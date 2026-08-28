#!/usr/bin/env python3
"""LOT A — Fidélité structurelle Sky (règle R6) : mappe le champ ROM
`layout.structure` de mappa_s.bin vers le GridPath RogueElements exact,
étage par étage, pour les structures exotiques :

  RING       -> GridPathCircle   (grille 6x4 EoS generate_ring)
  CROSSROADS -> GridPathCross    (grille 5x4 EoS generate_crossroads)
  CROSS      -> GridPathCross    (grille 3x3 EoS generate_cross, exact)
  BETTLE     -> GridPathBeetle   (grille 3x3, colonne centrale fusionnée
                                  EoS generate_beetle merge_rooms -> Vertical=False)
  LINE       -> grille 5x1       (EoS generate_room_line, path Branch conservé)

Justification binaire : dungeon-eos (portage 1:1 du générateur EoS,
adresses US commentées dans DungeonAlgorithm.py) : generate_ring
(6x4, anneau extérieur couloirs), generate_crossroads (5x4, coins
invalides, centre couloirs), generate_cross (3x3 sans coins),
generate_beetle (3x3, colonne x=1 fusionnée en salle géante),
generate_room_line (5x1).

Conventions de sérialisation reprises du vanilla PMDO (DumpAsset) :
GridPathCircle: ambush_forest (CircleRoomRatio/Paths) ; GridPathBeetle:
debug_zone (LegPercent/ConnectPercent/GiantHallGen). Le RoomGen/HallGen
pool de l'étage (GenericRooms/GenericHalls/Room/HallComponents du
GridPathBranch d'origine) est CONSERVÉ, seul le path change.

Le transformateur ne touche jamais aux zones CH1-CH5 verrouillées.
"""
import json, gzip, glob, os, sys, copy, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')

sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS  # refuse de toucher au verrouillé

EXOTIC = {'RING', 'CROSSROADS', 'CROSS', 'BETTLE', 'LINE'}
# dims de grille EoS exactes (dungeon-eos)
GRID_DIMS = {
    'RING': (6, 4),
    'CROSSROADS': (5, 4),
    'CROSS': (3, 3),
    'BETTLE': (3, 3),
    'LINE': (5, 1),
}

MGC = 'RogueEssence.LevelGen.MapGenContext, RogueEssence'


def path_type(name, assembly='RogueElements'):
    return f"{assembly}.{name}`1[[{MGC}]], {assembly}"


def find_zone_floors(zobj, n_rom_floors):
    """Trouve le segment dont le nombre d'étages == nombre d'étages ROM."""
    for si, seg in enumerate(zobj['Segments']):
        fls = seg.get('Floors', [])
        if isinstance(fls, list) and len(fls) == n_rom_floors:
            return si, fls
    return None, None


def get_gensteps(floor):
    """GridFloorGen direct, ou ChanceFloorGen -> premier Spawn GridFloorGen."""
    if 'GenSteps' in floor:
        return [floor.get('GenSteps')]
    out = []
    for sp in floor.get('Spawns', []):
        g = sp.get('Spawn', {})
        if 'GenSteps' in g:
            out.append(g['GenSteps'])
    return out


