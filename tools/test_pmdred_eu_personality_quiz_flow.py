#!/usr/bin/env python3
"""Regressions for the production-routed PMD Red EU quiz presentation flow."""

from __future__ import annotations

import hashlib
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INIT = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"
FLOW = ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_flow.lua"
GROUND = ROOT / "Data/Ground/personality_test.rsground"
RUNTIME = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_flow"
EXPECTED_RECOMMENDATIONS = {
    "hardy": ["charmander", "pikachu"],
    "docile": ["bulbasaur", "chikorita"],
    "brave": ["machop", "charmander"],
    "jolly": ["squirtle", "totodile"],
    "impish": ["pikachu", "cubone"],
    "naive": ["totodile", "eevee"],
    "timid": ["cyndaquil", "mudkip"],
    "hasty": ["torchic", "skitty"],
    "sassy": ["treecko", "torchic"],
    "calm": ["mudkip", "bulbasaur"],
    "relaxed": ["psyduck", "squirtle"],
    "lonely": ["cubone", "psyduck"],
    "quirky": ["meowth", "treecko"],
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class PersonalityQuizFlowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.init = INIT.read_text()
        cls.flow = FLOW.read_text()
        cls.validation = json.loads((RUNTIME / "validation.json").read_text())

    def test_existing_personality_test_is_the_only_production_route(self) -> None:
        self.assertIn("function personality_test.CharacterSelect()", self.init)
        self.assertIn(
            "local PmdRedQuizFlow = require 'halcyon.ground.personality_test.pmdred_quiz_flow'",
            self.init,
        )
        prelude = self.init.index("PmdRedQuizFlow.PlayCanonicalPrelude()")
        run = self.init.index("local quiz_result = PmdRedQuizFlow.Run()")
        selector = self.init.index("if CONFIG.RegularStarters() then", run)
        self.assertLess(prelude, run)
        self.assertLess(run, selector)
        self.assertEqual(self.init.count("PmdRedQuizFlow.Run()"), 1)
        self.assertNotIn("Bienvenue dans le monde des Pokémon !", self.init)
        self.assertNotIn("Es-tu un garçon, une fille ou non binaire ?", self.init)
        self.assertNotIn("GAME:FadeOut(false, 120)", self.init)

    def test_result_is_transmitted_and_catalogue_is_prioritized_never_filtered(self) -> None:
        for token in (
            "SV.PersonalityTest.Personality = quiz_result.personality",
            "SV.PersonalityTest.GenderChoice = quiz_result.gender_choice",
            "SV.PersonalityTest.Recommendation = quiz_result.recommendation",
            "SV.PersonalityTest.SelectedQuestions = quiz_result.selected_questions",
            "SV.PersonalityTest.Totals = quiz_result.totals",
            "PmdRedQuizFlow.PrioritizeRecommendation(",
        ):
            self.assertIn(token, self.init)
        self.assertIn("move, never filter", self.flow)
        self.assertNotIn("table.remove", self.flow)
        self.assertIn("for _, value in ipairs(values)", self.flow)
        self.assertIn("for _, value in ipairs(deferred) do prioritized[#prioritized + 1] = value end", self.flow)

    def test_canonical_recommendation_table_matches_red(self) -> None:
        block = self.flow[
            self.flow.index("local CANONICAL_RECOMMENDATIONS"):
            self.flow.index("local function emit")
        ]
        observed = {
            nature: [male, female]
            for nature, male, female in re.findall(
                r"^\s*(\w+) = \{'([^']+)', '([^']+)'\},$", block, re.MULTILINE
            )
        }
        self.assertEqual(observed, EXPECTED_RECOMMENDATIONS)
        self.assertIn("data.gender.answers[1]", self.flow)
        self.assertIn("data.gender.answers[2]", self.flow)
        self.assertIn("text = 'Non-binaire.'", self.flow)
        self.assertIn("gender_choice == 2 and 2 or 1", self.flow)
        self.assertIn("new_era_non_binding = true", self.flow)

    def test_canonical_staging_and_partner_chain_are_routed(self) -> None:
        for token in (
            "PMDRED_EU_S01_006_A",
            "PMDRED_EU_S01_006_B",
            "SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)",
            "GAME:FadeIn(30)",
            "source_opcode = 'CMD_BYTE_22'",
            "SOUND:FadeOutBGM(30)",
            "GAME:FadeOut(false, 30)",
            "source_opcode = 'CMD_BYTE_23'",
        ):
            self.assertIn(token, self.flow)
        self.assertIn("PmdRedQuizFlow.ShowPartnerPrompt()", self.init)
        self.assertIn("PmdRedQuizFlow.PartnerNicknamePrompt()", self.init)
        self.assertIn("PmdRedQuizFlow.ShowEndText()", self.init)
        self.assertIn("PmdRedQuizFlow.FadeOutCanonical()", self.init)
        ground = json.loads(GROUND.read_text(encoding="utf-8-sig"))["Object"]
        self.assertEqual(ground["AssetName"], "personality_test")
        self.assertEqual(
            [layer["BG"]["BGMovement"]["X"] for layer in ground["Background"]["Layers"]],
            [30, -30],
        )

    def test_runtime_evidence_is_explicitly_partial_and_integral(self) -> None:
        self.assertEqual(
            self.validation["result"],
            "FLOW_PASS_PRODUCTION_ROUTED_INTERACTIVE_INPUT_PARTIAL",
        )
        self.assertTrue(self.validation["production_personality_test_routed"])
        self.assertFalse(self.validation["full_quiz_integrated"])
        self.assertEqual(self.validation["timeline"]["event_count"], 246)
        self.assertEqual(self.validation["timeline"]["text_page_count"], 46)
        self.assertEqual(self.validation["timeline"]["choice_prompt_count"], 21)
        self.assertEqual(self.validation["timeline"]["restart_count"], 1)
        self.assertEqual(self.validation["timeline"]["branch_count"], 1)
        self.assertIn("physical interactive menu input", self.validation["not_yet_validated"][0])
        self.assertIn("INTERACTIVE_INPUT", self.validation["promotion"])
        rows = (RUNTIME / "evidence_hashes.sha256").read_text().splitlines()
        self.assertEqual(len(rows), 8)
        for row in rows:
            expected, relative = row.split("  ", 1)
            self.assertEqual(sha256(RUNTIME / relative), expected)


if __name__ == "__main__":
    unittest.main(verbosity=2)
