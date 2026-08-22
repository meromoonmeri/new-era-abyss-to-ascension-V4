#!/usr/bin/env python3
"""Transition contract for the rebuilt canonical Chapter 6 route.

The former test executed an optional Team Dazzling relay duel in segment 7,
which was deleted with the obsolete chapter substitute.  This guard instead
checks the three real canonical transitions: 10F -> checkpoint, 12F -> boss
Ground, boss result -> town/checkpoint.
"""
from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ZONE_SCRIPT = ROOT / "Data/Script/halcyon/zone/gloomy_forest/init.lua"
MID_SCRIPT = ROOT / "Data/Script/halcyon/ground/sinister_woods_mid/init.lua"
BOSS_SCRIPT = ROOT / "Data/Script/halcyon/ground/sinister_woods_boss/init.lua"


class Chapter6CanonicalTransitionTests(unittest.TestCase):
    def test_zone_has_only_the_three_canonical_segments(self):
        source = ZONE_SCRIPT.read_text(encoding="utf-8")
        self.assertIn("segmentID == 0", source)
        self.assertIn("segmentID == 1", source)
        self.assertNotIn("segmentID == 7", source)
        self.assertNotIn("gloomy_forest_miniboss", source)

    def test_ten_floor_checkpoint_and_twelve_floor_boss_ground_are_explicit(self):
        source = ZONE_SCRIPT.read_text(encoding="utf-8")
        self.assertIn("GAME:EnterGroundMap('sinister_woods_mid'", source)
        self.assertIn("GAME:EnterGroundMap('sinister_woods_boss'", source)
        self.assertIn("SinisterWoodsCheckpoint", source)

    def test_midpoint_keeps_kangaskhan_and_continues_only_to_segment_one(self):
        source = MID_SCRIPT.read_text(encoding="utf-8")
        self.assertIn("Kangashkhan_Rock_Interact", source)
        self.assertIn("GAME:EnterDungeon('gloomy_forest', 1", source)
        self.assertNotIn("', 7,", source)

    def test_boss_ground_loads_the_fixed_thirteenth_floor(self):
        source = BOSS_SCRIPT.read_text(encoding="utf-8")
        self.assertIn("GAME:EnterDungeon('gloomy_forest', 2", source)
        self.assertIn("Team Meanies", source)


if __name__ == "__main__":
    unittest.main(verbosity=2)
