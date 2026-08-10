"""Validation croisée Blue ↔ GBA (pmd-red) : les mêmes maps existent dans les
deux versions du jeu. On compare le rendu Blue (ROM APHP) avec le rendu GBA
(rsground + .tile packages, RESERVE/) — CROSS_REFERENCE, jamais une preuve NDS
mais une confirmation de la fidélité du décodage.

Usage : python -m nds2pmdo.validate_crossref [--limit N]
"""
from __future__ import annotations

import io
import json
import struct
import sys
from pathlib import Path

from .blue.ground import GroundPalette, decode_bma, decode_bpc, render_ground
from .config import EXTRACTED_DIR, REPO_ROOT

CHECKOUT = REPO_ROOT.parent
RESERVE = CHECKOUT / "RESERVE"


def render_gba_rsground(path: Path):
    from PIL import Image
    g = json.loads(path.read_text(encoding='utf-8-sig'))["Object"]
    layer = g["Layers"][0]["Tiles"]
    W, H = len(layer), len(layer[0])
    sheet = None
    for x in range(W):
        for y in range(H):
            if layer[x][y]["Layers"]:
                sheet = layer[x][y]["Layers"][0]["Frames"][0]["Sheet"]
                break
        if sheet:
            break
    raw = (RESERVE / "red_tiles" / f"{sheet}.tile").read_bytes()
    ts, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x2, y2 = key & 0xFFFFFFFF, key >> 32
        ln = struct.unpack_from('<q', raw, off)[0]
        cells[(x2, y2)] = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert('RGBA')
    img = Image.new('RGBA', (W * 8, H * 8), (0, 0, 0, 0))
    for x in range(W):
        for y in range(H):
            tile = layer[x][y]
            if not tile["Layers"]:
                continue
            fr = tile["Layers"][0]["Frames"][0]
            t = cells.get((fr["TexLoc"]["X"], fr["TexLoc"]["Y"]))
            if t:
                img.paste(t, (x * 8, y * 8), t)
    return img


def tile_sig(img, x, y):
    return tuple(img.crop((x * 8, y * 8, x * 8 + 8, y * 8 + 8)).getdata())


def validate_ground(name: str, gs: bytes, entries: dict) -> dict:
    """Compare le rendu Blue (nom) avec le rendu GBA (RESERVE/red_grounds/<name>.rsground).
    Retourne {match_exact, tuiles_uniques_position_ok, nb_tuiles_uniques}."""
    up = name.upper()
    pal = GroundPalette.parse(gs[entries[up]["offset"]:entries[up]["offset"] + entries[up]["size"]])
    bpc = decode_bpc(gs[entries[up + "c"]["offset"]:entries[up + "c"]["offset"] + entries[up + "c"]["size"]])
    bma = decode_bma(gs[entries[up + "m"]["offset"]:entries[up + "m"]["offset"] + entries[up + "m"]["size"]])
    blue = render_ground({"name": up, "palette": pal, "bpc": bpc, "bma": bma})
    gba_path = RESERVE / "red_grounds" / f"{name}.rsground"
    if not gba_path.exists():
        return {"name": name, "status": "NO_GBA_REF"}
    gba = render_gba_rsground(gba_path)
    if gba.size != blue.size:
        return {"name": name, "status": "SIZE_MISMATCH",
                "gba": gba.size, "blue": blue.size}
    gb = list(gba.getdata())
    bl = list(blue.getdata())
    exact = sum(1 for a, b in zip(gb, bl) if a == b) / len(gb)
    # tuiles uniques GBA → position dans Blue (décalage (0,0) attendu)
    W, H = gba.size[0] // 8, gba.size[1] // 8
    from collections import Counter
    gba_pos, gba_count = {}, Counter()
    for y in range(H):
        for x in range(W):
            s = tile_sig(gba, x, y)
            gba_count[s] += 1
            gba_pos.setdefault(s, (x, y))
    unique = {s for s, c in gba_count.items() if c == 1}
    offsets = Counter()
    for y in range(H):
        for x in range(W):
            s = tile_sig(blue, x, y)
            if s in unique:
                gx, gy = gba_pos[s]
                offsets[(gx - x, gy - y)] += 1
    ok_unique = offsets.get((0, 0), 0) == len(unique) if unique else None
    return {"name": name, "status": "OK", "match_exact": round(exact, 4),
            "tuiles_uniques": len(unique),
            "tuiles_uniques_position_ok": ok_unique}


def main() -> int:
    manifest = json.loads((EXTRACTED_DIR / "ground_pack" / "manifest.json").read_text())
    entries = {e["name"]: e for e in manifest["entries"]}
    gs = (EXTRACTED_DIR / "fs" / "ground.sbin").read_bytes()
    gba_grounds = sorted(f.name[:-9] for f in (RESERVE / "red_grounds").glob("*.rsground"))
    results = []
    for name in gba_grounds:
        up = name.upper()
        if up not in entries or up + "c" not in entries or up + "m" not in entries:
            continue
        try:
            results.append(validate_ground(name, gs, entries))
        except Exception as ex:  # noqa: BLE001
            results.append({"name": name, "status": f"ERR {str(ex)[:60]}"})
    exact100 = sum(1 for r in results if r.get("match_exact") == 1.0)
    posok = sum(1 for r in results if r.get("tuiles_uniques_position_ok") is True)
    print(f"Validation croisée Blue↔GBA : {len(results)} maps | "
          f"match exact 100% = {exact100} | tuiles uniques positionnées = {posok}")
    for r in results:
        if r.get("status") != "OK" or r.get("match_exact", 1) < 0.9:
            print(f"  {r['name']}: {r}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
