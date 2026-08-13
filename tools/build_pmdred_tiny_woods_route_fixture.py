#!/usr/bin/env python3
"""Build a create-only Tiny Woods opening/clear/retry/rescue fixture.

The overlay extends the already authenticated Tiny Woods procedural fixture.  It
adds only the two EU-backed Grounds and fixture-local Lua needed to prove route
semantics in exact PMDO 0.8.12.  In particular, the shared Script symlink is
materialized before any write so this builder can never modify repository or
candidate scripts through the overlay.
"""

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
ENDING_GROUND = ROOT / "RESERVE/pmdred_direct/grounds/d01p02.rsground"
ENDING_TILE = ROOT / "RESERVE/pmdred_direct/tiles/d01p02_DirectBase.tile"
ROUTE_MODULE = ROOT / "tools/pmdred_tiny_woods_route_fixture.lua"
ROUTE_VALIDATOR = ROOT / "tools/pmdred_tiny_woods_route_validator.lua"
ENDING_MUSIC = ROOT / "Content/Music/In the Depths of the Pit.ogg"
ENDING_GROUND_SHA256 = "ce2e109b082a5a6986fb5768ea315b60dfb5549d882f2f11908842b37e52e47e"
ENDING_TILE_SHA256 = "0aff40efcb0a42849495510eac868402245e0489876da595511b28b74466350f"
ENDING_MUSIC_SHA256 = "4b22c99be63e4ec61055c9a32ea0951e4910132551a8258f58fe2f1a6f9d9cd2"
ZONE_SHA256 = "e4f3edaf4af60bc625ce8e5c3b9d1d36372c2a1b009b4b1d21d13774e7eb92f7"
VALIDATOR_MODE = "tiny_woods_route_fixture"

D01P01_SCRIPT = r"""-- Fixture-local PMD Red EU Tiny Woods opening/retry relay.
require 'origin.common'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local d01p01 = {}
function d01p01.Init(map) DEBUG.EnableDbgCoro() end
function d01p01.Enter(map)
  Route.DispatchGround('d01p01')
  SOUND:StopBGM()
end
function d01p01.Exit(map) end
function d01p01.Update(map) end
function d01p01.GameSave(map) end
function d01p01.GameLoad(map) end
return d01p01
"""

D01P02_SCRIPT = r"""-- Fixture-local PMD Red EU Tiny Woods Caterpie ending relay.
require 'origin.common'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local d01p02 = {}
local managed = {}
local function remove_managed()
  local map = GAME:GetCurrentGround()
  for _, chara in ipairs(managed) do
    pcall(function() if chara ~= nil then map:RemoveTempChar(chara) end end)
  end
  managed = {}
end
local function add_actor(chara)
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  local result = RogueEssence.Script.TriggerResult()
  TASK:WaitTask(chara:RunEvent(
    RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
  AI:DisableCharacterAI(chara)
  table.insert(managed, chara)
end
local function spawn_scene_cast()
  remove_managed()
  local partnerData = GAME:GetPlayerPartyMember(1)
  if partnerData == nil then error('Tiny Woods route fixture requires the canonical partner slot') end
  add_actor(RogueEssence.Ground.GroundChar(
    partnerData, RogueElements.Loc(196, 276), Direction.Down, 'PARTNER'))
  local caterpieID = RogueEssence.Dungeon.MonsterID(
    'caterpie', 0, 'normal', RogueEssence.Data.Gender.Unknown)
  add_actor(RogueEssence.Ground.GroundChar(
    caterpieID, RogueElements.Loc(180, 148), Direction.Down, 'Caterpie', 'CATERPIE'))
end
function d01p02.Init(map) DEBUG.EnableDbgCoro() end
function d01p02.Enter(map)
  local group = Route.DispatchGround('d01p02')
  if group == 'g1' then
    spawn_scene_cast()
    SOUND:PlayBGM('In the Depths of the Pit.ogg', false)
  else
    remove_managed()
    SOUND:StopBGM()
  end
end
function d01p02.Exit(map)
  remove_managed()
  SOUND:StopBGM()
end
function d01p02.Update(map) end
function d01p02.GameSave(map) end
function d01p02.GameLoad(map) end
return d01p02
"""

