#!/usr/bin/env python3
"""Exact structural tests for the EU-backed Tiny Woods ZoneData builder."""

from __future__ import annotations

import hashlib
import json
import os
import tempfile
import unittest
from pathlib import Path

import build_pmdred_tiny_woods as tiny


def floors(zone: dict):
    return zone["Object"]["Segments"][0]["Floors"]["nodes"]


def alternatives(zone: dict, floor_index: int):
    return floors(zone)[floor_index]["Item"]["Spawns"]


def steps(grid_floor: dict):
    return [entry["Value"] for entry in grid_floor["GenSteps"]]


def one_step(grid_floor: dict, type_fragment: str) -> dict:
    matches = [step for step in steps(grid_floor) if type_fragment in step.get("$type", "")]
    if len(matches) != 1:
        raise AssertionError(f"expected one {type_fragment}, found {len(matches)}")
    return matches[0]


class TinyWoodsBuilderTests(unittest.TestCase):
    def setUp(self) -> None:
        self.zone = tiny.build_zone()

    def test_zone_restrictions_and_three_floor_ranges_are_canonical(self) -> None:
        obj = self.zone["Object"]
        self.assertEqual(obj["Name"]["DefaultText"], "Petit Bois")
        self.assertEqual(self.zone["Version"], "0.8.12.0")
        self.assertEqual(obj["$type"], "RogueEssence.Data.ZoneData, RogueEssence")
        self.assertEqual(
            (obj["Level"], obj["TeamRestrict"], obj["TeamSize"], obj["BagRestrict"], obj["MoneyRestrict"], obj["KeepTreasure"], obj["Rescues"], obj["Rogue"]),
            (1, False, 3, 20, False, False, -1, 0),
        )
        self.assertEqual([node["Range"] for node in floors(self.zone)], [
            {"Min": 0, "Max": 1}, {"Min": 1, "Max": 2}, {"Min": 2, "Max": 3},
        ])

    def test_geometry_alternatives_have_exact_100_million_rates(self) -> None:
        self.assertEqual(len(tiny.GEOMETRY_KEYS), 8)
        for floor_index in range(3):
            actual = [entry["Rate"] for entry in alternatives(self.zone, floor_index)]
            self.assertEqual(actual, list(tiny.GEOMETRY_WEIGHTS[floor_index]))
            self.assertEqual(sum(actual), 100_000_000)
        self.assertEqual(tiny.GEOMETRY_WEIGHTS[1], tiny.GEOMETRY_WEIGHTS[2])

    def test_each_grid_has_authenticated_extent_and_finite_room_assignment(self) -> None:
        for floor_index in range(3):
            for (rows, normal_count), alt in zip(tiny.GEOMETRY_KEYS, alternatives(self.zone, floor_index)):
                grid_floor = alt["Spawn"]
                init = one_step(grid_floor, "InitGridPlanStep")
                extent = (
                    init["CellX"] * (init["CellWidth"] + init["CellWall"]) - init["CellWall"] + 2,
                    init["CellY"] * (init["CellHeight"] + init["CellWall"]) - init["CellWall"] + 2,
                )
                self.assertEqual(extent, (28, 32 if rows == 2 else 30))
                branch = one_step(grid_floor, "GridPathBranch")
                self.assertEqual(branch["RoomRatio"], {"Min": 100, "Max": 100})
                bag = branch["GenericRooms"]
                self.assertTrue(bag["removeOnRoll"])
                self.assertEqual(len(bag["ToSpawn"]), rows * 2)
                squares = [room for room in bag["ToSpawn"] if "RoomGenSquare" in room["$type"]]
                anchors = [room for room in bag["ToSpawn"] if "RoomGenDefault" in room["$type"]]
                self.assertEqual((len(squares), len(anchors)), (normal_count, rows * 2 - normal_count))
                self.assertTrue(all(room["Width"] == {"Min": 5, "Max": 10} for room in squares))
                self.assertTrue(all(room["Height"] == {"Min": 4, "Max": 13 if rows == 2 else 7} for room in squares))

    def test_stairs_items_money_and_mobs_exclude_one_tile_anchors(self) -> None:
        for floor_index in range(3):
            for alt in alternatives(self.zone, floor_index):
                grid = alt["Spawn"]
                relevant = [
                    one_step(grid, "FloorStairsStep"),
                    one_step(grid, "RandomRoomSpawnStep"),
                    one_step(grid, "PlaceRandomMobsStep"),
                ]
                for step in relevant:
                    self.assertIn({
                        "$type": "RogueElements.RoomFilterDefaultGen, RogueElements",
                        "Negate": True,
                    }, step["Filters"])
                    self.assertFalse(step.get("IncludeHalls", False))

    def test_money_value_and_pile_count_distributions_are_independent_and_exact(self) -> None:
        for floor_index in (0, 1):
            spawn = one_step(alternatives(self.zone, floor_index)[0]["Spawn"], "RandomRoomSpawnStep")
            picker = spawn["Spawn"]["Picker"]
            amounts = [(row["Spawn"]["Amount"], row["Rate"]) for row in picker["Spawner"]["$values"]]
            counts = [(row["Spawn"], row["Rate"]) for row in picker["AmountSpawner"]["$values"]]
            self.assertEqual(amounts, list(tiny.MONEY_WEIGHTS))
            self.assertEqual(sum(rate for _, rate in amounts), 100)
            self.assertEqual(counts, list(tiny.COUNT_WEIGHTS))
            self.assertIsNot(picker["Spawner"], picker["AmountSpawner"])

    def test_third_floor_berry_value_and_item_count_weights_are_exact(self) -> None:
        spawn = one_step(alternatives(self.zone, 2)[0]["Spawn"], "RandomRoomSpawnStep")
        picker = spawn["Spawn"]["Picker"]
        items = [(row["Spawn"]["ID"], row["Rate"]) for row in picker["Spawner"]["$values"]]
        counts = [(row["Spawn"], row["Rate"]) for row in picker["AmountSpawner"]["$values"]]
        self.assertEqual(items, list(tiny.BERRY_WEIGHTS))
        self.assertEqual(counts, list(tiny.COUNT_WEIGHTS))

    def test_initial_enemy_counts_and_species_rates_are_exact_per_floor(self) -> None:
        for floor_index in range(3):
            mobs = one_step(alternatives(self.zone, floor_index)[0]["Spawn"], "PlaceRandomMobsStep")
            spawner = mobs["Spawn"]
            counts = [(row["Spawn"], row["Rate"]) for row in spawner["AmountSpawner"]["$values"]]
            species = [
                (row["Spawn"]["Spawns"][0]["BaseForm"]["Species"], row["Rate"])
                for row in spawner["Picker"]["$values"]
            ]
            self.assertEqual(counts, list(tiny.ENEMY_COUNT_WEIGHTS))
            self.assertEqual(species, list(tiny.FLOOR_ENEMIES[floor_index]))
            for row in spawner["Picker"]["$values"]:
                mob = row["Spawn"]["Spawns"][0]
                self.assertEqual(mob["Level"], {"Min": 1, "Max": 1})
                self.assertEqual(mob["SpecifiedSkills"], [])

    def test_respawn_tables_ranges_interval_and_normal_room_cap_are_canonical(self) -> None:
        zone_step = self.zone["Object"]["Segments"][0]["ZoneSteps"][0]
        actual = [(row["Spawn"]["Spawn"]["BaseForm"]["Species"], row["Rate"], row["Range"]) for row in zone_step["Spawns"]]
        expected = [
            (species, rate, {"Min": 0, "Max": 2}) for species, rate in tiny.FLOOR_ENEMIES[0]
        ] + [
            (species, rate, {"Min": 2, "Max": 3}) for species, rate in tiny.FLOOR_ENEMIES[2]
        ]
        self.assertEqual(actual, expected)
        self.assertEqual(zone_step["TeamSizes"], [{"Spawn": 1, "Rate": 1, "Range": {"Min": 0, "Max": 3}}])
        for floor_index in range(3):
            settings = one_step(alternatives(self.zone, floor_index)[0]["Spawn"], "MobSpawnSettingsStep")
            self.assertEqual(settings["Respawn"]["RespawnTime"], 36)
            self.assertEqual(settings["Respawn"]["MaxFoes"], 4)

    def test_five_extra_hallways_and_tiny_woods_tileset_are_on_every_alternative(self) -> None:
        for floor_index in range(3):
            for alt in alternatives(self.zone, floor_index):
                grid = alt["Spawn"]
                tunnel = one_step(grid, "AddTunnelStep")
                self.assertEqual(tunnel["Halls"], {"Min": 5, "Max": 5})
                self.assertEqual(tunnel["TurnLength"], {"Min": 3, "Max": 6})
                texture = one_step(grid, "MapTextureStep")
                self.assertEqual(
                    (texture["GroundTileset"], texture["BlockTileset"], texture["WaterTileset"]),
                    ("tiny_woods_floor", "tiny_woods_wall", "tiny_woods_secondary"),
                )

    def test_serialization_is_deterministic(self) -> None:
        first = tiny.canonical_json_bytes(tiny.build_zone())
        second = tiny.canonical_json_bytes(tiny.build_zone())
        self.assertEqual(first, second)
        self.assertEqual(hashlib.sha256(first).hexdigest(), hashlib.sha256(second).hexdigest())
        self.assertEqual(json.loads(first), self.zone)


@unittest.skipUnless(os.environ.get("PMDRED_EU_ROM"), "set PMDRED_EU_ROM")
class TinyWoodsEuRomIntegrationTests(unittest.TestCase):
    def test_builder_reauthenticates_selectors_properties_and_enemy_rates(self) -> None:
        source = tiny.validate_authoritative_rom(Path(os.environ["PMDRED_EU_ROM"]).read_bytes())
        self.assertEqual(source["rom_sha256"], tiny.EXPECTED_EU_ROM_SHA256)
        self.assertEqual(source["selector_rows"], [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 2, 3, 0],
            [1, 0, 0, 4, 1, 2, 3, 0],
            [2, 1, 0, 5, 1, 2, 3, 0],
        ])
        self.assertEqual(source["monster_weight_deltas"], [[3333, 3334, 3333], [2857, 1429, 2857, 2857]])


if __name__ == "__main__":
    unittest.main()
