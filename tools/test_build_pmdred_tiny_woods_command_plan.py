#!/usr/bin/env python3
"""Regression gates for the authenticated Tiny Woods command plan."""
from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "tools/build_pmdred_tiny_woods_command_plan.py"
SCENE = ROOT / "docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json"
POST = ROOT / "docs/pmdred_eu/playable/tiny_woods/post_route/eu_post_route_graph.json"
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
PINNED = {
    SCENE: "6cc155b0302602e7edb223243a43e65aa3b0b3ff296df7742e79686db07ee1d1",
    POST: "9f1cf97cbfa211b16dab5fbf52df8aeb195878461f6425be542a229468766615",
    PLAN: "ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b",
}
EXACT_FIELDS = (
    "index", "address", "op", "op_hex", "arg_byte", "arg_short", "arg1", "arg2",
    "pointer", "pret_source_index", "categories",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_tool():
    spec = importlib.util.spec_from_file_location("tiny_woods_command_plan", TOOL)
    if spec is None or spec.loader is None:
        raise ImportError(TOOL)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class TinyWoodsCommandPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tool = load_tool()
        cls.scene = json.loads(SCENE.read_text(encoding="utf-8"))
        cls.post = json.loads(POST.read_text(encoding="utf-8"))
        cls.plan = json.loads(PLAN.read_text(encoding="utf-8"))
        cls.expected = cls.tool.arrays(cls.scene, "tiny_woods_scene") + cls.tool.arrays(cls.post, "post_route")

    def test_pinned_source_and_plan_hashes(self) -> None:
        for path, expected in PINNED.items():
            self.assertEqual(sha256(path), expected, path)

    def test_all_27_array_boundaries_are_exact(self) -> None:
        actual = self.plan["arrays"]
        self.assertEqual(len(actual), 27)
        self.assertEqual(len(self.expected), 27)
        for expected, observed in zip(self.expected, actual, strict=True):
            self.assertEqual(observed["array_id"], expected["array_id"])
            self.assertEqual(observed["source_path"], expected["source_path"])
            self.assertEqual(observed["declared_count"], len(expected["commands"]))
            self.assertEqual(len(observed["commands"]), observed["declared_count"])
            self.assertEqual(observed["commands"][0]["address"], expected["commands"][0]["address"])
            self.assertEqual(observed["commands"][-1]["address"], expected["commands"][-1]["address"])

    def test_every_command_address_and_operand_is_preserved(self) -> None:
        observed = [row for array in self.plan["arrays"] for row in array["commands"]]
        expected = [row for array in self.expected for row in array["commands"]]
        self.assertEqual(len(observed), 975)
        self.assertEqual(len({row["address"] for row in observed}), 975)
        for source, planned in zip(expected, observed, strict=True):
            for field in EXACT_FIELDS:
                self.assertEqual(planned[field], source[field], f"{planned['address']}:{field}")
            self.assertEqual(planned["op_name"], self.tool.OP_NAMES[source["op"]])
            self.assertEqual(
                planned["pmdo_handler"],
                self.tool.HANDLERS.get(source["op"], "actor.control_unknown"),
            )

    def test_all_french_pointer_associations_are_exact(self) -> None:
        observed = [
            row for array in self.plan["arrays"] for row in array["commands"] if "french" in row
        ]
        expected = [
            row for array in self.expected for row in array["commands"] if "french" in row
        ]
        self.assertEqual(len(observed), 195)
        self.assertEqual(
            [(row["address"], row["pointer"], row["french"]) for row in observed],
            [(row["address"], row["pointer"], row["french"]) for row in expected],
        )

    def test_create_only_generation_is_reproducible(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp) / "command_plan.json"
            first = subprocess.run(
                [sys.executable, str(TOOL), "--output", str(output)],
                cwd=ROOT, text=True, capture_output=True, check=False,
            )
            self.assertEqual(first.returncode, 0, first.stdout + first.stderr)
            self.assertEqual(output.read_bytes(), PLAN.read_bytes())
            before = sha256(output)
            second = subprocess.run(
                [sys.executable, str(TOOL), "--output", str(output)],
                cwd=ROOT, text=True, capture_output=True, check=False,
            )
            self.assertNotEqual(second.returncode, 0)
            self.assertIn("refusing to overwrite", second.stderr)
            self.assertEqual(sha256(output), before)


if __name__ == "__main__":
    unittest.main()
