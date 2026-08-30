#!/usr/bin/env python3
"""M1 — matérialise la carte composée en .rsground PMDO natif.

Fidélité totale au Ground Metano :
  * mêmes 11 couches (Base, Cliffs, River, Layer 4, Objects Under,
    Objects Under Anim, Objects, Objects Anim, Objects Over,
    Objects Over Anim, Fringe) ;
  * chaque cellule composée (hash) est recopiée depuis sa cellule
    REPRÉSENTATIVE du donneur : pour chaque couche, le tile JSON
    complet (frames multiples = animations rivière/cascade 4 frames
    FrameLength 10 — colorimétrie et timing canoniques par
    construction) ;
  * collision : grille composée (native par supertile/groupe) ;
  * Background/BlankBG/rand : structure Metano ; AssetName nouveau.

Sortie : Data/Ground/vallon_eclusee.rsground + entrée Script ground.
"""
from __future__ import annotations

import copy
import json
from pathlib import Path

REPO = Path('/home/user/new-era-abyss-to-ascension-V4')
ASSET = 'vallon_eclusee'
NAME_FR = "Vallon de l'Éclusée — environnement brut (M1)"

COMPOSED = json.load(open('/tmp/m1_metano_composed.json'))
DB = json.load(open('/tmp/mt_db.json'))
INFO = DB['info']


def main():
    donor = json.loads(
        (REPO / 'Data/Ground/metano_town.rsground')
        .read_text(encoding='utf-8-sig'))
    dobj = donor['Object']
    dlayers = dobj['Layers']

    W, H = COMPOSED['W'], COMPOSED['H']
    P = COMPOSED['p']
    C = COMPOSED['c']

    EMPTY = {"AutoTileset": "", "Associates": [], "Layers": [],
             "NeighborCode": 0}

    layers = []
    for li, dl in enumerate(dlayers):
        tiles = []
        for x in range(W):
            col = []
            for y in range(H):
                rep = INFO[P[x][y]]['rep']
                src = dl['Tiles'][rep[0]][rep[1]]
                col.append(copy.deepcopy(src) if src.get('Layers')
                           else dict(EMPTY))
            tiles.append(col)
        layers.append({'Name': dl['Name'], 'Layer': dl.get('Layer', 0),
                       'Visible': True, 'Tiles': tiles})

    obstacles = [[{'Bounds': {'X': x * 8, 'Y': y * 8,
                              'Width': 8, 'Height': 8},
                   'Tags': C[x][y]} for y in range(H)]
                 for x in range(W)]

    # spawn : entrée sud du chemin principal (43, H-6) praticable
    sx, sy = 43, H - 6
    assert C[sx][sy] == 0, 'spawn bloqué'

    out = {
        'Version': donor.get('Version', '0.8.9.0'),
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': NAME_FR,
                     'LocalTexts': {'fr': NAME_FR}},
            'Released': False,
            'Comment': ('M1 RAW_TOWN_ENVIRONMENT — layout original '
                        'synthétisé dans le langage du Ground '
                        'metano_town (supertiles pixel-perfect, '
                        'autotiles/berges/falaises/cascades/ponts '
                        'natifs, animations rivière 4 frames '
                        'FrameLength 10 canoniques). Générateur '
                        'mt_layout3.py seed ' +
                        str(COMPOSED['params']['seed']) + '.'),
            'obstacles': obstacles,
            'rand': copy.deepcopy(dobj['rand']),
            'Status': {},
            'Background': copy.deepcopy(dobj['Background']),
            'BlankBG': copy.deepcopy(dobj['BlankBG']),
            'Layers': layers,
            'AssetName': ASSET,
            'Music': dobj.get('Music', ''),
            'EdgeView': dobj.get('EdgeView', 1),
            'NoSwitching': False,
            'ViewCenter': None,
            'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0,
                             'Visible': True, 'Anims': []}],
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [],
                          'Spawners': [],
                          'Markers': [{'EntName':
                                       'Main_Entrance_Marker',
                                       'Direction': 0,
                                       'EntEnabled': True,
                                       'EntOrder': 0,
                                       'InteractOrder': 0,
                                       'triggerType': 0,
                                       'Collider': {'X': sx * 8,
                                                    'Y': sy * 8,
                                                    'Width': 16,
                                                    'Height': 16}}]}],
        },
    }
    dst = REPO / 'Data/Ground' / f'{ASSET}.rsground'
    dst.write_text('\ufeff' + json.dumps(out, ensure_ascii=False,
                                         indent=1),
                   encoding='utf-8')
    print('written', dst, dst.stat().st_size, 'bytes')

    # script ground minimal (conventions projet)
    sdir = REPO / 'Data/Script/halcyon/ground' / ASSET
    sdir.mkdir(parents=True, exist_ok=True)
    (sdir / 'init.lua').write_text(f"""-- M1 RAW_TOWN_ENVIRONMENT — {ASSET} (environnement brut, zéro
-- bâtiment). Généré par materialize_ground.py.
require 'origin.common'
local M = {{}}
function M.Init(map) end
function M.Enter(map) GAME:FadeIn(20) end
function M.Exit(map) end
function M.Update(map, time) end
function M.GameSave(map) end
function M.GameLoad(map) GAME:FadeIn(20) end
return M
""", encoding='utf-8')
    print('script', sdir / 'init.lua')


if __name__ == '__main__':
    main()
