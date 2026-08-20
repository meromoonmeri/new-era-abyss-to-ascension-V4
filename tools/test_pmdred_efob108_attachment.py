#!/usr/bin/env python3
"""Regression gates for the archived native Caterpie/efob108 attachment proof."""
from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

from tools import run_pmdred_efob108_attachment_certification as runner

ROOT = Path(__file__).resolve().parents[1]
V1 = ROOT / "docs/pmdred_eu/playable/tiny_woods/efob108_attachment_runtime_v1"
V2 = ROOT / "docs/pmdred_eu/playable/tiny_woods/efob108_attachment_runtime_v2"
PARTICLE = ROOT / "Content/Particle/PMDRed_Efob108.dir"
PARTICLE_MANIFEST = ROOT / "docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json"
PROGRESS = ROOT / "docs/pmdred_eu/playable/progress.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def assert_hash_inventory(case: unittest.TestCase, archive: Path) -> None:
    for line in (archive / "evidence_hashes.sha256").read_text(encoding="utf-8").splitlines():
        expected, name = line.split(None, 1)
        path = archive / name.removeprefix("./")
        case.assertTrue(path.is_file(), str(path))
        case.assertEqual(sha256(path), expected, name)


class Efob108AttachmentTests(unittest.TestCase):
    def test_v2_archive_trace_and_strict_native_termination(self) -> None:
        assert_hash_inventory(self, V2)
        items = runner.read_events(V2 / "events.jsonl")
        trace = runner.validate_trace(items)
        termination = runner.strict_termination(V2 / "termination.json")
        report = json.loads((V2 / "native_attachment_validation.json").read_text(encoding="utf-8"))

        self.assertEqual(len(items), 44)
        self.assertEqual(report["schema"], "pmdred-eu-efob108-attachment-native-v1")
        self.assertEqual(report["status"], "passed")
        self.assertEqual(report["runtime"]["version"], "0.8.12.0")
        self.assertEqual(report["runtime"]["executable_sha256"], runner.PMDO_SHA256)
        self.assertEqual(report["authority"]["rom_sha256"], runner.ROM_SHA256)
        self.assertEqual(report["authority"]["particle_sha256"], runner.PARTICLE_SHA256)
        self.assertEqual(report["trace"], trace)
        self.assertEqual(report["termination"]["exit_classification"], "NORMAL_EXIT")
        self.assertEqual(report["termination"]["return_code"], 0)
        self.assertTrue(report["termination"]["terminal"])
        self.assertTrue(report["termination"]["graceful"])
        self.assertTrue(termination["load_phase_unload"]["pass"])
        self.assertEqual(
            termination["load_phase_unload"]["terminal_event"]["load_phase"], "Unload"
        )
        self.assertTrue(all(report["assertions"].values()))

    def test_particle_and_checkpoint_are_hash_bound(self) -> None:
        progress = json.loads(PROGRESS.read_text(encoding="utf-8"))
        checkpoint = progress["tiny_woods"]["narrative_scenes"]["efob108_attachment_semantics"]
        report = V2 / "native_attachment_validation.json"

        self.assertEqual(sha256(PARTICLE), runner.PARTICLE_SHA256)
        self.assertEqual(sha256(PARTICLE_MANIFEST), report_hash := "3d1d74e7b84e3517bb98ef820c8de82a87831291e4663aa2ac160acabf59085c")
        self.assertEqual(checkpoint["status"], "PASS")
        self.assertEqual(checkpoint["particle_sha256"], runner.PARTICLE_SHA256)
        self.assertEqual(checkpoint["particle_manifest_sha256"], report_hash)
        self.assertEqual(checkpoint["report_sha256"], sha256(report))
        self.assertEqual(checkpoint["source_arguments"], [62, 0])
        self.assertEqual(checkpoint["selected_coordinate_convention"], "eu_center_to_pmdo_top_left_minus_8_minus_8")
        self.assertEqual(checkpoint["normalized_candidate"]["effect_center"], [179, 149])
        self.assertEqual(
            progress["resume"]["next_phase"],
            "early_dungeon_bulk_after_mt_steel_begin_sinister_woods",
        )

    def test_v1_parser_failure_is_preserved_without_false_native_failure(self) -> None:
        assert_hash_inventory(self, V1)
        diagnostic = json.loads((V1 / "CERTIFICATION_DIAGNOSTIC.json").read_text(encoding="utf-8"))
        self.assertEqual(diagnostic["status"], "preserved_parser_failure")
        self.assertEqual(diagnostic["native_runtime_status"], "PASS")
        self.assertEqual(diagnostic["failure"]["message"], "attachment event count differs: 44")
        self.assertFalse(diagnostic["failure"]["runtime_or_semantic_failure"])
        self.assertEqual(diagnostic["preservation"]["exit_classification"], "NORMAL_EXIT")
        self.assertEqual(diagnostic["preservation"]["return_code"], 0)
        self.assertTrue(diagnostic["preservation"]["terminal"])
        self.assertTrue(diagnostic["preservation"]["graceful"])


if __name__ == "__main__":
    unittest.main()
