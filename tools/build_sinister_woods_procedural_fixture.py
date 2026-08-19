#!/usr/bin/env python3
"""Build an ignored PMDO fixture for the procedural Sinister Woods gate.

The fixture keeps production assets read-only.  It overlays only the current
Zone, the reconstructed ``deep_shadow`` MapStatus, the status index, the
Sinister Woods music, and an opt-in runtime probe.  No PNG, Ground, Relic
Forest blob, D04P01, or D04P02 asset is generated or replaced.
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import os
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE_PATH = ROOT / "tools/build_pmdred_eu_runtime_fixture.py"
SPEC = importlib.util.spec_from_file_location("pmdred_runtime_fixture", BASE_PATH)
assert SPEC and SPEC.loader
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

SEGMENTS = (0, 1, 3)


def install_probe(quest: Path) -> None:
    main_path = quest / "Data/Script/halcyon/main.lua"
    if main_path.is_symlink():
        main_path.unlink()
    source_main = main_path if main_path.is_file() else ROOT / "Data/Script/halcyon/main.lua"
    main_path.write_text(
        source_main.read_text(encoding="utf-8")
        + "\nrequire 'halcyon.services.sinister_woods_procedural_probe'\n",
        encoding="utf-8",
    )
    probe_path = quest / "Data/Script/halcyon/services/sinister_woods_procedural_probe/init.lua"
    probe_path.parent.mkdir(parents=True, exist_ok=True)
    segments = ", ".join(str(segment) for segment in SEGMENTS)
    probe_path.write_text(
        f'''require 'origin.common'\n'''
        f'''require 'origin.services.baseservice'\n'''
        f'''local SEGMENTS={{ {segments} }}\n'''
        f'''local V=Class('SinisterWoodsProceduralProbe',BaseService)\n'''
        f'''local function emit(s)\n'''
        f'''  PrintInfo('[SINISTER_WOODS_PROBE] '..s)\n'''
        f'''  local f=io.open("/tmp/sinister_woods_procedural_probe.jsonl","a")\n'''
        f'''  if f then f:write(s.."\\n");f:flush();f:close() end\n'''
        f'''end\n'''
        f'''local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end\n'''
        f'''function V:initialize()\n'''
        f'''  BaseService.initialize(self)\n'''
        f'''  self.enabled=os.getenv("PMDO_SINISTER_WOODS_PROBE")=="1"\n'''
        f'''  self.index=0;self.entered=false;self.transitioning=false\n'''
        f'''end\n'''
        f'''function V:OnInit()\n'''
        f'''  if not self.enabled then return end\n'''
        f'''  local f=io.open("/tmp/sinister_woods_procedural_probe.jsonl","w");if f then f:close() end\n'''
        f'''  emit('{{"event":"bootstrap"}}')\n'''
        f'''  RogueEssence.GameManager.Instance:NewGamePlus(424242)\n'''
        f'''end\n'''
        f'''function V:enter_next()\n'''
        f'''  self.transitioning=false\n'''
        f'''  self.index=self.index+1\n'''
        f'''  if self.index>#SEGMENTS then\n'''
        f'''    emit('{{"event":"end","normal_unload_requested":true}}')\n'''
        f'''    RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload\n'''
        f'''  else\n'''
        f'''    local segment=SEGMENTS[self.index]\n'''
        f'''    emit('{{"event":"enter","segment":'..segment..'}}')\n'''
        f'''    GAME:EnterZone("gloomy_forest",segment,0,0)\n'''
        f'''  end\n'''
        f'''end\n'''
        f'''function V:inspect_map()\n'''
        f'''  GAME:WaitFrames(4)\n'''
        f'''  local map=_ZONE.CurrentMap\n'''
        f'''  assert(map~=nil,"CurrentMap absent")\n'''
        f'''  local hero=safe(function()return map.ActiveTeam.Leader end,nil)\n'''
        f'''  assert(hero~=nil,"ActiveTeam leader absent")\n'''
        f'''  local width=safe(function()return map.Width end,-1)\n'''
        f'''  local height=safe(function()return map.Height end,-1)\n'''
        f'''  local music=safe(function()return map.Music end,"")\n'''
        f'''  local setter=safe(function()return map.Status:ContainsKey("deep_shadow")end,false)\n'''
        f'''  local darkness=safe(function()return map.Status:ContainsKey("darkness")end,false)\n'''
        f'''  local dusk=safe(function()return map.Status:ContainsKey("dusk")end,false)\n'''
        f'''  local x=safe(function()return hero.CharLoc.X end,-1)\n'''
        f'''  local y=safe(function()return hero.CharLoc.Y end,-1)\n'''
        f'''  local free_probe=false;local blocked_probe=false\n'''
        f'''  for px=0,width-1,1 do\n'''
        f'''    for py=0,height-1,1 do\n'''
        f'''      local loc=RogueElements.Loc(px,py)\n'''
        f'''      local blocked=map:TileBlocked(loc)\n'''
        f'''      if blocked then blocked_probe=true elseif map:GetCharAtLoc(loc)==nil then free_probe=true end\n'''
        f'''      if free_probe and blocked_probe then break end\n'''
        f'''    end\n'''
        f'''    if free_probe and blocked_probe then break end\n'''
        f'''  end\n'''
        f'''  emit('{{"event":"map","segment":'..SEGMENTS[self.index]..',"width":'..width..',"height":'..height..',"music":"'..tostring(music)..'","deep_shadow_setter":'..tostring(setter)..',"darkness":'..tostring(darkness)..',"dusk":'..tostring(dusk)..',"free_collision_probe":'..tostring(free_probe)..',"blocked_collision_probe":'..tostring(blocked_probe)..'}}')\n'''
        f'''  _GROUND:Screenshot()\n'''
        f'''  GAME:WaitFrames(3)\n'''
        f'''  self.entered=false\n'''
        f'''  self:enter_next()\n'''
        f'''end\n'''
        f'''function V:OnNewGame()\n'''
        f'''  if self.enabled and not self.entered then self:enter_next() end\n'''
        f'''end\n'''
        f'''function V:OnDungeonMapInit()\n'''
        f'''  if not self.enabled or self.transitioning then return end\n'''
        f'''  if tostring(_ZONE.CurrentZoneID)~="gloomy_forest" then return end\n'''
        f'''  self.entered=true\n'''
        f'''  TASK:BranchCoroutine(function()\n'''
        f'''    local ok,err=xpcall(function()self:inspect_map()end,debug.traceback)\n'''
        f'''    if not ok then emit('{{"event":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\\\"')..'"}}');RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload end\n'''
        f'''  end)\n'''
        f'''end\n'''
        f'''function V:Subscribe(med)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.Init,function()self:OnInit()end)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.NewGame,function()self:OnNewGame()end)\n'''
        f'''  med:Subscribe("SinisterWoodsProceduralProbe",EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)\n'''
        f'''end\n'''
        f'''function V:UnSubscribe(med)end\n'''
        f'''SCRIPT:AddService("SinisterWoodsProceduralProbe",V:new())\n'''
        f'''return V\n''',
        encoding="utf-8",
    )


def prepare_music(asset_root: Path) -> None:
    music = asset_root / "Content/Music"
    if music.is_symlink():
        music.unlink()
    elif music.exists():
        shutil.rmtree(music)
    music.mkdir(parents=True)
    shutil.copy2(ROOT / "Content/Music/Sinister Woods.ogg", music / "Sinister Woods.ogg")


def build(output: Path) -> Path:
    if output.exists():
        shutil.rmtree(output)
    # One direct Ground keeps the fixture builder's authenticated base small;
    # the probe enters gloomy_forest directly and does not use that Ground.
    quest = BASE.build(ROOT, output, conversion_set="direct", ids=["d01p02"])
    zone_dir = quest / "Data/Zone"
    shutil.copy2(ROOT / "Data/Zone/gloomy_forest.json", zone_dir / "gloomy_forest.json")
    # The map-status index is already copied by the base fixture.  Replace the
    # generated setter with a fixture-local copy so the runtime tests the exact
    # staged file rather than a source symlink.
    deep = quest / "Data/MapStatus/deep_shadow.json"
    if deep.is_symlink():
        deep.unlink()
    shutil.copy2(ROOT / "Data/MapStatus/deep_shadow.json", deep)
    install_probe(quest)
    prepare_music(output / "asset")
    manifest = json.loads((output / "fixture_manifest.json").read_text(encoding="utf-8"))
    manifest.update({
        "schema": "new-era.pmdred-eu.sinister-woods-procedural-runtime-fixture.v1",
        "scope": "gloomy_forest procedural segments 0, 1 and 3 at floor 0",
        "zone_source": "Data/Zone/gloomy_forest.json",
        "zone_sha256": __import__('hashlib').sha256((ROOT / "Data/Zone/gloomy_forest.json").read_bytes()).hexdigest(),
        "map_status_source": "Data/MapStatus/deep_shadow.json",
        "map_status_sha256": __import__('hashlib').sha256((ROOT / "Data/MapStatus/deep_shadow.json").read_bytes()).hexdigest(),
        "segments": list(SEGMENTS),
        "production_assets_modified": False,
    })
    (output / "fixture_manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return quest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path(".runtime-cache/sinister-woods-procedural-fixture"))
    args = parser.parse_args()
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
