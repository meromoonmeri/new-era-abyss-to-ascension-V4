#!/usr/bin/env python3
"""Guard the runtime fix for Sinister Woods b41 shared tile data.

AutoTiles are loaded once and shared between dungeon maps.  A delayed map
callback must therefore never rotate/remove frames in those global lists.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
SERVICE = ROOT / "Data/Script/halcyon/services/sinister_woods_b41_startup_adapter/init.lua"


class SinisterWoodsRuntimeTileSafetyTests(unittest.TestCase):
    def test_compatibility_service_does_not_mutate_shared_autotiles(self) -> None:
        source = SERVICE.read_text(encoding="utf-8")
        self.assertIn("SCRIPT:AddService('SinisterWoodsB41StartupAdapter', V:new())", source)
        self.assertIn("Intentionally no DungeonMapInit subscription", source)
        for forbidden in ("RemoveAt(", "Insert(", "Frames:Add(", "GAME:WaitFrames("):
            self.assertNotIn(forbidden, source, forbidden)


if __name__ == "__main__":
    unittest.main()
