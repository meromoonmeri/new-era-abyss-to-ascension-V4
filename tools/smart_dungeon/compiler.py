#!/usr/bin/env python3
"""Compile a designed progression to valid native PMDO/RogueElements ZoneData."""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import copy,json,math,random,re
from pathlib import Path
from typing import Any
from .model import BossEncounterPlan,DesignBrief,FloorPlan,RelayPlan
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
 family=plan.identity.get('composition_family',plan.archetype)
 avgw=sum(r.width for r in plan.rooms)/max(1,len(plan.rooms));avgh=sum(r.height for r in plan.rooms)/max(1,len(plan.rooms));loops=max(0,len(plan.edges)-len(plan.rooms)+1);density=plan.quality.get('metrics',{}).get('walkable_density',.35)
 family_rules={
  'open_field':{'cells':4,'room':88,'branch':38,'turn':72,'dead':False,'scale':1.18},
  'island_clusters':{'cells':5,'room':72,'branch':48,'turn':58,'dead':True,'scale':1.05},
  'central_landmark':{'cells':5,'room':78,'branch':55,'turn':62,'dead':False,'scale':1.12},
  'protected_core':{'cells':5,'room':76,'branch':64,'turn':58,'dead':False,'scale':1.10},
  'circular_progression':{'cells':6,'room':68,'branch':78,'turn':48,'dead':False,'scale':.95},
  'dominant_loop':{'cells':6,'room':64,'branch':82,'turn':44,'dead':False,'scale':.92},
  'branching_pockets':{'cells':6,'room':62,'branch':72,'turn':42,'dead':True,'scale':.88},
  'asymmetric_gradient':{'cells':6,'room':66,'branch':63,'turn':38,'dead':True,'scale':1.0},
  'chamber_sequence':{'cells':6,'room':58,'branch':30,'turn':70,'dead':False,'scale':.76},
  'corridor_spine':{'cells':6,'room':56,'branch':28,'turn':78,'dead':True,'scale':.82},
  'relay_haven':{'cells':4,'room':76,'branch':42,'turn':68,'dead':False,'scale':1.04},
  'boss_stage':{'cells':3,'room':88,'branch':38,'turn':72,'dead':False,'scale':1.30},
  'mini_boss_stage':{'cells':3,'room':84,'branch':42,'turn':68,'dead':False,'scale':1.18},
 }
 rule=family_rules.get(family,{'cells':max(3,min(7,round(math.sqrt(max(4,len(plan.rooms)))))),'room':round(density*190),'branch':52,'turn':55,'dead':plan.archetype in ('labyrinth','branching'),'scale':1})
 for step in typed(gen,'MapDataStep'):
  step['TimeLimit']=1800;step['ClampCamera']=False
 for step in typed(gen,'InitGridPlanStep'):
  cells=rule['cells'];step['CellX']=cells;step['CellY']=max(3,min(7,round(cells*plan.height/plan.width)));step['CellWidth']=max(6,min(16,round(avgw*rule['scale'])));step['CellHeight']=max(6,min(15,round(avgh*rule['scale'])));step['CellWall']=max(2,min(6,round((avgw+avgh)/5)))
 for step in typed(gen,'GridPathBranch'):
  room=max(42,min(94,rule['room']));branch=max(20,min(90,rule['branch']+min(12,loops*3)));step['RoomRatio']={'Min':room,'Max':min(101,room+14)};step['BranchRatio']={'Min':branch,'Max':min(101,branch+22)};step['NoForcedBranches']=family in ('corridor_spine','chamber_sequence')
 for step in typed(gen,'RoomGen'):
  if isinstance(step.get('Width'),dict):step['Width']={'Min':max(4,round(avgw*.58*rule['scale'])),'Max':max(7,round(avgw*1.28*rule['scale']))}
  if isinstance(step.get('Height'),dict):step['Height']={'Min':max(4,round(avgh*.58*rule['scale'])),'Max':max(7,round(avgh*1.28*rule['scale']))}
 for step in typed(gen,'RoomGenAngledHall'):step['HallTurnBias']=rule['turn']
 for step in typed(gen,'AddTunnelStep'):
  step['TurnLength']={'Min':2,'Max':5};step['MaxLength']={'Min':3,'Max':9 if rule['dead'] else 7};step['AllowDeadEnd']=rule['dead'];step['Halls']={'Min':max(2,loops+2),'Max':max(5,loops+6)}
 for step in typed(gen,'FloorStairsStep'):step['MinDistance']=max(8,min(40,round(plan.quality.get('metrics',{}).get('exit_distance',20)*.55)))
 if texture and len(texture)>=3:
  for step in typed(gen,'MapTextureStep'):step['GroundTileset'],step['BlockTileset'],step['WaterTileset']=texture[:3]
 return gen
