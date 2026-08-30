"""PixelLab Structure & Building Engine for PMDO Town Generator.

Generates and registers PMDO-compliant pixel art building prefabs, shops, homes,
fountains, and decorations via PixelLab with transparent backgrounds and collision envelopes.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image

from .models import BiomeType, LayerType, SeasonType, StructurePrefab, TileCollision
from .pixellab_client import PixelLabAsset, PixelLabClient


class PixelLabStructureEngine:
    """Manages building and structure generation via PixelLab."""

    def __init__(
        self,
        client: Optional[PixelLabClient] = None,
        tile_size: int = 24,
        project_root: Optional[Path] = None,
    ):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.client = client or PixelLabClient(project_root=self.project_root)
        self.tile_size = tile_size
        self.loaded_sprites: Dict[str, Image.Image] = {}
        self.prefabs: Dict[str, StructurePrefab] = {}
        self._initialize_core_prefabs()

    def _initialize_core_prefabs(self) -> None:
        """Sets up default structure definitions and requests PixelLab generation."""
        core_defs = [
            {
                "id": "pokemon_center",
                "role": "pokemon_center",
                "category": "cafe",
                "tiles_w": 5,
                "tiles_h": 4,
                "door": (2, 3),
                "warp": "interior_pokemon_center",
                "prompt": "pokemon mystery dungeon spinda cafe building with wooden timber beams, tiled roof, warm glowing windows, transparent background",
                "ref_file": "metano_cafe_day.png",
            },
            {
                "id": "shop",
                "role": "shop",
                "category": "shop",
                "tiles_w": 4,
                "tiles_h": 3,
                "door": (2, 2),
                "warp": "interior_shop",
                "prompt": "pokemon mystery dungeon kecleon merchant shop with red striped fabric awning, wooden counter, market baskets, transparent background",
                "ref_file": "metano_kecleon_shop_day.png",
            },
            {
                "id": "inn",
                "role": "inn",
                "category": "inn",
                "tiles_w": 4,
                "tiles_h": 4,
                "door": (2, 3),
                "warp": "interior_inn",
                "prompt": "pokemon mystery dungeon cozy rustic wooden inn with signpost and timber framing, transparent background",
                "ref_file": "metano_cafe_day.png",
            },
            {
                "id": "house_small",
                "role": "residential",
                "category": "house_small",
                "tiles_w": 3,
                "tiles_h": 3,
                "door": (1, 2),
                "warp": "interior_house_small",
                "prompt": "pokemon mystery dungeon small elemental wooden cottage with thatched roof and cobblestone foundation, transparent background",
                "ref_file": "metano_house_normal_day.png",
            },
            {
                "id": "house_medium",
                "role": "residential",
                "category": "house_medium",
                "tiles_w": 4,
                "tiles_h": 3,
                "door": (2, 2),
                "warp": "interior_house_medium",
                "prompt": "pokemon mystery dungeon sturdy stone rock house with chimney and wooden door, transparent background",
                "ref_file": "metano_house_rock_day.png",
            },
            {
                "id": "house_large",
                "role": "residential",
                "category": "house_large",
                "tiles_w": 4,
                "tiles_h": 4,
                "door": (2, 3),
                "warp": "interior_house_large",
                "prompt": "pokemon mystery dungeon large brick fire home with red clay shingle roof, transparent background",
                "ref_file": "metano_house_fire_day.png",
            },
            {
                "id": "fountain",
                "role": "monument",
                "category": "fountain",
                "tiles_w": 3,
                "tiles_h": 3,
                "door": (1, 1),
                "warp": "",
                "prompt": "pokemon mystery dungeon multi-tier carved stone fountain with sparkling water pool, transparent background",
                "ref_file": None,
            },
        ]

        b_dir = self.project_root / "docs/metano_origins_structure_library/buildings"

        for d in core_defs:
            pid = d["id"]
            tw, th = d["tiles_w"], d["tiles_h"]
            px_w, px_h = tw * self.tile_size, th * self.tile_size
            ref_path = str(b_dir / d["ref_file"]) if d["ref_file"] and (b_dir / d["ref_file"]).exists() else None

            asset = self.client.create_structure_stamp(
                description=d["prompt"],
                category=d["category"],
                width=px_w,
                height=px_h,
                style_image_path=ref_path,
                no_background=True,
            )

            img = Image.open(asset.image_path).convert("RGBA")
            self.loaded_sprites[pid] = img

            # Build footprint collision grid: row-major [[int]] matching height x width
            footprint = [[TileCollision.BLOCKED.value for _ in range(tw)] for _ in range(th)]
            dx, dy = d["door"]
            if 0 <= dy < th and 0 <= dx < tw:
                footprint[dy][dx] = TileCollision.WALKABLE.value

            prefab = StructurePrefab(
                id=pid,
                role=d["role"],
                width=tw,
                height=th,
                layers={},
                collision=footprint,
                door_pos=d["door"],
                door_warp_target=d["warp"],
                allowed_biomes=list(BiomeType),
                allowed_seasons=list(SeasonType),
                allowed_elevations=[0, 1, 2],
                clearance_margin=1,
            )
            self.prefabs[pid] = prefab

    def get_prefab(self, prefab_id: str) -> Optional[StructurePrefab]:
        return self.prefabs.get(prefab_id)

    def get_sprite(self, prefab_id: str) -> Optional[Image.Image]:
        return self.loaded_sprites.get(prefab_id)

    def generate_custom_building(
        self,
        prefab_id: str,
        role: str,
        prompt: str,
        width_tiles: int,
        height_tiles: int,
        door_offset: Tuple[int, int],
        door_warp_target: str = "",
        category: str = "custom",
    ) -> StructurePrefab:
        """Generates an entirely custom building via PixelLab."""
        px_w = width_tiles * self.tile_size
        px_h = height_tiles * self.tile_size

        asset = self.client.create_structure_stamp(
            description=prompt,
            category=category,
            width=px_w,
            height=px_h,
            no_background=True,
        )

        img = Image.open(asset.image_path).convert("RGBA")
        self.loaded_sprites[prefab_id] = img

        footprint = [[TileCollision.BLOCKED.value for _ in range(width_tiles)] for _ in range(height_tiles)]
        dx, dy = door_offset
        if 0 <= dy < height_tiles and 0 <= dx < width_tiles:
            footprint[dy][dx] = TileCollision.WALKABLE.value

        prefab = StructurePrefab(
            id=prefab_id,
            role=role,
            width=width_tiles,
            height=height_tiles,
            layers={},
            collision=footprint,
            door_pos=door_offset,
            door_warp_target=door_warp_target,
            allowed_biomes=list(BiomeType),
            allowed_seasons=list(SeasonType),
            allowed_elevations=[0, 1, 2],
            clearance_margin=1,
        )
        self.prefabs[prefab_id] = prefab
        return prefab
