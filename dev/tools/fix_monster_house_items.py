#!/usr/bin/env python3
"""LOT F' — Items des Monster Houses canoniques (règle R4.5, volet items).

ROM NDS (dungeon-eos l.3175-3218) : items+pièges d'une MH non vide =
max(6, randrange(50%..80% des tuiles)) plafonné à MH_NORMAL_SPAWN_ITEM=7 ;
tirés dans la table dédiée items['monster_house'] de l'étage (mappa_s,
poids /10000 cumulés). (Le volet pièges 50/50 reste PARTIAL : le
MonsterHouseStep PMDO ne pose pas de pièges — documenté.)

Implémentation native :
  SpreadHouseZoneStep.Items  = table monster_house ROM mappée (étage médian
                               de la plage SpreadPlan, poids décumulés)
  ItemThemeNone.SpecialRatio = 100  (les items MH viennent EXCLUSIVEMENT
                               de la table MH, comme la ROM)
  ItemThemeNone.Amount       = {Min 6, Max 7}  (loi ROM min 6 / cap 7)

Zones : Sky mappées uniquement (les tables monster_house GBA suivront le
même outil quand les tables Red seront alignées). CH1-CH5 exclues.
Idempotent via marqueur Amount 6-7 + SpecialRatio 100 déjà posés.
"""
import json, gzip, glob, os, sys, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS


def load_item_map():
    m = json.load(open(os.path.join(TAB, 'PMDO_MAPPING.json')))['items']['entries']
    out = {}
    for name, e in m.items():
        if e.get('status') in ('EXACT', 'RENAMED', 'TM') and e.get('pmdo_item'):
            out[e['sky_item_id']] = e['pmdo_item']
    return out


def mh_items_for(rom, floor_1based, item_map, skipped):
    fl = None
    for f in rom['floors']:
        if f['floor'] == floor_1based:
            fl = f
            break
    if fl is None:
        fl = rom['floors'][0]
    table = fl.get('items', {}).get('monster_house', {}).get('items', [])
    entries = []
    prev = 0
    for it in table:
        w = it['weight'] - prev
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
            # SpawnRangeList exige Range.Length >= 1 (RogueElements
            # SpawnRangeList.Add l.49) — la plage est posée par l'appelant.
        })
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}
    item_map = load_item_map()

    report = {'rule': "R4.5 items MH : table monster_house mappa_s (SpecialRatio 100) + Amount 6-7 (min 6/cap 7 ROM)",
              'apply': args.apply, 'zones': [], 'items_skipped_requires_mod': {}}
    skipped = report['items_skipped_requires_mod']
    tot = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        raw = open(zpath, encoding='utf-8-sig').read()
        if 'SpreadHouseZoneStep' not in raw:
            continue
        rom = json.load(gzip.open(fp))
        z = json.loads(raw)
        changed = 0
        for seg in z['Object']['Segments']:
            for zs in seg.get('ZoneSteps', []):
                if 'SpreadHouseZoneStep' not in zs.get('$type', ''):
                    continue
                plan = zs.get('SpreadPlan', {})
                fr = plan.get('FloorRange', {'Min': 0, 'Max': len(rom['floors'])})
                mid = max(1, min(len(rom['floors']), (fr.get('Min', 0) + fr.get('Max', 1)) // 2 + 1))
                items = mh_items_for(rom, mid, item_map, skipped)
                if not items:
                    continue
                already = (json.dumps(zs.get('ItemThemes', [])).find('"SpecialRatio": 100') >= 0
                           and zs.get('Items'))
                if already:
                    continue
                fr2 = plan.get('FloorRange', {'Min': 0, 'Max': len(rom['floors'])})
                span = {'Min': fr2.get('Min', 0),
                        'Max': max(fr2.get('Max', 1), fr2.get('Min', 0) + 1)}
                for e in items:
                    e['Range'] = dict(span)
                zs['Items'] = items
                for th in zs.get('ItemThemes', []):
                    sp = th.get('Spawn', th)
                    if 'ItemTheme' in sp.get('$type', ''):
                        sp['SpecialRatio'] = 100
                        if isinstance(sp.get('Amount'), dict):
                            sp['Amount'] = {'Min': 6, 'Max': 7}
                changed += 1
        if changed:
            tot += changed
            report['zones'].append({'zone': zone, 'dungeon': info['dungeon'],
                                    'housesteps': changed})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/MONSTER_HOUSE_ITEMS_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    print(f"SpreadHouse mis à la table MH ROM: {tot} steps / {len(report['zones'])} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
