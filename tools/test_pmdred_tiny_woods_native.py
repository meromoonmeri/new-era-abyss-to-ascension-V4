#!/usr/bin/env python3
"""Unit tests for the exact-PMDO Tiny Woods native gate."""

from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load(name: str):
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


NATIVE = load("run_pmdred_tiny_woods_native")
RUNNER = load("run_pmdred_eu_native_fixture")


def passing_events() -> list[dict]:
    result = [{"event": kind} for kind in NATIVE.EVENT_ORDER]
    result[4] = {
        "event": "floor_probe",
        "bootstrap_seed": 424242,
        "adventure_seed": -1,
        "map_seed": 2,
        "requested_floor": 0,
        "zone": "tiny_woods",
        "segment": 0,
        "map": 0,
        "width": 28,
        "height": 30,
        "music": "Tiny Woods.ogg",
        "start": {"x": 1, "y": 1},
        "entries": [{"x": 1, "y": 1}],
        "terrain": {"floor": 100, "wall": 740},
        "effects": {"stairs_go_up": 1},
        "walkable": 100,
        "reachable": 100,
        "all_walkable_reachable": True,
        "stairs": [{
            "id": "stairs_go_up", "x": 8, "y": 8,
            "reachable": True, "distance": 14,
        }],
        "shortest_stair_route": 14,
        "items": [{
            "id": "", "money": True, "amount": 22,
            "x": 4, "y": 4, "reachable": True,
        }],
        "mobs": [
            {"species": "pidgey", "level": 1, "x": 5, "y": 5, "reachable": True},
            {"species": "sunkern", "level": 1, "x": 6, "y": 6, "reachable": True},
        ],
        "mob_count": 2,
        "traps": 0,
        "verdict": "PASS",
    }
    return result


class TinyWoodsNativeTests(unittest.TestCase):
    def test_validator_reseeds_before_silent_dungeon_entry(self) -> None:
        script = (ROOT / "tools/pmdred_tiny_woods_native_validator.lua").read_text()
        reseed = script.index("RogueElements.MathUtils.ReSeedRand(self.seed)")
        enter = script.index("GAME:EnterDungeon(")
        self.assertLess(reseed, enter)
        self.assertIn("DungeonStakes.Risk,true,true)", script)
        self.assertIn("eid=='stairs_go_up'", script)
        self.assertNotIn("eid=='stairs_go_down'", script)
        self.assertEqual(script.count("@@LAUNCHER_GROUND_INDEX@@"), 1)

    def test_generic_runner_environment_is_explicit_and_validated(self) -> None:
        parsed = RUNNER.parse_environment(["TINY_WOODS_FLOOR=2", "TINY_WOODS_SEED=424242"])
        self.assertEqual(parsed, {"TINY_WOODS_FLOOR": "2", "TINY_WOODS_SEED": "424242"})
        env = RUNNER.pmdo_env("tiny_woods_native_fixture", parsed)
        self.assertEqual(env["PMDO_GROUND_VALIDATOR"], "tiny_woods_native_fixture")
        self.assertEqual(env["TINY_WOODS_FLOOR"], "2")
        with self.assertRaises(ValueError):
            RUNNER.parse_environment(["NOT_AN_ASSIGNMENT"])
        with self.assertRaises(ValueError):
            RUNNER.parse_environment(["BAD-NAME=value"])
        with self.assertRaisesRegex(ValueError, "exact-runtime"):
            RUNNER.pmdo_env(
                "tiny_woods_native_fixture",
                {"LD_LIBRARY_PATH": "/untrusted"},
            )
        with self.assertRaisesRegex(ValueError, "exact-runtime"):
            RUNNER.pmdo_env(
                "tiny_woods_native_fixture",
                {"PMDO_GROUND_VALIDATOR": "bypass"},
            )

    def test_probe_accepts_exact_connected_floor_contract(self) -> None:
        probe = NATIVE.validate_probe(passing_events(), 0, 424242)
        self.assertEqual(probe["shortest_stair_route"], 14)

    def test_probe_rejects_disconnected_floor_and_wrong_stair(self) -> None:
        disconnected = passing_events()
        disconnected[4]["reachable"] = 99
        disconnected[4]["all_walkable_reachable"] = False
        with self.assertRaisesRegex(ValueError, "disconnected"):
            NATIVE.validate_probe(disconnected, 0, 424242)

        wrong_stair = passing_events()
        wrong_stair[4]["effects"] = {"stairs_go_down": 1}
        with self.assertRaisesRegex(ValueError, "stair/trap"):
            NATIVE.validate_probe(wrong_stair, 0, 424242)

    def test_probe_rejects_noncanonical_spawn_class(self) -> None:
        events = passing_events()
        events[4]["mobs"][0]["species"] = "mewtwo"
        with self.assertRaisesRegex(ValueError, "enemy identity"):
            NATIVE.validate_probe(events, 0, 424242)


if __name__ == "__main__":
    unittest.main()
