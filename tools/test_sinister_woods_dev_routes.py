#!/usr/bin/env python3
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
class TestDevRoutes(unittest.TestCase):
 def test_final_cinematic_is_armable(self):
  t=(ROOT/'Data/Script/halcyon/SceneDebug.lua').read_text()
  self.assertIn("key = 'sinister_dazzling_final'",t)
  self.assertIn('SinisterFinalGroundPending = true',t)
 def test_every_canonical_floor_has_dev_entry(self):
  t=(ROOT/'Data/Script/halcyon/SceneDebug.lua').read_text()
  self.assertIn('function SceneDebug.GoSinisterFloor(floor)',t)
  self.assertIn("GAME:EnterDungeon('gloomy_forest', segment, map, 0",t)
  for n in ['floor >= 8 and floor <= 10','floor >= 11'] : self.assertIn(n,t)
if __name__=='__main__':unittest.main()
