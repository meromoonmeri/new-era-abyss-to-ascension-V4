#!/usr/bin/env python3
"""Structural tests for PMD Red's six PMDO orb adapters."""

from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

EXPECTED_ITEMS = {
    "pmdred_permutorbe": ("Permutorbe", "PMDC.Dungeon.SwitcherEvent, PMDC"),
    "pmdred_soufflorbe": ("Soufflorbe", "PMDC.Dungeon.KnockBackEvent, PMDC"),
    "pmdred_teleporbe": ("Téléporbe", "PMDC.Dungeon.RandomWarpEvent, PMDC"),
    "pmdred_revelorbe": ("Révélorbe", "PMDC.Dungeon.GiveMapStatusEvent, PMDC"),
    "pmdred_radarorbe": ("Radarorbe", "PMDC.Dungeon.GiveMapStatusEvent, PMDC"),
    "pmdred_projectorbe": ("Projectorbe", "PMDC.Dungeon.ThrowBackEvent, PMDC"),
}
EXPECTED_STATUSES = {
    "pmdred_items_revealed": "PMDC.Dungeon.SeeItemsEvent, PMDC",
    "pmdred_characters_revealed": "PMDC.Dungeon.SeeCharsEvent, PMDC",
}


def load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


class OrbAdapterTests(unittest.TestCase):
    def test_items_are_indexed_functional_orbs(self) -> None:
        index = load(ROOT / "Data/Item/index.idx")["Object"]
        for item_id, (name_fr, event_type) in EXPECTED_ITEMS.items():
            with self.subTest(item_id=item_id):
                item = load(ROOT / f"Data/Item/{item_id}.json")["Object"]
                self.assertIn(item_id, index)
                self.assertEqual(item["Name"]["LocalTexts"]["fr"], name_fr)
                self.assertEqual(
                    item["ItemStates"], [{"$type": "PMDC.Dungeon.OrbState, PMDC"}]
                )
                events = item["UseEvent"]["OnHits"]
                self.assertEqual(len(events), 1)
                self.assertEqual(events[0]["Value"]["$type"], event_type)
                self.assertTrue((ROOT / f"Content/Item/{item['Sprite']}.dir").is_file())

    def test_projectorbe_has_collision_damage(self) -> None:
        item = load(ROOT / "Data/Item/pmdred_projectorbe.json")["Object"]
        event = item["UseEvent"]["OnHits"][0]["Value"]
        self.assertEqual(event["Distance"], 10)
        self.assertEqual(event["HitEvent"], {
            "$type": "PMDC.Dungeon.SpecificDamageEvent, PMDC",
            "Damage": 10,
        })

    def test_scanner_contracts_do_not_overlap(self) -> None:
        index = load(ROOT / "Data/MapStatus/index.idx")["Object"]
        actual = {}
        for status_id in EXPECTED_STATUSES:
            with self.subTest(status_id=status_id):
                status = load(ROOT / f"Data/MapStatus/{status_id}.json")["Object"]
                self.assertIn(status_id, index)
                self.assertEqual(len(status["OnRefresh"]), 1)
                actual[status_id] = status["OnRefresh"][0]["Value"]["BaseEvent"]["$type"]
        self.assertEqual(actual, EXPECTED_STATUSES)

    def test_scanner_orbs_reference_the_split_statuses(self) -> None:
        expected = {
            "pmdred_revelorbe": "pmdred_items_revealed",
            "pmdred_radarorbe": "pmdred_characters_revealed",
        }
        for item_id, status_id in expected.items():
            item = load(ROOT / f"Data/Item/{item_id}.json")["Object"]
            event = item["UseEvent"]["OnHits"][0]["Value"]
            self.assertEqual(event["StatusID"], status_id)


if __name__ == "__main__":
    unittest.main()
