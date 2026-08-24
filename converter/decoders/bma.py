"""BMA (Background Map Assembly) decoder — placeholder.

BMA is the GBA map-layer container used by PMD Red: it declares one or
more chunk-indexed layers, one or more collision layers, plus animated
tile references. The header layout is documented publicly by the
SkyTemple project (skytemple-files, MIT). This module will parse the
container structure once the ROM offsets are known via the registry.

For now, the decoder returns an empty BMA_IR shell and reports
UNIMPLEMENTED so no downstream stage can silently emit garbage.
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str):
    """Return (BMA_IR, list[str] warnings). Currently raises NotImplemented."""
    raise NotImplementedError(
        "BMA decoder not implemented yet. Contribute the header parser "
        "based on the SkyTemple docs; keep unknown regions as raw bytes "
        "in BMA_IR.unknown_data instead of dropping them."
    )
