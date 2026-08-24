"""BPA (animated background tiles) decoder — placeholder.

BPA declares per-descriptor animation frames for tiles that swap over
time (waterfalls, torches, glowing crystals). The decoder returns
BPA_IR records ready for mapping into RogueEssence animated tile
metadata; raw pixels stay under converter/rom_output/ (git-ignored).
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str):
    raise NotImplementedError("BPA decoder not implemented yet.")
