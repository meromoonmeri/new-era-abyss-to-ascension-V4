#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_plot.py — dispatch de chapitre dans les init.lua de ground.

Vérifie le patron PlotScripting des ground/*/init.lua : chaque chapitre
couvert par un fichier *_ch_N.lua doit avoir une branche de dispatch
réelle (pas seulement un require), et un chapitre sans fichier doit
retomber sur le repli (ChapterDispatch / branche else) plutôt que sur
du vide.

Usage : python3 tools/audit_plot.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

rows = []
for d in sorted(glob.glob(os.path.join(ROOT, 'Data/Script/*/ground/*/'))):
    g = os.path.basename(d.rstrip('/'))
    init = os.path.join(d, 'init.lua')
    if not os.path.exists(init):
        continue
    t = strip_comments(open(init, encoding='utf-8', errors='replace').read())
    ch_files = {}
    for p in glob.glob(os.path.join(d, g + '_ch_*.lua')):
        c = int(re.search(r'_ch_(\d+)\.lua$', p).group(1))
        ct = strip_comments(open(p, encoding='utf-8', errors='replace').read())
        # ne compter que les fichiers qui définissent une ENTRÉE DE SCÈNE
        # (fonction à dispatcher). Un fichier qui ne contient que des
        # handlers *_Action (ex. guild_guildmasters_room_ch_3) est couvert
        # par le repli de handlers et n'est PAS un trou de PlotScripting.
        scene_fns = [f for f in re.findall(r'^function\s+\w+\.(\w+)\s*\(', ct, re.M)
                     if not f.endswith('_Action') and not f.endswith('_Touch')]
        if scene_fns:
            ch_files[c] = scene_fns
    if not ch_files:
        continue
    # branche explicite Chapter == N, OU appel direct d'une fonction du
    # module _ch_N dans le fichier (patron des arènes de boss ch5 :
    # `if SV.Chapter5.X then ..._ch_5.FirstPreBossScene() end`), OU
    # ChapterDispatch générique.
    branch = set()
    for c in ch_files:
        if re.search(r'Chapter\s*==\s*%d\b|Chapter==%d\b' % (c, c), t):
            branch.add(c)
    direct_calls = {int(x) for x in re.findall(r'\b' + re.escape(g) + r'_ch_(\d+)\.\w+\s*\(', t)}
    branch |= direct_calls
    has_dispatch = 'ChapterDispatch' in t
    has_else = re.search(r'\belse\b', t) is not None
    uncovered = sorted(c for c in ch_files if c not in branch and not has_dispatch)
    if uncovered:
        rows.append((g, sorted(ch_files), uncovered, has_dispatch, has_else))

print("### PLOT. Fichiers _ch_N sans branche de dispatch explicite ni ChapterDispatch")
print(f"   {len(rows)} carte(s)\n")
for g, ch, un, disp, else_ in sorted(rows):
    print(f"   {g:26s} ch {ch}  NON-BRANCHÉS {un}  dispatch={disp} else={else_}")
