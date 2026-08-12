#!/usr/bin/env python3
"""Narrow role-classification tests for the authenticated Ground campaign."""
from __future__ import annotations

import copy
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from build_pmdred_eu_entity_migration import MIGRATION_POLICIES, build_migration, read_json
from run_pmdred_eu_ground_milestone import (
    build_collision_validation,
    classify_ground_role,
    insert_zone,
    validate_partial_additive_recovery_record,
    validate_partial_entity_migration_recovery_record,
    validate_pre_promotion_collision_failure_record,
    write_commands,
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

    def test_personality_test_screen_comes_from_enum_symbol(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_PERSONALITY_TEST_CYAN"),
            {
                "category": "personality_test_screen",
                "classification": "cyan_personality_test_screen",
                "color": "cyan",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_fugitive_journey_scene_comes_from_enum_symbol(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_FUGITIVES_SNOW_ROAD"),
            {
                "category": "fugitive_journey_scene",
                "classification": "snow_road_fugitive_journey_scene",
                "setting": "snow_road",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_summit_sunset_is_explicit(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_SUMMIT_SUNSET"),
            {
                "category": "summit_scene",
                "classification": "sunset_summit_scene",
                "time": "sunset",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_story_and_transition_roles_come_from_pinned_symbols(self) -> None:
        self.assertEqual(
            classify_ground_role("MAP_SKY_TOWER"),
            {
                "category": "story_location",
                "classification": "sky_tower_story_location",
                "location": "sky_tower",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )
        self.assertEqual(
            classify_ground_role("MAP_NIGHT_SKY_2")["classification"],
            "night_sky_scene_2",
        )
        self.assertEqual(
            classify_ground_role("MAP_THUNDERWAVE_CAVE_ENTRY"),
            {
                "category": "dungeon_transition_ground",
                "classification": "thunderwave_cave_entry_ground",
                "location": "thunderwave_cave",
                "transition": "entry",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )
        self.assertEqual(
            classify_ground_role("MAP_MT_THUNDER_MID"),
            {
                "category": "dungeon_midpoint_ground",
                "classification": "mt_thunder_midpoint_ground",
                "location": "mt_thunder",
                "stage": "midpoint",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )
        self.assertEqual(
            classify_ground_role("MAP_D16"),
            {
                "category": "dungeon_endpoint_ground",
                "classification": "fiery_field_endpoint_ground",
                "location": "fiery_field",
                "stage": "endpoint",
                "cinematic": False,
                "arena": False,
                "boss": False,
            },
        )

    def test_unimplemented_role_still_stops(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "stopping rather than guessing"):
            classify_ground_role("MAP_POKEMON_SQUARE")


class CollisionApplicabilityGateTests(unittest.TestCase):
    @staticmethod
    def plan(layers: int, solids: int) -> dict:
        return {
            "resources": {"bma": "map.bma"},
            "collision_layer_count": layers,
            "solid_cells": solids,
            "collision_sha256": "collision-hash",
        }

    @staticmethod
    def entry(blocked: dict | None, expectation: str) -> dict:
        return {
            "spawn": {
                "movement_probes": {
                    "successful": {"x": 8, "y": 16, "direction": "Down"},
                    "blocked": blocked,
                    "blocked_expectation": expectation,
                }
            }
        }

    @staticmethod
    def event(blocked_result: str, solids: int) -> dict:
        return {
            "movement_probe": "PASS",
            "blocked_probe": blocked_result,
            "move_delta": "0,8",
            "blocked_delta": "0,0",
            "solid_cells": solids,
        }

    def test_no_bma_collision_is_strictly_authenticated_non_applicability(self) -> None:
        result = build_collision_validation(
            self.plan(0, 0),
            self.entry(None, "NO_BMA_COLLISION_LAYER_OR_SOLIDS"),
            self.event("NOT_APPLICABLE_NO_BMA_SOLIDS", 0),
        )
        self.assertEqual(result["result"], "PASS")
        self.assertFalse(result["blocked_probe"]["applicable"])
        self.assertEqual(result["blocked_probe"]["result"], "NOT_APPLICABLE")

    def test_non_applicability_cannot_bypass_real_bma_solids(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "blocked-probe gate failed"):
            build_collision_validation(
                self.plan(1, 12),
                self.entry(None, "NO_BMA_COLLISION_LAYER_OR_SOLIDS"),
                self.event("NOT_APPLICABLE_NO_BMA_SOLIDS", 12),
            )

    def test_real_bma_collision_still_requires_passed_blocked_probe(self) -> None:
        result = build_collision_validation(
            self.plan(1, 12),
            self.entry(
                {"x": 24, "y": 32, "direction": "Left"},
                "BMA_SOLID_BLOCK",
            ),
            self.event("PASS", 12),
        )
        self.assertTrue(result["blocked_probe"]["applicable"])
        self.assertEqual(result["blocked_probe"]["result"], "PASS")

    def test_inconsistent_raw_bma_facts_stop(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "inconsistent BMA collision facts"):
            build_collision_validation(
                self.plan(0, 1),
                self.entry(None, "NO_BMA_COLLISION_LAYER_OR_SOLIDS"),
                self.event("NOT_APPLICABLE_NO_BMA_SOLIDS", 1),
            )


class PrePromotionCollisionFailureRecoveryTests(unittest.TestCase):
    @staticmethod
    def valid_record() -> dict:
        return {
            "schema": "new-era.pmdred-eu-ground-orchestration-failure.v1",
            "ground": "a01p02",
            "result": "ORCHESTRATION_FAIL_BEFORE_PROMOTION",
            "failure": {"stage": "comparison_gate_before_promotion", "gate_index": 14},
            "authenticated_collision_facts": {
                "collision_layer_count": 0,
                "solid_cells": 0,
                "fixture_blocked_probe": None,
                "fixture_blocked_expectation": "NO_BMA_COLLISION_LAYER_OR_SOLIDS",
                "runtime_blocked_probe": "NOT_APPLICABLE_NO_BMA_SOLIDS",
            },
            "canonical_state": {
                "ground_destination_absent": True,
                "tile_destination_absent": True,
                "zone_entry_count": 0,
                "official_pass_evidence_created": False,
            },
            "recovery_policy": {
                "preserve_this_failed_attempt": True,
                "do_not_reclassify_as_pass": True,
                "narrow_collision_non_applicability_gate_required": True,
                "fresh_full_runtime_and_comparison_rerun_required": True,
                "official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun": True,
            },
        }

    def test_exact_failure_record_requires_fresh_rerun(self) -> None:
        validate_pre_promotion_collision_failure_record(self.valid_record(), "a01p02")

    def test_prior_failure_cannot_be_reclassified_as_pass(self) -> None:
        record = self.valid_record()
        record["result"] = "PASS"
        with self.assertRaisesRegex(RuntimeError, "failure record gate failed"):
            validate_pre_promotion_collision_failure_record(record, "a01p02")

    def test_collision_facts_cannot_be_relaxed_during_recovery(self) -> None:
        record = self.valid_record()
        record["authenticated_collision_facts"]["solid_cells"] = 1
        with self.assertRaisesRegex(RuntimeError, "failure record gate failed"):
            validate_pre_promotion_collision_failure_record(record, "a01p02")


class OccupiedGroundEntityMigrationTests(unittest.TestCase):
    @staticmethod
    def write_bom(path: Path, payload: dict) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(
            "\ufeff" + json.dumps(payload, ensure_ascii=False, separators=(",", ":")),
            encoding="utf-8",
        )

    @staticmethod
    def digest(path: Path) -> str:
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def fixture(self, root: Path) -> tuple[dict, Path, Path, Path]:
        layer = {
            "Name": "entities", "Visible": True,
            "MapChars": [], "GroundObjects": [], "Spawners": [], "Markers": [],
        }
        canonical = {
            "Version": "0.8.12.0",
            "Object": {
                "AssetName": "test01",
                "obstacles": [[{"Tags": 0} for _ in range(4)] for _ in range(5)],
                "Entities": [copy.deepcopy(layer)],
                "visual": {"authenticated": True},
            },
        }
        historical = copy.deepcopy(canonical)
        old_layer = historical["Object"]["Entities"][0]
        old_layer["Markers"] = [
            {
                "EntName": "Main_Entrance_Marker", "EntEnabled": True,
                "Collider": {"X": 8, "Y": 8, "Width": 16, "Height": 16},
            },
            {
                "EntName": "Cutscene_Marker", "EntEnabled": True,
                "Collider": {"X": 16, "Y": 8, "Width": 16, "Height": 16},
            },
        ]
        old_layer["Spawners"] = [
            {
                "EntName": name, "NPCName": f"Teammate{index}", "EntEnabled": True,
                "Collider": {"X": 8 * index, "Y": 8, "Width": 16, "Height": 16},
            }
            for index, name in enumerate(("TEAMMATE_1", "TEAMMATE_2", "TEAMMATE_3"), 1)
        ]
        historical_path = root / "Data/Ground/test01.rsground"
        canonical_root = root / "canonical"
        canonical_path = canonical_root / "grounds/test01.rsground"
        historical_tile = root / "Content/Tile/Test01_Base.tile"
        canonical_tile = canonical_root / "tiles/test01_Base.tile"
        self.write_bom(historical_path, historical)
        self.write_bom(canonical_path, canonical)
        historical_tile.parent.mkdir(parents=True)
        historical_tile.write_bytes(b"authenticated tile")
        canonical_tile.parent.mkdir(parents=True)
        canonical_tile.write_bytes(historical_tile.read_bytes())
        (canonical_root / "conversion_report.json").write_text("{}\n")
        policy = {
            "schema": "test-policy.v1",
            "ground": "test01",
            "historical_ground_sha256": self.digest(historical_path),
            "historical_tile": "Content/Tile/Test01_Base.tile",
            "historical_tile_sha256": self.digest(historical_tile),
            "canonical_ground_sha256": self.digest(canonical_path),
            "canonical_tile_sha256": self.digest(canonical_tile),
            "preserved_fields": ["Markers", "Spawners"],
            "expected_entities": {
                "Markers": ["Main_Entrance_Marker", "Cutscene_Marker"],
                "Spawners": ["TEAMMATE_1", "TEAMMATE_2", "TEAMMATE_3"],
            },
            "historical_reserves": {},
            "related_scripts": {},
        }
        return policy, historical_path, historical_tile, canonical_root

    def test_migration_preserves_entities_and_only_entities(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            policy, historical_path, historical_tile, canonical_root = self.fixture(root)
            output = root / "output"
            manifest = build_migration(
                root, "test01", output, policy=policy,
                historical_ground=historical_path, historical_tile=historical_tile,
                canonical_root=canonical_root,
            )
            integrated = read_json(output / "grounds/test01.rsground")
            historical = read_json(historical_path)
            canonical = read_json(canonical_root / "grounds/test01.rsground")
            layer = integrated["Object"]["Entities"][0]
            old_layer = historical["Object"]["Entities"][0]
            self.assertEqual(layer["Markers"], old_layer["Markers"])
            self.assertEqual(layer["Spawners"], old_layer["Spawners"])
            layer["Markers"] = []
            layer["Spawners"] = []
            self.assertEqual(integrated, canonical)
            self.assertEqual(
                manifest["entity_integration"]["ordered_names"]["spawners"],
                ["TEAMMATE_1", "TEAMMATE_2", "TEAMMATE_3"],
            )
            self.assertFalse(manifest["existing_entity_silently_deactivated"])

    def test_same_identity_tile_requires_reserve_before_replacement(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            policy, historical_path, historical_tile, canonical_root = self.fixture(root)
            same_identity_tile = root / "Content/Tile/test01_Base.tile"
            same_identity_tile.write_bytes(historical_tile.read_bytes())
            policy["historical_tile"] = "Content/Tile/test01_Base.tile"
            policy["historical_tile_sha256"] = self.digest(same_identity_tile)
            policy["tile_migration_mode"] = "reserve_and_replace_canonical_identity"
            manifest = build_migration(
                root, "test01", root / "output", policy=policy,
                historical_ground=historical_path, historical_tile=same_identity_tile,
                canonical_root=canonical_root,
            )
            self.assertEqual(
                manifest["tile_migration"]["mode"],
                "reserve_and_replace_canonical_identity",
            )
            self.assertTrue(manifest["tile_migration"]["same_active_identity"])
            self.assertTrue(
                manifest["tile_migration"]["canonical_identity_replaced_only_after_reserve"]
            )
            self.assertIsNone(manifest["legacy_case_tile_retained_unchanged"])
            self.assertEqual(
                manifest["historical_tile_replaced_after_reserve"],
                "Content/Tile/test01_Base.tile",
            )

    def test_historical_tamper_is_rejected_before_output(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            policy, historical_path, historical_tile, canonical_root = self.fixture(root)
            historical_path.write_bytes(historical_path.read_bytes() + b"tamper")
            output = root / "output"
            with self.assertRaisesRegex(RuntimeError, "historical Ground hash gate failed"):
                build_migration(
                    root, "test01", output, policy=policy,
                    historical_ground=historical_path, historical_tile=historical_tile,
                    canonical_root=canonical_root,
                )
            self.assertFalse(output.exists())

    def test_canonical_tamper_is_rejected_before_output(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            policy, historical_path, historical_tile, canonical_root = self.fixture(root)
            canonical = canonical_root / "grounds/test01.rsground"
            canonical.write_bytes(canonical.read_bytes() + b"tamper")
            output = root / "output"
            with self.assertRaisesRegex(RuntimeError, "authenticated canonical Ground hash gate failed"):
                build_migration(
                    root, "test01", output, policy=policy,
                    historical_ground=historical_path, historical_tile=historical_tile,
                    canonical_root=canonical_root,
                )
            self.assertFalse(output.exists())

    def test_migration_output_is_create_only(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            policy, historical_path, historical_tile, canonical_root = self.fixture(root)
            output = root / "output"
            output.mkdir()
            with self.assertRaisesRegex(FileExistsError, "create-only migration output exists"):
                build_migration(
                    root, "test01", output, policy=policy,
                    historical_ground=historical_path, historical_tile=historical_tile,
                    canonical_root=canonical_root,
                )

    def test_reproduction_recipe_rebuilds_integrated_subject(self) -> None:
        repo = Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            write_commands(
                output, "a02p01",
                {"stable_ground_id": "a02p01", "map_file_id": 174},
                "MAP_FUGITIVES_FISSURE", "integrated-ground-hash", "tile-hash",
                28, 2, 1,
                repo / "RESERVE/red_grounds/a02p01.rsground",
                repo / "RESERVE/red_tiles/a02p01_Base.tile",
                {"canonical_baseline": {"ground_sha256": "canonical-ground-hash"}},
            )
            recipe = (output / "commands.sh").read_text()
            self.assertIn("build_pmdred_eu_entity_migration.py --ground a02p01", recipe)
            self.assertIn("canonical-ground-hash", recipe)
            self.assertIn("integrated-ground-hash", recipe)
            self.assertIn('--candidate-root "$MIGRATED"', recipe)
            self.assertEqual(recipe.count("--entity-integrated-ids a02p01"), 2)
            self.assertEqual(recipe.count('--canonical-baseline-root "$CANONICAL"'), 2)


class EntityMigrationRecoveryGateTests(unittest.TestCase):
    @staticmethod
    def same_identity_record() -> dict:
        policy = MIGRATION_POLICIES["a03p01"]
        return {
            "schema": "new-era.pmdred-eu-ground-orchestration-failure.v1",
            "ground": "a03p01",
            "result": "ORCHESTRATION_FAIL_AFTER_AUTHENTICATED_MIGRATION_INSTALL_BEFORE_PROMOTION",
            "failure": {"stage": "zone_integration_after_migration_install"},
            "entity_migration": {
                "historical_ground_sha256": policy["historical_ground_sha256"],
                "canonical_baseline_ground_sha256": policy["canonical_ground_sha256"],
                "integrated_ground_sha256": policy["integrated_ground_sha256"],
                "tile_sha256": policy["canonical_tile_sha256"],
                "markers": policy["expected_entities"]["Markers"],
                "spawners": policy["expected_entities"]["Spawners"],
                "reserve_created": True,
                "tile_migration_mode": "reserve_and_replace_canonical_identity",
                "historical_active_tile_sha256": policy["historical_tile_sha256"],
                "historical_tile_reserved_before_replacement": True,
                "canonical_identity_tile_replaced_atomically": True,
            },
            "canonical_state": {
                "active_ground_sha256": policy["integrated_ground_sha256"],
                "active_tile_sha256": policy["canonical_tile_sha256"],
                "historical_reserve_ground_sha256": policy["historical_ground_sha256"],
                "historical_reserve_tile_sha256": policy["historical_tile_sha256"],
                "official_pass_evidence_created": False,
                "zone_unchanged": True,
                "zone_entry_count": 1,
            },
            "recovery_policy": {
                "preserve_this_failed_attempt": True,
                "do_not_reclassify_as_pass": True,
                "authenticate_partial_migration_and_reserve": True,
                "retain_singleton_historical_zone_entry_in_place": True,
                "fresh_full_runtime_comparison_and_post_promotion_rerun_required": True,
                "official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun": True,
            },
        }

    def test_preserved_partial_migration_record_is_fully_authenticated(self) -> None:
        root = Path(__file__).resolve().parents[1]
        record = json.loads((
            root / "docs/pmdred_eu/pmdo_validation/a02p01_failed_attempt_preexisting_zone_gate/failure_record.json"
        ).read_text())
        validate_partial_entity_migration_recovery_record(
            record, "a02p01", MIGRATION_POLICIES["a02p01"]
        )

    def test_same_identity_tile_recovery_authenticates_reserve_and_atomic_replacement(self) -> None:
        validate_partial_entity_migration_recovery_record(
            self.same_identity_record(), "a03p01", MIGRATION_POLICIES["a03p01"]
        )

    def test_same_identity_tile_recovery_rejects_wrong_historical_reserve(self) -> None:
        record = self.same_identity_record()
        record["canonical_state"]["historical_reserve_tile_sha256"] = "wrong"
        with self.assertRaisesRegex(RuntimeError, "recovery record gate failed"):
            validate_partial_entity_migration_recovery_record(
                record, "a03p01", MIGRATION_POLICIES["a03p01"]
            )

    def test_failed_migration_cannot_be_reclassified_as_pass(self) -> None:
        root = Path(__file__).resolve().parents[1]
        record = json.loads((
            root / "docs/pmdred_eu/pmdo_validation/a02p01_failed_attempt_preexisting_zone_gate/failure_record.json"
        ).read_text())
        record["result"] = "PASS"
        with self.assertRaisesRegex(RuntimeError, "recovery record gate failed"):
            validate_partial_entity_migration_recovery_record(
                record, "a02p01", MIGRATION_POLICIES["a02p01"]
            )

    def test_historical_singleton_zone_entries_are_retained_byte_exactly(self) -> None:
        root = Path(__file__).resolve().parents[1]
        zone = root / "Data/Zone/master_zone.json"
        before = zone.read_bytes()
        maps = json.loads(before.decode("utf-8-sig"))["Object"]["GroundMaps"]
        for ground in MIGRATION_POLICIES:
            with self.subTest(ground=ground):
                pre, post, prior, index = insert_zone(
                    ground, list(MIGRATION_POLICIES), {"a01p02"}, retain_existing=True
                )
                self.assertEqual(pre, post)
                self.assertEqual(zone.read_bytes(), before)
                self.assertEqual(index, maps.index(ground))
                self.assertEqual(prior, maps[index - 1])

    def test_fugitive_migration_policies_pin_exact_integrated_outputs(self) -> None:
        expected = {
            "a02p01": ("016551d87ddf6b5556a4f9181ec8061a5af2df1bda97e3f43e376f3dc64dc3b2", 2, 3, "retain_distinct_historical_identity"),
            "a02p02": ("f9aac6971906cbb93eab368bcd91bb4a9723180bd854d17b19811474c3484a3c", 2, 1, "retain_distinct_historical_identity"),
            "a02p03": ("f939c874590008a7db4217f7fd77f65d548a32ba5ccfa0701e77a0da070982a3", 2, 1, "retain_distinct_historical_identity"),
            "a02p04": ("9add5df8383ddb077c832ddae9e06287ad29cd6db695437b7d1f655af8a2c790", 2, 1, "retain_distinct_historical_identity"),
            "a03p01": ("b0217e3fa2963faf0ee340c639b80d8a2cd33f7c3a8a585db21f8eecc0be0beb", 1, 0, "reserve_and_replace_canonical_identity"),
            "a03p02": ("4c685a550e2cc6a9cf58f0b640ed3f206700639ac9dd0c39e1a35d1d8c16634c", 1, 0, "reserve_and_replace_canonical_identity"),
            "a03p03": ("8a0124252466f4adcdbfad6ab2097920e34d863c663e141772a034e602039589", 1, 0, "reserve_and_replace_canonical_identity"),
            "a04p01": ("c6b2b6938f37f2c5f4d10f0686c7b7734aab500144ed036ecc5eeee53c79d6af", 4, 2, "reserve_and_replace_canonical_identity"),
            "a05p03": ("bb7a394689a9f70c556d54de0e8ca1679132174111446f14b2c6a39c305d5212", 2, 0, "retain_distinct_historical_identity"),
        }
        self.assertEqual(set(MIGRATION_POLICIES), set(expected))
        for ground, (integrated_hash, marker_count, spawner_count, tile_mode) in expected.items():
            with self.subTest(ground=ground):
                policy = MIGRATION_POLICIES[ground]
                self.assertEqual(policy["ground"], ground)
                self.assertEqual(policy["integrated_ground_sha256"], integrated_hash)
                self.assertEqual(len(policy["expected_entities"]["Markers"]), marker_count)
                self.assertEqual(len(policy["expected_entities"]["Spawners"]), spawner_count)
                self.assertEqual(
                    policy.get("tile_migration_mode", "retain_distinct_historical_identity"),
                    tile_mode,
                )

    def test_generic_zone_insertion_still_rejects_unvalidated_existing_entry(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "zone already contains unvalidated a02p01"):
            insert_zone("a02p01", ["a01p02", "a02p01"], {"a01p02"})


class PilotZoneIntegrationCorrectionTests(unittest.TestCase):
    def test_validated_out_of_order_pilots_are_registered_once(self) -> None:
        root = Path(__file__).resolve().parents[1]
        maps = json.loads(
            (root / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig")
        )["Object"]["GroundMaps"]
        self.assertEqual(maps.count("h26p01"), 1)
        self.assertEqual(maps.count("a01p01"), 1)
        self.assertLess(maps.index("h25p01"), maps.index("h26p01"))
        self.assertLess(maps.index("h26p01"), maps.index("a01p01"))
        # Later contiguous h27-h29 promotions are intentionally inserted between
        # the corrected h26 predecessor and the already validated a01 pilot.
        if "h27p01" in maps:
            self.assertLess(maps.index("h27p01"), maps.index("a01p01"))

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
