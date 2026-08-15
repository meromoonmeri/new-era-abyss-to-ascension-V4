#!/usr/bin/env python3
"""Build a fresh create-only Tiny Woods semantic fixture from the palette overlay."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from datetime import datetime
from pathlib import Path
from types import ModuleType
from typing import Any
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
SUPPLEMENT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json"
VALIDATOR = ROOT / "tools/pmdred_tiny_woods_command_semantic_validator_v3.lua"


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
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def expected_row(row: dict[str, Any]) -> str:
    return "{address=%s,array_id=%s,source_index=%d,op=%d,arg_byte=%d,arg_short=%d,arg1=%d,arg2=%d,handler=%s,category=%s,api=%s,route_class=%s,source_frames=%d}" % (
        lua(row["address"]), lua(row["array_id"]), row["source_index"], row["op"], row["arg_byte"], row["arg_short"],
        row["arg1"], row["arg2"], lua(row["pmdo_handler"]), lua(row["semantic_category"]), lua(row["pmdo_api"]),
        lua(row["route_class"]), row["source_frames"],
    )


def adapter_module(rows: list[dict[str, Any]], fault_ordinal: int | None) -> str:
    encoded = []
    for row in rows:
        address = row["address"]
        if fault_ordinal == row["ordinal"]:
            address = "FAULT_" + address
        encoded.append(
            "  {ordinal=%d,address=%s,array_id=%s,source_index=%d,op=%d,arg_byte=%d,arg_short=%d,arg1=%d,arg2=%d,handler=%s,category=%s,api=%s,route_class=%s,source_frames=%d}," % (
                row["ordinal"], lua(address), lua(row["array_id"]), row["source_index"], row["op"], row["arg_byte"],
                row["arg_short"], row["arg1"], row["arg2"], lua(row["pmdo_handler"]), lua(row["semantic_category"]),
                lua(row["pmdo_api"]), lua(row["route_class"]), row["source_frames"],
            )
        )
    return """-- Address-gated PMD Red EU Tiny Woods semantic adapter v3.
-- Non-wait commands expose authenticated metadata for actor-context integration;
-- WAIT commands additionally execute their exact source duration natively.
local GraphicsManagerType=luanet.import_type('RogueEssence.Content.GraphicsManager')
local ROWS={
%s
}
local Adapter={}
local function ticks() return tonumber(GraphicsManagerType.TotalFrameTick) or 0 end
local function trace(kind,r,beforeTick,afterTick,elapsed)
  if PMDRED_TINY_WOODS_COMMAND_SEMANTIC_TRACE then
    return PMDRED_TINY_WOODS_COMMAND_SEMANTIC_TRACE(kind,r.ordinal,r.address,r.array_id,r.source_index,r.op,r.arg_byte,r.arg_short,r.arg1,r.arg2,r.handler,r.category,r.api,r.route_class,r.source_frames,beforeTick,afterTick,elapsed)
  end
  return false
end
function Adapter.Execute(mode)
  local executed=0
  -- Ground Enter can begin at tick zero, where PMDO's first coroutine wait
  -- consumes the bootstrap tick.  Advance that harness-only tick before any
  -- authenticated command so every source WAIT retains exact tick accounting.
  if ticks()==0 then GAME:WaitFrames(2) end
  for _,r in ipairs(ROWS) do
    if mode=='semantic_all_v3' or r.route_class=='selected_route' then
      local before=ticks()
      if trace('semantic_start',r,before,before,0)~=true then return executed,false end
      if r.op==0xDB then GAME:WaitFrames(r.source_frames) end
      local after=ticks();local elapsed=math.floor((after-before)/120)
      if trace('semantic_complete',r,before,after,elapsed)~=true then return executed,false end
      executed=executed+1
    end
  end
  return executed,true
end
function Adapter.Count() return #ROWS end
return Adapter
""" % "\n".join(encoded)


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if text.count(old) != 1:
        raise ValueError(f"semantic integration boundary differs: {label} ({text.count(old)} matches)")
    return text.replace(old, new)


def update_file_record(group: dict[str, Any], relative: str, path: Path) -> None:
    if relative in group:
        group[relative] = {"bytes": path.stat().st_size, "sha256": sha256(path)}


def build(output: Path, music_source: Path, fanfare_source: Path, fault_ordinal: int | None = None) -> dict[str, Any]:
    output = output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite semantic fixture: {output}")
    supplement = json.loads(SUPPLEMENT.read_text(encoding="utf-8"))
    if supplement.get("schema") != "pmdred-eu-tiny-woods-command-semantic-supplement-v3":
        raise ValueError("semantic supplement schema differs")
    if fault_ordinal is not None and not 0 <= fault_ordinal < 304:
        raise ValueError("fault ordinal must address one of 304 commands")

    base = load_tool("build_pmdred_tiny_woods_palette_overlay")
    base.build(output, music_source, fanfare_source)
    script = output / "quest/Data/Script/halcyon"
    adapter = script / "pmdred_command_semantic_adapter_v3.lua"
    adapter.write_text(adapter_module(supplement["commands"], fault_ordinal), encoding="utf-8")

    campaign = script / "pmdred_tiny_woods_command_campaign.lua"
    text = campaign.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "local Palette=require 'halcyon.pmdred_palette_adapter'\n",
        "local Palette=require 'halcyon.pmdred_palette_adapter'\nlocal CommandSemanticV3=require 'halcyon.pmdred_command_semantic_adapter_v3'\n",
        "campaign adapter import",
    )
    semantic_entry = """function Campaign.RunCommandSemanticV3(mode)
  Campaign.TraceAllCommands()
  local executed,ok=CommandSemanticV3.Execute(mode)
  if PMDRED_TINY_WOODS_COMMAND_SEMANTIC_CHECKPOINT then PMDRED_TINY_WOODS_COMMAND_SEMANTIC_CHECKPOINT(executed,ok) end
