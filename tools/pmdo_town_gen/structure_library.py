<<<<<<< HEAD
"""Structure Prefab Stamp Library for PMDO Town Generator.

Stores multi-layer building prefabs, real pixel art sprites,
collision envelopes, doorway anchors, and clearance constraints,
powered by PixelLab.
"""
from __future__ import annotations

import io
import json
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from PIL import Image

from .models import BiomeType, LayerType, SeasonType, StructurePrefab, TileCollision
from .pixellab_client import PixelLabClient
from .pixellab_structure_engine import PixelLabStructureEngine


class StructureLibrary:
    def __init__(
        self,
        project_root: Optional[Path] = None,
        pixellab_client: Optional[PixelLabClient] = None,
    ):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.pixellab_client = pixellab_client or PixelLabClient(project_root=self.project_root)
        self.pixellab_engine = PixelLabStructureEngine(
            client=self.pixellab_client,
            project_root=self.project_root,
        )
        self.prefabs: Dict[str, StructurePrefab] = {}
        self.sprite_cache: Dict[str, Image.Image] = {}
        self._load_default_prefabs()
        self._load_sprites()

    def _load_sprites(self) -> None:
        """Loads real pixel art building images from docs/metano_origins_structure_library/buildings/ and PixelLab."""
        b_dir = self.project_root / "docs/metano_origins_structure_library/buildings"

        sprite_map = {
            "pokemon_center": "metano_cafe_day.png",
            "inn": "metano_cafe_day.png",
            "shop": "metano_kecleon_shop_day.png",
            "house_small": "metano_house_normal_day.png",
            "house_medium": "metano_house_rock_day.png",
            "house_large": "metano_house_fire_day.png",
            "well": "origins_well_frame_0.png",
            "windmill": "origins_windmill_frame_0.png",
        }

        for p_id, filename in sprite_map.items():
            if b_dir.exists():
                img_path = b_dir / filename
                if img_path.exists():
                    try:
                        self.sprite_cache[p_id] = Image.open(img_path).convert("RGBA")
                        continue
                    except Exception:
                        pass
            
            # If not found in static folder, check PixelLab engine
            pl_sprite = self.pixellab_engine.get_sprite(p_id)
            if pl_sprite:
                self.sprite_cache[p_id] = pl_sprite

    def get_sprite(self, prefab_id: str) -> Optional[Image.Image]:
        # First check direct cache
        if prefab_id in self.sprite_cache:
            return self.sprite_cache[prefab_id]
        # Then check PixelLab engine
        pl_sprite = self.pixellab_engine.get_sprite(prefab_id)
        if pl_sprite:
            self.sprite_cache[prefab_id] = pl_sprite
            return pl_sprite
        return None

    def _load_default_prefabs(self) -> None:
        """Initializes canonical Pokémon structures with exact layer & collision schemas."""
        
        # 1. POKÉMON CENTER (7x6 tiles = 168x144 px at 24px)
        pc_collision = [
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 0, 1, 1, 1],
        ]
        self.prefabs["pokemon_center"] = StructurePrefab(
            id="pokemon_center",
            role="pokemon_center",
            width=7,
            height=6,
            layers={},
            collision=pc_collision,
            door_pos=(3, 5),
            door_warp_target="interior_pokemon_center",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1],
            clearance_margin=1,
        )

        # 2. POKÉMON MART / KECLEON SHOP (5x5 tiles = 120x120 px)
        shop_collision = [
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 0, 1, 1],
        ]
        self.prefabs["shop"] = StructurePrefab(
            id="shop",
            role="shop",
            width=5,
            height=5,
            layers={},
            collision=shop_collision,
            door_pos=(2, 4),
            door_warp_target="interior_shop",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1],
            clearance_margin=1,
        )

        # 3. CAFE / INN (8x6 tiles = 192x144 px)
        inn_collision = [
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 0, 1, 1, 1],
        ]
        self.prefabs["inn"] = StructurePrefab(
            id="inn",
            role="inn",
            width=8,
            height=6,
            layers={},
            collision=inn_collision,
            door_pos=(4, 5),
            door_warp_target="interior_inn",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1],
            clearance_margin=1,
        )

        # 4. HOUSE SMALL (4x4 tiles = 96x96 px)
        house_s_collision = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 0, 1],
        ]
        self.prefabs["house_small"] = StructurePrefab(
            id="house_small",
            role="residential",
            width=4,
            height=4,
            layers={},
            collision=house_s_collision,
            door_pos=(2, 3),
            door_warp_target="interior_house_small",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1, 2],
            clearance_margin=1,
        )

        # 5. HOUSE MEDIUM (5x4 tiles = 120x96 px)
        house_m_collision = [
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 0, 1, 1],
        ]
        self.prefabs["house_medium"] = StructurePrefab(
            id="house_medium",
            role="residential",
            width=5,
            height=4,
            layers={},
            collision=house_m_collision,
            door_pos=(2, 3),
            door_warp_target="interior_house_medium",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1, 2],
            clearance_margin=1,
        )

        # 6. HOUSE LARGE (6x5 tiles = 144x120 px)
        house_l_collision = [
            [1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1],
            [1, 1, 1, 0, 1, 1],
        ]
        self.prefabs["house_large"] = StructurePrefab(
            id="house_large",
            role="residential",
            width=6,
            height=5,
            layers={},
            collision=house_l_collision,
            door_pos=(3, 4),
            door_warp_target="interior_house_large",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1, 2],
            clearance_margin=1,
        )

        # 7. FOUNTAIN (4x4 tiles = 96x96 px)
        fountain_collision = [
            [0, 1, 1, 0],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [0, 1, 1, 0],
        ]
        self.prefabs["fountain"] = StructurePrefab(
            id="fountain",
            role="monument",
            width=4,
            height=4,
            layers={},
            collision=fountain_collision,
            door_pos=(2, 3),
            door_warp_target="",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1],
            clearance_margin=1,
        )

        # 8. WELL (3x3 tiles = 72x72 px)
        well_collision = [
            [0, 1, 0],
            [1, 1, 1],
            [0, 1, 0],
        ]
        self.prefabs["well"] = StructurePrefab(
            id="well",
            role="monument",
            width=3,
            height=3,
            layers={},
            collision=well_collision,
            door_pos=(1, 2),
            door_warp_target="",
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1, 2],
            clearance_margin=1,
        )

        # 9. WINDMILL (4x4 tiles = 96x96 px)
        windmill_collision = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
        ]
        self.prefabs["windmill"] = StructurePrefab(
            id="windmill",
            role="landmark",
            width=4,
            height=4,
            layers={},
            collision=windmill_collision,
            door_pos=(2, 3),
            door_warp_target="interior_windmill",
            allowed_biomes=[BiomeType.GRASSLAND, BiomeType.MOUNTAIN, BiomeType.COASTAL],
            allowed_seasons=list(SeasonType),
            allowed_elevations=[1, 2],
            clearance_margin=2,
=======
"""Structure stamp and building definition library for PMDO town generator."""
from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from PIL import Image, ImageDraw


@dataclass
class StructurePrefab:
    id: str
    name: str
    role: str
    width: int  # in 24x24 tiles
    height: int  # in 24x24 tiles
    door_relative_pos: Tuple[int, int]
    door_tile_offset: Tuple[int, int]
    solid_footprint: List[Tuple[int, int]]
    roof_offset_y: int
    allowed_biomes: List[str]
    sprite_path: Optional[Path] = None


class StructureLibrary:
    """Library of buildings, monuments, and props."""

    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.prefabs: Dict[str, StructurePrefab] = {}
        self._init_prefabs()

    def _init_prefabs(self) -> None:
        self.prefabs["shop"] = StructurePrefab(
            id="shop",
            name="Kecleon General Store",
            role="shop",
            width=4,
            height=3,
            door_relative_pos=(2, 2),
            door_tile_offset=(2, 2),
            solid_footprint=[(x, y) for x in range(4) for y in range(3) if (x, y) != (2, 2)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["pokemon_center"] = StructurePrefab(
            id="pokemon_center",
            name="Kangaskhan Storage & Care",
            role="storage",
            width=5,
            height=4,
            door_relative_pos=(2, 3),
            door_tile_offset=(2, 3),
            solid_footprint=[(x, y) for x in range(5) for y in range(4) if (x, y) != (2, 3)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["inn"] = StructurePrefab(
            id="inn",
            name="Explorers Rest Inn",
            role="inn",
            width=4,
            height=4,
            door_relative_pos=(2, 3),
            door_tile_offset=(2, 3),
            solid_footprint=[(x, y) for x in range(4) for y in range(4) if (x, y) != (2, 3)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["house_small"] = StructurePrefab(
            id="house_small",
            name="Cozy Cottage",
            role="residential",
            width=3,
            height=3,
            door_relative_pos=(1, 2),
            door_tile_offset=(1, 2),
            solid_footprint=[(x, y) for x in range(3) for y in range(3) if (x, y) != (1, 2)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["house_medium"] = StructurePrefab(
            id="house_medium",
            name="Timber Dwelling",
            role="residential",
            width=4,
            height=3,
            door_relative_pos=(2, 2),
            door_tile_offset=(2, 2),
            solid_footprint=[(x, y) for x in range(4) for y in range(3) if (x, y) != (2, 2)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["house_large"] = StructurePrefab(
            id="house_large",
            name="Expedition Manor",
            role="residential",
            width=4,
            height=4,
            door_relative_pos=(2, 3),
            door_tile_offset=(2, 3),
            solid_footprint=[(x, y) for x in range(4) for y in range(4) if (x, y) != (2, 3)],
            roof_offset_y=1,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
        )

        self.prefabs["fountain"] = StructurePrefab(
            id="fountain",
            name="Village Stone Fountain",
            role="monument",
            width=3,
            height=3,
            door_relative_pos=(1, 2),
            door_tile_offset=(1, 2),
            solid_footprint=[(x, y) for x in range(3) for y in range(3)],
            roof_offset_y=0,
            allowed_biomes=["grassland", "forest", "mountain", "coastal"],
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        )

    def get_prefab(self, prefab_id: str) -> Optional[StructurePrefab]:
        return self.prefabs.get(prefab_id)

<<<<<<< HEAD
    def list_prefabs(self) -> List[str]:
        return list(self.prefabs.keys())
=======
    def render_structure_sprite(self, prefab_id: str, tile_size: int = 24) -> Image.Image:
        """Renders authentic PMD pixel-art building sprite with roofs and walls."""
        prefab = self.get_prefab(prefab_id)
        if not prefab:
            img = Image.new("RGBA", (tile_size * 3, tile_size * 3), (120, 100, 80, 255))
            return img

        w_px = prefab.width * tile_size
        h_px = prefab.height * tile_size
        img = Image.new("RGBA", (w_px, h_px), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)

        # Style colors
        if prefab.role == "shop":
            roof_col = (180, 60, 50, 255)       # Red Kecleon awning
            wall_col = (220, 190, 140, 255)     # Cream plaster
            trim_col = (110, 50, 30, 255)
            door_col = (75, 45, 25, 255)
        elif prefab.role == "storage":
            roof_col = (190, 130, 45, 255)      # Amber thatch
            wall_col = (175, 140, 105, 255)     # Hewn stone
            trim_col = (110, 80, 55, 255)
            door_col = (65, 40, 25, 255)
        elif prefab.role == "inn":
            roof_col = (60, 105, 160, 255)      # Deep blue slate
            wall_col = (205, 180, 145, 255)     # Timber frame
            trim_col = (85, 55, 35, 255)
            door_col = (60, 40, 25, 255)
        elif prefab.role == "monument":
            roof_col = (130, 150, 165, 255)     # Carved stone
            wall_col = (150, 165, 180, 255)
            trim_col = (90, 105, 120, 255)
            door_col = (65, 145, 205, 255)      # Water pool
        else:
            roof_col = (170, 85, 45, 255)       # Terracotta
            wall_col = (215, 195, 160, 255)
            trim_col = (100, 65, 40, 255)
            door_col = (70, 45, 25, 255)

        # Draw Walls
        wall_y = int(h_px * 0.4)
        draw.rectangle([4, wall_y, w_px - 5, h_px - 4], fill=wall_col, outline=trim_col, width=2)

        # Draw Roof
        draw.polygon([(0, wall_y + 4), (w_px // 2, 2), (w_px - 1, wall_y + 4)], fill=roof_col, outline=trim_col)
        # Roof highlights
        draw.line([(w_px // 2, 2), (0, wall_y + 4)], fill=(min(255, roof_col[0] + 40), min(255, roof_col[1] + 40), min(255, roof_col[2] + 40), 255), width=2)

        # Draw Door & Windows
        dx = prefab.door_relative_pos[0] * tile_size + (tile_size - 14) // 2
        dy = h_px - 20
        draw.rectangle([dx, dy, dx + 14, h_px - 4], fill=door_col, outline=trim_col, width=1)
        draw.ellipse([dx + 10, dy + 8, dx + 12, dy + 10], fill=(250, 220, 80, 255))  # Brass handle

        # Windows
        for wx in range(8, w_px - 16, tile_size):
            if abs(wx - dx) > 16:
                draw.rectangle([wx, wall_y + 8, wx + 10, wall_y + 18], fill=(240, 230, 130, 255), outline=trim_col, width=1)
                draw.line([wx + 5, wall_y + 8, wx + 5, wall_y + 18], fill=trim_col)
                draw.line([wx, wall_y + 13, wx + 10, wall_y + 13], fill=trim_col)

        return img
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
