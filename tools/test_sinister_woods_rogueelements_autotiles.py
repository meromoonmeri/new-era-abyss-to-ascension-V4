#!/usr/bin/env python3
"""Validate the live RogueEssence AutoTile route for Sinister Woods."""
from __future__ import annotations

import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
ZONE = ROOT / "Data/Zone/gloomy_forest.json"
INDEX = ROOT / "Data/AutoTile/index.idx"
EXPECTED = {
    "GroundTileset": "sinister_woods_floor",
    "BlockTileset": "sinister_woods_wall",
    "WaterTileset": "sinister_woods_secondary",
}


def walk(value):
    if isinstance(value, dict):
        yield value
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def frames(value):
    if isinstance(value, dict):
        if "Frames" in value:
            yield from value["Frames"]
        for child in value.values():
            yield from frames(child)
    elif isinstance(value, list):
        for child in value:
            yield from frames(child)


class RogueElementsAutoTileTests(unittest.TestCase):
    def test_every_sinister_map_texture_step_uses_live_autotiles(self):
        zone = json.loads(ZONE.read_text(encoding="utf-8-sig"))
        steps = [node for node in walk(zone) if node.get("$type", "").startswith("RogueEssence.LevelGen.MapTextureStep")]
        self.assertEqual(len(steps), 3)
        for step in steps:
            self.assertEqual({key: step[key] for key in EXPECTED}, EXPECTED)

    def test_sparse_atlas_preserves_the_authentic_rogueelements_topology(self):
        index = json.loads(INDEX.read_text(encoding="utf-8-sig"))["Object"]
        for kind in ("floor", "wall", "secondary"):
            resource = f"sinister_woods_{kind}"
            self.assertIn(resource, index)
            document = json.loads((ROOT / "Data/AutoTile" / f"{resource}.json").read_text(encoding="utf-8-sig"))
            actual = list(frames(document))
            self.assertTrue(actual)
            self.assertTrue(all(frame["Sheet"] == "SinisterWoods" for frame in actual))
            # Every frame must be backed by the promoted sparse sheet.  The
            # sheet's authenticated topology extends beyond 16 columns; the
            # old 16-column chunk atlas could not represent all positions.
            self.assertTrue(all(frame["TexLoc"]["X"] >= 0 and frame["TexLoc"]["Y"] >= 0 for frame in actual))
        import struct
        sheet = (ROOT / "Content/Tile/SinisterWoods.tile").read_bytes()
        _, count = struct.unpack_from("<ii", sheet)
        coords = [struct.unpack_from("<ii", sheet, 8 + index * 16) for index in range(count)]
        self.assertEqual(count, 1598)
        self.assertGreater(max(x for x, _ in coords), 15)


if __name__ == "__main__":
    unittest.main()
