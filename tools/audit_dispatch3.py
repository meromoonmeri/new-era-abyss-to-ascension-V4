#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_dispatch3.py — PNJ instanciés sans handler dans le même fichier.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_dispatch3.py » de
~/audit/scripts/) : un PNJ créé par MakeCharactersFromList dans un
fichier de chapitre mais dont le handler <Nom>_Action n'est pas défini
dans CE fichier → l'assert du dispatch lève à l'interaction (classe I5 :
Noctowl_Action au ch1, Camerupt_Action au ch2, Audino_Action au ch4...).

Usage : python3 tools/audit_dispatch3.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

rows = []
for f in glob.glob(os.path.join(ROOT, 'Data/Script/*/ground/*/*.lua'), recursive=True):
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    # instances créées via MakeCharactersFromList (liste de tuples)
    inst = set()
    for m in re.finditer(r"MakeCharactersFromList\(\s*\{([^}]*)\}", t, re.S):
        for mm in re.finditer(r"\{\s*'([A-Za-z_]\w*)'\s*,", m.group(1)):
            inst.add(mm.group(1))
    # handlers définis dans ce fichier + TOUS les .lua du dossier (init.lua
    # compris : Zarude_Action, Nidoking_Action, Furret_Action vivent dans
    # init.lua, pas dans les _ch_N — ne pas les compter manquants).
    base = os.path.basename(f)[:-4]
    parent = os.path.dirname(f)
    defined = set()
    for cf in glob.glob(os.path.join(parent, '*.lua')):
        ct = strip_comments(open(cf, encoding='utf-8', errors='replace').read())
        defined |= set(re.findall(r'^function\s+\w+\.([A-Za-z_]\w*_Action)\s*\(', ct, re.M))
    # handlers RÉFÉRENCÉS quelque part (dispatch/assert/load) dans le dossier :
    # un PNJ de cinématique créé mais jamais interactif n'a pas besoin de
    # handler (faux positif vigie_stratos/Rayquaza). On ne signale que les
    # instances dont le _Action est réellement appelé par le code.
    all_dir_src = ''
    for cf in glob.glob(os.path.join(parent, '*.lua')):
        all_dir_src += strip_comments(open(cf, encoding='utf-8', errors='replace').read())
    referenced = {i + '_Action' for i in inst if i + '_Action' in all_dir_src}
    missing = sorted(ref for ref in referenced if ref not in defined)
    if missing:
        rows.append((os.path.relpath(f, ROOT), sorted(inst), missing))

print("### D3. Instances MakeCharactersFromList dont le handler _Action est RÉFÉRENCÉ")
print("        mais jamais défini (même fichier + frères _ch_N)")
print(f"   {len(rows)} fichier(s)\n")
for p, inst, missing in sorted(rows):
    print(f"   {p}")
    print(f"        instances : {inst}")
    print(f"        manquants : {missing}")
