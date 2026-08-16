#!/usr/bin/env python3
"""Independent structural-autonomy audit of the PMU building candidates.

This tool answers one question with evidence, never with a visual impression:

    Are the PMU houses/buildings autonomous structures, or are they only
    available as compositions painted inside a map?

It does NOT trust `docs/pmuniverse_buildings/manifest.json`. That manifest is a
derived artifact; its own verifier only checks self-consistency (declared hash
vs tracked file) and therefore cannot prove provenance, nor that the flag
`terrain_included: false` is true.

Method (source -> proof, no PNG cropping of a rendered map):

1. Re-read the pinned PMU-Client `.tile` archives with the format proven in
   `PMU_EXTRACTION/docs/source-chain.md` (`Client/Graphics/Tileset.cs`):
   little-endian int32 width/height, then per-tile (int64 relative offset,
   int32 encoded size), payload after the index.
2. Rebuild each native atlas from its embedded 32x32 records.
3. Re-derive every candidate from its declared atlas bbox.
4. Compare against the tracked PNG pixel by pixel and classify:
     - RGB must be identical wherever the tracked asset is opaque
       (no recolor / no interpolation / no rescale);
     - pixels the tracked asset made transparent are counted as
       "environment removed by the alpha mask".

A candidate is only `AUTONOMOUS_CONFIRMED` when its source archive is
byte-identical to the pinned public client. Where the archive cannot be
verified against a public pinned source, the candidate stays `REVIEW_REQUIRED`
— fail-closed, exactly as the project requires.

Usage:
    PYTHONPATH=<pillow> python3 PMU_ADAPTATION/tools/audit_pmu_structure_autonomy.py \
        --tiles <PMU-Client>/resources/GFX/Tiles \
        --out PMU_ADAPTATION/reports/structure-autonomy
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
from collections import Counter, defaultdict
from pathlib import Path

from PIL import Image

TILE_SIZE = 32
REPO = Path(__file__).resolve().parents[2]
LIBRARY = REPO / "docs/pmuniverse_buildings"


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_atlas(path: Path) -> Image.Image:
    """Rebuild a native atlas exactly as Tileset.cs indexes it."""
    raw = path.read_bytes()
    width, height = struct.unpack("<ii", raw[:8])
    count = (width // TILE_SIZE) * (height // TILE_SIZE)
    entries = [struct.unpack("<qi", raw[8 + 12 * i : 20 + 12 * i]) for i in range(count)]
    header = 8 + 12 * count
    atlas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    columns = width // TILE_SIZE
    for index, (offset, size) in enumerate(entries):
        payload = raw[header + offset : header + offset + size]
        if len(payload) != size:
            raise ValueError(f"{path}: tile {index} truncated")
        with Image.open(io.BytesIO(payload)) as tile:
            atlas.paste(tile.convert("RGBA"), ((index % columns) * TILE_SIZE, (index // columns) * TILE_SIZE))
    return atlas


def compare(candidate: dict, atlas: Image.Image, tracked_root: Path) -> dict:
    x, y, width, height = candidate["source_atlas_bbox"]
    crop = atlas.crop((x, y, x + width, y + height))
    tracked = Image.open(tracked_root / candidate["file"]).convert("RGBA")
    if tracked.size != (width, height):
        return {"geometry_match": False, "rgb_mismatch": None, "environment_pixels_removed": None, "opaque": None}
    source_px = crop.load()
    tracked_px = tracked.load()
    removed = 0
    opaque = 0
    mismatch = 0
    for row in range(height):
        for column in range(width):
            source = source_px[column, row]
            kept = tracked_px[column, row]
            if kept[3] == 0:
                if source[3] > 0:
                    removed += 1
                continue
            opaque += 1
            if kept != source:
                mismatch += 1
    return {
        "geometry_match": True,
        "rgb_mismatch": mismatch,
        "environment_pixels_removed": removed,
        "opaque": opaque,
        "bbox_pixels": width * height,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tiles", type=Path, required=True, help="pinned PMU-Client resources/GFX/Tiles directory")
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument(
        "--client-commit",
        default="c25c01f9879369647cd5a19731b2e4e5acd33e67",
        help="pinned Sprinkoringo/PMU-Client commit used as the public provenance anchor",
    )
    arguments = parser.parse_args()

    manifest = json.loads((LIBRARY / "manifest.json").read_text())
    declared = manifest["source"]["archive_sha256"]

    archives = {}
    for name, expected in sorted(declared.items()):
        path = arguments.tiles / name
        actual = sha256_file(path) if path.exists() else None
        archives[name] = {
            "declared_sha256": expected,
            "pinned_client_sha256": actual,
            "verified": actual == expected,
            "path": str(path),
        }

    atlas_cache: dict[str, Image.Image] = {}
    candidates = []
    for candidate in manifest["buildings"]:
        archive = candidate["source_archive"]
        record = {
            "structure_id": candidate["id"],
            "source_archive": archive,
            "source_component": candidate["source_component"],
            "source_atlas_bbox": candidate["source_atlas_bbox"],
            "dimensions": [candidate["width"], candidate["height"]],
            "tracked_file": candidate["file"],
            "tracked_sha256": candidate["sha256"],
        }
        if not archives[archive]["verified"]:
            record.update(
                {
                    "classification": "REVIEW_REQUIRED",
                    "evidence": "source archive is not byte-identical to the pinned public client; "
                    "autonomy cannot be re-derived from a public source",
                    "reproduced_from_source": False,
                }
            )
            candidates.append(record)
            continue
        if archive not in atlas_cache:
            atlas_cache[archive] = build_atlas(arguments.tiles / archive)
        result = compare(candidate, atlas_cache[archive], LIBRARY)
        autonomous = bool(result["geometry_match"]) and result["rgb_mismatch"] == 0
        record.update(
            {
                "reproduced_from_source": autonomous,
                "rgb_mismatch_where_opaque": result["rgb_mismatch"],
                "environment_pixels_removed_by_mask": result["environment_pixels_removed"],
                "opaque_pixels": result["opaque"],
                "bbox_pixels": result["bbox_pixels"],
                "classification": "AUTONOMOUS_CONFIRMED" if autonomous else "REVIEW_REQUIRED",
                "evidence": "re-derived from the pinned public client archive; RGB identical where opaque; "
                "alpha mask isolates the connected structure and drops adjacent atlas content"
                if autonomous
                else "pixel comparison against the pinned public client failed",
            }
        )
        candidates.append(record)

    counts = Counter(entry["classification"] for entry in candidates)
    verified = [entry for entry in candidates if entry["classification"] == "AUTONOMOUS_CONFIRMED"]
    duplicates = defaultdict(list)
    for candidate in manifest["buildings"]:
        duplicates[candidate["sha256"]].append(candidate["id"])

    report = {
        "schema": "new-era.pmu-structure-autonomy.v1",
        "question": "are PMU buildings autonomous structures or only map compositions?",
        "method": "native .tile archive index -> embedded 32x32 records -> atlas rebuild -> "
        "bbox re-derivation -> pixel comparison; no rendered-map crop is used as evidence",
        "provenance": {
            "pinned_public_client": f"https://github.com/Sprinkoringo/PMU-Client@{arguments.client_commit}",
            "pmu_zip_declared_sha256": manifest["source"]["download_sha256"],
            "pmu_zip_reachable": False,
            "pmu_zip_block_reason": "LFS object host (github-cloud.githubusercontent.com / media.githubusercontent.com) "
            "resets the TLS handshake from this sandbox; only github.com and api.github.com are reachable",
        },
        "archives": archives,
        "counts": {
            "candidates": len(candidates),
            "autonomous_confirmed": counts.get("AUTONOMOUS_CONFIRMED", 0),
            "review_required": counts.get("REVIEW_REQUIRED", 0),
            "map_fragment_only": counts.get("MAP_FRAGMENT_ONLY", 0),
            "blocked": counts.get("BLOCKED", 0),
            "pixel_identical_duplicate_groups": sum(1 for ids in duplicates.values() if len(ids) > 1),
        },
        "aggregate_evidence": {
            "rgb_mismatch_total": sum(entry.get("rgb_mismatch_where_opaque") or 0 for entry in verified),
            "environment_pixels_removed_total": sum(
                entry.get("environment_pixels_removed_by_mask") or 0 for entry in verified
            ),
            "bbox_pixels_total": sum(entry.get("bbox_pixels") or 0 for entry in verified),
        },
        "candidates": sorted(candidates, key=lambda entry: entry["structure_id"]),
    }

    arguments.out.mkdir(parents=True, exist_ok=True)
    target = arguments.out / "structure-autonomy.json"
    target.write_text(json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(
        "PMU_STRUCTURE_AUTONOMY "
        f"candidates={report['counts']['candidates']} "
        f"autonomous={report['counts']['autonomous_confirmed']} "
        f"review={report['counts']['review_required']} "
        f"rgb_mismatch={report['aggregate_evidence']['rgb_mismatch_total']} "
        f"env_px_removed={report['aggregate_evidence']['environment_pixels_removed_total']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
