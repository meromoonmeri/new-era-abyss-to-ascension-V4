#!/usr/bin/env python3
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class TestGroundOrder(unittest.TestCase):
 def test_midpoint_is_the_entry_route(self):
  text=(ROOT/'Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua').read_text()
  self.assertIn('EnterGroundMap("gloomy_forest_midpoint", "Main_Entrance_Marker")',text)
  mid=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_midpoint/init.lua').read_text()
  self.assertIn('GAME:EnterDungeon("gloomy_forest", 0, 0, 0',mid)
 def test_entrance_is_the_final_ground_route(self):
  zone=(ROOT/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
  self.assertIn("GAME:EnterGroundMap('gloomy_forest_entrance', 'Main_Entrance_Marker')",zone)
  entry=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_entrance/init.lua').read_text()
  self.assertIn('SinisterFinalGroundPending',entry)
  self.assertIn('DazzlingClearingCutscene()',entry)
if __name__=='__main__':unittest.main()
