"""Comprehensive automated test suite for PMU-to-PMDO extraction, rendering, and adaptation pipeline."""
import json
import sqlite3
import sys
from pathlib import Path
from PIL import Image
import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))
if str(REPO_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "tools"))

from pmu_pipeline.catalog import PMUCatalog
from pmu_pipeline.constants import (
    DEFINITE_BLOCK_TYPES,
    PMDO_SUBTILE_SIZE,
    PMU_TILE_SIZE,
    SUBTILES_PER_PMU_TILE,
)
from pmu_pipeline.converter import PMDOConverter, read_pmdo_tile_file
from pmu_pipeline.extractor import PMUExtractor, normalize_map_id
from pmu_pipeline.renderer import PMURenderer
from pmu_pipeline.validator import PMDOValidator
DB_PATH = REPO_ROOT / ".runtime-cache/pmu-extraction/pmu-standard.sqlite3"
TILES_DIR = REPO_ROOT / ".runtime-cache/pmu/PMU-Client/resources/GFX/Tiles"


@pytest.fixture(scope="module")
def extractor():
    assert DB_PATH.exists(), f"Database missing at {DB_PATH}"
    return PMUExtractor(DB_PATH, REPO_ROOT)


@pytest.fixture(scope="module")
def renderer():
    assert TILES_DIR.exists(), f"Tiles directory missing at {TILES_DIR}"
    r = PMURenderer(TILES_DIR)
    yield r
    r.close()


@pytest.fixture(scope="module")
def converter(renderer):
    return PMDOConverter(REPO_ROOT, renderer)


@pytest.fixture(scope="module")
def validator():
    return PMDOValidator(REPO_ROOT)


@pytest.fixture(scope="module")
def catalog():
    return PMUCatalog(DB_PATH, REPO_ROOT)


class TestPMUExtraction:
    def test_normalize_map_id(self):
        assert normalize_map_id("95") == "s95"
        assert normalize_map_id("s95") == "s95"
        assert normalize_map_id(95) == "s95"
        assert normalize_map_id("S737") == "s737"

    def test_extract_s95_golden(self, extractor):
        data = extractor.extract_map("s95")
        pmu = data["pmu_map"]
        assert pmu["map_id"] == "s95"
        assert pmu["name"] == "Stone-Solid Dungeon B1F"
        assert pmu["dimensions"]["width_tiles"] == 20
        assert pmu["dimensions"]["height_tiles"] == 15
        assert pmu["dimensions"]["width_px"] == 640
        assert pmu["dimensions"]["height_px"] == 480
        assert len(pmu["tiles"]) == 300

        col = data["collision"]
        assert col["dimensions_tiles"] == [20, 15]
        assert col["definite_block_count"] == 111
        assert col["walkable_count"] == 189

        ent = data["entities"]
        assert ent["npc_count"] == 9
        assert len(ent["npcs"]) == 9

        tset = data["tileset"]
        assert 9 in tset["tileset_ids"]

    def test_extract_s737_grassroot(self, extractor):
        data = extractor.extract_map("s737")
        pmu = data["pmu_map"]
        assert pmu["map_id"] == "s737"
        assert pmu["name"] == "Exbel, Grassroot Town"
        assert pmu["dimensions"]["width_tiles"] == 51
        assert pmu["dimensions"]["height_tiles"] == 51
        assert pmu["dimensions"]["width_px"] == 1632
        assert pmu["dimensions"]["height_px"] == 1632
        assert len(pmu["tiles"]) == 2601

        sem = data["semantics"]
        assert sem["warps_count"] == 12
        assert sem["signs_count"] > 0
        assert data["tileset"]["animated_tiles_count"] > 0


