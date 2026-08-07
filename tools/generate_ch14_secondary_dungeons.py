#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_ch14_secondary_dungeons.py — Générateur des 4 donjons secondaires
du Chapitre 14 (Arc du Ciel Boréal) pour New Era : Abyss to Ascension.
"""
import os, sys, json, copy

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
TEMPLATE_ZONE = os.path.join(MOD_ROOT, "Data/Zone/forsaken_desert.json")
TEMPLATE_RSMAP = os.path.join(MOD_ROOT, "Data/Map/searing_tunnel_miniboss.rsmap")

CH14_DUNGEONS = [
    {
        "id": "aurora_pass", "name": "Col de l'Aurore", "name_en": "Aurora Pass",
        "rank": 62, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "glacial_rift_floor", "wall_ts1": "glacial_rift_wall",
        "floor_ts2": "ice_crystal_cave_floor", "wall_ts2": "ice_crystal_cave_wall",
        "spawns_seg1": [("vulpix", 44, 50), ("snorunt", 44, 50), ("swinub", 45, 51), ("spheal", 45, 51), ("bergmite", 46, 52), ("cubchoo", 46, 52), ("smoochum", 44, 50), ("seel", 45, 51), ("shellder", 46, 52), ("sneasel", 45, 51), ("delibird", 44, 50), ("lapras", 46, 52)],
        "spawns_seg2": [("ninetales", 52, 60), ("glalie", 52, 60), ("froslass", 53, 60), ("piloswine", 53, 60), ("sealeo", 54, 60), ("avalugg", 54, 60), ("beartic", 54, 60), ("jynx", 52, 60), ("dewgong", 53, 60), ("cloyster", 54, 60), ("weavile", 53, 60), ("walrein", 54, 60), ("mamoswine", 54, 60)],
        "minibosses": [(7, "Momartik la Brume", "froslass", 52), (14, "Blizzarroi le Souffle", "abomasnow", 56), (22, "Feunard d'Alola l'Aurore", "ninetales", 60)],
        "weather": {}
    },
    {
        "id": "crystal_crevasse", "name": "Crevasse Cristalline", "name_en": "Crystal Crevasse",
        "rank": 63, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "glacial_rift_floor", "wall_ts1": "glacial_rift_wall",
        "floor_ts2": "ice_crystal_cave_floor", "wall_ts2": "ice_crystal_cave_wall",
        "spawns_seg1": [("cryogonal", 44, 50), ("bergmite", 44, 50), ("snorunt", 45, 51), ("swinub", 45, 51), ("spheal", 46, 52), ("cubchoo", 46, 52), ("seel", 44, 50), ("shellder", 45, 51), ("sneasel", 46, 52), ("smoochum", 45, 51), ("delibird", 44, 50), ("lapras", 46, 52)],
        "spawns_seg2": [("avalugg", 52, 60), ("froslass", 52, 60), ("glalie", 53, 60), ("piloswine", 53, 60), ("sealeo", 54, 60), ("beartic", 54, 60), ("jynx", 52, 60), ("dewgong", 53, 60), ("cloyster", 54, 60), ("weavile", 53, 60), ("walrein", 54, 60), ("mamoswine", 54, 60), ("glaceon", 53, 60)],
        "minibosses": [(8, "Hexagel le Givre", "cryogonal", 52), (16, "Séracrawl la Glace", "avalugg", 56), (24, "Kaimorse le Glacier", "walrein", 60)],
        "weather": {}
    },
    {
        "id": "roaring_summit", "name": "Sommet Grondant", "name_en": "Roaring Summit",
        "rank": 64, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Mt. Horn.ogg", "music_seg2": "Craggy Coast.ogg",
        "floor_ts1": "rocky_crag_floor", "wall_ts1": "rocky_crag_wall",
        "floor_ts2": "windy_summit_floor", "wall_ts2": "windy_summit_wall",
        "spawns_seg1": [("rufflet", 44, 50), ("vullaby", 44, 50), ("rookidee", 45, 51), ("pidgey", 45, 51), ("spearow", 46, 52), ("zubat", 46, 52), ("doduo", 44, 50), ("skarmory", 45, 51), ("taillow", 46, 52), ("wingull", 45, 51), ("hoothoot", 44, 50), ("natu", 46, 52)],
        "spawns_seg2": [("braviary", 52, 60), ("mandibuzz", 52, 60), ("corviknight", 53, 60), ("pidgeotto", 53, 60), ("fearow", 54, 60), ("golbat", 54, 60), ("dodrio", 52, 60), ("swellow", 53, 60), ("pelipper", 54, 60), ("noctowl", 53, 60), ("xatu", 54, 60), ("dragonite", 54, 60)],
        "minibosses": [(7, "Guériaigle l'Élan", "braviary", 52), (15, "Corvaillus l'Ombre", "corviknight", 56), (23, "Dracolosse le Sommet", "dragonite", 60)],
        "weather": {4: "fog", 14: "fog"}
    },
    {
        "id": "forgotten_tundra", "name": "Toundra Oubliée", "name_en": "Forgotten Tundra",
        "rank": 65, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "glacial_rift_floor", "wall_ts1": "glacial_rift_wall",
        "floor_ts2": "ice_crystal_cave_floor", "wall_ts2": "ice_crystal_cave_wall",
        "spawns_seg1": [("swinub", 44, 50), ("cubchoo", 44, 50), ("snorunt", 45, 51), ("spheal", 45, 51), ("bergmite", 46, 52), ("seel", 46, 52), ("shellder", 44, 50), ("sneasel", 45, 51), ("smoochum", 46, 52), ("cryogonal", 45, 51), ("delibird", 44, 50), ("lapras", 46, 52), ("vulpix", 45, 51)],
        "spawns_seg2": [("mamoswine", 52, 60), ("beartic", 52, 60), ("glalie", 53, 60), ("froslass", 53, 60), ("walrein", 54, 60), ("avalugg", 54, 60), ("piloswine", 52, 60), ("sealeo", 53, 60), ("jynx", 54, 60), ("dewgong", 53, 60), ("cloyster", 54, 60), ("weavile", 54, 60), ("glaceon", 53, 60)],
        "minibosses": [(8, "Mammochon le Croc", "mamoswine", 52), (16, "Polagriffe la Force", "beartic", 56), (25, "Blizzarroi le Géant", "abomasnow", 60)],
        "weather": {}
    }
]

def make_spawn_table(spawns_list):
    sp_dict = {}
    for idx, (sp, min_lv, max_lv) in enumerate(spawns_list):
        sp_dict[f"spawn_{idx}"] = {
            "Spawn": {
                "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
                "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                "Level": {"Min": min_lv, "Max": max_lv},
                "SpawnFeatures": []
            },
            "Rate": 10
        }
    return {
        "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.LevelGen.MobSpawn, RogueEssence]], RogueEssence",
        "spawns": sp_dict,
        "spawnTotal": len(spawns_list) * 10
    }

def make_team_spawn_zone_step(spawns_list):
    spawns = []
    for sp, min_lv, max_lv in spawns_list:
        spawns.append({
            "Spawn": {
                "Spawn": {
                    "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                    "Level": {"Min": min_lv, "Max": max_lv},
                    "SpecifiedSkills": [],
                    "Intrinsic": "",
                    "Tactic": "wait_and_see",
                    "SpawnConditions": [],
                    "SpawnFeatures": []
                },
                "Role": 0
            },
            "Rate": 10,
            "Range": {"Min": 0, "Max": 30}
        })
    return {
        "$type": "PMDC.LevelGen.TeamSpawnZoneStep, PMDC",
        "Priority": -2,
        "Spawns": spawns
    }

def make_shop_step():
    return {
        "$type": "RogueEssence.LevelGen.ShopStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [4]},
        "SecurityStatus": "shop_security",
        "Personality": 0,
        "StartSpawn": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "kecleon", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 55, "Max": 60},
            "SpawnFeatures": []
        },
        "Items": {
            "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueEssence",
            "spawns": {
                "item_0": {"Spawn": {"ID": "food_apple", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_1": {"Spawn": {"ID": "berry_oran", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_2": {"Spawn": {"ID": "seed_reviver", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 5}
            },
            "spawnTotal": 25
        }
    }

def make_cafe_step():
    return {
        "$type": "RogueEssence.LevelGen.SecretRoomStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [5]},
        "SecretMob": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "spinda", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 45, "Max": 45},
            "SpawnFeatures": []
        }
    }

def make_miniboss_rsmap(map_id, name, species, level, music):
    with open(TEMPLATE_RSMAP, "r", encoding="utf-8") as f:
        content = f.read()
    data = json.loads(content)
    obj = data["Object"]
    obj["Name"] = {"DefaultText": name, "LocalTexts": {"fr": name}}
    obj["Music"] = music
    team = obj["MapTeams"][0]
    mob = team["Players"][0]
    mob["BaseForm"]["Species"] = species
    mob["Level"] = level
    mob["Nickname"] = name
    team["Players"] = [mob]
    path = os.path.join(MOD_ROOT, "Data", "Map", map_id + ".rsmap")
    with open(path, "w", encoding="utf-8") as f:
        f.write(json.dumps(data, ensure_ascii=False))
    print(f"  [Arène] Générée : {map_id}.rsmap ({name})")

def generate_ch14_dungeons():
    with open(TEMPLATE_ZONE, "r", encoding="utf-8-sig") as f:
        tpl_data = json.load(f)

    for cfg in CH14_DUNGEONS:
        data = copy.deepcopy(tpl_data)
        obj = data["Object"]
        obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
        obj["Comment"] = f"New Era ch14 — Ch14 secondary: {cfg['name']}"
        obj["Level"] = 44
        
        segments = obj.get("Segments", [])
        mid_floor = cfg["floors"] // 2
        
        if len(segments) >= 2:
            seg1 = segments[0]
            seg1["Music"] = cfg["music_seg1"]
            has_zs1 = False
            for zs in seg1.get("ZoneSteps", []):
                if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                    zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg1"])["Spawns"]
                    has_zs1 = True
            if not has_zs1:
                seg1.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg1"]))
            for fl in seg1.get("Floors", []):
                if isinstance(fl, dict):
                    for st in fl.get("GenSteps", []):
                        val = st.get("Value", {})
                        if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts1"]
                        if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts1"]
                        if "Spawns" in val or "TeamSpawns" in val:
                            val["Spawns"] = make_spawn_table(cfg["spawns_seg1"])
            
            seg2 = segments[1]
            seg2["Music"] = cfg["music_seg2"]
            has_zs2 = False
            for zs in seg2.get("ZoneSteps", []):
                if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                    zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg2"])["Spawns"]
                    has_zs2 = True
            if not has_zs2:
                seg2.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg2"]))
            for fl in seg2.get("Floors", []):
                if isinstance(fl, dict):
                    for st in fl.get("GenSteps", []):
                        val = st.get("Value", {})
                        if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts2"]
                        if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts2"]
                        if "Spawns" in val or "TeamSpawns" in val:
                            val["Spawns"] = make_spawn_table(cfg["spawns_seg2"])
        
        path = os.path.join(MOD_ROOT, "Data", "Zone", cfg["id"] + ".json")
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  [OK] Zone : {cfg['id']} ({cfg['floors']} étages, scaling Lv 44-60)")
        
        make_miniboss_rsmap(f"{cfg['id']}_mb1", cfg["minibosses"][0][1], cfg["minibosses"][0][2], cfg["minibosses"][0][3], cfg["music_seg1"])
        make_miniboss_rsmap(f"{cfg['id']}_mb2", cfg["minibosses"][1][1], cfg["minibosses"][1][2], cfg["minibosses"][1][3], cfg["music_seg2"])
        make_miniboss_rsmap(f"{cfg['id']}_boss", cfg["minibosses"][2][1], cfg["minibosses"][2][2], cfg["minibosses"][2][3], cfg["music_seg2"])

if __name__ == "__main__":
    print("=== GÉNÉRATION DES DONJONS SECONDAIRES CH14 ===")
    generate_ch14_dungeons()
