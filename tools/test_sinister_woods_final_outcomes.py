#!/usr/bin/env python3
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
class TestFinalOutcomes(unittest.TestCase):
 def test_victory_marker_is_after_rescue_scene(self):
  zone=(ROOT/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
  scene=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua').read_text()
  self.assertIn('FinalVictoryPending = true',zone)
  self.assertNotIn('MissionComplete = true',zone[zone.index('if segmentID == 4'):zone.index('elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped',zone.index('if segmentID == 4'))])
  self.assertIn('DazzlingVictoryRescueCutscene',scene)
  self.assertLess(scene.index("{'Chenipent'"),scene.index('MissionComplete=true'))
 def test_retreat_and_defeat_return_to_midpoint_scenes(self):
  zone=(ROOT/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
  mid=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_midpoint/gloomy_forest_midpoint_ch_6.lua').read_text()
  self.assertIn('SinisterRetreatPending = true',zone)
  self.assertIn('function gloomy_forest_midpoint_ch_6.RetreatCutscene()',mid)
  self.assertIn('function gloomy_forest_midpoint_ch_6.WipedCutscene()',mid)
if __name__=='__main__':unittest.main()
