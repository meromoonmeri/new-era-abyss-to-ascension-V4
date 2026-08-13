#!/usr/bin/env python3
"""Topology-aware Ground composition from observed PMDO cell grammars."""
from __future__ import annotations
import copy
import hashlib
import json
import math
import random
from collections import defaultdict, deque
from pathlib import Path
from typing import Any


def load_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))


def _has_visual(cell):
    return bool(cell.get("AutoTileset")) or any(layer.get("Frames") for layer in cell.get("Layers", []))


def _layer_role(name):
    text = name.casefold()
    if any(word in text for word in ("river", "water", "lac", "rivière")):
        return "water"
    if any(word in text for word in ("object", "fringe", "decor")):
        return "decoration"
    if any(word in text for word in ("shadow", "ombre")):
        return "shadow"
    if any(word in text for word in ("cliff", "wall", "mur")):
        return "structure"
    return "base"


def _water_cells(obj):
    result = set()
    width = len(obj.get("obstacles", []))
    height = len(obj.get("obstacles", [[]])[0]) if width else 0
    for layer in obj.get("Layers", []):
        if _layer_role(str(layer.get("Name", ""))) != "water":
            continue
        tiles = layer.get("Tiles", [])
        if len(tiles) != width or not tiles or len(tiles[0]) != height:
            continue
        for x, column in enumerate(tiles):
            for y, cell in enumerate(column):
                if _has_visual(cell) and obj["obstacles"][x][y].get("Tags", 0):
                    result.add((x, y))
    return result


def _classes(obj):
    obstacles = obj.get("obstacles", [])
    width, height = len(obstacles), len(obstacles[0]) if obstacles else 0
    water = _water_cells(obj)
    result = [["open" for _ in range(height)] for _ in range(width)]
    for x in range(width):
        for y in range(height):
            result[x][y] = "water" if (x, y) in water else "wall" if obstacles[x][y].get("Tags", 0) else "open"
    return result


def _mask(classes, x, y):
    target = classes[x][y]
    width, height = len(classes), len(classes[0])
    mask = 0
    for bit, (dx, dy) in enumerate(((0, -1), (1, 0), (0, 1), (-1, 0), (1, -1), (1, 1), (-1, 1), (-1, -1))):
        nx, ny = x + dx, y + dy
        if 0 <= nx < width and 0 <= ny < height and classes[nx][ny] == target:
            mask |= 1 << bit
    return mask


def build_cell_grammar(obj):
    classes = _classes(obj)
    width, height = len(classes), len(classes[0])
    pools = defaultdict(list)
    for x in range(width):
        for y in range(height):
            pools[(classes[x][y], _mask(classes, x, y))].append((x, y))
    return classes, pools


def _ellipse_value(x, y, cx, cy, rx, ry):
    return ((x - cx) / max(1, rx)) ** 2 + ((y - cy) / max(1, ry)) ** 2


