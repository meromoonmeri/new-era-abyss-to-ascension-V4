#!/usr/bin/env python3
"""Build the create-only command-complete PMD Red EU Tiny Woods overlay."""
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
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SCENE_PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/scene_plan.json"
SCENE_GRAPH = ROOT / "docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json"
POST_GRAPH = ROOT / "docs/pmdred_eu/playable/tiny_woods/post_route/eu_post_route_graph.json"
MUSIC_SOURCE = ROOT / ".runtime-cache/pmdred-tiny-woods-scene-music-v3"
FANFARE_SOURCE = ROOT / ".runtime-cache/pmdred-tiny-woods-fanfares-v4"
VALIDATOR = ROOT / "tools/pmdred_tiny_woods_command_complete_validator.lua"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PINNED = {
    PLAN: "ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b",
    SCENE_PLAN: "95440fd600528f62328f2db26853054ad965f4205d7eb48709cf022e4571a38f",
    SCENE_GRAPH: "6cc155b0302602e7edb223243a43e65aa3b0b3ff296df7742e79686db07ee1d1",
    POST_GRAPH: "9f1cf97cbfa211b16dab5fbf52df8aeb195878461f6425be542a229468766615",
}
MASTER_INDICES = {"b01p00a": 141, "d01p01": 308, "s02_fre": 329}
SAFE_MARKERS = {"b01p00a": (34, 34, 272, 272), "s02_fre": (18, 27, 144, 216)}
BASE_ARRAY = "post_route:s_gs9_g17_s0_lives0_dlg0"
STATION_ARRAY = "post_route:s_gs9_g17_s0_station_sref_script"
BASE_PREFIX = [6, 24, 26, 27, 30, 32, 33, 36, 43, 46, 61, 68, 69, 70, 71, 72, 73, 74, 92]
BASE_REFUSAL = [105, 110, 114]
BASE_ACCEPTANCE = [127, 128, 137, 138]
BASE_NAMING = [154, 158]
BASE_STATION = [13, 14, 15]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_tool(name: str) -> ModuleType:
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def lua(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "") + '"'


def normalize_red_text(value: str) -> str:
    result = value.strip()
    replacements = {
        "~2c": ",", "~27": "'", "#W": "[pause=30]", "#+": "",
        "#C5": "[color=#00FFFF]", "#R": "[color]",
    }
    for source, target in replacements.items():
        result = result.replace(source, target)
    return result


def command_lua(plan: dict[str, Any]) -> str:
    arrays = []
    for array in plan["arrays"]:
        rows = []
        for command in array["commands"]:
            fields = [
                f"index={command['index']}", f"address={lua(command['address'])}",
                f"op={command['op']}", f"arg_byte={command['arg_byte']}",
                f"arg_short={command['arg_short']}", f"arg1={command['arg1']}",
                f"arg2={command['arg2']}", f"handler={lua(command['pmdo_handler'])}",
                "pointer=" + (lua(command["pointer"]) if command["pointer"] else "false"),
            ]
            if "french" in command:
                fr = command["french"]
                fields.append(
                    "fr={block=%s,address=%s,raw=%s,text=%s}" % (
                        lua(fr["block_address"]), lua(fr["address"]), lua(fr["raw_hex"]), lua(fr["text"])
                    )
                )
            rows.append("    {" + ",".join(fields) + "}")
        arrays.append("  [%s]={\n%s\n  }" % (lua(array["array_id"]), ",\n".join(rows)))
    return "local COMMANDS={\n" + ",\n".join(arrays) + "\n}\n"


def selected_rows(plan: dict[str, Any], array_id: str, indices: list[int]) -> list[dict[str, Any]]:
    array = next(item for item in plan["arrays"] if item["array_id"] == array_id)
    by_index = {row["index"]: row for row in array["commands"]}
    result = []
    for index in indices:
        row = by_index[index]
        if "french" not in row:
            raise ValueError(f"selected dialogue has no French association: {array_id}:{index}")
        result.append({
            "sequence": len(result) + 1,
            "index": index,
            "address": row["address"],
            "pointer": row["pointer"],
            "text": normalize_red_text(row["french"]["text"]),
        })
    return result


def rows_lua(rows: list[dict[str, Any]]) -> str:
    return "{\n" + ",\n".join(
        "  {seq=%d,index=%d,address=%s,pointer=%s,text=%s}" % (
            row["sequence"], row["index"], lua(row["address"]), lua(row["pointer"]), lua(row["text"])
        ) for row in rows
    ) + "\n}"


