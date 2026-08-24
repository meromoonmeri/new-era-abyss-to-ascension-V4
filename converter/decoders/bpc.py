"""BPC (Background Palette Chunk) decoder — placeholder.

BPC holds the tileset chunks + palettes referenced by BMA layers. The
decoder will return an Asset_IR describing the atlas layout without
reproducing any Nintendo art in the repository; the actual pixel data
is written to converter/rom_output/ (git-ignored) for downstream
mapping to Content/Tile atlases.
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str):
    raise NotImplementedError("BPC decoder not implemented yet.")