def _add_neutral_encounter(repo,gen,floor_rule):
 neutral=floor_rule.get('neutral_encounter',{}) if floor_rule else {}
 if not neutral.get('present_in_control_realization') or not neutral.get('table'):return gen
 source=load_json(repo/'Data/Zone/desert_oublies.json')['Object']['Segments'][0]['Floors'][2]
 prototype=next(copy.deepcopy(step) for step in source.get('GenSteps',[]) if typed(step,'NpcDialogueBattleEvent'))
 species=neutral['table'][0]['species'];level=next((row['level'] for row in floor_rule.get('enemy_table',[]) if row['species']==species),floor_rule.get('enemy_table',[{'level':[15,17]}])[0]['level'])
 for value in walk(prototype):
  if not isinstance(value,dict):continue
  if isinstance(value.get('BaseForm'),dict) and value['BaseForm'].get('Species'):value['BaseForm']={'Species':species,'Form':0,'Skin':'normal','Gender':-1};value['Level']={'Min':level[0],'Max':level[1]};value['Tactic']='wait_only'
  if 'MobSpawnInteractable' in value.get('$type',''):value['CheckEvents']=[]
 prototype['Value']['Ally']=True;gen.setdefault('GenSteps',[]).append(prototype);return gen

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
def _apply_stage_roster(segment,stage,brief,local_floor_count,floor_rules=None):
 enemies=stage.get('enemy_table',[]) if stage else []
 if not enemies:return
 for step in typed(segment,'TeamSpawnZoneStep'):
  if not step.get('Spawns'):continue
  proto=copy.deepcopy(step['Spawns'][0]);rows=[];tables=floor_rules or [{'enemy_table':enemies} for _ in range(local_floor_count)]
  for local_floor,floor_rule in enumerate(tables):
   for index,enemy in enumerate(floor_rule.get('enemy_table',enemies)):
    row=copy.deepcopy(proto);mob=row['Spawn']['Spawn'];mob['BaseForm']={'Species':enemy['species'],'Form':0,'Skin':'normal','Gender':-1};mob['Level']={'Min':enemy['level'][0],'Max':enemy['level'][1]};mob['SpecifiedSkills']=[];mob['Intrinsic']='';mob['Tactic']=enemy.get('native_tactic') or ['wander_dumb','wander_dumb_two_range','wander_normal'][index%3];mob['SpawnConditions']=[];row['Rate']=enemy['weight'];row['Range']={'Min':local_floor,'Max':local_floor+1};rows.append(row)
  step['Spawns']=rows;step['TeamSizes']=[{'Spawn':1,'Rate':12,'Range':{'Min':0,'Max':local_floor_count}},{'Spawn':2,'Rate':7,'Range':{'Min':max(0,local_floor_count//3),'Max':local_floor_count}},{'Spawn':3,'Rate':3,'Range':{'Min':max(0,2*local_floor_count//3),'Max':local_floor_count}}]
 for settings in typed(segment,'MobSpawnSettingsStep'):
  start=stage.get('rules',{}).get('starting_enemies',[2,4]) if stage else [2,4];settings['MaxFoes']=max(6,start[1]*3);settings['RespawnTime']=max(18,round(55-brief.danger_bias*30))
  if isinstance(settings.get('Respawn'),dict):settings['Respawn']['MaxFoes']=settings['MaxFoes'];settings['Respawn']['RespawnTime']=settings['RespawnTime']

def _ensure_shop_step(repo,segment):
 if typed(segment,'ShopStep'):return
 source=load_json(repo/'Data/Zone/vast_steppe.json')['Object']['Segments'][0]
 prototype=next(copy.deepcopy(step) for step in source.get('ZoneSteps',[]) if typed(step,'ShopStep'))
 segment.setdefault('ZoneSteps',[]).append(prototype)

def _configure_shop_floors(segment,floor_rules):
 zone_steps=segment.get('ZoneSteps',[]);shop_indices=[index for index,step in enumerate(zone_steps) if typed(step,'ShopStep')]
 if not shop_indices:return
 prototype=copy.deepcopy(zone_steps[shop_indices[0]]);replacement=[]
 for local_floor,rule in enumerate(floor_rules):
  shop=rule.get('shop',{})
  if not shop.get('eligible'):continue
  step=copy.deepcopy(prototype);chance=max(0,min(100,round(shop.get('chance_percent',0))));step['SpreadPlan']={'$type':'RogueEssence.LevelGen.SpreadPlanChance, RogueEssence','Chance':chance,'FloorRange':{'Min':local_floor,'Max':local_floor+1}}
  for spawn in step.get('Spawns',[]):spawn['Range']={'Min':local_floor,'Max':local_floor+1}
  replacement.append(step)
 first=shop_indices[0];segment['ZoneSteps']=[step for index,step in enumerate(zone_steps) if index not in shop_indices];segment['ZoneSteps'][first:first]=replacement

def _restrict_content(repo,segment,stage,local_floor_count):
 if not stage:return
 allowed={row['item_id'] for row in stage.get('loot',{}).get('ground',[])}
 shop_allowed={row['item_id'] for row in stage.get('kecleon',{}).get('assortment',[])}
 for value in walk(segment):
  if not isinstance(value,dict):continue
  typ=value.get('$type','')
  if 'ShopStep' in typ and value.get('Items'):
   by_id={row.get('Spawn',{}).get('Value'):row for row in value['Items']};prototype=copy.deepcopy(value['Items'][0]);compiled=[]
   for index,item_id in enumerate(sorted(shop_allowed)):
    if item_id in by_id:row=copy.deepcopy(by_id[item_id])
    else:
     row=copy.deepcopy(prototype);row['Spawn']['Value']=item_id;item_path=repo/'Data/Item'/f'{item_id}.json'
     try:row['Spawn']['Price']=load_json(item_path)['Object'].get('Price',100)
     except:row['Spawn']['Price']=100
     row['Rate']=max(2,12-index//4)
    compiled.append(row)
   value['Items']=compiled or value['Items'][:min(8,len(value['Items']))]
  if isinstance(value.get('Spawn'),dict) and value['Spawn'].get('Value') and 'Rate' in value:
   item_id=value['Spawn']['Value']
   if allowed and item_id not in allowed and item_id not in shop_allowed:value['Rate']=0

def _mapped_boss_segment(repo,encounter):
 source=load_json(repo/'Data/Zone/vast_steppe.json')
 segment=next(copy.deepcopy(row) for row in source['Object']['Segments'] if 'LayeredSegment' in row.get('$type','') and typed(row,'MappedRoomStep'))
 for step in typed(segment,'MappedRoomStep'):step['MapID']=encounter.arena_id
 segment['Comment']=f'Arène finale {encounter.arena_id}; aucun escalier générique; flow scripté Ground → combat → Ground.'
 for name in typed(segment,'FloorNameDropZoneStep'):name['Name']={'DefaultText':encounter.arena_id.replace('_',' ').title(),'LocalTexts':{'fr':'Arène finale'}}
 return segment

def compile_zone(repo:Path,brief:DesignBrief,plans:list[FloorPlan],selection:dict,output:Path,reference:str|None=None,roster_size:int=24,relays:list[RelayPlan]|None=None,profile:dict|None=None,boss_encounter:BossEncounterPlan|None=None):
 relays=relays or [];ref_name,ref_path=choose_reference(repo,brief,selection,reference);zone=load_json(ref_path);base_segment,generators=_floor_generators(zone);fallback_roster=derive_roster(repo,brief,roster_size,brief.seed)
 boundaries=[relay.after_floor for relay in sorted(relays,key=lambda item:item.order)]+[len(plans)];segments=[];segment_contracts=[];start=0
 stages=(profile or {}).get('segments',[]);floor_rules={row['floor']:row for row in (profile or {}).get('floor_rules',[])}
 for segment_index,end in enumerate(boundaries):
  segment_plans=plans[start:end];stage=stages[segment_index] if segment_index<len(stages) else None;texture=stage.get('biome_continuity',{}).get('texture_bundle') if stage else selection.get('texture_values');nodes=[]
  for local_index,plan in enumerate(segment_plans):
   global_index=start+local_index;generator=_tune_floor(copy.deepcopy(generators[global_index%len(generators)]),plan,texture);generator=_add_neutral_encounter(repo,generator,floor_rules.get(plan.floor));nodes.append({'Item':generator,'Range':{'Min':local_index,'Max':local_index+1}})
  segment=copy.deepcopy(base_segment);segment['Floors']={'nodes':nodes};segment['Comment']=f'{brief.name} — {stage.get("stage_name") if stage else "partie"} {segment_index+1}/{len(boundaries)}, étages globaux {start+1}-{end}, seed {brief.seed}'
  if stage:_apply_stage_roster(segment,stage,brief,len(segment_plans),[floor_rules.get(plan.floor) for plan in segment_plans]);_ensure_shop_step(repo,segment);_configure_shop_floors(segment,[floor_rules.get(plan.floor) for plan in segment_plans]);_restrict_content(repo,segment,stage,len(segment_plans))
  else:_replace_roster(segment,fallback_roster,brief)
  segments.append(segment);segment_contracts.append({'segment':segment_index,'global_floor_range':[start+1,end],'floor_count':len(segment_plans),'stage_name':stage.get('stage_name') if stage else None,'texture_bundle':texture,'enemy_species':[row['species'] for row in stage.get('enemy_table',[])] if stage else fallback_roster,'loot_items':[row['item_id'] for row in stage.get('loot',{}).get('ground',[])] if stage else [],'shop_chance_percent':stage.get('kecleon',{}).get('chance_percent_per_eligible_floor') if stage else None,'entry':{'map_id':0,'entry_point':0},'relay_before':relays[segment_index-1].relay_id if segment_index>0 else None,'relay_after':relays[segment_index].relay_id if segment_index<len(relays) else None});start=end
 procedural_segment_count=len(segments)
 if boss_encounter:
  boss_encounter.battle_segment=procedural_segment_count;segments.append(_mapped_boss_segment(repo,boss_encounter))
 obj=zone['Object'];obj['Name']={'DefaultText':brief.name,'LocalTexts':{'fr':brief.name}};obj['Released']=True;obj['Comment']=f'Parcours Smart Dungeon complet; {procedural_segment_count} segment(s) procéduraux, {len(relays)} relais Ground, arène finale scriptée={bool(boss_encounter)}; référence PMDO {ref_name}; seed {brief.seed}.';obj['Segments']=segments;obj['GroundMaps']=[relay.relay_id for relay in relays]+([boss_encounter.arena_id] if boss_encounter else []);obj['Level']={'facile':10,'normal':18,'difficile':26,'extrême':34}.get(brief.difficulty,18);obj['LevelCap']=False;obj['TeamSize']=4;obj['BagSize']=32
 output.parent.mkdir(parents=True,exist_ok=True);output.write_text('\ufeff'+json.dumps(zone,ensure_ascii=False,indent=1),encoding='utf-8')
 roster=list(dict.fromkeys(row['species'] for stage in stages for row in stage.get('enemy_table',[]))) or fallback_roster
 minis=[{'floor':plan.floor,'species':roster[-2-(index%max(1,len(roster)-2))],'position':next((point['position'] for point in plan.points_of_interest if point.get('kind')=='mini_boss'),None),'integration':'generated_stage_plus_battle_hook'} for index,plan in enumerate(item for item in plans if item.special=='mini_boss')]
 relay_contracts=[{'relay_id':relay.relay_id,'after_floor':relay.after_floor,'previous_segment':relay.previous_segment,'next_segment':relay.next_segment,'ground_file':relay.ground_file,'script_file':relay.script_file,'kangaskhan_rock':True,'two_routes':{'north':relay.north_route,'south':relay.south_route},'services':relay.services,'validation':relay.validation,'integration':'native_ground_midpoint_between_range_segments'} for relay in relays]
 boss_contract=boss_encounter.to_dict() if boss_encounter else None
 return {'reference_zone':ref_name,'zone_file':str(output),'floor_count':len(plans),'procedural_segment_count':procedural_segment_count,'segment_count':len(segments),'boss_segment':boss_encounter.battle_segment if boss_encounter else None,'segment_contracts':segment_contracts,'ground_maps':obj['GroundMaps'],'roster':roster,'boss_contract':boss_contract,'mini_boss_contracts':minis,'relay_contracts':relay_contracts,'content_profile_id':(profile or {}).get('profile_id'),'floor_design_contracts':[{'floor':plan.floor,'composition_family':plan.identity.get('composition_family'),'signature':plan.identity.get('signature'),'spectacle':plan.identity.get('spectacle'),'structural_score':plan.quality.get('structural_score'),'visual_score':plan.quality.get('visual_score')} for plan in plans]}
