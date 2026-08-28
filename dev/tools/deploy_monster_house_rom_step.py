#!/usr/bin/env python3
"""Déploie NewEra.LevelGen.MonsterHouseRomStep (R4.4/R4.5 ROM-exact) sur
toutes les zones ROM : remplace PMDC MonsterHouseStep dans les
SpreadHouseZoneStep. MobCap : 30 (NDS) / 12 (GBA) — pret dungeon_config
l.22 et dungeon-eos l.64. AllowTraps : NDS dungeon_id>=28 ; GBA true
(pas de gate story équivalente dans Red). CH1-CH5 exclues."""
import json, gzip, glob, os, sys, argparse
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()
    reg = json.load(open(os.path.join(ROOT, 'dev/docs/canonical/CONTENT_REGISTRY.json')))['resources']
    prov = {k.split('/')[1]: v.get('provider') for k, v in reg.items() if k.startswith('Zone/')}
    cmp_zones = json.load(open(os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp for fp in glob.glob(os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/dungeons/*.json.gz'))}
    did = {}
    for z, info in cmp_zones.items():
        fp = dmap.get(info['dungeon'])
        if fp:
            did[z] = json.load(gzip.open(fp))['dungeon_id']
    rep = {'rule': 'MonsterHouseRomStep partout (mobs 70-80% salle cap ROM, items+pièges 50/50 cap 7)', 'zones': [], 'apply': args.apply}
    tot = 0
    for zone, provider in sorted(prov.items()):
        if provider not in ('ROM:NDS', 'ROM:GBA'):
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS or not os.path.exists(os.path.join(ROOT, rel)):
            continue
        raw = open(os.path.join(ROOT, rel), encoding='utf-8-sig').read()
        if 'MonsterHouseStep`1' not in raw:
            continue
        z = json.loads(raw)
        mobcap = 30 if provider == 'ROM:NDS' else 12
        allow = True if provider == 'ROM:GBA' else (did.get(zone, 99) >= 28)
        n = 0
        def walk(node):
            nonlocal n
            if isinstance(node, dict):
                t = node.get('$type', '')
                if t.startswith('PMDC.LevelGen.MonsterHouseStep`1'):
                    node['$type'] = t.replace('PMDC.LevelGen.MonsterHouseStep`1', 'NewEra.LevelGen.MonsterHouseRomStep`1').replace(', PMDC', ', NewEra.Engine')
                    node['MobCap'] = mobcap
                    node['ItemTrapCap'] = 7
                    node['AllowTraps'] = allow
                    node.setdefault('Traps', [])
                    n += 1
                for v in node.values():
                    walk(v)
            elif isinstance(node, list):
                for v in node:
                    walk(v)
        walk(z['Object'])
        if n:
            tot += n
            rep['zones'].append({'zone': zone, 'provider': provider, 'steps': n, 'mobcap': mobcap, 'traps': allow})
            if args.apply:
                with open(os.path.join(ROOT, rel), 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)
    json.dump(rep, open(os.path.join(ROOT, 'dev/docs/canonical/MONSTER_HOUSE_ROM_STEP_REPORT.json'), 'w'), indent=1, ensure_ascii=False)
    print(f"steps remplacés: {tot} / {len(rep['zones'])} zones, apply={args.apply}")

if __name__ == '__main__':
    main()
