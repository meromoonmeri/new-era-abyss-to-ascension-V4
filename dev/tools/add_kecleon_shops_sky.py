#!/usr/bin/env python3
"""LOT E — Kecleon shops Sky (règle R5).

ROM : mappa_s.bin layout.kecleon_shop_chance (% PAR ÉTAGE, ex. apple_woods
8,8,9,9,...,10) + items['shop'] (table pondérée /10000 par étage).
65 zones Sky mappées ont kecleon>0 en ROM et AUCUN ShopStep aujourd'hui.

Implémentation native : SpreadStepRangeZoneStep -> ShopStep<MapGenContext>
(modèle EXACT de buried_relic, port GBA du projet validé journeys) avec :
  - SpreadPlanChance par plages contiguës de même % (même technique que
    MONSTER_HOUSE_CHANCE_FIX, preuve destiny_tower 11 plages) ;
  - Items = table shop ROM de l'étage médian de la plage, mappée via
    PMDO_MAPPING.json (EXACT/RENAMED/TM uniquement ; REQUIRES_MOD_ITEM
    exclus et comptés dans le rapport, cohérent ZONE_FIX_REPORT) ;
  - Price=0 (le runtime PMDO price les marchandises via la valeur d'item) ;
  - Mob Kecleon niveau = médiane des niveaux d'ennemis du donjon (borné
    ROM : le Kecleon EoS est très au-dessus du niveau local ; PMDO vanilla
    utilise 55 partout -> on garde 55, convention moteur, documenté) ;
  - SecurityStatus 'shop_security' (mécanique voleur native).

Garde-fous : R5 exclusivité MH est gérée par le moteur (ShopStep filtre) ;
zones verrouillées exclues ; idempotent (saute si ShopStep déjà présent).
"""
import json, gzip, glob, os, sys, argparse, copy

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

MGC = 'RogueEssence.LevelGen.MapGenContext, RogueEssence'


def load_item_map():
    m = json.load(open(os.path.join(TAB, 'PMDO_MAPPING.json')))['items']['entries']
    out = {}
    for name, e in m.items():
        if e.get('status') in ('EXACT', 'RENAMED', 'TM') and e.get('pmdo_item'):
            out[e['sky_item_id']] = e['pmdo_item']
    return out


def shop_items_for(rom, lo, hi, item_map, skipped):
    """Table du shop de l'étage médian de la plage [lo,hi] (1-based ROM)."""
    mid = (lo + hi) // 2
    fl = None
    for f in rom['floors']:
        if f['floor'] == mid:
            fl = f
            break
    if fl is None:
        fl = rom['floors'][0]
    entries = []
    prev = 0
    for it in fl['items']['shop']['items']:
        w = it['weight'] - prev  # weights ROM cumulatifs
        prev = it['weight']
        if w <= 0:
            continue
        pmdo = item_map.get(it['item_id'])
        if not pmdo:
            skipped[it['en']] = skipped.get(it['en'], 0) + w
            continue
        entries.append({
            'Spawn': {'IsMoney': False, 'Cursed': False, 'Value': pmdo,
                      'HiddenValue': '', 'Amount': 0, 'Price': 0,
                      'TileLoc': {'X': 0, 'Y': 0}},
            'Rate': w,
        })
    return entries


_KECLEON_CACHE = None


def kecleon_spawn():
    """MobSpawn Kecleon EXACT du ShopStep de buried_relic (port GBA validé
    journeys) : shopkeeper, color_change, MobSpawnBoost 256, lv 55."""
    global _KECLEON_CACHE
    if _KECLEON_CACHE is None:
        src = json.load(open(os.path.join(ROOT, 'Data/Zone/buried_relic.json'),
                             encoding='utf-8-sig'))
        def find(node):
            if isinstance(node, dict):
                if 'ShopStep' in node.get('$type', '') and node.get('StartMob'):
                    return node['StartMob']
                for v in node.values():
                    r = find(v)
                    if r is not None:
                        return r
            elif isinstance(node, list):
                for v in node:
                    r = find(v)
                    if r is not None:
                        return r
            return None
        _KECLEON_CACHE = find(src['Object'])
        assert _KECLEON_CACHE and _KECLEON_CACHE['BaseForm']['Species'] == 'kecleon'
    return copy.deepcopy(_KECLEON_CACHE)


