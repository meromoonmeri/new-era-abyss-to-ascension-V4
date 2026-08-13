#!/usr/bin/env python3
"""Regression gates for the archived Tiny Woods native-route milestone."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "docs/pmdred_eu/playable/tiny_woods/route_runtime"


def load_runner():
    path = ROOT / "tools/run_pmdred_tiny_woods_route.py"
    spec = importlib.util.spec_from_file_location("run_pmdred_tiny_woods_route", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class TinyWoodsRouteTests(unittest.TestCase):
    def test_archived_evidence_hashes_and_native_assertions(self) -> None:
        for line in (EVIDENCE / "evidence_hashes.sha256").read_text().splitlines():
            expected, name = line.split(None, 1)
            path = EVIDENCE / name.removeprefix("./")
            self.assertTrue(path.is_file())
            self.assertEqual(sha256(path), expected)

        runner = load_runner()
        report = json.loads((EVIDENCE / "native_route_validation.json").read_text())
        self.assertEqual(report["status"], "passed")
        self.assertEqual(report["runtime"]["version"], "0.8.12.0")
        self.assertEqual(report["authority"]["rom_sha256"], runner.ROM_SHA256)
        self.assertEqual(report["authority"]["ending_music"], runner.ENDING_MUSIC)
        self.assertEqual(
            report["authority"]["ending_music_sha256"], runner.ENDING_MUSIC_SHA256
        )
        self.assertTrue(
            report["assertions"]["natural_hostile_occupancy_replanned_and_attacked"]
        )

        summaries = []
        for mode in runner.MODES:
            items = runner.events(EVIDENCE / mode / "events.jsonl")
            summaries.append(runner.validate_mode(mode, items))
            runner.strict_termination(EVIDENCE / mode / "termination.json")
        clear = summaries[-1]
        self.assertEqual(clear["player_action_count"], 143)
        self.assertEqual(clear["attack_action_count"], 2)
        self.assertEqual(clear["occupancy_replan_count"], 28)

    def test_eu_bgm_command_and_content_tile_contract(self) -> None:
        graph = json.loads((ROOT / "docs/pmdred_eu/ground_scripts.json").read_text())
        d01p02 = next(item for item in graph["candidates"] if item["asset"] == "d01p02")
        commands = [
            command
            for script in d01p02["scripts"]
            for command in script["commands"]
            if command["address"] == "0x084D4C78"
        ]
        self.assertEqual(len(commands), 1)
        self.assertEqual(commands[0]["op_hex"], "0x44")
        self.assertEqual(commands[0]["arg1"], 114)

        music = ROOT / "Content/Music/In the Depths of the Pit.ogg"
        self.assertEqual(
            sha256(music),
            "4b22c99be63e4ec61055c9a32ea0951e4910132551a8258f58fe2f1a6f9d9cd2",
        )
        builder = (ROOT / "tools/build_pmdred_tiny_woods_route_fixture.py").read_text()
        validator = (ROOT / "tools/pmdred_tiny_woods_route_validator.lua").read_text()
        self.assertIn('quest / "Content/Tile/d01p02_DirectBase.tile"', builder)
        self.assertNotIn('quest / "Data/Tile/d01p02_DirectBase.tile"', builder)
        self.assertIn("SOUND:PlayBGM('In the Depths of the Pit.ogg', false)", builder)
        self.assertIn("SOUND:GetCurrentSong()=='In the Depths of the Pit.ogg'", validator)
        self.assertNotIn("GROUND:Teleport", validator)
        self.assertIn("ProcessPlayerInput", validator)

    def test_playable_checkpoint_points_past_route_phase(self) -> None:
        progress = json.loads((ROOT / "docs/pmdred_eu/playable/progress.json").read_text())
        route = progress["tiny_woods"]["entry_exit_retry_rescue_cleanup"]
        self.assertEqual(route["status"], "PASS")
        self.assertEqual(
            route["report_sha256"], sha256(EVIDENCE / "native_route_validation.json")
        )
        self.assertEqual(progress["tiny_woods"]["narrative_scenes"]["status"], "PENDING")
        self.assertEqual(
            progress["resume"]["next_phase"], "tiny_woods_eu_dialogue_and_choreography"
        )


if __name__ == "__main__":
    unittest.main()
