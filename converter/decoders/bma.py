"""BMA (Background Map Assembly) decoder for PMD Red.

BMA is the container format that describes a ground map's structural
layout: a header of 12 bytes, then one or two NRL-compressed chunk
mapping layers, then zero to two collision layers, then an optional
"data" layer whose semantics are game-specific.

Header layout (12 bytes, structure documented publicly by the pret
decompilation under MIT and by the SkyTemple project):

    struct BmaHeader {
        u8  map_width_tiles;
        u8  map_height_tiles;
        u8  tiling_width;       // always 3 in this game
        u8  tiling_height;      // always 3
        u8  map_width_chunks;
        u8  map_height_chunks;
        u16 num_layers;         // 1 or 2
        s16 has_data_layer;     // 0 or 1
        s16 has_collision;      // 0, 1 or 2
    };

For each background layer we then read a chunk-mapping compressed with
the format's specific NRL scheme (documented below). Each collision
layer is a plain byte grid of size (width_tiles * height_tiles). The
optional data layer is the same size.

This decoder is a Python reimplementation of the format shape. It
never reproduces game data; the byte stream it consumes comes from the
user's local ROM, extracted by s01.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field
from typing import Optional

from converter.ir.ground import (
    BMA_IR,
    BPA_IR,
    CollisionLayer_IR,
    TileLayer_IR,
)
from converter.ir.provenance import Provenance, Status


HEADER_SIZE = 12
CHUNK_TILE_SIDE = 3     # tiling is always 3x3 for this game


@dataclass(frozen=True)
class BmaHeaderRaw:
    map_width_tiles:  int
    map_height_tiles: int
    tiling_width:     int
    tiling_height:    int
    map_width_chunks: int
    map_height_chunks: int
    num_layers:       int
    has_data_layer:   int
    has_collision:    int


def _read_header(blob: bytes) -> BmaHeaderRaw:
    if len(blob) < HEADER_SIZE:
        raise ValueError(
            f"BMA too short for header ({len(blob)} < {HEADER_SIZE})"
        )
    (
        mw_t, mh_t, tw, th, mw_c, mh_c, nl, hd, hc
    ) = struct.unpack_from("<BBBBBBhhh", blob, 0)
    return BmaHeaderRaw(
        map_width_tiles=mw_t,
        map_height_tiles=mh_t,
        tiling_width=tw,
        tiling_height=th,
        map_width_chunks=mw_c,
        map_height_chunks=mh_c,
        num_layers=nl,
        has_data_layer=hd,
        has_collision=hc,
    )


def _validate_header(h: BmaHeaderRaw) -> list[str]:
    """Return a list of human-readable warnings about the header.

    A completely bogus header (e.g. width_tiles=0) is a strong signal
    that we are pointing at random bytes, not at a real BMA. Callers
    can turn warnings into a hard error at their own discretion.
    """
    w: list[str] = []
    if h.tiling_width != CHUNK_TILE_SIDE or h.tiling_height != CHUNK_TILE_SIDE:
        w.append(
            f"tiling {h.tiling_width}x{h.tiling_height} != expected "
            f"{CHUNK_TILE_SIDE}x{CHUNK_TILE_SIDE}"
        )
    if h.map_width_tiles == 0 or h.map_height_tiles == 0:
        w.append("width/height in tiles is zero")
    if h.map_width_chunks == 0 or h.map_height_chunks == 0:
        w.append("width/height in chunks is zero")
    if h.num_layers not in (1, 2):
        w.append(f"num_layers={h.num_layers} not in {{1,2}}")
    if h.has_collision not in (0, 1, 2):
        w.append(f"has_collision={h.has_collision} not in {{0,1,2}}")
    if h.has_data_layer not in (0, 1):
        w.append(f"has_data_layer={h.has_data_layer} not in {{0,1}}")

    # Consistency check: mapWidthChunks * tilingWidth should equal
    # mapWidthTiles for the vast majority of BMAs in this game.
    if h.map_width_chunks * CHUNK_TILE_SIDE != h.map_width_tiles:
        w.append(
            f"width_chunks({h.map_width_chunks})*3 != width_tiles"
            f"({h.map_width_tiles})"
        )
    if h.map_height_chunks * CHUNK_TILE_SIDE != h.map_height_tiles:
        w.append(
            f"height_chunks({h.map_height_chunks})*3 != height_tiles"
            f"({h.map_height_tiles})"
        )
    return w


# ---------------------------------------------------------------- NRL


def _decompress_layer_nrl(
    blob: bytes, offset: int, width_chunks: int, height_chunks: int
) -> tuple[list[int], int]:
    """Decompress one BMA chunk-mapping layer.

    Returns (chunk_indices, bytes_consumed).

    The NRL scheme reads command bytes and produces 12-bit values that
    are then combined into 16-bit chunk indices (2 chunk indices per
    3-byte value). For the first row of chunks each value is stored
    directly; for subsequent rows each value is XORed with the value
    64 chunks earlier in the output (the "reference row" trick). The
    command byte selects one of three modes:

        cmd < 0x80 :  emit (cmd + 1) pairs of zeros
        0x80..0xBF :  emit (cmd - 0x7F) pairs, all equal to the next
                      3-byte value (run compression)
        0xC0..0xFF :  emit (cmd - 0xBF) pairs, each pair coming from
                      its OWN next 3-byte value (raw block)

    On rows > 0, each emitted 12-bit value is XORed with the value 64
    positions earlier in the output stream.

    Sources: public pret/pmd-red decompilation (MIT) plus the SkyTemple
    documentation of the equivalent GBA-era format.
    """
    total_chunks = width_chunks * height_chunks
    out: list[int] = []
    src = offset
    n = len(blob)

    for row in range(height_chunks):
        col = 0
        row_start = len(out)
        while col < width_chunks:
            if src >= n:
                raise ValueError(
                    f"BMA NRL truncated at row={row} col={col} "
                    f"src_offset={src:#x}"
                )
            cmd = blob[src]
            src += 1

            if cmd >= 0xC0:
                count_pairs = cmd - 0xBF
                for _ in range(count_pairs):
                    if src + 3 > n:
                        raise ValueError(
                            f"BMA NRL raw block truncated at src={src:#x}"
                        )
                    v = blob[src] | (blob[src + 1] << 8) | (blob[src + 2] << 16)
                    src += 3
                    a = v & 0xFFF
                    b = (v >> 12) & 0xFFF
                    if row > 0:
                        # Reference row: previous row, same column pair.
                        # We compare against out[len(out) - 64] the way
                        # the original loop does with ptrVal.
                        ref_a = out[len(out) - 64]
                        ref_b = out[len(out) - 63]
                        a ^= ref_a
                        b ^= ref_b
                    out.append(a)
                    out.append(b)
                col += count_pairs * 2

            elif cmd >= 0x80:
                count_pairs = cmd - 0x7F
                if src + 3 > n:
                    raise ValueError(
                        f"BMA NRL run block truncated at src={src:#x}"
                    )
                v = blob[src] | (blob[src + 1] << 8) | (blob[src + 2] << 16)
                src += 3
                a0 = v & 0xFFF
                b0 = (v >> 12) & 0xFFF
                for _ in range(count_pairs):
                    a = a0
                    b = b0
                    if row > 0:
                        ref_a = out[len(out) - 64]
                        ref_b = out[len(out) - 63]
                        a ^= ref_a
                        b ^= ref_b
                    out.append(a)
                    out.append(b)
                col += count_pairs * 2

            else:
                count_pairs = cmd + 1
                for _ in range(count_pairs):
                    a = 0
                    b = 0
                    if row > 0:
                        ref_a = out[len(out) - 64]
                        ref_b = out[len(out) - 63]
                        a ^= ref_a
                        b ^= ref_b
                    out.append(a)
                    out.append(b)
                col += count_pairs * 2

        # Sanity: we should end exactly at width_chunks columns.
        if col != width_chunks:
            raise ValueError(
                f"BMA NRL row {row} overshot: emitted {col} columns, "
                f"expected {width_chunks}"
            )
        # `row_start` is kept for debuggability; not consulted further.
        _ = row_start

    if len(out) != total_chunks:
        raise ValueError(
            f"BMA NRL wrong output size: got {len(out)}, "
            f"expected {total_chunks}"
        )
    return out, src - offset


# ---------------------------------------------------------------- API


@dataclass
class BmaDecodeStats:
    header_warnings: list[str] = field(default_factory=list)
    layers_decoded: int = 0
    collision_layers_decoded: int = 0
    data_layer_present: bool = False
    solid_cells_per_layer: list[int] = field(default_factory=list)
    bytes_consumed: int = 0


def _prov(rom_sha256: str, offset: int, length: int, note: str,
          status: Status) -> Provenance:
    return Provenance(
        rom_sha256=rom_sha256,
        rom_offset=offset,
        rom_length=length,
        extractor_version="converter.decoders.bma/0.1",
        status=status,
        status_reason=(
            ""
            if status in (Status.PORTED, Status.CANONICAL)
            else note
        ),
    )


def decode(
    blob: bytes,
    *,
    ground_id: str,
    rom_sha256: str,
    rom_offset: int,
) -> tuple[BMA_IR, BmaDecodeStats]:
    """Decode a raw BMA blob into a BMA_IR + statistics.

    On success, BMA_IR.layers contains one TileLayer_IR per background
    layer (chunk indices in row-major order), BMA_IR.collisions the
    collision layers (raw bytes preserved), BMA_IR.animated is left
    empty (BPA decoding is a separate module), and BMA_IR.unknown_data
    holds the optional data layer verbatim.

    A header that fails validation still returns a BMA_IR (with
    `layers=[]`) plus statistics; the caller can inspect
    `stats.header_warnings` to decide how to react.
    """
    header = _read_header(blob)
    stats = BmaDecodeStats()
    stats.header_warnings = _validate_header(header)

    # If the header is obviously not a BMA, don't attempt to decode
    # the body — the NRL parser would burn a lot of time on garbage.
    if stats.header_warnings and any(
        "zero" in w or "expected 3x3" in w for w in stats.header_warnings
    ):
        return BMA_IR(
            layers=[], collisions=[], animated=[],
            unknown_data=None,
            provenance=_prov(
                rom_sha256, rom_offset, HEADER_SIZE,
                "BMA header failed validation: "
                + "; ".join(stats.header_warnings),
                Status.UNKNOWN,
            ),
        ), stats

    tile_layers: list[TileLayer_IR] = []
    collision_layers: list[CollisionLayer_IR] = []
    src = HEADER_SIZE

    # -- background chunk-mapping layers ---------------------------------
    for i in range(header.num_layers):
        try:
            chunks, consumed = _decompress_layer_nrl(
                blob, src, header.map_width_chunks, header.map_height_chunks,
            )
        except Exception as exc:  # noqa: BLE001
            # Preserve everything we already extracted; the ground stays
            # partially decoded rather than being lost outright.
            stats.header_warnings.append(
                f"layer {i} NRL decompression failed: {exc!r}"
            )
            return BMA_IR(
                layers=tile_layers, collisions=collision_layers,
                animated=[], unknown_data=None,
                provenance=_prov(
                    rom_sha256, rom_offset, src,
                    "partial BMA: "
                    + "; ".join(stats.header_warnings),
                    Status.PARTIAL,
                ),
            ), stats

        tile_layers.append(TileLayer_IR(
            layer_index=i,
            width_chunks=header.map_width_chunks,
            height_chunks=header.map_height_chunks,
            chunk_indices=chunks,
            provenance=_prov(
                rom_sha256, rom_offset + src, consumed,
                "", Status.PORTED,
            ),
        ))
        src += consumed
        stats.layers_decoded += 1

    # -- collision layers (raw byte grids) ------------------------------
    grid_bytes = header.map_width_tiles * header.map_height_tiles
    for i in range(max(0, header.has_collision)):
        if src + grid_bytes > len(blob):
            stats.header_warnings.append(
                f"collision layer {i} truncated: need {grid_bytes} bytes, "
                f"have {len(blob) - src}"
            )
            break
        raw = bytes(blob[src : src + grid_bytes])
        solid = sum(1 for b in raw if b != 0)
        collision_layers.append(CollisionLayer_IR(
            layer_index=i,
            width_tiles=header.map_width_tiles,
            height_tiles=header.map_height_tiles,
            raw=raw,
            solid_cells=solid,
            provenance=_prov(
                rom_sha256, rom_offset + src, grid_bytes,
                "", Status.PORTED,
            ),
        ))
        src += grid_bytes
        stats.collision_layers_decoded += 1
        stats.solid_cells_per_layer.append(solid)

    # -- optional data layer (preserved verbatim) -----------------------
    unknown_data: Optional[bytes] = None
    if header.has_data_layer:
        if src + grid_bytes <= len(blob):
            unknown_data = bytes(blob[src : src + grid_bytes])
            src += grid_bytes
            stats.data_layer_present = True
        else:
            stats.header_warnings.append(
                "data layer truncated: skipping"
            )

    stats.bytes_consumed = src

    # Aggregate provenance: PORTED only if there were no warnings AND
    # we consumed at least the promised layers.
    if not stats.header_warnings and stats.layers_decoded == header.num_layers:
        agg_status = Status.PORTED
        agg_reason = ""
    else:
        agg_status = Status.PARTIAL
        agg_reason = (
            f"decoded {stats.layers_decoded}/{header.num_layers} tile layers, "
            f"{stats.collision_layers_decoded}/{header.has_collision} "
            f"collision layers, warnings="
            + "; ".join(stats.header_warnings)
        )

    return BMA_IR(
        layers=tile_layers,
        collisions=collision_layers,
        animated=[],
        unknown_data=unknown_data,
        provenance=_prov(
            rom_sha256, rom_offset, src, agg_reason, agg_status,
        ),
    ), stats