end
"""
    text = replace_once(text, "return Campaign\n", semantic_entry + "return Campaign\n", "campaign entry")
    campaign.write_text(text, encoding="utf-8")

    ground = script / "ground/d01p01/init.lua"
    text = ground.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "function M.Enter(map)\n  if os.getenv('TINY_WOODS_COMMAND_MODE')=='palette_adapter_all' then Campaign.RunSemanticAdapterCertification();return end\n",
        "function M.Enter(map)\n  local semanticMode=os.getenv('TINY_WOODS_COMMAND_MODE')\n  if semanticMode=='semantic_selected_v3' or semanticMode=='semantic_all_v3' then Campaign.RunCommandSemanticV3(semanticMode);return end\n  if semanticMode=='palette_adapter_all' then Campaign.RunSemanticAdapterCertification();return end\n",
        "Ground semantic dispatch",
    )
    ground.write_text(text, encoding="utf-8")

    service = script / "services/tiny_woods_command_semantic_v3_validator/init.lua"
    service.parent.mkdir(parents=True)
    validator_text = VALIDATOR.read_text(encoding="utf-8")
    validator_text = validator_text.replace("@@LAUNCHER_GROUND_INDEX@@", "308")
    validator_text = validator_text.replace("@@SEMANTIC_EXPECTED_ROWS@@", ",\n".join(expected_row(row) for row in supplement["commands"]))
    if "@@" in validator_text:
        raise ValueError("unresolved semantic validator template token")
    service.write_text(validator_text, encoding="utf-8")

    main_lua = script / "main.lua"
    main_text = main_lua.read_text(encoding="utf-8")
    main_text = replace_once(
        main_text,
        "require 'halcyon.services.ground_gameplay_validator'--opt-in: PMDO_GROUND_VALIDATOR=1 uniquement\n",
        "require 'halcyon.services.ground_gameplay_validator'--opt-in: PMDO_GROUND_VALIDATOR=1 uniquement\nrequire 'halcyon.services.tiny_woods_command_semantic_v3_validator'--opt-in exact EU semantic proof v3\n",
        "semantic validator service require",
    )
    if main_lua.is_symlink():
        main_lua.unlink()
    main_lua.write_text(main_text, encoding="utf-8")

    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    for section in ("tiny_woods_command_complete", "tiny_woods_palette_semantics"):
        group = manifest[section]["files"]
        for path in (campaign, ground):
            update_file_record(group, str(path.relative_to(output)), path)
    manifest["tiny_woods_command_semantic_v3"] = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-overlay-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(),
        "authority": {
            "region": "EU",
            "rom_sha256": supplement["authority"]["rom_sha256"],
            "command_plan_sha256": supplement["authority"]["command_plan_sha256"],
            "supplement_sha256": sha256(SUPPLEMENT),
        },
        "commands": 304,
        "selected_route": 251,
        "retry_only": 53,
        "source_waits": 108,
        "source_wait_frames": 3001,
        "fault_injection": None if fault_ordinal is None else {"kind": "address_mismatch", "ordinal": fault_ordinal},
        "certification_eligible": fault_ordinal is None,
        "adapter": {"path": str(adapter.relative_to(output)), "bytes": adapter.stat().st_size, "sha256": sha256(adapter)},
        "validator": {
            "source": str(VALIDATOR.relative_to(ROOT)), "source_sha256": sha256(VALIDATOR),
            "path": str(service.relative_to(output)), "bytes": service.stat().st_size, "sha256": sha256(service),
            "opt_in": "PMDO_GROUND_VALIDATOR=tiny_woods_command_semantic_v3",
        },
        "files": {
            str(path.relative_to(output)): {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in (adapter, campaign, ground, service, main_lua)
        },
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_OVERLAY_V3_READY "
        f"output={output} commands=304 fault_ordinal={fault_ordinal}"
    )
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--music-source", type=Path, required=True)
    parser.add_argument("--fanfare-source", type=Path, required=True)
    parser.add_argument("--fault-ordinal", type=int)
    args = parser.parse_args()
    build(args.output, args.music_source, args.fanfare_source, args.fault_ordinal)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
