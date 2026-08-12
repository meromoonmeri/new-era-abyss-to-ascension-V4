#!/usr/bin/env python3
"""Narrow role-classification tests for the authenticated Ground campaign."""
from __future__ import annotations

import unittest

from run_pmdred_eu_ground_milestone import classify_ground_role


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


if __name__ == "__main__":
    unittest.main()