class TestPMURendering:
    def test_render_s95_golden(self, extractor, renderer):
        data = extractor.extract_map("s95")
        img = renderer.render_map(data["pmu_map"], animated=False)
        assert img.size == (640, 480)
        assert img.mode == "RGB"

        preview = renderer.render_preview(img, max_dimension=256)
        assert max(preview.size) <= 256

        col_img = renderer.render_collision_overlay(img, data["pmu_map"])
        assert col_img.size == (640, 480)

    def test_render_s737_animated(self, extractor, renderer):
        data = extractor.extract_map("s737")
        base = renderer.render_map(data["pmu_map"], animated=False)
        anim = renderer.render_map(data["pmu_map"], animated=True)
        assert base.size == (1632, 1632)
        assert anim.size == (1632, 1632)
        # Verify that animation frames differ for animated tiles
        assert base.tobytes() != anim.tobytes()


class TestPMDOAdaptationAndRoundTrip:
    def test_s95_conversion_and_pixel_perfect_roundtrip(self, extractor, converter, validator, renderer):
        data = extractor.extract_map("s95")
        result = converter.convert_map(data)

        assert result["rsground"]["Object"]["TexSize"] == 1
        assert result["rsground"]["Object"]["AssetName"] == "pmu_s95"
        assert len(result["pmdo_layers"]) == 5
        assert [l["Name"] for l in result["pmdo_layers"]] == [
            "PMU Ground", "PMU Mask", "PMU Mask2", "PMU Fringe", "PMU Fringe2"
        ]

        # Verify .tile binary file can be read back
        tile_size, tile_images = read_pmdo_tile_file(result["tile_path"])
        assert tile_size == 8
        assert len(tile_images) == result["atlas_entries_count"]

        # Render PMDO Ground map
        pmdo_rendered = validator.render_pmdo_map(result["rsground"], tile_images, frame_index=0)
        assert pmdo_rendered.size == (640, 480)

        # Golden PMU render
        pmu_golden = renderer.render_map(data["pmu_map"], animated=False)

        # Visual diff validation: 0.0000% difference required
        vis_res = validator.validate_visual(pmu_golden, pmdo_rendered)
        assert vis_res["status"] == "VALIDATED"
        assert vis_res["diff_pixels_base"] == 0
        assert vis_res["diff_percentage_base"] == 0.0
        assert vis_res["perfect_byte_match"] is True

        # Collision validation: 100% match required
        col_res = validator.validate_collision(data["collision"], result["rsground"])
        assert col_res["status"] == "VALIDATED"
        assert col_res["total_pmu_cells"] == 300
        assert col_res["total_pmdo_cells"] == 4800  # 300 * 16
        assert col_res["matched_cells"] == 4800
        assert col_res["lost_blocked_cells"] == 0
        assert col_res["perfect_collision_match"] is True

    def test_s737_animated_roundtrip(self, extractor, converter, validator, renderer):
        data = extractor.extract_map("s737")
        result = converter.convert_map(data)

        tile_size, tile_images = read_pmdo_tile_file(result["tile_path"])
        pmdo_base = validator.render_pmdo_map(result["rsground"], tile_images, frame_index=0)
        pmdo_anim = validator.render_pmdo_map(result["rsground"], tile_images, frame_index=1)

        pmu_base = renderer.render_map(data["pmu_map"], animated=False)
        pmu_anim = renderer.render_map(data["pmu_map"], animated=True)

        vis_res = validator.validate_visual(pmu_base, pmdo_base, pmu_anim, pmdo_anim)
        assert vis_res["status"] == "VALIDATED"
        assert vis_res["diff_pixels_base"] == 0
        assert vis_res["diff_pixels_anim"] == 0
        assert vis_res["perfect_byte_match"] is True


class TestCatalogAndSearch:
    def test_catalog_query(self, catalog):
        total = catalog.get_total_count()
        assert total == 2000

        res_grassroot = catalog.list_maps(query="Grassroot", limit=20)
        assert len(res_grassroot) > 0
        assert any(r["map_id"] == "s737" for r in res_grassroot)

        res_s95 = catalog.get_map_summary("s95")
        assert res_s95 is not None
        assert res_s95["name"] == "Stone-Solid Dungeon B1F"
        assert res_s95["dimensions_tiles"] == [20, 15]
