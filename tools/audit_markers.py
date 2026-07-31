#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_markers.py — marqueurs d'entrée des EnterGroundMap.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_markers.py » de
~/audit/scripts/) : chaque `GAME:EnterGroundMap("map", "marker")` doit
viser une carte existante ET un marqueur réellement présent dans le
.rsground (GroundMap.GetEntryPointIdx → KeyNotFoundException sinon).
Le moteur vérifie aussi que la carte est dans les GroundMaps de la zone
et dans index.idx — c'est le rôle de verify_ground_registration.py.

Usage : python3 tools/audit_markers.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, json, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

markers = {}
for p in glob.glob(os.path.join(ROOT, 'Data/Ground/*.rsground')):
    g = os.path.basename(p)[:-9]
    try:
        e = json.load(open(p, encoding='utf-8-sig'))['Object']['Entities'][0]
    except Exception:
        continue
    markers[g] = {m.get('EntName') for m in e.get('Markers', [])}

bad = []
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = open(f, encoding='utf-8', errors='replace').read()
    t = re.sub(r'--\[\[.*?\]\]', '', t, flags=re.S)
    t = re.sub(r'--[^\n]*', '', t)
    for m in re.finditer(r"GAME:EnterGroundMap\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([A-Za-z0-9_]+)['\"]", t):
        g, mk = m.group(1), m.group(2)
        if g not in markers:
            bad.append((os.path.relpath(f, ROOT), g, mk, 'CARTE INCONNUE'))
        elif mk not in markers[g]:
            bad.append((os.path.relpath(f, ROOT), g, mk, 'MARQUEUR ABSENT'))

print("### M. Marqueurs d'entrée manquants pour EnterGroundMap")
print(f"   {len(bad)} appel(s) en échec\n")
seen = set()
for p, g, mk, why in sorted(bad):
    key = (g, mk)
    if key in seen:
        continue
    seen.add(key)
    print(f"   {why:16s} {g} :: {mk}  <- {p}")
if not bad:
    print("   0 marqueur manquant.")
