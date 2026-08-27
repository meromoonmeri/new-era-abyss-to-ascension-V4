#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_ground_viewport_spawn.py — Grounds : centrage viewport + spawn en jeu.

CAUSES RACINES (RogueEssence source, BaseGroundScene.UpdateCam +
GroundMap.GetEntryPoint) :
 1. EdgeView=0 (Blank) sur 318 grounds importés : la caméra n'est PAS
    clampée aux bords de la carte et les cartes plus petites que l'écran
    ne sont PAS centrées (le clamp/centrage n'existe que pour
    ScrollEdge.Clamp=1, valeur des grounds vanilla PMDO 18/18).
 2. 350 grounds sans aucun Marker : GAME:EnterZone -> GetEntryPoint(0)
    retourne Loc.Zero -> le joueur apparaît en (0,0), coin haut-gauche,
    souvent bloqué/hors décor ("spawn hors champ").

CORRECTIF :
 - EdgeView 0 -> 1 (Clamp) : comportement caméra vanilla (centrage
   automatique des petites cartes, pas de vide en bord d'écran).
 - Ajout d'un Marker d'entrée "Main_Entrance_Marker" sur la case
   MARCHABLE (obstacles Tags==0, hitbox 16x16 libre) la plus proche du
   centre de la carte. Aucune donnée canonique modifiée : le marker est
   un point d'entrée moteur, pas du contenu ROM.
Grounds déjà pourvus d'un marker : position conservée (seul EdgeView est
harmonisé).
"""
import glob
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GROUND_DIR = os.path.join(REPO, "Data", "Ground")


def load(p):
    return json.load(open(p, encoding="utf-8-sig"))


def save(p, doc):
    with open(p, "w", encoding="utf-8-sig") as fh:
        json.dump(doc, fh, ensure_ascii=False, indent=2)


def walkable_near_center(obstacles):
    """(x8,y8) cellule 8px libre la plus proche du centre, hitbox 16x16
    libre (2x2 cellules)."""
    if not obstacles:
        return None
    W = len(obstacles)
    H = len(obstacles[0]) if W else 0
    if not H:
        return None

    def free(x, y):
        if x < 0 or y < 0 or x + 1 >= W or y + 1 >= H:
            return False
        for dx in (0, 1):
            for dy in (0, 1):
                c = obstacles[x + dx][y + dy]
                if not isinstance(c, dict) or c.get("Tags", 1) != 0:
                    return False
        return True

    cx, cy = W // 2, H // 2
    best = None
    best_d = None
    # anneaux croissants autour du centre (borne raisonnable)
    for r in range(0, max(W, H)):
        found = False
        for x in range(max(0, cx - r), min(W, cx + r + 1)):
            for y in range(max(0, cy - r), min(H, cy + r + 1)):
                if max(abs(x - cx), abs(y - cy)) != r:
                    continue
                if free(x, y):
                    d = (x - cx) ** 2 + (y - cy) ** 2
                    if best is None or d < best_d:
                        best, best_d = (x, y), d
                    found = True
        if best is not None and found:
            return best
    return best


def main():
    fixed_edge = 0
    added_marker = 0
    no_walkable = []
    for p in sorted(glob.glob(os.path.join(GROUND_DIR, "*.rsground"))):
        doc = load(p)
        o = doc["Object"]
        changed = False
        if o.get("EdgeView") == 0:
            o["EdgeView"] = 1
            fixed_edge += 1
            changed = True
        ents = o.get("Entities") or []
        nmark = sum(len(e.get("Markers") or []) for e in ents)
        if nmark == 0:
            cell = walkable_near_center(o.get("obstacles"))
            if cell is None:
                # pas de grille d'obstacles : centre géométrique de la carte
                L = o.get("Layers") or []
                if L and L[0].get("Tiles"):
                    tex = o.get("TexSize", 1)
                    W = len(L[0]["Tiles"]) * 8 * tex
                    H = len(L[0]["Tiles"][0]) * 8 * tex
                    px, py = W // 2, H // 2
                    no_walkable.append(os.path.basename(p))
                else:
                    continue
            else:
                px, py = cell[0] * 8, cell[1] * 8
            marker = {
                "EntName": "Main_Entrance_Marker",
                "Direction": 4,  # Down
                "EntEnabled": True,
                "EntOrder": 0,
                "InteractOrder": 0,
                "triggerType": 0,
                "Collider": {"X": px, "Y": py, "Width": 16, "Height": 16},
            }
            if not ents:
                o["Entities"] = [{"Name": "Entities0", "Visible": True,
                                  "Markers": [marker]}]
            else:
                grp = ents[0]
                grp.setdefault("Markers", [])
                grp["Markers"].append(marker)
            added_marker += 1
            changed = True
        if changed:
            save(p, doc)
    print(f"EdgeView 0->1 : {fixed_edge}")
    print(f"markers ajoutés : {added_marker}")
    if no_walkable:
        print(f"fallback centre géométrique (pas d'obstacles) : "
              f"{len(no_walkable)} -> {no_walkable[:10]}")


if __name__ == "__main__":
    main()
