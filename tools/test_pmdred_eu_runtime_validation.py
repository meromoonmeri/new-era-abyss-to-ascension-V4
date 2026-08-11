#!/usr/bin/env python3
"""Focused regressions for the ignored PMDO runtime fixture and PNG comparator."""

from __future__ import annotations

import importlib.util
import struct
import sys
import tempfile
import unittest
from pathlib import Path

TOOLS = Path(__file__).parent
ROOT = TOOLS.parent


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, TOOLS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


FIXTURE = load("build_pmdred_eu_runtime_fixture")
COMPARE = load("compare_pmdred_eu_pmdo_renders")


class TileIndexTests(unittest.TestCase):
    @staticmethod
    def node(seed: int) -> bytes:
        return struct.pack("<ii", seed, 1) + bytes(range(16))

    def test_tile_index_round_trip_is_exact(self) -> None:
        nodes = {"alpha": self.node(7), "épreuve": self.node(9)}
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            FIXTURE.write_tile_index(path, nodes)
            self.assertEqual(FIXTURE.read_tile_index(path), nodes)

    def test_tile_index_rejects_duplicate_names(self) -> None:
        name = b"same"
        entry = FIXTURE.write_7bit_int(len(name)) + name + self.node(1)
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_bytes(struct.pack("<i", 2) + entry + entry)
            with self.assertRaisesRegex(ValueError, "duplicate"):
                FIXTURE.read_tile_index(path)

    def test_tile_node_rejects_truncation(self) -> None:
        with self.assertRaisesRegex(ValueError, "invalid PMDO tile node"):
            FIXTURE.tile_node(struct.pack("<ii", 0, 1) + b"short")


class RuntimeEvidenceTests(unittest.TestCase):
    def test_canonical_apng_decodes_every_stored_state(self) -> None:
        frames = COMPARE.decode_png(
            ROOT / "docs/pmdred_eu/dungeon_grounds/d02p02/animation.png"
        )
        self.assertEqual(len(frames), 4)
        self.assertTrue(all(frame.width == 360 and frame.height == 336 for frame in frames))
        self.assertTrue(all(all(frame.rgba[i] == 255 for i in range(3, len(frame.rgba), 4)) for frame in frames))

    def test_rgba_encoder_round_trip(self) -> None:
        rgba = bytes((1, 2, 3, 255, 40, 50, 60, 127, 250, 0, 99, 0, 4, 5, 6, 255))
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "sample.png"
            COMPARE.encode_rgba(path, 2, 2, rgba)
            self.assertEqual(COMPARE.decode_png(path)[0].rgba, rgba)

    def test_targeted_report_proves_reentry_exit_and_final_cleanup(self) -> None:
        report = FIXTURE.read_json(
            ROOT / "docs/pmdred_eu/pmdo_validation/route193_reentry.json"
        )
        runtime = report["runtime"]
        self.assertEqual(runtime["validation_count"], 2)
        self.assertEqual(runtime["same_ground_reentry_count"], 1)
        self.assertEqual(runtime["observed_ground_exit_count"], 1)
        self.assertEqual(runtime["cleanup_probe_count"], 2)
        self.assertTrue(runtime["all_runtime_safe"])
        self.assertTrue(runtime["runtime_sequence_consistent"])
        self.assertTrue(runtime["all_cleanups_pass"])
        self.assertTrue(runtime["end_event_seen"])


if __name__ == "__main__":
    unittest.main()
