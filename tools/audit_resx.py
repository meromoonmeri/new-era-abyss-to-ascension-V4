#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_resx.py — parité EN/FR des clés .resx.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_resx.py » de
~/audit/scripts/) : chaque strings.resx (EN) doit avoir son
strings.fr.resx (FR) avec EXACTEMENT les mêmes clés. Signale aussi les
clés FR sans EN (résidu de traduction).

Usage : python3 tools/audit_resx.py [racine]   (défaut: répertoire courant)
"""
import glob, os, sys
import xml.etree.ElementTree as ET

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def keys(path):
    try:
        t = ET.parse(path)
        return {e.attrib['name'] for e in t.getroot().findall('data')}
    except Exception as ex:
        return None

en_only, fr_only, missing_fr_file, parse_err = [], [], [], []
for p in glob.glob(os.path.join(ROOT, 'Data/**/strings.resx'), recursive=True):
    fr = os.path.join(os.path.dirname(p), 'strings.fr.resx')
    ke = keys(p)
    if ke is None:
        parse_err.append(os.path.relpath(p, ROOT))
        continue
    if not os.path.exists(fr):
        missing_fr_file.append(os.path.relpath(p, ROOT))
        continue
    kf = keys(fr)
    if kf is None:
        parse_err.append(os.path.relpath(fr, ROOT))
        continue
    for k in sorted(ke - kf):
        en_only.append((os.path.relpath(p, ROOT), k))
    for k in sorted(kf - ke):
        fr_only.append((os.path.relpath(fr, ROOT), k))

# aussi les stringsEx racine
for base in ('strings.resx',):
    p = os.path.join(ROOT, 'Strings', base)
    fr = os.path.join(ROOT, 'Strings', 'stringsEx.fr.resx')
    if os.path.exists(p):
        ke, kf = keys(p), keys(fr) if os.path.exists(fr) else None
        if ke is not None and kf is not None:
            for k in sorted(ke - kf):
                en_only.append((os.path.relpath(p, ROOT), k))
            for k in sorted(kf - ke):
                fr_only.append((os.path.relpath(fr, ROOT), k))

print("### R. Parité EN/FR des .resx")
print(f"\n   fichiers strings.resx sans strings.fr.resx : {len(missing_fr_file)}")
for p in missing_fr_file:
    print(f"      {p}")
print(f"\n   clés EN sans équivalent FR : {len(en_only)}")
for p, k in en_only[:40]:
    print(f"      {p} :: {k}")
if len(en_only) > 40:
    print(f"      ... et {len(en_only)-40} autres")
print(f"\n   clés FR sans équivalent EN : {len(fr_only)}")
for p, k in fr_only[:20]:
    print(f"      {p} :: {k}")
if parse_err:
    print(f"\n   fichiers illisibles : {parse_err}")
