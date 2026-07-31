#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_fade2.py — FadeIn atteignable par carte de scène.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_fade2.py » de
~/audit/scripts/) : le moteur ne pose AUCUN fondu à l'entrée d'un ground
(GameManager.cs:772 « no fade; the script handles that itself »). Une
carte dont le script d'Enter ne contient aucun FadeIn atteignable
apparaît sans transition (ou sous l'écran noir précédent).

Signale les ground/*/init.lua dont la fonction Enter ne contient ni
FadeIn direct ni appel à une fonction connue pour poser le fondu
(PlotScripting est inspecté à travers l'appel).

Usage : python3 tools/audit_fade2.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

bodies = {}
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    for m in re.finditer(r'function\s+([\w\.:]+)\s*\([^)]*\)(.*?)\n(?:end)\b', t, re.S):
        bodies.setdefault(m.group(1), []).append(m.group(2))

def has_fade(fn, depth=0, seen=None):
    seen = seen or set()
    if fn in seen or depth > 3:
        return False
    seen.add(fn)
    for b in bodies.get(fn, []):
        if re.search(r'FadeIn\(', b):
            return True
        for m in re.finditer(r'\b([\w]+)\.(\w+)\s*\(', b):
            c = m.group(1) + '.' + m.group(2)
            if c in bodies and has_fade(c, depth + 1, seen):
                return True
    return False

# Faux positifs documentés : les cartes 100% narratives qui vivent sous
# un fond plein écran (WaitShowBG) n'ont AUCUN besoin de FadeIn — le fond
# couvre la carte entière dès le premier frame (genesis_vision, Autel...).
# grand_canyon_porte : sa sortie() fait FadeOut + EndDungeonRun (voulu).
# testmap : carte d'atelier jamais référencée.
SKIP_MAP = {'genesis_vision', 'testmap', 'grand_canyon_porte'}

bad = []
for f in glob.glob(os.path.join(ROOT, 'Data/Script/*/ground/*/init.lua'), recursive=True):
    g = os.path.basename(os.path.dirname(f))
    if g in SKIP_MAP:
        continue
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    if 'EnterGroundMap' in t and 'function' not in t:
        continue
    # cartes qui posent un fond plein écran dans leurs scènes : pas de FadeIn requis
    if re.search(r'WaitShowBG\(', t):
        continue
    # fonctions Enter / PlotScripting
    for m in re.finditer(r'function\s+([\w\.]+\.(?:Enter|PlotScripting))\s*\([^)]*\)(.*?)\n(?:end)\b', t, re.S):
        fn = m.group(1)
        body = m.group(2)
        if re.search(r'FadeIn\(', body):
            continue
        ok = False
        for mm in re.finditer(r'\b([\w]+)\.(\w+)\s*\(', body):
            c = mm.group(1) + '.' + mm.group(2)
            if c in bodies and has_fade(c, 1, {fn}):
                ok = True
                break
        if not ok:
            bad.append((os.path.relpath(f, ROOT), fn))

print("### F2. Fonctions Enter/PlotScripting sans FadeIn atteignable")
print(f"   {len(bad)} carte(s) concernée(s)\n")
for p, fn in sorted(set(bad)):
    print(f"   {p} :: {fn}")
