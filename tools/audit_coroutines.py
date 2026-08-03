#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_coroutines.py — detecte les appels a TASK:BranchCoroutine mal formes.

LE DEFAUT
---------
BranchCoroutine attend une FONCTION a executer plus tard. Ecrire :

    coro1 = TASK:BranchCoroutine(GAME:MoveCamera(544, 328, 112, false))

execute MoveCamera immediatement, puis passe son RESULTAT (un objet moteur,
ou nil) a BranchCoroutine. Le moteur leve alors :

    NLua.Exceptions.LuaScriptException:
      Invalid arguments to method: ScriptTask.BranchCoroutine: 18100201

et la cinematique s'arrete net. Le joueur reste bloque, souvent sur un
ecran noir, parce que le FadeIn qui suit n'est jamais atteint.

La forme correcte enveloppe l'appel :

    coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(...) end)

TROIS FORMES SONT VALIDES, et l'outil ne doit pas les confondre :
  1. BranchCoroutine(function() ... end)      lambda      -> OK
  2. BranchCoroutine(module.MaFonction)       reference   -> OK
  3. BranchCoroutine(MaFonction)              reference   -> OK
Seule la forme "appel immediat" — un identifiant suivi d'une parenthese
ouvrante — est fautive.

CAS PARTICULIER DETECTE AUSSI
-----------------------------
    TASK:BranchCoroutine({coro1, coro2, ...})
Passer une LISTE de coroutines a Branch n'a pas de sens : c'est
JoinCoroutines qui prend une liste, pour attendre la fin de toutes.
Ecrit avec Branch, le code n'attend rien et la suite se joue par-dessus.

USAGE
    python3 tools/audit_coroutines.py          # tout Data/Script
    python3 tools/audit_coroutines.py <chemin>
Sortie 1 si au moins un defaut reel est trouve.
"""
from __future__ import annotations

import glob
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# identifiant (avec . ou :) immediatement suivi d'une parenthese => appel
APPEL = re.compile(r"^\s*[A-Za-z_][\w.:]*\s*\(")
LISTE = re.compile(r"^\s*\{")


def main() -> int:
    cible = sys.argv[1] if len(sys.argv) > 1 else str(ROOT / "Data/Script")
    fichiers = sorted(glob.glob(f"{cible}/**/*.lua", recursive=True))

    appels_immediats, listes, refs, commentes = [], [], 0, 0

    for f in fichiers:
        for i, ligne in enumerate(open(f, encoding="utf-8", errors="ignore"), 1):
            if "BranchCoroutine(" not in ligne:
                continue
            if "BranchCoroutine(function" in ligne:
                continue
            if ligne.strip().startswith("--"):
                commentes += 1
                continue
            arg = ligne.split("BranchCoroutine(", 1)[1]
            rel = f.replace(str(ROOT) + "/", "").replace("Data/Script/halcyon/", "")
            if APPEL.match(arg):
                appels_immediats.append((rel, i, ligne.strip()))
            elif LISTE.match(arg):
                listes.append((rel, i, ligne.strip()))
            else:
                refs += 1

    print("=" * 78)
    print(" AUDIT DES COROUTINES — TASK:BranchCoroutine")
    print("=" * 78)
    print(f"\n  {len(fichiers)} fichier(s) Lua analyses\n")

    if appels_immediats:
        print(f"### APPEL IMMEDIAT AU LIEU D'UNE FONCTION : {len(appels_immediats)}")
        print("    (leve « Invalid arguments to method: ScriptTask.BranchCoroutine »)")
        for f, i, s in appels_immediats:
            print(f"\n  {f}:{i}")
            print(f"      {s[:110]}")
            inner = s.split("BranchCoroutine(", 1)[1].rstrip()
            if inner.endswith(")"):
                inner = inner[:-1]
            print(f"    corriger en : TASK:BranchCoroutine(function() {inner[:70]} end)")
        print()

    if listes:
        print(f"### LISTE PASSEE A BRANCH AU LIEU DE JOIN : {len(listes)}")
        print("    (n'attend rien : la suite de la scene se joue par-dessus)")
        for f, i, s in listes:
            print(f"  {f}:{i}")
            print(f"      {s[:110]}")
            print("    corriger en : TASK:JoinCoroutines({...})")
        print()

    print(f"  formes valides  : {refs} reference(s) de fonction")
    print(f"  en commentaire  : {commentes} (inertes)")

    total = len(appels_immediats) + len(listes)
    print("\n" + "=" * 78)
    if total:
        print(f" {total} DEFAUT(S) — cinematique interrompue a l'execution")
    else:
        print(" AUCUN DEFAUT DE COROUTINE")
    print("=" * 78)
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
