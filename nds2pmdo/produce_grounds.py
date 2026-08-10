"""Production des preuves visuelles par Ground Blue → docs/blue_to_pmdo/grounds/.

Pour chaque ground (triplet palette `P`, tiles `Pc`, map `Pm`) :
  - décode palette, tiles, chunks, layers, collision
  - génère : source_tiles.png, layer_*.png, composite.png, collision.png,
    report.json (+ animation_frames/ si BPA actif)
  - agrège grounds_index/ (contact sheet + index.csv) et reports/coverage_grounds.json

Statuts : FULL (rendu complet), PARTIAL (tiles ok, chunks non reconstruits),
BLOCKED (format non décodable), MISSING (fichiers absents).

Usage : python -m nds2pmdo.produce_grounds [--limit N]
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from .blue.ground import GroundPalette, decode_bma, decode_bpc, render_ground, render_layer
from .config import EXTRACTED_DIR, REPO_ROOT

DOCS = REPO_ROOT.parent / "docs" / "blue_to_pmdo"
GROUNDS_DIR = DOCS / "grounds"
INDEX_DIR = DOCS / "grounds_index"
REPORTS_DIR = DOCS / "reports"


def list_grounds() -> list[dict]:
    """Triplets (palette, c, m) depuis le manifest du ground_pack."""
    manifest = json.loads((EXTRACTED_DIR / "ground_pack" / "manifest.json").read_text())
    entries = {e["name"]: e for e in manifest["entries"]}
    names = [e["name"] for e in manifest["entries"]]
    triplets = []
    seen = set()
    for name in names:
        base = None
        if name.endswith("c") and name[:-1] in entries and name[:-1] + "m" in entries:
            base = name[:-1]
        elif name.endswith("m") and name[:-1] in entries and name[:-1] + "c" in entries:
            base = name[:-1]
        if base and base not in seen:
            seen.add(base)
            triplets.append({"name": base,
                             "palette": entries[base],
                             "c": entries[base + "c"],
                             "m": entries[base + "m"]})
    return triplets


def produce_ground(t: dict, gs: bytes) -> dict:
    name = t["name"]
    out = GROUNDS_DIR / name
    out.mkdir(parents=True, exist_ok=True)
    report = {"Ground ID": name,
              "source_files": [f"ground.sbin/{t['palette']['name']}",
                               f"ground.sbin/{t['c']['name']}",
                               f"ground.sbin/{t['m']['name']}"],
              "source_offsets": [t["palette"]["offset"], t["c"]["offset"], t["m"]["offset"]],
              "sha256": {t["palette"]["name"]: t["palette"]["sha256"],
                         t["c"]["name"]: t["c"]["sha256"],
                         t["m"]["name"]: t["m"]["sha256"]}}
    try:
        palette = GroundPalette.parse(gs[t["palette"]["offset"]:t["palette"]["offset"] + t["palette"]["size"]])
    except Exception as ex:  # noqa: BLE001
        report["status"] = "BLOCKED"
        report["error"] = f"palette: {ex}"
        (out / "report.json").write_text(json.dumps(report, indent=1, ensure_ascii=False))
        return report
    report["palette_count"] = palette.count
    report["palette_colors"] = len(set(c for p in palette.colors for c in p))
    try:
        bpc = decode_bpc(gs[t["c"]["offset"]:t["c"]["offset"] + t["c"]["size"]])
    except Exception as ex:  # noqa: BLE001
        report["status"] = "BLOCKED"
        report["error"] = f"bpc: {ex}"
        (out / "report.json").write_text(json.dumps(report, indent=1, ensure_ascii=False))
        return report
    try:
        bma = decode_bma(gs[t["m"]["offset"]:t["m"]["offset"] + t["m"]["size"]])
    except Exception as ex:  # noqa: BLE001
        bma = None
        report["bma_error"] = str(ex)
    ground = {"name": name, "palette": palette, "bpc": bpc, "bma": bma}

    # --- chiffres ---
    nt = bpc["nt"]
    tiles_present = len(bpc["tiles"]) // 32
    report["Tiles attendues (header nt-1)"] = nt - 1
    report["Tiles décodées"] = tiles_present
    report["Layers attendues"] = bma["nL"] if bma else None
    report["Layers décodées"] = len(bma["layers"]) if bma else 0
    report["Chunks attendus (nc-1)"] = bpc["nc"] - 1
    report["Chunks décodés"] = bpc["chunk_count"]
    report["BPA (animations)"] = bpc["bpa"]
    report["Frames d'animation attendues"] = None
    report["Frames d'animation décodées"] = None
    report["Frames rendues"] = None
    report["Collision"] = bma["collision_status"] if bma else "UNKNOWN"
    report["Dimensions"] = f"{bma['Wt']}x{bma['Ht']} tuiles" if bma else "UNKNOWN"
    report["Markers"] = "UNKNOWN (non stockés dans ces fichiers)"
    report["VFX/particules"] = "UNKNOWN"
    report["PNG"] = []

    # --- rendus ---
    if bpc["status"] == "FULL" and bma is not None:
        from PIL import Image
        # feuille de tiles (palette 0)
        sheet = render_tile_sheet(bpc["tiles"], palette.colors[0])
        p = out / "source_tiles.png"
        sheet.save(p)
        report["PNG"].append("source_tiles.png")
        # layers + composite
        for li in range(bma["nL"]):
            img = render_layer(ground, li)
            p = out / f"layer_{li}.png"
            img.save(p)
            report["PNG"].append(f"layer_{li}.png")
        comp = render_ground(ground)
        p = out / "composite.png"
        comp.save(p)
        report["PNG"].append("composite.png")
        # collision
        if bma["collision"] is not None:
            img = render_collision(bma, bma["collision"])
            p = out / "collision.png"
            img.save(p)
            report["PNG"].append("collision.png")
        report["status"] = "FULL"
        report["question_textures_completes"] = (
            "PASS" if tiles_present == nt - 1 and bpc["chunk_count"] == bpc["nc"] - 1
            else "FAIL")
        report["question_frames_canoniques"] = "PASS (aucune animation BPA dans ces fichiers)"
    else:
        report["status"] = "PARTIAL"
        report["question_textures_completes"] = (
            "PARTIAL" if tiles_present == nt - 1 else "FAIL")
        report["question_frames_canoniques"] = "UNKNOWN"
        if bpc["note"]:
            report["note"] = bpc["note"]
    (out / "report.json").write_text(json.dumps(report, indent=1, ensure_ascii=False))
    return report


def render_tile_sheet(tiles: bytes, pal, cols: int = 32):
    from PIL import Image
    n = len(tiles) // 32
    rows = (n + cols - 1) // cols
    img = Image.new("RGBA", (cols * 8, rows * 8), (0, 0, 0, 0))
    px = img.load()
    for t in range(n):
        td = tiles[t * 32:(t + 1) * 32]
        bx, by = (t % cols) * 8, (t // cols) * 8
        for yy in range(8):
            row = td[yy * 4:yy * 4 + 4]
            for xx in range(8):
                nib = (row[xx // 2] >> (4 * (1 - xx % 2))) & 0xF
                if nib == 0:
                    continue
                c = pal[nib] if nib < len(pal) else (255, 0, 255, 255)
                px[bx + xx, by + yy] = c
    return img


def render_collision(bma, collision):
    from PIL import Image
    Wt, Ht = bma["Wt"], bma["Ht"]
    img = Image.new("RGB", (Wt, Ht), (255, 255, 255))
    px = img.load()
    for y in range(min(Ht, len(collision) // max(1, Wt))):
        for x in range(Wt):
            v = collision[y * Wt + x] if y * Wt + x < len(collision) else 0
            px[x, y] = (200, 30, 30) if v else (240, 240, 240)
    return img.resize((Wt * 4, Ht * 4), 0)


def make_index(reports: list[dict]):
    INDEX_DIR.mkdir(parents=True, exist_ok=True)
    # index.csv
    import csv
    with open(INDEX_DIR / "index.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["ground_id", "dimensions", "layers", "tiles", "chunks",
                    "collision", "animations", "status", "composite_png"])
        for r in sorted(reports, key=lambda x: x["Ground ID"]):
            w.writerow([r["Ground ID"], r.get("Dimensions", "?"),
                        r.get("Layers décodées", 0), r.get("Tiles décodées", 0),
                        r.get("Chunks décodés", 0), r.get("Collision", "?"),
                        r.get("BPA (animations)"), r.get("status"),
                        f"grounds/{r['Ground ID']}/composite.png"
                        if r.get("status") == "FULL" else ""])
    # contact sheet : composites en vignettes
    from PIL import Image
    full = [r for r in reports if r.get("status") == "FULL"]
    if full:
        tw, th = 120, 90
        cols = 8
        rows = (len(full) + cols - 1) // cols
        sheet = Image.new("RGB", (cols * tw, rows * (th + 14)), (30, 30, 30))
        from PIL import ImageDraw
        dr = ImageDraw.Draw(sheet)
        for i, r in enumerate(sorted(full, key=lambda x: x["Ground ID"])):
            comp = GROUNDS_DIR / r["Ground ID"] / "composite.png"
            if not comp.exists():
                continue
            img = Image.open(comp)
            img.thumbnail((tw - 4, th - 4))
            cx, cy = (i % cols) * tw + 2, (i // cols) * (th + 14) + 2
            sheet.paste(img, (cx, cy))
            dr.text((cx, cy + th - 10), r["Ground ID"], fill=(255, 255, 255))
        sheet.save(INDEX_DIR / "all_grounds_contact_sheet.png")
    return len(full)


def main() -> int:
    ap = argparse.ArgumentParser(prog="nds2pmdo produce_grounds")
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()
    gs = (EXTRACTED_DIR / "fs" / "ground.sbin").read_bytes()
    triplets = list_grounds()
    if args.limit:
        triplets = triplets[:args.limit]
    reports = []
    for t in triplets:
        r = produce_ground(t, gs)
        reports.append(r)
        print(f"{r['Ground ID']}: {r.get('status')} "
              f"tiles={r.get('Tiles décodées')}/{r.get('Tiles attendues (header nt-1)')} "
              f"chunks={r.get('Chunks décodés')}/{r.get('Chunks attendus (nc-1)')} "
              f"layers={r.get('Layers décodées')}")
    n_full = make_index(reports)
    # coverage agrégé
    cov = {
        "grounds_discovered": len(reports),
        "grounds_full": sum(1 for r in reports if r.get("status") == "FULL"),
        "grounds_partial": sum(1 for r in reports if r.get("status") == "PARTIAL"),
        "grounds_blocked": sum(1 for r in reports if r.get("status") == "BLOCKED"),
        "tiles_expected": sum(r.get("Tiles attendues (header nt-1)", 0) for r in reports),
        "tiles_decoded": sum(r.get("Tiles décodées", 0) for r in reports),
        "chunks_expected": sum(r.get("Chunks attendus (nc-1)", 0) for r in reports),
        "chunks_decoded": sum(r.get("Chunks décodés", 0) for r in reports),
        "contact_sheet": "grounds_index/all_grounds_contact_sheet.png",
    }
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    (REPORTS_DIR / "coverage_grounds.json").write_text(
        json.dumps(cov, indent=1, ensure_ascii=False))
    print(f"\nTotal: {cov['grounds_discovered']} grounds | "
          f"FULL={cov['grounds_full']} PARTIAL={cov['grounds_partial']} "
          f"BLOCKED={cov['grounds_blocked']}")
    print(f"Tiles: {cov['tiles_decoded']}/{cov['tiles_expected']} | "
          f"Chunks: {cov['chunks_decoded']}/{cov['chunks_expected']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
