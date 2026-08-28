#!/usr/bin/env python3
"""LOT C — Mystery Floors Sky : escaliers cachés (règle R11).

ROM : mappa_s.bin layout.hidden_stairs_spawn_chance (% PAR ÉTAGE, 435
étages Sky > 0). Comportement EoS : un escalier caché peut apparaître sur
l'étage ; il mène à une salle secrète à trésors, puis on RETOURNE au
donjon principal à l'étage suivant.

Implémentation 100 % native (mécanique vanilla PMDO stairs_secret_*,
cf. faded_trail) :
 1. Par étage éligible f : GenStep [5,2] RandomRoomSpawnStep<EffectTile>
    SuccessPercent = chance ROM de l'étage (roll PAR ÉTAGE comme la ROM),
    BulkSpawner -> EffectTile `stairs_secret_down` Revealed=false
    (caché : révélé par RevealSecretEvent/Luminous) + DestState
    {Segment: T, ID: idx} Relative=false.
 2. Segment T « Salle secrète » (LayeredSegment ajouté en fin de zone) :
    un étage par étage éligible, petit layout (grille 2x2) SANS ennemis
    (Mob steps retirés, pas de TeamSpawnZoneStep), items x3 + argent
    (ZoneSteps copiés du segment principal, Ranges triplés), sortie
    stairs_go_down + DestState {Segment:0, ID:f+1} (ou EndSegment Cleared
    si dernier étage, sémantique DestState invalide).
Statut canonique : mécanique et probabilités EXACTES ; contenu de la
salle secrète PORTED_APPROXIMATED (Secret Bazaar PNJ non porté, documenté).
"""
import json, gzip, glob, os, sys, argparse, copy

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

MGC = 'RogueEssence.LevelGen.MapGenContext, RogueEssence'
ET = 'RogueEssence.Dungeon.EffectTile, RogueEssence'


def secret_stair_step(chance, tseg, tfloor):
    return {
        'Key': {'str': [5, 2]},
        'Value': {
            '$type': f'RogueElements.RandomRoomSpawnStep`2[[{MGC}],[{ET}]], RogueElements',
            'SuccessPercent': chance,
            'IncludeHalls': False,
            'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
            'Spawn': {
                '$type': f'RogueEssence.LevelGen.BulkSpawner`2[[{MGC}],[{ET}]], RogueEssence',
                'SpecificSpawns': [{
                    'TileLoc': {'X': 0, 'Y': 0},
                    'ID': 'stairs_secret_down',
                    'Revealed': False,
                    'Owner': 0,
                    'TileStates': [{
                        '$type': 'PMDC.Dungeon.DestState, PMDC',
                        'Dest': {'Segment': tseg, 'ID': tfloor},
                        'Relative': False,
                        'PreserveMusic': True,
                    }],
                }],
                'RandomSpawns': [],
                'SpawnAmount': 0,
            },
        },
    }


def strip_mob_steps(gensteps):
    keep = []
    for g in gensteps:
        t = g['Value'].get('$type', '')
        if 'PlaceRandomMobsStep' in t or 'MobSpawnSettingsStep' in t:
            continue
        keep.append(g)
    return keep


def retarget_stairs(gensteps, dest_seg, dest_floor):
    for g in gensteps:
        t = g['Value'].get('$type', '')
        if 'FloorStairsStep' in t:
            for ex in g['Value'].get('Exits', []):
                tile = ex.get('Tile', ex)
                tile['ID'] = 'stairs_go_down'
                tile['TileStates'] = [{
                    '$type': 'PMDC.Dungeon.DestState, PMDC',
                    'Dest': {'Segment': dest_seg, 'ID': dest_floor},
                    'Relative': False,
                    'PreserveMusic': True,
                }]
            return True
    return False


def shrink_grid(gensteps):
    for g in gensteps:
        if 'InitGridPlanStep' in g['Value'].get('$type', ''):
            g['Value']['CellX'] = 2
            g['Value']['CellY'] = 2
            return True
    return False


def strip_secret_steps(gensteps):
    return [g for g in gensteps
            if 'stairs_secret' not in json.dumps(g)]


