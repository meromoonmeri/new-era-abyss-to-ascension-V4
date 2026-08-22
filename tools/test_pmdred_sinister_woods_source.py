#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import unittest

import audit_pmdred_sinister_woods_source as audit

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / "docs/pmdred_eu/playable/sinister_woods/source_manifest_2026-08-21.json"
MUSIC_TILE_GATE = ROOT / "docs/pmdred_eu/playable/sinister_woods/canonical_music_tiles_gate_2026-08-21.json"
ROM = Path(os.environ.get("PMDRED_EU_ROM", ROOT / ".runtime-cache/downloads/pmdred-eu.gba"))
PRET = Path(os.environ.get("PMDRED_PRET_ROOT", ROOT / ".runtime-cache/pmd-red-reference"))
REPORT_SHA256 = "8c33755d0ad313f7c8f6757a0e06f109cde3dea51bc7609122ec2871064189e4"


class SinisterWoodsSourceTests(unittest.TestCase):
    def test_committed_report_identity_and_scope(self) -> None:
        self.assertEqual(hashlib.sha256(REPORT.read_bytes()).hexdigest(), REPORT_SHA256)
        data = json.loads(REPORT.read_text())
        self.assertEqual(data["validation"]["status"], "PASS")
        self.assertEqual(data["dungeon"]["playable_floor_count"], 13)
        self.assertEqual(data["dungeon"]["procedural_tileset"], 41)
        self.assertEqual(data["dungeon"]["ending_material_tileset"], 65)
        self.assertEqual(data["validation"]["item_table_ids"], [1, 2, 3, 11, 12])
        self.assertEqual(data["validation"]["trap_table_ids"], [2])

    def test_monster_tables_cover_canonical_first_and_boss_floors(self) -> None:
        floors = json.loads(REPORT.read_text())["floors"]
        self.assertEqual([(x["species"], x["level"], x["probability"]) for x in floors[0]["monsters"]], [
            ("oddish", 7, 1579), ("sudowoodo", 7, 4210), ("swinub", 8, 4211),
        ])
        self.assertEqual([(x["species"], x["level"], x["probability"]) for x in floors[12]["monsters"]], [
            ("ekans", 15, 3333), ("gengar", 15, 3334), ("medicham", 12, 3333),
        ])
        self.assertEqual(floors[7]["selector"]["monster_spawn_index"], 17)
        self.assertEqual(floors[8]["selector"]["monster_spawn_index"], 17)

    def test_active_music_and_b41_assets_match_the_canonical_gate(self) -> None:
        gate = json.loads(MUSIC_TILE_GATE.read_text())
        self.assertEqual(gate["status"], "PASS_CANONICAL_MUSIC_TILESET_ACTIVE_ROM_EXACT")
        # The music gate remains byte-exact.  The historical b41 chunk atlas
        # was superseded because its 16-column layout did not preserve the
        # native RogueEssence sparse AutoTile topology; see the dedicated
        # RogueElements promotion test for the live tile route.
        record = gate["music"]
        self.assertEqual(hashlib.sha256((ROOT / record["path"]).read_bytes()).hexdigest(), record["sha256"])
        zone_text = (ROOT / gate["zone_validation"]["zone"]).read_text(encoding="utf-8-sig")
        self.assertIn("Sinister Woods.ogg", zone_text)
        for name in ("sinister_woods_floor", "sinister_woods_wall", "sinister_woods_secondary"):
            self.assertIn(name, zone_text)
        self.assertNotIn("treeshroud_forest_1_", zone_text)
        self.assertNotIn("relic_forest_blob_", zone_text)

    @unittest.skipUnless(ROM.is_file() and PRET.is_dir(), "authenticated ROM/pret unavailable")
    def test_fresh_build_is_semantically_deterministic(self) -> None:
        expected = json.loads(REPORT.read_text())
        self.assertEqual(audit.build(ROM, PRET), expected)


if __name__ == "__main__":
    unittest.main()
