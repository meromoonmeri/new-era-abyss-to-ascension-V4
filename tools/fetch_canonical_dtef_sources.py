#!/usr/bin/env python3
"""Mirror the RawAsset DTEF source folders referenced by the complete bundle.

The files remain unmodified DTEF source images.  They are not converted here:
PMDO's native ``Import DTEF`` flow is the only importer used for runtime
material.  A hash manifest is written beside each source folder.

Usage:
    python3 tools/fetch_canonical_dtef_sources.py --write
    python3 tools/fetch_canonical_dtef_sources.py --check
"""
from __future__ import annotations

import argparse
import base64
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "docs/canonical_dungeons/complete_bundle_registry.json"
DEST = ROOT / "Content/TileDtef/canonical"


def gh_json(endpoint: str):
    return json.loads(subprocess.check_output(["gh", "api", endpoint], text=True))


def folders() -> list[str]:
    data = json.loads(REGISTRY.read_text())
    return sorted({row["dtef"]["rawasset_folder"] for row in data["main_route"] + data["pmd_red_roster"] if "dtef" in row})


def write_folder(folder: str) -> int:
    rows = gh_json(f"repos/PMDCollab/RawAsset/contents/TileDtef/{folder}?ref=master")
    target = DEST / folder
    target.mkdir(parents=True, exist_ok=True)
    manifest = []
    for row in rows:
        if row.get("type") != "file":
            continue
        content = gh_json(f"repos/PMDCollab/RawAsset/contents/{row['path']}?ref=master")["content"]
        payload = base64.b64decode(content)
        (target / row["name"]).write_bytes(payload)
        manifest.append({"name": row["name"], "bytes": len(payload), "sha256": hashlib.sha256(payload).hexdigest(), "git_blob_sha": row["sha"], "source": row["download_url"]})
    (target / "RAWASSET_PROVENANCE.json").write_text(json.dumps({"schema": "new-era.rawasset-dtef-source.v1", "repository": "https://github.com/PMDCollab/RawAsset", "path": f"TileDtef/{folder}", "ref": "master", "format": "XML-less DTEF", "files": manifest}, ensure_ascii=False, indent=2) + "\n")
    return sum(row["bytes"] for row in manifest)


def check_folder(folder: str) -> list[str]:
    errors: list[str] = []
    manifest_path = DEST / folder / "RAWASSET_PROVENANCE.json"
    if not manifest_path.is_file():
        return [f"missing manifest {folder}"]
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("path") != f"TileDtef/{folder}":
        errors.append(f"wrong source path {folder}")
    for row in manifest.get("files", []):
        path = DEST / folder / row["name"]
        if not path.is_file():
            errors.append(f"missing {folder}/{row['name']}")
        elif hashlib.sha256(path.read_bytes()).hexdigest() != row["sha256"]:
            errors.append(f"hash mismatch {folder}/{row['name']}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if not (args.write or args.check):
        parser.error("choose --write and/or --check")
    items = folders()
    if args.write:
        total = 0
        for index, folder in enumerate(items, 1):
            # TreeshroudForest1 is already mirrored under the dedicated Ch6
            # path.  Keep a canonical copy as well so every registry binding
            # resolves in one directory tree.
            total += write_folder(folder)
            print(f"[{index}/{len(items)}] {folder}")
        print(f"mirrored {len(items)} DTEF folders ({total} bytes)")
    if args.check:
        errors = [error for folder in items for error in check_folder(folder)]
        if errors:
            print("DTEF mirror failed:", *[" - " + error for error in errors], sep="\n", file=sys.stderr)
            return 1
        print(f"DTEF mirror: OK ({len(items)} folders)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
