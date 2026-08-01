#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
api_check.py — Vérificateur d'API RogueEssence (règle « ne jamais inventer une API »).

Compare chaque appel moteur des scripts Lua du mod contre deux références :
  - api_engine.json : les fonctions réellement disponibles dans le moteur
    (8 namespaces : GROUND, UI, GAME, SOUND, TASK, AI, DUNGEON, STRINGS).
  - api_usage.json : les fonctions déjà utilisées dans le projet (avec
    compteurs) — une fonction jamais utilisée ailleurs est une « première
    utilisation » à documenter, pas forcément une erreur.

Usage :
  python3 api_check.py <racine_du_mod> [--strict] [--show-all]

  --strict   : signale aussi les premières utilisations (défaut : info)
  --show-all : affiche aussi les fonctions conformes

Exceptions DOCUMENTÉES (coroutines internes / propriétés légitimes,
vérifiées dans l'audit du 30/07, RogueEssence ScriptGame.cs:314/370,
ScriptStrings.cs:15, ScriptGame.cs:18) :
  - GAME:_MoveCamera, GROUND:_CharAnimateTurnTo  (coroutines internes,
    légitimes dans un TASK:BranchCoroutine)
  - GAME:Rand, STRINGS:MapStrings                 (propriétés, pas des méthodes)
  - GROUND:EnterGroundMap                         (chemin fail-safe jamais
    atteint en jeu normal, documenté)
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ENGINE = json.load(open(os.path.join(HERE, 'api_ref', 'api_engine.json'), encoding='utf-8'))
USAGE = json.load(open(os.path.join(HERE, 'api_ref', 'api_usage.json'), encoding='utf-8'))

# Fonctions moteur normalisées : {ns: set(noms)}
ENGINE_NORM = {ns: set(funcs) for ns, funcs in ENGINE.items()}
# Fonctions déjà utilisées : {ns: set(noms sans ':')}
USAGE_NORM = {ns: set(k.rstrip(':').rstrip('.') for k in funcs) for ns, funcs in USAGE.items()}

NS = set(ENGINE_NORM.keys())

# Exceptions documentées (voir docstring) : (ns, nom)
EXCEPTIONS = {
    ('GAME', '_MoveCamera'),
    ('GROUND', '_CharAnimateTurnTo'),
    ('GAME', 'Rand'),
    ('STRINGS', 'MapStrings'),
    ('GROUND', 'EnterGroundMap'),
}


def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]--', '', src, flags=re.S)
    src = re.sub(r'--.*$', '', src, flags=re.M)
    return src


def strip_strings(src):
    """Remplace les chaînes Lua par des espaces (pour ne pas compter un nom
    d'API écrit DANS un texte comme un appel)."""
    # long strings [[...]] et [=[...]=]
    src = re.sub(r'\[(=*)\[.*?\]\1\]', lambda m: ' ' * len(m.group(0)), src, flags=re.S)
    # chaînes simples et doubles avec échappements
    out = []
    i = 0
    n = len(src)
    while i < n:
        c = src[i]
        if c in ('"', "'"):
            j = i + 1
            while j < n:
                if src[j] == '\\':
                    j += 2
                    continue
                if src[j] == c:
                    break
                j += 1
            out.append(' ' * (j - i + 1))
            i = j + 1
        else:
            out.append(c)
            i += 1
    return ''.join(out)


def extract_calls(src):
    """Extrait (ns, nom) des appels moteur : NS:Fonction( et NS.Propriété."""
    calls = []
    # appels de méthode : NS:Fonction(
    for m in re.finditer(r'\b(' + '|'.join(NS) + r'):([A-Za-z_]\w*)\s*\(', src):
        calls.append((m.group(1), m.group(2)))
    # propriétés : NS.Prop (GAME.Rand, STRINGS.MapStrings)
    for m in re.finditer(r'\b(' + '|'.join(NS) + r')\.([A-Za-z_]\w*)\b', src):
        calls.append((m.group(1), m.group(2)))
    return calls


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    strict = '--strict' in sys.argv
    show_all = '--show-all' in sys.argv

    invents = []       # absentes de l'engine ET pas dans les exceptions
    first_uses = []    # présentes dans l'engine mais jamais utilisées ailleurs
    unknown_ns = []    # namespace moteur inconnu (ne devrait pas arriver)
    total_calls = 0

    lua_files = []
    for dirpath, _, filenames in os.walk(root):
        if 'node_modules' in dirpath:
            continue
        for fn in filenames:
            if fn.endswith('.lua'):
                lua_files.append(os.path.join(dirpath, fn))

    for path in sorted(lua_files):
        with open(path, encoding='utf-8') as f:
            src = strip_comments(f.read())
            src = strip_strings(src)
        for ns, name in extract_calls(src):
            total_calls += 1
            if ns not in ENGINE_NORM:
                unknown_ns.append((path, ns, name))
                continue
            if name not in ENGINE_NORM[ns]:
                if (ns, name) not in EXCEPTIONS:
                    invents.append((path, ns, name))
            elif name not in USAGE_NORM.get(ns, set()) and name not in ('Rand', 'MapStrings', '_MoveCamera', '_CharAnimateTurnTo'):
                first_uses.append((path, ns, name))

    print(f'Fichiers analysés : {len(lua_files)}')
    print(f'Appels moteur détectés : {total_calls}')
    print()

    if unknown_ns:
        print(f'⚠️  Namespaces inconnus ({len(unknown_ns)}) :')
        for p, ns, n in unknown_ns[:10]:
            print(f'   {p}: {ns}:{n}')
        print()

    if invents:
        print(f'❌ INVENTIONS SUSPECTES ({len(invents)}) — absentes de l\'engine, hors exceptions :')
        for p, ns, n in invents[:30]:
            print(f'   {p}: {ns}:{n}')
        print()
    else:
        print('✅ Aucune invention d\'API (tout appel appartient à l\'engine ou aux exceptions documentées)')
        print()

    if first_uses:
        print(f'ℹ️  Premières utilisations ({len(first_uses)}) — présentes dans l\'engine mais jamais utilisées ailleurs dans le projet :')
        for p, ns, n in first_uses[:30]:
            print(f'   {p}: {ns}:{n}')
        print()
    else:
        print('✅ Aucune première utilisation (tout appel a déjà été utilisé ailleurs)')
        print()

    if show_all:
        print('--- Détail conforme (extrait) ---')
        seen = set()
        for path in sorted(lua_files):
            with open(path, encoding='utf-8') as f:
                src = strip_strings(strip_comments(f.read()))
            for ns, name in extract_calls(src):
                if (ns, name) not in seen:
                    seen.add((ns, name))
                    print(f'   {ns}:{name}')

    ok = not invents and not unknown_ns
    print('VERDICT :', 'OK' if ok else 'À CORRIGER')
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
