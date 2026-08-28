#!/usr/bin/env python3
"""LOT G' — Impasses canoniques Sky (règle R9, volet dead ends).

ROM : mappa_s layout.dead_ends (bool PAR ÉTAGE, 726 étages true).
Sémantique EoS (dungeon-eos create_connections l.507) : si dead_end==0,
le générateur RECONNECTE toutes les impasses ; si dead_end==1 elles sont
CONSERVÉES (topologie plus dangereuse, cul-de-sacs réels).

PMDO natif : ConnectGridBranchStep.ConnectPercent (RogueElements l.37,
RandBinomial sur les branches terminales). Nos zones Sky ont uniformément
ConnectPercent=100 (= dead_end 0 partout) → écart sur 726 étages.

Transformation : par étage, si dead_ends ROM == true → ConnectPercent=0
(impasses conservées, loi EoS exacte) ; sinon 100 (reconnexion totale,
déjà en place). Zones verrouillées et segments LoadGen exclus.
"""
import json, gzip, glob, os, sys, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS


def pools(fl):
    if 'GenSteps' in fl:
        yield fl['GenSteps']
    for sp in fl.get('Spawns', []):
        g = sp.get('Spawn', {})
        if 'GenSteps' in g:
            yield g['GenSteps']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}

    report = {'rule': 'R9 dead_ends mappa_s -> ConnectPercent 0/100 par étage (EoS create_connections l.507)',
              'apply': args.apply, 'zones': []}
    tot = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        de = [bool(f['layout']['dead_ends']) for f in rom['floors']]
        if not any(de):
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        z = json.load(open(zpath, encoding='utf-8-sig'))
        seg = None
        for s in z['Object']['Segments']:
            fls = s.get('Floors', [])
            if isinstance(fls, list) and len(fls) == len(de):
                seg = s
                break
        if seg is None:
            report['zones'].append({'zone': zone, 'status': 'SEGMENT_NON_ALIGNE'})
            continue
        if any(isinstance(f, dict) and 'LoadGen' in f.get('$type', '')
               for f in seg['Floors']):
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOADGEN_BOSS'})
            continue
        changed = 0
        for fi, keep_dead in enumerate(de):
            if not keep_dead:
                continue
            for gensteps in pools(seg['Floors'][fi]):
                for g in gensteps:
                    if 'ConnectGridBranchStep' in g['Value'].get('$type', ''):
                        if g['Value'].get('ConnectPercent') != 0:
                            g['Value']['ConnectPercent'] = 0
                            changed += 1
        if changed:
            tot += changed
            report['zones'].append({'zone': zone, 'dungeon': info['dungeon'],
                                    'floors_dead_ends': sum(de), 'steps_changed': changed})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/DEAD_ENDS_SKY_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('steps_changed')])
    print(f"ConnectPercent 100->0 : {tot} steps dans {nz} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
