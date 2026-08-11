#!/usr/bin/env python3
"""Regression tests for the EU PMD Red PMDO graphical converter."""

from __future__ import annotations

import hashlib
import json
import struct
import tempfile
import unittest
from pathlib import Path

import convert_red_all as converter


class BpaTimingTests(unittest.TestCase):
    def test_post_decrement_durations_include_zero_duration_frame(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "anim.bpa"
            header = bytes((1, 0)) + struct.pack("<h2i", 2, 0, 2)
            path.write_bytes(header + bytes(2 * 32))
            slot = converter.parse_bpa([str(path)])[0]
        self.assertEqual(slot["source_durations"], [0, 2])
        self.assertEqual(slot["durations"], [1, 3])
        self.assertEqual(slot["cycle"], 4)

        renderer = converter.Renderer(
            [bytes(32)], [slot], [[(0, 0, 0, 0)] * 16], {}, [(0, 0)], [[0]]
        )
        self.assertEqual([renderer.bpa_frame_at(0, tick) for tick in range(8)],
                         [0, 1, 1, 1, 0, 1, 1, 1])

    def test_slot_gap_identity_is_preserved_without_consuming_tiles(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("slot0.bpa", "slot2.bpa"):
                (root / name).write_bytes(bytes((1, 0)) + struct.pack("<hi", 1, 0) + bytes(32))
            slots = converter.parse_bpa([
                str(root / "slot0.bpa"), None, str(root / "slot2.bpa"), None
            ])
        self.assertEqual([slot is None for slot in slots], [False, True, False, True])
        renderer = converter.Renderer(
            [bytes(32)], slots, [[(0, 0, 0, 0)] * 16], {}, [(0, 0)], [[0]]
        )
        self.assertEqual(renderer.bpa_location(1), (0, 0))
        self.assertEqual(renderer.bpa_location(2), (2, 0))


class BlankSentinelTests(unittest.TestCase):
    def test_out_of_range_tile_reference_is_canonical_blank(self) -> None:
        palette = [(0, 0, 0, 0)] + [(255, 0, 255, 255)] * 15
        renderer = converter.Renderer([bytes(32)], [], [palette], {}, [(0, 0)], [[0]])
        self.assertEqual(set(renderer.tile(1023, 0, 0).tobytes()), {0})


class CollisionTests(unittest.TestCase):
    def test_collision_uses_camera_dimensions_and_vertical_xor(self) -> None:
        # 2x2 camera, one 2x1 map layer, collision deltas [0,1]/[1,0].
        header = bytes((2, 2, 2, 2, 2, 1)) + struct.pack("<HHH", 1, 0, 1)
        layer = bytes((0x00,))
        collision = bytes((0x00, 0x81, 0x00))
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "map.bma"
            path.write_bytes(header + layer + collision)
            layers, width, height = converter.decode_bma_collision(str(path))
        self.assertEqual((width, height), (2, 2))
        self.assertEqual(layers, [[False, True, True, True]])


class DryRunTests(unittest.TestCase):
    def test_conversion_dry_run_has_provenance_collision_absence_and_no_writes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "MAP.bpl").write_bytes(struct.pack("<hh", 1, 0) + bytes(60))
            bpc_header = bytearray(16)
            struct.pack_into("<HHH", bpc_header, 0, 1, 1, 1)
            struct.pack_into("<H", bpc_header, 14, 1)
            (root / "MAPc.bpc").write_bytes(bpc_header)
            # Camera/chunk dimensions 2x1, one blank graphical pair, no collision.
            bma = bytes((2, 1, 2, 1, 2, 1)) + struct.pack("<HHH", 1, 0, 0) + bytes((0,))
            (root / "MAPm.bma").write_bytes(bma)
            old = converter.RED, converter.OUT_G, converter.OUT_T
            converter.RED = str(root)
            converter.OUT_G = str(root / "grounds")
            converter.OUT_T = str(root / "tiles")
            try:
                result = converter.convert(
                    "map", "MAP", "MAPc", "MAPm", [None] * 4,
                    apply=False, dep_key="EU map_file_id=0",
                    source_hashes={"MAP": "proof"},
                )
            finally:
                converter.RED, converter.OUT_G, converter.OUT_T = old
            self.assertEqual(result["source_normalized_sha256"], {"MAP": "proof"})
            self.assertEqual(result["collision_layers"], 0)
            self.assertEqual(result["solid_cells"], 0)
            self.assertEqual(result["dims"], (2, 1))
            self.assertFalse((root / "grounds").exists())
            self.assertFalse((root / "tiles").exists())


class AuthorityTests(unittest.TestCase):
    def test_source_files_must_match_manifest_hashes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            payloads = {
                "MAP.bpl": b"palette",
                "MAPc.bpc": b"chunks",
                "MAPm.bma": b"layout",
            }
            for name, payload in payloads.items():
                (root / name).write_bytes(payload)
            resources = []
            for name, resource_type in (("MAP", "bpl"), ("MAPc", "bpc"), ("MAPm", "bma")):
                payload = payloads[name + "." + resource_type]
                resources.append({
                    "name": name,
                    "type": resource_type,
                    "normalized_sha256": hashlib.sha256(payload).hexdigest(),
                })
            manifest = {
                "authority": {"rom": {"sha256": converter.eu_audit.EXPECTED_ROM_SHA256}},
                "validation": {"status": "pass"},
                "ground_archive": {"resources": resources},
                "map_files_table": {"entries": [{
                    "map_file_id": 0,
                    "bpl": "MAP", "bpc": "MAPc", "bma": "MAPm",
                    "bpa_0": None, "bpa_1": None, "bpa_2": None, "bpa_3": None,
                }]},
            }
            manifest_path = root / "manifest.json"
            manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
            jobs = converter.load_authoritative_jobs(str(manifest_path), str(root))
            self.assertEqual(len(jobs), 1)
            self.assertEqual(jobs[0][1]["bpa"], [None, None, None, None])
            (root / "MAPc.bpc").write_bytes(b"tampered")
            with self.assertRaises(ValueError):
                converter.load_authoritative_jobs(str(manifest_path), str(root))


if __name__ == "__main__":
    unittest.main()
