"""Décodage des blobs graphiques de dungeon.sbin (Blue Rescue Team APHP).

Chaîne graphique NDS :
  bXXfon  — motifs de tiles 8×8 (4 bpp), compressés AT4PX
  bXXcel  — table de cells (index de tiles + attributs), AT4PX
  bXXcex  — comportements/tiles étendus, AT4PX
  bXXcanm — animations de tileset (SIR0, sémantique à documenter)
  bXXpal  — 3 palettes × 256 couleurs BGR555 (brut)

Fidélité : aucun ré-échantillonnage, aucune palette arbitraire. Une ressource
manquante est signalée, jamais remplacée par du noir.
"""
from __future__ import annotations

import json
import struct
from pathlib import Path

from ..provenance import Provenance, tag
from ..rom.compression import at4px_decompress, is_sir0, sir0_parse

TILE_W, TILE_H = 8, 8
TILE_BYTES_4BPP = 32
PAL_BYTES = 768
PAL_COLORS = 256
PAL_COUNT = 3


def bgr555_to_rgb(v: int) -> tuple[int, int, int]:
    r = (v & 0x1F) << 3
    g = ((v >> 5) & 0x1F) << 3
    b = ((v >> 10) & 0x1F) << 3
    return r, g, b


def decode_palette(raw: bytes) -> list[list[tuple[int, int, int]]]:
    """768 octets = 384 u16 BGR555 : paires (couleur, couleur|0x8000).
    Les 192 couleurs distinctes sont celles à offset pair (bit 15 = variante
    « flag » de la même couleur). Le découpage en sous-palettes (12 × 16 ?)
    dépend des cellules (cel) : ici on rend la liste plate des couleurs."""
    if len(raw) != PAL_BYTES:
        raise ValueError(f"palette {len(raw)} octets != {PAL_BYTES}")
    colors = []
    for i in range(len(raw) // 2):
        v = struct.unpack_from('<H', raw, i * 2)[0]
        colors.append(bgr555_to_rgb(v & 0x7FFF))
    distinct = [colors[i] for i in range(0, len(colors), 2)]
    # sous-palettes candidates de 16 couleurs (4bpp)
    sub = [distinct[i * 16:(i + 1) * 16] for i in range(len(distinct) // 16)]
    return {"colors": colors, "distinct": distinct, "sub_palettes_16": sub}


def decode_fon(dec: bytes) -> int:
    """Motifs 8×8 4bpp : 32 octets par tile. Retourne le nombre de tiles."""
    if len(dec) % TILE_BYTES_4BPP != 0:
        raise ValueError(f"fon {len(dec)} non multiple de 32")
    return len(dec) // TILE_BYTES_4BPP


def render_fon_sheet(dec: bytes, pal: list[tuple[int, int, int]],
                     cols: int = 16) -> "PIL.Image.Image":
    """Rend la feuille de tiles (PNG) avec la palette 0. 1 tile = 8×8 px."""
    from PIL import Image
    n = len(dec) // TILE_BYTES_4BPP
    rows = (n + cols - 1) // cols
    img = Image.new("RGB", (cols * TILE_W, rows * TILE_H))
    px = img.load()
    for t in range(n):
        tile = dec[t * TILE_BYTES_4BPP:(t + 1) * TILE_BYTES_4BPP]
        base_x = (t % cols) * TILE_W
        base_y = (t // cols) * TILE_H
        for yy in range(TILE_H):
            row = tile[yy * 4:yy * 4 + 4]
            for xx in range(TILE_W):
                nib = (row[xx // 2] >> (4 * (1 - xx % 2))) & 0xF
                c = pal[nib] if nib < len(pal) else (255, 0, 255)
                px[base_x + xx, base_y + yy] = c
    return img


def decode_cel(dec: bytes) -> dict:
    """Cells du tileset : u16 = bits 0-9 index de tile, bits 14-15 palette,
    bits 10/12/13 flags (sémantique UNKNOWN, documentée).

    Validé sur APHP : 2250 cells, index de tile ≤ 414 (415 tiles dans le fon),
    palettes 0/1/2 observées, jamais de palette 3."""
    vals = struct.unpack_from(f'<{len(dec) // 2}H', dec)
    cells = []
    palettes = set()
    max_tile = 0
    for v in vals:
        tile = v & 0x3FF
        pal = (v >> 14) & 0x3
        palettes.add(pal)
        max_tile = max(max_tile, tile)
        cells.append({"tile": tile, "palette": pal,
                      "flags": {"f1_bit10": bool(v & 0x400),
                                "f2_bit12": bool(v & 0x1000),
                                "f3_bit13": bool(v & 0x2000)}})
    return {"cell_count": len(cells), "cells": cells,
            "max_tile_index": max_tile, "palettes_used": sorted(palettes),
            "flag_semantics": "UNKNOWN (documenté)"}


def decode_canm(data: bytes) -> dict:
    """SIR0 canm : structure brute + pointeurs. Sémantique = UNKNOWN (documenté).

    Forme observée sur APHP (b41canm 1408 B, b10canm 1152 B) :
    main = table de 16 u32 (offsets absolus) → 16 entrées de 68 octets :
    { u16, u16, 16 × u32 } — les u32 sont constants par entrée (ex. 0x80DB7BA2,
    0x80009C9C) ; signification (frames ? délais ? pointeurs ARM ?) UNKNOWN."""
    if not is_sir0(data):
        return {"status": "NOT_SIR0", "provenance": Provenance.UNKNOWN.value}
    s = sir0_parse(data)
    entries = []
    try:
        offs = struct.unpack_from('<16I', data, s.main_ptr)
        for eo in offs[:8]:
            if eo + 68 > len(data):
                continue
            a, b = struct.unpack_from('<HH', data, eo)
            vals = struct.unpack_from('<16I', data, eo + 4)
            entries.append({"offset": eo, "u16_a": a, "u16_b": b,
                            "u32_values": list(vals)})
    except struct.error:
        pass
    return {
        "status": "SIR0",
        "main_ptr": s.main_ptr,
        "ptrlist_ptr": s.ptrlist_ptr,
        "pointer_count": len(s.sub_objects),
        "entries_count": len(entries),
        "entries_shape": "68 octets : u16, u16, 16×u32",
        "entries_sample": entries[:2],
        "provenance": Provenance.SOURCE_NDS_DECODED.value,
        "semantics": Provenance.UNKNOWN.value,
    }


def decode_graphics_blob(name: str, blob: bytes) -> dict:
    """Décode un blob bXX{fon,cel,cex,canm,pal}. Retourne {status, données...}."""
    if blob[:5] == b'AT4PX':
        dec = at4px_decompress(blob)
        return {"status": "SOURCE_NDS_DECODED", "decompressed_size": len(dec),
                "decompressed": dec}
    if blob[:4] == b'SIR0':
        idx = blob.find(b'AT4PX')
        if idx >= 0:
            flen = struct.unpack_from('<H', blob, idx + 5)[0]
            dec = at4px_decompress(blob[idx:idx + flen])
            return {"status": "SOURCE_NDS_DECODED", "at4px_at": idx,
                    "decompressed_size": len(dec), "decompressed": dec}
        return {"status": "SOURCE_NDS_SIR0_NO_AT4PX", "info": decode_canm(blob)}
    return {"status": "SOURCE_NDS_RAW", "raw": blob}


def decode_all_graphics(dungeon_pack: Path, outdir: Path) -> dict:
    """Décode tous les blobs graphiques bXX* du dungeon_pack vers decoded/dungeon/graphics."""
    outdir.mkdir(parents=True, exist_ok=True)
    report: dict[str, dict] = {}
    for f in sorted(dungeon_pack.iterdir()):
        name = f.name
        if not (6 <= len(name) <= 7 and name[0] == 'b' and name[1:3].isdigit()
                and name[3:] in ("fon", "cel", "cex", "canm", "pal")):
            continue
        blob = f.read_bytes()
        entry: dict = {"raw_size": len(blob)}
        try:
            res = decode_graphics_blob(name, blob)
            if "decompressed" in res:
                entry["status"] = "SOURCE_NDS_DECODED"
                entry["decompressed_size"] = res["decompressed_size"]
                dec = res["decompressed"]
                (outdir / f"{name}.dec.bin").write_bytes(dec)
                if name.endswith("pal"):
                    pals = decode_palette(blob)
                    entry["palette"] = {
                        "u16_count": len(pals["colors"]),
                        "distinct_colors": len(pals["distinct"]),
                        "sub_palettes_16": len(pals["sub_palettes_16"]),
                    }
                elif name.endswith("fon"):
                    entry["tile_count"] = decode_fon(dec)
                elif name.endswith("cel"):
                    entry["cell_u16_count"] = len(dec) // 2
                    cd = decode_cel(dec)
                    entry["cel_summary"] = {k: v for k, v in cd.items()
                                            if k != "cells"}
                    if name in ("b41cel", "b10cel"):
                        (outdir / f"{name}.cel.json").write_text(
                            json.dumps(cd, indent=1, ensure_ascii=False))
                        entry["full_decode"] = f"{name}.cel.json"
            elif res["status"] == "SOURCE_NDS_SIR0_NO_AT4PX":
                entry["status"] = "SOURCE_NDS_SIR0_NO_AT4PX"
                entry["canm"] = res["info"]
                (outdir / f"{name}.sir0.json").write_text(
                    json.dumps(res["info"], indent=1))
            else:
                entry["status"] = res["status"]
                (outdir / f"{name}.raw.bin").write_bytes(blob)
        except Exception as ex:  # noqa: BLE001 — erreur signalée, jamais masquée
            entry["status"] = "DECODE_FAIL"
            entry["error"] = str(ex)
        entry["provenance"] = Provenance.SOURCE_NDS.value
        report[name] = entry
    (outdir / "graphics_report.json").write_text(
        json.dumps(report, indent=1, ensure_ascii=False))
    return report
