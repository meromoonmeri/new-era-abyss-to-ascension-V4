#!/usr/bin/env python3
"""LOT D — Sticky items Sky (règle R12).

ROM : mappa_s.bin layout.sticky_item_chance (% par étage ; 178/180 donjons
ont UNE valeur constante — vérifié : distribution {0:888, 3:30, 5:565,
7:88, 8:224} étages). Sémantique EoS : chaque item posé au sol a S% de
chance d'être collant (sticky). Équivalent PMDO natif : InvItem.Cursed.

Transformation data (préserve exactement la distribution d'espèces
d'items) : pour chaque entrée de SpawnRangeList des ItemSpawnZoneStep,
  rate_cursed = rate * S // 100   (arrondi bas, jamais >0 si S=0)
  rate_normal = rate - rate_cursed
et on ajoute l'entrée dupliquée Cursed=true. Somme des rates inchangée.

Zones : ROM:NDS uniquement (CONTENT_REGISTRY), jamais les CH1-CH5
verrouillées, jamais les items à Price>0 (marchandise de shop) ni les
money spawns. Idempotent : saute les zones contenant déjà des entrées
Cursed=true issues de ce script (marqueur dans le rapport).
"""
import json, gzip, glob, os, sys, argparse, copy

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS


def sticky_of(rom):
    vals = sorted(set(f['layout']['sticky_item_chance'] for f in rom['floors']))
    if len(vals) == 1:
        return vals[0]
    # 2 donjons à valeurs multiples : prendre le max étage par étage serait
    # plus fin, mais SpawnRangeList est par plage ; on prend la valeur
    # majoritaire (documenté dans le rapport).
    from collections import Counter
    c = Counter(f['layout']['sticky_item_chance'] for f in rom['floors'])
    return c.most_common(1)[0][0]


def transform_zone(zobj, sticky):
    """Duplique les spawns d'items avec Cursed=true au taux sticky%."""
    changed = 0
    already = 0

    def walk(node):
        nonlocal changed, already
        if isinstance(node, dict):
            if 'ItemSpawnZoneStep' in node.get('$type', ''):
                spawns = node.get('Spawns')
                pools = spawns.values() if isinstance(spawns, dict) else [spawns]
                for pool in pools:
                    if not isinstance(pool, dict) or 'Spawns' not in pool:
                        continue
                    entries = pool['Spawns']
                    if any(e.get('Spawn', {}).get('Cursed') for e in entries):
                        already += 1
                        continue
                    new_entries = []
                    for e in entries:
                        sp = e.get('Spawn', {})
                        rate = e.get('Rate', 0)
                        if sp.get('Price', 0) > 0 or sp.get('IsMoney') or rate <= 0:
                            new_entries.append(e)
                            continue
                        rc = rate * sticky // 100
                        if rc <= 0:
                            new_entries.append(e)
                            continue
                        norm = copy.deepcopy(e)
                        norm['Rate'] = rate - rc
                        cur = copy.deepcopy(e)
                        cur['Rate'] = rc
                        cur['Spawn']['Cursed'] = True
                        new_entries.append(norm)
                        new_entries.append(cur)
                        changed += 1
                    entries[:] = new_entries
            for v in node.values():
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(zobj)
    return changed, already


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}

    report = {'rule': 'R12 sticky_item_chance mappa_s -> InvItem.Cursed (taux exact, somme des rates preservee)',
              'apply': args.apply, 'zones': []}
    tot = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        s = sticky_of(rom)
        if s <= 0:
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        z = json.load(open(zpath, encoding='utf-8-sig'))
        changed, already = transform_zone(z['Object'], s)
        row = {'zone': zone, 'dungeon': info['dungeon'], 'sticky_pct': s,
               'entries_split': changed, 'pools_already_done': already}
        report['zones'].append(row)
        tot += changed
        if args.apply and changed:
            with open(zpath, 'w', encoding='utf-8-sig') as f:
                json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/STICKY_ITEM_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('entries_split')])
    print(f"entries dédoublées Cursed: {tot} dans {nz} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
