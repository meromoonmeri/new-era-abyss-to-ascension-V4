#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_red_dungeon_population.py — 38 zones Red : GenSteps de placement.

CAUSE RACINE : 38 zones procédurales Red (GridFloorGen) possèdent les
TABLES de spawn (TeamSpawnZoneStep/ItemSpawnZoneStep/MoneySpawnZoneStep au
niveau zone) mais AUCUN GenStep de PLACEMENT par étage
(PlaceRandomMobsStep / DueSpawnStep<InvItem> / TerminalSpawnStep<MoneySpawn>
/ RandomRoomSpawnStep<EffectTile>). Résultat runtime prouvé (dprobe) :
magma_cavern étage 1-2 = 0 mob, 0 item.

AUTORITÉ ROM : pret pmd-red data/dungeon/main_data.inc (FloorProperties
28 octets, offsets str_dungeon.h : enemyDensity=6, itemDensity=15,
trapDensity=16) × floor_id.json par donjon. Sémantique dungeon_generation.c :
  items  : n = DungeonRandRange(d-2, d+2), min 1 ;
  enemies: n = DungeonRandRange(e/2, e), min 1 (e>0) ; e==0 -> aucun ;
  traps  : n = DungeonRandRange(t/2, t).
Gabarit des steps : tiny_woods (zone Red déjà fonctionnelle, prouvée
dprobe 4 mobs/2 items/1 piège étage 1).
"""
import copy
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference", "data",
                    "dungeon")
ZONES = os.path.join(REPO, "Data", "Zone")

ZONE2PRET = {
    'buried_relic': 'BuriedRelic', 'darknight_relic': 'DarknightRelic',
    'desert_region': 'DesertRegion', 'fantasy_strait': 'FantasyStrait',
    'far_off_sea': 'FaroffSea', 'fiery_field': 'FieryField',
    'frosty_forest': 'FrostyForest', 'frosty_grotto': 'FrostyGrotto',
    'grand_sea': 'GrandSea', 'howling_forest': 'HowlingForest',
    'joyous_tower': 'JoyousTower', 'lightning_field': 'LightningField',
    'magma_cavern': 'MagmaCavern', 'magma_cavern_pit': 'MagmaCavernPit',
    'marvelous_sea': 'MarvelousSea', 'meteor_cave': 'MeteorCave',
    'mt_faraway': 'MtFaraway', 'murky_cave': 'MurkyCave',
    'northern_range': 'NorthernRange', 'northwind_field': 'NorthwindField',
    'oddity_cave': 'OddityCave', 'pitfall_valley': 'PitfallValley',
    'purity_forest': 'PurityForest', 'remains_island': 'RemainsIsland',
    'rock_path': 'RockPath', 'silver_trench': 'SilverTrench',
    'sky_tower': 'SkyTower', 'sky_tower_summit': 'SkyTowerSummit',
    'snow_path': 'SnowPath', 'solar_cave': 'SolarCave',
    'southern_cavern': 'SouthernCavern', 'stormy_sea': 'StormySea',
    'unown_relic': 'UnownRelic', 'uproar_forest': 'UproarForest',
    'waterfall_pond': 'WaterfallPond', 'western_cave': 'WesternCave',
    'wish_cave': 'WishCave', 'wyvern_hill': 'WyvernHill',
}

MGC = "RogueEssence.LevelGen.MapGenContext, RogueEssence"


def parse_floorprops():
    stream = []

    def rec(path):
        for line in open(path):
            line = line.strip()
            m = re.match(r'#include\s+"([^"]+)"', line)
            if m:
                rec(os.path.join(PRET, m.group(1)))
            elif line.startswith('.byte'):
                stream.extend(int(x, 16) for x in
                              re.findall(r'0x([0-9a-fA-F]{2})', line))
    rec(os.path.join(PRET, 'main_data.inc'))
    assert len(stream) % 28 == 0
    return [stream[i:i + 28] for i in range(0, len(stream), 28)]


def mob_step(e):
    lo, hi = (max(1, e // 2), max(1, e)) if e > 0 else (0, 0)
    return {"Key": {"str": [6, 2]}, "Value": {
        "$type": f"RogueEssence.LevelGen.PlaceRandomMobsStep`1[[{MGC}]], RogueEssence",
        "Filters": [
            {"$type": "PMDC.LevelGen.RoomFilterConnectivity, PMDC",
             "Connection": 1},
            {"$type": "RogueElements.RoomFilterComponent, RogueElements",
             "Negate": True,
             "Components": [{"$type": "PMDC.LevelGen.BossRoom, PMDC"}]}],
        "IncludeHalls": False,
        "Spawn": {
            "$type": f"RogueEssence.LevelGen.TeamContextSpawner`1[[{MGC}]], RogueEssence",
            "Amount": {"Min": lo, "Max": hi}},
        "Ally": False, "ClumpFactor": 20}}


def item_step(d):
    lo, hi = (max(1, d - 2), max(2, d + 2)) if d > 0 else (1, 2)
    return {"Key": {"str": [6, 1]}, "Value": {
        "$type": f"RogueElements.DueSpawnStep`3[[{MGC}],"
                 f"[RogueEssence.Dungeon.InvItem, RogueEssence],"
                 f"[RogueEssence.LevelGen.MapGenEntrance, RogueEssence]], RogueElements",
        "SuccessPercent": 25, "IncludeHalls": False, "Filters": [],
        "Spawn": {
            "$type": f"RogueElements.ContextSpawner`2[[{MGC}],"
                     f"[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueElements",
            "Amount": {"Min": lo, "Max": hi}}}}


def money_step():
    return {"Key": {"str": [6]}, "Value": {
        "$type": f"RogueElements.TerminalSpawnStep`2[[{MGC}],"
                 f"[RogueEssence.LevelGen.MoneySpawn, RogueEssence]], RogueElements",
        "IncludeHalls": False, "Filters": [],
        "Spawn": {
            "$type": f"RogueEssence.LevelGen.MoneyDivSpawner`1[[{MGC}]], RogueEssence",
            "DivAmount": {"Min": 2, "Max": 4}}}}


def trap_step(t):
    lo, hi = (max(0, t // 2), t) if t > 0 else (0, 0)
    return {"Key": {"str": [5]}, "Value": {
        "$type": f"RogueElements.RandomRoomSpawnStep`2[[{MGC}],"
                 f"[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
        "SuccessPercent": 100, "IncludeHalls": False, "Filters": [],
        "Spawn": {
            "$type": f"RogueElements.ContextSpawner`2[[{MGC}],"
                     f"[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements",
            "Amount": {"Min": lo, "Max": hi}}}}


def main():
    props = parse_floorprops()
    changed = {}
    for zn, pret_dir in sorted(ZONE2PRET.items()):
        fid_p = os.path.join(PRET, pret_dir, 'floor_id.json')
        tables = json.load(open(fid_p))['tables']
        zp = os.path.join(ZONES, f'{zn}.json')
        doc = json.load(open(zp, encoding='utf-8-sig'))
        obj = doc['Object']
        gfloor = 0
        rep = {"mob": 0, "item": 0, "money": 0, "trap": 0}
        for seg in obj.get('Segments', []):
            zsteps = seg.get('ZoneSteps', [])
            has_team = any('TeamSpawnZoneStep' in s.get('$type', '')
                           for s in zsteps)
            has_item = any('ItemSpawnZoneStep' in s.get('$type', '')
                           for s in zsteps)
            has_money = any('MoneySpawnZoneStep' in s.get('$type', '')
                            for s in zsteps)
            has_tile = any('TileSpawnZoneStep' in s.get('$type', '')
                           for s in zsteps)
            floors = seg.get('Floors')
            if not isinstance(floors, list):
                continue
            for fl in floors:
                if gfloor >= len(tables):
                    break
                r = props[tables[gfloor]['MainData']]
                enemy, item, trap = r[6], r[15], r[16]
                gfloor += 1
                if not isinstance(fl, dict) or 'GenSteps' not in fl:
                    continue
                steps = fl['GenSteps']
                types = [gs.get('Value', {}).get('$type', '')
                         for gs in steps]
                if has_team and not any('PlaceRandomMobsStep' in t
                                        for t in types):
                    steps.append(mob_step(enemy))
                    rep['mob'] += 1
                if has_item and not any('DueSpawnStep' in t and
                                        'InvItem' in t for t in types):
                    steps.append(item_step(item))
                    rep['item'] += 1
                if has_money and not any('TerminalSpawnStep' in t and
                                         'MoneySpawn' in t for t in types):
                    steps.append(money_step())
                    rep['money'] += 1
                if has_tile and trap > 0 and not any(
                        'RandomRoomSpawnStep' in t and 'EffectTile' in t
                        for t in types):
                    steps.append(trap_step(trap))
                    rep['trap'] += 1
        if any(rep.values()):
            with open(zp, 'w', encoding='utf-8-sig') as fh:
                json.dump(doc, fh, ensure_ascii=False, indent=2)
            changed[zn] = rep
    tot = {k: sum(r[k] for r in changed.values())
           for k in ("mob", "item", "money", "trap")}
    print(f"zones modifiées: {len(changed)}  totaux: {tot}")
    out = os.path.join(REPO, "dev", "docs", "canonical",
                       "RED_POPULATION_FIX_REPORT.json")
    json.dump({"changed": changed, "totals": tot}, open(out, 'w'),
              ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == "__main__":
    main()
