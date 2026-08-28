#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_battle_position_offsets.py — BattlePositionEvent : offsets RELATIFS.

CAUSE (source PMDC SingleCharEvent.cs, BattlePositionEvent.MoveChar) :
    endLoc = leader.CharLoc + StartLocs[i].Loc
Les StartLocs sont des OFFSETS relatifs à la position du leader (formation
vanilla boss_awd: (0,0),(0,1),(-1,1),(1,1)). 38 arènes du dépôt stockaient
des positions ABSOLUES de la carte -> en runtime l'équipe est projetée à
EntryPoint+(5,4)... : héros décalé, partenaire pas face au boss.

CORRECTIF :
 - leader canonique = StartLocs[0] absolu (position LEADER_SPAWN ROM déjà
   posée par le commit précédent) ;
 - EntryPoint := leader absolu (si différent) ;
 - StartLocs[i] := abs[i] - leader_abs (le 1er devient (0,0)) ;
 - Dir de chaque slot := direction 8-voies vers le boss le plus proche
   (MapTeams), calculée depuis la position ABSOLUE du slot — le face-à-face
   canonique (Team Meanies face au duo, duo face au boss).
Aucune position ROM n'est modifiée : seule la REPRÉSENTATION (absolue ->
relative moteur) est corrigée.
"""
import glob
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DIRMAP = {(0, -1): 0, (1, -1): 1, (1, 0): 2, (1, 1): 3,
          (0, 1): 4, (-1, 1): 5, (-1, 0): 6, (-1, -1): 7}


def sgn(v):
    return 0 if v == 0 else (1 if v > 0 else -1)


def main():
    changed = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Map',
                                           '*.rsmap'))):
        d = json.load(open(p, encoding='utf-8-sig'))
        o = d['Object']
        name = os.path.basename(p)[:-6]
        me = o.get('MapEffect') or {}
        boss_locs = []
        for team in o.get('MapTeams') or []:
            for pl in team.get('Players') or []:
                loc = pl.get('CharLoc') or {}
                if 'X' in loc:
                    boss_locs.append((loc['X'], loc['Y']))
        touched = False
        for e in me.get('OnMapStarts', []):
            v = e.get('Value', {})
            if 'BattlePositionEvent' not in v.get('$type', ''):
                continue
            locs = v.get('StartLocs') or []
            if not locs:
                continue
            coords = [(sl['Loc']['X'], sl['Loc']['Y']) for sl in locs]
            # absolu = au moins un offset au-delà de la formation (2 cases)
            if not any(abs(x) > 2 or abs(y) > 2 for x, y in coords):
                continue
            lx, ly = coords[0]
            # EntryPoint aligné sur le leader absolu
            for ep in o.get('EntryPoints') or []:
                if ep.get('Loc', {}) != {'X': lx, 'Y': ly}:
                    ep['Loc'] = {'X': lx, 'Y': ly}
            new_locs = []
            for (ax, ay) in coords:
                if boss_locs:
                    bx, by = min(boss_locs,
                                 key=lambda b: (b[0] - ax) ** 2 +
                                               (b[1] - ay) ** 2)
                    dir8 = DIRMAP.get((sgn(bx - ax), sgn(by - ay)), 0)
                else:
                    dir8 = locs[0].get('Dir', 0)
                new_locs.append({'Loc': {'X': ax - lx, 'Y': ay - ly},
                                 'Dir': dir8})
            v['StartLocs'] = new_locs
            # EntryPoint Dir = direction leader vers boss
            for ep in o.get('EntryPoints') or []:
                ep['Dir'] = new_locs[0]['Dir']
            changed[name] = {'leader_abs': [lx, ly],
                             'offsets': [[s['Loc']['X'], s['Loc']['Y'],
                                          s['Dir']] for s in new_locs]}
            touched = True
        if touched:
            with open(p, 'w', encoding='utf-8-sig') as fh:
                json.dump(d, fh, ensure_ascii=False, indent=2)
    print(f"arènes corrigées: {len(changed)}")
    for n, r in list(changed.items())[:12]:
        print(" ", n, r)
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'BATTLE_POSITION_OFFSET_FIX_REPORT.json')
    json.dump(changed, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    main()