def boost_item_ranges(zonestep, mult=3, cap=12):
    def walk(n):
        if isinstance(n, dict):
            if 'Range' in n and isinstance(n.get('Range'), dict) and 'Spawn' in n:
                r = n['Range']
                if isinstance(r.get('Min'), int):
                    r['Min'] = min(cap, max(1, r['Min'] * mult))
                    r['Max'] = min(cap + 3, max(r['Min'] + 1, r['Max'] * mult))
            for v in n.values():
                walk(v)
        elif isinstance(n, list):
            for v in n:
                walk(v)
    walk(zonestep)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}

    report = {'rule': 'R11 hidden_stairs_spawn_chance mappa_s -> stairs_secret_down natif + segment salle secrete',
              'apply': args.apply, 'zones': []}
    tot_floors = 0
    for zone, info in sorted(cmp_zones.items()):
        fp = dmap.get(info['dungeon'])
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        elig = [(f['floor'], f['layout']['hidden_stairs_spawn_chance'])
                for f in rom['floors'] if f['layout']['hidden_stairs_spawn_chance'] > 0]
        if not elig:
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        raw = open(zpath, encoding='utf-8-sig').read()
        if 'stairs_secret_down' in raw:
            report['zones'].append({'zone': zone, 'status': 'DEJA_EQUIPPE'})
            continue
        z = json.loads(raw)
        zobj = z['Object']
        segs = zobj['Segments']
        main_i = None
        for si, s in enumerate(segs):
            fls = s.get('Floors', [])
            if isinstance(fls, list) and len(fls) == len(rom['floors']):
                main_i = si
                break
        if main_i is None:
            report['zones'].append({'zone': zone, 'status': 'SEGMENT_NON_ALIGNE'})
            continue
        main_seg = segs[main_i]
        tseg_idx = len(segs)
        nfl = len(rom['floors'])

        # segment salle secrète
        treasure = {
            '$type': 'RogueEssence.LevelGen.LayeredSegment, RogueEssence',
            'Floors': [],
            'ZoneSteps': [],
            'IsRelevant': False,
            'Comment': f'R11 salles secretes (hidden stairs ROM {info["dungeon"]})',
        }
        # ZoneSteps : items/money copiés + boostés, nom d'étage dédié
        for zs in main_seg.get('ZoneSteps', []):
            t = zs.get('$type', '')
            if 'ItemSpawnZoneStep' in t or 'MoneySpawnZoneStep' in t:
                c = copy.deepcopy(zs)
                if 'ItemSpawnZoneStep' in t:
                    boost_item_ranges(c)
                treasure['ZoneSteps'].append(c)
            elif 'FloorNameDropZoneStep' in t:
                c = copy.deepcopy(zs)
                name = c.get('Name', {})
                if isinstance(name.get('DefaultText'), str):
                    base = name['DefaultText'].split('\\n')[0]
                    name['DefaultText'] = base + ' Secret Room'
                    for k in list(name.get('LocalTexts', {})):
                        b = name['LocalTexts'][k].split('\\n')[0]
                        name['LocalTexts'][k] = b + (' Salle Secrète' if k == 'fr' else ' Secret Room')
                treasure['ZoneSteps'].append(c)

        template = main_seg['Floors'][0]
        added = []
        for ti, (fnum, chance) in enumerate(elig):
            # 1) escalier caché sur l'étage principal
            fl = main_seg['Floors'][fnum - 1]
            pools = [fl['GenSteps']] if 'GenSteps' in fl else \
                    [sp['Spawn']['GenSteps'] for sp in fl.get('Spawns', []) if 'GenSteps' in sp.get('Spawn', {})]
            for gensteps in pools:
                gensteps.append(secret_stair_step(chance, tseg_idx, ti))
            # 2) étage salle secrète correspondant
            tf = copy.deepcopy(template)
            tpools = [tf['GenSteps']] if 'GenSteps' in tf else \
                     [sp['Spawn']['GenSteps'] for sp in tf.get('Spawns', []) if 'GenSteps' in sp.get('Spawn', {})]
            if 'Spawns' in tf and tf.get('Spawns'):
                # ChanceFloorGen -> ne garder que la première variante
                tf['Spawns'] = tf['Spawns'][:1]
                tpools = tpools[:1]
            for gensteps_t in tpools:
                gensteps_t[:] = strip_secret_steps(strip_mob_steps(gensteps_t))
                shrink_grid(gensteps_t)
                if fnum < nfl:
                    retarget_stairs(gensteps_t, main_i, fnum)  # 0-based : étage suivant
                else:
                    retarget_stairs(gensteps_t, -1, -1)        # EndSegment Cleared
            treasure['Floors'].append(tf)
            added.append({'floor_rom': fnum, 'chance': chance, 'treasure_idx': ti})

        segs.append(treasure)
        tot_floors += len(added)
        report['zones'].append({'zone': zone, 'dungeon': info['dungeon'],
                                'treasure_segment': tseg_idx, 'floors': added})
        if args.apply:
            with open(zpath, 'w', encoding='utf-8-sig') as f:
                json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/HIDDEN_STAIRS_SKY_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('floors')])
    print(f"escaliers cachés: {tot_floors} étages dans {nz} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
