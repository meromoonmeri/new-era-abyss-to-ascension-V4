#!/usr/bin/env python3
"""LOT M — Structures secondaires GBA (règle R8) : budget ROM -> eau posée.

ROM (pret dungeon_generation.c GenerateSecondaryStructure, Rand(6)) :
DIVIDER / ISLAND / POOL / CHECKERBOARD / MAZE+DOT — motifs d'eau PAR SALLE,
nombre limité par FloorProperties.secondaryStructuresBudget (offset 12).
Chaque salle est flaggée à 50 % (SECONDARY_STRUCTURE_FLAG_CHANCE) puis le
budget limite le nombre réellement généré.

Contre-épreuve : 155/1764 étages GBA ont budget>0 (11 zones mappées :
fantasy_strait 8, far_off_sea 15, howling_forest 7, marvelous_sea 5,
northern_range 13, pitfall_valley 8, remains_island 10, silver_trench 24,
snow_path 1, stormy_sea 10, wish_cave 33) et AUCUNE de ces zones ne pose
de terrain secondaire aujourd'hui.

Implémentation native (§35) : PatternTerrainStep (PMDC) + rsmaps vanilla
pattern_* (mêmes assets que depleted_basin/geode_crevice) :
  POOL         ~ pattern_blob / pattern_blob_small
  CHECKERBOARD ~ pattern_checker / pattern_dither_fourth
  MAZE+DOT     ~ pattern_plus / pattern_crosshair
  DIVIDER      ~ pattern_slash
  Amount       = {Min 1, Max budget} par plage d'étages de même budget
  Terrain      = water (Tile ID 'water') ; stencil = modèle vanilla exact
  (Room-only, pas d'effet-tile, pas de chokepoint).
Statut : PORTED_APPROXIMATED (motifs voisins, budget exact) — ISLAND avec
warp+loot reste au cycle C# (documenté).
"""
import json, re, os, sys, argparse, copy

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PRET = os.path.join(ROOT, '.runtime-cache/pmd-red-reference/data/dungeon')
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS
from add_monster_houses_from_rom import RED_Z2P

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


def water_tile():
    return {'$type': 'RogueEssence.Dungeon.Tile, RogueEssence',
            'Data': {'ID': 'water',
                     'TileTex': {'AutoTileset': '', 'Associates': [],
                                 'Layers': [], 'NeighborCode': -1},
                     'StableTex': False},
            'Effect': {'TileLoc': {'X': 0, 'Y': 0}, 'ID': '', 'Revealed': False,
                       'Owner': 0, 'TileStates': []}}


def pattern_step(budget):
    """PatternTerrainStep eau — motifs = équivalents des 5 structures ROM."""
    return {'Key': {'str': [3, 3]}, 'Value': {
        '$type': f'PMDC.LevelGen.PatternTerrainStep`1[[{MGC}]], PMDC',
        'Terrain': water_tile(),
        'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
        'IncludeHalls': False,
        'AllowTerminal': True,
        'TerrainStencil': {
            '$type': f'RogueElements.MultiTerrainStencil`1[[{MGC}]], RogueElements',
            'List': [
                {'$type': f'RogueElements.MapTerrainStencil`1[[{MGC}]], RogueElements',
                 'Room': True, 'Wall': False, 'Blocked': False, 'Not': False},
                {'$type': f'RogueEssence.LevelGen.TileEffectStencil`1[[{MGC}]], RogueEssence',
                 'Not': True},
            ],
            'RequireAny': False},
        'Amount': {'Min': 1, 'Max': max(1, budget)},
        'Maps': [
            {'Spawn': {'MapID': 'pattern_blob', 'Pattern': 0}, 'Rate': 3},        # POOL
            {'Spawn': {'MapID': 'pattern_blob_small', 'Pattern': 0}, 'Rate': 3},  # POOL (petit)
            {'Spawn': {'MapID': 'pattern_checker', 'Pattern': 0}, 'Rate': 2},     # CHECKERBOARD
            {'Spawn': {'MapID': 'pattern_plus', 'Pattern': 0}, 'Rate': 2},        # MAZE+DOT (croix)
            {'Spawn': {'MapID': 'pattern_crosshair', 'Pattern': 0}, 'Rate': 1},   # MAZE+DOT
            {'Spawn': {'MapID': 'pattern_slash', 'Pattern': 0}, 'Rate': 1},       # DIVIDER
        ],
    }}


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
    P = parse_floorprops()

    report = {'rule': 'R8 GBA secondaryStructuresBudget (offset 12) -> PatternTerrainStep eau (motifs POOL/CHECKER/PLUS/SLASH vanilla)',
              'status': 'PORTED_APPROXIMATED (ISLAND warp+loot = cycle C#)',
              'apply': args.apply, 'zones': []}
    tot = 0
    for zone, pret in sorted(RED_Z2P.items()):
        fid = os.path.join(PRET, pret, 'floor_id.json')
        if not os.path.exists(fid):
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        tables = json.load(open(fid))['tables']
        budgets = [P[t['MainData']][12] for t in tables]
        if not any(b > 0 for b in budgets):
            continue
        raw = open(zpath, encoding='utf-8-sig').read()
        z = json.loads(raw)
        gfloor = 0
        changed = []
        for seg in z['Object']['Segments']:
            fls = seg.get('Floors')
            if not isinstance(fls, list):
                continue
            for fl in fls:
                if gfloor >= len(budgets):
                    break
                b = budgets[gfloor]
                gfloor += 1
                if b <= 0 or not isinstance(fl, dict):
                    continue
                for gensteps in pools(fl):
                    if any('PatternTerrainStep' in g['Value'].get('$type', '')
                           for g in gensteps):
                        continue
                    gensteps.append(pattern_step(b))
                    changed.append({'floor': gfloor, 'budget': b})
        if changed:
            tot += len(changed)
            report['zones'].append({'zone': zone, 'floors': changed})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/GBA_SECONDARY_STRUCTURES_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len(report['zones'])
    print(f"structures secondaires: {tot} étages / {nz} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
