#!/usr/bin/env python3
"""Focused tests for the shared early-dungeon serializer."""

from __future__ import annotations

import json
import tempfile
import unittest
from fractions import Fraction
from pathlib import Path

from pmdred_early_dungeon import (
    append_index_entries,
    build_chance_floor,
    build_load_floor,
    build_red_large_chance_floor,
    fixed_mob_spawn,
    init_grid_step,
    map_item,
    red_compact_geometry,
    room_square,
)


class IndexAppendTests(unittest.TestCase):
    def test_preserves_compact_history_and_absent_final_newline(self) -> None:
        before = '{\n"Version": "0.8.9.0",\n"Object": {\n"old": {\n"Name": "kept"\n}\n}\n}'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_text(before, encoding="utf-8")
            append_index_entries(path, {"new": {"Name": "ajouté"}})
            after = path.read_text(encoding="utf-8")
            self.assertTrue(after.startswith(before[:-4]))
            self.assertFalse(after.endswith("\n"))
            self.assertEqual(json.loads(after)["Object"]["old"], {"Name": "kept"})
            self.assertEqual(json.loads(after)["Object"]["new"], {"Name": "ajouté"})

    def test_preserves_terminal_newline(self) -> None:
        before = '{\n  "Version": "0.8.12.0",\n  "Object": {\n    "old": true\n  }\n}\n'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_text(before, encoding="utf-8")
            append_index_entries(path, {"new": {"Name": "new"}})
            after = path.read_text(encoding="utf-8")
            self.assertTrue(after.endswith("\n"))
            self.assertEqual(json.loads(after)["Object"]["old"], True)
            self.assertEqual(json.loads(after)["Object"]["new"], {"Name": "new"})

    def test_preserves_bom_indented_history_and_rejects_duplicate(self) -> None:
        before = b"\xef\xbb\xbf" + b'{\n  "Version": "0.8.12.0",\n  "Object": {\n    "old": {\n      "Name": "kept"\n    }\n  }\n}'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_bytes(before)
            append_index_entries(path, {"new": {"Name": "new"}})
            after = path.read_bytes()
            self.assertTrue(after.startswith(b"\xef\xbb\xbf" + before[3:-6]))
            self.assertEqual(json.loads(after.decode("utf-8-sig"))["Object"]["old"], {"Name": "kept"})
            with self.assertRaises(FileExistsError):
                append_index_entries(path, {"new": {"Name": "replacement"}})


