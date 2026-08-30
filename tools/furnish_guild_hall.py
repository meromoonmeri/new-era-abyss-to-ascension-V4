#!/usr/bin/env python3
"""Furnish ``guild_first_floor`` by transplanting real furniture clusters from
``guild_dining_room``'s Objects layer (same sheet family, same wood palette).

Design rules (verified against the repo, see docs/METANO_TOWN_REFERENCE_ET_PLAN.md):
- purely additive: appends one ``Objects`` layer + solidifies collision cells
  under drawn furniture; never mutates Base tiles, markers, objects, or the
  hall's obstacle semantics outside the footprints;
- every footprint must sit on currently-walkable cells, clear of entry/stairs
  markers and of the two functional ground-object colliders;
- after placement, entry -> stairs and entry -> partner-stairs cells must stay
  connected, and >= 90 % of pre-edit walkable cells must remain reachable
  (no isolated pockets may be created);
- idempotent: re-running on an already-furnished hall produces no change.

Deterministic output: JSON with UTF-8 BOM + Newtonsoft-style ``": "`` spacing,
matching the on-disk files.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import sys
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HALL = ROOT / "Data/Ground/guild_first_floor.rsground"
DINING = ROOT / "Data/Ground/guild_dining_room.rsground"
EMPTY_TILE = {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}

# (source cluster anchor in dining, footprint w/h, candidate anchors in hall, label)
# Rejected after the visual pass over the dining render (see
# docs/METANO_TOWN_REFERENCE_ET_PLAN.md, Phase B):
#  - dining (13,7) 8x8 cluster is the round WINDOW wall fixture, not a table;
#    its 4x4 "core" rendered as a window lying on the hall floor -- removed.
#  - the 184-cell lace tablecloth cluster is one connected table+chairs block;
#    no 8x8-clean floor anchor exists in the circular hall without covering
#    entrance markers or isolating the spiral ring.
CLUSTERS = [
    {"src": (38, 26), "w": 6, "h": 3, "label": "supply_crates", "dst": [(19, 23), (10, 11)]},
    {"src": (7, 19), "w": 3, "h": 3, "label": "berry_basket_a", "dst": [(8, 15), (8, 16), (9, 14)]},
    {"src": (8, 24), "w": 3, "h": 3, "label": "berry_basket_b", "dst": [(19, 20), (21, 17)]},
]
# Hall anchor cells that must stay walkable & connected (tiles = px // 8).
KEEP_CONNECTED = [(17, 25), (17, 8), (20, 6)]
# Marker cells from the serialized markers/objects (entrance is separate).
BLOCKED_CELLS = KEEP_CONNECTED + [(19, 19)]
# Furniture may occlude at most this many currently-reachable cells (decorative
# corners), never markers or the spiral ring continuity checked above.
MAX_REACH_LOSS = 16
# Ground-object collider rects in tiles that must stay clear.
RESERVED = [(15, 27, 10, 1), (23, 2, 1, 8)]


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def tile_drawn(cell) -> bool:
    return bool(cell) and bool(cell.get("Layers"))


def extract_cluster(dining_tiles, ax: int, ay: int, w: int, h: int):
    """Return {(dx,dy): tile-deepcopy} of drawn cells inside the anchor box."""
    out = {}
    for dy in range(h):
        for dx in range(w):
            cell = dining_tiles[ax + dx][ay + dy]
            if tile_drawn(cell):
                out[(dx, dy)] = copy.deepcopy(cell)
    assert out, f"empty cluster at {ax},{ay} w{w} h{h}"
    return out


def walk_grid(obstacles, w: int, h: int):
    return [[1 if obstacles[x][y].get("Tags", 0) == 0 else 0 for y in range(h)] for x in range(w)]


def reachable(grid, start):
    w, h = len(grid), len(grid[0])
    seen = {start}
    dq = deque([start])
    while dq:
        x, y = dq.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and grid[nx][ny] and (nx, ny) not in seen:
                seen.add((nx, ny))
                dq.append((nx, ny))
    return seen


def fits(grid, footprint_abs, reserved):
    for (x, y) in footprint_abs:
        if not grid[x][y]:
            return False
        if (x, y) in BLOCKED_CELLS:
            return False
        if any(rx <= x < rx + rw and ry <= y < ry + rh for rx, ry, rw, rh in reserved):
            return False
    return True


def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true", help="write the result (default: dry-run report)")
    ap.add_argument("--report", type=Path, default=ROOT / ".runtime-work/guild_hall_report.json")
    args = ap.parse_args(argv)

    hall = read_json(HALL)
    dining = read_json(DINING)
    hall_obj = hall["Object"]
    dining_obj = dining["Object"]

    if any(l["Name"] == "Objects" for l in hall_obj["Layers"]):
        print("ALREADY_FURNISHED: hall has an Objects layer; nothing to do.")
        return 0

    w = len(hall_obj["obstacles"])
    h = len(hall_obj["obstacles"][0])
    dining_tiles = next(l for l in dining_obj["Layers"] if l["Name"] == "Objects")["Tiles"]
    base_grid = walk_grid(hall_obj["obstacles"], w, h)
    baseline_reachable = reachable(base_grid, KEEP_CONNECTED[0])
    baseline_walk = sum(map(sum, base_grid))

    new_tiles = [[copy.deepcopy(EMPTY_TILE) for _ in range(h)] for _ in range(w)]
    grid = [row[:] for row in base_grid]
    placements, skips = [], []

    for spec in CLUSTERS:
        sx, sy = spec["src"]
        cluster = extract_cluster(dining_tiles, sx, sy, spec["w"], spec["h"])
        placed = False
        for (ax, ay) in spec["dst"]:
            # full box must be walkable; solids applied only on drawn cells
            box = [(ax + dx, ay + dy) for dx in range(spec["w"]) for dy in range(spec["h"])]
            if not fits(grid, box, RESERVED):
                continue
            trial_grid = [row[:] for row in grid]
            for (dx, dy) in cluster:
                trial_grid[ax + dx][ay + dy] = 0
            # connectivity gates: markers stay walkable and mutually reachable
            if any(not trial_grid[x][y] for x, y in BLOCKED_CELLS):
                skips.append({"label": spec["label"], "at": [ax, ay], "why": "covers marker cell"})
                continue
            reach = reachable(trial_grid, KEEP_CONNECTED[0])
            if any(c not in reach for c in KEEP_CONNECTED):
                skips.append({"label": spec["label"], "at": [ax, ay], "why": "disconnects markers"})
                continue
            lost = baseline_walk - sum(map(sum, trial_grid))
            remaining = len(reach)
            if remaining < 0.9 * len(baseline_reachable):
                skips.append({"label": spec["label"], "at": [ax, ay], "why": f"isolates pockets ({remaining}<{0.9*len(baseline_reachable):.0f})"})
                continue
            for (dx, dy), tile in cluster.items():
                new_tiles[ax + dx][ay + dy] = tile
                hall_obj["obstacles"][ax + dx][ay + dy]["Tags"] = 1
            grid = trial_grid
            placements.append({"label": spec["label"], "at": [ax, ay], "cells": len(cluster),
                               "src": [sx, sy]})
            placed = True
            break
        if not placed and all(s["label"] != spec["label"] for s in skips):
            skips.append({"label": spec["label"], "at": None, "why": "no candidate fits"})

    if not placements:
        print(json.dumps({"result": "NO_PLACEMENT", "skips": skips}, indent=2))
        return 1

    hall_obj["Layers"].append({"Name": "Objects", "Layer": 0, "Visible": True, "Tiles": new_tiles})

    payload = "\ufeff" + json.dumps(hall, indent=0, ensure_ascii=False)
    digest = hashlib.sha256(payload.encode("utf-8")).hexdigest()
    report = {
        "result": "PREVIEW" if not args.apply else "APPLIED",
        "hall_before_sha256": hashlib.sha256(HALL.read_bytes()).hexdigest(),
        "dining_sha256": hashlib.sha256(DINING.read_bytes()).hexdigest(),
        "placements": placements, "skips": skips,
        "walkable_before": baseline_walk,
        "walkable_after": sum(map(sum, walk_grid(hall_obj["obstacles"], w, h))),
        "reachable_kept": len(reachable(grid, KEEP_CONNECTED[0])),
        "reachable_baseline": len(baseline_reachable),
        "out_sha256": digest,
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))

    if args.apply:
        bak = ROOT / ".runtime-work/guild_first_floor.rsground.pre-furnish.bak"
        bak.parent.mkdir(exist_ok=True)
        if not bak.exists():
            bak.write_bytes(HALL.read_bytes())
        tmp = HALL.with_suffix(".rsground.tmp")
        tmp.write_text(payload, encoding="utf-8")
        read_json(tmp)  # parse-back guard
        tmp.replace(HALL)
        print(f"APPLIED -> {HALL} (backup: {bak})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
