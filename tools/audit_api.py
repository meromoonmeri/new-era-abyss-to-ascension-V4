#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_api.py — surface moteur vs appels Lua du mod.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_api.py » de
~/audit/scripts/) : liste les membres `NOMESPACE:Fonction` appelés par le
mod qui n'existent PAS dans la référence officielle PMDO
(PMDODump/DataAsset/Docs/Script.txt, 255 fonctions — copie locale dans
tools/data/pmdo_script_api.txt).

Règle projet (PASSATION §2.2) : ne jamais inventer une API. Zéro
occurrence hors du fichier courant = invention. Cet outil automatise le
contrôle. Les fausses alertes connues (déjà documentées par l'audit) :
  - GAME:_MoveCamera / GROUND:_CharAnimateTurnTo = coroutines internes
    légitimes dans un BranchCoroutine
  - STRINGS.MapStrings (propriété), GAME.Rand (champ)
  - appels en commentaire (retirés avant analyse)

Usage : python3 tools/audit_api.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

# --- référence officielle (copie locale) ---
REF = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'pmdo_script_api.txt')
allowed = set()
if os.path.exists(REF):
    txt = open(REF, encoding='utf-8').read()
    for m in re.finditer(r'^==\s*([A-Z_]+):([A-Za-z_]\w*)\s*(?:\([^=]*\))?\s*==', txt, re.M):
        allowed.add((m.group(1), m.group(2)))
else:
    print(f"AVERTISSEMENT : référence absente ({REF}) — pas de contrôle API possible.")
    sys.exit(0)

# --- globaux du moteur qui ne sont PAS des namespaces API ---
NS = {'GAME', 'GROUND', 'UI', 'SOUND', 'AI', 'DUNGEON', 'STRINGS', 'TASK'}
# membres autorisés mais absents de Script.txt — vérifiés dans le code
# moteur RogueEssence (audit 2026-07-30 §5) :
#   GAME:FadeInFront / FadeOutFront : coroutines de fondu du calque texte
#     (ScriptGame.cs — GeneralFunctions.lua:1857/1870, patron DeathFadeOut)
#   GROUND:ActionToPosition : variante de _AnimateToPosition
#     (ScriptGround.cs, attesté apricorn_glade_ch_4.lua:256)
#   GROUND:EnterGroundMap : chemin fail-safe jamais atteint en jeu normal
#     (personality_test/init.lua:75 — documenté par l'audit)
#   GAME:_MoveCamera / GROUND:_CharAnimateTurnTo : coroutines internes
#     légitimes dans un BranchCoroutine
#   GAME.Rand / STRINGS.MapStrings : propriétés (ScriptGame.cs:18,
#     ScriptStrings.cs:15)
EXTRA_OK = {
    ('GAME', 'Rand'), ('GAME', '_MoveCamera'),
    ('GAME', 'FadeInFront'), ('GAME', 'FadeOutFront'),
    ('GROUND', '_CharAnimateTurnTo'), ('GROUND', '_CharAnimateTurn'),
    ('GROUND', 'ActionToPosition'), ('GROUND', 'EnterGroundMap'),
    ('STRINGS', 'MapStrings'),
}

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

found = {}
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    for m in re.finditer(r'\b(GAME|GROUND|UI|SOUND|AI|DUNGEON|STRINGS|TASK):([A-Za-z_]\w*)\s*\(', t):
        found.setdefault((m.group(1), m.group(2)), set()).add(os.path.relpath(f, ROOT))

missing = sorted(((ns, fn), locs) for (ns, fn), locs in found.items()
                 if (ns, fn) not in allowed and (ns, fn) not in EXTRA_OK)

print("### A. Membres moteur appelés ABSENTS de la référence PMDO (Script.txt)")
print(f"   {len(found)} membres distincts appelés · {len(missing)} non référencés\n")
for (ns, fn), locs in missing:
    ex = sorted(locs)[0]
    print(f"   {ns}:{fn}  <- {ex}" + (f" (+{len(locs)-1})" if len(locs) > 1 else ""))
if not missing:
    print("   0 invention d'API.")
