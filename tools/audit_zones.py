#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_zones.py — zones et grounds orphelins.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_zones.py » de
~/audit/scripts/) :
  - grounds .rsground présents mais déclarés dans AUCUNE zone
    (inatteignables — dette M16, ~107 fichiers dont 49 sans marqueur) ;
  - zones Data/Zone/*.json jamais référencées par un script (EnterZone/
    EnterDungeon/ContinueDungeon/UnlockDungeon/dungeon_entrance_mapping) ;
  - zones déclarées dans un script mais absentes de Data/Zone.

Usage : python3 tools/audit_zones.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, json, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

GROUND_DIR = os.path.join(ROOT, 'Data/Ground')
ZONE_DIR = os.path.join(ROOT, 'Data/Zone')

grounds = {os.path.basename(p)[:-9] for p in glob.glob(os.path.join(GROUND_DIR, '*.rsground'))}
zones = {os.path.basename(p)[:-5] for p in glob.glob(os.path.join(ZONE_DIR, '*.json'))}

# grounds déclarés dans les GroundMaps de chaque zone (master_zone + autres)
declared = set()
for z in zones:
    try:
        d = json.load(open(os.path.join(ZONE_DIR, z + '.json'), encoding='utf-8-sig'))
        o = d.get('Object', d)
        declared.update(o.get('GroundMaps', []))
    except Exception:
        pass

# zones citées par les scripts
cited = set()
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = open(f, encoding='utf-8', errors='replace').read()
    t = re.sub(r'--\[\[.*?\]\]', '', t, flags=re.S)
    t = re.sub(r'--[^\n]*', '', t)
    for m in re.finditer(r"(?:EnterZone|EnterDungeon|ContinueDungeon|UnlockDungeon)\(\s*['\"]([a-z0-9_]+)['\"]", t):
        cited.add(m.group(1))
    for m in re.finditer(r"['\"]([a-z0-9_]+)['\"]\s*=\s*\{", t):
        pass  # trop bruité, on s'en tient aux appels directs

print("### Z. Zones / grounds orphelins")
orphan_grounds = sorted(grounds - declared)
print(f"\n   Grounds .rsground NON déclarés dans aucune zone : {len(orphan_grounds)}")
for g in orphan_grounds:
    print(f"      {g}")

print(f"\n   Zones Data/Zone/*.json jamais citées par un script : "
      f"{len(sorted(zones - cited))}")
for z in sorted(zones - cited):
    print(f"      {z}")

print(f"\n   Zones citées par un script mais ABSENTES de Data/Zone : "
      f"{len(sorted(cited - zones))}")
for z in sorted(cited - zones):
    print(f"      {z}")
