#!/usr/bin/env python3
"""Build an ignored PMDO 0.8.12 overlay for the 27 PMD Red EU Ground candidates.

The fixture never edits the quest or RESERVE candidates.  It symlinks every
untouched quest subtree, copies only the assets that need controlled routing,
and adds deterministic walkable entry markers plus audit-only scripts.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import struct
from pathlib import Path
from typing import Any

CANDIDATES = (
    "d01p02", "d02p02", "d03p02", "d04p02", "d05p02", "d06p02", "d06p03",
    "d09p02", "d09p03", "d10p02", "d10p03", "d11p02", "d11p03", "d12p02",
    "d12p04", "d13p02", "d13p03", "d14p01", "d15p01", "d16p01", "d17p01",
    "d18p01", "d19p01", "d20p01", "d21p01", "d23p01", "d25p01",
)
SHEET_SUFFIX = "_DirectBase.tile"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json_bom(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\ufeff" + json.dumps(value, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


def symlink(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    target.symlink_to(source.resolve(), target_is_directory=source.is_dir())


def overlay_children(source: Path, target: Path, excluded: set[str]) -> None:
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        if child.name not in excluded:
            symlink(child, target / child.name)


def overlay_data_tree(source: Path, target: Path) -> None:
    """Overlay one Data subtree while copying every recursively nested index."""
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        destination = target / child.name
        if child.is_file() and child.name == "index.idx":
            shutil.copy2(child, destination)
        elif child.is_dir() and any(child.rglob("index.idx")):
            overlay_data_tree(child, destination)
        else:
            symlink(child, destination)


def overlay_data_root(source: Path, target: Path, excluded: set[str]) -> None:
    """Overlay Data while keeping every writable type index fixture-local."""
    target.mkdir(parents=True, exist_ok=True)
    for child in source.iterdir():
        if child.name in excluded:
            continue
        destination = target / child.name
        if child.is_dir():
            overlay_data_tree(child, destination)
        elif child.name == "index.idx":
            shutil.copy2(child, destination)
        else:
            symlink(child, destination)


def read_7bit_int(data: bytes, offset: int) -> tuple[int, int]:
    value = 0
    shift = 0
    while True:
        if offset >= len(data) or shift >= 35:
            raise ValueError("invalid .NET 7-bit integer")
        byte = data[offset]
        offset += 1
        value |= (byte & 0x7F) << shift
        if byte < 0x80:
            return value, offset
        shift += 7


def write_7bit_int(value: int) -> bytes:
    result = bytearray()
    while value >= 0x80:
        result.append((value & 0x7F) | 0x80)
        value >>= 7
    result.append(value)
    return bytes(result)


def tile_node(data: bytes, offset: int = 0) -> tuple[bytes, int]:
    if offset + 8 > len(data):
        raise ValueError("truncated PMDO tile node")
    _, count = struct.unpack_from("<ii", data, offset)
    end = offset + 8 + count * 16
    if count < 0 or end > len(data):
        raise ValueError("invalid PMDO tile node")
    return data[offset:end], end


def read_tile_index(path: Path) -> dict[str, bytes]:
    data = path.read_bytes()
    if len(data) < 4:
        raise ValueError("truncated PMDO tile index")
    count = struct.unpack_from("<i", data)[0]
    if count < 0:
        raise ValueError("negative PMDO tile-index count")
    offset = 4
    nodes: dict[str, bytes] = {}
    for _ in range(count):
        length, offset = read_7bit_int(data, offset)
        end = offset + length
        if end > len(data):
            raise ValueError("truncated PMDO tile-index name")
        name = data[offset:end].decode("utf-8")
        if not name or name in nodes:
            raise ValueError(f"empty or duplicate PMDO tile-index name: {name!r}")
        offset = end
        node, offset = tile_node(data, offset)
        nodes[name] = node
    if offset != len(data):
        raise ValueError("trailing bytes in PMDO tile index")
    return nodes


def write_tile_index(path: Path, nodes: dict[str, bytes]) -> None:
    output = bytearray(struct.pack("<i", len(nodes)))
    for name, node in nodes.items():
        encoded = name.encode("utf-8")
        output.extend(write_7bit_int(len(encoded)))
        output.extend(encoded)
        output.extend(node)
    path.write_bytes(output)


def footprint_clear(obstacles: list[list[dict[str, Any]]], x: int, y: int) -> bool:
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    if x < 0 or y < 0 or x + 1 >= width or y + 1 >= height:
        return False
    return all(obstacles[ix][iy]["Tags"] == 0 for ix in (x, x + 1) for iy in (y, y + 1))


def choose_spawn(obstacles: list[list[dict[str, Any]]]) -> tuple[int, int, int]:
    """Choose a 16px footprint, preferring four-way movement near map center."""
    width = len(obstacles)
    height = len(obstacles[0]) if width else 0
    choices: list[tuple[int, float, int, int]] = []
    for x in range(width - 1):
        for y in range(height - 1):
            if not footprint_clear(obstacles, x, y):
                continue
            move_count = sum(
                footprint_clear(obstacles, x + dx, y + dy)
                for dx, dy in ((0, -1), (1, 0), (0, 1), (-1, 0))
            )
            distance = (x + 0.5 - width / 2) ** 2 + (y + 0.5 - height / 2) ** 2
            choices.append((-move_count, distance, x, y))
    if not choices:
        raise ValueError("no clear 16x16 collision footprint")
    neg_moves, _, x, y = min(choices)
    return x * 8, y * 8, -neg_moves


def marker(x: int, y: int) -> dict[str, Any]:
    return {
        "EntName": "Main_Entrance_Marker",
        "Direction": 0,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 0,
        "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16},
    }


def fixture_ground(source: Path, target: Path) -> dict[str, int]:
    payload = read_json(source)
    ground = payload["Object"]
    x, y, move_count = choose_spawn(ground["obstacles"])
    layers = ground["Entities"]
    if not layers:
        layers.append({
            "Name": "Validation PMDO isolée", "Visible": True, "MapChars": [],
            "GroundObjects": [], "Spawners": [], "Markers": [],
        })
    for layer in layers:
        layer["Markers"] = [
            item for item in layer.get("Markers", [])
            if item.get("EntName") != "Main_Entrance_Marker"
        ]
    layers[0].setdefault("Markers", []).append(marker(x, y))
    ground["Comment"] = (
        ground.get("Comment", "")
        + " [FIXTURE IGNORÉE: marqueur déterministe injecté sur copie; source intacte.]"
    )
    write_json_bom(target, payload)
    return {"x": x, "y": y, "clear_move_directions": move_count}


def ground_script(asset: str) -> str:
    return f"""-- Fixture PMDO ignorée; n'altère pas le script canonique ou le candidat source.
