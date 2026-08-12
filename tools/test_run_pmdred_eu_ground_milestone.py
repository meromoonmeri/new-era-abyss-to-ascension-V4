#!/usr/bin/env python3
"""Narrow role-classification tests for the authenticated Ground campaign."""
from __future__ import annotations

import json
import unittest
from pathlib import Path

from run_pmdred_eu_ground_milestone import (
    classify_ground_role,
    validate_partial_additive_recovery_record,
)


class GroundRoleClassificationTests(unittest.TestCase):
    def test_team_base_classification_is_unchanged(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_TEAM_BASE_INSIDE_TREECKO_FINAL"),
            {
                "category": "rescue_team_base",
                "classification": "final_treecko_rescue_team_base_interior",
                "location": "interior",
                "species": "treecko",
                "stage": "final",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_friend_area_classification_comes_from_enum_symbol(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_FRIEND_AREA_BOUNTIFUL_SEA"),
            {
                "category": "friend_area",
                "classification": "bountiful_sea_friend_area",
                "friend_area": "bountiful_sea",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_unimplemented_role_still_stops(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "stopping rather than guessing"):
            classify_ground_role("MAP_POKEMON_SQUARE")


class PilotZoneIntegrationCorrectionTests(unittest.TestCase):
    def test_validated_out_of_order_pilots_are_registered_once(self) -> None:
        root = Path(__file__).resolve().parents[1]
        maps = json.loads(
            (root / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig")
        )["Object"]["GroundMaps"]
        self.assertEqual(maps.count("h26p01"), 1)
        self.assertEqual(maps.count("a01p01"), 1)
        h25 = maps.index("h25p01")
        self.assertEqual(maps[h25 : h25 + 3], ["h25p01", "h26p01", "a01p01"])

    def test_correction_is_non_reserializing_and_exact_pmdo_indexed(self) -> None:
        root = Path(__file__).resolve().parents[1]
        record = json.loads(
            (
                root
                / "docs/pmdred_eu/pmdo_validation/pilot_zone_integration_correction_20260812/correction_record.json"
            ).read_text()
        )
        self.assertEqual(record["result"], "PASS")
        self.assertFalse(record["zone"]["reserialized"])
        self.assertTrue(record["zone"]["other_bytes_unchanged"])
        self.assertEqual(record["exact_pmdo_index"]["result"], "PASS")


class PartialAdditiveRecoveryGateTests(unittest.TestCase):
    @staticmethod
    def valid_record() -> dict:
        return {
            "schema": "new-era.pmdred-eu-ground-orchestration-failure.v1",
            "ground": "h27p01",
            "result": "ORCHESTRATION_FAIL_AFTER_EXACT_ADDITIVE_INSTALL",
            "failure": {"stage": "zone_registration_after_runtime_and_comparison_pass"},
            "initial_destination_precondition": {"ground": "absent", "tile": "absent"},
            "preserved_partial_additive_install": {
                "ground": {
                    "sha256": "ground-hash",
                    "tracked_at_head": False,
                    "matches_authenticated_v201_candidate": True,
                },
                "tile": {
                    "sha256": "tile-hash",
                    "tracked_at_head": False,
                    "matches_authenticated_v201_candidate": True,
                },
                "deleted_or_overwritten_during_diagnosis": False,
            },
            "recovery_policy": {
                "preserve_this_failed_attempt": True,
                "preserve_exact_partial_destination_bytes": True,
                "fresh_full_runtime_and_comparison_rerun_required": True,
                "official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun": True,
            },
        }

    def test_exact_record_permits_only_fresh_rerun_recovery(self) -> None:
        validate_partial_additive_recovery_record(
            self.valid_record(), "h27p01", "ground-hash", "tile-hash"
        )

    def test_wrong_candidate_hash_stops_recovery(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "record gate failed"):
            validate_partial_additive_recovery_record(
                self.valid_record(), "h27p01", "different-ground-hash", "tile-hash"
            )

    def test_prior_diagnostic_cannot_be_reclassified_as_pass(self) -> None:
        record = self.valid_record()
        record["result"] = "PASS"
        with self.assertRaisesRegex(RuntimeError, "record gate failed"):
            validate_partial_additive_recovery_record(
                record, "h27p01", "ground-hash", "tile-hash"
            )

    def test_recovery_without_full_rerun_requirement_stops(self) -> None:
        record = self.valid_record()
        record["recovery_policy"]["fresh_full_runtime_and_comparison_rerun_required"] = False
        with self.assertRaisesRegex(RuntimeError, "record gate failed"):
            validate_partial_additive_recovery_record(
                record, "h27p01", "ground-hash", "tile-hash"
            )


if __name__ == "__main__":
    unittest.main()
