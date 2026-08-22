#!/usr/bin/env python3
"""Validate MapStatus data and the canonical darkness use in Sinister Woods.

``deep_shadow`` remains a reusable PMDO family setter for other content, but
clean canonical Sinister Woods must use the RB darkness floors directly rather
than inherit the former New Era deep-shadow extension.
"""
from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path
from typing import Any, Iterator

ROOT = Path(__file__).resolve().parents[1]
STATUS_PATH = ROOT / "Data/MapStatus/deep_shadow.json"
INDEX_PATH = ROOT / "Data/MapStatus/index.idx"
ZONE_PATH = ROOT / "Data/Zone/gloomy_forest.json"
DEFAULT_IDS = ("darkness", "dusk")


def load(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def walk(value: Any) -> Iterator[Any]:
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def find_nodes(value: Any, key: str, expected: Any) -> list[dict[str, Any]]:
    return [
        node for node in walk(value)
        if isinstance(node, dict) and node.get(key) == expected
    ]


class DeepShadowMapStatus(unittest.TestCase):
    def test_family_setter_schema_is_not_a_visual_copy(self):
        self.assertTrue(STATUS_PATH.is_file())
        obj = load(STATUS_PATH)["Object"]
        self.assertEqual(obj["$type"], "RogueEssence.Data.MapStatusData, RogueEssence")
        self.assertTrue(obj["DefaultHidden"])
        self.assertEqual(obj["Emitter"]["$type"], "RogueEssence.Content.EmptySwitchOffEmitter, RogueEssence")
        self.assertEqual(obj["RepeatMethod"]["$type"], "PMDC.Dungeon.MapStatusReplaceEvent, PMDC")
        states = obj["StatusStates"]
        self.assertEqual(len(states), 1)
        self.assertEqual(states[0]["$type"], "RogueEssence.Dungeon.MapIDState, RogueEssence")
        self.assertEqual(states[0]["ID"], "")
        self.assertIn("family setter", obj["Comment"])
        self.assertNotIn("OverlayEmitter", json.dumps(obj))

    def test_weather_fill_is_installed_at_start_and_refresh(self):
        obj = load(STATUS_PATH)["Object"]
        starts = obj["OnMapStarts"]
        self.assertEqual(len(starts), 1)
        self.assertEqual(starts[0]["Value"]["$type"], "PMDC.Dungeon.WeatherFillEvent, PMDC")
        turn_ends = obj["OnMapTurnEnds"]
        self.assertEqual(len(turn_ends), 1)
        self.assertEqual(turn_ends[0]["Key"]["str"], [6])
        self.assertEqual(turn_ends[0]["Value"]["$type"], "PMDC.Dungeon.WeatherFillEvent, PMDC")

    def test_canonical_zone_uses_rb_darkness_not_the_old_deep_shadow_extension(self):
        zone = load(ZONE_PATH)["Object"]
        payload = json.dumps(zone)
        self.assertNotIn("deep_shadow", payload)
        setters = [
            node for node in walk(zone)
            if isinstance(node, dict)
            and node.get("$type", "").startswith("PMDC.LevelGen.StateMapStatusStep")
            and node.get("MapStatus") == "darkness"
        ]
        # Five official dark floors, each with three runtime layout families.
        self.assertEqual(len(setters), 15)
        status = load(ROOT / "Data/MapStatus/darkness.json")["Object"]
        self.assertTrue(any(
            isinstance(node, dict)
            and node.get("$type") == "RogueEssence.Dungeon.MapWeatherState, RogueEssence"
            for node in status["StatusStates"]
        ))

    def test_index_registers_the_status(self):
        index = load(INDEX_PATH)["Object"]
        self.assertIn("deep_shadow", index)
        self.assertEqual(index["deep_shadow"]["Name"]["DefaultText"], "Deep Shadow")
        self.assertTrue(index["deep_shadow"]["Released"])

    def test_production_inputs_are_pinned_for_the_proof(self):
        # These are the inputs used by the reconstruction record.  They make
        # accidental edits to the two visual defaults visible in review.
        self.assertEqual(
            hashlib.sha256((ROOT / "Data/MapStatus/darkness.json").read_bytes()).hexdigest(),
            "dbe7bfa569bdeb018cb3e0a78b5afe0f928be6094610eac95edc190e0d19e0ac",
        )
        self.assertEqual(
            hashlib.sha256((ROOT / "Data/MapStatus/dusk.json").read_bytes()).hexdigest(),
            "87473f22e2bd800e4c15c65ef246dc56f9f0a60dbb6c62d07aa412df443561b1",
        )


if __name__ == "__main__":
    unittest.main()
