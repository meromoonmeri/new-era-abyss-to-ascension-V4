#!/usr/bin/env python3
"""Reauthenticate the complete EU Tiny Woods opening/ending scene graphs.

The general direct-Ground report starts at d01p02.  This focused audit also
follows regional Ground 183 (d01p01) directly from the authenticated EU ROM,
using pret declarations only to type and bound the graph.  It records all five
localized strings; French scene work must cite pointers from this report.
"""

from __future__ import annotations

import argparse
import json
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any, Sequence

import audit_pmdred_eu_ground_scripts as base

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "new-era.pmdred-eu-tiny-woods-scenes.v1"
CANDIDATES = (("d01p01", 183), ("d01p02", 184))
EXPECTED = {
    "d01p01": {"source_id": 178, "groups": 4, "scripts": 14, "commands": 626, "texts": 109},
    "d01p02": {"source_id": 179, "groups": 2, "scripts": 5, "commands": 71, "texts": 8},
}


def audit(rom: bytes, pret_root: Path, compiler: str, source_name: str) -> dict[str, Any]:
    base.require(len(rom) == base.EXPECTED_ROM_SIZE, "EU ROM size differs")
    digest = base.sha256(rom)
    base.require(digest == base.EXPECTED_ROM_SHA256, "EU ROM SHA-256 differs")
    commit = subprocess.check_output(
        ["git", "-C", str(pret_root), "rev-parse", "HEAD"], text=True
    ).strip()
    reader = base.RomReader(rom)
    candidates = []
    totals: Counter[str] = Counter()
    for asset, regional_id in CANDIDATES:
        source = base.compile_source_reference(asset, pret_root, compiler)
        result = base.audit_candidate(reader, source, regional_id)
        expected = EXPECTED[asset]
        summary = result["summary"]
        base.require(source.source_ground_id == expected["source_id"], f"{asset}: source ID differs")
        base.require(result["typed_graph"]["group_count"] == expected["groups"], f"{asset}: group count differs")
        base.require(len(result["scripts"]) == expected["scripts"], f"{asset}: script count differs")
        base.require(summary["eu_command_count"] == expected["commands"], f"{asset}: command count differs")
        base.require(len(result["text_blocks"]) == expected["texts"], f"{asset}: text count differs")
        base.require(result["validation"]["status"] == "pass", f"{asset}: graph validation failed")
        for key in ("command_array_count", "eu_command_count", "text_block_count", "french_text_count"):
            totals[key] += summary[key]
        candidates.append(result)
    return {
        "schema": SCHEMA,
        "tool": {"name": Path(__file__).name, "base_tool_version": base.TOOL_VERSION},
        "authority": {
            "game": "Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "source_filename": source_name,
            "rom_size": len(rom),
            "rom_sha256": digest,
            "regional_language_order": list(base.LANGUAGES),
        },
        "technical_reference": {
            "repository": "https://github.com/pret/pmd-red",
            "commit": commit,
            "role": "typed declarations and semantic alignment only; never content authority",
            "compiler": compiler,
        },
        "route_groups": {
            "d01p01": {"regional_ground_id": 183, "groups": ["g0", "g1", "g2", "g3"]},
            "d01p02": {"regional_ground_id": 184, "groups": ["g0", "g1"]},
            "playable_flow": ["d01p01:g1", "tiny_woods:0-2", "d01p02:g1", "d01p01:g3"],
            "failed_flow": ["tiny_woods:failed", "d01p01:g2", "tiny_woods:0"],
        },
        "totals": dict(totals),
        "candidates": candidates,
        "validation": {
            "status": "pass",
            "candidate_count": len(candidates),
            "typed_graph_mismatch_count": 0,
            "missing_french_text_count": 0,
        },
    }


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("rom", type=Path)
    result.add_argument("--pret-root", type=Path, required=True)
    result.add_argument("--compiler", default="gcc")
    result.add_argument("--report", type=Path, required=True)
    return result


def main(argv: Sequence[str] | None = None) -> int:
    args = parser().parse_args(argv)
    report = audit(args.rom.read_bytes(), args.pret_root, args.compiler, args.rom.name)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(
        json.dumps(report, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    print(
        "TINY_WOODS_EU_SCENES_PASS "
        f"commands={report['totals']['eu_command_count']} "
        f"french_texts={report['totals']['french_text_count']} report={args.report}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
