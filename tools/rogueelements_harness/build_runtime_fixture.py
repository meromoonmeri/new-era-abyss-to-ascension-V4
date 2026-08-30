#!/usr/bin/env python3
"""Create an ignored PMDO 0.8.12 RogueElements profile fixture.

Never writes production paths.  Profiles are cloned from a known-deserializable
GridFloorGen and only native path-step types/parameters are changed.
"""
import copy, json, shutil
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'.runtime-cache/pmdred-eu-runtime-restoration-gate'
OUT=ROOT/'.runtime-cache/rogueelements-harness-fixture'
TYPE='RogueElements.GridPath'
PROFILES=('branch','circle','cross','two_sides','grid')
def load(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def dump(p,o): p.write_text('\ufeff'+json.dumps(o,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
def path_step(f): return next(x['Value'] for x in f['GenSteps'] if 'GridPath' in x['Value'].get('$type',''))
def configure(f,profile):
 s=path_step(f); common={k:copy.deepcopy(s[k]) for k in ('GenericRooms','GenericHalls','RoomComponents','HallComponents') if k in s}
 ctx='`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements'
 s.clear();s.update(common)
 s['$type']=TYPE+({'branch':'Branch','circle':'Circle','cross':'Cross','two_sides':'TwoSides','grid':'Grid'}[profile])+ctx
 if profile=='branch': s.update(RoomRatio={'Min':55,'Max':90},BranchRatio={'Min':100,'Max':180},NoForcedBranches=False)
 elif profile=='circle': s.update(CircleRoomRatio={'Min':55,'Max':90},Paths={'Min':2,'Max':4})
 elif profile=='two_sides': s.update(GapAxis=0)
 elif profile=='grid': s.update(RoomRatio=80,HallRatio=55)
 # Remove optional PMDC room constraints that can suppress the new shapes.
 for x in f['GenSteps']:
  if 'ConnectGridBranchStep' in x['Value'].get('$type',''):
   x['Value']['ConnectPercent']=70 if profile in ('branch','circle') else 20
 return f
def main():
 if OUT.exists(): shutil.rmtree(OUT)
 shutil.copytree(BASE,OUT,symlinks=True)
 zdir=OUT/'quest/Data/Zone'; canonical_zone=load(ROOT/'.runtime-cache/DumpAsset/Data/Zone/ambush_forest.json'); source=canonical_zone['Object']
 seg0=source['Segments'][0]; floors=seg0['Floors'][:1]
 source['Name']['DefaultText']='RogueElements Harness';source['Name']['LocalTexts']={'fr':'Harness RogueElements'}
 source['Segments']=[]
 for profile in PROFILES:
  seg=copy.deepcopy(seg0); seg['Floors']=[configure(copy.deepcopy(floors[0]),profile)]; seg['ZoneSteps']=[]; source['Segments'].append(seg)
 dump(zdir/'rogueelements_harness.json',{'Version':'0.8.12.0','Object':source})
 idx=load(zdir/'index.idx'); source_idx=load(ROOT/'.runtime-cache/DumpAsset/Data/Zone/index.idx'); idx['Object']['rogueelements_harness']=copy.deepcopy(source_idx['Object']['ambush_forest']);dump(zdir/'index.idx',idx)
 mainp=OUT/'quest/Data/Script/halcyon/main.lua'
 if mainp.is_symlink(): mainp.unlink()
 mainp.write_text((ROOT/'Data/Script/halcyon/main.lua').read_text()+"\nrequire 'halcyon.services.rogueelements_harness_probe'\n")
 p=OUT/'quest/Data/Script/halcyon/services/rogueelements_harness_probe/init.lua';p.parent.mkdir(parents=True,exist_ok=True)
 p.write_text("""require 'origin.common'\nrequire 'origin.services.baseservice'\nlocal V=Class('REHarness',BaseService)\nlocal function e(s)local f=io.open('/tmp/re_harness.jsonl','a');if f then f:write(s..'\\n');f:close()end;PrintInfo(s)end\nfunction V:initialize()BaseService.initialize(self);self.i=0;self.on=os.getenv('PMDO_RE_HARNESS')=='1' end\nfunction V:OnInit()if not self.on then return end;io.open('/tmp/re_harness.jsonl','w'):close();RogueEssence.GameManager.Instance:NewGamePlus(tonumber(os.getenv('PMDO_RE_SEED')) or 1)end\nfunction V:OnNewGame()if self.on then GAME:EnterZone('rogueelements_harness',0,0,0)end end\nfunction V:OnDungeonMapInit()if not self.on then return end;TASK:BranchCoroutine(function() GAME:WaitFrames(3);local m=_ZONE.CurrentMap;local w=m.Width;local h=m.Height;local free=0;local blocked=0;for x=0,w-1 do for y=0,h-1 do if m:TileBlocked(RogueElements.Loc(x,y)) then blocked=blocked+1 else free=free+1 end end end;e('{'..'\\"profile\\":'..self.i..',\\"width\\":'..w..',\\"height\\":'..h..',\\"free\\":'..free..',\\"blocked\\":'..blocked..'}');self.i=self.i+1;if self.i<5 then GAME:EnterZone('rogueelements_harness',self.i,0,0)else RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload end end)end\nfunction V:Subscribe(m) m:Subscribe('REHarness',EngineServiceEvents.Init,function()self:OnInit()end);m:Subscribe('REHarness',EngineServiceEvents.NewGame,function()self:OnNewGame()end);m:Subscribe('REHarness',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)end\nfunction V:UnSubscribe(m)end\nSCRIPT:AddService('REHarness',V:new())\nreturn V\n""")
 print(OUT)
if __name__=='__main__':main()
