#!/usr/bin/env python3
import json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
class TestBeedrillMiniboss(unittest.TestCase):
 def test_arena_is_beedrill_swarm_with_evolved_chief(self):
  o=json.loads((ROOT/'Data/Map/gloomy_forest_miniboss.rsmap').read_text(encoding='utf-8-sig'))['Object']
  mobs=[m for t in o['MapTeams'] for m in t['Players']]
  self.assertGreaterEqual(len(mobs), 4)
  self.assertTrue(all(m['BaseForm']['Species']=='beedrill' for m in mobs))
  self.assertEqual(mobs[0]['Nickname'],'Dardargnan Alpha')
  self.assertGreater(mobs[0]['Level'], mobs[1]['Level'])
 def test_cinematic_uses_chief_and_scout(self):
  s=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_miniboss/gloomy_forest_miniboss_ch_6.lua').read_text()
  self.assertIn("{'Beedrill_Chief'",s);self.assertIn("{'Beedrill_Scout'",s)
if __name__=='__main__':unittest.main()