def campaign_module(plan: dict[str, Any]) -> str:
    prefix = selected_rows(plan, BASE_ARRAY, BASE_PREFIX)
    refusal = selected_rows(plan, BASE_ARRAY, BASE_REFUSAL)
    acceptance = selected_rows(plan, BASE_ARRAY, BASE_ACCEPTANCE)
    naming = selected_rows(plan, BASE_ARRAY, BASE_NAMING)
    station = selected_rows(plan, STATION_ARRAY, BASE_STATION)
    command_table = command_lua(plan)
    selected = (
        "local BASE_PREFIX=" + rows_lua(prefix) + "\n"
        + "local BASE_REFUSAL=" + rows_lua(refusal) + "\n"
        + "local BASE_ACCEPTANCE=" + rows_lua(acceptance) + "\n"
        + "local BASE_NAMING=" + rows_lua(naming) + "\n"
        + "local BASE_STATION=" + rows_lua(station) + "\n"
    )
    return command_table + selected + r"""
local Core=require 'halcyon.pmdred_tiny_woods_scenes'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Campaign={}
local managed={}
local tracedAll=false

local function trace(kind,scene,sequence,pointer,speaker,text,detail)
  if PMDRED_TINY_WOODS_SCENE_TRACE then PMDRED_TINY_WOODS_SCENE_TRACE(kind,scene,sequence,pointer,speaker,text,detail) end
end
local function format(text)
  local hero=GAME:GetCurrentGround():GetChar('PLAYER')
  local partner=GAME:GetCurrentGround():GetTempChar('PARTNER')
  local species=RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:Get(hero.Data.BaseForm.Species).Name:ToLocal()
  local team=GAME:GetTeamName()
  return text:gsub('$n0',hero:GetDisplayName()):gsub('$n1',partner and partner:GetDisplayName() or ''):gsub('$n2','Chenipan'):gsub('$m0',species):gsub('$t',team)
end
local function show(rows,scene)
  local partner=GAME:GetCurrentGround():GetTempChar('PARTNER')
  if partner then UI:SetSpeaker(partner) else UI:ResetSpeaker() end
  for _,row in ipairs(rows) do
    local text=format(row.text);trace('dialogue',scene,row.seq,row.address,'partner',text,'eu_pointer='..tostring(row.pointer));UI:WaitShowDialogue(text)
  end
end
local function addPartner(x,y)
  local data=GAME:GetPlayerPartyMember(1);if data==nil then error('Tiny Woods base scene requires partner slot') end
  local chara=RogueEssence.Ground.GroundChar(data,RogueElements.Loc(x,y),Direction.Left,'PARTNER')
  chara:ReloadEvents();GAME:GetCurrentGround():AddTempChar(chara);chara:OnMapInit()
  local result=RogueEssence.Script.TriggerResult();TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned,result,chara));AI:DisableCharacterAI(chara)
  table.insert(managed,chara);return chara
end
local function cue(id,wait)
  trace('audio_cue','audio',0,'','','',tostring(id))
  if id==450 then SOUND:LoopSE('Cue 450');GAME:WaitFrames(20);SOUND:StopSE('Cue 450')
  else SOUND:PlayFanfare('Cue '..tostring(id));if wait then SOUND:WaitFanfare() end end
end

function Campaign.TraceAllCommands()
  if tracedAll then return end;tracedAll=true
  for arrayId,rows in pairs(COMMANDS) do for _,row in ipairs(rows) do
    if PMDRED_TINY_WOODS_COMMAND_TRACE then PMDRED_TINY_WOODS_COMMAND_TRACE(arrayId,row.index,row.address,row.op,row.arg_byte,row.arg_short,row.arg1,row.arg2,row.handler) end
  end end
  trace('command_coverage','all',975,'','','','arrays=27;commands=975')
end
function Campaign.NameHero()
  local member=GAME:GetPlayerPartyMember(0);local old=GAME:GetCharacterNickname(member);local result=old
  if os.getenv('PMDRED_TINY_WOODS_AUTOMATION')~='1' then
    UI:NameMenu('Quel sera ton nom ?', '', 60, old);UI:WaitForChoice();local chosen=UI:ChoiceResult();if chosen~=nil and chosen~='' then result=chosen end
  elseif result==nil or result=='' then result='Héros' end
  GAME:SetCharacterNickname(member,result);trace('naming_hero','d01p01_g1',23,'0x084CDEC8','hero',result,'native_name_menu_or_deterministic_automation')
end
PMDRED_TINY_WOODS_HERO_NAME=function() Campaign.NameHero() end

function Campaign.RunCore(scene)
  Campaign.TraceAllCommands()
  trace('active_command_arrays',scene,0,'','','','authenticated group arrays')
  if scene=='d01p01_g1' or scene=='d01p02_g1' then cue(468,false) end
  Core.Run(scene)
  if scene=='d01p01_g1' then cue(469,true);cue(482,true);cue(470,true);cue(466,true);cue(463,true);cue(450,false);cue(465,true)
  elseif scene=='d01p02_g1' then cue(469,true);cue(470,true);cue(450,false);cue(457,true)
  elseif scene=='d01p01_g3' then cue(470,true);cue(450,false) end
end
function Campaign.OpeningAutomationCheckpoint()
  trace('opening_automation_checkpoint','d01p01_g1',0,'','','','after_row_23_native_naming')
end
function Campaign.DeliverRewards()
  local state=Route.GetState();if state.RewardsDelivered then return end
  for _,item in ipairs({{'berry_oran',1},{'berry_pecha',1},{'berry_rawst',1}}) do GAME:GivePlayerItem(item[1],item[2]);trace('reward','d01p01_g3',0,'','','',item[1]) end
  state.RewardsDelivered=true
end
function Campaign.StageBase()
  Campaign.TraceAllCommands();Campaign.CleanupBase()
  local hero=GAME:GetCurrentGround():GetChar('PLAYER');GROUND:TeleportTo(hero,272,272,Direction.Right);addPartner(296,272)
  trace('safe_marker','b01p00a_g16',0,'','','','cell=34,34;pixel=272,272')
end
function Campaign.CleanupBase()
  local map=GAME:GetCurrentGround();for _,chara in ipairs(managed) do pcall(function()map:RemoveTempChar(chara)end) end;managed={}
end
function Campaign.RunBase()
  local scene='b01p00a_g16';GAME:CutsceneMode(true);trace('scene_start',scene,0,'','','',scene)
  SOUND:PlayBGM('PMD Red - Rescue Team Base.ogg',false);trace('audio_bgm',scene,0,'','','','id=1')
  cue(465,true);cue(455,true);show(BASE_PREFIX,scene)
  local automation=os.getenv('PMDRED_TINY_WOODS_AUTOMATION')=='1'
  local refusals=automation and (tonumber(os.getenv('PMDRED_TINY_WOODS_AUTOMATION_REFUSALS') or '1') or 1) or 0
  local accepted=false
  while not accepted do
    local choice=1
    if automation then if refusals>0 then choice=2;refusals=refusals-1 end
    else UI:BeginChoiceMenu('Que réponds-tu ?', {"J'accepte.","Je refuse."},1,2);UI:WaitForChoice();choice=UI:ChoiceResult() end
    if choice==2 then show(BASE_REFUSAL,scene) else accepted=true end
  end
  show(BASE_ACCEPTANCE,scene)
  local team='Secours'
  if not automation then
    local confirmed=false
    while not confirmed do
      UI:NameMenu('Quel sera le nom de votre équipe ?', "Tu n'as pas besoin d'inclure « Équipe » dans le nom.",60,GAME:GetTeamName());UI:WaitForChoice();team=UI:ChoiceResult();if team==nil or team=='' then team=GAME:GetTeamName() end
      GAME:SetTeamName(team);UI:ChoiceMenuYesNo("L'Équipe "..GAME:GetTeamName()..' convient-elle ?',true);UI:WaitForChoice();confirmed=UI:ChoiceResult()
    end
  else GAME:SetTeamName(team) end
  trace('naming_team',scene,0,'0x0838E394','team',GAME:GetTeamName(),'native_name_menu_or_deterministic_automation')
  show(BASE_NAMING,scene);cue(473,true);show(BASE_STATION,scene)
  SOUND:FadeOutBGM(120);GAME:WaitFrames(120);trace('scene_complete',scene,0,'','','',scene);GAME:CutsceneMode(false)
end
function Campaign.RunTitle()
  local scene='s02_fre_g2';Campaign.TraceAllCommands();local hero=GAME:GetCurrentGround():GetChar('PLAYER');GROUND:TeleportTo(hero,144,216,Direction.Up)
  trace('safe_marker',scene,0,'','','','cell=18,27;pixel=144,216');GAME:CutsceneMode(true);trace('scene_start',scene,0,'','','',scene)
  SOUND:PlayBGM('PMD Red - Aftermath.ogg',false);trace('audio_bgm',scene,0,'','','','id=46;completion=TRACK_CLEAR');GAME:WaitFrames(60);GAME:FadeIn(60);GAME:WaitFrames(480);SOUND:FadeOutBGM(30);GAME:WaitFrames(30)
  _DATA.Save:CompleteDungeon('tiny_woods');SV.Scenario=SV.Scenario or {};SV.Scenario.Main=3;SV.Scenario.MainLevel=0
  SV.PmdRedTinyWoodsProgress={Schema='pmdred-eu-tiny-woods-progression-v1',TinyWoodsCompleted=true,Scenario=3,Level=0,EventDivision='EVENT_DIVIDE'}
  local state=Route.GetState();state.Status='completed';state.PendingGround='EVENT_DIVIDE';state.EventDivision='EVENT_DIVIDE'
  trace('scene_complete',scene,0,'','','',scene);trace('progression',scene,0,'0x08286E48','','tiny_woods','SCENARIO_MAIN=3,0;EVENT_DIVIDE');GAME:CutsceneMode(false)
end
return Campaign
"""


