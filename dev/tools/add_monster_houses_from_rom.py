#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""add_monster_houses_from_rom.py — Maisons de Monstres canoniques.

CAUSE : les gabarits de zones ne portaient pas SpreadHouseZoneStep alors
que la ROM donne un monster_house_chance>0 pour la plupart des étages
(Sky mappa_s.bin : 1223/1795 étages ; Red pret FloorProperties offset 8).
Résultat : jamais de Maison de Monstres en jeu.

CORRECTIF (convention vanilla PMDO, cf. copper_quarry/champions_road :
Mobs=[] + MobThemeNone => la maison puise dans le POOL DE SPAWN DE
L'ÉTAGE, donc espèces canoniques par étage automatiquement) :
 - SpreadPlanChance avec le POURCENTAGE ROM (moyenne des étages où
   chance>0) et FloorRange = plage réelle des étages concernés ;
 - MobThemeNone Amount {7,13} / ItemThemeNone {2,4} (valeurs du step
   déjà runtime-validé magma_cavern) ;
 - items de la maison = pool d'items de l'étage (Items=[]).
Aucune zone verrouillée CH1-5 modifiée.
"""
import glob
import gzip
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                      "Tables")
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference", "data",
                    "dungeon")

LOCKED = {
    "relic_forest", "illuminant_riverbed", "crooked_cavern",
    "apricorn_grove", "vast_steppe", "searing_tunnel", "mount_windswept",
    "cloven_ruins", "beginner_lesson", "petit_tunnel", "bosquet_voile",
    "grotte_mystere", "vallee_fertile", "grotte_repos", "bois_ronces",
    "antre_enigme", "carriere_cuivre", "grotte_echoue", "halles_royales",
    "jardin_secret", "foret_embuscade", "bois_filou", "normal_maze",
    "bug_maze", "electric_maze", "fire_maze", "flying_maze", "grass_maze",
    "rock_maze", "water_maze", "master_zone",
}

RED_Z2P = {
    'tiny_woods': 'TinyWoods', 'thunderwave_cave': 'ThunderwaveCave',
    'mt_steel': 'MtSteel', 'gloomy_forest': 'SinisterWoods',
    'silent_chasm': 'SilentChasm', 'mt_thunder': 'MtThunder',
    'mt_thunder_peak': 'MtThunderPeak', 'great_canyon': 'GreatCanyon',
    'lapis_cave': 'LapisCave', 'mt_blaze': 'MtBlaze',
    'mt_blaze_peak': 'MtBlazePeak', 'frosty_forest': 'FrostyForest',
    'frosty_grotto': 'FrostyGrotto', 'mt_freeze': 'MtFreeze',
    'mt_freeze_peak': 'MtFreezePeak', 'magma_cavern': 'MagmaCavern',
    'magma_cavern_pit': 'MagmaCavernPit', 'sky_tower': 'SkyTower',
    'sky_tower_summit': 'SkyTowerSummit', 'stormy_sea': 'StormySea',
    'silver_trench': 'SilverTrench', 'meteor_cave': 'MeteorCave',
    'buried_relic': 'BuriedRelic', 'darknight_relic': 'DarknightRelic',
    'desert_region': 'DesertRegion', 'fantasy_strait': 'FantasyStrait',
    'far_off_sea': 'FaroffSea', 'fiery_field': 'FieryField',
    'grand_sea': 'GrandSea', 'howling_forest': 'HowlingForest',
    'joyous_tower': 'JoyousTower', 'lightning_field': 'LightningField',
    'marvelous_sea': 'MarvelousSea', 'mt_faraway': 'MtFaraway',
    'murky_cave': 'MurkyCave', 'northern_range': 'NorthernRange',
    'northwind_field': 'NorthwindField', 'oddity_cave': 'OddityCave',
    'pitfall_valley': 'PitfallValley', 'purity_forest': 'PurityForest',
    'remains_island': 'RemainsIsland', 'rock_path': 'RockPath',
    'snow_path': 'SnowPath', 'solar_cave': 'SolarCave',
    'southern_cavern': 'SouthernCavern', 'unown_relic': 'UnownRelic',
    'uproar_forest': 'UproarForest', 'waterfall_pond': 'WaterfallPond',
    'western_cave': 'WesternCave', 'wish_cave': 'WishCave',
    'wyvern_hill': 'WyvernHill',
}


def house_step(chance, lo, hi):
    return {
        "$type": "PMDC.LevelGen.SpreadHouseZoneStep, PMDC",
        "Priority": {"str": [4, 1]},
        "HouseStepSpawns": [{
            "Spawn": {
                "$type": "PMDC.LevelGen.MonsterHouseStep`1[["
                         "RogueEssence.LevelGen.ListMapGenContext, "
                         "RogueEssence]], PMDC",
                "Filters": [{
                    "$type": "RogueElements.RoomFilterComponent, "
                             "RogueElements",
                    "Negate": True,
                    "Components": [
                        {"$type": "RogueEssence.LevelGen.ImmutableRoom, "
                                  "RogueEssence"},
                        {"$type": "PMDC.LevelGen.NoEventRoom, PMDC"}]}],
                "Items": [], "ItemThemes": [], "Mobs": [],
                "MobThemes": []},
            "Rate": 10}],
        "Items": [],
        "ItemThemes": [{
            "Spawn": {"$type": "PMDC.LevelGen.ItemThemeNone, PMDC",
                      "SpecialRatio": 40, "Amount": {"Min": 2, "Max": 4}},
            "Rate": 30, "Range": {"Min": lo, "Max": hi}}],
        "Mobs": [],
        "MobThemes": [{
            "Spawn": {"$type": "PMDC.LevelGen.MobThemeNone, PMDC",
                      "SpecialRatio": 40, "Amount": {"Min": 7, "Max": 13}},
            "Rate": 10, "Range": {"Min": lo, "Max": hi}}],
        "SpreadPlan": {
            "$type": "RogueEssence.LevelGen.SpreadPlanChance, "
                     "RogueEssence",
            "Chance": chance, "FloorRange": {"Min": lo, "Max": hi}},
        "ModStates": [],
    }


def mh_profile_sky(zone):
    cmp_ = json.load(open(os.path.join(
        TABLES, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    e = cmp_.get(zone)
    if not e:
        return None
    g = glob.glob(os.path.join(TABLES, 'dungeons',
                               f"{e['dungeon']}_*.json.gz"))
    if not g:
        return None
    rom = json.load(gzip.open(g[0]))
    ch = [f['layout']['monster_house_chance'] for f in rom['floors']]
    idx = [i for i, c in enumerate(ch) if c > 0]
    if not idx:
        return None
    avg = round(sum(ch[i] for i in idx) / len(idx))
    return avg, min(idx), max(idx) + 1


def parse_red_props():
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
    return [stream[i:i + 28] for i in range(0, len(stream), 28)]


def mh_profile_red(zone, props):
    pret_dir = RED_Z2P.get(zone)
    if not pret_dir:
        return None
    fid = os.path.join(PRET, pret_dir, 'floor_id.json')
    if not os.path.exists(fid):
        return None
    tables = json.load(open(fid))['tables']
    ch = [props[t['MainData']][8] for t in tables]
    idx = [i for i, c in enumerate(ch) if c > 0]
    if not idx:
        return None
    avg = round(sum(ch[i] for i in idx) / len(idx))
    return avg, min(idx), max(idx) + 1


def main():
    props = parse_red_props()
    added = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Zone',
                                           '*.json'))):
        zn = os.path.basename(p)[:-5]
        if zn in LOCKED:
            continue
        prof = mh_profile_sky(zn) or mh_profile_red(zn, props)
        if not prof:
            continue
        chance, lo, hi = prof
        z = json.load(open(p, encoding='utf-8-sig'))
        changed = False
        gfloor = 0
        for seg in z['Object'].get('Segments', []):
            zsteps = seg.get('ZoneSteps')
            floors = seg.get('Floors')
            if zsteps is None or not isinstance(floors, list):
                continue
            nf = len(floors)
            has = any('SpreadHouseZoneStep' in s.get('$type', '')
                      for s in zsteps)
            # plage ROM globale -> locale au segment
            slo = max(0, lo - gfloor)
            shi = min(nf, hi - gfloor)
            gfloor += nf
            if has or slo >= shi:
                continue
            # seulement les segments procéduraux (pas les LoadGen boss)
            proc = any(isinstance(fl, dict) and (
                'GridFloorGen' in fl.get('$type', '') or
                'ChanceFloorGen' in fl.get('$type', ''))
                for fl in floors)
            if not proc:
                continue
            zsteps.append(house_step(chance, slo, shi))
            changed = True
        if changed:
            with open(p, 'w', encoding='utf-8-sig') as fh:
                json.dump(z, fh, ensure_ascii=False, indent=2)
            added[zn] = {"chance": chance, "range": [lo, hi]}
    print(f"zones équipées de Maisons de Monstres ROM: {len(added)}")
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'MONSTER_HOUSE_ADD_REPORT.json')
    json.dump(added, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    main()
