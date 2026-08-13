#!/usr/bin/env python3
"""Compile a designed progression to valid native PMDO/RogueElements ZoneData."""
from __future__ import annotations
import copy,json,math,random,re
from pathlib import Path
from typing import Any
from .model import DesignBrief,FloorPlan
def load_json(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def walk(x):
 yield x
 if isinstance(x,dict):
  for v in x.values():yield from walk(v)
 elif isinstance(x,list):
  for v in x:yield from walk(v)
def typed(x,needle):return [v for v in walk(x) if isinstance(v,dict) and needle in v.get('$type','')]
def _name_text(zone):
 n=zone['Object'].get('Name',{});return ' '.join([str(n.get('DefaultText',''))]+list(n.get('LocalTexts',{}).values()))
def _species(zone):
 result=[]
 for v in walk(zone):
  if isinstance(v,dict):
   b=v.get('BaseForm')
   if isinstance(b,dict) and isinstance(b.get('Species'),str):result.append(b['Species'])
 return result
def derive_roster(repo:Path,brief:DesignBrief,size:int,seed:int):
 theme=set(brief.theme_tokens);ranked=[];all_species=[]
 for p in (repo/'Data/Zone').glob('*.json'):
  try:z=load_json(p)
  except:continue
  sp=list(dict.fromkeys(_species(z)));all_species+=sp;text=(p.stem+' '+_name_text(z)).casefold();score=sum(t in text for t in theme)
  if sp:ranked.append((score,p.stem,sp))
 pool=[]
 for _,_,sp in sorted(ranked,key=lambda x:(-x[0],x[1])):pool+=sp
 pool=list(dict.fromkeys(pool+sorted(set(all_species))));rng=random.Random(seed);head=pool[:max(size*3,size)];rng.shuffle(head);return head[:size]
def choose_reference(repo:Path,brief:DesignBrief,selection:dict,explicit:str|None=None):
 if explicit:
  p=repo/f'Data/Zone/{explicit}.json'
  if not p.exists():raise FileNotFoundError(p)
  return explicit,p
 candidates=[]
 for p in (repo/'Data/Zone').glob('*.json'):
  try:z=load_json(p);segments=z['Object']['Segments']
  except:continue
  if not any('RangeDictSegment' in s.get('$type','') and isinstance(s.get('Floors'),dict) and s['Floors'].get('nodes') for s in segments):continue
  text=(p.stem+' '+_name_text(z)).casefold();score=sum(t in text for t in brief.theme_tokens)*3
  texture=selection.get('texture_values') or [];zone_textures={str(v.get(k,'')) for v in walk(z) if isinstance(v,dict) and 'GroundTileset' in v for k in ('GroundTileset','BlockTileset','WaterTileset')};score+=sum(6 for t in texture if t and t in zone_textures)
  candidates.append((score,p.stem,p))
 if not candidates:raise ValueError('No native RangeDictSegment reference found')
 _,name,path=max(candidates,key=lambda x:(x[0],-len(x[1]),x[1]));return name,path
def _floor_generators(zone):
 for s in zone['Object']['Segments']:
  if 'RangeDictSegment' in s.get('$type','') and isinstance(s.get('Floors'),dict):
   nodes=s['Floors'].get('nodes',[])
   if nodes:return s,[copy.deepcopy(n['Item']) for n in nodes]
 raise ValueError('Reference has no procedural floor generators')
def _tune_floor(gen:dict,plan:FloorPlan,texture:list[str]|None):
 avgw=sum(r.width for r in plan.rooms)/max(1,len(plan.rooms));avgh=sum(r.height for r in plan.rooms)/max(1,len(plan.rooms));loops=max(0,len(plan.edges)-len(plan.rooms)+1);density=plan.quality.get('metrics',{}).get('walkable_density',.35)
 for step in typed(gen,'MapDataStep'):
  step['TimeLimit']=1800;step['ClampCamera']=False
 for step in typed(gen,'InitGridPlanStep'):
  cells=max(3,min(7,round(math.sqrt(max(4,len(plan.rooms))))));step['CellX']=cells;step['CellY']=max(3,min(7,round(cells*plan.height/plan.width)));step['CellWidth']=max(6,min(14,round(avgw)));step['CellHeight']=max(6,min(14,round(avgh)));step['CellWall']=max(2,min(6,round((avgw+avgh)/5)))
 for step in typed(gen,'GridPathBranch'):
  step['RoomRatio']={'Min':max(45,round(density*180)),'Max':min(100,max(55,round(density*210)))};step['BranchRatio']={'Min':35+min(35,loops*7),'Max':75+min(25,loops*6)};step['NoForcedBranches']=plan.archetype=='linear'
 for step in typed(gen,'RoomGen'):
  if isinstance(step.get('Width'),dict):step['Width']={'Min':max(4,round(avgw*.65)),'Max':max(7,round(avgw*1.3))}
  if isinstance(step.get('Height'),dict):step['Height']={'Min':max(4,round(avgh*.65)),'Max':max(7,round(avgh*1.3))}
 for step in typed(gen,'RoomGenAngledHall'):
  step['HallTurnBias']=45 if plan.archetype=='labyrinth' else 65
 for step in typed(gen,'AddTunnelStep'):
  step['TurnLength']={'Min':2,'Max':5};step['MaxLength']={'Min':3,'Max':8};step['AllowDeadEnd']=plan.archetype in ('labyrinth','branching');step['Halls']={'Min':max(2,loops+2),'Max':max(5,loops+6)}
 for step in typed(gen,'FloorStairsStep'):
  step['MinDistance']=max(8,min(40,round(plan.quality.get('metrics',{}).get('exit_distance',20)*.55)))
 if texture and len(texture)>=3:
  for step in typed(gen,'MapTextureStep'):step['GroundTileset'],step['BlockTileset'],step['WaterTileset']=texture[:3]
 # A final arena is intentionally spacious and low-noise.
 if plan.special in ('boss','mini_boss'):
  for step in typed(gen,'InitGridPlanStep'):step['CellX']=3;step['CellY']=3;step['CellWidth']=14 if plan.special=='boss' else 11;step['CellHeight']=12 if plan.special=='boss' else 10
  for step in typed(gen,'GridPathBranch'):step['RoomRatio']={'Min':82,'Max':101};step['BranchRatio']={'Min':35,'Max':61}
 return gen
def _replace_roster(segment,roster,brief):
 steps=typed(segment,'TeamSpawnZoneStep')
 if not steps:return
 total=brief.floors;level={'facile':10,'normal':18,'difficile':26,'extrême':34}.get(brief.difficulty,18)
 for step in steps:
  if not step.get('Spawns'):continue
  proto=copy.deepcopy(step['Spawns'][0]);rows=[]
  for i,s in enumerate(roster):
   row=copy.deepcopy(proto);mob=row['Spawn']['Spawn'];mob['BaseForm']={'Species':s,'Form':0,'Skin':'','Gender':-1};mob['Level']={'Min':level+i%5,'Max':level+3+i%5};mob['SpecifiedSkills']=[];mob['Intrinsic']='';mob['Tactic']=['wander_dumb','wander_dumb_two_range','wander_normal'][i%3];mob['SpawnConditions']=[];row['Rate']=10 if i<len(roster)*.72 else 4;row['Range']={'Min':0,'Max':total};rows.append(row)
  step['Spawns']=rows;step['TeamSizes']=[{'Spawn':1,'Rate':12,'Range':{'Min':0,'Max':total}},{'Spawn':2,'Rate':9,'Range':{'Min':0,'Max':total}},{'Spawn':3,'Rate':4,'Range':{'Min':total//3,'Max':total}}]
 for x in typed(segment,'MobSpawnSettingsStep'):
  x['MaxFoes']=8+round(brief.danger_bias*7);x['RespawnTime']=max(18,round(55-brief.danger_bias*30))
  if isinstance(x.get('Respawn'),dict):x['Respawn']['MaxFoes']=x['MaxFoes'];x['Respawn']['RespawnTime']=x['RespawnTime']
def compile_zone(repo:Path,brief:DesignBrief,plans:list[FloorPlan],selection:dict,output:Path,reference:str|None=None,roster_size:int=24):
 ref_name,ref_path=choose_reference(repo,brief,selection,reference);zone=load_json(ref_path);segment,generators=_floor_generators(zone);nodes=[]
 for i,plan in enumerate(plans):nodes.append({'Item':_tune_floor(copy.deepcopy(generators[i%len(generators)]),plan,selection.get('texture_values')),'Range':{'Min':i,'Max':i+1}})
 segment=copy.deepcopy(segment);segment['Floors']={'nodes':nodes};segment['Comment']=f'{brief.name} — conçu par Smart Dungeon Designer, seed {brief.seed}';roster=derive_roster(repo,brief,roster_size,brief.seed);_replace_roster(segment,roster,brief);o=zone['Object'];o['Name']={'DefaultText':brief.name,'LocalTexts':{'fr':brief.name}};o['Released']=True;o['Comment']=f'Génération intelligente reproductible; référence PMDO {ref_name}; seed {brief.seed}.';o['Segments']=[segment];o['GroundMaps']=[];o['Level']={'facile':10,'normal':18,'difficile':26,'extrême':34}.get(brief.difficulty,18);o['LevelCap']=False;o['TeamSize']=4;o['BagSize']=32
 output.parent.mkdir(parents=True,exist_ok=True);output.write_text('\ufeff'+json.dumps(zone,ensure_ascii=False,indent=1),encoding='utf-8');return {'reference_zone':ref_name,'zone_file':str(output),'floor_count':len(plans),'roster':roster,'boss_contract':next(({'floor':p.floor,'species':roster[-1],'arena_position':p.points_of_interest[0]['position'] if p.points_of_interest else None,'integration':'generated_arena_plus_story_battle_hook'} for p in plans if p.special=='boss'),None),'mini_boss_contracts':[{'floor':p.floor,'species':roster[-2-(i%max(1,len(roster)-2))],'arena_position':p.points_of_interest[0]['position'] if p.points_of_interest else None,'integration':'generated_arena_plus_battle_hook'} for i,p in enumerate(x for x in plans if x.special=='mini_boss')],'relay_contracts':[{'floor':p.floor,'position':p.points_of_interest[0]['position'] if p.points_of_interest else None,'integration':'refuge_contract'} for p in plans if p.special=='relay']}
