"""Automated Unit and Integration Tests for PixelLab-Powered PMDO Town Engine."""
from __future__ import annotations

import json
import struct
from pathlib import Path

import pytest
from PIL import Image

from tools.pmdo_town_gen.animation_engine import AnimationEngine
from tools.pmdo_town_gen.hybrid_town_synthesizer import HybridTownSynthesizer
from tools.pmdo_town_gen.models import BiomeType, SeasonType, TileCollision, TownSpec
from tools.pmdo_town_gen.pixellab_client import DEFAULT_PIXELLAB_TOKEN, PixelLabClient
from tools.pmdo_town_gen.pixellab_structure_engine import PixelLabStructureEngine
from tools.pmdo_town_gen.pixellab_tileset_engine import PixelLabTilesetEngine
from tools.pmdo_town_gen.generator import TownGenerator
from tools.pmdo_town_gen.metano_recreator import MetanoRecreator


@pytest.fixture
def pixellab_client(tmp_path):
    return PixelLabClient(api_token=DEFAULT_PIXELLAB_TOKEN, cache_dir=tmp_path / "pixellab_cache")


def test_pixellab_client_initialization(pixellab_client):
    """Test PixelLab client auth and directory structure initialization."""
    assert pixellab_client.api_token == DEFAULT_PIXELLAB_TOKEN
    assert (pixellab_client.cache_dir / "tilesets").exists()
    assert (pixellab_client.cache_dir / "structures").exists()
    assert (pixellab_client.cache_dir / "decorations").exists()


def test_pixellab_wang_tileset_generation(pixellab_client):
    """Test creation and caching of 16-tile Wang terrain atlas via PixelLab."""
    tileset = pixellab_client.create_topdown_tileset(
        lower_description="crystal water",
        upper_description="lush chartreuse grass",
        tile_size=24,
    )

    assert tileset.tileset_id.startswith("tileset_")
    assert Path(tileset.image_path).exists()
    assert len(tileset.sha256) == 64
    assert len(tileset.tiles) == 16

    # Verify atlas dimensions (4x4 tiles = 96x96 px at 24px)
    atlas_im = Image.open(tileset.image_path)
    assert atlas_im.size == (96, 96)
    assert atlas_im.mode == "RGBA"


def test_pixellab_bitmask_to_wang_index():
    """Test standard 8-neighbor bitmask conversion to Wang tile index."""
    engine = PixelLabTilesetEngine()

    # 1. Solid upper (all 8 bits set: 255) -> 0
    assert engine.bitmask_to_wang_index(255) == 0

    # 2. Solid lower (no bits set: 0) -> 15
    assert engine.bitmask_to_wang_index(0) == 15

    # 3. Cardinal North lower, others matching -> 1 (North edge)
    mask_north_edge = 4 | 16 | 64
    assert engine.bitmask_to_wang_index(mask_north_edge) == 1


def test_animation_engine_dir_compilation(tmp_path):
    """Test multi-frame animation .dir compiler with exact PMDO binary header/tail specification."""
    anim_engine = AnimationEngine(project_root=tmp_path)

    # 1. Generate 4-frame waterfall
    wf = anim_engine.create_waterfall_animation(width=48, height=72, frame_count=4)
    assert wf.frame_count == 4
    assert Path(wf.dir_path).exists()

    # Read binary .dir file
    with open(wf.dir_path, "rb") as f:
        data = f.read()

    # Header is uint64 PNG length
    png_len = struct.unpack("<Q", data[:8])[0]
    png_data = data[8:8 + png_len]
    assert png_data.startswith(b"\x89PNG")

    # Tail is [width, height, 0, frame_count]
    tail_data = data[8 + png_len:]
    frame_w, frame_h, offset, frame_c = struct.unpack("<IIII", tail_data)
    assert frame_w == 48
    assert frame_h == 72
    assert offset == 0
    assert frame_c == 4


def test_native_rsground_8x8_cell_bounds_and_tags(tmp_path):
    """Test that generated .rsground follows exact 8x8 cell bounds and per-cell Tags format."""
    client = PixelLabClient(cache_dir=tmp_path / "cache")
    synth = HybridTownSynthesizer(pixellab_client=client, project_root=tmp_path)
    layout, artifacts = synth.synthesize_waterfall_haven()

    ground_json = json.loads(artifacts["ground"].read_text(encoding="utf-8-sig"))
    obj = ground_json["Object"]

    assert obj["TexSize"] == 1
    obstacles = obj["obstacles"]
    # 63 tiles x 3 subdivisions = 189 cols x 189 rows
    assert len(obstacles) == 189
    assert len(obstacles[0]) == 189

    # Check cell 0,0 bounds
    cell_0_0 = obstacles[0][0]
    assert cell_0_0["Bounds"]["Width"] == 8
    assert cell_0_0["Bounds"]["Height"] == 8
    assert "Tags" in cell_0_0

    # Verify 11 layers
    assert len(obj["Layers"]) == 11
    layer_names = [l["Name"] for l in obj["Layers"]]
    assert "Base" in layer_names
    assert "Cliffs" in layer_names
    assert "River" in layer_names
    assert "Fringe" in layer_names


def test_hybrid_town_synthesis_connectivity_and_score(tmp_path):
    """Test full novel hybrid town generation combining canonical + PixelLab assets."""
    client = PixelLabClient(cache_dir=tmp_path / "cache")
    synth = HybridTownSynthesizer(pixellab_client=client, project_root=tmp_path)
    layout, artifacts = synth.synthesize_waterfall_haven(name="test_waterfall_haven", seed=20260830)

    assert layout.validation.status == "PASS"
    assert layout.validation.score.connectivity == 100.0
    assert layout.visual_score.total_visual_score >= 85.0
    assert layout.composite_score >= 95.0
    assert artifacts["ground"].exists()
    assert artifacts["tile"].exists()
    assert artifacts["script"].exists()