def kecleon_mob():
    return {'Spawn': kecleon_spawn(), 'Rate': 10}


def make_shop_zonestep(chance, lo0, hi0, items):
    """ZoneStep complet (indices 0-based, FloorRange Max exclusif)."""
    return {
        '$type': 'RogueEssence.LevelGen.SpreadStepRangeZoneStep, RogueEssence',
        'StepPriority': {'str': [4, 2]},
        'Spawns': [{
            'Spawn': {
                '$type': f'PMDC.LevelGen.ShopStep`1[[{MGC}]], PMDC',
                'Items': items,
                'ItemThemes': [],
                'Mobs': [kecleon_mob()],
                'StartMob': kecleon_spawn(),
                'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
                'SecurityStatus': 'shop_security',
                'Personality': 0,
            },
            'Rate': 10,
            'Range': {'Min': lo0, 'Max': hi0},
        }],
        'SpreadPlan': {
            '$type': 'RogueEssence.LevelGen.SpreadPlanChance, RogueEssence',
            'Chance': chance,
            'FloorRange': {'Min': lo0, 'Max': hi0},
        },
        'ModStates': [],
    }


def contiguous_ranges(vals):
    """[(floor,val)...] -> [(lo,hi,val)] par plages contiguës de même val>0."""
    out = []
    cur = None
    for fnum, v in vals:
        if v <= 0:
            if cur:
                out.append(cur)
                cur = None
            continue
        if cur and cur[2] == v and fnum == cur[1] + 1:
            cur = (cur[0], fnum, v)
        else:
            if cur:
                out.append(cur)
            cur = (fnum, fnum, v)
    if cur:
        out.append(cur)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}
    item_map = load_item_map()

    report = {'rule': 'R5 kecleon_shop_chance mappa_s -> ShopStep natif par plages',
              'apply': args.apply, 'zones': [], 'items_skipped_requires_mod': {}}
    skipped = report['items_skipped_requires_mod']
    tot = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        vals = [(f['floor'], f['layout']['kecleon_shop_chance']) for f in rom['floors']]
        ranges = contiguous_ranges(vals)
        if not ranges:
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        raw = open(zpath, encoding='utf-8-sig').read()
        if 'ShopStep' in raw:
            report['zones'].append({'zone': zone, 'status': 'DEJA_EQUIPPE'})
            continue
        z = json.loads(raw)
        # segment aligné = même nb d'étages que ROM
        seg = None
        for s in z['Object']['Segments']:
            fls = s.get('Floors', [])
            if isinstance(fls, list) and len(fls) == len(rom['floors']):
                seg = s
                break
        if seg is None:
            report['zones'].append({'zone': zone, 'status': 'SEGMENT_NON_ALIGNE'})
            continue
        # GARDE-FOU : ne jamais toucher un segment contenant des étages
        # LoadGen (arènes boss rsmap fixes : amp_clearing, crystal_lake...)
        if any(isinstance(f, dict) and 'LoadGen' in f.get('$type', '')
               for f in (seg.get('Floors', []) if isinstance(seg.get('Floors', []), list) else [])):
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOADGEN_BOSS'})
            continue
        added = []
        for lo, hi, chance in ranges:
            items = shop_items_for(rom, lo, hi, item_map, skipped)
            if not items:
                continue
            zs = make_shop_zonestep(chance, lo - 1, hi, items)
            seg.setdefault('ZoneSteps', []).append(zs)
            added.append({'floors_rom': [lo, hi], 'chance': chance, 'items': len(items)})
        if added:
            tot += len(added)
            report['zones'].append({'zone': zone, 'dungeon': info['dungeon'], 'ranges': added})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/KECLEON_SHOP_SKY_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('ranges')])
    print(f"ShopStep ajoutés: {tot} plages dans {nz} zones, apply={args.apply}")
    print(f"items REQUIRES_MOD exclus (espèces): {len(skipped)}")


if __name__ == '__main__':
    main()