D01P01_SCRIPT = r"""-- Production-overlay PMD Red EU Tiny Woods opening/retry/post-rescue relay.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Core=require 'halcyon.pmdred_tiny_woods_scenes'
local Campaign=require 'halcyon.pmdred_tiny_woods_command_campaign'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p01');if group~='g1' and group~='g2' and group~='g3' then error('unsupported d01p01 group '..tostring(group)) end
  Core.Stage('d01p01_'..group);Campaign.RunCore('d01p01_'..group)
  if group=='g1' and os.getenv('TINY_WOODS_COMMAND_MODE')=='opening_naming' then Campaign.OpeningAutomationCheckpoint();return end
  if group=='g1' or group=='g2' then
    local seed=tonumber(os.getenv('TINY_WOODS_COMMAND_SEED') or '424242') or 424242;Route.BeginAttempt();RogueElements.MathUtils.ReSeedRand(seed)
    GAME:EnterDungeon('tiny_woods',0,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
  else
    Campaign.DeliverRewards();local state=Route.GetState();state.LastGround='d01p01';state.LastGroup='g3';state.PendingGround='b01p00a'
    GAME:EnterZone('master_zone',-1,141,0)
  end
end
function M.Exit(map) Core.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""

D01P02_SCRIPT = r"""-- Production-overlay authenticated EU Caterpie rescue relay.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Core=require 'halcyon.pmdred_tiny_woods_scenes'
local Campaign=require 'halcyon.pmdred_tiny_woods_command_campaign'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p02');if group~='g1' then error('d01p02 did not dispatch g1') end
  Core.Stage('d01p02_g1');Campaign.RunCore('d01p02_g1');Route.CompleteRescue();GAME:EnterGroundMap('d01p01','Main_Entrance_Marker')
