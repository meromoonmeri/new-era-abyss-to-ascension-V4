#!/usr/bin/env python3
"""Regression tests for the PMU structure-autonomy resolution.

These guard the two findings that unblock (and correctly block) the
"replace NNV structures with PMU structures" mission. They must keep passing
without network access: they validate the tracked reports, not the download.
"""
from __future__ import annotations

import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
REPORTS = REPO / "PMU_ADAPTATION/reports/structure-autonomy"
AUTONOMY = REPORTS / "structure-autonomy.json"
COMPATIBILITY = REPORTS / "nnv-structure-compatibility.json"
VALID = {"AUTONOMOUS_CONFIRMED", "AUTONOMOUS_PARTIAL", "MAP_FRAGMENT_ONLY", "REVIEW_REQUIRED", "BLOCKED"}


def test_autonomy_report() -> None:
    report = json.loads(AUTONOMY.read_text())
    assert report["schema"] == "new-era.pmu-structure-autonomy.v1"

    candidates = report["candidates"]
    assert len(candidates) == report["counts"]["candidates"] == 143

    # Every candidate carries a strict classification.
    for candidate in candidates:
        assert candidate["classification"] in VALID, candidate["structure_id"]
        for key in ("structure_id", "source_archive", "source_atlas_bbox", "dimensions", "evidence"):
            assert candidate.get(key) is not None, (candidate["structure_id"], key)

    # An unverifiable source archive can never yield a confirmed structure.
    for candidate in candidates:
        verified = report["archives"][candidate["source_archive"]]["verified"]
        if not verified:
            assert candidate["classification"] == "REVIEW_REQUIRED", candidate["structure_id"]

    # Confirmed structures must be pixel-faithful re-derivations: no recolor,
    # no rescale, no interpolation anywhere the asset is opaque.
    confirmed = [c for c in candidates if c["classification"] == "AUTONOMOUS_CONFIRMED"]
    assert confirmed, "expected at least one confirmed structure"
    for candidate in confirmed:
        assert candidate["reproduced_from_source"] is True
        assert candidate["rgb_mismatch_where_opaque"] == 0
        assert candidate["opaque_pixels"] > 0
        assert candidate["dimensions"][0] == candidate["source_atlas_bbox"][2]
        assert candidate["dimensions"][1] == candidate["source_atlas_bbox"][3]
    assert report["aggregate_evidence"]["rgb_mismatch_total"] == 0

    # PMU.zip itself stayed unreachable; that must remain declared, not hidden.
    assert report["provenance"]["pmu_zip_reachable"] is False
    assert report["provenance"]["pmu_zip_block_reason"]


def test_compatibility_is_fail_closed() -> None:
    report = json.loads(COMPATIBILITY.read_text())
    assert report["schema"] == "new-era.nnv-pmu-structure-compatibility.v1"
    assert report["geometry_contract"]["rescaling_allowed"] is False
    assert report["geometry_contract"]["nnv_visual_cell_px"] == 64
    assert report["geometry_contract"]["pmu_native_tile_px"] == 32

    targets = report["targets"]
    assert len(targets) == 4, "rmvillage has exactly four source-proved houses"

    for target in targets:
        assert target["replacement_status"] in {"COMPATIBLE", "ADAPTATION_REQUIRED", "BLOCKED"}
        # The structural perimeter must never absorb surrounding NNV terrain.
        assert "terrain" in target["structural_perimeter"]
        # A target may only be COMPATIBLE if a candidate genuinely fits natively.
        if target["replacement_status"] == "COMPATIBLE":
            assert target["pmu_candidates_fitting_natively"]
        else:
            assert not target["pmu_candidates_fitting_natively"]
            assert target["blocking_reason"]

    counted = report["summary"]["compatible"] + report["summary"]["adaptation_required"]
    assert counted == len(targets)


def main() -> int:
    test_autonomy_report()
    test_compatibility_is_fail_closed()
    print("PMU structure autonomy tests: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
