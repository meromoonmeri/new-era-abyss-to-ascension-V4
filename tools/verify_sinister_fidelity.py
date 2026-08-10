#!/usr/bin/env python3
"""Verify Sinister Woods fidelity.

A. SOURCE FIDELITY — Blue NDS audit completeness / concordance
B. PMDO VALIDATION — current New Era zone technical shape (not NDS proof)
"""
from __future__ import annotations
import json, sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
AUDIT = REPO / 'docs' / 'sinister_woods_nds' / 'AUDIT_SOURCE_NDS.json'
FLOORS = REPO / 'docs' / 'sinister_woods_nds' / 'floors_f1_f13.json'
ZONE = REPO / 'Data' / 'Zone' / 'gloomy_forest.json'

def main():
    results = {'A_SOURCE_FIDELITY': {}, 'B_PMDO_VALIDATION': {}}
    if not AUDIT.exists():
        results['A_SOURCE_FIDELITY']['audit_present'] = 'FAIL'
        print(json.dumps(results, indent=2)); return 1
    rep = json.loads(AUDIT.read_text())
    floors = json.loads(FLOORS.read_text()) if FLOORS.exists() else []

    A = results['A_SOURCE_FIDELITY']
    A['rom_present'] = 'PASS' if rep.get('rom', {}).get('gamecode') == 'APHP' else 'FAIL'
    A['floor_count_13'] = 'PASS' if len(floors) == 13 else 'FAIL'
    A['floor_id_table'] = 'PASS' if rep['status'].get('floor_id_match_red') else 'FAIL'
    A['floor_properties_bytes'] = 'PASS' if rep['status'].get('floor_props_bytes_match_red') else 'FAIL'
    A['tileset_id_present'] = 'PASS' if all(f.get('tileset_id') is not None for f in floors) else 'FAIL'
    A['monster_spawns_extracted'] = 'PASS' if all(f.get('pokemon_spawns') for f in floors) else 'FAIL'
    A['item_tables'] = 'UNKNOWN'
    A['trap_tables'] = 'UNKNOWN'
    A['music_seq'] = 'UNKNOWN'
    A['geometry_generator_full'] = 'UNKNOWN'
    A['b41_graphics_decoded'] = (
        'PASS' if rep.get('graphics_b41', {}).get('fon', {}).get('status') == 'SOURCE_NDS_DECODED'
        else 'FAIL')
    # Overall A
    vals = list(A.values())
    if any(v == 'FAIL' for v in vals):
        A['OVERALL'] = 'FAIL'
    elif any(v == 'UNKNOWN' for v in vals):
        A['OVERALL'] = 'UNKNOWN'
    else:
        A['OVERALL'] = 'PASS'

    B = results['B_PMDO_VALIDATION']
    if ZONE.exists():
        z = json.loads(ZONE.read_text(encoding='utf-8-sig'))['Object']
        B['zone_json_parses'] = 'PASS'
        B['has_segments'] = 'PASS' if z.get('Segments') else 'FAIL'
        B['public_name'] = z.get('Name', {}).get('DefaultText')
        B['nds_equivalence'] = 'UNKNOWN'  # must not claim NDS fidelity from PMDO alone
        B['note'] = 'PMDO validity ≠ NDS fidelity'
    else:
        B['zone_json_parses'] = 'FAIL'
    B['OVERALL'] = 'PASS' if B.get('zone_json_parses') == 'PASS' and B.get('has_segments') == 'PASS' else 'FAIL'

    print(json.dumps(results, indent=2))
    # Exit 0 only if A is PASS (strict source fidelity). UNKNOWN => exit 2
    if A['OVERALL'] == 'PASS' and B['OVERALL'] == 'PASS':
        return 0
    if A['OVERALL'] == 'UNKNOWN':
        return 2
    return 1

if __name__ == '__main__':
    sys.exit(main())
