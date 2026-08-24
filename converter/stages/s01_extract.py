"""Stage 1 — extract raw ROM regions to disk.

Uses the offset registry (converter/registry/rom_regions.json) to know
which byte ranges to copy out of the ROM. The registry is human-curated
based on pret/pmd-red symbol tables. Every extracted blob is stored
under converter/rom_output/01_extract/<region>/<name>.bin with a
sidecar .json declaring its (offset, length, sha256).

This stage NEVER interprets bytes. It just copies them out so higher
stages can decode without re-touching the ROM.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any

from converter.stages.context import Context, StageResult, StageStatus
from converter.version import __version__


STAGE = "s01_extract"


REGISTRY_REL = "converter/registry/rom_regions.json"


def _load_registry(ctx: Context) -> dict[str, Any]:
    path = ctx.repo_root / REGISTRY_REL
    if not path.exists():
        return {"version": 0, "regions": []}
    return json.loads(path.read_text(encoding="utf-8"))


def _sha256(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def _extract_region(
    rom_bytes_view: memoryview,
    region: dict[str, Any],
    out_dir: Path,
) -> tuple[dict[str, Any], list[str]]:
    """Copy one region out of the ROM (as a slice) into out_dir.

    Returns (record, warnings). Never raises on soft errors so the
    pipeline can keep going for other regions.
    """
    warnings: list[str] = []
    name = region["name"]
    offset = int(region["offset"], 0)
    length = int(region["length"], 0)
    if offset < 0 or length <= 0 or offset + length > len(rom_bytes_view):
        return (
            {
                "name": name,
                "status": "SKIPPED",
                "reason": (
                    f"Out-of-bounds region offset={offset:#x} length={length}"
                ),
            },
            warnings,
        )

    blob = bytes(rom_bytes_view[offset : offset + length])
    dest = out_dir / f"{name}.bin"
    dest.write_bytes(blob)
    sha = _sha256(blob)

    sidecar = {
        "name": name,
        "offset": offset,
        "length": length,
        "sha256": sha,
        "kind": region.get("kind", ""),
        "notes": region.get("notes", ""),
        "extractor_version": __version__,
    }
    dest_side = out_dir / f"{name}.json"
    dest_side.write_text(
        json.dumps(sidecar, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    return (
        {
            "name": name,
            "status": "EXTRACTED",
            "bytes": length,
            "sha256_head": sha[:16],
        },
        warnings,
    )


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)

    registry = _load_registry(ctx)
    regions = registry.get("regions", [])
    result.metrics["registry_regions_total"] = len(regions)
    result.metrics["registry_version"] = registry.get("version", 0)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.status = StageStatus.SKIPPED
        result.reason = (
            "No authenticated ROM (s00_detect did not PASS). "
            "Nothing to extract."
        )
        return result

    if not regions:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = (
            f"Registry {REGISTRY_REL} declares 0 regions. "
            f"Populate it with ROM offsets (from pret/pmd-red symbols) "
            f"before s01 can produce anything."
        )
        return result

    # Read the ROM once, into a memoryview, so we can slice without copies.
    rom = ctx.rom_path.read_bytes()
    if _sha256(rom) != ctx.rom_actual_hash:
        result.status = StageStatus.FAIL
        result.reason = (
            "ROM hash changed between s00 and s01 (file was modified "
            "under our feet)."
        )
        return result
    view = memoryview(rom)

    out_dir = ctx.stage_output_dir(STAGE)
    records: list[dict[str, Any]] = []
    for reg in regions:
        rec, warns = _extract_region(view, reg, out_dir)
        records.append(rec)
        for w in warns:
            result.warnings.append(w)

    ctx.write_json(out_dir / "_manifest.json", {
        "registry_version": registry.get("version", 0),
        "extractor_version": __version__,
        "rom_sha256": ctx.rom_actual_hash,
        "regions": records,
    })
    result.artefacts.append(str(out_dir / "_manifest.json"))

    extracted = sum(1 for r in records if r["status"] == "EXTRACTED")
    result.metrics["regions_extracted"] = extracted
    result.metrics["regions_skipped"] = len(records) - extracted

    if extracted == 0:
        result.status = StageStatus.UNIMPLEMENTED
        result.reason = "Registry present but 0 regions successfully extracted."
    else:
        result.status = StageStatus.PASS
        result.reason = f"Extracted {extracted}/{len(records)} regions."
    return result
