#!/usr/bin/env python3
"""Regression gates for archived command-complete Tiny Woods native evidence."""
from __future__ import annotations

import hashlib
import importlib.util
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_complete_runtime_v2"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_runner():
    path = ROOT / "tools/run_pmdred_tiny_woods_command_complete.py"
    spec = importlib.util.spec_from_file_location("run_pmdred_tiny_woods_command_complete", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class TinyWoodsCommandCompleteNativeTests(unittest.TestCase):
    def test_archived_evidence_hashes_and_strict_native_runs(self) -> None:
        for line in (EVIDENCE / "evidence_hashes.sha256").read_text().splitlines():
            expected, name = line.split(None, 1)
            path = EVIDENCE / name.removeprefix("./")
            self.assertTrue(path.is_file(), name)
            self.assertEqual(sha256(path), expected, name)
        runner = load_runner()
        plan = json.loads((ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json").read_text())
        scene_plan = json.loads(runner.SCENE_PLAN.read_text())
        cue_union = set()
        dialogue_total = 0
        for mode in runner.MODES:
            events = runner.read_events(EVIDENCE / mode / "events.jsonl")
            summary = runner.validate_mode(mode, events, plan, scene_plan)
            runner.strict_termination(EVIDENCE / mode / "termination.json")
            self.assertEqual(summary["commands"], 975)
            self.assertEqual(summary["arrays"], 27)
            cue_union.update(summary["cue_ids"])
            dialogue_total += summary["dialogues"]
        self.assertEqual(dialogue_total, 94)
        self.assertEqual(cue_union, {450, 455, 457, 463, 465, 466, 468, 469, 470, 473, 482})

    def test_report_and_checkpoint_scope_are_explicit(self) -> None:
        runner = load_runner()
        report = json.loads((EVIDENCE / "native_command_complete_validation.json").read_text())
        self.assertEqual(report["status"], "passed")
        self.assertEqual(report["runtime"]["executable_sha256"], runner.PMDO_SHA256)
        self.assertEqual(report["combined"]["unique_command_addresses_per_mode"], 975)
        self.assertEqual(report["combined"]["selected_route_dialogues_closed"], 94)
        self.assertEqual(len(report["branch_scope"]), 3)
        progress = json.loads((ROOT / "docs/pmdred_eu/playable/progress.json").read_text())
        extension = progress["tiny_woods"]["narrative_scenes"]["command_complete_selected_route_extension"]
        self.assertEqual(extension["status"], "PASS")
        self.assertEqual(extension["report_sha256"], sha256(EVIDENCE / "native_command_complete_validation.json"))
        self.assertEqual(extension["fixture_manifest_sha256"], sha256(EVIDENCE / "fixture_manifest.json"))
        self.assertEqual(extension["provenance_report_sha256"], sha256(EVIDENCE / "provenance.json"))
        provenance = json.loads((EVIDENCE / "provenance.json").read_text())
        renderer = ROOT / provenance["current_renderer"]["source"]
        self.assertEqual(provenance["status"], "pass")
        self.assertEqual(provenance["current_renderer"]["source_sha256"], sha256(renderer))
        self.assertTrue(provenance["current_renderer"]["source_hash_matches_manifest"])
        self.assertTrue(all(row["byte_identical_to_superseded_snapshot"] for row in provenance["cue_identity"]))
        self.assertIn("non-selected", extension["scope"])
        self.assertEqual(progress["resume"]["next_phase"], "tiny_woods_opcode_semantic_choreography_and_production_integration")


if __name__ == "__main__":
    unittest.main()
