#!/usr/bin/env python3
"""Audit R5 GBA : kecleonShopChance ROM (FloorProperties offset 7, stream
main_data.inc chunké par 28) vs présence de ShopStep dans les 53 zones Red.

Verdicts : PASS (ROM 0 % et pas de shop / ROM >0 % et shop présent),
GAP_MISSING_SHOP (ROM >0 % sans shop), GAP_EXTRA_SHOP (shop sans chance ROM
— à justifier), SKIP_LOCKED. --fix ajoute les ShopStep manquants par plages
contiguës (technique LOT E), items = table KecleonShop ROM de l'étage
médian (dungeon_item_data.json, index floor_id.json), mappée via
CONVERSION/Item.txt + ITEM_OVERRIDES (convert_item de
build_canonical_definitions, importé — pas dupliqué).
"""
import json, re, os, sys, argparse, copy, importlib.util

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PRET = os.path.join(ROOT, '.runtime-cache/pmd-red-reference/data/dungeon')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

spec = importlib.util.spec_from_file_location(
    'bcd', os.path.join(ROOT, 'dev/tools/build_canonical_definitions.py'))
bcd = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bcd)

spec2 = importlib.util.spec_from_file_location(
    'ksky', os.path.join(ROOT, 'dev/tools/add_kecleon_shops_sky.py'))
ksky = importlib.util.module_from_spec(spec2)
spec2.loader.exec_module(ksky)

from add_monster_houses_from_rom import RED_Z2P  # mapping zone->pret complet

MGC = 'RogueEssence.LevelGen.MapGenContext, RogueEssence'


def parse_floorprops():
    stream = []

    def rec(path):
        for line in open(path):
            line = line.strip()
            m = re.match(r'#include\s+"([^"]+)"', line)
            if m:
                rec(os.path.join(PRET, m.group(1)))
            elif line.startswith('.byte'):
                stream.extend(int(x, 16) for x in re.findall(r'0x([0-9a-fA-F]{2})', line))
    rec(os.path.join(PRET, 'main_data.inc'))
    assert len(stream) % 28 == 0
    return [stream[i:i + 28] for i in range(0, len(stream), 28)]


def contiguous(vals):
    out, cur = [], None
    for i, v in enumerate(vals, 1):
        if v <= 0:
            if cur:
                out.append(cur)
                cur = None
            continue
        if cur and cur[2] == v and i == cur[1] + 1:
            cur = (cur[0], i, v)
        else:
            if cur:
                out.append(cur)
            cur = (i, i, v)
    if cur:
        out.append(cur)
    return out


def shop_items_gba(pret_dir, floor_mid, conversion, prices, skipped):
    fid = json.load(open(os.path.join(PRET, pret_dir, 'floor_id.json')))
    tables = fid['tables']
    idx = tables[min(floor_mid - 1, len(tables) - 1)].get('KecleonShop', 0)
    itemdata = json.load(open(os.path.join(PRET, 'dungeon_item_data.json')))
    table = itemdata[idx]
    entries = []
    for cat in table.get('categories', []):
        catp = cat.get('categoryProbability', 0)
        for it in cat.get('items', []):
            w = catp * it.get('itemProbability', 0) // 10000
            if w <= 0:
                continue
            pmdo = bcd.convert_item(it['item'], conversion, prices)
            if not pmdo:
                skipped[it['item']] = skipped.get(it['item'], 0) + w
                continue
            entries.append({'Spawn': {'IsMoney': False, 'Cursed': False, 'Value': pmdo,
                                      'HiddenValue': '', 'Amount': 0, 'Price': 0,
                                      'TileLoc': {'X': 0, 'Y': 0}},
                            'Rate': w})
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--fix', action='store_true')
    args = ap.parse_args()
    props = parse_floorprops()
    conversion = bcd.load_item_conversion()
    prices = bcd.known_items()

    report = {'rule': 'R5 GBA kecleonShopChance (FloorProps offset 7) vs ShopStep',
              'fix': args.fix, 'zones': [], 'items_skipped': {}}
    skipped = report['items_skipped']
    for zone, pret in sorted(RED_Z2P.items()):
        rel = f'Data/Zone/{zone}.json'
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        fid = json.load(open(os.path.join(PRET, pret, 'floor_id.json')))
        ks = [props[t['MainData']][7] for t in fid['tables']]
        rom_has = any(v > 0 for v in ks)
        raw = open(zpath, encoding='utf-8-sig').read()
        zone_has = 'ShopStep' in raw
        row = {'zone': zone, 'pret': pret, 'rom_chances': ks, 'zone_has_shop': zone_has}
        if rel in LOCKED_PATHS:
            row['verdict'] = 'SKIP_LOCKED'
        elif rom_has == zone_has:
            row['verdict'] = 'PASS'
        elif rom_has and not zone_has:
            row['verdict'] = 'GAP_MISSING_SHOP'
            if args.fix:
                z = json.loads(raw)
                seg = None
                for s in z['Object']['Segments']:
                    fls = s.get('Floors', [])
                    if isinstance(fls, list) and len(fls) == len(ks):
                        seg = s
                        break
                if seg is None:
                    row['verdict'] = 'SEGMENT_NON_ALIGNE'
                elif any(isinstance(f, dict) and 'LoadGen' in f.get('$type', '')
                         for f in seg.get('Floors', [])):
                    row['verdict'] = 'SKIP_LOADGEN_BOSS'
                else:
                    added = []
                    for lo, hi, chance in contiguous(ks):
                        items = shop_items_gba(pret, (lo + hi) // 2, conversion, prices, skipped)
                        if not items:
                            continue
                        zs = ksky.make_shop_zonestep(chance, lo - 1, hi, items)
                        seg.setdefault('ZoneSteps', []).append(zs)
                        added.append({'floors_rom': [lo, hi], 'chance': chance,
                                      'items': len(items)})
                    if added:
                        with open(zpath, 'w', encoding='utf-8-sig') as f:
                            json.dump(z, f, indent=2, ensure_ascii=False)
                        row['verdict'] = 'FIXED'
                        row['ranges'] = added
        else:
            row['verdict'] = 'EXTRA_SHOP_VS_ROM'
        report['zones'].append(row)

    out = os.path.join(ROOT, 'dev/docs/canonical/KECLEON_GBA_VS_ROM_AUDIT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    from collections import Counter
    c = Counter(r['verdict'] for r in report['zones'])
    print(dict(c))
    for r in report['zones']:
        if r['verdict'] not in ('PASS', 'SKIP_LOCKED'):
            print(' ', r['verdict'], r['zone'], r.get('ranges', ''))


if __name__ == '__main__':
    main()
