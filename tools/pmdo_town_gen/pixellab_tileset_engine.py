"""PixelLab Wang Tileset Engine for PMDO Town Generator.

Manages 16-tile Wang terrain sets, bitmask-to-Wang mapping, seamless transitions,
and export to PMDO native tile sheets.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image

from .models import BiomeType, SeasonType
from .pixellab_client import PixelLabClient, PixelLabWangTileset


class PixelLabTilesetEngine:
    """Manages terrain Wang autotiling using PixelLab generated tilesets."""

    def __init__(
        self,
        client: Optional[PixelLabClient] = None,
        tile_size: int = 24,
        project_root: Optional[Path] = None,
    ):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.client = client or PixelLabClient(project_root=self.project_root)
        self.tile_size = tile_size
        self.loaded_tilesets: Dict[str, Image.Image] = {}
        self.tileset_metadata: Dict[str, PixelLabWangTileset] = {}

    def get_or_create_tileset(
        self,
        lower_terrain: str,
        upper_terrain: str,
        biome: BiomeType = BiomeType.GRASSLAND,
        season: SeasonType = SeasonType.SPRING,
        palette_hint: Optional[Dict[str, Tuple[int, int, int]]] = None,
    ) -> PixelLabWangTileset:
        """Retrieves or generates a Wang tileset connecting two terrain types."""
        tag = f"{lower_terrain}_{upper_terrain}_{biome.value}_{season.value}"
        if tag in self.tileset_metadata:
            return self.tileset_metadata[tag]

        tileset = self.client.create_topdown_tileset(
            lower_description=f"{biome.value} {season.value} {lower_terrain}",
            upper_description=f"{biome.value} {season.value} {upper_terrain}",
            tile_size=self.tile_size,
            palette_hint=palette_hint,
        )

        img = Image.open(tileset.image_path).convert("RGBA")
        self.loaded_tilesets[tag] = img
        self.tileset_metadata[tag] = tileset
        return tileset

    def get_tile_subimage(
        self,
        tileset_tag: str,
        wang_index: int,
    ) -> Image.Image:
        """Extracts the specific sub-tile (0..15) from a loaded 4x4 Wang atlas."""
        if tileset_tag not in self.loaded_tilesets:
            raise KeyError(f"Tileset {tileset_tag} not loaded in PixelLab engine.")

        atlas = self.loaded_tilesets[tileset_tag]
        ts = self.tile_size
        idx = max(0, min(15, wang_index))
        row = idx // 4
        col = idx % 4

        box = (col * ts, row * ts, (col + 1) * ts, (row + 1) * ts)
        return atlas.crop(box)

    @staticmethod
    def bitmask_to_wang_index(bitmask: int) -> int:
        """Maps 8-neighbor bitmask (0..255) to standard 16-tile Wang index (0..15)."""
        # North = 1, East = 4, South = 16, West = 64
        n = bool(bitmask & 1)
        ne = bool(bitmask & 2)
        e = bool(bitmask & 4)
        se = bool(bitmask & 8)
        s = bool(bitmask & 16)
        sw = bool(bitmask & 32)
        w = bool(bitmask & 64)
        nw = bool(bitmask & 128)

        # 1. Fully surrounded by upper terrain -> Solid Upper
        if n and e and s and w and ne and se and sw and nw:
            return 0

        # 2. Fully surrounded by lower terrain -> Solid Lower
        if not (n or e or s or w or ne or se or sw or nw):
            return 15

        # 3. Cardinal Edges (3 neighbors matching, 1 lower)
        if not n and e and s and w:
            return 1  # North edge
        if n and not e and s and w:
            return 2  # East edge
        if n and e and not s and w:
            return 4  # South edge
        if n and e and s and not w:
            return 8  # West edge

        # 4. Outer Corners (2 adjacent lower edges)
        if not n and not e:
            return 3  # NE corner
        if not s and not e:
            return 6  # SE corner
        if not s and not w:
            return 12 # SW corner
        if not n and not w:
            return 9  # NW corner

        # 5. Inner Corners (cardinals match, but diagonal corner is lower)
        if n and e and not ne:
            return 14 # NE inner
        if n and w and not nw:
            return 13 # NW inner
        if s and e and not se:
            return 7  # SE inner
        if s and w and not sw:
            return 11 # SW inner

        # 6. Channels / Bridges
        if not e and not w:
            return 5  # Vertical channel (N+S bridge)
        if not n and not s:
            return 10 # Horizontal channel (E+W bridge)

        return 0