def transform(gensteps, structure, report_row):
    """Remplace le path + ajuste la grille dans une liste de GenSteps."""
    changed = False
    # 1. localiser InitGridPlanStep et le path GridPathBranch
    init_step = None
    path_step = None
    for g in gensteps:
        t = g['Value'].get('$type', '')
        if 'InitGridPlanStep' in t:
            init_step = g['Value']
        elif 'GridPathBranch' in t:
            path_step = g['Value']
        elif any(p in t for p in ('GridPathCircle', 'GridPathCross', 'GridPathBeetle', 'GridPathGrid')):
            report_row['note'] = 'path déjà non-branch : ' + t.split(',')[0].split('.')[-1]
            return False
    if init_step is None or path_step is None:
        report_row['note'] = 'InitGridPlanStep ou GridPathBranch introuvable'
        return False

    gx, gy = GRID_DIMS[structure]
    report_row['grid_before'] = [init_step.get('CellX'), init_step.get('CellY')]
    init_step['CellX'] = gx
    init_step['CellY'] = gy
    report_row['grid_after'] = [gx, gy]

    keep = {k: path_step[k] for k in ('GenericRooms', 'GenericHalls', 'RoomComponents', 'HallComponents') if k in path_step}

    if structure == 'RING':
        path_step.clear()
        path_step['$type'] = path_type('GridPathCircle')
        path_step.update(keep)
        # convention projet (port GBA great_canyon, validée journeys)
        path_step['CircleRoomRatio'] = {'Min': 60, 'Max': 90}
        path_step['Paths'] = {'Min': 2, 'Max': 4}
        changed = True
    elif structure in ('CROSSROADS', 'CROSS'):
        path_step.clear()
        path_step['$type'] = path_type('GridPathCross')
        path_step.update(keep)
        changed = True
    elif structure == 'BETTLE':
        path_step.clear()
        path_step['$type'] = path_type('GridPathBeetle', 'PMDC')
        path_step.update(keep)
        path_step['LargeRoomComponents'] = copy.deepcopy(keep.get('RoomComponents', []))
        # EoS : colonne verticale fusionnée -> Vertical=False (Rect(tier,0,1,H))
        path_step['Vertical'] = False
        path_step['LegPercent'] = 80       # convention vanilla debug_zone
        path_step['ConnectPercent'] = 80
        path_step['FromCorners'] = False
        # salle géante = colonne (3 cellules de haut)
        path_step['GiantHallGen'] = [{
            'Spawn': {
                '$type': f"RogueElements.RoomGenBump`1[[{MGC}]], RogueElements",
                'Width': {'Min': 6, 'Max': 10},
                'Height': {'Min': 22, 'Max': 30},
                'BumpPercent': {'Min': 0, 'Max': 101},
            },
            'Rate': 10,
        }]
        changed = True
    elif structure == 'LINE':
        # path Branch conservé : la contrainte EoS est la grille 5x1
        changed = True

    return changed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    cmp_zones = json.load(open(os.path.join(TAB, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    dmap = {os.path.basename(fp).split('_')[0]: fp
            for fp in glob.glob(os.path.join(TAB, 'dungeons/*.json.gz'))}

    report = {'rule': 'R6 structure mappa_s -> GridPath exact (dungeon-eos)', 'apply': args.apply, 'zones': []}
    for zone, info in sorted(cmp_zones.items()):
        did = info['dungeon']
        fp = dmap.get(did)
        if not fp:
            continue
        rom = json.load(gzip.open(fp))
        exotic = [(f['floor'], f['layout']['structure']) for f in rom['floors']
                  if f['layout']['structure'] in EXOTIC]
        if not exotic:
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            report['zones'].append({'zone': zone, 'status': 'ZONE_ABSENTE'})
            continue
        z = json.load(open(zpath, encoding='utf-8-sig'))
        zobj = z['Object']
        si, floors = find_zone_floors(zobj, len(rom['floors']))
        if floors is None:
            report['zones'].append({'zone': zone, 'status': 'SEGMENT_NON_ALIGNE',
                                    'rom_floors': len(rom['floors'])})
            continue
        zrep = {'zone': zone, 'dungeon': did, 'segment': si, 'floors': []}
        nch = 0
        for fnum, structure in exotic:
            row = {'floor': fnum, 'structure': structure}
            fl = floors[fnum - 1]
            done = False
            for gensteps in get_gensteps(fl):
                if transform(gensteps, structure, row):
                    done = True
            row['status'] = 'CHANGED' if done else 'SKIP'
            if done:
                nch += 1
            zrep['floors'].append(row)
        zrep['changed'] = nch
        report['zones'].append(zrep)
        if args.apply and nch:
            with open(zpath, 'w', encoding='utf-8-sig') as f:
                json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/SKY_EXOTIC_STRUCTURE_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    tot = sum(z.get('changed', 0) for z in report['zones'])
    print(f"zones: {len(report['zones'])}, étages transformés: {tot}, apply={args.apply}")
    for z in report['zones']:
        print(' ', z['zone'], z.get('status', ''), 'changed=', z.get('changed', 0))


if __name__ == '__main__':
    main()
