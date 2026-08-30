"""Automated Regression and Validation Test Suite for PMDO Town Generator."""
from __future__ import annotations

import json
from pathlib import Path

import pytest

from tools.pmdo_town_gen import (
    BiomeType,
    ReferenceAnalyzer,
    SeasonType,
    TileCollision,
    TownGenerator,
    TownSpec,
)


@pytest.fixture
def generator():
    return TownGenerator()


@pytest.fixture
def analyzer():
    return ReferenceAnalyzer()


def test_reference_analysis_metano_and_grasstown(analyzer):
    """Test A & B: Reference analysis on Metano Town and Grasstown."""
    res = analyzer.run_and_save()
    assert "metano" in res
    assert "grasstown" in res
    assert "profile" in res

    metano = res["metano"]
    assert metano["reference_id"] == "metano_town"
    assert metano["elevation"]["levels_count"] == 2
    assert metano["metrics"]["walkable_ratio"] > 0.50
    assert len(metano["structures"]) >= 5

    grasstown = res["grasstown"]
    assert grasstown["reference_id"] == "grasstown_s737"
    assert grasstown["dimensions"]["width_tiles"] == 51
    assert grasstown["dimensions"]["height_tiles"] == 51
    assert len(grasstown["structures"]) >= 8

    profile = res["profile"]
    assert profile["profile_name"] == "PokemonTownStyleProfile"
    assert profile["environment_constraints"]["strictly_one_primary_biome"] is True
    assert profile["environment_constraints"]["strictly_one_season"] is True


def test_town_generator_deterministic_seed(generator):
    """Test C: Seed determinism (same seed produces exact same layout)."""
    spec1 = TownSpec(name="det_village", seed=424242)
    spec2 = TownSpec(name="det_village", seed=424242)

    l1 = generator.generate(spec1)
    l2 = generator.generate(spec2)

    assert l1.heightmap == l2.heightmap
    assert l1.cliff_mask == l2.cliff_mask
    assert l1.road_mask == l2.road_mask
    assert l1.collision == l2.collision
    assert len(l1.buildings) == len(l2.buildings)
    assert len(l1.stairs) == len(l2.stairs)
    assert l1.composite_score == l2.composite_score


def test_different_seeds_produce_distinct_topologies(generator):
    """Test D: Different seeds produce distinct elevation, road, and parcel layouts."""
    spec1 = TownSpec(name="seed_a", seed=111111)
    spec2 = TownSpec(name="seed_b", seed=999999)

    l1 = generator.generate(spec1)
    l2 = generator.generate(spec2)

    assert l1.heightmap != l2.heightmap
    assert l1.road_mask != l2.road_mask


def test_elevation_and_cliff_integrity(generator):
    """Test E: Heightmap levels, cliff boundaries, and structural stairs."""
    spec = TownSpec(name="elevation_test", elevation_levels=2, seed=184729)
    layout = generator.generate(spec)

    assert layout.validation.status == "PASS"
    assert layout.validation.stair_connections_valid is True
    assert len(layout.stairs) >= 2

    # Verify each stair connects lower level to upper level
    for st in layout.stairs:
        assert st.from_level == 0
        assert st.to_level == 1
        top_y = st.y - 1
        bot_y = st.y + st.length + 1
        mid_x = st.x + st.width // 2
        assert layout.heightmap[mid_x][top_y] == 1
        assert layout.heightmap[mid_x][bot_y] == 0


def test_multi_layer_tree_collision(generator):
    """Test F: Multi-layer trees (trunk Blocked, canopy Walkable)."""
    spec = TownSpec(name="tree_test", seed=184729)
    layout = generator.generate(spec)

    assert len(layout.vegetation) > 10
    for veg in layout.vegetation:
        tx, ty, tw, th = veg.trunk_bounds

        # Trunk cells must be BLOCKED
        for bx in range(tx, tx + tw):
            for by in range(ty, ty + th):
                assert layout.collision[bx][by] == TileCollision.BLOCKED.value


def test_gameplay_connectivity_and_reachability(generator):
    """Test G: 100% pathfinding reachability of all town objectives."""
    spec = TownSpec(name="nav_test", seed=184729)
    layout = generator.generate(spec)

    assert layout.validation.status == "PASS"
    assert layout.validation.score.connectivity == 100.0
    assert layout.validation.reachable_objectives == layout.validation.total_objectives
    assert len(layout.validation.unreachable_nodes) == 0


def test_reference_style_metano_and_grasstown(generator):
    """Test H: Generation in Reference Style mode (Metano & Grasstown)."""
    spec_m = TownSpec(name="test_metano_ref", reference_style="metano", seed=20260830)
    layout_m = generator.generate(spec_m)
    assert layout_m.validation.status == "PASS"
    assert layout_m.water_mask is not None
    assert layout_m.visual_score.total_visual_score >= 80.0

    spec_g = TownSpec(name="test_grasstown_ref", reference_style="grasstown", seed=20260830)
    layout_g = generator.generate(spec_g)
    assert layout_g.validation.status == "PASS"
    assert layout_g.visual_score.total_visual_score >= 80.0


def test_batch_generation_and_ranking(generator):
    """Test I: Batch generation of 10 layouts ranked by composite score."""
    base_spec = TownSpec(name="batch_test", reference_style="metano", seed=100000)
    ranked = generator.generate_batch_and_rank(base_spec, count=10)

    assert len(ranked) == 10
    # Check descending order of composite scores
    scores = [l.composite_score for l in ranked]
    assert scores == sorted(scores, reverse=True)
    assert ranked[0].composite_score >= 90.0


def test_native_pmdo_export_bundle(generator, tmp_path):
    """Test J: Full export to native .rsground, .tile, and init.lua."""
    spec = TownSpec(name="export_test_village", seed=184729)
    layout, artifacts = generator.generate_and_export(spec, out_dir=tmp_path)

    assert artifacts["ground"].exists()
    assert artifacts["tile"].exists()
    assert artifacts["script"].exists()
    assert artifacts["manifest"].exists()

    # Verify .rsground JSON integrity
    ground_data = json.loads(artifacts["ground"].read_text(encoding="utf-8-sig"))
    assert ground_data["Object"]["Name"]["DefaultText"] == spec.display_name
    assert ground_data["Object"]["TexSize"] == 1
    assert len(ground_data["Object"]["obstacles"]) == spec.width * 3
    assert len(ground_data["Object"]["obstacles"][0]) == spec.height * 3
    assert ground_data["Object"]["obstacles"][0][0]["Bounds"]["Width"] == 8
    assert "Tags" in ground_data["Object"]["obstacles"][0][0]

    # Verify .tile binary header
    tile_bytes = artifacts["tile"].read_bytes()
    assert len(tile_bytes) > 200
    assert tile_bytes[32:36] == b"\x89PNG"
