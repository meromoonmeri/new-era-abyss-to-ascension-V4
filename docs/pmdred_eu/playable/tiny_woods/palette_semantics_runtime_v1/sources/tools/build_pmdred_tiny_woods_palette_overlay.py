#!/usr/bin/env python3
"""Build the create-only Tiny Woods overlay with certified palette semantics."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SEMANTICS = ROOT / "docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json"
VALIDATOR = ROOT / "tools/pmdred_tiny_woods_palette_validator.lua"
SEMANTICS_SCHEMA = "pmdred-eu-tiny-woods-palette-semantics-v1"


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


def replace_once(value: str, old: str, new: str, label: str) -> str:
    if value.count(old) != 1:
        raise ValueError(f"palette integration boundary differs: {label} ({value.count(old)} matches)")
    return value.replace(old, new)


def lua(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def adapter_module(semantics: dict[str, Any]) -> str:
    rows = []
    order = []
    for command in semantics["commands"]:
        address = command["address"]
        order.append(lua(address))
        rows.append(
            "  [%s]={address=%s,array=%s,index=%d,opcode=%d,opcode_hex=%s,frames=%d,channel=%s,target=%s,api=%s}" % (
                lua(address), lua(address), lua(command["array_id"]), command["index"], command["opcode_value"],
                lua(command["opcode"]), command["source_frames"], lua(command["channel"]),
                lua(command["target"]), lua(command["pmdo_api"]),
            )
        )
    return """-- Source-pinned adapter for the 15 authenticated PMD Red EU palette commands.
local GraphicsManagerType=luanet.import_type('RogueEssence.Content.GraphicsManager')
local COMMANDS={
%s
}
local ORDER={%s}
local Palette={}
local function trace(kind,command,scene,detail)
  if PMDRED_TINY_WOODS_SCENE_TRACE then
    PMDRED_TINY_WOODS_SCENE_TRACE(kind,scene,command.index,command.address,command.channel,command.target,detail)
  end
end
local function ticks() return tonumber(GraphicsManagerType.TotalFrameTick) or 0 end
function Palette.Execute(address,scene)
  local command=COMMANDS[address]
  if command==nil then error('palette adapter rejected unauthenticated address '..tostring(address)) end
  local runtimeFrames=command.frames==0 and 1 or command.frames
  local before=ticks()
  local common=string.format('array=%%s;opcode=%%s;source_frames=%%d;runtime_frames=%%d;blocking=true;api=%%s',command.array,command.opcode_hex,command.frames,runtimeFrames,command.api)
  trace('palette_transition_start',command,scene,common..';before_tick='..tostring(before))
  if command.opcode==0x22 then GAME:FadeIn(runtimeFrames)
  elseif command.opcode==0x23 then GAME:FadeOut(false,runtimeFrames)
  elseif command.opcode==0x25 then GAME:FadeInFront(runtimeFrames)
  elseif command.opcode==0x26 then GAME:FadeOutFront(false,runtimeFrames)
  else error('palette adapter opcode gate failed') end
  local after=ticks();local elapsed=math.floor((after-before)/120)
  trace('palette_transition_complete',command,scene,common..';before_tick='..tostring(before)..';after_tick='..tostring(after)..';elapsed_frames='..tostring(elapsed))
end
function Palette.ExecuteAll(scene)
  for _,address in ipairs(ORDER) do Palette.Execute(address,scene) end
