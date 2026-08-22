#!/usr/bin/env python3
"""Regression guard for RawAsset DTEF imports used by canonical dungeons."""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/canonical_dungeons/dtef_import_manifest.json"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


class RawAssetDtefImportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = load(MANIFEST)["entries"]
        cls.index = load(ROOT / "Data/AutoTile/index.idx")["Object"]

    def test_source_packages_have_hash_manifests(self):
        for name, entry in self.manifest.items():
            source = ROOT / entry["source"]
            self.assertTrue((source / "RAWASSET_PROVENANCE.json").is_file(), name)
            self.assertTrue((source / "tileset_0.png").is_file(), name)

    def test_imported_autotiles_are_adjacent_mappings_with_real_sheet(self):
        expected_codes = 47
        imported = 0
        for name, entry in self.manifest.items():
            # SilverTrench3Floor contains only one DTEF tile type.  The
            # Treeshroud source was imported under the shorter explicit ID.
            ids = entry["autotiles"]
            if name == "TreeshroudForest1":
                ids = ["canon_treeshroud_wall", "canon_treeshroud_secondary", "canon_treeshroud_floor"]
            for auto_id in ids:
                imported += 1
                self.assertIn(auto_id, self.index)
                payload = load(ROOT / "Data/AutoTile" / f"{auto_id}.json")["Object"]
                self.assertEqual(payload["Tiles"]["$type"], "RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence")
                populated = sum(bool(value) for key, value in payload["Tiles"].items() if key.startswith("Tilex"))
                self.assertEqual(populated, expected_codes, auto_id)
                sheets = {
                    frame["Sheet"]
                    for variants in payload["Tiles"].values()
                    if isinstance(variants, list)
                    for layers in variants
                    for layer in layers
                    for frame in layer.get("Frames", [])
                }
                self.assertEqual(len(sheets), 1, auto_id)
                sheet = next(iter(sheets))
                self.assertTrue((ROOT / "Content/Tile" / f"{sheet}.tile").is_file(), sheet)
        self.assertGreaterEqual(imported, 64)


if __name__ == "__main__":
    unittest.main(verbosity=2)
