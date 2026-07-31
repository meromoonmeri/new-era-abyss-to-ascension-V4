#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_cutscene_exit.py — CutsceneMode(true) jamais désarmé.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_cut2.py » de
~/audit/scripts/) : un CutsceneMode(true) sans CutsceneMode(false)
atteignable fige le joueur définitivement (Save.CutsceneMode persistant,
GroundScene.cs:176 — la classe de bug B1, gel de metano_normal_home ch5).

Une fonction est considérée sûre si, dans son corps OU par suivi des
appels de fonctions (profondeur 5), elle contient :
  - CutsceneMode(false), ou
  - un changement de carte (EnterGroundMap/EnterDungeon/EnterZone/
    ContinueDungeon/EndDungeonRun/RestartToTitle).

Usage : python3 tools/audit_cutscene_exit.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, collections, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

def extract_bodies(t):
    """Découpe les corps de fonctions en équilibrant les `end` : un corps
    s'arrête au `end` qui referme SON function, pas au premier `end` d'un
    bloc interne (sinon les désarmements situés après un if/pcall interne
    deviennent invisibles)."""
    out = []
    for m in re.finditer(r'function\s+([\w\.:]+)\s*\([^)]*\)', t):
        name, start = m.group(1), m.end()
        depth = 1
        i = start
        while i < len(t) and depth > 0:
            nxt = t.find('\nend', i)
            if nxt < 0:
                break
            # compter les `end` entre start et nxt (tous au même niveau
            # d'indentation au début de ligne)
            j = start
            while True:
                e = t.find('\nend', j)
                if e < 0 or e > nxt:
                    break
                depth -= 1
                j = e + 4
                if depth == 0:
                    break
            if depth == 0:
                out.append((name, t[start:nxt + 1]))
                break
            # sinon il y avait des `function` imbriqués entre les deux
            # — compter les ouvertures
            depth += len(re.findall(r'\nfunction\s+', t[i:nxt]))
            i = nxt + 4
    return out

bodies = {}
for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = open(f, encoding='utf-8', errors='replace').read()
    t = re.sub(r'--\[\[.*?\]\]', '', t, flags=re.S)
    t = re.sub(r'--[^\n]*', '', t)
    for name, body in extract_bodies(t):
        bodies.setdefault(name, []).append((os.path.relpath(f, ROOT), body))

def resolves(fn, depth=0, seen=None):
    seen = seen or set()
    if fn in seen or depth > 5:
        return False
    seen.add(fn)
    for _, b in bodies.get(fn, []):
        if re.search(r'CutsceneMode\(\s*false\s*\)', b):
            return True
        if re.search(r'EnterGroundMap|EnterDungeon|EnterZone|ContinueDungeon|EndDungeonRun|RestartToTitle', b):
            return True
        for m in re.finditer(r'\b([\w]+)\.(\w+)\s*\(', b):
            c = m.group(1) + '.' + m.group(2)
            if c in bodies and resolves(c, depth + 1, seen):
                return True
    return False

def caller_disarms_after(fn, depth=0, seen=None):
    """Vrai si CHAQUE appelant de fn désarme (CutsceneMode(false)) ou
    change de carte APRÈS l'appel — le mode cinématique ne peut donc pas
    rester actif quand fn rend la main. On scanne TOUT le corps restant
    de l'appelant (pas tronqué au premier `end` interne), et on suit
    aussi les CALLEES de l'appelant (ex. MorningAddress → PostAddress
    Scripting → CutsceneMode(false))."""
    seen = seen or set()
    if fn in seen or depth > 4:
        return False
    seen.add(fn)
    callers = []
    for caller, lst in bodies.items():
        if caller == fn:
            continue
        for _, b in lst:
            for m in re.finditer(r'\b' + re.escape(fn) + r'\s*\(', b):
                after = b[m.end():]
                ok = False
                if re.search(r'CutsceneMode\(\s*false\s*\)', after):
                    ok = True
                elif re.search(r'EnterGroundMap|EnterDungeon|EnterZone|ContinueDungeon|EndDungeonRun|RestartToTitle', after):
                    ok = True
                else:
                    # une callee de l'appelant désarme-t-elle ? (suivi
                    # récursif sur les appels présents APRÈS l'appel)
                    for mm in re.finditer(r'\b([\w]+)\.(\w+)\s*\(', after):
                        c = mm.group(1) + '.' + mm.group(2)
                        if c in bodies and resolves(c, 1, {fn, caller}):
                            ok = True
                            break
                if not ok and caller_disarms_after(caller, depth + 1, seen):
                    ok = True
                callers.append(ok)
    if not callers:
        return None  # jamais appelée par du Lua : callback moteur ou code mort
    return all(callers)

def disarms_via_wrapper(fn, seen=None):
    """Le patron `pcall(DefeatedBossBody)` : le wrapper `DefeatedBoss`
    désarme CutsceneMode APRÈS le pcall — le corps est donc sûr."""
    seen = seen or set()
    if fn in seen:
        return False
    seen.add(fn)
    for caller, lst in bodies.items():
        if caller == fn:
            continue
        for _, b in lst:
            # pcall(NomBare) ou pcall(function() ... NomBare() ... end)
            if re.search(r'pcall\(\s*' + re.escape(fn) + r'\s*\)', b):
                if re.search(r'CutsceneMode\(\s*false\s*\)', b):
                    return True
                if disarms_via_wrapper(caller, seen):
                    return True
            if re.search(r'pcall\(function\(\)', b) and re.search(r'\b' + re.escape(fn) + r'\s*\(', b):
                if re.search(r'CutsceneMode\(\s*false\s*\)', b):
                    return True
    return False

bad = []
for fn, lst in bodies.items():
    for path, b in lst:
        if re.search(r'CutsceneMode\(\s*true\s*\)', b) and not re.search(r'CutsceneMode\(\s*false\s*\)', b):
            if re.search(r'EnterGroundMap|EnterDungeon|EnterZone|ContinueDungeon|EndDungeonRun|RestartToTitle', b):
                continue
            ok = False
            for m in re.finditer(r'\b([\w]+)\.(\w+)\s*\(', b):
                c = m.group(1) + '.' + m.group(2)
                if c in bodies and resolves(c, 1, {fn}):
                    ok = True
                    break
            if not ok and disarms_via_wrapper(fn):
                ok = True
            caller_state = caller_disarms_after(fn)
            if caller_state is True:
                ok = True
            if caller_state is None:
                # jamais appelée par du Lua : callback moteur (Init/Enter/
                # GameLoad...) ou code mort (AnimationTest). Pas un gel
                # possible en jeu — on écarte.
                ok = True
            if not ok:
                bad.append((path, fn))

print("### K1(affine). CutsceneMode(true) sans desarmement atteignable (suivi d'appels prof. 5)")
print(f"   {len(bad)} fonctions\n")
for p, f in sorted(bad):
    print(f"   {p} :: {f}")
