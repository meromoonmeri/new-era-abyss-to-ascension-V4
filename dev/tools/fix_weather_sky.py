#!/usr/bin/env python3
"""LOT H' — Météo canonique par étage Sky (§31, champ mappa_s weather).

ROM : layout.weather par étage (1795 étages : CLEAR 1574, RANDOM 82,
FOG 48, CLOUDY 40, SUNNY 26, RAINY 14, SANDSTORM 6, SNOW 5).
Écart mesuré : 114/139 étages à météo FIXE non branchés dans nos zones.

Implémentation native (pattern vanilla barren_tundra + CH1-5 locked) :
GenStep prioritaire [-6] `DefaultMapStatusStep(SetterID='default_weather',
DefaultMapStatus=[id])` par étage concerné.
Mapping ROM->PMDO (MapStatus vanilla, hérités par le quest) :
  FOG->fog  CLOUDY->cloudy  SUNNY->sunny  RAINY->rain
  SANDSTORM->sandstorm  SNOW->snow
RANDOM : non traité ici (mécanique EoS de tirage météo par étage —
documenté UNIMPLEMENTED_DATA, nécessite un step de tirage, cycle suivant).
CLEAR : rien (défaut).
Zones verrouillées / segments LoadGen exclus. Idempotent (saute l'étage
si un DefaultMapStatusStep default_weather y existe déjà).
"""
import json, gzip, glob, os, sys, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

WX = {'FOG': 'fog', 'CLOUDY': 'cloudy', 'SUNNY': 'sunny', 'RAINY': 'rain',
      'SANDSTORM': 'sandstorm', 'SNOW': 'snow', 'HAIL': 'hail'}


def pools(fl):
    if 'GenSteps' in fl:
        yield fl['GenSteps'], 'MapGenContext'
    for sp in fl.get('Spawns', []):
        g = sp.get('Spawn', {})
        if 'GenSteps' in g:
            yield g['GenSteps'], 'MapGenContext'


def weather_step(status, ctx):
    return {'Key': {'str': [-6]}, 'Value': {
        '$type': f'PMDC.LevelGen.DefaultMapStatusStep`1[[RogueEssence.LevelGen.{ctx}, RogueEssence]], PMDC',
        'SetterID': 'default_weather',
        'DefaultMapStatus': [status]}}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}

    report = {'rule': '§31 weather mappa_s par étage -> DefaultMapStatusStep default_weather (pattern vanilla)',
              'mapping': WX, 'random_floors_unimplemented': 0,
              'apply': args.apply, 'zones': []}
    tot = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        wxf = [(i, f['layout']['weather']) for i, f in enumerate(rom['floors'])]
        fixed = [(i, w) for i, w in wxf if w in WX]
        report['random_floors_unimplemented'] += sum(1 for _, w in wxf if w == 'RANDOM')
        if not fixed:
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
            if isinstance(fls, list) and len(fls) == len(rom['floors']):
                seg = s
                break
        if seg is None:
            report['zones'].append({'zone': zone, 'status': 'SEGMENT_NON_ALIGNE'})
            continue
        if any(isinstance(f, dict) and 'LoadGen' in f.get('$type', '')
               for f in seg['Floors']):
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOADGEN_BOSS'})
            continue
        changed = []
        for fi, w in fixed:
            fl = seg['Floors'][fi]
            for gensteps, ctx in pools(fl):
                if any('DefaultMapStatusStep' in g['Value'].get('$type', '')
                       and g['Value'].get('SetterID') == 'default_weather'
                       for g in gensteps):
                    continue
                gensteps.insert(1, weather_step(WX[w], ctx))
                changed.append({'floor': fi + 1, 'weather': WX[w]})
        if changed:
            tot += len(changed)
            report['zones'].append({'zone': zone, 'dungeon': info['dungeon'],
                                    'floors': changed})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/WEATHER_SKY_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('floors')])
    print(f"météo fixée: {tot} étages / {nz} zones, RANDOM non traités: "
          f"{report['random_floors_unimplemented']}, apply={args.apply}")


if __name__ == '__main__':
    main()
