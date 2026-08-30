#!/usr/bin/env python3
"""M1 — plan directeur ORIGINAL + synthèse + rendu + rapport.

Layout (aucune géométrie commune avec Metano/Luluby/Grass Town) :
  * rivière en L : entre au NORD-OUEST, descend, coude vers l'EST,
    sort à l'EST (Metano : rivière verticale plein centre-est) ;
  * place centrale au SUD-EST du coude, chemin principal N-S décalé à
    l'ouest, boucle secondaire est, entrée SUD ;
  * parcelles futures : NO (près rivière), CENTRE-EST, SUD-OUEST ;
  * ceinture de forêt sur tout le périmètre.
Déterministe : seed fixe enregistré.
"""
from __future__ import annotations

import json
import sys

sys.path.insert(0, '/home/user/new-era-abyss-to-ascension-V4/'
                   'dev/TOWN/M1_RAW_TOWN_ENVIRONMENT/tools')
import mt_synth as S  # noqa: E402

SEED = 20260830
W, H = 72, 72


def build_plan():
    plan = [['F'] * H for _ in range(W)]

    def rect(x0, y0, x1, y1, lab):
        for x in range(max(0, x0), min(W, x1 + 1)):
            for y in range(max(0, y0), min(H, y1 + 1)):
                plan[x][y] = lab

    # clairière générale (respiration) au centre
    rect(8, 10, 63, 63, 'G')
    # rivière en L : verticale x=14..19 du nord à y=34, puis
    # horizontale y=30..35 vers l'est jusqu'au bord
    rect(13, 0, 20, 35, 'W')
    rect(13, 29, 71, 36, 'W')
    # chemin principal N-S (x=34..38) de y=8 à l'entrée sud
    rect(33, 8, 39, 71, 'P')
    # place centrale (élargie) sous la rivière
    rect(28, 44, 47, 54, 'P')
    # chemin ouest place->pont sud rivière? pas de pont : chemin est
    rect(39, 46, 60, 50, 'P')
    # sentier ouest vers parcelle SO
    rect(18, 56, 34, 59, 'P')
    # parcelles (plates, herbe) : NO près rivière, E, SO
    rect(24, 14, 31, 21, 'G')
    rect(52, 40, 60, 47, 'G')
    rect(12, 60, 22, 67, 'G')
    # bandes vertes le long de la rivière (berges praticables)
    rect(21, 8, 27, 28, 'G')
    rect(24, 37, 60, 43, 'G')
    return plan


def main():
    plan_cols = build_plan()
    # plan[x][i] attendu par synth
    grid = S.synth(W, H, plan_cols, SEED, tries=400)
    if grid is None:
        print('SYNTH FAILED')
        return 1
    bad = S.validate(grid)
    print('pairs violations:', len(bad))
    coll = [[S.COLL.get(grid[x][y], 0) for y in range(H)]
            for x in range(W)]
    json.dump({'W': W, 'H': H, 'p': grid, 'c': coll,
               'params': {'seed': SEED, 'plan': 'mt_compose.py/1'}},
              open('/tmp/m1_metano_composed.json', 'w'))
    S.render(grid, '/tmp/m1_metano_composed.png')
    print(f'{W}x{H} -> /tmp/m1_metano_composed.png')
    return 0 if not bad else 2


if __name__ == '__main__':
    raise SystemExit(main())
