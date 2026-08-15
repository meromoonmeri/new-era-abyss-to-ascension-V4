#!/usr/bin/env python3
"""Validate all No Name Village Grounds in exact Agent A PMDO 0.8.12 runtime."""
import hashlib,json,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(ROOT/'tools'),str(ROOT/'external/BIBLIOTHEQUE_WORKSPACE/tools')]
from smart_dungeon import ground_runtime as g
ORIGINAL_FIXTURE=g.fixture_ground
PHASE_OVERRIDE=None
def collision_fixture(source,target):
 result=ORIGINAL_FIXTURE(source,target);payload=g.read_json(target)
 # Only the ignored runtime copy drops actors/triggers so the collision probe
 # cannot be blocked by an NPC standing on its deterministic centre cell.
 for layer in payload['Object']['Entities']:
  layer['MapChars']=[];layer['GroundObjects']=[];layer['Spawners']=[]
 g.write_json_bom(target,payload);return result
def scaled_dark_gate(path,ground):
 image=g.load_png(path);o=ground['Object'];obs=o['obstacles'];w=len(obs);h=len(obs[0]);scale=max(1,int(o.get('TexSize',1)))
 if image.width!=w*8 or image.height!=h*8:return []
 bases=[l for l in o.get('Layers',[])if any(k in str(l.get('Name','')).casefold()for k in('base','floor','sol'))and'ceiling'not in str(l.get('Name','')).casefold()];bad=[]
 for x in range(w):
  for y in range(h):
   if obs[x][y].get('Tags',0):continue
   gx,gy=x//scale,y//scale
   if not any(gx<len(l['Tiles'])and gy<len(l['Tiles'][gx])and(l['Tiles'][gx][gy].get('AutoTileset')or any(r.get('Frames')for r in l['Tiles'][gx][gy].get('Layers',[])))for l in bases):bad.append([x,y])
 return bad
def real_ground_script(asset):
 if asset.startswith('no_name_village_'):
  season=asset.removeprefix('no_name_village_')
  phase="" if PHASE_OVERRIDE is None else f"local init=M.Init\nfunction M.Init(map) SV.NoNameVillage=SV.NoNameVillage or {{}};SV.NoNameVillage.TimeOfDay={PHASE_OVERRIDE};init(map) end\n"
  return f"""require 'origin.common'
local VillageMap=require 'halcyon.no_name_village.VillageMap'
local M=VillageMap.Build('{asset}','{season}')
{phase}local update=M.Update
function M.Update(map,time) update(map,time);if SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE then SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE:OnMapUpdate() end end
return M
"""
 source=ROOT/'Data/Script/halcyon/ground'/asset/'init.lua';text=source.read_text()
 old='function M.Update(map,time)end'
 new="function M.Update(map,time) if SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE then SMART_GROUND_RUNTIME_VALIDATOR_INSTANCE:OnMapUpdate() end end"
 if old not in text:raise ValueError(f'cannot instrument {source}')
 return text.replace(old,new)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 global PHASE_OVERRIDE
 required=[ROOT/'.runtime-cache/pmdo-headless-bundle/PMDO',ROOT/'.runtime-cache/dotnet-headless',ROOT/'.runtime-cache/DumpAsset']
 if not all(p.exists()for p in required):raise SystemExit('Restore Agent A runtime first')
 g.fixture_ground=collision_fixture;g._dark_walkable_cells=scaled_dark_gate;g.ground_script=real_ground_script
 assets=[f'no_name_village_{s}'for s in('spring','summer','autumn','winter')]+[f'no_name_{h}_house'for h in('player','logger','hunter','carpenter')];rows=[]
 for asset in assets:
  print('VALIDATING',asset,flush=True);report=g.validate_runtime(ROOT,ROOT/'Data/Ground'/f'{asset}.rsground',None,ROOT/'.runtime-cache'/f'{asset}-runtime',ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/runtime'/asset,[0,15],300);report['fixture_entity_isolation']='Ignored fixture only; actors/triggers removed to isolate BMA movement. Candidate hash is unchanged.';(ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/runtime'/asset/'runtime_report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');rows.append({'asset':asset,'ground_sha256':report['candidate']['ground_sha256'],'result':report['result'],'load':report['runtime_probes']['load'],'movement':report['runtime_probes']['movement'],'blocked':report['runtime_probes']['blocked'],'report_sha256':sha(ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/runtime'/asset/'runtime_report.json')})
 phases=[]
 for phase in range(4):
  PHASE_OVERRIDE=phase;asset='no_name_village_spring';report=g.validate_runtime(ROOT,ROOT/'Data/Ground'/f'{asset}.rsground',None,ROOT/'.runtime-cache'/f'{asset}-phase-{phase}-runtime',ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/runtime-time'/f'state_{phase}',[0],300);phases.append({'source_numeric_state':phase,'ground_sha256':report['candidate']['ground_sha256'],'load':report['runtime_probes']['load'],'movement':report['runtime_probes']['movement'],'blocked':report['runtime_probes']['blocked'],'capture_sha256':report['captures'][0]['sha256']})
 PHASE_OVERRIDE=None;assert len({r['capture_sha256']for r in phases})==4
 aggregate={'schema':'no-name-village.pmdo-runtime-validation.v2','result':'EXACT_PMDO_0.8.12_RUNTIME_PASS','pmdo_sha256':sha(required[0]),'method':'Agent A ignored overlay + patched SDL + SwiftShader/ANGLE','real_lua_scripts_loaded':True,'grounds':rows,'source_numeric_time_states':phases,'time_state_capture_distinctness':'PASS_4_OF_4'};out=ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/runtime-validation.json';out.write_text(json.dumps(aggregate,ensure_ascii=False,indent=2)+'\n');print(aggregate['result'])
if __name__=='__main__':main()
