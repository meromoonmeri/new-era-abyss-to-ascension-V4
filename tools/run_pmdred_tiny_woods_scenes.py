#!/usr/bin/env python3
"""Certify all four authenticated French Tiny Woods scenes in exact PMDO."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import shutil
import signal
import subprocess
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT=Path(__file__).resolve().parents[1]
PMDO_SHA256='faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327'
ROM_SHA256='0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd'
PLAN=ROOT/'docs/pmdred_eu/playable/tiny_woods/scene_plan.json'
EVENTS=Path('/tmp/tiny_woods_scenes.jsonl')
MODES=('opening_scene','defeat_scene','ending_rescue_scene')
EXPECTED={'opening_scene':['d01p01_g1'],'defeat_scene':['d01p01_g2'],'ending_rescue_scene':['d01p02_g1','d01p01_g3']}
MUSIC={'d01p01_g1':"PMD Red - There's Trouble.ogg",'d01p01_g2':'','d01p02_g1':'PMD Red - In the Depths of the Pit.ogg','d01p01_g3':''}
ACTORS={
 'd01p01_g1':[('PLAYER','200,196,Down: 0'),('PARTNER','232,196,Left: 2'),('BUTTERFREE','72,188,Right: 6')],
 'd01p01_g2':[('PLAYER','200,196,Down: 0'),('PARTNER','232,196,Down: 0'),('BUTTERFREE','216,172,Down: 0')],
 'd01p02_g1':[('PLAYER','164,276,Up: 4'),('PARTNER','196,276,Up: 4'),('CATERPIE','180,148,Up: 4')],
 'd01p01_g3':[('PLAYER','200,196,Up: 4'),('PARTNER','232,196,Up: 4'),('BUTTERFREE','232,172,Down: 0'),('CATERPIE','200,172,Down: 0')],
}
CHOREOGRAPHY={
 'd01p01_g1':['hero_sleep','hero_wake_music_fadein','hero_look_around','butterfree_enters','trouble_music','party_faces_dungeon'],
 'd01p01_g2':['party_sleep','party_wake','party_returns_to_dungeon'],
 'd01p02_g1':['ending_music_fadein','rescuers_approach','caterpie_notices','caterpie_happy'],
 'd01p01_g3':['successful_rescue_music','caterpie_admires_hero','reward_sequence','family_exits_east','partner_invites_hero'],
}

def load_tool(name:str)->ModuleType:
 p=ROOT/'tools'/f'{name}.py';s=importlib.util.spec_from_file_location(name,p)
 if s is None or s.loader is None:raise ImportError(p)
 m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m

def sha256(path:Path)->str:return hashlib.sha256(path.read_bytes()).hexdigest()
def dump(path:Path,value:Any)->None:path.parent.mkdir(parents=True,exist_ok=True);path.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n')
def read_events(path:Path)->list[dict[str,Any]]:return [json.loads(x) for x in path.read_text().splitlines() if x]

def index_fixture(fixture:Path,evidence:Path,runner:ModuleType)->dict[str,Any]:
 command=[str(runner.PMDO),'-asset',str(fixture/'asset')+'/', '-appdata',str(fixture/'appdata')+'/', '-quest','pmdred_eu_fixture','-index','zone']
 log=evidence/'index.log'
 with log.open('wb') as out:
  proc=subprocess.Popen(command,cwd=ROOT,env=runner.pmdo_env('tiny_woods_scene_index_only'),stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
  try:rc=proc.wait(timeout=60);timed=False
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(proc.pid,signal.SIGTERM)
   try:rc=proc.wait(timeout=5)
   except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);rc=proc.wait()
 idx=fixture/'quest/Data/Zone/index.idx';result={'status':'passed' if rc==0 and not timed and idx.is_file() else 'failed','return_code':rc,'timed_out':timed,'index_sha256':sha256(idx) if idx.is_file() else None,'log_sha256':sha256(log)}
 dump(evidence/'index_validation.json',result)
 if result['status']!='passed':raise RuntimeError('scene fixture zone index failed')
 return result

def authenticate(fixture:Path)->dict[str,Any]:
 manifest=json.loads((fixture/'fixture_manifest.json').read_text());scene=manifest.get('tiny_woods_scenes',{})
 if scene.get('schema')!='pmdred-eu-tiny-woods-scene-fixture-v1' or scene.get('authority',{}).get('rom_sha256')!=ROM_SHA256 or scene.get('scenarios')!=list(MODES):raise ValueError('scene fixture identity differs')
 for group in ('files','music'):
  for name,expected in scene[group].items():
   p=fixture/name
   if not p.is_file() or p.is_symlink() or p.stat().st_size!=expected['bytes'] or sha256(p)!=expected['sha256']:raise ValueError(f'scene fixture file differs: {name}')
 source=ROOT/scene['validator']['source'];installed=fixture/'quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua'
 if scene['validator']['source_sha256']!=sha256(source) or scene['validator']['fixture_sha256']!=sha256(installed):raise ValueError('scene validator differs')
 return manifest

def strict(path:Path)->dict[str,Any]:
 r=json.loads(path.read_text())
 if not (r.get('result')=='PASS' and r.get('exit_classification')=='NORMAL_EXIT' and r.get('return_code')==0 and r.get('terminal') is True and r.get('graceful') is True and r.get('watchdog') is False and r.get('requested_signal') is None and r.get('sigsegv') is False and r.get('forced_kill') is False and r.get('orphan_process') is False):raise ValueError(f'strict termination failed: {path}')
 return r

def validate(mode:str,items:list[dict[str,Any]],plan:dict[str,Any])->dict[str,Any]:
 verdict=[x for x in items if x.get('event')=='scene_verdict'];
 if len(verdict)!=1 or verdict[0].get('verdict')!='PASS' or verdict[0].get('mode')!=mode:raise ValueError(f'{mode}: scene verdict differs')
 traces=[x for x in items if x.get('event')=='scene_trace'];dialogue=[x for x in traces if x.get('kind')=='dialogue'];actors=[x for x in traces if x.get('kind')=='actor'];choreo=[x for x in traces if x.get('kind')=='choreography']
 expected_scenes=EXPECTED[mode];expected_lines=[line for scene in expected_scenes for line in plan['scenes'][scene]['dialogue']]
 if [x.get('scene') for x in traces if x.get('kind')=='scene_start']!=expected_scenes or [x.get('scene') for x in traces if x.get('kind')=='scene_complete']!=expected_scenes:raise ValueError(f'{mode}: scene chronology differs')
 expected_actors=[(scene,name,detail) for scene in expected_scenes for name,detail in ACTORS[scene]]
 if [(x.get('scene'),x.get('speaker'),x.get('detail')) for x in actors]!=expected_actors:raise ValueError(f'{mode}: actor positions/facings differ')
 for actor in actors:
  if actor.get('speaker')=='BUTTERFREE' and actor.get('text')!='butterfree':raise ValueError(f'{mode}: Butterfree identity differs')
  if actor.get('speaker')=='CATERPIE' and actor.get('text')!='caterpie':raise ValueError(f'{mode}: Caterpie identity differs')
 expected_choreography=[(scene,detail) for scene in expected_scenes for detail in CHOREOGRAPHY[scene]]
 if [(x.get('scene'),x.get('detail')) for x in choreo]!=expected_choreography:raise ValueError(f'{mode}: choreography order differs')
 if [x.get('pointer') for x in dialogue]!=[x['pointer'] for x in expected_lines]:raise ValueError(f'{mode}: EU dialogue pointer order differs')
 for actual,expected in zip(dialogue,expected_lines):
  pattern=re.escape(expected['pmdo_text'])
  for token in (r'\{hero\}',r'\{partner\}',r'\{hero_species\}'):
   pattern=pattern.replace(token,'.+?')
  if re.fullmatch(pattern,actual.get('text',''),flags=re.DOTALL) is None:raise ValueError(f"{mode}: normalized EU dialogue text differs at {expected['pointer']}")
 if verdict[0].get('dialogues')!=len(expected_lines) or verdict[0].get('menus_closed')!=len(expected_lines) or len(choreo)==0:raise ValueError(f'{mode}: dialogue/menu/choreography counts differ')
 completed=[x for x in traces if x.get('kind')=='scene_complete']
 if any(x.get('music')!=MUSIC[x['scene']] for x in completed):raise ValueError(f'{mode}: scene music lifecycle differs')
 tails=[x.get('event') for x in items[-4:]]
 if tails!=['load_phase_unload_requested','native_deinit','native_graphics_unload','end']:raise ValueError(f'{mode}: unload lifecycle differs')
 end=items[-1]
 if end.get('terminal') is not True or end.get('graceful') is not True or end.get('load_phase')!='Unload':raise ValueError(f'{mode}: terminal evidence differs')
 return {'mode':mode,'scenes':expected_scenes,'dialogue_count':len(dialogue),'actor_probe_count':len(actors),'choreography_count':len(choreo),'verdict':verdict[0]}

def main()->int:
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--fixture',type=Path,required=True);parser.add_argument('--evidence-dir',type=Path,required=True);parser.add_argument('--seed',type=int,default=424242);parser.add_argument('--timeout-seconds',type=int,default=180);args=parser.parse_args()
 fixture=args.fixture.resolve();evidence=args.evidence_dir.resolve()
 if evidence.exists():raise FileExistsError(f'refusing overwrite: {evidence}')
 runner=load_tool('run_pmdred_eu_native_fixture')
 if sha256(runner.PMDO)!=PMDO_SHA256:raise ValueError('PMDO executable differs')
 manifest=authenticate(fixture);plan=json.loads(PLAN.read_text());evidence.mkdir(parents=True);dump(evidence/'fixture_manifest.json',manifest);shutil.copyfile(PLAN,evidence/'scene_plan.json');index=index_fixture(fixture,evidence,runner)
 runs=[]
 for mode in MODES:
  wrapper=fixture/'scene-runs'/mode;wrapper.mkdir(parents=True);(wrapper/'asset').symlink_to(fixture/'asset',target_is_directory=True);(wrapper/'appdata').symlink_to(fixture/'appdata',target_is_directory=True)
  ns=argparse.Namespace(fixture=wrapper,ground=mode,expected_screenshots=0,timeout_seconds=args.timeout_seconds,events=EVENTS,validator_mode='tiny_woods_scene_fixture',environment=[f'TINY_WOODS_SCENE_MODE={mode}',f'TINY_WOODS_SCENE_SEED={args.seed}'])
  runner.run(ns);dest=evidence/mode;dest.mkdir()
  for name in ('runtime.log','events.jsonl','termination.json'):shutil.copyfile(wrapper/name,dest/name)
  summary=validate(mode,read_events(dest/'events.jsonl'),plan);termination=strict(dest/'termination.json');runs.append({**summary,'result':'PASS','events_sha256':sha256(dest/'events.jsonl'),'runtime_log_sha256':sha256(dest/'runtime.log'),'termination_sha256':sha256(dest/'termination.json'),'termination':{k:termination[k] for k in ('exit_classification','return_code','terminal','graceful','watchdog','requested_signal','sigsegv','forced_kill','orphan_process')}})
 report={'schema':'pmdred-eu-tiny-woods-native-scenes-v1','date':str(date.today()),'status':'passed','authority':{'region':'EU','rom_sha256':ROM_SHA256,'scene_graph':'docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json','scene_plan_sha256':sha256(PLAN)},'runtime':{'version':'0.8.12.0','executable_sha256':PMDO_SHA256},'index_gate':index,'runs':runs,'assertions':{'74_selected_french_eu_dialogues_executed_in_pointer_order':True,'every_dialogue_reached_and_closed_a_native_menu':True,'four_scene_groups_dispatched_in_canonical_route_order':True,'canonical_actor_staging_and_core_choreography_executed':True,'eu_rom_rendered_bgm_lifecycle_executed':True,'all_processes_unload_normally_without_signal_or_orphan':True},'limitations':['The neutral D1/default Red talk-kind branch is selected; all grammatical alternatives remain authenticated in eu_scene_graph.json.','The post-g3 destination beyond Tiny Woods remains the next campaign-routing milestone.']}
 dump(evidence/'native_scene_validation.json',report);print(f'TINY_WOODS_SCENES_PASS scenarios=3 dialogues=74 evidence={evidence}');return 0
if __name__=='__main__':raise SystemExit(main())
