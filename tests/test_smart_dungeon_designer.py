#!/usr/bin/env python3
import json,random,shutil,tempfile,unittest
from pathlib import Path
import sys
REPO=Path(__file__).resolve().parents[1];sys.path.insert(0,str(REPO/'tools'))
from smart_dungeon.assets import analyze_library
from smart_dungeon.intent import parse_intent
from smart_dungeon.layout import progression,select_best,repair
from smart_dungeon.model import FloorPlan,Room
from smart_dungeon.quality import evaluate
from smart_dungeon.project import generate_project,regenerate,validate_project,write
class TestSmartDungeonDesigner(unittest.TestCase):
 def test_01_natural_intent_and_semantic_special_schedule(self):
  b=parse_intent('Sanctuaire','Un donjon ancien et majestueux de 25 étages, ouvert au début puis labyrinthique et inquiétant, avec un boss final, deux mini-boss, trois relais, sans eau.',seed=42);self.assertEqual(b.floors,25);self.assertTrue(b.boss);self.assertEqual(b.mini_bosses,2);self.assertEqual(b.relays,3);self.assertEqual(b.topology_start,'open');self.assertEqual(b.topology_end,'labyrinth');self.assertEqual(b.water_policy,'forbid');rows=progression(b);self.assertEqual(rows[-1]['special'],'boss');relay_floors=[x['floor'] for x in rows if x['special']=='relay'];self.assertEqual(len(relay_floors),3);self.assertNotEqual(relay_floors,[5,10,15])
 def test_02_candidate_search_is_deterministic_and_quality_driven(self):
  b=parse_intent('Test','12 étages, début ouvert puis labyrinthique, boss final',seed=777,boss=True);row=progression(b)[5];a,variants_a=select_best(b,row,b.seed,{'common':['a'],'secondary':['b'],'rare':['c'],'focal':['d']},variants=4);c,variants_b=select_best(b,row,b.seed,{'common':['a'],'secondary':['b'],'rare':['c'],'focal':['d']},variants=4);self.assertEqual(a.to_dict(),c.to_dict());self.assertEqual(variants_a,variants_b);self.assertEqual(a.quality['score'],max(x['score'] for x in variants_a));self.assertTrue(a.quality['metrics']['accessibility']==1)
 def test_03_local_repair_connects_only_the_broken_structure(self):
  tiles=['wall']*(20*15);rooms=[Room(0,'rect',2,2,3,3,[[1]*3 for _ in range(3)]),Room(1,'rect',15,10,3,3,[[1]*3 for _ in range(3)])];plan=FloorPlan(1,1,20,15,'loops','development',None,'test',rooms,[],tiles,[3,3],[16,11])
  for room in rooms:
   for y in range(room.y,room.y+room.height):
    for x in range(room.x,room.x+room.width):plan.set(x,y,'room')
  before=evaluate(plan);self.assertIn('DISCONNECTED',{x['code'] for x in before['violations']});repair(plan,before,random.Random(1));after=evaluate(plan);self.assertGreater(after['metrics']['accessibility'],before['metrics']['accessibility']);self.assertIn('connect_components',{x['action'] for x in plan.repair_log});self.assertTrue(all(x['localized'] for x in plan.repair_log))
 def test_04_asset_analysis_infers_roles_and_native_texture_vocabulary(self):
  with tempfile.TemporaryDirectory(dir=REPO/'.runtime-cache') as td:
   out=Path(td)/'assets.json';d=analyze_library(REPO,out,max_sheets=3,max_grounds=8,samples_per_sheet=4);self.assertEqual(d['result'],'ASSET_SEMANTIC_ANALYSIS_PASS');self.assertEqual(d['ground_sheet_count'],3);self.assertGreater(d['dungeon_texture_bundle_count'],0);self.assertTrue(all(a['role_scores'] and a['cluster_id'] for a in d['assets']));self.assertTrue(any(a['compatible'] for a in d['assets'] if a['kind']=='dungeon_texture_bundle'))
 @classmethod
 def setUpClass(cls):
  (REPO/'.runtime-cache').mkdir(exist_ok=True);cls.temp=Path(tempfile.mkdtemp(dir=REPO/'.runtime-cache',prefix='smart-test-'));cls.p1=cls.temp/'one';cls.p2=cls.temp/'two';intent='Un sanctuaire ancien et majestueux de 8 étages, ouvert au début puis labyrinthique et inquiétant, avec un boss final, un mini-boss, deux relais et une grande salle centrale.';cls.plan1=generate_project(REPO,cls.p1,'Sanctuaire Test',intent,8,'difficile',True,1,2,12345,None,3,5);cls.plan2=generate_project(REPO,cls.p2,'Sanctuaire Test',intent,8,'difficile',True,1,2,12345,None,3,5)
 @classmethod
 def tearDownClass(cls):shutil.rmtree(cls.temp,ignore_errors=True)
 def test_04_complete_project_and_native_zone_compilation(self):
  p=self.p1;required=['asset_catalog.json','brief.json','progression.json','project.json','quality_report.json','generation_manifest.json','previews/contact_sheet.svg','zone/sanctuaire_test.json'];self.assertTrue(all((p/x).exists() for x in required));self.assertEqual(len(list((p/'plans').glob('floor_*.json'))),8);self.assertEqual(len(list((p/'previews').glob('floor_*.svg'))),8);result=validate_project(p);self.assertEqual(result['result'],'SMART_DUNGEON_VALIDATION_PASS');self.assertGreaterEqual(result['stairs_step_count'],8);self.assertGreater(result['minimum_score'],72);z=json.loads((p/'zone/sanctuaire_test.json').read_text(encoding='utf-8-sig'))['Object'];self.assertTrue(z['Released']);self.assertEqual(len(z['Segments']),1);self.assertEqual(len(z['Segments'][0]['Floors']['nodes']),8);self.assertEqual(z['GroundMaps'],[])
 def test_05_same_seed_same_floor_plans_and_zone(self):
  a=json.loads((self.p1/'project.json').read_text());b=json.loads((self.p2/'project.json').read_text());self.assertEqual(a['brief'],b['brief']);self.assertEqual(a['progression'],b['progression']);self.assertEqual(a['floors'],b['floors']);self.assertEqual((self.p1/'zone/sanctuaire_test.json').read_bytes(),(self.p2/'zone/sanctuaire_test.json').read_bytes())
 def test_06_locks_and_local_regeneration(self):
  p=self.p1;before=json.loads((p/'plans/floor_008.json').read_text());locks=json.loads((p/'locks.json').read_text());locks.setdefault('floors',{})['8']={'locked':True};write(p/'locks.json',locks);regenerate(REPO,p,'floor:8',99999,False,2);after=json.loads((p/'plans/floor_008.json').read_text());self.assertEqual(before,after);floor2_before=json.loads((p/'plans/floor_002.json').read_text());floor3_before=json.loads((p/'plans/floor_003.json').read_text());regenerate(REPO,p,'decor:3',12345,False,2);floor2_after=json.loads((p/'plans/floor_002.json').read_text());floor3_after=json.loads((p/'plans/floor_003.json').read_text());self.assertEqual(floor2_before,floor2_after);self.assertEqual(floor3_before['tiles'],floor3_after['tiles']);self.assertEqual(floor3_before['rooms'],floor3_after['rooms']);self.assertNotEqual(floor3_before['decorations'],floor3_after['decorations'])
 def test_07_boss_miniboss_relay_contracts(self):
  c=self.plan2.compiler;self.assertIsNotNone(c['boss_contract']);self.assertEqual(len(c['mini_boss_contracts']),1);self.assertEqual(len(c['relay_contracts']),2);self.assertEqual(c['boss_contract']['floor'],8)
if __name__=='__main__':unittest.main(verbosity=2)
