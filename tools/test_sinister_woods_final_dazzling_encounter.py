#!/usr/bin/env python3
"""Regression contract: D04P02 ends in the Team Dazzling battle."""
from __future__ import annotations
import json
from pathlib import Path
import unittest
ROOT = Path(__file__).resolve().parents[1]

class FinalDazzlingEncounterTests(unittest.TestCase):
    def test_entrance_has_no_kangaskhan_save_statue(self):
        ground = json.loads((ROOT / 'Data/Ground/gloomy_forest_entrance.rsground').read_text(encoding='utf-8-sig'))['Object']
        names = [obj.get('EntName') for entity in ground.get('Entities', []) for obj in entity.get('GroundObjects', [])]
        self.assertNotIn('Kangaskhan_Rock', names)

    def test_final_segment_loads_dazzling_arena(self):
        zone = json.loads((ROOT / 'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))['Object']
        final = zone['Segments'][4]
        text = json.dumps(final)
        self.assertIn('sinister_woods_dazzling', text)
        self.assertNotIn('gloomy_forest_boss', text)
        arena = json.loads((ROOT / 'Data/Map/sinister_woods_dazzling.rsmap').read_text(encoding='utf-8-sig'))['Object']
        species = [member['BaseForm']['Species'] for team in arena['MapTeams'] for member in team['Players']]
        self.assertEqual(species, ['tsareena', 'lopunny', 'mismagius'])

    def test_d04p02_cinematic_transitions_to_final_team_battle(self):
        scene = (ROOT / 'Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua').read_text()
        self.assertIn('DazzlingFinalBattleSeen', scene)
        self.assertIn("GAME:ContinueDungeon('gloomy_forest', 4", scene)
        self.assertIn('COMMON.BossTransition()', scene)

if __name__ == '__main__':
    unittest.main()
