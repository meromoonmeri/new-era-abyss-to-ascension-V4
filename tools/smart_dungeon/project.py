#!/usr/bin/env python3
"""Project lifecycle: generation, locks, incremental regeneration and validation."""
from __future__ import annotations
import json,random,shutil
from pathlib import Path
from statistics import mean
from typing import Any
from .assets import analyze_library
from .compiler import compile_zone
from .intent import parse_intent
from .layout import progression,select_best,stable_seed,_decorate
from .model import DesignBrief,FloorPlan,Room,DungeonPlan
from .quality import evaluate
from .visual import contact_svg,select_visual_language,special_rooms_svg,svg_preview
def write(path,obj):path.parent.mkdir(parents=True,exist_ok=True);path.write_text(json.dumps(obj,ensure_ascii=False,indent=2),encoding='utf-8')
def read(path,default=None):return json.loads(path.read_text(encoding='utf-8-sig')) if path.exists() else default
def brief_from(d):return DesignBrief(**d)
def floor_from(d):
 d=dict(d);d['rooms']=[Room(**x) for x in d['rooms']];return FloorPlan(**d)
def _asset_roles(selection):return selection.get('roles',{})
def generate_project(repo:Path,project:Path,name:str,intent:str,floors:int|None=None,difficulty:str|None=None,boss:bool|None=None,mini_bosses:int|None=None,relays:int|None=None,seed:int|None=None,reference:str|None=None,variants:int=6,max_assets:int=0):
 repo=repo.resolve();project=project.resolve();project.mkdir(parents=True,exist_ok=True);brief=parse_intent(name,intent,floors,difficulty,boss,mini_bosses,relays,seed);overrides=read(project/'asset_overrides.json',{'assets':{},'visual_language':{}});locks=read(project/'locks.json',{'floors':{},'regions':[]});catalog_path=project/'asset_catalog.json';catalog=analyze_library(repo,catalog_path,project/'asset_overrides.json',max_assets) if not catalog_path.exists() else read(catalog_path);selection=select_visual_language(catalog,brief,overrides);rows=progression(brief);plans=[];comparisons=[]
 for row in rows:
  plan,variants_report=select_best(brief,row,brief.seed,_asset_roles(selection),variants=variants,locks=locks);plans.append(plan);comparisons.append({'floor':row['floor'],'candidates':variants_report,'selected_seed':plan.seed,'selected_score':plan.quality['score']});write(project/f'plans/floor_{row["floor"]:03d}.json',plan.to_dict());svg_preview(plan,project/f'previews/floor_{row["floor"]:03d}.svg')
 contact_svg(plans,project/'previews/contact_sheet.svg');special_rooms_svg(plans,project/'previews/special_rooms.svg');quality={'accepted_floor_count':sum(p.quality['accepted'] for p in plans),'floor_count':len(plans),'mean_score':round(mean(p.quality['score'] for p in plans),3),'minimum_score':round(min(p.quality['score'] for p in plans),3),'violations':{str(p.floor):p.quality['violations'] for p in plans if p.quality['violations']},'candidate_comparisons':comparisons};compiler=compile_zone(repo,brief,plans,selection,project/f'zone/{brief.slug}.json',reference);compiler['zone_file']=Path(compiler['zone_file']).relative_to(project).as_posix();plan=DungeonPlan('1.0.0',brief,selection['cluster_id'],selection,rows,plans,quality,compiler);write(project/'brief.json',brief.to_dict());write(project/'progression.json',rows);write(project/'quality_report.json',quality);write(project/'project.json',plan.to_dict());write(project/'generation_manifest.json',{'schema_version':'1.0.0','result':'SMART_DUNGEON_GENERATION_PASS','name':brief.name,'slug':brief.slug,'seed':brief.seed,'floor_count':brief.floors,'mean_quality_score':quality['mean_score'],'minimum_quality_score':quality['minimum_score'],'asset_catalog':catalog_path.name,'visual_language':selection,'compiler':compiler,'locks_file':'locks.json','overrides_file':'asset_overrides.json','reproducible':True});
 if not (project/'locks.json').exists():write(project/'locks.json',{'floors':{},'regions':[],'notes':'Set floors.<n>.locked=true or add region/POI locks.'})
 if not (project/'asset_overrides.json').exists():write(project/'asset_overrides.json',{'assets':{},'visual_language':{},'notes':'Override inferred role/tags/rarity or lock the visual language.'})
 return plan