def _abstract_clearing(width, height, rng, lake_count=3):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    cx, cy = width / 2, height / 2
    for x in range(width):
        for y in range(height):
            noise = ((x * 17 + y * 31 + rng.randrange(7)) % 11) / 90
            if _ellipse_value(x, y, cx, cy, width * .43, height * .39) <= 1 - noise:
                classes[x][y] = "open"
    path_x = width // 2
    for y in range(1, height - 1):
        width_here = 3 + (y // 9) % 2
        for x in range(path_x - width_here, path_x + width_here + 1):
            classes[x][y] = "open"
    lake_centers = [(width * .28, height * .34), (width * .70, height * .40), (width * .31, height * .68), (width * .70, height * .70)]
    chosen = lake_centers[:lake_count]
    water_regions = []
    for index, (lcx, lcy) in enumerate(chosen):
        rx, ry = rng.randint(4, 7), rng.randint(3, 5)
        cells = []
        for x in range(2, width - 2):
            for y in range(2, height - 2):
                wobble = (((x * 13 + y * 7 + index * 19) % 9) - 4) / 22
                if _ellipse_value(x, y, lcx, lcy, rx, ry) <= 1 + wobble and abs(x - path_x) > 4:
                    classes[x][y] = "water"
                    cells.append((x, y))
        water_regions.append(cells)
    entrance, exit_point = [path_x, height - 3], [path_x, 2]
    poi = [path_x, height // 2]
    for px, py in (entrance, exit_point, poi):
        classes[px][py] = "open"
    return classes, {"entrance": entrance, "exit": exit_point, "poi": poi, "water_regions": water_regions}


def _hamming(left, right):
    return (left ^ right).bit_count()


def _pick_source(pools, cell_class, mask, rng):
    exact = pools.get((cell_class, mask), [])
    if exact:
        return exact[rng.randrange(len(exact))], True, 0
    candidates = [(key_mask, cells) for (key_class, key_mask), cells in pools.items() if key_class == cell_class]
    if not candidates:
        candidates = [(key_mask, cells) for (key_class, key_mask), cells in pools.items() if key_class in ("wall", "water") and cell_class in ("wall", "water")]
    if not candidates:
        raise ValueError(f"No source cell for class {cell_class}")
    distance = min(_hamming(mask, key_mask) for key_mask, _ in candidates)
    nearest = [cells for key_mask, cells in candidates if _hamming(mask, key_mask) == distance]
    cells = nearest[rng.randrange(len(nearest))]
    return cells[rng.randrange(len(cells))], False, distance


def _empty_cell():
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def _prototype_entity(repo, object_name=None, marker_name=None):
    source = load_json(repo / "Data/Ground/searing_tunnel_midpoint.rsground")["Object"]
    for layer in source.get("Entities", []):
        if object_name:
            for row in layer.get("GroundObjects", []):
                if row.get("EntName") == object_name:
                    return copy.deepcopy(row)
        if marker_name:
            for row in layer.get("Markers", []):
                if row.get("EntName") == marker_name:
                    return copy.deepcopy(row)
    return None


def _set_collider(entity, cell, size=16):
    entity["Collider"] = {"X": cell[0] * 8, "Y": cell[1] * 8, "Width": size, "Height": size}
    return entity


def _component_count(classes, target):
    points = {(x, y) for x in range(len(classes)) for y in range(len(classes[0])) if classes[x][y] == target}
    count = 0
    while points:
        count += 1
        start = points.pop()
        queue = [start]
        while queue:
            x, y = queue.pop()
            for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if point in points:
                    points.remove(point)
                    queue.append(point)
    return count


def _reachable(classes, start):
    width, height = len(classes), len(classes[0])
    seen = {tuple(start)}
    queue = deque([tuple(start)])
    while queue:
        x, y = queue.popleft()
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < width and 0 <= ny < height and classes[nx][ny] == "open" and (nx, ny) not in seen:
                seen.add((nx, ny))
                queue.append((nx, ny))
    return seen


def _asset_refs(data):
    sheets = set()
    animation_count = 0
    for layer in data["Object"].get("Layers", []):
        for column in layer.get("Tiles", []):
            for cell in column:
                if cell.get("AutoTileset"):
                    sheets.add(cell["AutoTileset"])
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames", [])
                    animation_count += len(frames) > 1 or bool(tile_layer.get("FrameLength"))
                    for frame in frames:
                        if frame.get("Sheet"):
                            sheets.add(frame["Sheet"])
    return sheets, animation_count


def _validate_ground(repo, data, classes, anchors, resolution):
    obj = data["Object"]
    width, height = len(classes), len(classes[0])
    errors = []
    if any(len(layer.get("Tiles", [])) != width or any(len(column) != height for column in layer.get("Tiles", [])) for layer in obj.get("Layers", [])):
        errors.append({"code": "LAYER_DIMENSION_MISMATCH"})
    reachable = _reachable(classes, anchors["entrance"])
    if tuple(anchors["exit"]) not in reachable or tuple(anchors["poi"]) not in reachable:
        errors.append({"code": "NAVIGATION_DISCONNECTED"})
    lake_components = _component_count(classes, "water")
    if lake_components != len(anchors["water_regions"]):
        errors.append({"code": "LAKE_COMPONENT_COUNT", "expected": len(anchors["water_regions"]), "actual": lake_components})
    sheets, animations = _asset_refs(data)
    missing = [sheet for sheet in sheets if not (repo / "Content/Tile" / f"{sheet}.tile").exists()]
    if missing:
        errors.append({"code": "MISSING_SHEETS", "sheets": sorted(missing)})
    fallback_ratio = resolution["fallback_cells"] / max(1, width * height)
    if fallback_ratio > .38:
        errors.append({"code": "WEAK_TOPOLOGY_GRAMMAR_COVERAGE", "ratio": round(fallback_ratio, 4)})
    entities = [row for layer in obj.get("Entities", []) for row in layer.get("GroundObjects", []) + layer.get("Markers", [])]
    if any(row.get("Collider", {}).get("X", 0) < 0 or row.get("Collider", {}).get("Y", 0) < 0 or row.get("Collider", {}).get("X", 0) >= width * 8 or row.get("Collider", {}).get("Y", 0) >= height * 8 for row in entities):
        errors.append({"code": "ENTITY_OUT_OF_BOUNDS"})
    return {
        "result": "GROUND_VALIDATION_PASS" if not errors else "GROUND_VALIDATION_FAIL",
        "errors": errors,
        "navigation_reachable_cells": len(reachable),
        "water_component_count": lake_components,
        "referenced_sheet_count": len(sheets),
        "animation_cell_count": animations,
        "topology_exact_ratio": round(resolution["exact_cells"] / max(1, width * height), 4),
        "topology_fallback_ratio": round(fallback_ratio, 4),
        "viewport_policy": "local_follow_camera_no_forced_zoom",
        "size_cells": [width, height], "size_pixels": [width * 8, height * 8],
    }


def _candidate(repo, source_path, ground_id, seed, variant, width, height, lakes):
    source = load_json(source_path)
    source_obj = source["Object"]
    source_classes, pools = build_cell_grammar(source_obj)
    rng = random.Random(int.from_bytes(hashlib.sha256(f"{seed}|ground|{variant}".encode()).digest()[:8], "little"))
    classes, anchors = _abstract_clearing(width, height, rng, lakes)
    data = copy.deepcopy(source)
    obj = data["Object"]
    obj["AssetName"] = ground_id
    obj["Name"] = {"DefaultText": ground_id.replace("_", " ").title(), "LocalTexts": {"fr": "Clairière aux petits lacs"}}
    obj["Comment"] = f"Ground Smart Dungeon inédit; grammaire cellulaire apprise de {source_path.name}; seed {seed}; variante {variant}."
    obj["TexSize"] = 1
    obj["ViewCenter"] = None
    obj["ViewOffset"] = {"X": 0, "Y": 0}
    safe_layers, excluded_layers = [], []
    for source_layer in source_obj.get("Layers", []):
        tiles = source_layer.get("Tiles", [])
        if len(tiles) != len(source_classes) or not tiles or len(tiles[0]) != len(source_classes[0]):
            excluded_layers.append({"name": source_layer.get("Name"), "reason": "source_layer_grid_not_cell_aligned"})
            continue
        role = _layer_role(str(source_layer.get("Name", "")))
        if role == "decoration":
            excluded_layers.append({"name": source_layer.get("Name"), "reason": "unsafe_multicell_decoration_not_fragmented"})
            layer = copy.deepcopy(source_layer)
            layer["Tiles"] = [[_empty_cell() for _ in range(height)] for _ in range(width)]
            safe_layers.append(layer)
            continue
        layer = copy.deepcopy(source_layer)
        layer["Tiles"] = [[None for _ in range(height)] for _ in range(width)]
        safe_layers.append(layer)
    exact = fallback = distance_total = 0
    fallback_details = []
    sources = [[None for _ in range(height)] for _ in range(width)]
    for x in range(width):
        for y in range(height):
            source_cell, is_exact, distance = _pick_source(pools, classes[x][y], _mask(classes, x, y), rng)
            sources[x][y] = source_cell
            exact += is_exact
            fallback += not is_exact
            distance_total += distance
            if not is_exact and len(fallback_details) < 64:
                fallback_details.append({"target": [x, y], "functional_class": classes[x][y], "target_mask": f"{_mask(classes, x, y):02x}", "source": [source_cell[0], source_cell[1]], "hamming_distance": distance})
    for layer_index, layer in enumerate(safe_layers):
        if _layer_role(str(layer.get("Name", ""))) == "decoration":
            continue
        source_layer = next(row for row in source_obj["Layers"] if row.get("Name") == layer.get("Name"))
        for x in range(width):
            for y in range(height):
                sx, sy = sources[x][y]
                layer["Tiles"][x][y] = copy.deepcopy(source_layer["Tiles"][sx][sy])
    obj["Layers"] = safe_layers
    obj["obstacles"] = [[{
        "Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8},
        "Tags": 0 if classes[x][y] == "open" else 1,
    } for y in range(height)] for x in range(width)]
    entity_template = copy.deepcopy(source_obj.get("Entities", [{}])[0])
    entity_template["Name"] = "Smart Dungeon Entities"
    entity_template["MapChars"] = []
    entity_template["Spawners"] = []
    entity_template["GroundObjects"] = []
    entity_template["Markers"] = []
    marker = _prototype_entity(repo, marker_name="Main_Entrance_Marker")
    marker["EntName"] = "Main_Entrance_Marker"
    entity_template["Markers"].append(_set_collider(marker, anchors["entrance"]))
    poi_marker = copy.deepcopy(marker)
    poi_marker["EntName"] = "Point_Of_Interest"
    entity_template["Markers"].append(_set_collider(poi_marker, anchors["poi"]))
    north = _prototype_entity(repo, object_name="North_Exit")
    north["EntName"] = "North_Exit"
    entity_template["GroundObjects"].append(_set_collider(north, anchors["exit"]))
    obj["Entities"] = [entity_template]
    resolution = {"exact_cells": exact, "fallback_cells": fallback, "mean_hamming_distance": round(distance_total / max(1, width * height), 4), "fallback_details": fallback_details}
    validation = _validate_ground(repo, data, classes, anchors, resolution)
    score = (
        (1 if validation["result"] == "GROUND_VALIDATION_PASS" else 0) * 1000
        + validation["topology_exact_ratio"] * 100
        + min(100, validation["navigation_reachable_cells"] / max(1, width * height) * 180)
        - validation["topology_fallback_ratio"] * 50
    )
    metadata = {
        "schema_version": "1.0.0", "ground_id": ground_id, "seed": seed, "variant": variant,
        "concept": "clairiere_forestiere_petits_lacs", "source_ground": source_path.stem,
        "source_sha256": hashlib.sha256(source_path.read_bytes()).hexdigest(),
        "geometry": {
            "macro": "open_clearing_with_peripheral_mass", "path": "south_to_north_with_secondary_space",
            "water_regions": [{"index": index + 1, "cell_count": len(cells)} for index, cells in enumerate(anchors["water_regions"])],
            "anchors": {key: value for key, value in anchors.items() if key != "water_regions"},
        },
        "tile_grammar": {"source_rule_count": len(pools), "resolution": resolution, "neighbor_mask": "8-neighbor_same-functional-class"},
        "layers": {"kept": [layer.get("Name") for layer in safe_layers], "excluded": excluded_layers},
        "asset_policy": "only serialized source cells; native frames and orientation preserved; no arbitrary flip",
        "validation": validation, "score": round(score, 3),
        "decisions": [
            {"stage": "macro", "why": "clairière ouverte avant sélection des tiles"},
            {"stage": "water", "why": "trois régions logiques et contours calculés avant rendu"},
            {"stage": "tile_resolution", "why": "cellule source choisie par classe et masque de voisinage"},
            {"stage": "viewport", "why": "caméra locale suiveuse; aucun dézoom global"},
        ],
    }
    return data, metadata


def _preview_svg(data, metadata, path):
    import html
    obj=data['Object'];classes=_classes(obj);width,height=len(classes),len(classes[0]);cell=8
    colors={'open':'#79846f','wall':'#26342b','water':'#397b9b'}
    parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{width*cell}" height="{height*cell+42}" viewBox="0 0 {width*cell} {height*cell+42}"><rect width="100%" height="100%" fill="#11141a"/>']
    for x in range(width):
        for y in range(height):parts.append(f'<rect x="{x*cell}" y="{42+y*cell}" width="{cell}" height="{cell}" fill="{colors[classes[x][y]]}"/>')
    for layer in obj.get('Entities',[]):
        for row in layer.get('GroundObjects',[])+layer.get('Markers',[]):
            c=row.get('Collider',{});name=row.get('EntName','');color='#56d3ff' if 'Entrance' in name else '#f4ce63' if 'Point' in name else '#62c98a';parts.append(f'<circle cx="{c.get("X",0)+8}" cy="{42+c.get("Y",0)+8}" r="5" fill="{color}"><title>{html.escape(name)}</title></circle>')
    validation=metadata['validation'];parts.append(f'<text x="8" y="17" fill="white" font-family="sans-serif" font-size="12">{html.escape(metadata["ground_id"])} — {html.escape(metadata["concept"])}</text>');parts.append(f'<text x="8" y="33" fill="#b8c2cf" font-family="sans-serif" font-size="10">topologie exacte {validation["topology_exact_ratio"]:.1%} · lacs {validation["water_component_count"]} · caméra locale</text></svg>');path.write_text('\n'.join(parts),encoding='utf-8')


def generate_ground(repo: Path, output_dir: Path, ground_id: str, intent: str, seed: int, variants: int = 4, reference: str | None = None, width: int = 64, height: int = 48):
    repo, output_dir = repo.resolve(), output_dir.resolve()
    text = intent.casefold()
    lake_count = 3
    import re
    match = re.search(r"(\d+)\s*(?:petits?\s+)?lacs?", text)
    if match:
        lake_count = max(1, min(5, int(match.group(1))))
    reference_id = reference or "altere_pond"
    source_path = repo / "Data/Ground" / f"{reference_id}.rsground"
    if not source_path.exists():
        raise FileNotFoundError(source_path)
    candidates = []
    for variant in range(max(1, variants)):
        data, metadata = _candidate(repo, source_path, ground_id, seed, variant, width, height, lake_count)
        candidates.append((data, metadata))
    data, metadata = max(candidates, key=lambda row: row[1]["score"])
    metadata["candidate_comparison"] = [{"variant": row[1]["variant"], "score": row[1]["score"], "validation": row[1]["validation"]["result"]} for row in candidates]
    output_dir.mkdir(parents=True, exist_ok=True)
    ground_path = output_dir / f"{ground_id}.rsground"
    metadata_path = output_dir / f"{ground_id}.metadata.json"
    preview_path = output_dir / f"{ground_id}.svg"
    ground_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    metadata_path.write_text(json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8")
    _preview_svg(data, metadata, preview_path)
    return {"ground_file": ground_path.as_posix(), "metadata_file": metadata_path.as_posix(), "preview_file": preview_path.as_posix(), **metadata}
