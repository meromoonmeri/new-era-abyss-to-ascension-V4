"""Génération des preuves visuelles reproductibles → docs/blue_to_pmdo/.

Chaque PNG est produit directement depuis les données décodées (SOURCE_NDS ou
SOURCE_NDS_DECODED) et documenté dans manifests/provenance_manifest.json.
Aucune image n'est retouchée : ce sont des rendus bruts de validation.

Usage : python -m nds2pmdo.proofs
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from .blue.graphics import decode_cel, decode_palette, render_fon_sheet
from .blue.mapparam import decode_mapparam
from .config import DECODED_DIR, REPO_ROOT
from .provenance import Provenance

DOCS = REPO_ROOT.parent / "docs" / "blue_to_pmdo"


def mkdirs(*names):
    for n in names:
        (DOCS / n).mkdir(parents=True, exist_ok=True)


def render_tilesets():
    gfx = DECODED_DIR / "dungeon" / "graphics"
    out = DOCS / "tilesets"
    made = []
    for prefix in ("b41", "b10"):
        fon = (gfx / f"{prefix}fon.dec.bin").read_bytes()
        pal = decode_palette((gfx / f"{prefix}pal.raw.bin").read_bytes())
        # feuille principale (192 couleurs distinctes, palette brute)
        img = render_fon_sheet(fon, pal["distinct"])
        p = out / f"{prefix}fon_sheet_allcolors.png"
        img.save(p)
        made.append({"file": str(p.relative_to(DOCS)),
                     "source": f"dungeon_pack/{prefix}fon (AT4PX) + {prefix}pal",
                     "provenance": "SOURCE_NDS_DECODED"})
        # une vue par sous-palette (12 × 16 couleurs)
        for i, sub in enumerate(pal["sub_palettes_16"]):
            img = render_fon_sheet(fon, sub)
            p = out / f"{prefix}fon_sheet_subpal{i:02d}.png"
            img.save(p)
    return made


def render_palettes():
    from PIL import Image, ImageDraw
    gfx = DECODED_DIR / "dungeon" / "graphics"
    out = DOCS / "palettes"
    made = []
    for prefix in ("b41", "b10"):
        pal = decode_palette((gfx / f"{prefix}pal.raw.bin").read_bytes())
        # nuancier : 192 couleurs distinctes, 16 par ligne
        cell = 24
        cols = 16
        rows = (len(pal["distinct"]) + cols - 1) // cols
        img = Image.new("RGB", (cols * cell, rows * cell))
        dr = ImageDraw.Draw(img)
        for i, c in enumerate(pal["distinct"]):
            x = (i % cols) * cell
            y = (i // cols) * cell
            dr.rectangle([x, y, x + cell - 1, y + cell - 1], fill=c)
            dr.rectangle([x, y, x + cell - 1, y + cell - 1], outline=(40, 40, 40))
        p = out / f"{prefix}pal_swatches.png"
        img.save(p)
        made.append({"file": str(p.relative_to(DOCS)),
                     "source": f"dungeon_pack/{prefix}pal (384 u16 BGR555, paires)",
                     "provenance": "SOURCE_NDS"})
    return made


def render_cells():
    from PIL import Image
    gfx = DECODED_DIR / "dungeon" / "graphics"
    out = DOCS / "cells"
    made = []
    for prefix in ("b41", "b10"):
        cel = json.loads((gfx / f"{prefix}cel.cel.json").read_text())
        fon = (gfx / f"{prefix}fon.dec.bin").read_bytes()
        pal = decode_palette((gfx / f"{prefix}pal.raw.bin").read_bytes())
        # atlas des 2250 cells : chaque cell rendue 8×8 avec sa palette
        n = len(cel["cells"])
        cols = 150
        rows = (n + cols - 1) // cols
        img = Image.new("RGB", (cols * 8, rows * 8))
        px = img.load()
        for ci, c in enumerate(cel["cells"]):
            t = c["tile"]
            pal_idx = c["palette"]
            sub = pal["sub_palettes_16"][pal_idx % len(pal["sub_palettes_16"])]
            tile = fon[t * 32:(t + 1) * 32]
            bx = (ci % cols) * 8
            by = (ci // cols) * 8
            for yy in range(8):
                row = tile[yy * 4:yy * 4 + 4]
                for xx in range(8):
                    nib = (row[xx // 2] >> (4 * (1 - xx % 2))) & 0xF
                    px[bx + xx, by + yy] = sub[nib] if nib < len(sub) else (255, 0, 255)
        p = out / f"{prefix}cel_atlas.png"
        img.save(p)
        made.append({"file": str(p.relative_to(DOCS)),
                     "source": f"dungeon_pack/{prefix}cel + fon + pal",
                     "provenance": "SOURCE_NDS_DECODED",
                     "note": "cell = (tile 10 bits, palette 14-15, flags 10/12/13)"})
    return made


def render_comparisons():
    from PIL import Image
    gfx = DECODED_DIR / "dungeon" / "graphics"
    out = DOCS / "comparisons"
    fon10 = (gfx / "b10fon.dec.bin").read_bytes()
    fon41 = (gfx / "b41fon.dec.bin").read_bytes()
    pal10 = decode_palette((gfx / "b10pal.raw.bin").read_bytes())["distinct"]
    pal41 = decode_palette((gfx / "b41pal.raw.bin").read_bytes())["distinct"]
    a = render_fon_sheet(fon10, pal10)
    b = render_fon_sheet(fon41, pal41)
    h = max(a.height, b.height)
    img = Image.new("RGB", (a.width + b.width + 12, h), (255, 255, 255))
    img.paste(a, (0, 0))
    img.paste(b, (a.width + 12, 0))
    p = out / "b10_vs_b41_tilesets.png"
    img.save(p)
    return [{"file": str(p.relative_to(DOCS)),
             "source": "b10fon/b41fon + palettes respectives",
             "provenance": "SOURCE_NDS_DECODED",
             "note": "b10 = set graphique alternatif ; b41 = tileset sélectionné par FloorProperties.tileset=41"}]


def render_floor_props_chart():
    """Visualisation des FloorProperties par étage (données SOURCE_NDS prouvées)."""
    from PIL import Image, ImageDraw
    dec = json.loads((DECODED_DIR / "dungeon" / "mapparam.json").read_text())
    out = DOCS / "grounds"
    fields = ("roomDensity", "enemyDensity", "trapDensity", "itemDensity",
              "kecleonShopChance", "monsterHouseChance", "buriedItemDensity",
              "numExtraHallways", "visibilityRange")
    floors = sorted(dec["floor_properties"].keys(), key=int)
    W, H = 1100, 420
    img = Image.new("RGB", (W, H), (255, 255, 255))
    dr = ImageDraw.Draw(img)
    colors = [(200, 40, 40), (40, 120, 200), (40, 160, 80), (220, 140, 20),
              (140, 80, 200), (200, 60, 160), (120, 120, 120), (60, 60, 60),
              (0, 160, 200)]
    legend_x = W - 260
    for fi, f in enumerate(floors):
        fp = dec["floor_properties"][f]["fields"]
        for gi, g in enumerate(fields):
            v = fp.get(g, 0)
            x0 = 60 + fi * 36
            y = H - 40 - v * 14
            dr.rectangle([x0 + gi * 3, y, x0 + gi * 3 + 2, H - 40], fill=colors[gi])
        dr.text((60 + fi * 36 - 4, H - 26), str(int(f) - 16), fill=(0, 0, 0))
    for gi, g in enumerate(fields):
        dr.text((legend_x, 20 + gi * 18), g, fill=colors[gi])
    dr.text((60, 10), "Sinister Woods F1-F13 — FloorProperties (SOURCE_NDS, mapparam @0x7380)",
            fill=(0, 0, 0))
    p = out / "sinister_woods_floor_properties.png"
    img.save(p)
    return [{"file": str(p.relative_to(DOCS)),
             "source": "dungeon_pack/mapparam FloorProperties (indices 17..29)",
             "provenance": "SOURCE_NDS"}]


def main() -> int:
    mkdirs("tilesets", "palettes", "cells", "comparisons", "grounds",
           "collision", "markers", "animations", "cinematics", "music",
           "manifests", "reports", "spec")
    proofs = []
    proofs += render_tilesets()
    proofs += render_palettes()
    proofs += render_cells()
    proofs += render_comparisons()
    proofs += render_floor_props_chart()
    manifest = {
        "title": "Preuves visuelles — retransposition Blue → PMDO",
        "rule": "Chaque PNG provient directement des données décodées ; aucune retouche.",
        "provenance_legend": {p.value: p.value for p in Provenance},
        "rom_sha256": "2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05",
        "proofs": proofs,
        "blocked_render_dirs": {
            "collision": "BLOCKED — format des packages ground.sbin non décodé",
            "markers": "BLOCKED — idem",
            "cinematics": "BLOCKED — packages B10P01* non décodés",
            "animations": "BLOCKED — sémantique canm UNKNOWN",
        },
    }
    (DOCS / "manifests" / "provenance_manifest.json").write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False))
    print(f"{len(proofs)} preuves générées → docs/blue_to_pmdo/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