class VariableGeometryTests(unittest.TestCase):
    def test_existing_small_and_medium_dimensions_are_unchanged(self) -> None:
        small = init_grid_step(2, 2)
        medium = init_grid_step(3, 3)
        self.assertEqual((small["CellWidth"], small["CellHeight"]), (12, 14))
        self.assertEqual((medium["CellWidth"], medium["CellHeight"]), (12, 8))
        self.assertEqual(room_square(2, 2)["Width"], {"Min": 5, "Max": 10})
        self.assertEqual(room_square(2, 2)["Height"], {"Min": 4, "Max": 13})
        self.assertEqual(room_square(3, 3)["Height"], {"Min": 4, "Max": 7})

    def test_large_layout_derives_five_and_six_column_cells(self) -> None:
        five = init_grid_step(4, 5)
        six = init_grid_step(4, 6)
        self.assertEqual((five["CellWidth"], five["CellHeight"]), (9, 6))
        self.assertEqual((six["CellWidth"], six["CellHeight"]), (7, 6))
        self.assertEqual(room_square(4, 5)["Width"], {"Min": 5, "Max": 7})
        self.assertEqual(room_square(4, 6)["Width"], {"Min": 5, "Max": 5})
        self.assertEqual(room_square(4, 6)["Height"], {"Min": 4, "Max": 5})

    def test_per_alternative_columns_are_serialized(self) -> None:
        floor = build_chance_floor(
            geometry=[((2, 2, 3), 7), ((6, 4, 8), 11)],
            valid_columns=3,
            music="Sinister Woods.ogg",
            texture_family="sinister_woods",
            monsters=[("oddish", 3, 1)],
            enemy_count_weights=[(2, 1)],
            items=[({
                "IsMoney": False, "Cursed": False, "Value": "berry_oran",
                "HiddenValue": "", "Amount": 0, "Price": 0,
                "TileLoc": {"X": 0, "Y": 0},
            }, 1)],
            item_count_weights=[(1, 1)],
            trap_count_weights=[(0, 1)],
        )
        grids = []
        for spawn in floor["Spawns"]:
            steps = spawn["Spawn"]["GenSteps"]
            grids.append(next(pair["Value"] for pair in steps if "CellX" in pair["Value"]))
        self.assertEqual([(grid["CellX"], grid["CellY"]) for grid in grids], [(2, 2), (6, 4)])
        self.assertEqual([(grid["CellWidth"], grid["CellHeight"]) for grid in grids], [(12, 14), (7, 6)])
        self.assertEqual([spawn["Rate"] for spawn in floor["Spawns"]], [7, 11])

    def test_invalid_geometry_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            init_grid_step(4, 7)
        with self.assertRaises(ValueError):
            init_grid_step(5, 4)

    def test_secondary_terrain_is_explicit_and_wall_stencilled(self) -> None:
        common = dict(
            geometry=[((3, 3), 1)], valid_columns=3,
            music="PMD Red - Sinister Woods.ogg", texture_family="sinister_woods",
            monsters=[("oddish", 7, 1)], enemy_count_weights=[(4, 1)],
            items=[(map_item("berry_oran"), 1)], item_count_weights=[(3, 1)],
            trap_count_weights=[(1, 1)],
        )
        dry = build_chance_floor(**common)
        wet = build_chance_floor(**common, secondary_water_percent=12)
        dry_steps = dry["Spawns"][0]["Spawn"]["GenSteps"]
        wet_steps = wet["Spawns"][0]["Spawn"]["GenSteps"]
        self.assertEqual(len(wet_steps), len(dry_steps) + 1)
        self.assertEqual(
            [pair for pair in wet_steps if "PerlinWaterStep" not in pair["Value"].get("$type", "")],
            dry_steps,
        )
        perlin = next(pair for pair in wet_steps if pair["Key"] == {"str": [3]})["Value"]
        self.assertEqual(perlin["OrderComplexity"], 3)
        self.assertEqual(perlin["OrderSoftness"], 1)
        self.assertEqual(perlin["WaterPercent"], {"Min": 12, "Max": 12})
        self.assertTrue(perlin["Bowl"])
        self.assertEqual(perlin["Terrain"]["Data"]["ID"], "water")
        self.assertEqual(
            {key: perlin["TerrainStencil"][key] for key in ("Room", "Wall", "Blocked", "Not")},
            {"Room": False, "Wall": True, "Blocked": False, "Not": False},
        )

    def test_compact_density_adapters_match_exact_red_distributions(self) -> None:
        self.assertEqual(red_compact_geometry(6, 3), [
            ((2, 4), 8_928_571), ((2, 5), 19_642_857), ((2, 6), 21_428_572),
            ((3, 3), 1_515_152), ((3, 4), 9_469_697), ((3, 5), 19_015_152),
            ((3, 6), 15_303_030), ((3, 7), 4_393_939), ((3, 8), 303_030),
        ])
        self.assertEqual(red_compact_geometry(10, 3), [
            ((2, 6), 50_000_000), ((3, 7), 9_090_909),
            ((3, 8), 19_318_182), ((3, 9), 21_590_909),
        ])
        self.assertEqual(red_compact_geometry(12, 3), [
            ((2, 6), 50_000_000), ((3, 9), 50_000_000),
        ])
        self.assertEqual(red_compact_geometry(11, 2), [
            ((2, 4), 50_000_000), ((3, 5), 8_333_333), ((3, 6), 41_666_667),
        ])

    def test_floor_options_serialize_sight_and_dead_end_policy(self) -> None:
        floor = build_chance_floor(
            geometry=[((3, 6), 1)], valid_columns=3,
            music="PMD Red - Sinister Woods.ogg", texture_family="sinister_woods",
            monsters=[("oddish", 7, 1)], enemy_count_weights=[(4, 1)],
            items=[(map_item("berry_oran"), 1)], item_count_weights=[(3, 1)],
            trap_count_weights=[(1, 1)], allow_dead_end=False,
            tile_sight=2, char_sight=3,
        )
        steps = floor["Spawns"][0]["Spawn"]["GenSteps"]
        map_data = next(pair["Value"] for pair in steps if pair["Key"] == {"str": [-6]})
        tunnels = next(pair["Value"] for pair in steps if pair["Key"] == {"str": [0]})
        self.assertEqual((map_data["TileSight"], map_data["CharSight"]), (2, 3))
        self.assertFalse(tunnels["AllowDeadEnd"])

    def test_loaded_map_places_one_native_fixed_hostile_team(self) -> None:
        bosses = [
            fixed_mob_spawn("ekans", 15, (12, 14)),
            fixed_mob_spawn("gengar", 15, (11, 14)),
            fixed_mob_spawn("medicham", 12, (10, 14)),
        ]
        floor = build_load_floor(
            map_id="pmdred_sinister_woods_boss", hostile_teams=[bosses]
        )
        self.assertEqual([pair["Key"] for pair in floor["GenSteps"]], [
            {"str": [-1]}, {"str": [5, 2]},
        ])
        place = floor["GenSteps"][1]["Value"]
        self.assertIn("PlaceNoLocMobsStep`1[[RogueEssence.LevelGen.MapLoadContext", place["$type"])
        self.assertIn("PresetMultiTeamSpawner`1[[RogueEssence.LevelGen.MapLoadContext", place["Spawn"]["$type"])
        self.assertFalse(place["Ally"])
        self.assertEqual(len(place["Spawn"]["Spawns"]), 1)
        team = place["Spawn"]["Spawns"][0]
        self.assertEqual((team["Explorer"], len(team["Spawns"])), (False, 3))
        self.assertNotIn("$type", team)
        self.assertEqual([
            (mob["BaseForm"]["Species"], mob["Level"]["Min"],
             mob["SpawnFeatures"][0]["Loc"], mob["SpawnFeatures"][0]["Dir"])
            for mob in team["Spawns"]
        ], [
            ("ekans", 15, {"X": 12, "Y": 14}, 4),
            ("gengar", 15, {"X": 11, "Y": 14}, 4),
            ("medicham", 12, {"X": 10, "Y": 14}, 4),
        ])

    def test_loaded_map_places_typed_fixed_ally_after_hostiles(self) -> None:
        boss = fixed_mob_spawn("skarmory", 10, (4, 8), direction=0)
        protected = fixed_mob_spawn("diglett", 5, (4, 3), direction=0)
        floor = build_load_floor(
            map_id="mt_steel_peak",
            hostile_teams=[[boss]],
            ally_teams=[[protected]],
        )
        self.assertEqual([pair["Key"] for pair in floor["GenSteps"]], [
            {"str": [-1]}, {"str": [5, 2]}, {"str": [5, 3]},
        ])
        hostile = floor["GenSteps"][1]["Value"]
        ally = floor["GenSteps"][2]["Value"]
        self.assertFalse(hostile["Ally"])
        self.assertFalse(hostile["Spawn"]["Spawns"][0]["Explorer"])
        self.assertTrue(ally["Ally"])
        self.assertTrue(ally["Spawn"]["Spawns"][0]["Explorer"])
        self.assertEqual(
            ally["Spawn"]["Spawns"][0]["Spawns"][0]["BaseForm"]["Species"],
            "diglett",
        )

    def test_large_layout_serializes_all_32_attempts_and_exact_fallback(self) -> None:
        floor = build_red_large_chance_floor(
            room_density=8,
            reference_id="large-floor-5-accepted",
            music="Sinister Woods.ogg",
            texture_family="sinister_woods",
            monsters=[("oddish", 3, 1)],
            enemy_count_weights=[(4, 1)],
            items=[(map_item("berry_oran"), 1)],
            item_count_weights=[(3, 1)],
            trap_count_weights=[(1, 1)],
        )
        registry = floor["Spawns"]
        self.assertEqual(len(registry), 35)  # accepted + fallback + 32 trials + active root
        self.assertEqual([entry["Rate"] for entry in registry[:-1]], [0] * 34)
        self.assertEqual(registry[-1], {
            "Spawn": {"$ref": "large-floor-5-accepted-attempt-1"}, "Rate": 1,
        })

        accepted = registry[0]["Spawn"]
        self.assertEqual(accepted["$id"], "large-floor-5-accepted")
        self.assertEqual(len(accepted["Spawns"]), 45)  # 5 columns x 3 rows x 3 room increments
        fallback = registry[1]["Spawn"]
        self.assertEqual(fallback["$id"], "large-floor-5-accepted-fallback")

        trial_nodes = registry[2:-1]
        self.assertEqual(
            [node["Spawn"]["$id"] for node in trial_nodes],
            [f"large-floor-5-accepted-attempt-{attempt}" for attempt in range(32, 0, -1)],
        )
        for registry_entry, attempt in zip(trial_nodes, range(32, 0, -1), strict=True):
            node = registry_entry["Spawn"]
            self.assertEqual([entry["Rate"] for entry in node["Spawns"]], [15, 27])
            self.assertEqual(node["Spawns"][0]["Spawn"], {"$ref": "large-floor-5-accepted"})
            retry_id = (
                "large-floor-5-accepted-fallback" if attempt == 32
                else f"large-floor-5-accepted-attempt-{attempt + 1}"
            )
            self.assertEqual(node["Spawns"][1]["Spawn"], {"$ref": retry_id})

        fallback_grids = []
        fallback_rooms = []
        for entry in fallback["Spawns"]:
            steps = entry["Spawn"]["GenSteps"]
            grid = next(pair["Value"] for pair in steps if "CellX" in pair["Value"])
            path = next(pair["Value"] for pair in steps if "GenericRooms" in pair["Value"])
            fallback_grids.append((grid["CellX"], grid["CellY"]))
            fallback_rooms.append(sum(
                "RoomGenSquare" in room.get("$type", "")
                for room in path["GenericRooms"]["ToSpawn"]
            ))
        self.assertEqual(fallback_grids, [(4, 4)] * 3)
        self.assertEqual(fallback_rooms, [8, 9, 10])
        self.assertEqual(
            Fraction(27, 42) ** 32,
            Fraction(27 ** 32, 42 ** 32),
        )

    def test_large_layout_rejects_noncanonical_retry_count(self) -> None:
        with self.assertRaises(ValueError):
            build_red_large_chance_floor(
                room_density=8, reference_id="bad", attempts=31,
                music="Sinister Woods.ogg", texture_family="sinister_woods",
                monsters=[("oddish", 3, 1)], enemy_count_weights=[(4, 1)],
                items=[(map_item("berry_oran"), 1)], item_count_weights=[(3, 1)],
                trap_count_weights=[(1, 1)],
            )


if __name__ == "__main__":
    unittest.main()
