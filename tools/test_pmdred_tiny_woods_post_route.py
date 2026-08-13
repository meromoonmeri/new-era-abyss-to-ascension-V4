#!/usr/bin/env python3
"""Regression tests for the authenticated EU post-Tiny-Woods route."""
from __future__ import annotations
import importlib.util,json,sys,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'docs/pmdred_eu/playable/tiny_woods/post_route/eu_post_route_graph.json'
def load():
 p=ROOT/'tools/audit_pmdred_eu_tiny_woods_post_route.py';s=importlib.util.spec_from_file_location('post_route_audit',p);assert s and s.loader;m=importlib.util.module_from_spec(s);sys.modules[s.name]=m;s.loader.exec_module(m);return m
class TinyWoodsPostRouteTests(unittest.TestCase):
 def test_archived_correction_and_totals(self):
  report=json.loads(REPORT.read_text())
  self.assertEqual(report['validation']['status'],'pass')
  self.assertIn('map-script 9:g16 (b01p00a)',report['correction']['authenticated_eu_route'])
  self.assertIn('map-script 229:g2 (s02/s02_fre)',report['correction']['authenticated_eu_route'])
  self.assertEqual(report['totals'],{'event_command_count':10,'rescue_base_script_count':6,'rescue_base_command_count':258,'rescue_base_french_text_count':78,'title_command_count':10})
 def test_event_targets_and_progression(self):
  report=json.loads(REPORT.read_text());event=report['event_route']
  self.assertEqual([(x['regional_map_script_id'],x['group']) for x in event['route']],[(184,1),(183,3),(9,16),(229,2)])
  self.assertEqual(event['route'][2]['stable_ground'],'b01p00a')
  self.assertEqual(event['route'][3]['pmdo_french_variant'],'s02_fre')
  self.assertEqual(event['progression']['scenario_main'],[3,0])
  self.assertEqual(event['progression']['terminal'],'EVENT_DIVIDE')
 def test_scoped_graph_contract(self):
  report=json.loads(REPORT.read_text());base=report['rescue_base_group'];title=report['title_group']
  self.assertEqual(base['validation']['group_shift_authenticated'],{'pret':17,'eu':16})
  self.assertEqual(base['selected_graphical_map_id'],9)
  self.assertEqual(base['selected_stable_ground'],'b01p00a')
  self.assertEqual(len(base['scripts']),6);self.assertEqual(len(base['text_blocks']),78)
  self.assertEqual(title['selected_graphical_map_id'],229);self.assertEqual(title['pmdo_french_variant'],'s02_fre')
  self.assertTrue(title['validation']['rom_direct_decode'])
 def test_reaudit_when_authorities_available(self):
  rom=ROOT/'.runtime-cache/downloads/pmdred-eu.gba';pret=ROOT/'.runtime-cache/pmd-red-reference'
  if not rom.is_file() or not (pret/'.git').exists():self.skipTest('authenticated local authorities unavailable')
  module=load();fresh=module.audit(rom.read_bytes(),pret,'gcc',rom.name);archived=json.loads(REPORT.read_text())
  self.assertEqual(fresh,archived)
if __name__=='__main__':unittest.main()
