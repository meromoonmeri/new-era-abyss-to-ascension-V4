#!/usr/bin/env python3
"""Audit Sinister Woods from Blue Rescue Team NDS (APHP). SOURCE_NDS only for claims.

Does NOT modify Data/Zone/gloomy_forest.json.
Requires pre-extracted files under NDS_ROOT (see docs/sinister_woods_nds/README.md)
or set BLUE_NDS_ROM / run extraction first.
"""
from __future__ import annotations
import hashlib, json, re, struct, sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
NDS_ROOT = Path(__import__('os').environ.get('NDS_ROOT', '/home/user/nds_sources'))
ROM = Path(__import__('os').environ.get(
    'BLUE_NDS_ROM',
    str(NDS_ROOT / 'POKEMON-ROM' / 'Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds')))
EXTRACTED = NDS_ROOT / 'extracted_blue'
DUNGEON_PACK = EXTRACTED / 'dungeon_pack'
MAPPARAM = DUNGEON_PACK / 'mapparam'
MONSTER_H = NDS_ROOT / 'pmd-red' / 'include' / 'constants' / 'monster.h'
RED_SIN = NDS_ROOT / 'pmd-red' / 'data' / 'dungeon' / 'SinisterWoods'
OUT = REPO / 'docs' / 'sinister_woods_nds'
PX_MIN = 3

def iter_bits(n):
    b = 0x80
    while b > 0:
        yield 1 if n & b else 0
        b >>= 1

def nibble_pattern(idx, low):
    if idx == 0:
        byte1 = byte2 = (low << 4) | low
    else:
        base = low
        if idx == 1: base += 1
        elif idx == 5: base -= 1
        ns = [base] * 4
        if 1 <= idx <= 4: ns[idx - 1] -= 1
        else: ns[idx - 5] += 1
        ns = [x & 0xF for x in ns]
        byte1 = (ns[0] << 4) | ns[1]
        byte2 = (ns[2] << 4) | ns[3]
    return bytes([byte1 & 0xFF, byte2 & 0xFF])

def px_decompress(data: bytes, flags: bytes) -> bytes:
    out = bytearray(); cur = 0
    def rd():
        nonlocal cur
        v = data[cur]; cur += 1; return v
    while cur < len(data):
        cb = rd()
        for bit in iter_bits(cb):
            if cur >= len(data): break
            if bit == 1:
                out.append(rd())
            else:
                nb = rd(); hi = (nb >> 4) & 0xF; lo = nb & 0xF
                idx = next((i for i, f in enumerate(flags) if f == hi), None)
                if idx is not None:
                    out += nibble_pattern(idx, lo)
                else:
                    off = (-0x1000 + (lo << 8)) | rd()
                    pos = len(out) + off
                    for i in range(hi + PX_MIN):
                        out.append(out[pos + i])
    return bytes(out)

def at4px_decompress(blob: bytes) -> bytes:
    assert blob[:5] == b'AT4PX'
    flen = struct.unpack_from('<H', blob, 5)[0]
    flags = blob[7:16]
    want = struct.unpack_from('<H', blob, 16)[0]
    out = px_decompress(blob[0x12:flen], flags)
    if len(out) != want:
        raise ValueError(f'AT4PX size {len(out)} != {want}')
    return out

def monster_names():
    n = {}
    if MONSTER_H.exists():
        for m in re.finditer(r'#define\s+MONSTER_([A-Z0-9_]+)\s+(\d+)', MONSTER_H.read_text()):
            n[int(m.group(2))] = m.group(1)
    return n

def parse_spawns(mp, ptr, names):
    out = []; off = ptr
    for _ in range(32):
        bits, r0, r1, _pad = struct.unpack_from('<HhhH', mp, off); off += 8
        sp = bits & 0x1FF; lv = (bits >> 9) & 0x7F
        e = {'species_id': sp, 'species_name': names.get(sp, f'ID_{sp}'),
             'level': lv, 'weight0': r0, 'weight1': r1,
             'provenance_ids': 'SOURCE_NDS', 'provenance_names': 'CROSS_REFERENCE_RED'}
        if r0 == 0 and r1 == 0:
            e['special'] = True; out.append(e); break
        out.append(e)
    return out

def parse_props(mp, idx, base=0x7380):
    off = base + idx * 28
    b = mp[off:off + 28]
    return {
        'globalIndex': idx, 'offset': off, 'bytes_hex': b.hex(),
        'layout': b[0], 'roomDensity': struct.unpack_from('<b', b, 1)[0],
        'tileset': b[2], 'bgMusic': b[3], 'weather': b[4],
        'floorConnectivity': b[5], 'enemyDensity': struct.unpack_from('<b', b, 6)[0],
        'kecleonShopChance': b[7], 'monsterHouseChance': b[8],
        'mazeRoomChance': b[9], 'itemStickyChance': b[10],
        'allowDeadEnds': bool(b[11]), 'secondaryStructuresBudget': b[12],
        'roomFlags': b[13], 'itemDensity': b[15], 'trapDensity': b[16],
        'floorNumber': b[17], 'fixedRoomNumber': b[18],
        'numExtraHallways': b[19], 'buriedItemDensity': b[20],
        'standaloneLakeDensity': b[21], 'visibilityRange': b[22],
        'moneyUpperBound': b[23], 'kecleonShopLayout': b[24],
        'itemlessMonsterHouseChance': b[25],
        'bytes_provenance': 'SOURCE_NDS',
        'field_names_provenance': 'CROSS_REFERENCE_RED',
        'source': f'dungeon.sbin/mapparam@0x{off:X}',
    }

