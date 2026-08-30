"""PMU source map extractor. Extracts structured data for any map."""
from __future__ import annotations

import hashlib
import json
import sqlite3
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from .constants import (
    CONDITIONAL_BLOCK_TYPES,
    DEFINITE_BLOCK_TYPES,
    DIRECTIONS,
    LAYER_NAMES,
    LAYER_PAIRS,
    MAP_MORAL,
    NPC_BEHAVIOR,
    PMU_TILE_SIZE,
    TILE_TYPES,
    WEATHER,
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_data(data: bytes | str) -> str:
    if isinstance(data, str):
        data = data.encode("utf-8")
    return hashlib.sha256(data).hexdigest()


def normalize_map_id(map_id: str | int) -> str:
    s = str(map_id).strip()
    if s.isdigit():
        return f"s{s}"
    if s.lower().startswith("s") and s[1:].isdigit():
        return f"s{int(s[1:])}"
    return s


class PMUExtractor:
    def __init__(self, db_path: Path, repo_root: Path | None = None):
        self.db_path = Path(db_path)
        self.repo_root = Path(repo_root) if repo_root else self.db_path.parent.parent.parent
        if not self.db_path.exists():
            raise FileNotFoundError(f"PMU SQLite database not found at {self.db_path}")

    def get_connection(self) -> sqlite3.Connection:
        con = sqlite3.connect(self.db_path)
        con.row_factory = sqlite3.Row
        return con

    def extract_map(self, map_id: str | int) -> dict[str, Any]:
        mid = normalize_map_id(map_id)
        with self.get_connection() as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM maps WHERE map_id=?", (mid,))
            map_row = cur.fetchone()
            if map_row is None:
                raise ValueError(f"Map {mid} not found in PMU database")
            map_meta = dict(map_row)

            cur.execute("SELECT * FROM tiles WHERE map_id=? ORDER BY y, x", (mid,))
            tile_rows = [dict(r) for r in cur.fetchall()]

            cur.execute(
                """
                SELECT m.*, n.name as npc_name, n.sprite as npc_sprite, n.species as npc_species,
                       n.form as npc_form, n.sex as npc_sex, n.behavior as npc_behavior,
                       n.script as npc_script, n.attack_say as npc_attack_say
                FROM map_npcs m
                LEFT JOIN npc_defs n ON m.number = n.num
                WHERE m.map_id=?
                ORDER BY m.slot
                """,
                (mid,),
            )
            npc_rows = [dict(r) for r in cur.fetchall()]

        # Dimensions
        max_x = int(map_meta.get("max_x") or 0)
        max_y = int(map_meta.get("max_y") or 0)
        width_tiles = max_x + 1
        height_tiles = max_y + 1
        width_px = width_tiles * PMU_TILE_SIZE
        height_px = height_tiles * PMU_TILE_SIZE

        # Build 2D collision and tile index matrices
        collision_grid: list[list[dict[str, Any]]] = [
            [{} for _ in range(height_tiles)] for _ in range(width_tiles)
        ]
        tiles_by_coords: dict[tuple[int, int], dict[str, Any]] = {}

        tilesets_used: set[int] = set()
        tile_ids_by_tileset: dict[int, set[int]] = {}
        animated_tiles_count = 0

        warps: list[dict[str, Any]] = []
        signs: list[dict[str, Any]] = []
        doors: list[dict[str, Any]] = []
        items: list[dict[str, Any]] = []
        scripts: list[dict[str, Any]] = []
        stories: list[dict[str, Any]] = []
        level_blocks: list[dict[str, Any]] = []
        sprite_blocks: list[dict[str, Any]] = []
        mobile_blocks: list[dict[str, Any]] = []
        other_semantics: list[dict[str, Any]] = []

        type_counts: dict[str, int] = {}

        for tile in tile_rows:
            x, y = int(tile["x"]), int(tile["y"])
            t_type = int(tile["type"])
            t_name = TILE_TYPES.get(t_type, f"UNKNOWN_{t_type}")
            type_counts[t_name] = type_counts.get(t_name, 0) + 1

            tiles_by_coords[(x, y)] = tile

            is_definite_block = t_type in DEFINITE_BLOCK_TYPES
            is_conditional_block = t_type in CONDITIONAL_BLOCK_TYPES

            collision_cell = {
                "x": x,
                "y": y,
                "type_id": t_type,
                "type_name": t_name,
                "blocked": is_definite_block,
                "conditional": is_conditional_block,
                "data1": tile.get("data1", 0),
                "data2": tile.get("data2", 0),
                "data3": tile.get("data3", 0),
                "string1": tile.get("string1", ""),
                "string2": tile.get("string2", ""),
                "string3": tile.get("string3", ""),
            }
            if 0 <= x < width_tiles and 0 <= y < height_tiles:
                collision_grid[x][y] = collision_cell

            # Check tilesets used
            has_anim_on_tile = False
            for base_f, base_set_f, anim_f, anim_set_f in LAYER_PAIRS:
                b_num = int(tile.get(base_f) or 0)
                b_set = int(tile.get(base_set_f) or 0)
                a_num = int(tile.get(anim_f) or 0)
                a_set = int(tile.get(anim_set_f) or 0)
                if b_num != 0:
                    tilesets_used.add(b_set)
                    tile_ids_by_tileset.setdefault(b_set, set()).add(b_num)
                if a_num != 0:
                    tilesets_used.add(a_set)
                    tile_ids_by_tileset.setdefault(a_set, set()).add(a_num)
                    has_anim_on_tile = True

            if has_anim_on_tile:
                animated_tiles_count += 1

            # Semantic categorisation
            if t_type == 2:  # Warp
                warps.append({
                    "source_x": x,
                    "source_y": y,
                    "target_map_id": f"s{tile['data1']}",
                    "target_x": tile["data2"],
                    "target_y": tile["data3"],
                    "raw_data": [tile["data1"], tile["data2"], tile["data3"]],
                })
            elif t_type in (14, 31):  # Sign / ScriptedSign
                signs.append({
                    "x": x,
                    "y": y,
                    "type": t_name,
                    "script_id": tile["data1"] if t_type == 31 else None,
                    "lines": [tile.get("string1", ""), tile.get("string2", ""), tile.get("string3", "")],
                })
            elif t_type == 15:  # Door
                doors.append({
                    "x": x,
                    "y": y,
                    "target_map_id": f"s{tile['data1']}",
                    "target_x": tile["data2"],
                    "target_y": tile["data3"],
                })
            elif t_type == 3:  # Item
                items.append({
                    "x": x,
                    "y": y,
                    "item_id": tile["data1"],
                    "amount": tile["data2"],
                    "sticky": tile["data3"],
                })
            elif t_type == 19:  # Scripted
                scripts.append({
                    "x": x,
                    "y": y,
                    "script_id": tile["data1"],
                    "param2": tile["data2"],
                    "param3": tile["data3"],
                    "strings": [tile.get("string1", ""), tile.get("string2", ""), tile.get("string3", "")],
                })
            elif t_type == 28:  # Story
                stories.append({
                    "x": x,
                    "y": y,
                    "story_id": tile["data1"],
                    "param2": tile["data2"],
                })
            elif t_type == 25:  # LevelBlock
                level_blocks.append({
                    "x": x,
                    "y": y,
                    "min_level": tile["data1"],
                })
            elif t_type == 24:  # SpriteBlock
                sprite_blocks.append({
                    "x": x,
                    "y": y,
                    "mode": tile["data1"],
                    "sprite1": tile["data2"],
                    "sprite2": tile["data3"],
                })
            elif t_type == 10:  # MobileBlock
                mobile_blocks.append({
                    "x": x,
                    "y": y,
                    "mobility_mask": tile["data1"],
                })
            elif t_type not in (0, 1, 4):
                other_semantics.append({
                    "x": x,
                    "y": y,
                    "type_id": t_type,
                    "type_name": t_name,
                    "raw_data": [tile["data1"], tile["data2"], tile["data3"]],
                    "raw_strings": [tile.get("string1", ""), tile.get("string2", ""), tile.get("string3", "")],
                })

        # Cardinal map connections
        cardinal_connections = {}
        for dir_name, field in (("up", "up_map"), ("down", "down_map"), ("left", "left_map"), ("right", "right_map")):
            val = int(map_meta.get(field) or 0)
            if val > 0:
                cardinal_connections[dir_name] = f"s{val}"

        # Structured documents
        pmu_map_doc = {
            "schema": "new-era.pmu-map.v1",
            "map_id": mid,
            "name": map_meta.get("name", ""),
            "revision": int(map_meta.get("revision") or 0),
            "version": map_meta.get("version"),
            "dimensions": {
                "max_x": max_x,
                "max_y": max_y,
                "width_tiles": width_tiles,
                "height_tiles": height_tiles,
                "tile_size_px": PMU_TILE_SIZE,
                "width_px": width_px,
                "height_px": height_px,
            },
            "environment": {
                "moral_id": int(map_meta.get("moral") or 0),
                "moral": MAP_MORAL.get(int(map_meta.get("moral") or 0), "None"),
                "music": map_meta.get("music", ""),
                "indoors": bool(map_meta.get("indoors") == "1"),
                "weather_id": int(map_meta.get("weather") or 0),
                "weather": WEATHER.get(int(map_meta.get("weather") or 0), "Ambiguous"),
                "darkness": int(map_meta.get("darkness") or -1),
                "time_limit": int(map_meta.get("time_limit") or -1),
            },
            "gameplay": {
                "hunger_enabled": bool(map_meta.get("hunger_enabled")),
                "recruitment_enabled": bool(map_meta.get("recruitment_enabled")),
                "exp_enabled": bool(map_meta.get("exp_enabled")),
                "instanced": bool(map_meta.get("instanced")),
                "min_npcs": int(map_meta.get("min_npcs") or 0),
                "max_npcs": int(map_meta.get("max_npcs") or 0),
                "npc_spawn_time": int(map_meta.get("npc_spawn_time") or 0),
            },
            "connections": cardinal_connections,
            "tiles": tile_rows,
        }

        collision_doc = {
            "schema": "new-era.pmu-collision.v1",
            "map_id": mid,
            "dimensions_tiles": [width_tiles, height_tiles],
            "tile_size_px": PMU_TILE_SIZE,
            "definite_block_count": sum(1 for row in collision_grid for c in row if c.get("blocked")),
            "conditional_block_count": sum(1 for row in collision_grid for c in row if c.get("conditional")),
            "walkable_count": sum(1 for row in collision_grid for c in row if not c.get("blocked") and not c.get("conditional")),
            "tile_type_distribution": type_counts,
            "grid": collision_grid,
        }

        semantics_doc = {
            "schema": "new-era.pmu-semantics.v1",
            "map_id": mid,
            "warps_count": len(warps),
            "signs_count": len(signs),
            "doors_count": len(doors),
            "items_count": len(items),
            "scripts_count": len(scripts),
            "stories_count": len(stories),
            "level_blocks_count": len(level_blocks),
            "sprite_blocks_count": len(sprite_blocks),
            "mobile_blocks_count": len(mobile_blocks),
            "warps": warps,
            "signs": signs,
            "doors": doors,
            "items": items,
            "scripts": scripts,
            "stories": stories,
            "level_blocks": level_blocks,
            "sprite_blocks": sprite_blocks,
            "mobile_blocks": mobile_blocks,
            "other_semantics": other_semantics,
            "cardinal_connections": cardinal_connections,
        }

        entities_doc = {
            "schema": "new-era.pmu-entities.v1",
            "map_id": mid,
            "npc_count": len(npc_rows),
            "npcs": npc_rows,
        }

        tileset_doc = {
            "schema": "new-era.pmu-tileset.v1",
            "map_id": mid,
            "tileset_ids": sorted(tilesets_used),
            "tile_counts_by_tileset": {str(k): len(v) for k, v in sorted(tile_ids_by_tileset.items())},
            "tile_ids_by_tileset": {str(k): sorted(v) for k, v in sorted(tile_ids_by_tileset.items())},
            "animated_tiles_count": animated_tiles_count,
            "layer_names": list(LAYER_NAMES),
        }

        manifest_doc = {
            "schema": "new-era.pmu-manifest.v1",
            "map_id": mid,
            "name": map_meta.get("name", ""),
            "revision": int(map_meta.get("revision") or 0),
            "extraction_timestamp": datetime.now(timezone.utc).isoformat(),
            "source_provenance": {
                "database": str(self.db_path),
                "database_sha256": sha256_file(self.db_path),
            },
            "dimensions": {
                "tiles": [width_tiles, height_tiles],
                "pixels": [width_px, height_px],
                "tile_size": PMU_TILE_SIZE,
            },
            "statistics": {
                "total_tiles": len(tile_rows),
                "animated_tiles": animated_tiles_count,
                "tilesets_used": sorted(tilesets_used),
                "npcs_count": len(npc_rows),
                "warps_count": len(warps),
                "signs_count": len(signs),
            },
            "status": "EXTRACTED",
        }

        return {
            "map_id": mid,
            "pmu_map": pmu_map_doc,
            "collision": collision_doc,
            "semantics": semantics_doc,
            "entities": entities_doc,
            "tileset": tileset_doc,
            "manifest": manifest_doc,
        }
