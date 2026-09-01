#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""materialize_mapacomplete.py — émet le .rsground PMDO natif du BLOCKOUT.

Fidélité totale au Ground Metano :
  * mêmes 11 couches (Base, Cliffs, River, Layer 4, Objects Under,
    Objects Under Anim, Objects, Objects Anim, Objects Over,
    Objects Over Anim, Fringe) ;
  * chaque cellule composée (hash) est recopiée depuis sa cellule
    REPRÉSENTATIVE du donneur pour CHAQUE couche : c'est le tile JSON
    complet (Sheet + TexLoc + FrameLength) — le moteur retrouve donc
    le vrai rendu et la collision native ;
  * collision : grille composée (native par supertile) dans `obstacles`.

Sortie : Data/Ground/mapacomplete_metano.rsground + entrée index/script.
"""
from __future__ import annotations

import copy
import json
from pathlib import Path

REPO = Path('/home/user/new-era-abyss-to-ascension-V4')
ASSET = 'mapacomplete_metano'
NAME_FR = "Metano Outskirts (Treehouse) — blockout"

COMPOSED = json.load(open('/tmp/mapa_composed.json'))
DB = json.load(open('/tmp/mt_db.json'))
INFO = DB['info']


def main():
    donor = json.loads(
        (REPO / 'Data/Ground/metano_town.rsground').read_text(encoding='utf-8-sig'))
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
                h = P[x][y]
                rep = INFO[h]['rep']
                src = dl['Tiles'][rep[0]][rep[1]]
                col.append(copy.deepcopy(src) if src.get('Layers')
                           else dict(EMPTY))
            tiles.append(col)
        layers.append({'Name': dl['Name'], 'Layer': dl.get('Layer', 0),
                       'Visible': True, 'Tiles': tiles})

    # obstacles grid (W x H) using composite collision
    obstacles = [[int(C[x][y]) for y in range(H)] for x in range(W)]

    out = {
        "Version": "0.4.0.0",
        "Object": {
            "$type": "PMDC.Dungeon.GroundMap, PMDC",
            "TexSize": dobj.get('TexSize', 1),
            "Name": {"DefaultText": NAME_FR, "LocalTexts": {}},
            "Released": True,
            "Comment": ("Reconstruction manuelle du fragment TOWN PLAZA "
                        "(F1/F3) de MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp, "
                        "langage 100 % Metano, collision native. BLOCKOUT. "
                        "Placeholders de la source NON convertis (MISSING)."),
            "obstacles": obstacles,
            "rand": dobj.get('rand', 0),
            "Status": dobj.get('Status', 0),
            "Background": "",
            "BlankBG": False,
            "Layers": layers,
            "AssetName": ASSET,
            "Music": "Treasure Town.ogg",
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": {"X": W * 8 // 2, "Y": H * 8 // 2},
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "Decorations": [],
            "Entities": [
                {"Name": "New EntLayer", "Visible": True,
                 "MapChars": [], "GroundObjects": [], "Spawners": [],
                 "Markers": [
                     {"Name": "Spawn_North",
                      "Loc": {"X": (39) * 8, "Y": 12 * 8}, "Dir": 2},
                     {"Name": "Spawn_South",
                      "Loc": {"X": (39) * 8, "Y": (H - 6) * 8}, "Dir": 0}]}
            ],
            "Markers": [],
            "Spawners": [],
        },
    }
    dst = REPO / 'Data/Ground' / f'{ASSET}.rsground'
    dst.write_text('\ufeff' + json.dumps(out, ensure_ascii=False, indent=1),
                   encoding='utf-8')
    print('written', dst, dst.stat().st_size, 'bytes')

    # script ground minimal (conventions projet)
    sdir = REPO / 'Data/Script/halcyon/ground' / ASSET
    sdir.mkdir(parents=True, exist_ok=True)
    (sdir / 'init.lua').write_text(f"""-- Metano Outskirts (Treehouse) — {ASSET}
-- BLOCKOUT généré par materialize_mapacomplete.py (langage Metano).
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
