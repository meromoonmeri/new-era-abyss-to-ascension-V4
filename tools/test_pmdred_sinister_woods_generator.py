#!/usr/bin/env python3
"""Regression tests for the clean canonical Chapter 6 Sinister Woods bundle."""
from __future__ import annotations

import json
import subprocess
import unittest
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ZONE_PATH = ROOT / "Data/Zone/gloomy_forest.json"
BOSS_PATH = ROOT / "Data/Map/sinister_woods_boss.rsmap"
GROUNDS = ("sinister_woods_entrance", "sinister_woods_mid", "sinister_woods_boss")
MATERIALS = {"sinister_woods_b41_floor", "sinister_woods_b41_wall", "sinister_woods_b41_secondary"}


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))["Object"]


def gen_steps(grid: dict):
    return [entry["Value"] for entry in grid["GenSteps"]]


def step(grid: dict, token: str):
    return next(value for value in gen_steps(grid) if token in value.get("$type", ""))


class SinisterWoodsGeneratorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.zone = load(ZONE_PATH)

    def test_public_identity_and_canonical_floor_count(self):
        self.assertEqual(self.zone["Name"]["DefaultText"], "Sinister Woods")
        self.assertEqual(self.zone["Name"]["LocalTexts"]["fr"], "Forêt Sinistre")
        self.assertEqual(self.zone["TeamSize"], 3)
        self.assertEqual(self.zone["Rescues"], 10)
        self.assertEqual(len(self.zone["Segments"]), 3)
        self.assertEqual(self.zone["GroundMaps"], list(GROUNDS))
        self.assertEqual(sum(len(segment.get("Floors", {}).get("nodes", [])) for segment in self.zone["Segments"][:2]) + 1, 13)

    def test_display_names_follow_name_then_global_floor_number(self):
        first = self.zone["Segments"][0]["ZoneSteps"]
        title = next(value for value in first if "FloorNameDropZoneStep" in value["$type"])
        self.assertEqual(title["Name"]["DefaultText"], "Sinister Woods {0}")
        self.assertEqual(title["Name"]["LocalTexts"]["fr"], "Forêt Sinistre {0}")
        for floor, node in enumerate(self.zone["Segments"][1]["Floors"]["nodes"], start=11):
            direct = step(node["Item"]["Spawns"][0]["Spawn"], "MapNameIDStep")
            self.assertEqual(direct["Name"]["DefaultText"], "Sinister Woods {0}")
            self.assertEqual(direct["IDOffset"], 11)
        boss_title = next(value for value in self.zone["Segments"][2]["ZoneSteps"] if "FloorNameDropZoneStep" in value["$type"])
        self.assertEqual(boss_title["Name"]["DefaultText"], "Sinister Woods 13")

    def test_every_procedural_floor_has_three_native_topologies_and_no_seed(self):
        expected = (10, 2)
        signatures = set()
        for segment_id, expected_nodes in enumerate(expected):
            nodes = self.zone["Segments"][segment_id]["Floors"]["nodes"]
            self.assertEqual(len(nodes), expected_nodes)
            for local_floor, node in enumerate(nodes):
                self.assertEqual(node["Range"], {"Min": local_floor, "Max": local_floor + 1})
                chance = node["Item"]
                self.assertIn("ChanceFloorGen", chance["$type"])
                self.assertEqual(len(chance["Spawns"]), 3)
                variants = set()
                for choice in chance["Spawns"]:
                    grid = choice["Spawn"]
                    text = json.dumps(grid, sort_keys=True)
                    self.assertNotIn("FirstSeed", text)
                    self.assertNotIn('"seed"', text.lower())
                    self.assertIn("InitGridPlanStep", text)
                    self.assertIn("FloorStairsStep", text)
                    self.assertIn("ConnectGridBranchStep", text)
                    texture = step(grid, "MapTextureStep")
                    self.assertEqual(
                        {texture["GroundTileset"], texture["BlockTileset"], texture["WaterTileset"]},
                        MATERIALS,
                    )
                    stairs = step(grid, "FloorStairsStep")
                    self.assertEqual(stairs["Exits"][0]["Tile"]["ID"], "stairs_go_up")
                    self.assertGreaterEqual(stairs["MinDistance"], 1)
                    init = step(grid, "InitGridPlanStep")
                    path = next(value for value in gen_steps(grid) if "GridPath" in value["$type"])
                    tunnel_count = text.count("AddTunnelStep")
                    connect = next(value for value in gen_steps(grid) if "ConnectGridBranchStep" in value["$type"])
                    signature = (
                        init["CellX"], init["CellY"], init["CellWidth"], init["CellHeight"],
                        path["$type"], json.dumps(path.get("RoomRatio", path.get("TierConnections", {})), sort_keys=True),
                        json.dumps(path.get("BranchRatio", {}), sort_keys=True), connect.get("ConnectPercent"), tunnel_count,
                    )
                    variants.add(signature)
                    signatures.add(signature)
                self.assertEqual(len(variants), 3, f"segment {segment_id} floor {local_floor}")
        self.assertGreaterEqual(len(signatures), 12)

    def test_rb_darkness_and_no_forbidden_house_shop_trap_features(self):
        dark_floors = set()
        for segment_id in (0, 1):
            for local_floor, node in enumerate(self.zone["Segments"][segment_id]["Floors"]["nodes"]):
                global_floor = local_floor + (1 if segment_id == 0 else 11)
                has_darkness = any("darkness" in json.dumps(choice["Spawn"]) for choice in node["Item"]["Spawns"])
                if has_darkness:
                    dark_floors.add(global_floor)
        self.assertEqual(dark_floors, {5, 6, 7, 11, 12})
        payload = json.dumps(self.zone)
        for forbidden in ("ShopStep", "SpreadHouse", "MonsterHouse", "BuriedItem", "trap_"):
            self.assertNotIn(forbidden, payload)

    def test_official_wildlife_is_preserved_as_fifteen_species(self):
        species = set()
        levels = {}
        for segment in self.zone["Segments"][:2]:
            spawn_step = next(value for value in segment["ZoneSteps"] if "TeamSpawnZoneStep" in value["$type"])
            for row in spawn_step["Spawns"]:
                mob = row["Spawn"]["Spawn"]
                species.add(mob["BaseForm"]["Species"])
                levels.setdefault(mob["BaseForm"]["Species"], mob["Level"]["Min"])
        self.assertEqual(
            species,
            {"swinub", "oddish", "sudowoodo", "sunflora", "sentret", "silcoon", "cascoon", "shroomish", "linoone", "ledyba", "wooper", "scyther", "exeggutor", "hoothoot", "slakoth"},
        )
        self.assertEqual({key: levels[key] for key in ("swinub", "shroomish", "wooper", "scyther", "slakoth")}, {"swinub": 8, "shroomish": 9, "wooper": 10, "scyther": 10, "slakoth": 8})

    def test_fixed_boss_is_the_canonical_trio_and_reachable(self):
        game_map = load(BOSS_PATH)
        roster = {team["Players"][0]["BaseForm"]["Species"]: team["Players"][0]["Level"] for team in game_map["MapTeams"]}
        self.assertEqual(roster, {"gengar": 15, "ekans": 15, "medicham": 12})
        self.assertEqual((len(game_map["Tiles"]), len(game_map["Tiles"][0])), (15, 18))
        start = game_map["EntryPoints"][0]["Loc"]
        floors = {
            (x, y)
            for x, column in enumerate(game_map["Tiles"])
            for y, cell in enumerate(column)
            if cell["Data"]["ID"] == "floor"
        }
        seen = {tuple(start.values())}
        queue = deque(seen)
        while queue:
            x, y = queue.popleft()
            for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if point in floors and point not in seen:
                    seen.add(point)
                    queue.append(point)
        for team in game_map["MapTeams"]:
            pos = team["Players"][0]["serializationLoc"]
            self.assertIn((pos["X"], pos["Y"]), seen)

    def test_fixed_grounds_use_real_canonical_scene_art_and_are_registered(self):
        index = load(ROOT / "Data/Zone/index.idx")
        self.assertIn("gloomy_forest", index)
        self.assertEqual(index["gloomy_forest"]["Grounds"], list(GROUNDS))
        master = load(ROOT / "Data/Zone/master_zone.json")
        self.assertNotIn("sinister_woods_clearing", master["GroundMaps"])
        expected = {
            "sinister_woods_entrance": "d04p01_Base",
            "sinister_woods_mid": "BoisDesPlaintes_Base",
            "sinister_woods_boss": "SinisterWoodsFinalCanonical_Base",
        }
        for name, sheet in expected.items():
            self.assertIn(name, master["GroundMaps"])
            ground = load(ROOT / "Data/Ground" / f"{name}.rsground")
            self.assertEqual(ground["AssetName"], name)
            sheets = {
                frame["Sheet"]
                for layer in ground["Layers"]
                for column in layer["Tiles"]
                for cell in column
                for tile_layer in cell.get("Layers", [])
                for frame in tile_layer.get("Frames", [])
            }
            self.assertEqual(sheets, {sheet})
            self.assertTrue((ROOT / "Content/Tile" / f"{sheet}.tile").is_file())

    def test_builder_and_ten_pass_variation_contract(self):
        subprocess.run(["python3", str(ROOT / "tools/build_chapter6_sinister_woods.py"), "--check"], cwd=ROOT, check=True)
        subprocess.run(["python3", str(ROOT / "tools/validate_sinister_woods_variation.py"), "--passes", "10"], cwd=ROOT, check=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
