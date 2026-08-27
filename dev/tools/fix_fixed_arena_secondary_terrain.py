#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_fixed_arena_secondary_terrain.py — Restaure le terrain SECONDAIRE
ROM dans les arènes boss .rsmap.

CAUSE (prouvée par audit_fixed_arenas_vs_rom.py) : lors de la conversion,
les cellules fixed.bin classées SECONDARY (vide/eau) ont été aplaties en
'floor'. Exemples : temporal_pinnacle_arena 200 cellules VOID -> floor
(l'arène de Dialga ROM est une plateforme entourée de vide), vast_ice 192,
underground_lake 46 (lac d'eau), sky_peak_summit 25, sky_stairway 11
(vide), magma_pit_groudon 8 (lave GBA).

TYPE de secondaire = table ROM SECONDARY_TERRAIN_TYPES arm9 EU par donjon
(VOID -> 'pit', WATER -> 'water') ; Red : Magma Cavern = lave ('lava'),
Sky Tower = ciel/vide ('pit') — pret PMD Red, le secondaire GBA de la
Caverne Magma est la lave, celui de la Tour Céleste le vide céleste.
Textures : autotile <base>_secondary déjà présent (vérifié), Associates =
<base>_floor (convention vanilla boss_artifact*.rsmap).

Corrige aussi les 2 divergences unitaires :
 - sky_summit_rayquaza (1,4 ROM=floor, rsmap=wall) -> floor ;
 - spiritomb_arena (ROM=wall, rsmap=floor) -> wall.
"""
import glob
import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(REPO, "dev", "tools"))
from audit_fixed_arenas_vs_rom import (  # noqa: E402
    sky_fixed_floors, sky_terrain, red_decode, red_terrain)

# arène -> (terrain secondaire PMDO, source/justification)
SECONDARY_KIND = {
    # Sky — SECONDARY_TERRAIN_TYPES arm9 EU
    "temporal_pinnacle_arena": ("pit", "d43 VOID (arm9)"),
    "sky_stairway_apex_map": ("pit", "d99 VOID (arm9)"),
    "underground_lake_arena": ("water", "d23 WATER (arm9)"),
    "sky_peak_summit_map": ("water", "d122 WATER (arm9)"),
    "vast_ice_mountain_pinnacle_map": ("water", "d148 WATER (arm9)"),
    # Red — pret GBA
    "magma_pit_groudon": ("lava", "Magma Cavern secondaire = lave (GBA)"),
    "sky_summit_rayquaza": ("water", "Sky Tower secondaire déjà posé eau"),
}


def load(p):
    return json.load(open(p, encoding='utf-8-sig'))


def save(p, doc):
    with open(p, 'w', encoding='utf-8-sig') as fh:
        json.dump(doc, fh, ensure_ascii=False, indent=2)


def rom_grid_for(path, ffs):
    d = load(path)
    cmt = d['Object'].get('Comment') or ''
    m = re.search(r'fixed floor (\d+)', cmt)
    m2 = re.search(r'fixed room (\d+)', cmt)
    if m:
        ff = ffs[int(m.group(1))]
        rows = [[sky_terrain(ff.actions[y * ff.width + x])
                 for x in range(ff.width)] for y in range(ff.height)]
        return d, ff.width, ff.height, rows
    if m2:
        w, h, rows_v = red_decode(int(m2.group(1)))
        return d, w, h, [[red_terrain(v) for v in row] for row in rows_v]
    return d, None, None, None


def cell_data(tid, base):
    if tid in ('water', 'pit', 'lava'):
        return {"ID": tid,
                "TileTex": {"AutoTileset": f"{base}_secondary",
                            "Associates": [f"{base}_floor"],
                            "Layers": [], "NeighborCode": -1},
                "StableTex": False}
    if tid in ('wall', 'unbreakable'):
        return {"ID": tid,
                "TileTex": {"AutoTileset": f"{base}_wall",
                            "Associates": [], "Layers": [],
                            "NeighborCode": -1},
                "StableTex": False}
    return {"ID": "floor",
            "TileTex": {"AutoTileset": f"{base}_floor",
                        "Associates": [], "Layers": [],
                        "NeighborCode": -1},
            "StableTex": False}


def main():
    ffs = sky_fixed_floors()
    report = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Map',
                                           '*.rsmap'))):
        name = os.path.basename(p)[:-6]
        d, w, h, rows = rom_grid_for(p, ffs)
        if rows is None:
            continue
        o = d['Object']
        T = o.get('Tiles') or []
        if (len(T), len(T[0]) if T else 0) != (w, h):
            continue
        wall_at = o.get('TextureMap', {}).get('wall', {}) \
            .get('AutoTileset', '')
        base = wall_at[:-5] if wall_at.endswith('_wall') else None
        if not base:
            continue
        sec_kind = SECONDARY_KIND.get(name, ("water", "défaut WATER"))[0]
        fixes = 0
        layers = o.get('Layers') or []
        for y in range(h):
            for x in range(w):
                want = rows[y][x]
                cur = (T[x][y].get('Data') or {}).get('ID', '')
                cur_cls = 'wall' if cur in ('wall', 'unbreakable') else (
                    'secondary' if cur in ('water', 'pit', 'lava')
                    else 'floor')
                if want == cur_cls:
                    continue
                if want == 'secondary':
                    new_id = sec_kind
                elif want == 'wall':
                    new_id = 'wall'
                else:
                    new_id = 'floor'
                T[x][y]['Data'] = cell_data(new_id, base)
                # layer visuel aligné
                for L in layers:
                    lt = L.get('Tiles')
                    if lt and x < len(lt) and y < len(lt[x]) and \
                            isinstance(lt[x][y], dict) and \
                            'AutoTileset' in lt[x][y]:
                        suf = ('_secondary' if new_id in
                               ('water', 'pit', 'lava') else
                               ('_wall' if new_id == 'wall' else '_floor'))
                        lt[x][y]['AutoTileset'] = base + suf
                        if suf == '_secondary':
                            lt[x][y]['Associates'] = [f"{base}_floor"]
                        else:
                            lt[x][y]['Associates'] = []
                fixes += 1
        if fixes:
            save(p, d)
            report[name] = {"fixes": fixes, "secondary_as": sec_kind}
    print(json.dumps(report, indent=1, ensure_ascii=False))
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'FIXED_ARENA_SECONDARY_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    main()
