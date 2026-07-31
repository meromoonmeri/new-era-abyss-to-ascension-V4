#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_chapter_gaps.py — PNJ permanents muets par trou de chapitre.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_chgap2.py » de
~/audit/scripts/) : une entité PERMANENTE du .rsground (triggerType
1/2/3) aiguillée dynamiquement (load("..._ch_"..Chapter..".Action")) vers
un fichier de chapitre inexistant devient muette aux chapitres du trou
(classe I4 : Relicanth, Gible, Sunflora, comptoirs de l'auberge...).

Usage : python3 tools/audit_chapter_gaps.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, json, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

static = {}
for p in glob.glob(os.path.join(ROOT, 'Data/Ground/*.rsground')):
    g = os.path.basename(p)[:-9]
    try:
        e = json.load(open(p, encoding='utf-8-sig'))['Object']['Entities'][0]
    except Exception:
        continue
    s = set()
    for k in ('MapChars', 'GroundObjects'):
        for x in e.get(k, []):
            if x.get('triggerType') in (1, 2, 3):
                n = x.get('EntName') or x.get('NPCName')
                if n:
                    s.add(n + ('_Action' if x['triggerType'] == 1 else '_Touch'))
    static[g] = s

rows = []
for d in sorted(glob.glob(os.path.join(ROOT, 'Data/Script/*/ground/*/'))):
    g = os.path.basename(d.rstrip('/'))
    init = os.path.join(d, 'init.lua')
    if not os.path.exists(init) or g not in static:
        continue
    t = open(init, encoding='utf-8', errors='replace').read()
    dyn = {f for _, f in re.findall(
        r'load\("(\w+)_ch_"\s*\.\.\s*tostring\(SV\.ChapterProgression\.Chapter\)\s*\.\.\s*"\.(\w+)\(', t)}
    inter = sorted(dyn & static[g])
    if not inter:
        continue
    have = {int(re.search(r'_ch_(\d+)\.lua$', p).group(1))
            for p in glob.glob(os.path.join(d, g + '_ch_*.lua'))}
    gaps = [c for c in range(1, 11) if c not in have]
    if gaps:
        rows.append((g, sorted(have), gaps, inter))

print("### X2. PNJ/objet PERMANENT de la carte (.rsground, trigger 1/2/3) aiguille dynamiquement,")
print("        vers un fichier de chapitre INEXISTANT -> muet a ces chapitres\n")
for g, have, gaps, inter in rows:
    print(f"   {g:26s} ch presents {have}  MUET aux ch{gaps}")
    print(f"        entites concernees : {inter}")
print(f"\n   {len(rows)} cartes")
