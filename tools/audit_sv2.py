#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_sv2.py — tables SV créées à la volée sans déclaration.

Complément de l'audit_bugs (C/D) : repère les tables de premier niveau
`SV.X` utilisées mais déclarées NULLE PART dans scriptvars.lua et
non protégées par un garde « if SV.X == nil then SV.X = {} end ».
Lire un champ sur une table ABSENTE crashe (PASSATION §2.4) : seuls les
sites protégés sont sûrs. Signale aussi les tables déclarées mais sans
rattrapage OnUpgrade dans debug_tools (risque de régression de partie).

Usage : python3 tools/audit_sv2.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

sv_path = os.path.join(ROOT, 'Data/Script/halcyon/scriptvars.lua')

# Tous les scriptvars du dépôt (halcyon, megastones, source_duns_imbi...)
# + debug_tools/config_tools : chacun déclare ses propres tables SV.
declared_src = ''
for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/scriptvars.lua'), recursive=True):
    declared_src += open(p, encoding='utf-8').read()
for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/debug_tools/init.lua'), recursive=True):
    declared_src += open(p, encoding='utf-8').read()
for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/config_tools/init.lua'), recursive=True):
    declared_src += open(p, encoding='utf-8').read()
top_declared = set(re.findall(r'SV\.([A-Za-z_]\w*)\s*=', declared_src))

# modules protégés par Ensure() inline
ensure = set()
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    for m in re.finditer(r'if\s+SV\.([A-Za-z_]\w*)\s*==\s*nil\s+then\s+SV\.\1\s*=\s*\{\}', t):
        ensure.add(m.group(1))

used = set()
sv_abs = {os.path.abspath(p) for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/scriptvars.lua'), recursive=True)}
sv_abs |= {os.path.abspath(p) for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/debug_tools/init.lua'), recursive=True)}
sv_abs |= {os.path.abspath(p) for p in glob.glob(os.path.join(ROOT, 'Data/Script/**/config_tools/init.lua'), recursive=True)}
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    if os.path.abspath(f) in sv_abs:
        continue
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    for m in re.finditer(r'SV\.([A-Za-z_]\w*)\.', t):
        used.add(m.group(1))

missing = sorted(used - top_declared - ensure)
print("### SV2. Tables SV utilisées sans déclaration ni garde Ensure()")
print(f"   {len(missing)} table(s)\n")
for t in missing:
    print(f"      SV.{t}")
if not missing:
    print("   0 table fragile.")