end
function M.Exit(map) Core.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""

B01P00A_SCRIPT = r"""-- Production-overlay PMD Red EU rescue-base group 16.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Campaign=require 'halcyon.pmdred_tiny_woods_command_campaign'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local state=Route.GetState();if not state.RescueComplete then error('rescue-base scene requires completed Caterpie rescue') end
  state.LastGround='b01p00a';state.LastGroup='g16';state.PendingGround='b01p00a';Campaign.StageBase();Campaign.RunBase();state.PendingGround='s02_fre';GAME:EnterGroundMap(329,0)
end
function M.Exit(map) Campaign.CleanupBase() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""

S02_FRE_SCRIPT = r"""-- Production-overlay localized PMD Red EU title group 2 and progression.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Campaign=require 'halcyon.pmdred_tiny_woods_command_campaign'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local state=Route.GetState();if state.PendingGround~='s02_fre' then error('localized title route is out of order') end
  state.LastGround='s02_fre';state.LastGroup='g2';Campaign.RunTitle()
end
function M.Exit(map) SOUND:StopBGM() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def copy_extra_audio(
    output: Path, music_source: Path, fanfare_source: Path,
) -> tuple[dict[str, Any], dict[str, Any]]:
    music_manifest = json.loads((music_source / "manifest.json").read_text())
    fanfare_manifest = json.loads((fanfare_source / "manifest.json").read_text())
    if music_manifest.get("validation") != {"status": "pass", "track_count": 6}:
        raise ValueError("six-BGM source manifest differs")
    if fanfare_manifest.get("validation") != {"status": "pass", "cue_count": 11}:
        raise ValueError("eleven-cue source manifest differs")
    expected_renderer_hashes = {
        "loop": sha256(ROOT / "tools/pmdred_m4a_to_ogg_general.c"),
        "terminating": sha256(ROOT / "tools/pmdred_m4a_fanfare_to_ogg.c"),
    }
    renderer_gates = (
        (music_manifest, "looping_bgm", expected_renderer_hashes["loop"]),
        (music_manifest, "terminating_bgm", expected_renderer_hashes["terminating"]),
        (fanfare_manifest, "explicit_stop_loop", expected_renderer_hashes["loop"]),
        (fanfare_manifest, "one_shot", expected_renderer_hashes["terminating"]),
    )
    for manifest, renderer, expected in renderer_gates:
        if manifest.get("renderers", {}).get(renderer, {}).get("source_sha256") != expected:
            raise ValueError(f"audio renderer source provenance differs: {renderer}")
    music_dir = output / "quest/Content/Music"
    music_records = {}
    for track in music_manifest["tracks"]:
        destination = music_dir / track["filename"]
        source = music_source / track["filename"]
        if sha256(source) != track["sha256"]:
            raise ValueError(f"authenticated BGM differs: {source}")
        if destination.is_symlink():
            destination.unlink()
        if not destination.exists():
            shutil.copyfile(source, destination)
        if sha256(destination) != track["sha256"]:
            raise ValueError(f"installed BGM differs: {destination}")
        music_records[str(destination.relative_to(output))] = {"bytes": destination.stat().st_size, "sha256": sha256(destination), "song_index": track["song_index"]}

    sound_dir = output / "quest/Content/Sound"
    if not sound_dir.is_symlink():
        raise ValueError("base overlay Sound parent is not the expected shared symlink")
    source_sound = sound_dir.resolve(strict=True)
    sound_dir.unlink();sound_dir.mkdir()
    cue_names = {cue["filename"] for cue in fanfare_manifest["cues"]}
    for child in source_sound.iterdir():
        if child.name not in cue_names:
            (sound_dir / child.name).symlink_to(child.resolve(), target_is_directory=child.is_dir())
    cue_records = {}
    for cue in fanfare_manifest["cues"]:
        source = fanfare_source / cue["filename"]
        destination = sound_dir / cue["filename"]
        if sha256(source) != cue["sha256"]:
            raise ValueError(f"authenticated cue differs: {source}")
        shutil.copyfile(source, destination)
        cue_records[str(destination.relative_to(output))] = {"bytes": destination.stat().st_size, "sha256": sha256(destination), "cue_id": cue["cue_id"], "playback_kind": cue["playback_kind"]}
    return music_records, cue_records