require 'origin.common'
local Adapter = require 'halcyon.ground.{asset}.animation_callbacks'
local M = {{}}
function M.Init(map)
  DEBUG.EnableDbgCoro()
  Adapter.Init(map)
end
function M.Enter(map) end
function M.Exit(map) Adapter.Exit(map) end
function M.Update(map) Adapter.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
"""


def validator_script(entries: list[dict[str, Any]]) -> str:
    rows = "\n".join(
        " {id='%s',zone='master_zone',idx=%d,ticks={%s}}," % (
            item["id"], item["zone_index"],
            ",".join(str(tick) for tick in item["preview_ticks"]),
        )
        for item in entries
    )
    return f"""-- Generated ignored fixture validator for all direct PMD Red EU Grounds.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('PmdRedEuGroundValidator',BaseService)
local PILOT={{
{rows}
}}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\\\','\\\\\\\\'):gsub('"','\\\\"'):gsub('\\n',' | ')end
local function emit(s)
 PrintInfo('[PMDRED_EU_VALIDATOR] '..s)
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','a');if f then f:write(s..'\\n');f:flush();f:close() end
end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='pmdred_eu_fixture'
 local only=os.getenv('PMDO_GROUND_VALIDATOR_ONLY')
 if only and only~='' then
  for _,item in ipairs(PILOT) do if item.id==only then PILOT={{item,item}};break end end
 end
 self.idx=0;self.busy=false;self.task=nil
