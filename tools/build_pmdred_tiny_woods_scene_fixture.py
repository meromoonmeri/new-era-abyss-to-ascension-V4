#!/usr/bin/env python3
"""Build a create-only exact-PMDO fixture for the four Tiny Woods EU scenes."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import shutil
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/scene_plan.json"
GRAPH = ROOT / "docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json"
VALIDATOR = ROOT / "tools/pmdred_tiny_woods_scene_validator.lua"
PLAN_SHA256 = "95440fd600528f62328f2db26853054ad965f4205d7eb48709cf022e4571a38f"
GRAPH_SHA256 = "6cc155b0302602e7edb223243a43e65aa3b0b3ff296df7742e79686db07ee1d1"
MUSIC_HASHES = {
    "PMD Red - There's Trouble.ogg": "ee1472d8f2121e2f1388106fb24a601f7b276ca58cf032f1c0594466e039b707",
    "PMD Red - Heartwarming.ogg": "6ef0e60aa3aafc5606393103c9631d89c030341443d126df997cddb9107d5ac0",
    "PMD Red - A Successful Rescue.ogg": "9c581ff4ea0c231b58bd19c7fc5681a927a0dcf911eefef0f73858760475fd2e",
    "PMD Red - In the Depths of the Pit.ogg": "09f3bec584f3d35a1a2e9173ec977b4363169d99fdfa3cca7e2e1844c9c2f3d6",
}

D01P01_SCRIPT = r"""-- Fixture-local authenticated EU Tiny Woods entry scenes.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Scene=require 'halcyon.pmdred_tiny_woods_scenes'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p01')
  if group~='g1' and group~='g2' and group~='g3' then error('unsupported d01p01 scene group '..tostring(group)) end
  Scene.Stage('d01p01_'..group)
  Scene.Run('d01p01_'..group)
  if group=='g1' or group=='g2' then
    local seed=tonumber(os.getenv('TINY_WOODS_SCENE_SEED') or '424242') or 424242
    Route.BeginAttempt();RogueElements.MathUtils.ReSeedRand(seed)
    GAME:EnterDungeon('tiny_woods',0,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
  end
end
function M.Exit(map) Scene.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""

D01P02_SCRIPT = r"""-- Fixture-local authenticated EU Caterpie rescue scene.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Scene=require 'halcyon.pmdred_tiny_woods_scenes'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p02')
  if group~='g1' then error('d01p02 scene did not dispatch g1') end
  Scene.Stage('d01p02_g1');Scene.Run('d01p02_g1')
  Route.CompleteRescue()
  GAME:EnterGroundMap('d01p01','Main_Entrance_Marker')
end
function M.Exit(map) Scene.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def load_tool(name: str) -> ModuleType:
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def lua(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "") + '"'


def materialize_music(fixture: Path, music_source: Path) -> dict[str, dict[str, Any]]:
    parent = fixture / "quest/Content/Music"
    if not parent.is_symlink():
        raise ValueError("base fixture Music parent is not the expected shared symlink")
    tracked_source = parent.resolve(strict=True)
    parent.unlink();parent.mkdir()
    for child in tracked_source.iterdir():
        if child.name not in MUSIC_HASHES:
            (parent / child.name).symlink_to(child.resolve(), target_is_directory=child.is_dir())
    records = {}
    for name, expected in MUSIC_HASHES.items():
        source = music_source / name
        if sha256(source) != expected:
            raise ValueError(f"authenticated scene music differs: {name}")
        destination = parent / name
        shutil.copyfile(source, destination)
        records[str(destination.relative_to(fixture))] = {
            "bytes": destination.stat().st_size, "sha256": sha256(destination)
        }
    return records


def scene_module(plan: dict[str, Any]) -> str:
    tables = []
    for scene, payload in plan["scenes"].items():
        rows = [
            "    {seq=%d,speaker=%s,pointer=%s,text=%s}" % (
                row["sequence"], lua(row["speaker"]), lua(row["pointer"]), lua(row["pmdo_text"])
            )
            for row in payload["dialogue"]
        ]
        tables.append(f"  {scene}={{\n" + ",\n".join(rows) + "\n  }")
    dialogue = "local DIALOGUE={\n" + ",\n".join(tables) + "\n}\n"
    return dialogue + r'''
local Scene={}
local managed={}
local currentScene=''
local function trace(kind,seq,pointer,speaker,text,detail)
  if PMDRED_TINY_WOODS_SCENE_TRACE then PMDRED_TINY_WOODS_SCENE_TRACE(kind,currentScene,seq or 0,pointer or '',speaker or '',text or '',detail or '') end
end
local function add(chara)
  chara:ReloadEvents();GAME:GetCurrentGround():AddTempChar(chara);chara:OnMapInit()
  local result=RogueEssence.Script.TriggerResult()
  TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned,result,chara))
  AI:DisableCharacterAI(chara);table.insert(managed,chara)
end
local function monster(species,name,index,x,y,direction)
  local id=RogueEssence.Dungeon.MonsterID(species,0,'normal',RogueEssence.Data.Gender.Unknown)
  local chara=RogueEssence.Ground.GroundChar(id,RogueElements.Loc(x,y),direction,name,index)
  add(chara);return chara
end
local function partner(x,y,direction)
  local data=GAME:GetPlayerPartyMember(1);if data==nil then error('scene fixture requires partner slot') end
  local chara=RogueEssence.Ground.GroundChar(data,RogueElements.Loc(x,y),direction,'PARTNER')
  add(chara);return chara
end
function Scene.Cleanup()
  local map=GAME:GetCurrentGround()
  for _,chara in ipairs(managed) do pcall(function()map:RemoveTempChar(chara)end) end
  managed={};SOUND:StopBGM()
end
function Scene.Stage(scene)
  Scene.Cleanup();currentScene=scene
  local hero=GAME:GetCurrentGround():GetChar('PLAYER')
  if scene=='d01p01_g1' then
    hero.Direction=Direction.Down;partner(232,196,Direction.Left);monster('butterfree','Papilusion','BUTTERFREE',72,188,Direction.Right)
  elseif scene=='d01p01_g2' then
    hero.Direction=Direction.Down;partner(232,196,Direction.Down);monster('butterfree','Papilusion','BUTTERFREE',216,172,Direction.Down)
  elseif scene=='d01p01_g3' then
    hero.Direction=Direction.Up;partner(232,196,Direction.Up);monster('butterfree','Papilusion','BUTTERFREE',232,172,Direction.Down);monster('caterpie','Chenipan','CATERPIE',200,172,Direction.Down)
  elseif scene=='d01p02_g1' then
    hero.Direction=Direction.Up;partner(196,276,Direction.Up);monster('caterpie','Chenipan','CATERPIE',180,148,Direction.Up)
  else error('unknown scene '..tostring(scene)) end
  trace('staging',0,'','','',scene)
  for _,name in ipairs({'PLAYER','PARTNER','BUTTERFREE','CATERPIE'}) do
    local chara=name=='PLAYER' and GAME:GetCurrentGround():GetChar(name) or GAME:GetCurrentGround():GetTempChar(name)
    if chara then
      local species=chara.Data.BaseForm.Species
      trace('actor',0,'',name,species,string.format('%d,%d,%s',chara.Position.X,chara.Position.Y,tostring(chara.Direction)))
    end
  end
end
local function format(text)
  local hero=GAME:GetCurrentGround():GetChar('PLAYER');local part=GAME:GetCurrentGround():GetTempChar('PARTNER')
  local species=RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:Get(hero.Data.BaseForm.Species).Name:ToLocal()
  return text:gsub('{hero}',hero:GetDisplayName()):gsub('{partner}',part:GetDisplayName()):gsub('{hero_species}',species)
end
local function show(row)
  local map=GAME:GetCurrentGround();local actor=nil
  if row.speaker=='hero' or row.speaker=='hero_thought' then actor=map:GetChar('PLAYER')
  elseif row.speaker=='partner' then actor=map:GetTempChar('PARTNER')
  elseif row.speaker=='butterfree' then actor=map:GetTempChar('BUTTERFREE')
  elseif row.speaker=='caterpie' then actor=map:GetTempChar('CATERPIE') end
  if actor then UI:SetSpeaker(actor) else UI:ResetSpeaker() end
  local text=format(row.text);trace('dialogue',row.seq,row.pointer,row.speaker,text,'')
  UI:WaitShowDialogue(text)
end
local function choreo(detail)
  trace('choreography',0,'','','',detail)
end
local function runOpening(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local butterfree=map:GetTempChar('BUTTERFREE')
  SOUND:StopBGM();GROUND:CharSetAnim(hero,'EventSleep',true);choreo('hero_sleep')
  for i,row in ipairs(rows) do
    if i==11 then GROUND:CharSetAnim(hero,'Idle',true);SOUND:PlayBGM('PMD Red - Heartwarming.ogg',false);GAME:FadeIn(30);choreo('hero_wake_music_fadein') end
    if i==18 then GROUND:CharAnimateTurnTo(hero,Direction.Right,4);GROUND:CharAnimateTurnTo(hero,Direction.Left,4);choreo('hero_look_around') end
    if i==26 then SOUND:FadeOutBGM(30);GROUND:MoveInDirection(butterfree,Direction.Right,96,false,1);GAME:MoveCamera(216,188,20,false);choreo('butterfree_enters') end
    if i==29 then SOUND:PlayBGM("PMD Red - There's Trouble.ogg",false);choreo('trouble_music') end
    show(row)
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_faces_dungeon')
end
local function runDefeat(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER')
  SOUND:StopBGM();GROUND:CharSetAnim(hero,'EventSleep',true);GROUND:CharSetAnim(part,'EventSleep',true);choreo('party_sleep')
  for i,row in ipairs(rows) do
    if i==2 then GROUND:CharSetAnim(hero,'Idle',true);GROUND:CharSetAnim(part,'Idle',true);choreo('party_wake') end
    show(row)
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_returns_to_dungeon')
end
local function runEnding(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local caterpie=map:GetTempChar('CATERPIE')
  SOUND:PlayBGM('PMD Red - In the Depths of the Pit.ogg',false);GAME:FadeIn(30);choreo('ending_music_fadein')
  for i,row in ipairs(rows) do
    if i==3 then GROUND:MoveInDirection(hero,Direction.Up,16,false,1);GROUND:MoveInDirection(part,Direction.Up,16,false,1);choreo('rescuers_approach') end
    if i==4 then GROUND:CharSetEmote(caterpie,'notice',1);choreo('caterpie_notices') end
    if i==6 then GROUND:CharSetEmote(caterpie,'happy',1);choreo('caterpie_happy') end
    show(row)
  end
end
local function runPostRescue(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local butterfree=map:GetTempChar('BUTTERFREE');local caterpie=map:GetTempChar('CATERPIE')
  SOUND:PlayBGM('PMD Red - A Successful Rescue.ogg',false);GAME:FadeIn(30);choreo('successful_rescue_music')
  for i,row in ipairs(rows) do
    if i==7 then GROUND:CharSetEmote(caterpie,'happy',1);choreo('caterpie_admires_hero') end
    if i==13 then choreo('reward_sequence') end
    if i==15 then GROUND:MoveInDirection(butterfree,Direction.Right,96,false,1);GROUND:MoveInDirection(caterpie,Direction.Right,96,false,1);choreo('family_exits_east') end
    show(row)
  end
  GROUND:CharAnimateTurnTo(part,Direction.Right,4);GROUND:CharAnimateTurnTo(hero,Direction.Right,4);SOUND:FadeOutBGM(30);GAME:WaitFrames(30);choreo('partner_invites_hero')
end
function Scene.Run(scene)
  currentScene=scene;local rows=DIALOGUE[scene];if rows==nil then error('missing dialogue '..scene) end
  GAME:CutsceneMode(true);trace('scene_start',0,'','','',scene)
  if scene=='d01p01_g1' then runOpening(rows)
  elseif scene=='d01p01_g2' then runDefeat(rows)
  elseif scene=='d01p02_g1' then runEnding(rows)
  else runPostRescue(rows) end
  trace('scene_complete',0,'','','',scene);GAME:CutsceneMode(false)
end
return Scene
'''


def build(output: Path, music_source: Path) -> dict[str, Any]:
    output=output.resolve();music_source=music_source.resolve()
    if output.exists(): raise FileExistsError(f"refusing to overwrite scene fixture: {output}")
    if sha256(PLAN)!=PLAN_SHA256 or sha256(GRAPH)!=GRAPH_SHA256: raise ValueError('scene authority/plan hash differs')
    route_builder=load_tool('build_pmdred_tiny_woods_route_fixture')
    route_builder.build(output)
    plan=json.loads(PLAN.read_text())
    music_records=materialize_music(output,music_source)
    quest=output/'quest';script=quest/'Data/Script/halcyon'
    module=script/'pmdred_tiny_woods_scenes.lua';module.write_text(scene_module(plan),encoding='utf-8')
    (script/'ground/d01p01/init.lua').write_text(D01P01_SCRIPT,encoding='utf-8')
    (script/'ground/d01p02/init.lua').write_text(D01P02_SCRIPT,encoding='utf-8')
    validator=script/'services/ground_gameplay_validator/init.lua'
    source=VALIDATOR.read_text().replace('@@LAUNCHER_GROUND_INDEX@@','308')
    validator.write_text(source,encoding='utf-8')
    manifest_path=output/'fixture_manifest.json';manifest=json.loads(manifest_path.read_text())
    private=[module,script/'ground/d01p01/init.lua',script/'ground/d01p02/init.lua',validator]
    manifest['tiny_woods_scenes']={
      'schema':'pmdred-eu-tiny-woods-scene-fixture-v1','date':str(date.today()),
      'authority':{'region':'EU','rom_sha256':'0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd','scene_graph_sha256':GRAPH_SHA256,'scene_plan_sha256':PLAN_SHA256},
      'scenarios':['opening_scene','defeat_scene','ending_rescue_scene'],
      'dialogue_counts':{k:v['dialogue_count'] for k,v in plan['scenes'].items()},
      'music':music_records,
      'files':{str(p.relative_to(output)):{'bytes':p.stat().st_size,'sha256':sha256(p)} for p in private},
      'validator':{'source':str(VALIDATOR.relative_to(ROOT)),'source_sha256':sha256(VALIDATOR),'fixture_sha256':sha256(validator),'opt_in':'PMDO_GROUND_VALIDATOR=tiny_woods_scene_fixture'},
    }
    manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    print(f'TINY_WOODS_SCENE_FIXTURE_READY output={output} dialogue=74 music=4')
    return manifest


def main()->int:
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True);parser.add_argument('--music-source',type=Path,required=True);args=parser.parse_args();build(args.output,args.music_source);return 0
if __name__=='__main__':raise SystemExit(main())
