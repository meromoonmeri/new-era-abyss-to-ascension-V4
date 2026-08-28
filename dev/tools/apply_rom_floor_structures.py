#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""apply_rom_floor_structures.py — Casse l'architecture unique clonée
(gabarit dusk_forest 4x4) en appliquant PAR ÉTAGE la structure ROM.

CONSTAT : 146 zones portaient toutes InitGridPlan (10,10,4,4) — le
gabarit dusk_forest cloné. La ROM, elle, distingue par étage :
  Sky (mappa_s.bin `structure`, sémantique dungeon_eos generate_floor) :
   - SMALL  (layout 1)  : grille 4 x rand(2,3), carte demi-largeur ;
   - MEDIUM (layout 11) : grille 4 x rand(2,3), carte 3/4 ;
   - MEDIUM_LARGE/défaut: grille rand ≤ 6x4 ;
   - RING/CROSSROADS/CROSS/LINE/BETTLE : générateurs spéciaux EoS —
     approximés par le générateur natif PMDO (adaptation documentée).
  Red (pret FloorProperties roomDensity, AssignRooms) : le nombre de
  salles cible dimensionne la grille.

ADAPTATION PMDO (technique, jamais le canon) : InitGridPlanStep CellX/
CellY par étage selon la structure ROM ; CellWidth/CellHeight ajustés
pour rester dans le gabarit runtime-validé :
  SMALL         -> 3x3 cellules (cartes compactes début de jeu)
  MEDIUM        -> 4x3
  MEDIUM_LARGE+ -> 5x4
  RING/CROSSROADS/CROSS/LINE/BETTLE -> 4x4 (générateur natif)
  Red: rooms<=5 -> 3x3 ; 6-8 -> 4x3 ; 9-11 -> 4x4 ; >=12 -> 5x4
La génération reste ALÉATOIRE par étage (GridFloorGen natif) — seule la
gabarie de grille suit désormais la ROM au lieu d'être identique partout.
"""
import glob
import gzip
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                      "Tables")
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference", "data",
                    "dungeon")

LOCKED = {
    "relic_forest", "illuminant_riverbed", "crooked_cavern",
    "apricorn_grove", "vast_steppe", "searing_tunnel", "mount_windswept",
    "cloven_ruins", "beginner_lesson", "petit_tunnel", "bosquet_voile",
    "grotte_mystere", "vallee_fertile", "grotte_repos", "bois_ronces",
    "antre_enigme", "carriere_cuivre", "grotte_echoue", "halles_royales",
    "jardin_secret", "foret_embuscade", "bois_filou", "normal_maze",
    "bug_maze", "electric_maze", "fire_maze", "flying_maze", "grass_maze",
    "rock_maze", "water_maze", "master_zone",
}

from add_monster_houses_from_rom import RED_Z2P  # noqa: E402


def sky_profiles():
    cmp_ = json.load(open(os.path.join(
        TABLES, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    out = {}
    cache = {}
    for zn, e in cmp_.items():
        dxx = e['dungeon']
        if dxx not in cache:
            g = glob.glob(os.path.join(TABLES, 'dungeons',
                                       f'{dxx}_*.json.gz'))
            cache[dxx] = json.load(gzip.open(g[0])) if g else None
        rom = cache[dxx]
        if rom:
            out[zn] = [f['layout']['structure'] for f in rom['floors']]
    return out


def red_profiles():
    stream = []

    def rec(path):
        for line in open(path):
            line = line.strip()
            m = re.match(r'#include\s+"([^"]+)"', line)
            if m:
                rec(os.path.join(PRET, m.group(1)))
            elif line.startswith('.byte'):
                stream.extend(int(x, 16) for x in
                              re.findall(r'0x([0-9a-fA-F]{2})', line))
    rec(os.path.join(PRET, 'main_data.inc'))
    props = [stream[i:i + 28] for i in range(0, len(stream), 28)]
    out = {}
    for zn, pret_dir in RED_Z2P.items():
        fid = os.path.join(PRET, pret_dir, 'floor_id.json')
        if not os.path.exists(fid):
            continue
        tables = json.load(open(fid))['tables']
        rooms = []
        for t in tables:
            r = props[t['MainData']][1]
            rooms.append(r if r < 128 else abs(r - 256))
        out[zn] = rooms
    return out


def grid_for_sky(structure):
    if structure == 'SMALL':
        return (3, 3)
    if structure in ('MEDIUM', 'SMALL_MEDIUM'):
        return (4, 3)
    if structure in ('RING', 'CROSSROADS', 'CROSS', 'LINE', 'BETTLE'):
        return (4, 4)
    return (5, 4)  # MEDIUM_LARGE et variantes


def grid_for_red(rooms):
    if rooms <= 5:
        return (3, 3)
    if rooms <= 8:
        return (4, 3)
    if rooms <= 11:
        return (4, 4)
    return (5, 4)


def main():
    sky = sky_profiles()
    red = red_profiles()
    changed = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Zone',
                                           '*.json'))):
        zn = os.path.basename(p)[:-5]
        if zn in LOCKED:
            continue
        prof = sky.get(zn)
        which = 'sky' if prof else None
        if prof is None and zn in red:
            prof = red[zn]
            which = 'red'
        if prof is None:
            continue
        z = json.load(open(p, encoding='utf-8-sig'))
        n = 0
        gfloor = 0
        for seg in z['Object'].get('Segments', []):
            floors = seg.get('Floors')
            if not isinstance(floors, list):
                continue
            for fl in floors:
                idx = min(gfloor, len(prof) - 1)
                gfloor += 1
                gens = []
                if isinstance(fl, dict) and 'GenSteps' in fl:
                    gens = [fl]
                elif isinstance(fl, dict) and isinstance(
                        fl.get('Spawns'), list):
                    gens = [s['Spawn'] for s in fl['Spawns']
                            if isinstance(s.get('Spawn'), dict) and
                            'GenSteps' in s['Spawn']]
                for fg in gens:
                    for gs in fg['GenSteps']:
                        v = gs['Value']
                        if 'InitGridPlanStep' not in v['$type']:
                            continue
                        cur = (v.get('CellX'), v.get('CellY'))
                        if cur != (4, 4):
                            continue  # déjà spécifique — ne pas toucher
                        if which == 'sky':
                            want = grid_for_sky(prof[idx])
                        else:
                            want = grid_for_red(prof[idx])
                        if want != cur:
                            v['CellX'], v['CellY'] = want
                            n += 1
        if n:
            with open(p, 'w', encoding='utf-8-sig') as fh:
                json.dump(z, fh, ensure_ascii=False, indent=2)
            changed[zn] = n
    tot = sum(changed.values())
    print(f"zones: {len(changed)}, étages re-dimensionnés: {tot}")
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'FLOOR_STRUCTURE_APPLY_REPORT.json')
    json.dump(changed, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    import sys
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    main()
