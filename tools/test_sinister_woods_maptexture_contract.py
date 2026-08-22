#!/usr/bin/env python3
"""Guard PMDO's terrain-to-autotile contract for Sinister Woods."""
import json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
def walk(v):
 if isinstance(v,dict):
  yield v
  for x in v.values():yield from walk(x)
 elif isinstance(v,list):
  for x in v:yield from walk(x)
class TestMapTextureContract(unittest.TestCase):
 def test_all_procedural_segments_use_layered_ground_and_autotiles(self):
  zone=json.loads((ROOT/'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))
  steps=[x for x in walk(zone) if x.get('$type','').startswith('RogueEssence.LevelGen.MapTextureStep') and x.get('GroundTileset')=='sinister_woods_floor']
  self.assertEqual(len(steps),3)
  for step in steps:
   self.assertEqual(step['BlockTileset'],'sinister_woods_wall')
   self.assertEqual(step['WaterTileset'],'sinister_woods_secondary')
   self.assertTrue(step['LayeredGround'])
   self.assertFalse(step['IndependentGround'])
if __name__=='__main__':unittest.main()
