#!/usr/bin/env python3
"""Conversion Blue NDS -> PMDO for Sinister Woods.

BLOCKED by default until audit SOURCE_FIDELITY gates pass.
Does not write gloomy_forest.json unless --force-unproven (forbidden for release).
"""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
AUDIT = REPO / 'docs' / 'sinister_woods_nds' / 'AUDIT_SOURCE_NDS.json'

REQUIRED_PASS = [
    'floor_id_table',
    'floor_properties',
]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--force-unproven', action='store_true',
                    help='DONOTUSE: bypass gates (will still refuse to touch gloomy_forest.json)')
    args = ap.parse_args()
    if not AUDIT.exists():
        print('FAIL: run tools/audit_blue_sinister.py first', file=sys.stderr)
        return 2
    rep = json.loads(AUDIT.read_text())
    print('Conversion gate check:')
    print('  floor_id_match_red:', rep['status'].get('floor_id_match_red'))
    print('  props_match_red:', rep['status'].get('floor_props_bytes_match_red'))
    print('  unknowns:', len(rep.get('unknowns', [])))
    print('  source_fidelity_port:', rep['status'].get('source_fidelity_port'))
    # Hard block: item/trap/music/geometry still UNKNOWN
    blockers = rep.get('unknowns', [])
    if blockers and not args.force_unproven:
        print('BLOCKED: remaining UNKNOWN items:')
        for u in blockers:
            print(' -', u)
        print('gloomy_forest.json left untouched.')
        return 1
    print('Refusing to write zone data: full generator mapping not implemented.')
    print('gloomy_forest.json left untouched.')
    return 1

if __name__ == '__main__':
    sys.exit(main())
