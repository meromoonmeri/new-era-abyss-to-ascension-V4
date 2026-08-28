#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_autotile_structural.py — Test structurel « Sinister Woods »
(directive ROM BRIDGE §55-56).

Deux tilesets visuellement proches mais structurellement différents ne
doivent pas être considérés équivalents. Ce test compare chaque autotile
IMPORTÉ ROM du dépôt à la STRUCTURE vanilla PMDO (AutoTileData) :

 1. VARIANTES : mêmes clés Tilex.. que la référence vanilla du même rôle
    (wall/floor/secondary) — un mur sans ses 47 variantes de voisinage
    produit les « mauvais murs » historiques ;
 2. SHEET : chaque Frames[].Sheet référencé existe dans Content/Tile ou
    DumpAsset ;
 3. TEXLOC : chaque TexLoc (X,Y) référencé EXISTE dans l'index binaire du
    .tile (clé (x | y<<32) du dictionnaire) — un TexLoc hors index = tuile
    invisible/noire en jeu (cas Sinister Woods : mauvais découpage) ;
 4. FRAMES : FrameLength > 0, au moins 1 frame par variante.

Fail-closed : tout autotile en défaut est listé FAIL avec la raison.
Sortie : dev/docs/canonical/AUTOTILE_STRUCTURAL_AUDIT.json
"""
import glob
import io
import json
import os
import struct
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TILE_DIRS = [os.path.join(REPO, 'Content', 'Tile'),
             os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Content',
                          'Tile')]
AT_DIRS = [os.path.join(REPO, 'Data', 'AutoTile')]
VANILLA_AT = os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Data',
                          'AutoTile')

_sheet_cache = {}


def sheet_keys(name):
    """Ensemble des (x,y) présents dans l'index du .tile (sans décoder
    les PNG)."""
    if name in _sheet_cache:
        return _sheet_cache[name]
    path = None
    for d in TILE_DIRS:
        p = os.path.join(d, name + '.tile')
        if os.path.exists(p):
            path = p
            break
    if path is None:
        _sheet_cache[name] = None
        return None
    data = open(path, 'rb').read()
    _, count = struct.unpack_from('<II', data, 0)
    keys = set()
    for i in range(count):
        key, _off = struct.unpack_from('<QQ', data, 8 + i * 16)
        keys.add((key & 0xFFFFFFFF, key >> 32))
    _sheet_cache[name] = keys
    return keys


def variant_keys(obj):
    return sorted(k for k in obj.get('Tiles', {}) if k.startswith('Tilex'))


def role_of(name):
    for suf in ('_wall', '_floor', '_secondary'):
        if name.endswith(suf):
            return suf[1:]
    return None


def vanilla_reference(role):
    """Clés de variantes attendues pour un rôle, depuis beach_cave
    vanilla."""
    p = os.path.join(VANILLA_AT, f'beach_cave_{role}.json')
    d = json.load(open(p, encoding='utf-8-sig'))
    return set(variant_keys(d['Object']))


def audit_file(p, refs):
    name = os.path.basename(p)[:-5]
    d = json.load(open(p, encoding='utf-8-sig'))
    o = d['Object']
    problems = []
    role = role_of(name)
    ks = set(variant_keys(o))
    if role and role in refs:
        missing = refs[role] - ks
        if missing:
            problems.append(f"variantes manquantes ({len(missing)}): "
                            f"{sorted(missing)[:5]}")
    checked = 0
    for vk, variant in o.get('Tiles', {}).items():
        if not vk.startswith('Tilex'):
            continue
        # variant = liste de listes d'anims {Frames:[{Sheet,TexLoc}],FrameLength}
        stack = [variant]
        while stack:
            cur = stack.pop()
            if isinstance(cur, list):
                stack.extend(cur)
            elif isinstance(cur, dict):
                if 'Frames' in cur:
                    if not cur['Frames']:
                        problems.append(f"{vk}: 0 frame")
                    if cur.get('FrameLength', 1) <= 0:
                        problems.append(f"{vk}: FrameLength<=0")
                    for fr in cur['Frames']:
                        sh = fr.get('Sheet', '')
                        tl = fr.get('TexLoc', {})
                        keys = sheet_keys(sh)
                        if keys is None:
                            problems.append(f"{vk}: sheet absent '{sh}'")
                        elif (tl.get('X'), tl.get('Y')) not in keys:
                            problems.append(
                                f"{vk}: TexLoc ({tl.get('X')},"
                                f"{tl.get('Y')}) hors index de {sh}")
                        checked += 1
    return name, problems, checked


def main():
    refs = {r: vanilla_reference(r) for r in ('wall', 'floor', 'secondary')}
    report = {}
    n_pass = n_fail = total_frames = 0
    for d in AT_DIRS:
        for p in sorted(glob.glob(os.path.join(d, '*.json'))):
            name, problems, checked = audit_file(p, refs)
            total_frames += checked
            if problems:
                report[name] = {"verdict": "FAIL",
                                "problems": problems[:10],
                                "n_problems": len(problems)}
                n_fail += 1
            else:
                n_pass += 1
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'AUTOTILE_STRUCTURAL_AUDIT.json')
    json.dump({"summary": {"PASS": n_pass, "FAIL": n_fail,
                           "frames_verified": total_frames},
               "failures": report}, open(out, 'w'),
              ensure_ascii=False, indent=1)
    print(f"PASS: {n_pass}  FAIL: {n_fail}  frames vérifiées: "
          f"{total_frames}")
    for n, r in list(report.items())[:15]:
        print(" ", n, r['problems'][:3])
    print("rapport:", out)
    return 1 if n_fail else 0


if __name__ == '__main__':
    sys.exit(main())
