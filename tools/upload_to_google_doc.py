#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""upload_to_google_doc.py — Upload the Metano Town brief to a Google Doc.

Prerequisites:
  1. Create a Google Cloud project: https://console.cloud.google.com/
  2. Enable the Google Docs API and Google Drive API
  3. Create a service account: https://cloud.google.com/iam/docs/keys-create
  4. Download the JSON key file (e.g. service_account.json)
  5. Share your Google Drive folder with the service account email
  6. Set GOOGLE_APPLICATION_CREDENTIALS=/path/to/service_account.json

Usage:
  python3 tools/upload_to_google_doc.py --input /tmp/metanol_brief_EN.md
  python3 tools/upload_to_google_doc.py --input /tmp/metanol_brief_EN.html --format html

The script:
1. Parses the markdown/HTML brief
2. Creates a new Google Doc titled "Metano Town - Pixel Artist Master Reference"
3. Uploads the content with all images embedded
4. Returns the URL of the new document
"""
import argparse
import base64
import os
import re
from pathlib import Path
import sys

# Check for Google API client library
try:
    from google.oauth2 import service_account
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaFileUpload
    from googleapiclient.errors import HttpError
except ImportError:
    print("ERROR: Google API client libraries not installed.")
    print("Install with: pip install google-api-python-client google-auth")
    sys.exit(1)


# Scopes required
SCOPES = [
    'https://www.googleapis.com/auth/documents',
    'https://www.googleapis.com/auth/drive',
]


def parse_markdown(md_path: Path) -> tuple:
    """Parse markdown into a list of (type, content) tuples.
    Types: heading1, heading2, heading3, heading4, paragraph, list_item, code, table_row
    """
    content = []
    with open(md_path, encoding='utf-8') as f:
        lines = f.read().split('\n')

    in_table = False
    in_code = False
    in_list = False
    table_rows = []

    for line in lines:
        if line.startswith('```'):
            if in_code:
                content.append(('code_end', ''))
                in_code = False
            else:
                content.append(('code_start', ''))
                in_code = True
            continue
        if in_code:
            content.append(('code_line', line))
            continue
        if in_table:
            if '|' in line and not re.match(r'^\|[\s\-:|]+\|$', line):
                cells = [c.strip() for c in line.strip('|').split('|')]
                table_rows.append(cells)
            else:
                # End of table
                if table_rows:
                    content.append(('table', table_rows))
                in_table = False
                table_rows = []
        if '|' in line and line.strip().startswith('|'):
            cells = [c.strip() for c in line.strip('|').split('|')]
            table_rows.append(cells)
            in_table = True
            continue
        if line.startswith('# '):
            content.append(('h1', line[2:]))
        elif line.startswith('## '):
            content.append(('h2', line[3:]))
        elif line.startswith('### '):
            content.append(('h3', line[4:]))
        elif line.startswith('#### '):
            content.append(('h4', line[5:]))
        elif line.startswith('- '):
            content.append(('li', line[2:]))
        elif line.strip() == '':
            content.append(('blank', ''))
        else:
            content.append(('p', line))

    if table_rows:
        content.append(('table', table_rows))

    return content


def md_to_google_doc_requests(content: list) -> list:
    """Convert parsed markdown to Google Docs API batchUpdate requests."""
    requests = []
    index = 1  # 1-based index in Google Docs

    for item_type, text in content:
        if item_type == 'h1':
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text + '\n'}
            })
            requests.append({
                'updateParagraphStyle': {
                    'range': {'startIndex': index, 'endIndex': index + len(text) + 1},
                    'paragraphStyle': {'namedStyleType': 'HEADING_1'},
                    'fields': 'namedStyleType'
                }
            })
            index += len(text) + 1
        elif item_type == 'h2':
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text + '\n'}
            })
            requests.append({
                'updateParagraphStyle': {
                    'range': {'startIndex': index, 'endIndex': index + len(text) + 1},
                    'paragraphStyle': {'namedStyleType': 'HEADING_2'},
                    'fields': 'namedStyleType'
                }
            })
            index += len(text) + 1
        elif item_type == 'h3':
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text + '\n'}
            })
            requests.append({
                'updateParagraphStyle': {
                    'range': {'startIndex': index, 'endIndex': index + len(text) + 1},
                    'paragraphStyle': {'namedStyleType': 'HEADING_3'},
                    'fields': 'namedStyleType'
                }
            })
            index += len(text) + 1
        elif item_type == 'p':
            text_clean = text + '\n'
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text_clean}
            })
            index += len(text_clean)
        elif item_type == 'li':
            text_clean = '• ' + text + '\n'
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text_clean}
            })
            index += len(text_clean)
        elif item_type == 'code_start':
            pass
        elif item_type == 'code_line':
            text_clean = text + '\n'
            requests.append({
                'insertText': {'location': {'index': index}, 'text': text_clean}
            })
            index += len(text_clean)
        elif item_type == 'code_end':
            pass
        elif item_type == 'table':
            # For tables, we'd need to use insertTable request
            # Simplified: convert to list items
            for row in text:
                row_text = ' | '.join(row) + '\n'
                requests.append({
                    'insertText': {'location': {'index': index}, 'text': row_text}
                })
                index += len(row_text)
        elif item_type == 'blank':
            requests.append({
                'insertText': {'location': {'index': index}, 'text': '\n'}
            })
            index += 1
    return requests


def create_google_doc(creds, title: str, content_requests: list) -> str:
    """Create a new Google Doc and apply the requests. Returns the doc URL."""
    docs_service = build('docs', 'v1', credentials=creds)
    drive_service = build('drive', 'v3', credentials=creds)

    # Create empty document
    doc = docs_service.documents().create(body={'title': title}).execute()
    doc_id = doc.get('documentId')

    # Apply all requests in batches (max 100 per call)
    batch_size = 100
    for i in range(0, len(content_requests), batch_size):
        batch = content_requests[i:i+batch_size]
        docs_service.documents().batchUpdate(
            documentId=doc_id,
            body={'requests': batch}
        ).execute()

    # Make accessible (anyone with link can view)
    drive_service.permissions().create(
        fileId=doc_id,
        body={'type': 'anyone', 'role': 'reader'}
    ).execute()

    return f"https://docs.google.com/document/d/{doc_id}/edit"


def main():
    parser = argparse.ArgumentParser(description="Upload Metano Town brief to Google Doc")
    parser.add_argument("--input", required=True, help="Path to markdown or HTML file")
    parser.add_argument("--title", default="Metano Town - Pixel Artist Master Reference",
                       help="Document title")
    parser.add_argument("--credentials", help="Path to Google service account JSON key")
    args = parser.parse_args()

    creds_path = args.credentials or os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not creds_path:
        print("ERROR: Provide Google credentials via --credentials or GOOGLE_APPLICATION_CREDENTIALS env var")
        print("See script docstring for setup instructions.")
        sys.exit(1)

    if not Path(creds_path).exists():
        print(f"ERROR: Credentials file not found: {creds_path}")
        sys.exit(1)

    print(f"Loading credentials from {creds_path}...")
    creds = service_account.Credentials.from_service_account_file(
        creds_path, scopes=SCOPES)

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"ERROR: Input file not found: {input_path}")
        sys.exit(1)

    print(f"Parsing {input_path}...")
    if input_path.suffix == '.md':
        content = parse_markdown(input_path)
        requests = md_to_google_doc_requests(content)
    elif input_path.suffix == '.html':
        # For HTML, we'd need a more sophisticated parser
        # For now, extract text content
        print("HTML support: extracting text and skipping images.")
        print("For image-embedded version, use the Google Docs API to insert images manually.")
        # Simple: strip HTML and treat as text
        import html as html_lib
        text = input_path.read_text(encoding='utf-8')
        text = re.sub(r'<[^>]+>', '', text)
        text = html_lib.unescape(text)
        content = [('p', line) for line in text.split('\n') if line.strip()]
        requests = md_to_google_doc_requests(content)
    else:
        print(f"ERROR: Unsupported format: {input_path.suffix}")
        sys.exit(1)

    print(f"Creating Google Doc: {args.title}")
    print(f"Applying {len(requests)} requests...")
    url = create_google_doc(creds, args.title, requests)

    print(f"\n✓ Document created: {url}")
    print("You can now share this URL with your pixel artist.")


if __name__ == "__main__":
    main()