ZONE_SCRIPT = r"""-- Fixture-local PMD Red EU Tiny Woods route bridge.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local tiny_woods = {}
function tiny_woods.Init(zone) DEBUG.EnableDbgCoro() end
function tiny_woods.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
  GAME:SetRescueAllowed(false)
end
function tiny_woods.Rescued(zone, name, mail) COMMON.Rescued(zone, name, mail) end
function tiny_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  local destination = Route.ExitSegment(result, segmentID, mapID)
  if destination == 'd01p02' then
    GAME:EnterGroundMap('d01p02', 'Main_Entrance_Marker')
  else
    GeneralFunctions.EndDungeonRun(result, 'tiny_woods', -1, 0, 0, false, false)
  end
end
return tiny_woods
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
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def dump_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def marker(name: str, x: int, y: int, direction: int = 0) -> dict[str, Any]:
    """Create a PMDO marker facing Down (EU/GBA source direction code 4)."""
    return {
        "EntName": name,
        "Direction": direction,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 0,
        "EntityCallbacks": [],
        "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16},
    }


def install_marker(ground: dict[str, Any], *, x: int, y: int) -> None:
    layers = ground["Object"]["Entities"]
    if not layers:
        raise ValueError("Ground has no entity layer")
    markers = layers[0].setdefault("Markers", [])
    markers[:] = [item for item in markers if item.get("EntName") != "Main_Entrance_Marker"]
    markers.append(marker("Main_Entrance_Marker", x, y))


def materialize_script_tree(fixture: Path) -> Path:
    """Privatize the writable zone-script parent in the sparse overlay."""
    script = fixture / "quest/Data/Script"
    if script.is_symlink() or not script.is_dir():
        raise ValueError("base fixture Script root is not the expected private overlay directory")
    zone_parent = script / "halcyon/zone"
    if not zone_parent.is_symlink():
        raise ValueError("base fixture zone-script parent is not the expected shared symlink")
    source = zone_parent.resolve(strict=True)
    zone_parent.unlink()
    shutil.copytree(source, zone_parent, symlinks=False)
    if zone_parent.is_symlink() or not zone_parent.is_dir():
        raise RuntimeError("failed to privatize fixture zone-script parent")
    return script


def build(output: Path) -> dict[str, Any]:
    output = output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite route fixture: {output}")
    if sha256(ENDING_GROUND) != ENDING_GROUND_SHA256:
        raise ValueError("authenticated d01p02 Ground hash differs")
    if sha256(ENDING_TILE) != ENDING_TILE_SHA256:
        raise ValueError("authenticated d01p02 tile hash differs")
    if sha256(ENDING_MUSIC) != ENDING_MUSIC_SHA256:
        raise ValueError("official ending-scene music hash differs")
    if not ROUTE_VALIDATOR.is_file():
        raise FileNotFoundError(ROUTE_VALIDATOR)

    native_builder = load_tool("build_pmdred_tiny_woods_runtime_fixture")
    native_builder.build(
        output,
        native_builder.DEFAULT_CANDIDATES,
        native_builder.DEFAULT_PLAN,
    )
    quest = output / "quest"
    base_manifest = load_json(output / "fixture_manifest.json")
    script = materialize_script_tree(output)

    # Preserve the authenticated zone generation graph byte-for-byte except for
    # the required ending Ground map list.
    zone_path = quest / "Data/Zone/tiny_woods.json"
    if sha256(zone_path) != ZONE_SHA256:
        raise ValueError("authenticated Tiny Woods ZoneData differs before route extension")
    zone = load_json(zone_path)
    zone["Object"]["GroundMaps"] = ["d01p01", "d01p02"]
    dump_json(zone_path, zone)

    d01p01_path = quest / "Data/Ground/d01p01.rsground"
    d01p01 = load_json(d01p01_path)
    install_marker(d01p01, x=200, y=196)
    dump_json(d01p01_path, d01p01)

    d01p02_path = quest / "Data/Ground/d01p02.rsground"
    d01p02 = load_json(ENDING_GROUND)
    install_marker(d01p02, x=164, y=276)
    dump_json(d01p02_path, d01p02)

    # Ground-layer sheets are Content/Tile assets, not dungeon effect Data/Tile
    # records.  Extend the fixture-local binary content index with the exact
    # direct-render sheet node so PMDO cannot silently draw a missing texture.
    base_builder = native_builder.load_base_builder()
    tile_destination = quest / "Content/Tile/d01p02_DirectBase.tile"
    shutil.copyfile(ENDING_TILE, tile_destination)
    tile_payload = tile_destination.read_bytes()
    tile_node, tile_end = base_builder.tile_node(tile_payload)
    if tile_payload[tile_end + 8 : tile_end + 16] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("d01p02 direct Tile has no PNG body at its indexed boundary")
    tile_index = quest / "Content/Tile/index.idx"
    tile_nodes = base_builder.read_tile_index(tile_index)
    previous = tile_nodes.get(tile_destination.stem)
    if previous is not None and previous != tile_node:
        raise ValueError("refusing to replace a conflicting d01p02 Tile index node")
    tile_nodes[tile_destination.stem] = tile_node
    base_builder.write_tile_index(tile_index, tile_nodes)
    if base_builder.read_tile_index(tile_index).get(tile_destination.stem) != tile_node:
        raise ValueError("fixture Content/Tile index did not retain d01p02 direct node")

    route_target = script / "halcyon/pmdred_tiny_woods_route.lua"
    route_target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(ROUTE_MODULE, route_target)
    ground_root = script / "halcyon/ground"
    (ground_root / "d01p01").mkdir(parents=True, exist_ok=True)
    (ground_root / "d01p02").mkdir(parents=True, exist_ok=True)
    (ground_root / "d01p01/init.lua").write_text(D01P01_SCRIPT, encoding="utf-8")
    (ground_root / "d01p02/init.lua").write_text(D01P02_SCRIPT, encoding="utf-8")
    zone_script = script / "halcyon/zone/tiny_woods/init.lua"
    zone_script.parent.mkdir(parents=True, exist_ok=True)
    zone_script.write_text(ZONE_SCRIPT, encoding="utf-8")

    validator_target = script / "halcyon/services/ground_gameplay_validator/init.lua"
    validator_text = ROUTE_VALIDATOR.read_text(encoding="utf-8").replace(
        "@@LAUNCHER_GROUND_INDEX@@", "308"
    )
    validator_target.write_text(validator_text, encoding="utf-8")

    manifest_path = output / "fixture_manifest.json"
    manifest = load_json(manifest_path)
    manifest["tiny_woods_route"] = {
        "schema": "pmdred-eu-tiny-woods-route-fixture-v1",
        "date": str(date.today()),
        "authority": {
            "region": "EU",
            "rom_sha256": native_builder.EXPECTED_ROM_SHA256,
            "zone_generation_sha256_before_extension": ZONE_SHA256,
            "ending_ground_source": str(ENDING_GROUND.relative_to(ROOT)),
            "ending_ground_source_sha256": ENDING_GROUND_SHA256,
            "ending_tile_source": str(ENDING_TILE.relative_to(ROOT)),
            "ending_tile_source_sha256": ENDING_TILE_SHA256,
            "ending_music_source": str(ENDING_MUSIC.relative_to(ROOT)),
            "ending_music_source_sha256": ENDING_MUSIC_SHA256,
            "ending_bgm_eu_command": {
                "script": "d01p02:g1 station",
                "rom_address": "0x084D4C78",
                "opcode": "0x44",
                "music_id": 114,
                "technical_name": "MUS_IN_THE_DEPTHS_OF_THE_PIT",
            },
        },
        "route": {
            "opening": "d01p01:g1 -> tiny_woods segment 0",
            "failure": "failed segment -> d01p01:g2 -> retry",
            "clear": "cleared segment -> d01p02:g1",
            "rescue": "d01p02:g1 -> d01p01:g3",
            "master_zone_d01p01_index": 308,
            "tiny_woods_ground_maps": ["d01p01", "d01p02"],
            "ending_music": "In the Depths of the Pit.ogg",
            "silent_restrictions": True,
        },
        "placements": {
            "direction_translation": {
                "eu_gba_source_code": 4,
                "pmdo_name": "Down",
                "pmdo_serialized_value": 0,
            },
            "d01p01_hero": {"x": 200, "y": 196, "direction": "Down"},
            "d01p02_hero": {"x": 164, "y": 276, "direction": "Down"},
            "d01p02_partner": {"x": 196, "y": 276, "direction": "Down"},
            "d01p02_caterpie": {"x": 180, "y": 148, "direction": "Down"},
        },
        "fixture_isolation": {
            "script_root_is_overlay_directory": not script.is_symlink() and script.is_dir(),
            "zone_script_parent_is_symlink": (script / "halcyon/zone").is_symlink(),
            "zone_script_parent_private": not (script / "halcyon/zone").is_symlink()
            and (script / "halcyon/zone").is_dir(),
        },
        "validator": {
            "opt_in": f"PMDO_GROUND_VALIDATOR={VALIDATOR_MODE}",
            "source": str(ROUTE_VALIDATOR.relative_to(ROOT)),
            "source_sha256": sha256(ROUTE_VALIDATOR),
            "fixture_sha256": sha256(validator_target),
        },
        "files": {
            str(path.relative_to(output)): {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in (
                zone_path,
                d01p01_path,
                d01p02_path,
                tile_destination,
                tile_index,
                route_target,
                ground_root / "d01p01/init.lua",
                ground_root / "d01p02/init.lua",
                zone_script,
                validator_target,
            )
        },
    }
    dump_json(manifest_path, manifest)
    print(
        "TINY_WOODS_ROUTE_FIXTURE_READY "
        f"output={output} script_private=true grounds=d01p01,d01p02"
    )
    return manifest


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--output", type=Path, required=True)
    return result


def main() -> int:
    build(parser().parse_args().output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
