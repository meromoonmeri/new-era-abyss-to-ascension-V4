"""Structure Prefab Stamp Library for PMDO Town Generator.

Stores multi-layer building prefabs, real pixel art sprites,
collision envelopes, doorway anchors, and clearance constraints.
"""
from __future__ import annotations

import io
import json
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from PIL import Image

from .models import BiomeType, LayerType, SeasonType, StructurePrefab, TileCollision


class StructureLibrary:
    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.prefabs: Dict[str, StructurePrefab] = {}
        self.sprite_cache: Dict[str, Image.Image] = {}
        self._load_default_prefabs()
        self._load_sprites()

    def _load_sprites(self) -> None:
        """Loads real pixel art building images from docs/metano_origins_structure_library/buildings/."""
        b_dir = self.project_root / "docs/metano_origins_structure_library/buildings"
        if not b_dir.exists():
            return

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
            img_path = b_dir / filename
            if img_path.exists():
                try:
                    self.sprite_cache[p_id] = Image.open(img_path).convert("RGBA")
                except Exception:
                    pass

    def get_sprite(self, prefab_id: str) -> Optional[Image.Image]:
        return self.sprite_cache.get(prefab_id)

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
        )

    def get_prefab(self, prefab_id: str) -> Optional[StructurePrefab]:
        return self.prefabs.get(prefab_id)

    def list_prefabs(self) -> List[str]:
        return list(self.prefabs.keys())
