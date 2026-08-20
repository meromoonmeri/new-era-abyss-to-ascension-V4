#!/usr/bin/env python3
"""Archive gates for the recovered Tiny Woods semantic correction v3."""
from __future__ import annotations

import hashlib
import importlib.util
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SUPPLEMENT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json"
GENERATOR = ROOT / "tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py"
VALIDATOR = ROOT / "tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py"


def sha256(path: Path) -> str:return hashlib.sha256(path.read_bytes()).hexdigest()


def module(path: Path):
    spec=importlib.util.spec_from_file_location(path.stem,path);value=importlib.util.module_from_spec(spec);spec.loader.exec_module(value);return value


class CommandSemanticV3ArchiveTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan=json.loads(PLAN.read_text(encoding="utf-8"));cls.value=json.loads(SUPPLEMENT.read_text(encoding="utf-8"))

    def test_01_authority_and_immutable_plan_identity(self):
        self.assertEqual(sha256(PLAN),"ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b")
        self.assertEqual(self.value["authority"]["rom_sha256"],"0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd")
        self.assertTrue(self.value["contract"]["command_plan_is_immutable"])

    def test_02_generator_is_byte_deterministic(self):
        with tempfile.TemporaryDirectory() as tmp:
            out=Path(tmp)/"supplement.json"
            subprocess.run(["python3",str(GENERATOR),"--output",str(out)],cwd=ROOT,check=True,stdout=subprocess.PIPE,text=True)
            self.assertEqual(out.read_bytes(),SUPPLEMENT.read_bytes())

    def test_03_independent_validator_accepts_archive(self):
        proc=subprocess.run(["python3",str(VALIDATOR),"--supplement",str(SUPPLEMENT)],cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        self.assertEqual(proc.returncode,0,proc.stderr)
        self.assertIn("SUPPLEMENT_V3_VALID",proc.stdout)

    def test_04_independent_validator_rejects_operand_mutation(self):
        with tempfile.TemporaryDirectory() as tmp:
            value=json.loads(SUPPLEMENT.read_text(encoding="utf-8"));value["commands"][0]["arg_short"]+=1
            bad=Path(tmp)/"bad.json";bad.write_text(json.dumps(value),encoding="utf-8")
            proc=subprocess.run(["python3",str(VALIDATOR),"--supplement",str(bad)],cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            self.assertNotEqual(proc.returncode,0)
            self.assertIn("source field differs",proc.stderr)

    def test_05_selected_retry_and_wait_boundaries(self):
        self.assertEqual(self.value["totals"],{
            "commands":304,"selected_route":251,"retry_only":53,"opcodes":16,
            "source_waits":108,"source_wait_frames":3001,"selected_route_waits":92,
            "selected_route_wait_frames":2690,"planning_unknown_rows":15,"supplement_unknown_rows":0,
        })
        retry=[row for row in self.value["commands"] if row["route_class"]=="retry_only"]
        self.assertEqual(len(retry),53);self.assertTrue(all("s_gs178_g2_" in row["array_id"] for row in retry))

    def test_06_semantic_rows_are_complete_and_unknown_disjoint(self):
        semantic={row["address"] for row in self.value["commands"]}
        unknown={row["address"] for array in self.plan["arrays"] for row in array["commands"] if row["pmdo_handler"]=="actor.control_unknown"}
        self.assertEqual(len(semantic),304);self.assertEqual(len(unknown),15);self.assertFalse(semantic & unknown)
        self.assertTrue(all(row["semantic_category"] and row["pmdo_api"] for row in self.value["commands"]))


if __name__=="__main__":unittest.main()