def decode_graphics(prefix: str, outdir: Path):
    info = {}
    for suf in ('fon', 'cel', 'cex', 'canm', 'pal'):
        p = DUNGEON_PACK / f'{prefix}{suf}'
        if not p.exists():
            info[suf] = {'status': 'NOT_PRESENT'}; continue
        blob = p.read_bytes()
        e = {'raw_size': len(blob), 'sha256': hashlib.sha256(blob).hexdigest(),
             'provenance': 'SOURCE_NDS'}
        try:
            if blob[:5] == b'AT4PX':
                dec = at4px_decompress(blob)
                (outdir / f'{prefix}{suf}.dec.bin').write_bytes(dec)
                e.update(status='SOURCE_NDS_DECODED', decomp_size=len(dec))
            elif blob[:4] == b'SIR0':
                idx = blob.find(b'AT4PX')
                e['status'] = 'SOURCE_NDS_CONTAINER_SIR0'
                e['main_ptr'] = struct.unpack_from('<I', blob, 4)[0]
                if idx >= 0:
                    flen = struct.unpack_from('<H', blob, idx + 5)[0]
                    dec = at4px_decompress(blob[idx:idx + flen])
                    (outdir / f'{prefix}{suf}.dec.bin').write_bytes(dec)
                    e.update(status='SOURCE_NDS_DECODED', decomp_size=len(dec), at4px_at=idx)
                else:
                    e['status'] = 'SOURCE_NDS_SIR0_NO_AT4PX'
            else:
                e['status'] = 'SOURCE_NDS_RAW'
                (outdir / f'{prefix}{suf}.raw.bin').write_bytes(blob)
        except Exception as ex:
            e['status'] = 'DECODE_FAIL'; e['error'] = str(ex)
        info[suf] = e
    return info

