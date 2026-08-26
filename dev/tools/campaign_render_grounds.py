#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Rendu PNG pixel-perfect (toutes frames) des Grounds Red & Sky.

Compose chaque `.rsground` depuis ses planches `.tile` (format RogueEssence :
paquet binaire de cellules 8×8 PNG indexées par (x,y)), exactement comme le
moteur PMDO les blitte : cellule 8 px, aucune transformation, aucun
resampling.

Frames d'animation : pour chaque ground, le cycle global est rendu — le
nombre de frames rendues = LCM borné des longueurs de cycles des tuiles
animées (borné à MAX_FRAMES pour rester exploitable ; la 1re frame est
toujours exacte, chaque frame k utilise Frames[k % len] par tuile, ce qui
est la règle du moteur).

Usage:
    campaign_render_grounds.py <grounds_dir> <tiles_dir> <out_dir>
        [--only a,b,c] [--max-frames N] [--flat-tiles]

Sorties: <out>/<ground>/frame_000.png … + <out>/render_report.json
"""
from __future__ import annotations

import io
import json
import math
import os
import struct
import sys
from functools import reduce
from pathlib import Path

from PIL import Image

MAX_FRAMES = 8          # cap du cycle rendu (documenté dans le rapport)


def load_package(path: Path) -> dict:
    raw = path.read_bytes()
    ts, count = struct.unpack_from("<II", raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        ln = struct.unpack_from("<Q", raw, off)[0]
        cells[(x, y)] = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert("RGBA")
    return cells


def lcm(a: int, b: int) -> int:
    return a * b // math.gcd(a, b)


def render_ground(gpath: Path, tiles_dir: Path, out_dir: Path,
                  max_frames: int) -> dict:
    name = gpath.stem
    try:
        d = json.loads(gpath.read_text(encoding="utf-8-sig"))["Object"]
    except Exception as e:
        return {"ground": name, "error": f"rsground illisible: {e}"}
    layers = d.get("Layers")
    if isinstance(layers, dict):
        layers = layers.get("$values") or []
    if not layers:
        return {"ground": name, "error": "aucun layer"}

    # planches nécessaires
    sheets = set()
    for l in layers:
        t = l.get("Tiles") or []
        for col in t:
            for cell in col:
                for cl in cell.get("Layers", []):
                    for fr in cl.get("Frames", []):
                        s = fr.get("Sheet")
                        if s:
                            sheets.add(s)
    packs = {}
    missing_sheets = []
    for s in sheets:
        p = tiles_dir / f"{s}.tile"
        if not p.exists():
            missing_sheets.append(s)
            continue
        try:
            packs[s] = load_package(p)
        except Exception as e:
            return {"ground": name, "error": f"tile {s} illisible: {e}"}
    if not packs:
        return {"ground": name, "error": "aucune planche disponible",
                "missing_sheets": missing_sheets}

    W = len(layers[0]["Tiles"])
    H = len(layers[0]["Tiles"][0])

    # cycle global = LCM des longueurs de frames, borné
    cycle = 1
    n_anim_tiles = 0
    for l in layers:
        for col in l.get("Tiles") or []:
            for cell in col:
                for cl in cell.get("Layers", []):
                    n = len(cl.get("Frames", []))
                    if n > 1:
                        n_anim_tiles += 1
                        cycle = lcm(cycle, n)
                        if cycle > 512:
                            cycle = 512
    frames_to_render = min(cycle, max_frames) if n_anim_tiles else 1

    gdir = out_dir / name
    gdir.mkdir(parents=True, exist_ok=True)
    missing_cells = 0
    for k in range(frames_to_render):
        img = Image.new("RGBA", (W * 8, H * 8), (0, 0, 0, 255))
        for l in layers:
            if not l.get("Visible", True):
                continue
            tls = l.get("Tiles") or []
            for x in range(min(W, len(tls))):
                col = tls[x]
                for y in range(min(H, len(col))):
                    for cl in col[y].get("Layers", []):
                        frames = cl.get("Frames", [])
                        if not frames:
                            continue
                        fr = frames[k % len(frames)]
                        sheet = fr.get("Sheet")
                        tl = fr.get("TexLoc", {})
                        pack = packs.get(sheet)
                        if pack is None:
                            continue
                        cellimg = pack.get((tl.get("X", -1), tl.get("Y", -1)))
                        if cellimg is None:
                            if k == 0:
                                missing_cells += 1
                            continue
                        img.alpha_composite(cellimg, (x * 8, y * 8))
        img.convert("RGB").save(gdir / f"frame_{k:03}.png")
    return {"ground": name, "width_px": W * 8, "height_px": H * 8,
            "frames_rendered": frames_to_render, "animation_cycle": cycle,
            "animated_tiles": n_anim_tiles,
            "missing_cells": missing_cells,
            "missing_sheets": missing_sheets or None,
            "sheets": sorted(sheets)}


def main() -> int:
    args = sys.argv[1:]
    grounds_dir, tiles_dir, out_dir = Path(args[0]), Path(args[1]), Path(args[2])
    only = None
    max_frames = MAX_FRAMES
    if "--only" in args:
        only = set(args[args.index("--only") + 1].split(","))
    if "--max-frames" in args:
        max_frames = int(args[args.index("--max-frames") + 1])
    out_dir.mkdir(parents=True, exist_ok=True)
    report = []
    grounds = sorted(grounds_dir.glob("*.rsground"))
    for i, g in enumerate(grounds, 1):
        if only and g.stem not in only:
            continue
        r = render_ground(g, tiles_dir, out_dir, max_frames)
        report.append(r)
        status = r.get("error") or (f"{r['width_px']}x{r['height_px']} "
                                    f"{r['frames_rendered']}f")
        print(f"[{i}/{len(grounds)}] {g.stem}: {status}", flush=True)
    (out_dir / "render_report.json").write_text(
        json.dumps({"schema": "new-era.campaign-ground-render.v1",
                    "max_frames_cap": max_frames,
                    "renders": report}, indent=1))
    ok = sum(1 for r in report if "error" not in r)
    print(f"\n{ok}/{len(report)} rendus OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
