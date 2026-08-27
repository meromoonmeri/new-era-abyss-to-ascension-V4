#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_dungeon_population.py — Correctif CRITIQUE « étages vides » + noms.

CAUSES RACINES PROUVÉES (moteur RogueEssence/PMDC source + dungeon_eos) :
 1. Le gabarit dusk_forest clonait ConnectivityRoom.Connection=32 (BlockVault)
    sur les rooms de GridPathBranch, alors que PlaceRandomMobsStep filtre
    RoomFilterConnectivity Connection=1 (Main) → AUCUNE room éligible →
    0 Pokémon au spawn initial de l'étage (139 zones Sky).
 2. Les ContextSpawner d'items (DueSpawnStep) et de pièges
    (RandomRoomSpawnStep<EffectTile>) clonés SANS champ Amount →
    RandRange.Empty → 0 item / 0 piège posé.
 3. MoneyDivSpawner sans DivAmount → 1 seul tas d'argent.
 4. FloorNameDropZoneStep gardait le nom du gabarit (« Dusk Forest »,
    « Spiritomb Room ») → bandeau d'étage FAUX dans 195 zones.

VALEURS ROM (mappa_s.bin, sémantique dungeon_eos = code EoS désassemblé) :
 - item_density d   : nb = max(rand[d-2, d+2), 1) + 1  → RandRange
   {max(2, d-1), d+2} par étage.
 - trap_density t   : nb = rand[t/2, t]                → {t//2, max(t,t//2)}.
 - enemy_density e  : e<1 → exact |e| ; sinon rand[e/2, e) min 1
   → {max(1, e//2), max(1, e)}.
 - money : DivAmount {2,4} = convention PMDO native (MoneySpawnZoneStep
   porte déjà le montant ROM max_coin) — adaptation documentée.
 - direction ROM (DungeonRestriction EU, arm9) : 0=descente → « B{0}F »
   (fr {0}SS), 1=montée → « {0}F ».

Zones CH1-CH5 verrouillées : jamais modifiées (lockfile vérifié en amont).
"""
import copy
import glob
import gzip
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
ZONES_DIR = os.path.join(REPO, "Data", "Zone")

LOCKED = {
    "relic_forest", "illuminant_riverbed", "crooked_cavern", "apricorn_grove",
    "vast_steppe", "searing_tunnel", "mount_windswept", "cloven_ruins",
    "beginner_lesson", "petit_tunnel", "bosquet_voile", "grotte_mystere",
    "vallee_fertile", "grotte_repos", "bois_ronces", "antre_enigme",
    "carriere_cuivre", "grotte_echoue", "halles_royales", "jardin_secret",
    "foret_embuscade", "bois_filou", "normal_maze", "bug_maze",
    "electric_maze", "fire_maze", "flying_maze", "grass_maze", "rock_maze",
    "water_maze", "master_zone",
}


def load(p):
    return json.load(open(p, encoding="utf-8-sig"))


def save(p, doc):
    with open(p, "w", encoding="utf-8-sig") as fh:
        json.dump(doc, fh, ensure_ascii=False, indent=2)


def rom_floor_tables():
    """zone -> (dXX, [floors ROM])"""
    cmp_ = load(os.path.join(TABLES, "ZONE_VS_ROM_COMPARISON.json"))["zones"]
    cache = {}
    out = {}
    for zn, e in cmp_.items():
        dxx = e["dungeon"]
        if dxx not in cache:
            g = glob.glob(os.path.join(TABLES, "dungeons", f"{dxx}_*.json.gz"))
            cache[dxx] = json.load(gzip.open(g[0])) if g else None
        out[zn] = (dxx, cache[dxx])
    return out


def iter_floor_gens(fl):
    if not isinstance(fl, dict):
        return
    if "GenSteps" in fl:
        yield fl
    elif isinstance(fl.get("Spawns"), list):  # ChanceFloorGen
        for s in fl["Spawns"]:
            sp = s.get("Spawn")
            if isinstance(sp, dict) and "GenSteps" in sp:
                yield sp


def item_range(d):
    return {"Min": max(2, d - 1), "Max": max(2, d + 2)}


def trap_range(t):
    if t <= 0:
        return {"Min": 0, "Max": 0}
    return {"Min": max(0, t // 2), "Max": t}


def enemy_range(e):
    if e < 1:
        v = max(1, abs(e))
        return {"Min": v, "Max": v}
    return {"Min": max(1, e // 2), "Max": max(1, e)}


def fix_floor_gen(fg, layout, rep):
    for gs in fg.get("GenSteps", []):
        v = gs.get("Value", {})
        t = v.get("$type", "")
        if "GridPathBranch" in t or "GridPathCircle" in t:
            for key in ("RoomComponents", "HallComponents"):
                for rc in v.get(key) or []:
                    if ("ConnectivityRoom" in rc.get("$type", "")
                            and rc.get("Connection") == 32):
                        rc["Connection"] = 1
                        rep["conn"] += 1
        elif "PlaceRandomMobsStep" in t:
            sp = v.get("Spawn", {})
            if "TeamContextSpawner" in sp.get("$type", "") and layout:
                want = enemy_range(layout["initial_enemy_density"])
                if sp.get("Amount") != want:
                    sp["Amount"] = want
                    rep["mob"] += 1
        elif "DueSpawnStep" in t and "InvItem" in t:
            sp = v.get("Spawn", {})
            if "ContextSpawner" in sp.get("$type", "") and "Amount" not in sp:
                sp["Amount"] = item_range(layout["item_density"] if layout
                                          else 1)
                rep["item"] += 1
        elif "RandomRoomSpawnStep" in t and "EffectTile" in t:
            sp = v.get("Spawn", {})
            if "ContextSpawner" in sp.get("$type", "") and "Amount" not in sp:
                sp["Amount"] = trap_range(layout["trap_density"] if layout
                                          else 0)
                rep["trap"] += 1
        elif "TerminalSpawnStep" in t and "MoneySpawn" in t:
            sp = v.get("Spawn", {})
            if "MoneyDivSpawner" in sp.get("$type", "") and \
                    "DivAmount" not in sp:
                sp["DivAmount"] = {"Min": 2, "Max": 4}
                rep["money"] += 1


def main():
    roms = rom_floor_tables()
    dirs = load(os.path.join(TABLES, "DUNGEON_DIRECTIONS.json"))
    # sanity : d01 Beach Cave descend (0), d04 Mt Bristle monte (1)
    assert dirs["1"]["direction"] == 0 and dirs["4"]["direction"] == 1

    tot = {"conn": 0, "mob": 0, "item": 0, "trap": 0, "money": 0, "name": 0}
    changed = []
    for p in sorted(glob.glob(os.path.join(ZONES_DIR, "*.json"))):
        zn = os.path.basename(p)[:-5]
        if zn in LOCKED:
            continue
        doc = load(p)
        obj = doc["Object"]
        before = json.dumps(doc, sort_keys=True)
        rep = {"conn": 0, "mob": 0, "item": 0, "trap": 0, "money": 0,
               "name": 0}
        dxx, rom = roms.get(zn, (None, None))
        floors_rom = rom["floors"] if rom else None

        zname_en = obj.get("Name", {}).get("DefaultText", "")
        zname_fr = obj.get("Name", {}).get("LocalTexts", {}).get("fr", "")

        for seg in obj.get("Segments", []):
            floors = seg.get("Floors")
            if isinstance(floors, list):
                for fi, fl in enumerate(floors):
                    layout = None
                    if floors_rom:
                        layout = floors_rom[min(fi, len(floors_rom) - 1)][
                            "layout"]
                    for fg in iter_floor_gens(fl):
                        fix_floor_gen(fg, layout, rep)
            # nom d'étage canonique
            for s in seg.get("ZoneSteps", []):
                if "FloorNameDropZoneStep" not in s.get("$type", ""):
                    continue
                nm = s.get("Name", {})
                cur_en = nm.get("DefaultText", "")
                base = cur_en.split("\\n")[0]
                if not zname_en or base == zname_en:
                    continue
                if rom is not None:
                    did = str(int(dxx[1:]))
                    down = dirs.get(did, {}).get("direction", 0) == 0
                    pat_en = "B{0}F" if down else "{0}F"
                    pat_fr = "{0}SS" if down else "{0}F"
                else:
                    # zone hors tables Sky : garder le motif existant,
                    # ne corriger que le nom
                    pat_en = cur_en.split("\\n")[1] if "\\n" in cur_en \
                        else "B{0}F"
                    cur_fr = nm.get("LocalTexts", {}).get("fr", "")
                    pat_fr = cur_fr.split("\\n")[1] if "\\n" in cur_fr \
                        else pat_en
                nm["DefaultText"] = f"{zname_en}\\n{pat_en}"
                if zname_fr:
                    nm.setdefault("LocalTexts", {})["fr"] = \
                        f"{zname_fr}\\n{pat_fr}"
                elif "fr" in nm.get("LocalTexts", {}):
                    nm["LocalTexts"]["fr"] = f"{zname_en}\\n{pat_fr}"
                rep["name"] += 1

        if json.dumps(doc, sort_keys=True) != before:
            save(p, doc)
            changed.append((zn, rep))
            for k in tot:
                tot[k] += rep[k]

    print(f"zones modifiées: {len(changed)}")
    print("totaux:", tot)
    rep_p = os.path.join(REPO, "dev", "docs", "canonical",
                         "DUNGEON_POPULATION_FIX_REPORT.json")
    json.dump({"changed": {z: r for z, r in changed}, "totals": tot},
              open(rep_p, "w"), ensure_ascii=False, indent=1)
    print("rapport:", rep_p)


if __name__ == "__main__":
    main()
