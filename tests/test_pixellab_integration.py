"""Automated Unit and Integration Tests for PixelLab-Powered PMDO Town Engine."""
from __future__ import annotations

import json
from pathlib import Path

import pytest
from PIL import Image

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
    # N=0, NE=2, E=4, SE=8, S=16, SW=32, W=64, NW=128
    mask_north_edge = 4 | 16 | 64
    assert engine.bitmask_to_wang_index(mask_north_edge) == 1


def test_pixellab_structure_stamp_generation(pixellab_client):
    """Test generation of authentic PMD building stamps with transparency via PixelLab."""
    asset = pixellab_client.create_structure_stamp(
        description="pokemon mystery dungeon spinda cafe building with wooden timber beams",
        category="cafe",
        width=120,
        height=96,
        no_background=True,
    )

    assert asset.asset_type == "structure"
    assert Path(asset.image_path).exists()
    assert len(asset.sha256) == 64

    img = Image.open(asset.image_path)
    assert img.size == (120, 96)
    assert img.mode == "RGBA"


def test_pixellab_structure_engine_prefabs(tmp_path):
    """Test PixelLab structure engine sets up correct building prefabs & footprints."""
    client = PixelLabClient(cache_dir=tmp_path / "cache")
    engine = PixelLabStructureEngine(client=client, tile_size=24)

    # Verify core PMD prefabs are loaded
    assert "pokemon_center" in engine.prefabs
    assert "shop" in engine.prefabs
    assert "inn" in engine.prefabs
    assert "fountain" in engine.prefabs

    shop = engine.prefabs["shop"]
    assert shop.width == 4
    assert shop.height == 3
    # Check door cell is walkable (0) and walls are blocked (1)
    assert shop.collision[shop.door_pos[1]][shop.door_pos[0]] == TileCollision.WALKABLE.value


def test_end_to_end_pixellab_town_generation(tmp_path):
    """Test end-to-end procedural town generation using PixelLab backend."""
    client = PixelLabClient(cache_dir=tmp_path / "cache")
    generator = TownGenerator(pixellab_client=client)

    spec = TownSpec(
        name="pixellab_test_town",
        display_name="PixelLab Town",
        biome=BiomeType.GRASSLAND,
        season=SeasonType.SPRING,
        seed=20260830,
        width=48,
        height=48,
        elevation_levels=2,
        reference_style="metano",
    )

    layout, artifacts = generator.generate_and_export(spec, out_dir=tmp_path / "export")

    assert layout.validation.status == "PASS"
    assert layout.validation.score.connectivity == 100.0
    assert layout.composite_score >= 90.0
    assert artifacts["ground"].exists()
    assert artifacts["tile"].exists()


def test_metano_recreator_pixellab_integration(tmp_path):
    """Test Metano Town recreation using PixelLab backend and canonical palette."""
    client = PixelLabClient(cache_dir=tmp_path / "cache")
    recreator = MetanoRecreator(pixellab_client=client)

    layout = recreator.build_metano_layout()
    assert layout.validation.status == "PASS"
    assert layout.validation.score.connectivity == 100.0
    assert layout.visual_score.total_visual_score >= 85.0
    assert layout.composite_score >= 95.0

    rendered = recreator.render_exact_metano(layout, tile_size=24)
    assert rendered.size == (63 * 24, 63 * 24)
