#!/usr/bin/env python3
"""Authenticate the EU-ROM route immediately after Tiny Woods.

This audit is intentionally scoped.  The European executable does not use the
same rescue-base group number or title-screen graph shape as the current
pret/pmd-red declarations:

* EU EVENT_M01E01A_L003 calls map-script 9 group 16 (not group 17);
* EU map-script 9 group 16 aligns to pret's technical group-17 declaration and
  selects graphical map 9, the basic Pikachu base (stable asset b01p00a);
* the EU event then calls regional title map-script 229 group 2.  That group is
  decoded directly from the ROM because pret's source-region title declaration
  has no corresponding group 2.

ROM bytes remain the content authority.  pret is used only to type and align
the rescue-base command arrays after the independently proven regional shift.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import subprocess
import sys
from collections import Counter
from pathlib import Path
from typing import Any, Sequence

ROOT = Path(__file__).resolve().parents[1]
GENERIC_AUDITOR = ROOT / "tools" / "audit_pmdred_eu_ground_scripts.py"
TOOL_VERSION = "1.0.0"
SCHEMA = "new-era.pmdred-eu-tiny-woods-post-route.v1"
EXPECTED_PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"


def load_generic():
    spec = importlib.util.spec_from_file_location("pmdred_ground_audit", GENERIC_AUDITOR)
    if spec is None or spec.loader is None:
        raise ImportError(GENERIC_AUDITOR)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


A = load_generic()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise A.AuditError(message)


def command_record(core: Any, pointer: int, address: int, index: int,
                   source_index: int | None = None, text_block: str | None = None) -> dict[str, Any]:
    return {
        "index": index,
        "address": A.address_hex(address),
        "op": core.op,
        "op_hex": f"0x{core.op:02X}",
        "arg_byte": core.arg_byte,
        "arg_short": core.arg_short,
        "arg1": core.arg1,
        "arg2": core.arg2,
        "pointer": A.address_hex(pointer) if pointer else None,
        "text_block": text_block,
        "categories": A.classify_command(core),
        "pret_source_index": source_index,
    }


def read_linear(reader: Any, root: int, expected: list[Any], context: str) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for index, wanted in enumerate(expected):
        address = root + index * A.SCRIPT_COMMAND_SIZE
        core, pointer = A.decode_command(reader, address, f"{context}[{index}]")
        require(core == wanted, f"{context}[{index}] differs: expected {wanted}, got {core}")
        require(pointer == 0, f"{context}[{index}] unexpectedly has pointer {A.address_hex(pointer)}")
        records.append(command_record(core, pointer, address, index))
    return records


def audit_event_route(reader: Any) -> dict[str, Any]:
    # This long sequence has one unique occurrence in the exact EU ROM.  It
    # starts after the region's omitted DEBUGINFO command.
    expected = [
        A.CommandCore(0x3B, 0x39, 4, 0, 0),
        A.CommandCore(0x1E, 0, 1, 184, 0),
        A.CommandCore(0x1E, 0, 3, 183, 0),
        A.CommandCore(0x1E, 0, 16, 9, 0),
        A.CommandCore(0x3B, 0x39, 1, 0, 0),
        A.CommandCore(0x1E, 0, 2, 229, 0),
        A.CommandCore(0x3B, 0x39, 0, 0, 0),
        A.CommandCore(0xB0, 1, 0, 0, 0),
        A.CommandCore(0xA9, 0, 4, 3, 0),
        A.CommandCore(0xE9, 0, 102, 0, 0),
    ]
    pattern = b"".join(
        bytes((core.op, core.arg_byte))
        + int(core.arg_short).to_bytes(2, "little", signed=True)
        + int(core.arg1).to_bytes(4, "little", signed=True)
        + int(core.arg2).to_bytes(4, "little", signed=True)
        + b"\0" * 12
        for core in expected
    )
    offsets: list[int] = []
    cursor = 0
    while True:
        found = reader.data.find(pattern, cursor)
        if found < 0:
            break
        offsets.append(found)
        cursor = found + 1
    require(len(offsets) == 1, f"EVENT_M01E01A_L003 signature occurrence count is {len(offsets)}, expected 1")
    root = A.ROM_BASE + offsets[0]
    records = read_linear(reader, root, expected, "EVENT_M01E01A_L003")
    return {
        "identity": "EVENT_M01E01A_L003",
        "address": A.address_hex(root),
        "command_count": len(records),
        "commands": records,
        "route": [
            {"order": 1, "regional_map_script_id": 184, "group": 1, "sector": 0,
             "stable_ground": "d01p02", "role": "Tiny Woods ending room"},
            {"order": 2, "regional_map_script_id": 183, "group": 3, "sector": 0,
             "stable_ground": "d01p01", "role": "Tiny Woods entry rescue ending"},
            {"order": 3, "regional_map_script_id": 9, "group": 16, "sector": 0,
             "selected_graphical_map_id": 9, "stable_ground": "b01p00a",
             "role": "basic Pikachu rescue-team base exterior and team formation"},
            {"order": 4, "regional_map_script_id": 229, "group": 2, "sector": 0,
             "selected_graphical_map_id": 229, "stable_ground": "s02",
             "pmdo_french_variant": "s02_fre", "role": "localized title interstitial"},
        ],
        "progression": {
            "rescue_dungeon_tiny_woods": "conquered",
            "scenario_main": [3, 0],
            "terminal": "EVENT_DIVIDE",
            "terminal_script_id": 102,
        },
        "validation": {"status": "pass", "unique_rom_signature": True},
    }


SOURCE_MAPPING = {
    ("T", 16, 0, 0, 0): "s_gs9_g17_s0_station_sref_script",
    ("F", 16, 0, 0, 0): "s_gs9_g17_s0_eff0_script",
    ("L", 16, 0, 0, 0): "s_gs9_g17_s0_lives0_dlg0",
    ("L", 16, 0, 1, 0): "s_gs9_g17_s0_lives1_dlg0",
    ("L", 16, 2, 0, 0): "s_gs9_g17_s2_lives0_dlg0",
    ("L", 16, 3, 0, 0): "s_gs9_g17_s3_lives0_dlg0",
}


def audit_rescue_base(reader: Any, pret_root: Path, compiler: str) -> dict[str, Any]:
    source_ref = A.compile_source_reference("b01p01a", pret_root, compiler)
    source = A.parse_source_structure(source_ref.structure_lines)
    eu = A.decode_eu_graph(reader, 9, source_ref.source_ground_id)
    require(eu["group_count"] == 48, f"EU map-script 9 group count changed: {eu['group_count']}")
    group = eu["groups"][16]
    source_group = source["groups"][17]
    require(group["sector_count"] == source_group["sector_count"] == 4,
            "EU g16 / technical g17 sector count differs")
    keys = ("lives", "objects", "effects", "events", "has_station")
    for index in range(4):
        require({key: group["sectors"][index][key] for key in keys}
                == {key: source_group["sectors"][index][key] for key in keys},
                f"EU g16 sector {index} differs from technical g17 declaration")
    for key, raw in source["entities"].items():
        if key[1] != 17:
            continue
        eu_key = (key[0], 16, *key[2:])
        require(eu["entities"].get(eu_key) == raw, f"EU g16 entity metadata differs at {eu_key}")

    eu_owners = {key: value for key, value in eu["owners"].items() if key[1] == 16}
    require(set(eu_owners) == set(SOURCE_MAPPING),
            f"EU g16 owner set differs: {sorted(eu_owners, key=str)}")
    all_nodes = sorted(eu["node_addresses"])
    scripts: list[dict[str, Any]] = []
    texts: dict[int, dict[str, Any]] = {}
    totals = Counter()
    minimum_coverage = 1.0
    for owner in sorted(SOURCE_MAPPING, key=str):
        source_name = SOURCE_MAPPING[owner]
        _guessed_name, root = eu_owners[owner]
        upper_bound = min((address for address in all_nodes if address > root),
                          default=A.ROM_BASE + len(reader.data))
        selected, matches = A.select_command_extent(
            reader, root, source_ref.commands[source_name], upper_bound,
            f"EU map-script 9 g16 {source_name}",
        )
        semantic_source = [core for core in source_ref.commands[source_name] if core.op != A.DEBUG_OPCODE]
        coverage = len(matches) / len(semantic_source)
        require(coverage >= 0.40, f"implausibly low semantic coverage for {source_name}: {coverage:.3f}")
        minimum_coverage = min(minimum_coverage, coverage)
        match_by_eu = {eu_index: source_index for source_index, eu_index in matches}
        commands: list[dict[str, Any]] = []
        terminals: list[int] = []
        for index, (core, pointer) in enumerate(selected):
            text_ref = None
            if core.op in A.TEXT_OPCODES:
                require(pointer != 0, f"{source_name}[{index}] has null text pointer")
                if pointer not in texts:
                    texts[pointer] = A.decode_text_block(reader, pointer, f"{source_name}[{index}]")
                text_ref = A.address_hex(pointer)
            if core.op in A.TERMINAL_OPCODES:
                terminals.append(index)
            commands.append(command_record(core, pointer, root + index * A.SCRIPT_COMMAND_SIZE,
                                           index, match_by_eu.get(index), text_ref))
        require(terminals, f"{source_name} has no terminal command")
        totals["eu_commands"] += len(selected)
        totals["source_semantic_commands"] += len(semantic_source)
        totals["lcs_matches"] += len(matches)
        scripts.append({
            "owner": list(owner),
            "name": source_name,
            "address": A.address_hex(root),
            "command_count": len(selected),
            "terminal_indices": terminals,
            "pret_reference": {
                "technical_group": 17,
                "eu_group": 16,
                "semantic_command_count": len(semantic_source),
                "lcs_match_count": len(matches),
                "semantic_coverage": coverage,
                "eu_unmatched_command_count": len(selected) - len(matches),
            },
            "commands": commands,
        })

    station = next(script for script in scripts if script["owner"][0] == "T")
    require(station["commands"][1]["op"] == 0x08 and station["commands"][1]["arg1"] == 9,
            "EU rescue-base station no longer selects graphical map 9")
    return {
        "regional_map_script_id": 9,
        "header_address": eu["header_address"],
        "map_script_table_entry": eu["table_entry_address"],
        "eu_group": 16,
        "technical_reference_asset": "ground_data_b01p01a_station.h",
        "technical_reference_ground_id": 9,
        "technical_reference_group": 17,
        "selected_graphical_map_id": 9,
        "selected_stable_ground": "b01p00a",
        "group": group,
        "entities": [
            {"owner": list(key), "raw_hex": value}
            for key, value in sorted(eu["entities"].items(), key=lambda item: str(item[0]))
            if key[1] == 16
        ],
        "scripts": scripts,
        "text_blocks": [texts[pointer] for pointer in sorted(texts)],
        "summary": {
            "script_count": len(scripts),
            "eu_command_count": totals["eu_commands"],
            "pret_semantic_command_count": totals["source_semantic_commands"],
            "pret_lcs_match_count": totals["lcs_matches"],
            "minimum_script_semantic_coverage": minimum_coverage,
            "five_language_text_block_count": len(texts),
            "french_text_block_count": len(texts),
        },
        "validation": {
            "status": "pass",
            "group_shift_authenticated": {"pret": 17, "eu": 16},
            "typed_sector_match": True,
            "entity_metadata_match": True,
            "all_command_roots_mapped": True,
            "selected_graphical_map_match": True,
        },
    }


def audit_title(reader: Any) -> dict[str, Any]:
    eu = A.decode_eu_graph(reader, 229, 226)
    require(eu["group_count"] == 5, f"EU title map-script group count changed: {eu['group_count']}")
    group = eu["groups"][2]
    require(group["sector_count"] == 1, "EU title g2 must have exactly one sector")
    sector = group["sectors"][0]
    require((sector["lives"], sector["objects"], sector["effects"], sector["events"], sector["has_station"])
            == (0, 0, 1, 0, 1), "EU title g2 sector shape differs")
    owner = ("T", 2, 0, 0, 0)
    require(owner in eu["owners"], "EU title g2 station root missing")
    root = eu["owners"][owner][1]
    expected = [
        A.CommandCore(0x08, 0, 0, 229, 0),
        A.CommandCore(0x0C, 0, 1, 0, 0),
        A.CommandCore(0x0C, 0, -1, 0, 0),
        A.CommandCore(0x44, 0, 0, 46, 0),
        A.CommandCore(0xDB, 0, 60, 0, 0),
        A.CommandCore(0x22, 1, 60, 0, 0),
        A.CommandCore(0xDB, 0, 480, 0, 0),
        A.CommandCore(0x48, 0, 30, 0, 0),
        A.CommandCore(0x23, 1, 30, 0, 0),
        A.CommandCore(0xEF, 0, 0, 0, 0),
    ]
    commands = read_linear(reader, root, expected, "regional title map-script 229 g2")
    return {
        "regional_map_script_id": 229,
        "header_address": eu["header_address"],
        "map_script_table_entry": eu["table_entry_address"],
        "eu_group": 2,
        "selected_graphical_map_id": 229,
        "selected_stable_ground": "s02",
        "pmdo_french_variant": "s02_fre",
        "group": group,
        "script": {
            "owner": list(owner),
            "address": A.address_hex(root),
            "command_count": len(commands),
            "commands": commands,
        },
        "timing_frames": {"pre_fade_wait": 60, "title_hold": 480, "music_fade": 30},
        "music_id": 46,
        "validation": {
            "status": "pass",
            "rom_direct_decode": True,
            "note": "The source-region technical title declaration has no group 2; no fictitious pret equality is claimed.",
        },
    }


def audit(rom: bytes, pret_root: Path, compiler: str, source_name: str) -> dict[str, Any]:
    require(len(rom) == A.EXPECTED_ROM_SIZE, f"ROM size mismatch: {len(rom)}")
    digest = hashlib.sha256(rom).hexdigest()
    require(digest == A.EXPECTED_ROM_SHA256, f"EU ROM SHA-256 mismatch: {digest}")
    commit = subprocess.run(["git", "-C", str(pret_root), "rev-parse", "HEAD"],
                            check=True, text=True, capture_output=True).stdout.strip()
    require(commit == EXPECTED_PRET_COMMIT, f"pret technical-reference commit mismatch: {commit}")
    reader = A.RomReader(rom)
    event = audit_event_route(reader)
    rescue_base = audit_rescue_base(reader, pret_root, compiler)
    title = audit_title(reader)
    require(event["route"][2]["group"] == rescue_base["eu_group"], "event/base group mismatch")
    require(event["route"][3]["group"] == title["eu_group"], "event/title group mismatch")
    return {
        "schema": SCHEMA,
        "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
        "authority": {
            "game": "Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "source_filename": source_name,
            "rom_size": len(rom),
            "rom_sha256": digest,
            "rule": "EU ROM bytes are absolute content authority",
        },
        "technical_reference": {
            "repository": "https://github.com/pret/pmd-red",
            "commit": commit,
            "role": "typed declaration/alignment only; regional IDs, groups, commands, and text come from EU ROM",
        },
        "correction": {
            "supersedes_unscoped_assumption": "d01p01:g3 -> b01p01a:g17 -> t00p01:g2",
            "authenticated_eu_route": "d01p02:g1 -> d01p01:g3 -> map-script 9:g16 (b01p00a) -> map-script 229:g2 (s02/s02_fre) -> Tiny Woods conquered -> SCENARIO_MAIN 3,0 -> EVENT_DIVIDE",
            "reason": "The earlier names/group numbers mixed stable graphical IDs, source-region declarations, and EU regional map-script IDs.",
        },
        "event_route": event,
        "rescue_base_group": rescue_base,
        "title_group": title,
        "totals": {
            "event_command_count": event["command_count"],
            "rescue_base_script_count": rescue_base["summary"]["script_count"],
            "rescue_base_command_count": rescue_base["summary"]["eu_command_count"],
            "rescue_base_french_text_count": rescue_base["summary"]["french_text_block_count"],
            "title_command_count": title["script"]["command_count"],
        },
        "validation": {
            "status": "pass",
            "event_route": "pass",
            "rescue_base_group": "pass",
            "title_group": "pass",
            "cross_route_targets": "pass",
        },
    }


def summarize(report: dict[str, Any]) -> str:
    totals = report["totals"]
    return "\n".join((
        "PASS: authenticated EU post-Tiny-Woods route",
        report["correction"]["authenticated_eu_route"],
        f"Event/base/title commands: {totals['event_command_count']}/"
        f"{totals['rescue_base_command_count']}/{totals['title_command_count']}",
        f"Rescue-base scripts/French blocks: {totals['rescue_base_script_count']}/"
        f"{totals['rescue_base_french_text_count']}",
        f"ROM: {report['authority']['rom_sha256']}",
    ))


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path)
    parser.add_argument("--pret-root", type=Path, required=True)
    parser.add_argument("--compiler", default="gcc")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args(argv)
    try:
        report = audit(args.rom.read_bytes(), args.pret_root.resolve(), args.compiler, args.rom.name)
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(summarize(report))
        return 0
    except (A.AuditError, OSError, subprocess.SubprocessError, ValueError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
