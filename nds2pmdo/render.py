"""Rendu de validation : feuilles de tiles NDS (fon) avec leurs palettes.

Usage :
  python -m nds2pmdo.render --blobs b41 b10
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

from .blue.graphics import decode_palette, render_fon_sheet
from .config import DECODED_DIR, VALIDATION_DIR


def render(prefix: str) -> dict:
    out = VALIDATION_DIR / "renders"
    out.mkdir(parents=True, exist_ok=True)
    gfx = DECODED_DIR / "dungeon" / "graphics"
    fon_path = gfx / f"{prefix}fon.dec.bin"
    pal_path = gfx / f"{prefix}pal.raw.bin"
    if not fon_path.exists() or not pal_path.exists():
        return {"prefix": prefix, "status": "MISSING — lancer decode d'abord"}
    fon = fon_path.read_bytes()
    pal = decode_palette(pal_path.read_bytes())
    made = []
    # rendu avec les 12 sous-palettes candidates de 16 couleurs
    for i, sub in enumerate(pal["sub_palettes_16"]):
        img = render_fon_sheet(fon, sub)
        p = out / f"{prefix}fon_subpal{i:02d}.png"
        img.save(p)
        made.append(str(p))
    # rendu global (192 couleurs distinctes) pour visualisation brute
    img = render_fon_sheet(fon, pal["distinct"])
    p = out / f"{prefix}fon_allcolors.png"
    img.save(p)
    made.append(str(p))
    return {"prefix": prefix, "status": "OK", "tiles": len(fon) // 32,
            "renders": made}


def main() -> int:
    ap = argparse.ArgumentParser(prog="nds2pmdo render")
    ap.add_argument("--blobs", default="b41,b10", help="préfixes de blobs à rendre")
    args = ap.parse_args()
    for prefix in args.blobs.split(","):
        r = render(prefix.strip())
        print(r)
    return 0


if __name__ == "__main__":
    sys.exit(main())
