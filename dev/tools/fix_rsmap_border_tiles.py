#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_rsmap_border_tiles.py — Uniformisation des bordures rsmap.

PROBLÈME (constaté en jeu) : autour des cartes fixes importées de la ROM,
le moteur dessine la texture BlankBG au-delà des bords (BaseDungeonScene :
EdgeView=Blank -> BlankBG). Sur ~40 rsmaps, BlankBG et/ou TextureMap sont
restés sur les autotiles du GABARIT de conversion (treeshroud_forest_1_wall,
magma_cavern_2_*) au lieu du tileset canonique de la carte -> anneau de
tuiles hors sujet autour de l'arène.

CORRECTIF (technique, zéro modification du contenu ROM) :
 - mur dominant réel = comptage des Tiles ID wall/unbreakable de la carte ;
 - BlankBG := mur dominant (l'extérieur se fond dans la paroi canonique) ;
 - TextureMap wall/unbreakable := mur dominant ; floor := sol dominant ;
   water := secondary du même set si l'autotile existe, sinon inchangé.
Les rsmaps dont BlankBG est vide (voile noir, convention vanilla 117/122)
ne sont modifiés QUE si leur TextureMap est hors sujet.
"""
import collections
import glob
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MAP_DIR = os.path.join(REPO, "Data", "Map")
AUTOTILE_DIRS = [os.path.join(REPO, "Data", "AutoTile"),
                 os.path.join(REPO, ".runtime-cache", "DumpAsset", "Data",
                              "AutoTile")]

# rsmaps verrouillés CH1-5
LOCKED = {"mount_windswept_guardian", "vast_steppe_guardian"}


def autotile_exists(name):
    return any(os.path.exists(os.path.join(d, name + ".json"))
               for d in AUTOTILE_DIRS)


def load(p):
    return json.load(open(p, encoding="utf-8-sig"))


def save(p, doc):
    with open(p, "w", encoding="utf-8-sig") as fh:
        json.dump(doc, fh, ensure_ascii=False, indent=2)


def main():
    changed = []
    for p in sorted(glob.glob(os.path.join(MAP_DIR, "*.rsmap"))):
        name = os.path.basename(p)[:-6]
        if name in LOCKED:
            continue
        doc = load(p)
        o = doc["Object"]
        walls = collections.Counter()
        floors = collections.Counter()
        for col in o.get("Tiles") or []:
            for c in col:
                data = (c or {}).get("Data", {})
                tid = data.get("ID")
                at = data.get("TileTex", {}).get("AutoTileset", "")
                if not at:
                    continue
                if tid in ("wall", "unbreakable"):
                    walls[at] += 1
                elif tid == "floor":
                    floors[at] += 1
        if not walls and not floors:
            continue
        dom_wall = walls.most_common(1)[0][0] if walls else None
        dom_floor = floors.most_common(1)[0][0] if floors else None
        rep = {}

        # BlankBG : hors sujet si non vide et != mur dominant
        bb = o.get("BlankBG") or {}
        if dom_wall and bb.get("AutoTileset") and \
                bb.get("AutoTileset") != dom_wall:
            rep["BlankBG"] = [bb.get("AutoTileset"), dom_wall]
            bb["AutoTileset"] = dom_wall
        # BlankBG vide sur carte importée ROM : on le remplit avec le mur
        # dominant pour éviter le vide noir non canonique autour des arènes
        # (les MAP_BG NDS remplissent tout l'écran de paroi).
        elif dom_wall and not bb.get("AutoTileset"):
            cmt = (o.get("Comment") or "")
            if "fixed" in cmt.lower() or "fixed.bin" in cmt or \
                    "fixedmap" in cmt:
                rep["BlankBG"] = ["", dom_wall]
                o["BlankBG"] = {"AutoTileset": dom_wall, "Associates": [],
                                "Layers": [], "NeighborCode": -1}

        # TextureMap
        tm = o.get("TextureMap") or {}
        for key, want in (("wall", dom_wall), ("unbreakable", dom_wall),
                          ("floor", dom_floor)):
            if not want:
                continue
            cur = tm.get(key, {}).get("AutoTileset")
            if cur and cur != want:
                rep[f"TextureMap.{key}"] = [cur, want]
                tm[key]["AutoTileset"] = want
        # water : secondary du même set que le mur dominant
        if dom_wall and dom_wall.endswith("_wall"):
            base = dom_wall[:-5]
            sec = base + "_secondary"
            cur = tm.get("water", {}).get("AutoTileset")
            if cur and cur != sec and autotile_exists(sec) and \
                    not cur.startswith(base):
                rep["TextureMap.water"] = [cur, sec]
                tm["water"]["AutoTileset"] = sec
                assoc = tm["water"].get("Associates")
                if isinstance(assoc, list):
                    tm["water"]["Associates"] = [base + "_floor"]

        if rep:
            save(p, doc)
            changed.append((name, rep))

    print(f"rsmaps corrigés: {len(changed)}")
    for n, r in changed:
        print(" ", n, "->", json.dumps(r, ensure_ascii=False))
    out = os.path.join(REPO, "dev", "docs", "canonical",
                       "RSMAP_BORDER_FIX_REPORT.json")
    json.dump({n: r for n, r in changed}, open(out, "w"),
              ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == "__main__":
    main()