end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 local f=io.open('/tmp/pmdred_eu_ground_validator.jsonl','w');if f then f:close() end
 self.idx=1
 emit('{{"event":"begin","count":'..#PILOT..'}}')
 GAME:EnterZone(PILOT[1].zone,-1,PILOT[1].idx,0)
end
local function screenshot(id,phase)
 emit('{{"event":"screenshot_requested","ground":"'..id..'","phase":"'..phase..'"}}')
 _GROUND:Screenshot()
 GAME:WaitFrames(4)
 emit('{{"event":"screenshot_completed","ground":"'..id..'","phase":"'..phase..'"}}')
end
function V:validate_async()
 local item=PILOT[self.idx]
 local id=item.id
 local map=safe(function()return GAME:GetCurrentGround()end,nil)
 local hero=CH('PLAYER')
 if not map or not hero then error('map_or_hero_nil') end
 local Scheduler=require 'halcyon.RedDirectGroundAnimation'
 GAME:WaitFrames(8)
 local active0=safe(function()return Scheduler.ActiveAsset()end,'nil')
 local x=safe(function()return hero.Position.X end,-1)
 local y=safe(function()return hero.Position.Y end,-1)
 local moves={{}};local deltas={{}}
 for _,d in ipairs({{Direction.Up,Direction.Right,Direction.Down,Direction.Left}}) do
  GROUND:MoveInDirection(hero,d,8,false,2);GAME:WaitFrames(2)
  local nx=safe(function()return hero.Position.X end,x)
  local ny=safe(function()return hero.Position.Y end,y)
  moves[#moves+1]=(nx~=x or ny~=y) and 1 or 0
  deltas[#deltas+1]=string.format('"%d,%d"',nx-x,ny-y)
  GROUND:TeleportTo(hero,x,y,Direction.Down);GAME:WaitFrames(2)
 end
 local count=moves[1]+moves[2]+moves[3]+moves[4]
 -- Pause and seek exact canonical CANM ticks.  Keeping the actor outside the
 -- full-map target makes comparative PNGs contain map pixels only.
 local paused=Scheduler.Pause(map)
 GAME:WaitFrames(2)
 GROUND:TeleportTo(hero,-64,-64,Direction.Down);GAME:WaitFrames(1)
 local sampled={{}}
 local seek_ok=paused
 for _,tick in ipairs(item.ticks) do
  seek_ok=Scheduler.Seek(map,tick) and seek_ok
  sampled[#sampled+1]=tostring(safe(function()return Scheduler.CurrentTick()end,-1))
  screenshot(id,'tick_'..tostring(tick))
 end
 GROUND:TeleportTo(hero,x,y,Direction.Down)
 local resumed=Scheduler.Resume(map)
 GAME:WaitFrames(4)
 local active1=safe(function()return Scheduler.ActiveAsset()end,'nil')
 local animation=(active0==id and active1==id and seek_ok and resumed) and 'ANIMATION_SAMPLED_LIFECYCLE_PASS' or 'ANIMATION_LIFECYCLE_FAIL'
 local verdict=(count>0 and animation=='ANIMATION_SAMPLED_LIFECYCLE_PASS') and 'SAFE' or 'NEEDS_REPAIR'
 emit(string.format('{{"ground":"%s","load":"LOAD_PASS","spawn":{{"x":%d,"y":%d}},"move_dirs":[%d,%d,%d,%d],"move_deltas":[%s],"movement_probe":"%s","animation_probe":"%s","sampled_ticks":[%s],"verdict":"%s"}}',id,x,y,moves[1],moves[2],moves[3],moves[4],table.concat(deltas,','),count>0 and 'MOVEMENT_PASS' or 'SPAWN_ISOLATED',animation,table.concat(sampled,','),verdict))
end
function V:advance()
 local leaving=PILOT[self.idx]
 self.idx=self.idx+1
 if self.idx>#PILOT then
  local Scheduler=require 'halcyon.RedDirectGroundAnimation'
  local map=safe(function()return GAME:GetCurrentGround()end,nil)
  local cleaned=Scheduler.Cancel(map)
  local active=safe(function()return Scheduler.ActiveAsset()end,nil)
  emit('{{"event":"final_cleanup","cleanup":"'..((cleaned and active==nil) and 'PASS' or 'FAIL')..'"}}')
  emit('{{"event":"end"}}');self.busy=false;self.task=nil
 else
  self.exiting=leaving.id
  GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0);self.busy=false;self.task=nil
 end
end
function V:OnGroundMapExit()
 local Scheduler=require 'halcyon.RedDirectGroundAnimation'
 local active=safe(function()return Scheduler.ActiveAsset()end,nil)
 emit('{{"event":"ground_exit","ground":"'..quote(self.exiting or 'unknown')..'","cleanup":"'..(active==nil and 'PASS' or 'FAIL')..'"}}')
 self.exiting=nil
end
function V:OnGroundMapEnter()
 if not self.enabled or self.busy or self.idx<1 or self.idx>#PILOT then return end
 self.busy=true
 emit('{{"event":"ground_entered","ground":"'..PILOT[self.idx].id..'","scheduler":"TASK_BRANCH"}}')
 self.task=TASK:BranchCoroutine(function()
  local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
  if not ok then emit('{{"ground":"'..PILOT[self.idx].id..'","verdict":"RUNTIME_FAIL","error":"'..quote(err)..'"}}') end
  self:advance()
 end)
end
function V:OnInit()
 if self.enabled then
  emit('{{"event":"bootstrap_new_game"}}')
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
 end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('PmdRedEuGroundValidator',EngineServiceEvents.GroundMapExit,function()self.OnGroundMapExit(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('PmdRedEuGroundValidator',V:new())
return V
"""


def build(root: Path, output: Path) -> Path:
    reserve = root / "RESERVE/pmdred_direct"
    quest = output / "quest"
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)

    symlink(root / "Mod.xml", quest / "Mod.xml")
    symlink(root / "Strings", quest / "Strings")

    overlay_data_root(root / "Data", quest / "Data", {"Ground", "Zone", "Script", "Misc"})
    # Indexing writes Zone/index.idx and may rewrite triggered universal data.
    # Keep both destinations as real fixture files/directories, never symlinks.
    shutil.copytree(root / "Data/Misc", quest / "Data/Misc")
    overlay_children(
        root / "Data/Ground", quest / "Data/Ground",
        {f"{asset}.rsground" for asset in CANDIDATES},
    )
    # Deliberately sparse: PMDO 0.8.12's zone indexer cannot deserialize a few
    # unrelated legacy quest zones. Runtime fallback still supplies base zones;
    # this fixture only needs to override master_zone's routing summary.
    (quest / "Data/Zone").mkdir(parents=True, exist_ok=True)
    overlay_children(root / "Data/Script", quest / "Data/Script", {"halcyon"})
    overlay_children(
        root / "Data/Script/halcyon", quest / "Data/Script/halcyon",
        {"ground", "services"},
    )
    overlay_children(
        root / "Data/Script/halcyon/ground", quest / "Data/Script/halcyon/ground",
        set(CANDIDATES),
    )
    overlay_children(
        root / "Data/Script/halcyon/services", quest / "Data/Script/halcyon/services",
        {"ground_gameplay_validator"},
    )

    overlay_children(root / "Content", quest / "Content", {"Tile"})
    tile_names = {asset + SHEET_SUFFIX for asset in CANDIDATES}
    # Content indexing writes Tile/index.idx.  Keep that destination fixture-local
    # rather than exposing the tracked index through a writable symlink.
    overlay_children(
        root / "Content/Tile", quest / "Content/Tile", tile_names | {"index.idx"}
    )

    tile_nodes = read_tile_index(root / "Content/Tile/index.idx")
    zone_payload = read_json(root / "Data/Zone/master_zone.json")
    ground_maps = zone_payload["Object"]["GroundMaps"]
    manifest_entries: list[dict[str, Any]] = []
    for asset in CANDIDATES:
        source_ground = reserve / "grounds" / f"{asset}.rsground"
        spawn = fixture_ground(source_ground, quest / "Data/Ground" / source_ground.name)
        source_tile = reserve / "tiles" / f"{asset}{SHEET_SUFFIX}"
        symlink(source_tile, quest / "Content/Tile" / source_tile.name)
        tile_payload = source_tile.read_bytes()
        node, tile_end = tile_node(tile_payload)
        # A .tile content file continues after its indexable node with an
        # engine texture count/reserved pair and PNG payloads.  Verify that
        # boundary rather than mistaking the content body for index bytes.
        if tile_payload[tile_end + 8:tile_end + 16] != b"\x89PNG\r\n\x1a\n":
            raise ValueError(f"{source_tile}: missing PNG payload after tile index node")
        previous = tile_nodes.get(source_tile.stem)
        if previous is not None and previous != node:
            raise ValueError(f"refusing to replace conflicting tile index node {source_tile.stem}")
        tile_nodes[source_tile.stem] = node

        script_dir = quest / "Data/Script/halcyon/ground" / asset
        script_dir.mkdir(parents=True)
        (script_dir / "init.lua").write_text(ground_script(asset), encoding="utf-8")
        for name in ("animation_metadata.lua", "animation_callbacks.lua"):
            symlink(reserve / "scripts" / asset / name, script_dir / name)

        if asset not in ground_maps:
            ground_maps.append(asset)
        animation = read_json(
            root / "docs/pmdred_eu/dungeon_grounds" / asset / "animation.json"
        )
        preview_ticks = animation["preview"]["frame_start_ticks"]
        manifest_entries.append({
            "id": asset,
            "zone_index": ground_maps.index(asset),
            "spawn": spawn,
            "preview_ticks": preview_ticks,
            "source_ground": str(source_ground.relative_to(root)),
            "source_tile": str(source_tile.relative_to(root)),
        })

    fixture_tile_index = quest / "Content/Tile/index.idx"
    write_tile_index(fixture_tile_index, tile_nodes)
    reloaded_tile_nodes = read_tile_index(fixture_tile_index)
    if reloaded_tile_nodes != tile_nodes:
        raise ValueError("fixture tile index failed exact write/read verification")
    expected_sheet_nodes = {Path(name).stem for name in tile_names}
    missing_sheets = sorted(expected_sheet_nodes - set(reloaded_tile_nodes))
    if missing_sheets:
        raise ValueError(f"fixture tile index omitted candidate sheets: {missing_sheets}")

    source_indexes = sorted(root.glob("Data/**/index.idx"))
    exposed_indexes = [
        path for path in quest.glob("Data/**/index.idx")
        if path.is_symlink()
    ]
    if exposed_indexes:
        raise ValueError(f"writable Data indexes remain symlinked: {exposed_indexes}")
    copied_source_indexes = [
        path for path in source_indexes
        if path.relative_to(root / "Data").parts[0] not in {"Ground", "Zone", "Script", "Misc"}
    ]
    for source_index in copied_source_indexes:
        fixture_index = quest / "Data" / source_index.relative_to(root / "Data")
        if not fixture_index.is_file() or fixture_index.is_symlink():
            raise ValueError(f"Data index is not fixture-local: {fixture_index}")
        if fixture_index.read_bytes() != source_index.read_bytes():
            raise ValueError(f"Data index copy differs before indexing: {fixture_index}")

    write_json_bom(quest / "Data/Zone/master_zone.json", zone_payload)
    service_dir = quest / "Data/Script/halcyon/services/ground_gameplay_validator"
    service_dir.mkdir(parents=True)
    (service_dir / "init.lua").write_text(validator_script(manifest_entries), encoding="utf-8")

    manifest = {
        "kind": "ignored_symlink_overlay",
        "quest": str(quest),
        "candidate_count": len(manifest_entries),
        "master_zone_ground_count": len(ground_maps),
        "entries": manifest_entries,
    }
    (output / "fixture_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return quest


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output", type=Path,
        default=Path(".runtime-cache/pmdred-eu-fixture"),
        help="ignored fixture output directory",
    )
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = args.output if args.output.is_absolute() else root / args.output
    quest = build(root, output)
    print(quest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