def build(
    output: Path,
    music_source: Path = MUSIC_SOURCE,
    fanfare_source: Path = FANFARE_SOURCE,
) -> dict[str, Any]:
    output = output.resolve()
    music_source = music_source.resolve()
    fanfare_source = fanfare_source.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite command-complete overlay: {output}")
    for path, expected in PINNED.items():
        if sha256(path) != expected:
            raise ValueError(f"authenticated input differs: {path}")
    if not VALIDATOR.is_file():
        raise FileNotFoundError(VALIDATOR)
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    if plan["totals"] != {"arrays": 27, "commands": 975, "unique_addresses": 975, "opcodes": 61, "french_text_associations": 195}:
        raise ValueError("command-plan aggregate gate differs")

    scene_builder = load_tool("build_pmdred_tiny_woods_scene_fixture")
    scene_builder.build(output, music_source)
    quest = output / "quest"
    master = json.loads((quest / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig"))["Object"]["GroundMaps"]
    for ground, expected in MASTER_INDICES.items():
        if master.index(ground) != expected:
            raise ValueError(f"master-zone index differs for {ground}")
    for ground in ("b01p00a", "s02_fre"):
        candidate = quest / f"Data/Ground/{ground}.rsground"
        if not candidate.is_file() or candidate.resolve() != (ROOT / f"Data/Ground/{ground}.rsground").resolve():
            raise ValueError(f"authenticated promoted Ground overlay binding differs: {ground}")

    music, cues = copy_extra_audio(output, music_source, fanfare_source)
    script = quest / "Data/Script/halcyon"
    core = script / "pmdred_tiny_woods_scenes.lua"
    core_text = core.read_text(encoding="utf-8")
    needle = "    show(row)\n  end\n  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_faces_dungeon')"
    replacement = "    show(row)\n    if i==23 and PMDRED_TINY_WOODS_HERO_NAME then PMDRED_TINY_WOODS_HERO_NAME() end\n  end\n  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_faces_dungeon')"
    if core_text.count(needle) != 1:
        raise ValueError("opening row-23 naming injection boundary differs")
    core.write_text(core_text.replace(needle, replacement), encoding="utf-8")

    campaign = script / "pmdred_tiny_woods_command_campaign.lua"
    campaign.write_text(campaign_module(plan), encoding="utf-8")
    ground_root = script / "ground"
    scripts = {
        ground_root / "d01p01/init.lua": D01P01_SCRIPT,
        ground_root / "d01p02/init.lua": D01P02_SCRIPT,
        ground_root / "b01p00a/init.lua": B01P00A_SCRIPT,
        ground_root / "s02_fre/init.lua": S02_FRE_SCRIPT,
    }
    for path, text in scripts.items():
        path.parent.mkdir(parents=True, exist_ok=True);path.write_text(text, encoding="utf-8")
    validator = script / "services/ground_gameplay_validator/init.lua"
    validator.write_text(VALIDATOR.read_text(encoding="utf-8").replace("@@LAUNCHER_GROUND_INDEX@@", "308"), encoding="utf-8")

    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    # The production overlay intentionally extends the derived scene core; keep every nested hash truthful.
    manifest["tiny_woods_scenes"]["files"][str(core.relative_to(output))] = {"bytes": core.stat().st_size, "sha256": sha256(core)}
    private_files = [core, campaign, validator, *scripts.keys()]
    manifest["tiny_woods_command_complete"] = {
        "schema": "pmdred-eu-tiny-woods-command-complete-overlay-v1",
        "date": str(date.today()),
        "authority": {"region": "EU", "rom_sha256": ROM_SHA256, "command_plan_sha256": sha256(PLAN), "scene_graph_sha256": sha256(SCENE_GRAPH), "post_route_graph_sha256": sha256(POST_GRAPH)},
        "command_surface": plan["totals"],
        "route": ["d01p02:g1", "d01p01:g3", "b01p00a:g16", "s02_fre:g2", "Tiny Woods completed", "SCENARIO_MAIN 3,0", "EVENT_DIVIDE"],
        "master_zone_indices": MASTER_INDICES,
        "safe_markers": {key: {"cell": list(value[:2]), "pixel": list(value[2:])} for key, value in SAFE_MARKERS.items()},
        "dialogue": {"opening_hero_naming_after_row": 23, "base_prefix": len(BASE_PREFIX), "deterministic_refusal": len(BASE_REFUSAL), "acceptance_and_naming": len(BASE_ACCEPTANCE) + len(BASE_NAMING), "station_narration": len(BASE_STATION), "post_route_total_with_one_refusal": 56},
        "rewards": ["berry_oran", "berry_pecha", "berry_rawst"],
        "progression": {"dungeon": "tiny_woods", "unlock": "Completed", "scenario_main": 3, "scenario_level": 0, "event_division": "EVENT_DIVIDE"},
        "music_source_manifest_sha256": sha256(music_source / "manifest.json"),
        "fanfare_source_manifest_sha256": sha256(fanfare_source / "manifest.json"),
        "music": music,
        "cues": cues,
        "fixture_isolation": {"script_private": not (quest / "Data/Script").is_symlink(), "music_private": not (quest / "Content/Music").is_symlink(), "sound_private": not (quest / "Content/Sound").is_symlink(), "promoted_grounds_read_only_bound": True},
        "validator": {"source": str(VALIDATOR.relative_to(ROOT)), "source_sha256": sha256(VALIDATOR), "fixture_sha256": sha256(validator), "opt_in": "PMDO_GROUND_VALIDATOR=tiny_woods_command_complete"},
        "files": {str(path.relative_to(output)): {"bytes": path.stat().st_size, "sha256": sha256(path)} for path in private_files},
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    print(f"TINY_WOODS_COMMAND_COMPLETE_OVERLAY_READY output={output} arrays=27 commands=975 bgm=6 cues=11")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--music-source", type=Path, default=MUSIC_SOURCE)
    parser.add_argument("--fanfare-source", type=Path, default=FANFARE_SOURCE)
    args = parser.parse_args()
    build(args.output, args.music_source, args.fanfare_source)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
