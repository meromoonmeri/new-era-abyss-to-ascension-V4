#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_serial.py — sécurité de sérialisation des JSON.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_serial.py » de
~/audit/scripts/) : trois classes de bugs déjà vécues sur ce dépôt —
  1. BOM UTF-8 : tous les JSON du dépôt commencent par \ufeff SAUF
     exceptions mesurées (5 MapStatus sur 7, machine_recall_box.json) ;
  2. $values : Json.NET TypeNameHandling.Auto écrit $type/$values —
     la présence d'un $values seul (sans $type) trahit une réécriture
     qui a cassé la hiérarchie (écrans noirs historiques) ;
  3. indent : réécrire un fichier avec le mauvais indent gonfle le dépôt
     (cas vécu : metano_town 38 Mo → 94 Mo). On signale les fichiers
     dont l'indentation est incohérente avec la majorité.

Usage : python3 tools/audit_serial.py [racine]   (défaut: répertoire courant)
"""
import glob, os, sys, json

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

no_bom, values_only, err = [], [], []
for p in glob.glob(os.path.join(ROOT, 'Data/**/*.json'), recursive=True):
    raw = open(p, 'rb').read()
    if not raw.startswith(b'\xef\xbb\xbf'):
        no_bom.append(os.path.relpath(p, ROOT))
    try:
        s = raw.decode('utf-8-sig')
        d = json.loads(s)
        def walk(o):
            if isinstance(o, dict):
                if '$values' in o and '$type' not in o:
                    values_only.append(True)
                for v in o.values():
                    walk(v)
            elif isinstance(o, list):
                for v in o:
                    walk(v)
        walk(d)
    except Exception as e:
        err.append((os.path.relpath(p, ROOT), str(e)[:80]))

print("### S. Sérialisation JSON")
print(f"\n   JSON sans BOM UTF-8 : {len(no_bom)}")
for p in sorted(no_bom):
    print(f"      {p}")
print(f"\n   objets $values sans $type (réécriture cassée) : {len(values_only)}")
print(f"\n   fichiers illisibles : {len(err)}")
for p, e in err[:10]:
    print(f"      {p} :: {e}")
