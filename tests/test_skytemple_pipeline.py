"""Automated Pytest test suite for SkyTemple PMD Level Designer & Map Pipeline."""
from __future__ import annotations

import json
from pathlib import Path

import pytest
import skytemple_files
import skytemple_rust

from tools.pmdo_town_gen.animation_engine import AnimationEngine
from tools.pmdo_town_gen.models import TileCollision, TownSpec
from tools.pmdo_town_gen.pmdo_exporter import PMDOExporter
from tools.pmdo_town_gen.renderer import TownRenderer
from tools.pmdo_town_gen.skytemple_engine import QualityGateReport, SkyTempleMapEngine
from tools.pmdo_town_gen.structure_library import StructureLibrary
from tools.pmdo_town_gen.validator import TownValidator


@pytest.fixture
def skytemple_engine() -> SkyTempleMapEngine:
    return SkyTempleMapEngine()


def test_skytemple_files_installed():
    """Verify that skytemple-files and skytemple-rust are properly installed and loaded."""
    assert skytemple_files is not None
    assert skytemple_rust is not None
    assert hasattr(skytemple_rust, "st_bgp")
    assert hasattr(skytemple_rust, "st_dbg")


def test_canonical_ground_analysis(skytemple_engine: SkyTempleMapEngine):
    """Verify parsing of canonical ground map metano_town.rsground."""
    ref_path = Path("Data/Ground/metano_town.rsground")
    assert ref_path.exists()
    analysis = skytemple_engine.analyze_canonical_ground(ref_path)
    assert analysis["grid_w"] == 189
    assert analysis["grid_h"] == 189
    assert len(analysis["layers"]) == 11
    assert "Base" in analysis["layers"]
    assert "Fringe" in analysis["layers"]


def test_skytemple_build_outskirts(skytemple_engine: SkyTempleMapEngine):
    """Verify full end-to-end build of skytemple_metano_outskirts."""
    layout, report, artifacts = skytemple_engine.build_new_era_map(
        map_id="test_skytemple_outskirts",
        display_name="Test SkyTemple Outskirts",
        seed=42,
    )

    assert report.status == "READY"
    assert report.skytemple_load_valid is True
    assert report.collision_valid is True
    assert report.gameplay_connectivity == 100.0
    assert report.visual_score >= 80.0
    assert report.layers_count == 11

    # Check exported files
    assert artifacts["ground"].exists()
    assert artifacts["tile"].exists()
    assert artifacts["script"].exists()

    # Check .rsground contents
    with open(artifacts["ground"], "r", encoding="utf-8") as f:
        data = json.load(f)
    assert data["Object"]["TexSize"] == 1
    assert len(data["Object"]["obstacles"]) == 189
    assert len(data["Object"]["obstacles"][0]) == 189
    assert len(data["Object"]["Layers"]) == 11


def test_animation_dir_compilation():
    """Verify compilation of multi-frame animated .dir assets."""
    anim = AnimationEngine()
    wf_path = anim.create_waterfall_animation(48, 72, 4, "test_waterfall")
    assert wf_path.exists()
    assert wf_path.stat().st_size > 100

    rip_path = anim.create_river_ripple_animation(24, 24, 4, "test_ripple")
    assert rip_path.exists()

    fire_path = anim.create_campfire_animation(36, 36, 4, "test_campfire")
    assert fire_path.exists()