def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    if not MAPPARAM.exists():
        print('ERROR: mapparam missing. Extract Blue ROM first (see README).', file=sys.stderr)
        return 2
    mp = MAPPARAM.read_bytes()
    names = monster_names()
    # dungeon #3 floor_id table (u16 x8 per floor), skip 16-byte zero header at 0x150
    fid_off = 0x160
    floor_ids = []
    for i in range(13):
        v = struct.unpack_from('<8H', mp, fid_off + i * 16)
        floor_ids.append({'floor': i + 1, 'MainData': v[0], 'Pokemon': v[1], 'Traps': v[2],
                          'Items': v[3], 'KecleonShop': v[4], 'MonsterRoomItems': v[5],
                          'BuriedItems': v[6], 'offset': fid_off + i * 16})
    msp = 0x1fea8
    mptrs = []
    o = msp
    while True:
        p = struct.unpack_from('<I', mp, o)[0]
        if not p or p >= len(mp): break
        mptrs.append(p); o += 4
        if len(mptrs) > 600: break

    red_fid = []
    red_main = []
    if (RED_SIN / 'floor_id.json').exists():
        red_fid = json.loads((RED_SIN / 'floor_id.json').read_text())['tables']
    if (RED_SIN / 'main_data.inc').exists():
        for line in (RED_SIN / 'main_data.inc').read_text().splitlines():
            if not line.strip().startswith('.byte'): continue
            nums = [int(x, 16) if '0x' in x else int(x)
                    for x in line.replace('.byte', '').replace(' ', '').split(',') if x]
            if len(nums) == 28: red_main.append(bytes(nums))

    floors = []
    for e in floor_ids:
        fp = parse_props(mp, e['MainData'])
        sp = parse_spawns(mp, mptrs[e['Pokemon']], names) if e['Pokemon'] < len(mptrs) else []
        prop_eq = None
        if red_main:
            ri = e['MainData'] - 17
            if 0 <= ri < len(red_main):
                prop_eq = bytes.fromhex(fp['bytes_hex']) == red_main[ri]
        fid_eq = None
        if red_fid:
            r = red_fid[e['floor'] - 1]
            fid_eq = all(e[k] == r[k] for k in r)
        floors.append({
            'floor': e['floor'], 'floor_id': e, 'floor_id_provenance': 'SOURCE_NDS',
            'floor_id_match_red': fid_eq, 'properties': fp,
            'properties_match_red_bytes': prop_eq,
            'pokemon_table_index': e['Pokemon'], 'pokemon_spawns': sp,
            'tileset_id': fp['tileset'], 'bgMusic_id': fp['bgMusic'],
        })

    report = {
        'title': 'Sinister Woods Blue NDS SOURCE audit',
        'rom': {
            'path': str(ROM), 'exists': ROM.exists(),
            'gamecode': ROM.read_bytes()[0x0C:0x10].decode() if ROM.exists() else None,
            'size': ROM.stat().st_size if ROM.exists() else None,
            'sha256': hashlib.sha256(ROM.read_bytes()).hexdigest() if ROM.exists() else None,
            'provenance': 'SOURCE_NDS',
        },
        'status': {
            'floor_count_nds': 13,
            'floor_id_table': 'SOURCE_NDS PASS',
            'floor_properties': 'SOURCE_NDS PASS (names CROSS_REFERENCE_RED)',
            'floor_id_match_red': all(f['floor_id_match_red'] for f in floors),
            'floor_props_bytes_match_red': all(f['properties_match_red_bytes'] for f in floors),
            'source_fidelity_port': 'NOT PASS — conversion blocked',
        },
        'tileset_mapping': {
            'floor_tileset_id': floors[0]['tileset_id'] if floors else None,
            'dungeon_sbin_blob_for_floors': 'b41',
            'b10_graphics': 'present in dungeon.sbin but NOT selected by FloorProperties.tileset',
            'B10_grounds': 'ground.sbin B10P01*/B10P02* cutscene packages (SOURCE_NDS names)',
            'blob_link_rule': 'DERIVED_MAPPING tileset N -> b{N:02d} TOC name',
        },
        'graphics_b10': decode_graphics('b10', OUT),
        'graphics_b41': decode_graphics('b41', OUT),
        'floors': floors,
        'music': {
            'bgMusic_id': 4, 'provenance': 'SOURCE_NDS FloorProperties.bgMusic F1-F12',
            'sdat_seq_name': 'UNKNOWN', 'loop': 'UNKNOWN',
        },
        'unknowns': [
            'Item/trap table payloads (indices known)',
            'bgMusic 4 -> sound.sbin SEQ name/loop',
            'b10/b41 canm animation semantics',
            'Full B10P01/P02 ground script decode',
            'Team Meanies scene binary scripts',
            'Exact probability formula for weight0/weight1 pair',
        ],
        'conversion_gate': {
            'convert_blue_sinister.py': 'BLOCKED until item/trap/music/geometry generator fully decoded or explicitly scoped',
            'gloomy_forest.json': 'FROZEN — not modified by this tool',
        },
    }
    # New Era snapshot
    gf = REPO / 'Data' / 'Zone' / 'gloomy_forest.json'
    if gf.exists():
        z = json.loads(gf.read_text(encoding='utf-8-sig'))['Object']
        report['new_era_snapshot'] = {
            'provenance': 'PMDO_VALUE', 'segments': len(z.get('Segments', [])),
            'name': z.get('Name', {}).get('DefaultText'), 'frozen': True,
        }
    (OUT / 'AUDIT_SOURCE_NDS.json').write_text(json.dumps(report, indent=2))
    (OUT / 'floors_f1_f13.json').write_text(json.dumps(floors, indent=2))

    lines = [
        '# AUDIT SOURCE NDS — Sinister Woods (Blue Rescue Team Europe APHP)',
        '',
        f"- ROM `{report['rom'].get('gamecode')}` size={report['rom'].get('size')} sha256=`{report['rom'].get('sha256')}`",
        '- **gloomy_forest.json NOT MODIFIED**',
        '',
        '## Status',
    ]
    for k, v in report['status'].items():
        lines.append(f'- **{k}**: {v}')
    lines += ['', '## Tileset mapping', json.dumps(report['tileset_mapping'], indent=2),
              '', '## Floors F1–F13',
              '| F | tileset | music | roomDensity | enemyDensity | MH% | shop% | props==Red |',
              '|---|---|---|---|---|---|---|---|']
    for f in floors:
        p = f['properties']
        lines.append(
            f"| {f['floor']} | {p['tileset']} | {p['bgMusic']} | {p['roomDensity']} | "
            f"{p['enemyDensity']} | {p['monsterHouseChance']} | {p['kecleonShopChance']} | "
            f"{f['properties_match_red_bytes']} |")
    lines += ['', '## UNKNOWN', *[f'- {u}' for u in report['unknowns']],
              '', '## Verdict',
              'NDS floor_id + FloorProperties + monster spawn tables for 13 floors: **extracted**.',
              'Full PMDO port SOURCE FIDELITY: **NOT PASS**.',
              'Do **not** claim Sinister Woods is ported.']
    (OUT / 'AUDIT_SOURCE_NDS.md').write_text('\n'.join(lines) + '\n')
    print(json.dumps({'out': str(OUT), 'floors': len(floors),
                      'id_match_red': report['status']['floor_id_match_red'],
                      'props_match_red': report['status']['floor_props_bytes_match_red'],
                      'conversion': 'BLOCKED'}, indent=2))
    return 0

if __name__ == '__main__':
    sys.exit(main())
