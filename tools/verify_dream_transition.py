#!/usr/bin/env python3
"""Verification statique de la transition reve (Mont Venteux -> hero_dream -> Mont)."""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FAIL = []

def check(cond, msg):
    print(("  [OK]   " if cond else "  [FAIL] ") + msg)
    if not cond:
        FAIL.append(msg)

def main():
    print("== Verification transition reve ==")
    mz = os.path.join(ROOT, "Data", "Zone", "master_zone.json")
    check(os.path.isfile(mz), "master_zone.json present")
    grounds = []
    try:
        with open(mz, "r", encoding="utf-8") as f:
            data = json.load(f)
        def collect(o):
            if isinstance(o, dict):
                for v in o.values(): collect(v)
            elif isinstance(o, list):
                for v in o:
                    if isinstance(v, str): grounds.append(v)
                    else: collect(v)
        collect(data)
    except Exception as e:
        print("    (JSON: %s)" % e)
    check("hero_dream" in grounds, "hero_dream enregistre dans master_zone.json")
    check("mount_windswept_entrance" in grounds, "mount_windswept_entrance enregistre")
    check("songe_source" not in grounds, "pas de 'songe_source' orphelin")

    rsg = os.path.join(ROOT, "Data", "Ground", "hero_dream.rsground")
    check(os.path.isfile(rsg), "hero_dream.rsground present")
    if os.path.isfile(rsg):
        with open(rsg, "rb") as f: blob = f.read()
        check(b"Main_Entrance_Marker" in blob, "marqueur 'Main_Entrance_Marker' present")

    init = os.path.join(ROOT, "Data", "Script", "halcyon", "ground", "hero_dream", "init.lua")
    check(os.path.isfile(init), "hero_dream/init.lua present")
    src = ""
    if os.path.isfile(init):
        with open(init, "r", encoding="utf-8") as f: src = f.read()
        check("GAME:CutsceneMode(true)" in src, "Init pose CutsceneMode(true)")
        check("function hero_dream.DreamScene()" in src, "DreamScene() existe")
        check("pcall(DreamSceneBody)" in src, "corps de scene sous pcall")
        check("GAME:EnterGroundMap('mount_windswept_entrance'" in src, "retour always vers camp")
        check(src.count("EnterGroundMap('hero_dream'") == 0, "pas de boucle hero_dream")

    script_dir = os.path.join(ROOT, "Data", "Script")
    stale = []
    for dp, _, fns in os.walk(script_dir):
        for fn in fns:
            if fn.endswith(".lua"):
                p = os.path.join(dp, fn)
                try:
                    with open(p, "r", encoding="utf-8", errors="ignore") as f:
                        if "songe_source" in f.read(): stale.append(os.path.relpath(p, ROOT))
                except Exception: pass
    check(len(stale) == 0, "aucune reference 'songe_source'" + ("" if not stale else " -> " + ",".join(stale)))

    camp = os.path.join(ROOT, "Data", "Script", "halcyon", "ground", "mount_windswept_entrance", "mount_windswept_entrance_ch_5.lua")
    if os.path.isfile(camp):
        with open(camp, "r", encoding="utf-8") as f: cs = f.read()
        check("EnterGroundMap('hero_dream', 'Main_Entrance_Marker', false)" in cs,
              "CampNightfall -> hero_dream avec preserve=false (pas de doublon PLAYER)")
        check("SV.Chapter5.DreamSceneSeen = true" in cs and "EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker', false)" in cs,
              "repli camp sur echec (preserve=false)")

    print("")
    if FAIL:
        print("RESULTAT : %d invariant(s) NON satisfait(s)." % len(FAIL))
        for m in FAIL: print("   - " + m)
        return 1
    print("RESULTAT : TOUS LES INVARIANTS SATISFAITS.")
    print("Fix applique : preserve=false sur les 2 transitions du reve -> plus de")
    print("doublon d'entite PLAYER -> plus de NullReferenceException en ProcessInput.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
