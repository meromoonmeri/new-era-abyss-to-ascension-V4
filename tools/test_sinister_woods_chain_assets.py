#!/usr/bin/env python3
"""Asset-chain guards for the rebuilt canonical Sinister Woods route."""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MATERIALS = {"sinister_woods_b41_floor", "sinister_woods_b41_wall", "sinister_woods_b41_secondary"}


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))["Object"]


class SinisterWoodsChainAssetTests(unittest.TestCase):
    def test_boss_map_is_native_and_uses_only_the_unique_material(self):
        data = load(ROOT / "Data/Map/sinister_woods_boss.rsmap")
        self.assertEqual(data["$type"], "RogueEssence.Dungeon.Map, RogueEssence")
        self.assertEqual(data["AssetName"], "sinister_woods_boss")
        self.assertEqual(len(data["MapTeams"]), 3)
        materials = {
            tile["Data"]["TileTex"]["AutoTileset"]
            for column in data["Tiles"]
            for tile in column
        }
        self.assertEqual(materials, {"sinister_woods_b41_floor", "sinister_woods_b41_wall"})
        self.assertNotIn("treeshroud_forest_1_", json.dumps(data))

    def test_every_fixed_ground_uses_computed_auto_tiles_not_sheet_coordinates(self):
        for name in ("sinister_woods_entrance", "sinister_woods_mid", "sinister_woods_boss"):
            ground = load(ROOT / "Data/Ground" / f"{name}.rsground")
            self.assertEqual(ground["AssetName"], name)
            cells = [cell for layer in ground["Layers"] for column in layer["Tiles"] for cell in column]
            self.assertTrue(cells)
            self.assertTrue(all(cell["AutoTileset"] in MATERIALS for cell in cells))
            self.assertTrue(all(not cell["Layers"] for cell in cells))
            self.assertTrue(all(0 <= cell["NeighborCode"] <= 255 for cell in cells))

    def test_rawasset_dtef_bundle_is_complete_and_has_a_hash_manifest(self):
        folder = ROOT / "Content/TileDtef/sinister_woods/TreeshroudForest1"
        manifest = json.loads((folder / "RAWASSET_PROVENANCE.json").read_text())
        self.assertEqual(manifest["source_path"], "TileDtef/TreeshroudForest1")
        self.assertEqual(len(manifest["files"]), 28)
        self.assertTrue((folder / "tileset_0.png").is_file())
        self.assertTrue((folder / "tileset_1.png").is_file())
        self.assertTrue((folder / "tileset_2.png").is_file())

    def test_runtime_autotiles_and_sheet_are_registered(self):
        index = load(ROOT / "Data/AutoTile/index.idx")
        for material in MATERIALS:
            self.assertIn(material, index)
            self.assertTrue((ROOT / "Data/AutoTile" / f"{material}.json").is_file())
        self.assertTrue((ROOT / "Content/Tile/SinisterWoodsB41.tile").is_file())


if __name__ == "__main__":
    unittest.main(verbosity=2)
