#!/usr/bin/env python3
"""Regression gates for the source-pinned Tiny Woods palette milestone."""
from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

import build_pmdred_tiny_woods_palette_semantics as semantic_builder

ROOT = Path(__file__).resolve().parents[1]
SEMANTICS = ROOT / "docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json"
ARCHIVE = ROOT / "docs/pmdred_eu/playable/tiny_woods/palette_semantics_runtime_v1"
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class TinyWoodsPaletteSemanticsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.semantics = json.loads(SEMANTICS.read_text(encoding="utf-8"))
        cls.certificate = json.loads((ARCHIVE / "palette_certificate.json").read_text(encoding="utf-8"))
        cls.report = json.loads((ARCHIVE / "native_palette_validation.json").read_text(encoding="utf-8"))
        cls.plan = json.loads(PLAN.read_text(encoding="utf-8"))

    def test_source_pinned_semantics_inventory_and_fallback(self) -> None:
        rebuilt = semantic_builder.build()
        # The archived date is milestone provenance, not semantic content.
        # Normalize only this field when rebuilding on later dates.
        rebuilt["date"] = self.semantics["date"]
        self.assertEqual(rebuilt, self.semantics)
        self.assertEqual(self.semantics["schema"], "pmdred-eu-tiny-woods-palette-semantics-v1")
        self.assertEqual(self.semantics["status"], "source_pinned_semantics_pass")
        self.assertEqual(self.semantics["scope"]["opcode_counts"], {"0x22": 6, "0x23": 5, "0x25": 2, "0x26": 2})
        self.assertEqual(len(self.semantics["commands"]), 15)
        self.assertEqual(len(self.semantics["affected_arrays"]), 6)
        self.assertEqual({row["source_frames"] for row in self.semantics["commands"]}, {0, 30, 60})
        self.assertTrue(all(row["blocking"] and row["arg_byte"] == 1 for row in self.semantics["commands"]))
        self.assertTrue(all(row["planning_handler_retained"] == "actor.control_unknown" for row in self.semantics["commands"]))
        plan_rows = [row for array in self.plan["arrays"] for row in array["commands"] if row["op"] in (0x22, 0x23, 0x25, 0x26)]
        self.assertEqual(len(plan_rows), 15)
        self.assertTrue(all(row["pmdo_handler"] == "actor.control_unknown" for row in plan_rows))

    def test_adapter_and_all_six_production_choreographies_are_manifest_bound(self) -> None:
        fixture = ARCHIVE / "fixture_scripts/quest/Data/Script/halcyon"
        adapter = (fixture / "pmdred_palette_adapter.lua").read_text(encoding="utf-8")
        core = (fixture / "pmdred_tiny_woods_scenes.lua").read_text(encoding="utf-8")
        campaign = (fixture / "pmdred_tiny_woods_command_campaign.lua").read_text(encoding="utf-8")
        ground = (fixture / "ground/d01p01/init.lua").read_text(encoding="utf-8")
        combined = core + campaign
        expected_apis = {
            "0x22": "GAME:FadeIn(runtimeFrames)",
            "0x23": "GAME:FadeOut(false,runtimeFrames)",
            "0x25": "GAME:FadeInFront(runtimeFrames)",
            "0x26": "GAME:FadeOutFront(false,runtimeFrames)",
        }
        for opcode, api in expected_apis.items():
            self.assertIn(f"command.opcode=={opcode}", adapter)
            self.assertIn(api, adapter)
        for row in self.semantics["commands"]:
            self.assertEqual(combined.count(f"Palette.Execute('{row['address']}'"), 1, row["address"])
        self.assertEqual(combined.count("Palette.Execute('"), 15)
        self.assertNotIn("GAME:FadeIn(", combined)
        self.assertNotIn("GAME:FadeOut(false", combined)
        self.assertIn("Palette.ExecuteAll(scene)", campaign)
        self.assertIn("TINY_WOODS_COMMAND_MODE')=='palette_adapter_all'", ground)
        self.assertLess(core.index("Palette.Execute('0x084CB130'"), core.index("GAME:WaitFrames(100)"))
        self.assertLess(core.index("Palette.Execute('0x084CB2E0'"), core.index("Palette.Execute('0x084CB400'"))
        self.assertLess(campaign.index("Palette.Execute('0x0838D294'"), campaign.index("show(BASE_STATION,scene)"))
        self.assertLess(campaign.index("show(BASE_STATION,scene)"), campaign.index("Palette.Execute('0x0838D36C'"))

    def test_three_native_modes_and_strict_termination(self) -> None:
        self.assertEqual(self.report["schema"], "pmdred-eu-tiny-woods-palette-native-v1")
        self.assertEqual(self.report["status"], "passed")
        self.assertEqual([run["mode"] for run in self.report["runs"]], ["opening_naming", "post_route", "palette_adapter_all"])
        self.assertEqual([run["palette"]["count"] for run in self.report["runs"]], [4, 10, 15])
        self.assertEqual(self.report["combined"]["exact_palette_commands_isolated"], 15)
        self.assertEqual(self.report["combined"]["selected_route_palette_commands_integrated"], 14)
        self.assertEqual(self.report["combined"]["selected_route_dialogues_closed"], 94)
        for run in self.report["runs"]:
            self.assertEqual(run["result"], "PASS")
            self.assertEqual(run["commands"], 975)
            self.assertTrue(run["palette"]["strict_start_complete_adjacency"])
            self.assertTrue(run["palette"]["frame_tick_accounting"])
            self.assertTrue(all(record["blocking_return_observed"] for record in run["palette"]["records"]))
            self.assertEqual(run["termination"], {
                "exit_classification": "NORMAL_EXIT", "return_code": 0, "terminal": True,
                "graceful": True, "watchdog": False, "requested_signal": None,
                "sigsegv": False, "forced_kill": False, "orphan_process": False,
            })
            termination = json.loads((ARCHIVE / run["mode"] / "termination.json").read_text(encoding="utf-8"))
            self.assertTrue(termination["load_phase_unload"]["pass"])
            self.assertEqual(termination["load_phase_unload"]["terminal_event"]["load_phase"], "Unload")

    def test_archive_certificate_and_complete_integrity_list(self) -> None:
        self.assertEqual(self.certificate["status"], "PASS")
        self.assertEqual(self.certificate["modes"], 3)
        self.assertEqual(self.certificate["exact_palette_commands"], 15)
        self.assertEqual(self.certificate["strict_native_terminations"], 3)
        self.assertTrue(self.certificate["unknown_planning_fallback_retained"])
        self.assertEqual(self.certificate["native_report_sha256"], sha256(ARCHIVE / "native_palette_validation.json"))
        self.assertEqual(self.certificate["semantics_sha256"], sha256(ARCHIVE / "secondary_palette_semantics_v1.json"))
        expected: dict[str, str] = {}
        for line in (ARCHIVE / "evidence_hashes.sha256").read_text(encoding="utf-8").splitlines():
            digest, relative = line.split("  ", 1)
            self.assertNotIn(relative, expected)
            expected[relative] = digest
        actual = {
            str(path.relative_to(ARCHIVE)): sha256(path)
            for path in ARCHIVE.rglob("*")
            if path.is_file() and path.name != "evidence_hashes.sha256"
        }
        self.assertEqual(expected, actual)
        for relative, digest in expected.items():
            self.assertEqual(sha256(ARCHIVE / relative), digest)
        provenance = json.loads((ARCHIVE / "provenance.json").read_text(encoding="utf-8"))
        for relative, source in provenance["source_files"].items():
            self.assertEqual(source, {"bytes": (ROOT / relative).stat().st_size, "sha256": sha256(ROOT / relative)})


if __name__ == "__main__":
    unittest.main()
