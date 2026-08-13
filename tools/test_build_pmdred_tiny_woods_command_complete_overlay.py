#!/usr/bin/env python3
"""Regression tests for the create-only command-complete Tiny Woods overlay."""
from __future__ import annotations

import hashlib
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from tools import build_pmdred_tiny_woods_command_complete_overlay as builder

ROOT = Path(__file__).resolve().parents[1]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class TinyWoodsCommandCompleteOverlayTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temp = tempfile.TemporaryDirectory(prefix="tw-command-overlay-", dir=ROOT / ".runtime-cache")
        cls.output = Path(cls.temp.name) / "fixture"
        cls.manifest = builder.build(cls.output)
        cls.complete = cls.manifest["tiny_woods_command_complete"]

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp.cleanup()

    def test_create_only_and_aggregate_identity(self) -> None:
        self.assertEqual(self.complete["schema"], "pmdred-eu-tiny-woods-command-complete-overlay-v1")
        self.assertEqual(
            self.complete["command_surface"],
            {"arrays": 27, "commands": 975, "unique_addresses": 975, "opcodes": 61, "french_text_associations": 195},
        )
        with self.assertRaises(FileExistsError):
            builder.build(self.output)

    def test_private_scripts_audio_and_validator_are_hash_bound(self) -> None:
        self.assertEqual(
            self.complete["fixture_isolation"],
            {"script_private": True, "music_private": True, "sound_private": True, "promoted_grounds_read_only_bound": True},
        )
        self.assertEqual({row["song_index"] for row in self.complete["music"].values()}, {1, 10, 46, 101, 103, 114})
        self.assertEqual({row["cue_id"] for row in self.complete["cues"].values()}, {450, 455, 457, 463, 465, 466, 468, 469, 470, 473, 482})
        for group in ("files", "music", "cues"):
            for name, expected in self.complete[group].items():
                path = self.output / name
                self.assertTrue(path.is_file(), name)
                self.assertFalse(path.is_symlink(), name)
                self.assertEqual(path.stat().st_size, expected["bytes"])
                self.assertEqual(sha256(path), expected["sha256"])
        validator = self.output / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
        text = validator.read_text()
        self.assertNotIn("@@LAUNCHER_GROUND_INDEX@@", text)
        self.assertIn("GAME:EnterZone('master_zone',-1,308,0)", text)

    def test_audio_renderer_provenance_is_source_bound(self) -> None:
        altered = Path(self.temp.name) / "altered-fanfares"
        shutil.copytree(builder.FANFARE_SOURCE, altered)
        manifest_path = altered / "manifest.json"
        manifest = json.loads(manifest_path.read_text())
        manifest["renderers"]["one_shot"]["source_sha256"] = "0" * 64
        manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")
        with self.assertRaisesRegex(ValueError, "audio renderer source provenance differs"):
            builder.build(Path(self.temp.name) / "invalid-provenance", fanfare_source=altered)

    def test_generated_campaign_preserves_every_command_and_selected_french_path(self) -> None:
        campaign = (self.output / "quest/Data/Script/halcyon/pmdred_tiny_woods_command_campaign.lua").read_text()
        plan = json.loads(builder.PLAN.read_text())
        for array in plan["arrays"]:
            self.assertIn(f'[{builder.lua(array["array_id"])}]', campaign)
            for command in array["commands"]:
                self.assertIn(f"address={builder.lua(command['address'])}", campaign)
        self.assertEqual(campaign.count("fr={block="), 195)
        self.assertIn("if i==23 and PMDRED_TINY_WOODS_HERO_NAME", (self.output / "quest/Data/Script/halcyon/pmdred_tiny_woods_scenes.lua").read_text())
        self.assertEqual(self.complete["dialogue"]["post_route_total_with_one_refusal"], 56)

    def test_corrected_route_rewards_and_progression_are_native(self) -> None:
        scripts = self.output / "quest/Data/Script/halcyon/ground"
        d01p01 = (scripts / "d01p01/init.lua").read_text()
        d01p02 = (scripts / "d01p02/init.lua").read_text()
        base = (scripts / "b01p00a/init.lua").read_text()
        title = (scripts / "s02_fre/init.lua").read_text()
        campaign = (self.output / "quest/Data/Script/halcyon/pmdred_tiny_woods_command_campaign.lua").read_text()
        self.assertIn("Route.CompleteRescue()", d01p02)
        self.assertIn("GAME:EnterGroundMap('d01p01','Main_Entrance_Marker')", d01p02)
        self.assertIn("GAME:EnterZone('master_zone',-1,141,0)", d01p01)
        self.assertIn("GAME:EnterGroundMap(329,0)", base)
        self.assertIn("_DATA.Save:CompleteDungeon('tiny_woods')", campaign)
        self.assertIn("SV.Scenario.Main=3", campaign)
        self.assertIn("EventDivision='EVENT_DIVIDE'", campaign)
        for item in ("berry_oran", "berry_pecha", "berry_rawst"):
            self.assertIn(item, campaign)
        self.assertIn("Campaign.RunTitle()", title)


if __name__ == "__main__":
    unittest.main()
