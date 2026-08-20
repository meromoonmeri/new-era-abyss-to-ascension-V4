#!/usr/bin/env python3
"""Focused topology tests for the deterministic early-dungeon renderer."""

from __future__ import annotations

import unittest

from pmdred_early_dungeon import (
    build_chance_floor,
    build_red_large_chance_floor,
    map_item,
)
from render_pmdred_early_dungeon import build_floor_model, select_grid_generator


COMMON = {
    "music": "Sinister Woods.ogg",
    "texture_family": "sinister_woods",
    "monsters": [("oddish", 3, 1)],
    "enemy_count_weights": [(1, 1)],
    "items": [(map_item("berry_oran"), 1)],
    "item_count_weights": [(1, 1)],
    "trap_count_weights": [(1, 1)],
    "extra_hallways": 5,
    "connectivity_ratio": 20,
}


class SequenceRNG:
    def __init__(self, values: list[int]):
        self.values = iter(values)

    def randbelow(self, stop: int) -> int:
        value = next(self.values)
        if not 0 <= value < stop:
            raise AssertionError((value, stop))
        return value


class RepresentativeTopologyTests(unittest.TestCase):
    def test_room_bag_cardinality_hall_anchors_and_normal_room_stairs(self) -> None:
        chance = build_chance_floor(
            geometry=[((6, 4, 8), 1)],
            valid_columns=3,
            **COMMON,
        )
        model = build_floor_model(5, {"Item": chance}, "sinister-test")
        self.assertEqual(model.config["serialized_normal_rooms"], 8)
        self.assertEqual(model.config["serialized_hall_anchors"], 16)
        self.assertEqual(
            (model.config["grid"]["cells_x"], model.config["grid"]["cells_y"]),
            (6, 4),
        )
        self.assertIn(model.start, model.room_floor)
        self.assertIn(model.stairs, model.room_floor)
        self.assertGreaterEqual(
            len(model.route) - 1,
            model.config["minimum_stair_distance"],
        )
        self.assertTrue(all(model.terrain[y][x] == "floor" for x, y in model.route))

    def test_recursive_retry_reference_resolves_to_shared_grid_selector(self) -> None:
        chance = build_red_large_chance_floor(
            room_density=8,
            reference_id="sinister-floor-5-accepted",
            **COMMON,
        )
        # The shallow registry deterministically selects its one positive-rate
        # root; trial 1 then fails (roll 41), trial 2 succeeds (roll 0), and
        # accepted geometry/room outcome zero is selected from 45 outcomes.
        generator, trace = select_grid_generator(chance, SequenceRNG([0, 41, 0, 0]))
        self.assertEqual(len(trace), 4)
        self.assertEqual([entry["index"] for entry in trace], [34, 1, 0, 0])
        grid = next(
            pair["Value"] for pair in generator["GenSteps"]
            if "CellX" in pair["Value"]
        )
        path = next(
            pair["Value"] for pair in generator["GenSteps"]
            if "GenericRooms" in pair["Value"]
        )
        square_count = sum(
            "RoomGenSquare" in room.get("$type", "")
            for room in path["GenericRooms"]["ToSpawn"]
        )
        self.assertEqual((grid["CellX"], grid["CellY"]), (2, 2))
        self.assertEqual(square_count, 4)  # density 8 capped to the four cells


if __name__ == "__main__":
    unittest.main()
