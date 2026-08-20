#!/usr/bin/env python3
"""Regression tests for authenticated Tiny Woods French scene evidence."""
from __future__ import annotations
import hashlib,importlib.util,json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
E=ROOT/'docs/pmdred_eu/playable/tiny_woods/scene_runtime'
def sha(p:Path)->str:return hashlib.sha256(p.read_bytes()).hexdigest()
def load(name:str):
 p=ROOT/'tools'/f'{name}.py';s=importlib.util.spec_from_file_location(name,p);assert s and s.loader;m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
class TinyWoodsSceneTests(unittest.TestCase):
 def test_archived_runtime_and_termination(self):
  for line in (E/'evidence_hashes.sha256').read_text().splitlines():
   expected,name=line.split(None,1);p=E/name.removeprefix('./');self.assertTrue(p.is_file());self.assertEqual(sha(p),expected)
  runner=load('run_pmdred_tiny_woods_scenes');plan=json.loads((ROOT/'docs/pmdred_eu/playable/tiny_woods/scene_plan.json').read_text())
  report=json.loads((E/'native_scene_validation.json').read_text());self.assertEqual(report['status'],'passed');self.assertEqual(sum(x['dialogue_count'] for x in report['runs']),74)
  for mode in runner.MODES:
   summary=runner.validate(mode,runner.read_events(E/mode/'events.jsonl'),plan);self.assertGreater(summary['choreography_count'],0);runner.strict(E/mode/'termination.json')
 def test_scene_graph_and_pointer_plan(self):
  graph=json.loads((ROOT/'docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json').read_text());general=json.loads((ROOT/'docs/pmdred_eu/ground_scripts.json').read_text())
  self.assertEqual(graph['validation']['status'],'pass');self.assertEqual(graph['totals']['eu_command_count'],697);self.assertEqual(graph['totals']['french_text_count'],117)
  focused=next(x for x in graph['candidates'] if x['asset']=='d01p02');canonical=next(x for x in general['candidates'] if x['asset']=='d01p02');self.assertEqual(focused,canonical)
  plan=json.loads((ROOT/'docs/pmdred_eu/playable/tiny_woods/scene_plan.json').read_text());self.assertEqual(plan['totals']['selected_french_dialogue_count'],74);self.assertEqual(plan['variant_policy']['invented_text_count'],0)
  pointers=[x['pointer'] for s in plan['scenes'].values() for x in s['dialogue']];self.assertEqual(len(pointers),len(set(pointers)))
 def test_rom_music_promotions(self):
  manifest=json.loads((E/'music_render_validation.json').read_text());self.assertEqual(manifest['validation'],{'status':'pass','track_count':4});self.assertEqual(manifest['renderer']['source_sha256'],sha(ROOT/'tools/pmdred_m4a_to_ogg_general.c'))
  for track in manifest['tracks']:
   p=ROOT/'Content/Music'/track['filename'];self.assertEqual(sha(p),track['sha256']);self.assertEqual(track['deterministic_runs'],2);self.assertEqual(track['samples'],track['loop_start']+track['loop_length'])
  self.assertEqual(sha(ROOT/'tools/pmdred_m4a_to_ogg.c'),'4940a70df2d4919fd2af3acb2afad920cc769f653cd51af9048a5c463e48eeff')
if __name__=='__main__':unittest.main()