def regenerate(repo:Path,project:Path,scope:str='all',seed:int|None=None,force_unlock:bool=False,variants:int=6):
 repo=repo.resolve();project=project.resolve();old=read(project/'project.json');
 if not old:raise FileNotFoundError(project/'project.json')
 brief=brief_from(old['brief']);brief.seed=seed if seed is not None else brief.seed;catalog=read(project/'asset_catalog.json');overrides=read(project/'asset_overrides.json',{});selection=select_visual_language(catalog,brief,overrides);locks=read(project/'locks.json',{'floors':{}});old_plans={x['floor']:floor_from(x) for x in old['floors']};rows=progression(brief);plans=[];changes=[]
 target_kind,target_floor,target_room='all',None,None
 if scope!='all':
  parts=scope.split(':');target_kind=parts[0];target_floor=int(parts[1]) if len(parts)>1 else None;target_room=int(parts[2]) if len(parts)>2 else None
 for row in rows:
  f=row['floor'];locked=bool(locks.get('floors',{}).get(str(f),{}).get('locked'))
  if locked and not force_unlock:plans.append(old_plans[f]);continue
  affected=scope=='all' or f==target_floor
  if not affected:plans.append(old_plans[f]);continue
  if target_kind=='decor' and f in old_plans:
   plan=copy_floor(old_plans[f]);_decorate(plan,random.Random(stable_seed(brief.seed,'decor',f)),_asset_roles(selection),row['decoration_density']);plan.quality=evaluate(plan);changes.append({'floor':f,'scope':'decoration'})
  elif target_kind=='room' and f in old_plans and target_room is not None:
   plan=copy_floor(old_plans[f]);room=next((r for r in plan.rooms if r.room_id==target_room),None)
   room_lock=bool(locks.get('floors',{}).get(str(f),{}).get('rooms',{}).get(str(target_room),{}).get('locked'))
   if room and not room.locked and (force_unlock or not room_lock):
    rng=random.Random(stable_seed(brief.seed,'room',f,target_room))
    for y in range(room.y,room.y+room.height):
     for x in range(room.x,room.x+room.width):
      if plan.get(x,y)=='room':plan.set(x,y,'wall')
    room.cells=[[1 if rng.random()>.18 else 0 for _ in range(room.width)] for _ in range(room.height)]
    for ry,line in enumerate(room.cells):
     for rx,value in enumerate(line):
      if value:plan.set(room.x+rx,room.y+ry,'room')
    changes.append({'floor':f,'scope':'room','room_id':target_room})
   plan.quality=evaluate(plan)
  else:plan,_=select_best(brief,row,stable_seed(brief.seed,'regen',scope),_asset_roles(selection),variants=variants,locks=locks);changes.append({'floor':f,'scope':'structure'})
  plans.append(plan)
 for p in plans:write(project/f'plans/floor_{p.floor:03d}.json',p.to_dict());svg_preview(p,project/f'previews/floor_{p.floor:03d}.svg')
 contact_svg(plans,project/'previews/contact_sheet.svg');special_rooms_svg(plans,project/'previews/special_rooms.svg');quality={'accepted_floor_count':sum(p.quality['accepted'] for p in plans),'floor_count':len(plans),'mean_score':round(mean(p.quality['score'] for p in plans),3),'minimum_score':round(min(p.quality['score'] for p in plans),3),'violations':{str(p.floor):p.quality['violations'] for p in plans if p.quality['violations']},'regeneration_changes':changes};compiler=compile_zone(repo,brief,plans,selection,project/f'zone/{brief.slug}.json',old.get('compiler',{}).get('reference_zone'));compiler['zone_file']=Path(compiler['zone_file']).relative_to(project).as_posix();plan=DungeonPlan('1.0.0',brief,selection['cluster_id'],selection,rows,plans,quality,compiler);write(project/'quality_report.json',quality);write(project/'project.json',plan.to_dict());write(project/'generation_manifest.json',{'schema_version':'1.0.0','result':'SMART_DUNGEON_REGENERATION_PASS','seed':brief.seed,'scope':scope,'changes':changes,'mean_quality_score':quality['mean_score'],'locked_floor_count':sum(bool(x.get('locked')) for x in locks.get('floors',{}).values()),'reproducible':True});return plan
def copy_floor(plan):return floor_from(plan.to_dict())
def validate_project(project:Path):
 p=read(project/'project.json');errors=[];scores=[]
 if not p:return {'result':'FAIL','errors':['project.json missing']}
 for row in p['floors']:
  plan=floor_from(row);q=evaluate(plan);scores.append(q['score'])
  if not q['accepted']:errors.append({'floor':plan.floor,'violations':q['violations']})
 zone=project/p['compiler']['zone_file'];
 try:z=read(zone);segments=z['Object']['Segments'];stairs=sum(1 for x in _walk(segments) if isinstance(x,dict) and 'FloorStairsStep' in x.get('$type',''))
 except Exception as e:errors.append({'zone':str(e)});stairs=0
 return {'result':'SMART_DUNGEON_VALIDATION_PASS' if not errors and stairs>=len(p['floors']) else 'SMART_DUNGEON_VALIDATION_FAIL','floor_count':len(p['floors']),'mean_score':round(mean(scores),3),'minimum_score':min(scores),'stairs_step_count':stairs,'errors':errors}
def _walk(x):
 yield x
 if isinstance(x,dict):
  for v in x.values():yield from _walk(v)
 elif isinstance(x,list):
  for v in x:yield from _walk(v)
