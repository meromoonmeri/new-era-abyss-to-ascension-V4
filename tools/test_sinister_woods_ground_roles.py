#!/usr/bin/env python3
import json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
class TestGroundRoles(unittest.TestCase):
 def test_display_names_follow_physical_roles(self):
  expected={'gloomy_forest_midpoint':'Sinister Woods Entrance','gloomy_forest_entrance':'Sinister Woods Finale','sinister_woods_clearing':'Sinister Woods Guardian Clearing'}
  for ident,name in expected.items():
   data=json.loads((ROOT/'Data/Ground'/f'{ident}.rsground').read_text(encoding='utf-8-sig'))['Object']
   self.assertEqual(data['Name']['DefaultText'],name)
 def test_entry_is_searing_midpoint_template(self):
  e=json.loads((ROOT/'Data/Ground/gloomy_forest_midpoint.rsground').read_text(encoding='utf-8-sig'))['Object']
  t=json.loads((ROOT/'Data/Ground/searing_tunnel_midpoint.rsground').read_text(encoding='utf-8-sig'))['Object']
  self.assertEqual(e['Layers'],t['Layers'])
  self.assertEqual(e['obstacles'],t['obstacles'])
 def test_guardian_clearing_routes_to_miniboss_segment(self):
  zone=(ROOT/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
  clearing=(ROOT/'Data/Script/halcyon/ground/sinister_woods_clearing/init.lua').read_text()
  self.assertIn("GAME:EnterGroundMap('sinister_woods_clearing'",zone)
  self.assertIn("GAME:ContinueDungeon('gloomy_forest', 2, 0, 0",clearing)
if __name__=='__main__':unittest.main()