end
function Palette.Count() return #ORDER end
return Palette
""" % (",\n".join(rows), ",".join(order))


OLD_OPENING = """local function runOpening(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local butterfree=map:GetTempChar('BUTTERFREE')
  SOUND:StopBGM();GROUND:CharSetAnim(hero,'EventSleep',true);choreo('hero_sleep')
  for i,row in ipairs(rows) do
    if i==11 then GROUND:CharSetAnim(hero,'Idle',true);SOUND:PlayBGM('PMD Red - Heartwarming.ogg',false);GAME:FadeIn(30);choreo('hero_wake_music_fadein') end
    if i==18 then GROUND:CharAnimateTurnTo(hero,Direction.Right,4);GROUND:CharAnimateTurnTo(hero,Direction.Left,4);choreo('hero_look_around') end
    if i==26 then SOUND:FadeOutBGM(30);GROUND:MoveInDirection(butterfree,Direction.Right,96,false,1);GAME:MoveCamera(216,188,20,false);choreo('butterfree_enters') end
    if i==29 then SOUND:PlayBGM(\"PMD Red - There's Trouble.ogg\",false);choreo('trouble_music') end
    show(row)
    if i==23 and PMDRED_TINY_WOODS_HERO_NAME then PMDRED_TINY_WOODS_HERO_NAME() end
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_faces_dungeon')
end"""
NEW_OPENING = """local function runOpening(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local butterfree=map:GetTempChar('BUTTERFREE')
  SOUND:StopBGM();Palette.Execute('0x084CB130','d01p01_g1');Palette.Execute('0x084CB148','d01p01_g1');GROUND:CharSetAnim(hero,'EventSleep',true);GAME:WaitFrames(100);choreo('dual_channel_blackout_hero_sleep')
  for i,row in ipairs(rows) do
    if i==6 then GAME:WaitFrames(1);Palette.Execute('0x084CB2E0','d01p01_g1');choreo('front_layer_restored_after_black_narration') end
    if i==11 then GROUND:CharSetAnim(hero,'Idle',true);SOUND:PlayBGM('PMD Red - Heartwarming.ogg',false);Palette.Execute('0x084CB400','d01p01_g1');choreo('hero_wake_music_main_fadein_60') end
    if i==18 then GROUND:CharAnimateTurnTo(hero,Direction.Right,4);GROUND:CharAnimateTurnTo(hero,Direction.Left,4);choreo('hero_look_around') end
    if i==26 then SOUND:FadeOutBGM(30);GROUND:MoveInDirection(butterfree,Direction.Right,96,false,1);GAME:MoveCamera(216,188,20,false);choreo('butterfree_enters') end
    if i==29 then SOUND:PlayBGM(\"PMD Red - There's Trouble.ogg\",false);choreo('trouble_music') end
    show(row)
    if i==23 and PMDRED_TINY_WOODS_HERO_NAME then PMDRED_TINY_WOODS_HERO_NAME() end
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_faces_dungeon')
end"""
OLD_DEFEAT = """local function runDefeat(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER')
  SOUND:StopBGM();GROUND:CharSetAnim(hero,'EventSleep',true);GROUND:CharSetAnim(part,'EventSleep',true);choreo('party_sleep')
  for i,row in ipairs(rows) do
    if i==2 then GROUND:CharSetAnim(hero,'Idle',true);GROUND:CharSetAnim(part,'Idle',true);choreo('party_wake') end
    show(row)
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_returns_to_dungeon')
end"""
NEW_DEFEAT = """local function runDefeat(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER')
  SOUND:StopBGM();GROUND:CharSetAnim(hero,'EventSleep',true);GROUND:CharSetAnim(part,'EventSleep',true);GAME:WaitFrames(60);choreo('party_sleep')
  for i,row in ipairs(rows) do
    if i==2 then GROUND:CharSetAnim(hero,'Idle',true);GROUND:CharSetAnim(part,'Idle',true);choreo('party_wake') end
    show(row)
    if i==1 then GAME:WaitFrames(1);Palette.Execute('0x084CFFE8','d01p01_g2');choreo('defeat_main_fadein_60_after_station_message') end
  end
  GROUND:CharAnimateTurnTo(hero,Direction.Left,4);GROUND:CharAnimateTurnTo(part,Direction.Left,4);choreo('party_returns_to_dungeon')
end"""
OLD_ENDING = """local function runEnding(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetCurrentGround():GetTempChar('PARTNER');local caterpie=map:GetTempChar('CATERPIE')
"""
# OLD_ENDING above is not used; exact generated function is replaced below from boundaries.


def replace_function(text: str, name: str, replacement: str) -> str:
    start = text.find(f"local function {name}(rows)")
    if start < 0:
        raise ValueError(f"missing function boundary {name}")
    marker = "\nlocal function "
    end = text.find(marker, start + 1)
    if end < 0:
        end = text.find("\nfunction Scene.Run", start + 1)
    if end < 0:
        raise ValueError(f"missing function end boundary {name}")
    return text[:start] + replacement + text[end:]


NEW_ENDING = """local function runEnding(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local caterpie=map:GetTempChar('CATERPIE')
  SOUND:PlayBGM('PMD Red - In the Depths of the Pit.ogg',false);Palette.Execute('0x084D4C90','d01p02_g1');choreo('ending_music_main_fadein_30')
  for i,row in ipairs(rows) do
    if i==3 then GROUND:MoveInDirection(hero,Direction.Up,16,false,1);GROUND:MoveInDirection(part,Direction.Up,16,false,1);choreo('rescuers_approach') end
    if i==4 then GROUND:CharSetEmote(caterpie,'notice',1);choreo('caterpie_notices') end
    if i==6 then GROUND:CharSetEmote(caterpie,'happy',1);choreo('caterpie_happy') end
    show(row)
  end
  Palette.Execute('0x084D4CC0','d01p02_g1');GAME:WaitFrames(30);choreo('ending_main_fadeout_30')
end"""
NEW_POST_RESCUE = """local function runPostRescue(rows)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER');local part=map:GetTempChar('PARTNER');local butterfree=map:GetTempChar('BUTTERFREE');local caterpie=map:GetTempChar('CATERPIE')
  SOUND:PlayBGM('PMD Red - A Successful Rescue.ogg',false);Palette.Execute('0x084D1C54','d01p01_g3');choreo('successful_rescue_main_fadein_30')
  for i,row in ipairs(rows) do
    if i==7 then GROUND:CharSetEmote(caterpie,'happy',1);choreo('caterpie_admires_hero') end
    if i==13 then choreo('reward_sequence') end
    if i==15 then GROUND:MoveInDirection(butterfree,Direction.Right,96,false,1);GROUND:MoveInDirection(caterpie,Direction.Right,96,false,1);choreo('family_exits_east') end
    show(row)
  end
  GROUND:CharAnimateTurnTo(part,Direction.Right,4);GROUND:CharAnimateTurnTo(hero,Direction.Right,4);SOUND:FadeOutBGM(30);Palette.Execute('0x084D1C9C','d01p01_g3');GAME:WaitFrames(60);choreo('partner_invites_hero_main_fadeout_30')
end"""

OLD_BASE = """function Campaign.RunBase()
  local scene='b01p00a_g16';GAME:CutsceneMode(true);trace('scene_start',scene,0,'','','',scene)
  SOUND:PlayBGM('PMD Red - Rescue Team Base.ogg',false);trace('audio_bgm',scene,0,'','','','id=1')
  cue(465,true);cue(455,true);show(BASE_PREFIX,scene)
  local automation=os.getenv('PMDRED_TINY_WOODS_AUTOMATION')=='1'
  local refusals=automation and (tonumber(os.getenv('PMDRED_TINY_WOODS_AUTOMATION_REFUSALS') or '1') or 1) or 0
  local accepted=false
  while not accepted do
    local choice=1
    if automation then if refusals>0 then choice=2;refusals=refusals-1 end
    else UI:BeginChoiceMenu('Que réponds-tu ?', {\"J'accepte.\",\"Je refuse.\"},1,2);UI:WaitForChoice();choice=UI:ChoiceResult() end
    if choice==2 then show(BASE_REFUSAL,scene) else accepted=true end
  end
  show(BASE_ACCEPTANCE,scene)
  local team='Secours'
  if not automation then
    local confirmed=false
    while not confirmed do
      UI:NameMenu('Quel sera le nom de votre équipe ?', \"Tu n'as pas besoin d'inclure « Équipe » dans le nom.\",60,GAME:GetTeamName());UI:WaitForChoice();team=UI:ChoiceResult();if team==nil or team=='' then team=GAME:GetTeamName() end
      GAME:SetTeamName(team);UI:ChoiceMenuYesNo(\"L'Équipe \"..GAME:GetTeamName()..' convient-elle ?',true);UI:WaitForChoice();confirmed=UI:ChoiceResult()
    end
  else GAME:SetTeamName(team) end
  trace('naming_team',scene,0,'0x0838E394','team',GAME:GetTeamName(),'native_name_menu_or_deterministic_automation')
  show(BASE_NAMING,scene);cue(473,true);show(BASE_STATION,scene)
  SOUND:FadeOutBGM(120);GAME:WaitFrames(120);trace('scene_complete',scene,0,'','','',scene);GAME:CutsceneMode(false)
end"""
NEW_BASE = OLD_BASE.replace(
    "SOUND:PlayBGM('PMD Red - Rescue Team Base.ogg',false);trace('audio_bgm',scene,0,'','','','id=1')\n  cue(465,true)",
    "SOUND:PlayBGM('PMD Red - Rescue Team Base.ogg',false);trace('audio_bgm',scene,0,'','','','id=1');Palette.Execute('0x0838D21C',scene)\n  cue(465,true)",
).replace(
    "show(BASE_NAMING,scene);cue(473,true);show(BASE_STATION,scene)\n  SOUND:FadeOutBGM(120);GAME:WaitFrames(120);trace('scene_complete'",
    "show(BASE_NAMING,scene);cue(473,true);SOUND:FadeOutBGM(120);Palette.Execute('0x0838D27C',scene);Palette.Execute('0x0838D294',scene);GAME:WaitFrames(60);show(BASE_STATION,scene);GAME:WaitFrames(1);Palette.Execute('0x0838D36C',scene)\n  trace('scene_complete'",
)
OLD_TITLE = """function Campaign.RunTitle()
  local scene='s02_fre_g2';Campaign.TraceAllCommands();local hero=GAME:GetCurrentGround():GetChar('PLAYER');GROUND:TeleportTo(hero,144,216,Direction.Up)
  trace('safe_marker',scene,0,'','','','cell=18,27;pixel=144,216');GAME:CutsceneMode(true);trace('scene_start',scene,0,'','','',scene)
  SOUND:PlayBGM('PMD Red - Aftermath.ogg',false);trace('audio_bgm',scene,0,'','','','id=46;completion=TRACK_CLEAR');GAME:WaitFrames(60);GAME:FadeIn(60);GAME:WaitFrames(480);SOUND:FadeOutBGM(30);GAME:WaitFrames(30)
  _DATA.Save:CompleteDungeon('tiny_woods');SV.Scenario=SV.Scenario or {};SV.Scenario.Main=3;SV.Scenario.MainLevel=0"""
NEW_TITLE = OLD_TITLE.replace(
    "GAME:WaitFrames(60);GAME:FadeIn(60);GAME:WaitFrames(480);SOUND:FadeOutBGM(30);GAME:WaitFrames(30)",
    "GAME:WaitFrames(60);Palette.Execute('0x0856280C',scene);GAME:WaitFrames(480);SOUND:FadeOutBGM(30);Palette.Execute('0x08562854',scene)",
)


def build(output: Path, music_source: Path | None = None, fanfare_source: Path | None = None) -> dict[str, Any]:
    output = output.resolve()
    semantics = json.loads(SEMANTICS.read_text(encoding="utf-8"))
    if semantics.get("schema") != SEMANTICS_SCHEMA or semantics.get("status") != "source_pinned_semantics_pass" or len(semantics.get("commands", [])) != 15:
        raise ValueError("source-pinned palette semantics supplement differs")
    if semantics.get("adapter_contract", {}).get("all_other_unknown_opcodes_keep_actor_control_unknown_fallback") is not True:
        raise ValueError("unknown-opcode fallback retention gate differs")
    base = load_tool("build_pmdred_tiny_woods_command_complete_overlay")
    kwargs: dict[str, Path] = {}
    if music_source is not None:
        kwargs["music_source"] = music_source
    if fanfare_source is not None:
        kwargs["fanfare_source"] = fanfare_source
    base.build(output, **kwargs)

    script = output / "quest/Data/Script/halcyon"
    adapter = script / "pmdred_palette_adapter.lua"
    adapter.write_text(adapter_module(semantics), encoding="utf-8")

    core = script / "pmdred_tiny_woods_scenes.lua"
    core_text = core.read_text(encoding="utf-8")
    core_text = replace_once(core_text, "local Scene={}\n", "local Palette=require 'halcyon.pmdred_palette_adapter'\nlocal Scene={}\n", "core adapter import")
    core_text = replace_once(core_text, OLD_OPENING, NEW_OPENING, "opening choreography")
    core_text = replace_once(core_text, OLD_DEFEAT, NEW_DEFEAT, "defeat choreography")
    core_text = replace_function(core_text, "runEnding", NEW_ENDING)
    core_text = replace_function(core_text, "runPostRescue", NEW_POST_RESCUE)
    if "GAME:FadeIn(" in core_text or "GAME:FadeOut(false" in core_text:
        raise ValueError("unadapted main fade remains in Tiny Woods scene core")
    core.write_text(core_text, encoding="utf-8")

    campaign = script / "pmdred_tiny_woods_command_campaign.lua"
    campaign_text = campaign.read_text(encoding="utf-8")
    campaign_text = replace_once(campaign_text, "local Route=require 'halcyon.pmdred_tiny_woods_route'\n", "local Route=require 'halcyon.pmdred_tiny_woods_route'\nlocal Palette=require 'halcyon.pmdred_palette_adapter'\n", "campaign adapter import")
    campaign_text = replace_once(campaign_text, OLD_BASE, NEW_BASE, "base choreography")
    campaign_text = replace_once(campaign_text, OLD_TITLE, NEW_TITLE, "title choreography")
    semantic_function = """function Campaign.RunSemanticAdapterCertification()
  Campaign.TraceAllCommands();local scene='palette_adapter_all';GAME:CutsceneMode(true);trace('scene_start',scene,0,'','','',scene)
  Palette.ExecuteAll(scene)
  trace('scene_complete',scene,0,'','','',scene);trace('palette_semantic_automation_checkpoint',scene,Palette.Count(),'','','','exact_authenticated_commands=15');GAME:CutsceneMode(false)
end
"""
    campaign_text = replace_once(campaign_text, "return Campaign\n", semantic_function + "return Campaign\n", "semantic certification entry")
    campaign.write_text(campaign_text, encoding="utf-8")

    ground = script / "ground/d01p01/init.lua"
    ground_text = ground.read_text(encoding="utf-8")
    ground_text = replace_once(
        ground_text,
        "function M.Enter(map)\n  local group=Route.DispatchGround('d01p01');",
        "function M.Enter(map)\n  if os.getenv('TINY_WOODS_COMMAND_MODE')=='palette_adapter_all' then Campaign.RunSemanticAdapterCertification();return end\n  local group=Route.DispatchGround('d01p01');",
        "adapter certification dispatch",
    )
    ground.write_text(ground_text, encoding="utf-8")

    validator = script / "services/ground_gameplay_validator/init.lua"
    validator.write_text(VALIDATOR.read_text(encoding="utf-8").replace("@@LAUNCHER_GROUND_INDEX@@", "308"), encoding="utf-8")

    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    complete = manifest["tiny_woods_command_complete"]
    complete["validator"] = {
        "source": str(VALIDATOR.relative_to(ROOT)), "source_sha256": sha256(VALIDATOR),
        "fixture_sha256": sha256(validator), "opt_in": "PMDO_GROUND_VALIDATOR=tiny_woods_command_complete",
    }
    complete["files"][str(core.relative_to(output))] = {"bytes": core.stat().st_size, "sha256": sha256(core)}
    complete["files"][str(campaign.relative_to(output))] = {"bytes": campaign.stat().st_size, "sha256": sha256(campaign)}
    complete["files"][str(ground.relative_to(output))] = {"bytes": ground.stat().st_size, "sha256": sha256(ground)}
    complete["files"][str(validator.relative_to(output))] = {"bytes": validator.stat().st_size, "sha256": sha256(validator)}
    manifest["tiny_woods_scenes"]["files"][str(core.relative_to(output))] = {"bytes": core.stat().st_size, "sha256": sha256(core)}
    manifest["tiny_woods_palette_semantics"] = {
        "schema": "pmdred-eu-tiny-woods-palette-overlay-v1", "date": str(date.today()),
        "semantics_source": str(SEMANTICS.relative_to(ROOT)), "semantics_sha256": sha256(SEMANTICS),
        "commands": 15, "affected_arrays": 6, "planning_unknown_fallback_retained": True,
        "integrated_scenes": ["d01p01_g1", "d01p01_g2", "d01p01_g3", "d01p02_g1", "b01p00a_g16", "s02_fre_g2"],
        "adapter": {"path": str(adapter.relative_to(output)), "bytes": adapter.stat().st_size, "sha256": sha256(adapter)},
        "validator": complete["validator"],
        "files": {
            str(path.relative_to(output)): {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in (adapter, core, campaign, ground, validator)
        },
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"TINY_WOODS_PALETTE_OVERLAY_READY output={output} commands=15 scenes=6")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--music-source", type=Path)
    parser.add_argument("--fanfare-source", type=Path)
    args = parser.parse_args()
    build(args.output, args.music_source, args.fanfare_source)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
