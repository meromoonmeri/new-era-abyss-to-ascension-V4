#!/usr/bin/env python3
"""Regression gates for the native PMDO Mount Steel 9F serializer."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import unittest

import build_pmdred_mt_steel as builder
from render_pmdred_early_dungeon import loaded_ally_entities, loaded_hostile_entities
from validate_pmdred_early_dungeon import loaded_allies, loaded_hostiles


def load_floor(zone: dict) -> dict:
    found: list[dict] = []

    def walk(value):
        if isinstance(value, dict):
            if "LoadGen" in value.get("$type", ""):
                found.append(value)
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)

    walk(zone)
    assert len(found) == 1
    return found[0]


ROOT = Path(__file__).resolve().parents[1]
ROUTE_EVIDENCE = ROOT / "docs/pmdred_eu/playable/mt_steel/native_route_2026-08-21"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class MountSteelNativeFixTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.zone, cls.arena, _ = builder.build()
        cls.floor = load_floor(cls.zone)

    def test_static_map_uses_native_0812_container_without_characters(self) -> None:
        obj = self.arena["Object"]
        self.assertEqual(self.arena["Version"], "0.8.12.0")
        self.assertEqual(obj["rand"]["$type"], "RogueElements.ReRandom, RogueElements")
        self.assertEqual(obj["MapTeams"], [])
        self.assertEqual(obj["AllyTeams"], [])
        self.assertEqual(obj["Decorations"], [{
            "Name": "Mt Acier — décor", "Layer": 0, "Visible": True, "Anims": [],
        }])

    def test_battle_positions_are_entry_relative(self) -> None:
        starts = self.arena["Object"]["MapEffect"]["OnMapStarts"][0]["Value"]["StartLocs"]
        self.assertEqual([entry["Loc"] for entry in starts], [
            {"X": 0, "Y": 0}, {"X": -1, "Y": 1}, {"X": 1, "Y": 1},
        ])

    def test_loaded_hostile_and_ally_are_typed_and_exact(self) -> None:
        hostile = [{"id": "skarmory", "level": 10, "x": 4, "y": 8, "direction": 0}]
        ally = [{"id": "diglett", "level": 5, "x": 4, "y": 3, "direction": 0}]
        self.assertEqual(loaded_hostiles(self.floor, 9), hostile)
        self.assertEqual(loaded_allies(self.floor, 9), ally)
        self.assertEqual(loaded_hostile_entities(self.floor, 9), [{
            "kind": "enemy", **hostile[0],
        }])
        self.assertEqual(loaded_ally_entities(self.floor, 9), [{
            "kind": "ally", **ally[0],
        }])

    def test_diglett_spawn_retains_protection_and_wait_tactic(self) -> None:
        ally_step = next(
            entry["Value"] for entry in self.floor["GenSteps"]
            if entry["Value"].get("Ally") is True
        )
        mob = ally_step["Spawn"]["Spawns"][0]["Spawns"][0]
        self.assertEqual(mob["Tactic"], "wait_only")
        types = [feature["$type"] for feature in mob["SpawnFeatures"]]
        self.assertIn("RogueEssence.LevelGen.MobSpawnStatus, RogueEssence", types)
        self.assertIn("PMDC.LevelGen.MobSpawnUnrecruitable, PMDC", types)
        status = next(feature for feature in mob["SpawnFeatures"] if "MobSpawnStatus" in feature["$type"])
        self.assertEqual(status["Statuses"][0]["Spawn"]["ID"], "all_protect")
        self.assertEqual(status["Statuses"][0]["Spawn"]["StatusStates"][0]["Counter"], -1)

    def test_route_adapter_targets_the_current_dungeon_zone(self) -> None:
        script = (ROUTE_EVIDENCE / "RedEarlyDungeonRoute.lua").read_text()
        self.assertIn("result,\n      zone.ID,\n      -1,", script)
        self.assertNotIn("result,\n      config.ending_ground,\n      -1,", script)

    def test_native_route_evidence_is_integral_and_non_promoting(self) -> None:
        report = json.loads((ROUTE_EVIDENCE / "validation.json").read_text())
        self.assertEqual(report["status"], "PASS_NATIVE_BOSS_CLEAR_ENDING_RETURN")
        self.assertFalse(report["promotion_allowed"])
        self.assertTrue(all(report["assertions"].values()))
        for line in (ROUTE_EVIDENCE / "HASHES.sha256").read_text().splitlines():
            expected, name = line.split("  ", 1)
            self.assertEqual(sha256(ROUTE_EVIDENCE / name), expected)


if __name__ == "__main__":
    unittest.main()
