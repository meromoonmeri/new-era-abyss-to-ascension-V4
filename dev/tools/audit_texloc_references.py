#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_texloc_references.py — Test « tuile décalée » niveau carte.

Complément carte du test structurel autotile : chaque référence DIRECTE
{Sheet, TexLoc} dans les .rsground et .rsmap (couches Layers, Decorations,
BlankBG frames, etc.) doit pointer vers une entrée EXISTANTE de l'index
binaire du .tile. Un TexLoc hors index = tuile noire/décalée en jeu
(le cas Sinister Woods historique au niveau des cartes).

Fail-closed, aucune tolérance. Sortie :
dev/docs/canonical/TEXLOC_REFERENCE_AUDIT.json
"""
import glob
import json
import os
import struct
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TILE_DIRS = [os.path.join(REPO, 'Content', 'Tile'),
             os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Content',
                          'Tile')]

_cache = {}


def sheet_keys(name):
    if name in _cache:
        return _cache[name]
    path = None
    for d in TILE_DIRS:
        p = os.path.join(d, name + '.tile')
        if os.path.exists(p):
            path = p
            break
    if path is None:
        _cache[name] = None
        return None
    data = open(path, 'rb').read()
    _, count = struct.unpack_from('<II', data, 0)
    keys = set()
    for i in range(count):
        key, _ = struct.unpack_from('<QQ', data, 8 + i * 16)
        keys.add((key & 0xFFFFFFFF, key >> 32))
    _cache[name] = keys
    return keys


def walk(node, out):
    """Collecte récursive des couples (Sheet, TexLoc)."""
    if isinstance(node, dict):
        if 'Sheet' in node and 'TexLoc' in node:
            out.append((node.get('Sheet'),
                        node['TexLoc'].get('X'), node['TexLoc'].get('Y')))
        for v in node.values():
            walk(v, out)
    elif isinstance(node, list):
        for v in node:
            walk(v, out)


def main():
    failures = {}
    n_files = n_refs = 0
    for pattern in ('Data/Ground/*.rsground', 'Data/Map/*.rsmap'):
        for p in sorted(glob.glob(os.path.join(REPO, pattern))):
            name = os.path.relpath(p, REPO)
            try:
                d = json.load(open(p, encoding='utf-8-sig'))
            except Exception as e:
                failures[name] = [f"JSON: {e}"]
                continue
            refs = []
            walk(d.get('Object', {}), refs)
            n_files += 1
            probs = []
            for (sh, x, y) in refs:
                if not sh:
                    continue
                n_refs += 1
                keys = sheet_keys(sh)
                if keys is None:
                    probs.append(f"sheet absent '{sh}'")
                elif (x, y) not in keys:
                    probs.append(f"TexLoc ({x},{y}) hors index de {sh}")
            if probs:
                failures[name] = sorted(set(probs))[:10]
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'TEXLOC_REFERENCE_AUDIT.json')
    json.dump({"summary": {"files": n_files, "refs": n_refs,
                           "FAIL": len(failures)},
               "failures": failures}, open(out, 'w'),
              ensure_ascii=False, indent=1)
    print(f"fichiers: {n_files}  références: {n_refs}  "
          f"FAIL: {len(failures)}")
    for n, r in list(failures.items())[:15]:
        print(" ", n, r[:3])
    print("rapport:", out)
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
