#!/usr/bin/env python3
"""Qualification of the Relict source inventory and redaction boundary."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
SOURCE = REPO_ROOT / "external/BIBLIOTHEQUE/Relict/Relict V1.2/Relict"
TRACKED = WORKSPACE / "games/relict"
TOOLS = WORKSPACE / "tools"
sys.path.insert(0, str(TOOLS))

SPEC = importlib.util.spec_from_file_location("inventory_relict", TOOLS / "inventory_relict.py")
assert SPEC and SPEC.loader
INVENTORY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(INVENTORY)


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_hashes(root: Path) -> dict[str, str]:
    return {
        path.relative_to(root).as_posix(): sha256_file(path)
        for path in sorted(root.rglob("*")) if path.is_file()
    }


class RelictInventoryQualification(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = load_json(TRACKED / "reports/inventory.json")
        cls.zones = [load_json(path) for path in sorted((TRACKED / "metadata/zones").glob("*.json"))]

    def test_source_is_pinned_and_never_modified(self):
        commit = subprocess.check_output(
            ["git", "-C", str(SOURCE.parents[2]), "rev-parse", "HEAD"], text=True
        ).strip()
        self.assertEqual(commit, INVENTORY.EXPECTED_SOURCE_COMMIT)
        self.assertEqual(
            subprocess.check_output(
                ["git", "-C", str(SOURCE.parents[2]), "status", "--porcelain"], text=True
            ),
            "",
        )
        manifest = load_json(TRACKED / "manifests/source_manifest.json")
        self.assertEqual(manifest["source_commit"], commit)
        self.assertEqual(manifest["execution_policy"], "NO_SOURCE_CODE_EXECUTION")
        for row in manifest["files"]:
            path = SOURCE / row["path"]
            self.assertTrue(path.is_file(), row["path"])
            self.assertEqual(sha256_file(path), row["sha256"])
            self.assertNotIn("Scripts.rxdata", row["path"])
            self.assertNotIn("Game.exe", row["path"])

    def test_complete_map_variant_collision_and_entity_inventory(self):
        self.assertEqual(self.summary["canonical_map_count"], 28)
        self.assertEqual(self.summary["variant_map_count"], 8)
        self.assertEqual(self.summary["byte_identical_variant_count"], 2)
        self.assertEqual(self.summary["divergent_variant_count"], 6)
        self.assertEqual(len(self.zones), 28)
        self.assertEqual({row["source_map_id"] for row in self.zones}, set(range(1, 29)))
        self.assertEqual(self.summary["entity_event_count"], 100)
        self.assertEqual(self.summary["entity_page_placement_count"], 115)
        self.assertEqual(self.summary["cast_placeholder_count"], 68)
        self.assertEqual(self.summary["environmental_tile_entity_count"], 5)
        self.assertEqual(self.summary["logic_marker_count"], 42)
        self.assertEqual(self.summary["missing_dependency_count"], 0)
        for zone in self.zones:
            width = zone["geometry"]["width_tiles"]
            height = zone["geometry"]["height_tiles"]
            layers = zone["geometry"]["layer_count"]
            self.assertEqual(zone["collision"]["source_layers"]["value_count"], width * height * layers)
            self.assertTrue(zone["collision"]["source_complete"])
            self.assertTrue(zone["collision"]["dynamic_entities"]["placements_complete"])
            for section, key in (
                (zone["tile_layers"], "file"),
                (zone["collision"]["derived_directional_grid"], "file"),
                (zone["collision"]["tileset_tables"], "file"),
                (zone["entities"], "file"),
            ):
                path = TRACKED / section[key]
                self.assertTrue(path.is_file(), path)
                self.assertEqual(sha256_file(path), section["sha256"])

    def test_all_entity_positions_and_collision_flags_are_preserved_but_cast_is_redacted(self):
        classifications = {"CAST_PLACEHOLDER", "ENVIRONMENTAL_TILE_ENTITY", "LOGIC_MARKER"}
        for zone in self.zones:
            entities = load_json(TRACKED / zone["entities"]["file"])
            self.assertTrue(entities["source_complete"])
            self.assertTrue(entities["source_identities_redacted"])
            for placement in entities["placements"]:
                self.assertIn(placement["classification"], classifications)
                self.assertRegex(
                    placement["placeholder_id"],
                    r"^map_[0-9]{3}_entity_[0-9]{4}_page_[0-9]{2}$",
                )
                self.assertGreaterEqual(placement["position"]["x"], 0)
                self.assertLess(placement["position"]["x"], zone["geometry"]["width_tiles"])
                self.assertGreaterEqual(placement["position"]["y"], 0)
                self.assertLess(placement["position"]["y"], zone["geometry"]["height_tiles"])
                self.assertTrue(placement["graphic"]["source_identity_redacted"])
                self.assertIn("through", placement["collision"])
                self.assertIn("always_on_top", placement["collision"])
                self.assertIn("route_commands", placement["movement"])
                if placement["classification"] == "CAST_PLACEHOLDER":
                    self.assertRegex(
                        placement["graphic"]["source_identity_sha256"], r"^[0-9a-f]{64}$"
                    )

    def test_generated_outputs_contain_no_forbidden_asset_or_dialogue_payload(self):
        forbidden_keys = {
            "character_name", "event_name", "dialogue", "dialogue_text",
            "script_body", "trainer_name", "pokemon_species",
        }
        forbidden_paths = (
            "Graphics/Characters", "Graphics/Pokemon", "Graphics/Trainers",
            "Graphics/UI", "Game.exe", "Scripts.rxdata", ".dll",
        )
        for path in TRACKED.rglob("*"):
            if not path.is_file():
                continue
            self.assertIn(path.suffix, {".json", ".md", ".sha256"})
            text = path.read_text(encoding="utf-8")
            for value in forbidden_paths:
                self.assertNotIn(value, text, f"{path}: {value}")
            if path.suffix == ".json":
                def walk(value):
                    if isinstance(value, dict):
                        for key, child in value.items():
                            self.assertNotIn(key, forbidden_keys, f"{path}: {key}")
                            walk(child)
                    elif isinstance(value, list):
                        for child in value:
                            walk(child)
                walk(json.loads(text))
        self.assertFalse(self.summary["dialogue_contents_exported"])
        self.assertFalse(self.summary["script_bodies_exported"])
        self.assertFalse(self.summary["pmdo_conversion_started"])

    def test_generated_hash_manifest_covers_every_output(self):
        manifest_path = TRACKED / "manifests/generated_hashes.sha256"
        rows = {}
        for line in manifest_path.read_text().splitlines():
            digest, relative = line.split("  ", 1)
            rows[relative] = digest
        expected_paths = {
            path.relative_to(TRACKED).as_posix()
            for path in TRACKED.rglob("*")
            if path.is_file() and path != manifest_path
        }
        self.assertEqual(set(rows), expected_paths)
        for relative, digest in rows.items():
            self.assertEqual(sha256_file(TRACKED / relative), digest)

    def test_schema_contracts_are_closed_and_status_vocabulary_is_exact(self):
        schemas = {path.name: load_json(path) for path in (WORKSPACE / "schemas").glob("*.json")}
        self.assertEqual(
            schemas["status.schema.json"]["enum"],
            [
                "SOURCE_EXTRACTED", "SOURCE_DOCUMENTED", "PMDO_CONVERTED",
                "PMDO_VALIDATED", "ADAPTATION_REQUIRED", "UNSUPPORTED",
            ],
        )
        for name in (
            "asset.schema.json", "animation.schema.json", "collision.schema.json",
            "entity-placement.schema.json", "provenance.schema.json", "zone.schema.json",
        ):
            self.assertFalse(schemas[name]["additionalProperties"], name)
            self.assertTrue(schemas[name]["required"], name)
        zone_schema = schemas["zone.schema.json"]
        allowed = set(zone_schema["properties"])
        required = set(zone_schema["required"])
        for zone in self.zones:
            self.assertTrue(required <= set(zone))
            self.assertFalse(set(zone) - allowed)

    def test_inventory_is_byte_reproducible(self):
        (REPO_ROOT / ".runtime-cache").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=REPO_ROOT / ".runtime-cache") as temp:
            output = Path(temp) / "relict"
            result = INVENTORY.build(SOURCE, output)
            self.assertEqual(result, self.summary)
            self.assertEqual(tree_hashes(output), tree_hashes(TRACKED))


if __name__ == "__main__":
    unittest.main(verbosity=2)
