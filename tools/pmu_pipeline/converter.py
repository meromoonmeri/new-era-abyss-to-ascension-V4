"""PMU to PMDO Native Converter.
Converts PMU structured map data into PMDO .rsground, .tile binary atlas, and Lua controllers.
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import struct
from pathlib import Path
from typing import Any

from PIL import Image

from .constants import (
    DEFINITE_BLOCK_TYPES,
    LAYER_NAMES,
    LAYER_PAIRS,
    PMDO_ANIMATION_FRAME_LENGTH,
    PMDO_SUBTILE_SIZE,
    PMU_TILE_SIZE,
    SUBTILES_PER_PMU_TILE,
    TILE_TYPES,
)
from .renderer import PMURenderer


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _premultiply_rgba(image: Image.Image) -> Image.Image:
    """Premultiply alpha for PMDO binary tile format."""
    image = image.convert("RGBA")
    pixels = bytearray(image.tobytes())
    for offset in range(0, len(pixels), 4):
        alpha = pixels[offset + 3]
        for channel in range(3):
            pixels[offset + channel] = (pixels[offset + channel] * alpha + 127) // 255
    return Image.frombytes("RGBA", image.size, bytes(pixels))


def _unpremultiply_rgba(image: Image.Image) -> Image.Image:
    """Unpremultiply alpha from PMDO binary tile format."""
    image = image.convert("RGBA")
    pixels = bytearray(image.tobytes())
    for offset in range(0, len(pixels), 4):
        alpha = pixels[offset + 3]
        if alpha:
            for channel in range(3):
                pixels[offset + channel] = min(255, (pixels[offset + channel] * 255 + alpha // 2) // alpha)
    return Image.frombytes("RGBA", image.size, bytes(pixels))


def write_pmdo_tile_file(path: Path, tile_size: int, entries: list[tuple[int, bytes]]) -> None:
    """Write binary .tile file matching RogueEssence format."""
    payload_offsets: dict[bytes, int] = {}
    payloads: list[bytes] = []
    # Header: 8 bytes (tile_size uint32, count uint32) + entries * 16 bytes (key uint64, offset uint64)
    offset = 8 + len(entries) * 16
    for _, payload in entries:
        if payload not in payload_offsets:
            payload_offsets[payload] = offset
            payloads.append(payload)
            offset += 8 + len(payload)

    result = bytearray(struct.pack("<II", tile_size, len(entries)))
    for key, payload in entries:
        result.extend(struct.pack("<QQ", key, payload_offsets[payload]))
    for payload in payloads:
        result.extend(struct.pack("<Q", len(payload)))
        result.extend(payload)

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(result)


def read_pmdo_tile_file(path: Path) -> tuple[int, dict[tuple[int, int], Image.Image]]:
    """Read binary .tile file and return tile size and mapping (sheet_x, sheet_y) -> Image."""
    data = path.read_bytes()
    if len(data) < 8:
        return 0, {}
    size, count = struct.unpack_from("<II", data, 0)
    images: dict[tuple[int, int], Image.Image] = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", data, 8 + index * 16)
        sx = key & 0xFFFFFFFF
        sy = key >> 32
        if offset + 8 > len(data):
            continue
        length = struct.unpack_from("<Q", data, offset)[0]
        payload = data[offset + 8 : offset + 8 + length]
        with Image.open(io.BytesIO(payload)) as raw_img:
            unprem = _unpremultiply_rgba(raw_img)
            unprem.load()
            images[(sx, sy)] = unprem
    return size, images


class PMDOConverter:
    def __init__(self, repo_root: Path, renderer: PMURenderer):
        self.repo_root = Path(repo_root)
        self.renderer = renderer

    def convert_map(
        self,
        map_extraction: dict[str, Any],
        output_dir: Path | None = None,
    ) -> dict[str, Any]:
        pmu_map = map_extraction["pmu_map"]
        map_id = pmu_map["map_id"]
        map_name = pmu_map.get("name", map_id)
        tiles = pmu_map.get("tiles", [])
        tiles_by_coords = {(int(t["x"]), int(t["y"])): t for t in tiles}

        width_tiles = pmu_map["dimensions"]["width_tiles"]
        height_tiles = pmu_map["dimensions"]["height_tiles"]

        # Grid dimensions in PMDO 8px cells
        grid_w = width_tiles * SUBTILES_PER_PMU_TILE
        grid_h = height_tiles * SUBTILES_PER_PMU_TILE
        tex_size = 1  # 8px sub-cells
        sheet_name = f"pmu_{map_id}_Base"

        # Payloads and atlas registration
        unique_payloads: dict[bytes, tuple[int, int]] = {}
        payload_images: dict[tuple[int, int], Image.Image] = {}
        atlas_entries: list[tuple[int, bytes]] = []

        def register_sub_image(sub_img: Image.Image | None) -> dict[str, Any]:
            if sub_img is None:
                sub_img = Image.new("RGBA", (PMDO_SUBTILE_SIZE, PMDO_SUBTILE_SIZE), (0, 0, 0, 0))
            raw_bytes = sub_img.tobytes()
            if raw_bytes not in unique_payloads:
                idx = len(unique_payloads)
                sx = idx % 128
                sy = idx // 128
                unique_payloads[raw_bytes] = (sx, sy)
                payload_images[(sx, sy)] = sub_img

                # Premultiply and save as PNG payload
                premul = _premultiply_rgba(sub_img)
                buf = io.BytesIO()
                premul.save(buf, format="PNG", optimize=False, compress_level=9)
                png_bytes = buf.getvalue()
                key = (sy << 32) | (sx & 0xFFFFFFFF)
                atlas_entries.append((key, png_bytes))

            loc = unique_payloads[raw_bytes]
            return {"Sheet": sheet_name, "TexLoc": {"X": loc[0], "Y": loc[1]}}

        # Build PMDO layers
        pmdo_layers: list[dict[str, Any]] = []
        animated_cells_count = 0

        for layer_idx, (base_f, base_set_f, anim_f, anim_set_f) in enumerate(LAYER_PAIRS):
            layer_name = f"PMU {LAYER_NAMES[layer_idx]}"
            columns = []
            for gx in range(grid_w):
                col = []
                tx = gx // SUBTILES_PER_PMU_TILE
                sub_x = (gx % SUBTILES_PER_PMU_TILE) * PMDO_SUBTILE_SIZE
                for gy in range(grid_h):
                    ty = gy // SUBTILES_PER_PMU_TILE
                    sub_y = (gy % SUBTILES_PER_PMU_TILE) * PMDO_SUBTILE_SIZE
                    t = tiles_by_coords.get((tx, ty))
                    if t is None:
                        col.append({"AutoTileset": "", "Associates": [], "NeighborCode": -1, "Layers": []})
                        continue

                    base_num = int(t.get(base_f) or 0)
                    base_set = int(t.get(base_set_f) or 0)
                    anim_num = int(t.get(anim_f) or 0)
                    anim_set = int(t.get(anim_set_f) or 0)

                    if base_num == 0 and anim_num == 0:
                        col.append({"AutoTileset": "", "Associates": [], "NeighborCode": -1, "Layers": []})
                        continue

                    def get_sub_tile_img(num: int, sheet_id: int) -> Image.Image | None:
                        if num == 0:
                            return None
                        full = self.renderer.tile(map_id, tx, ty, base_f, sheet_id, num)
                        return full.crop((sub_x, sub_y, sub_x + PMDO_SUBTILE_SIZE, sub_y + PMDO_SUBTILE_SIZE))

                    img_base = get_sub_tile_img(base_num, base_set)
                    img_anim = get_sub_tile_img(anim_num, anim_set) if anim_num != 0 else img_base

                    base_has_content = img_base is not None and img_base.getextrema()[3][1] > 0
                    anim_has_content = img_anim is not None and img_anim.getextrema()[3][1] > 0

                    if not base_has_content and not anim_has_content:
                        col.append({"AutoTileset": "", "Associates": [], "NeighborCode": -1, "Layers": []})
                        continue

                    if anim_num != 0 and (img_base is None or img_base.tobytes() != img_anim.tobytes()):
                        f0 = register_sub_image(img_base if base_has_content else None)
                        f1 = register_sub_image(img_anim if anim_has_content else None)
                        frames = [f0, f1]
                        frame_length = PMDO_ANIMATION_FRAME_LENGTH
                        animated_cells_count += 1
                    else:
                        f0 = register_sub_image(img_base if base_has_content else None)
                        frames = [f0]
                        frame_length = 60

                    col.append({
                        "AutoTileset": "",
                        "Associates": [],
                        "NeighborCode": -1,
                        "Layers": [{"Frames": frames, "FrameLength": frame_length}],
                    })
                columns.append(col)
            pmdo_layers.append({
                "Name": layer_name,
                "Layer": 0,
                "Visible": True,
                "Tiles": columns,
            })

        # Build PMDO collision obstacles (8x8 cells)
        obstacles: list[list[dict[str, Any]]] = []
        blocked_cell_count = 0
        for gx in range(grid_w):
            col_obs = []
            tx = gx // SUBTILES_PER_PMU_TILE
            for gy in range(grid_h):
                ty = gy // SUBTILES_PER_PMU_TILE
                t = tiles_by_coords.get((tx, ty))
                t_type = int(t.get("type", 0)) if t else 0
                is_blocked = 1 if t_type in DEFINITE_BLOCK_TYPES else 0
                if is_blocked:
                    blocked_cell_count += 1
                col_obs.append({
                    "Bounds": {"X": gx * 8, "Y": gy * 8, "Width": 8, "Height": 8},
                    "Tags": is_blocked,
                })
            obstacles.append(col_obs)

        # Build PMDO Entities (MapChars, Markers, GroundObjects)
        markers: list[dict[str, Any]] = []
        ground_objects: list[dict[str, Any]] = []
        map_chars: list[dict[str, Any]] = []

        # Convert Warps to Markers
        for idx, warp in enumerate(map_extraction["semantics"].get("warps", [])):
            markers.append({
                "Name": f"Warp_{idx + 1}",
                "Position": {
                    "X": warp["source_x"] * PMU_TILE_SIZE + 16,
                    "Y": warp["source_y"] * PMU_TILE_SIZE + 16,
                },
                "Direction": 0,
                "TargetMap": warp["target_map_id"],
                "TargetX": warp["target_x"],
                "TargetY": warp["target_y"],
            })

        # Convert Cardinal connections to Markers
        for dir_name, target_map in map_extraction["semantics"].get("cardinal_connections", {}).items():
            markers.append({
                "Name": f"Edge_{dir_name.capitalize()}",
                "Position": {
                    "X": (width_tiles * PMU_TILE_SIZE) // 2 if dir_name in ("up", "down") else (0 if dir_name == "left" else width_tiles * PMU_TILE_SIZE - 16),
                    "Y": 0 if dir_name == "up" else (height_tiles * PMU_TILE_SIZE - 16 if dir_name == "down" else (height_tiles * PMU_TILE_SIZE) // 2),
                },
                "Direction": {"up": 4, "down": 0, "left": 2, "right": 6}.get(dir_name, 0),
                "TargetMap": target_map,
            })

        # Convert Signs to GroundObjects
        for idx, sign in enumerate(map_extraction["semantics"].get("signs", [])):
            ground_objects.append({
                "Name": f"Sign_{idx + 1}",
                "Collider": {
                    "X": sign["x"] * PMU_TILE_SIZE,
                    "Y": sign["y"] * PMU_TILE_SIZE,
                    "Width": PMU_TILE_SIZE,
                    "Height": PMU_TILE_SIZE,
                },
                "Lines": sign.get("lines", []),
                "ScriptId": sign.get("script_id"),
            })

        # Convert NPCs to MapChars
        for idx, npc in enumerate(map_extraction["entities"].get("npcs", [])):
            spawn_x = int(npc.get("spawn_x") or -1)
            spawn_y = int(npc.get("spawn_y") or -1)
            pos_x = (spawn_x * PMU_TILE_SIZE + 16) if spawn_x >= 0 else (width_tiles * PMU_TILE_SIZE // 2)
            pos_y = (spawn_y * PMU_TILE_SIZE + 16) if spawn_y >= 0 else (height_tiles * PMU_TILE_SIZE // 2)
            map_chars.append({
                "Name": f"NPC_{idx + 1}_{npc.get('npc_name', 'Monster')}",
                "CharID": npc.get("npc_sprite", 0),
                "Position": {"X": pos_x, "Y": pos_y},
                "Direction": 0,
                "Behavior": npc.get("npc_behavior", 0),
                "Script": npc.get("npc_script", ""),
                "Species": npc.get("npc_species", -1),
                "MinLevel": npc.get("min_level", 1),
                "MaxLevel": npc.get("max_level", 1),
            })

        entities_layers = [{
            "Name": "PMU Entities",
            "Visible": True,
            "MapChars": map_chars,
            "GroundObjects": ground_objects,
            "Spawners": [],
            "Markers": markers,
        }]

        # Full PMDO .rsground Object
        rsground_data = {
            "Version": "0.8.12.0",
            "Object": {
                "$type": "RogueEssence.Data.GroundData, RogueEssence",
                "TexSize": tex_size,
                "Name": {
                    "DefaultText": map_name,
                    "LocalTexts": {},
                },
                "Released": True,
                "Comment": f"PMU canonical port for {map_id} ({map_name})",
                "obstacles": obstacles,
                "rand": {"$type": "RogueEssence.Data.ReRandom, RogueEssence", "Seed": 20260830},
                "Status": [],
                "Background": None,
                "BlankBG": False,
                "Layers": pmdo_layers,
                "AssetName": f"pmu_{map_id}",
                "Music": pmu_map.get("environment", {}).get("music", ""),
                "EdgeView": 0,
                "NoSwitching": False,
                "ViewCenter": {"X": (width_tiles * PMU_TILE_SIZE) // 2, "Y": (height_tiles * PMU_TILE_SIZE) // 2},
                "ViewOffset": {"X": 0, "Y": 0},
                "ActiveChar": None,
                "Decorations": [{"Name": "New Deco", "Layer": 0, "Visible": True, "Anims": []}],
                "Entities": entities_layers,
            },
        }

        # Lua Controller Script
        lua_script = self._generate_lua_controller(map_id, map_name, pmu_map, map_extraction["semantics"])

        # Write files if output paths provided
        tile_file_path = self.repo_root / "Content/Tile" / f"{sheet_name}.tile"
        ground_file_path = self.repo_root / "Data/Ground" / f"pmu_{map_id}.rsground"
        lua_file_path = self.repo_root / "Data/Script/halcyon/ground" / f"pmu_{map_id}" / "init.lua"

        write_pmdo_tile_file(tile_file_path, tex_size * 8, atlas_entries)
        ground_file_path.parent.mkdir(parents=True, exist_ok=True)
        ground_file_path.write_text(
            "\ufeff" + json.dumps(rsground_data, ensure_ascii=False, separators=(",", ":")),
            encoding="utf-8",
        )
        lua_file_path.parent.mkdir(parents=True, exist_ok=True)
        lua_file_path.write_text(lua_script, encoding="utf-8", newline="\n")

        # Semantics comparison document
        semantics_pmdo = {
            "schema": "new-era.pmdo-semantics.v1",
            "map_id": map_id,
            "asset_name": f"pmu_{map_id}",
            "grid_dimensions_8px": [grid_w, grid_h],
            "tex_size": tex_size,
            "warps": [
                {"name": m["Name"], "pos": m["Position"], "target": m.get("TargetMap"), "tx": m.get("TargetX"), "ty": m.get("TargetY")}
                for m in markers if "Warp" in m["Name"]
            ],
            "signs": [
                {"name": s["Name"], "collider": s["Collider"], "lines": s.get("Lines", [])}
                for s in ground_objects if "Sign" in s["Name"]
            ],
            "npcs": [
                {"name": c["Name"], "sprite": c["CharID"], "pos": c["Position"], "behavior": c["Behavior"]}
                for c in map_chars
            ],
            "obstacles_summary": {
                "total_cells": grid_w * grid_h,
                "blocked_cells": blocked_cell_count,
                "walkable_cells": grid_w * grid_h - blocked_cell_count,
            },
        }

        pmdo_manifest = {
            "schema": "new-era.pmu-pmdo-manifest.v1",
            "map_id": map_id,
            "asset_name": f"pmu_{map_id}",
            "name": map_name,
            "tex_size": tex_size,
            "scale_factor_px": 1.0,
            "dimensions_tiles_pmu": [width_tiles, height_tiles],
            "dimensions_pixels": [width_tiles * PMU_TILE_SIZE, height_tiles * PMU_TILE_SIZE],
            "dimensions_grid_pmdo": [grid_w, grid_h],
            "unique_subtiles": len(atlas_entries),
            "animated_subcells": animated_cells_count,
            "artifacts": {
                "ground": str(ground_file_path.relative_to(self.repo_root)),
                "ground_sha256": sha256_file(ground_file_path),
                "tile": str(tile_file_path.relative_to(self.repo_root)),
                "tile_sha256": sha256_file(tile_file_path),
                "script": str(lua_file_path.relative_to(self.repo_root)),
                "script_sha256": sha256_file(lua_file_path),
            },
            "status": "CONVERTED",
        }

        return {
            "map_id": map_id,
            "asset_name": f"pmu_{map_id}",
            "rsground": rsground_data,
            "tile_path": tile_file_path,
            "ground_path": ground_file_path,
            "script_path": lua_file_path,
            "atlas_entries_count": len(atlas_entries),
            "unique_payloads_count": len(unique_payloads),
            "payload_images": payload_images,
            "pmdo_layers": pmdo_layers,
            "obstacles": obstacles,
            "semantics_pmdo": semantics_pmdo,
            "pmdo_manifest": pmdo_manifest,
        }

    def _generate_lua_controller(
        self,
        map_id: str,
        map_name: str,
        pmu_map: dict[str, Any],
        semantics: dict[str, Any],
    ) -> str:
        asset = f"pmu_{map_id}"
        lines = [
            f"-- PMU Ground Controller for {asset} ({map_name})",
            f"-- Generated by PMU Pipeline (New Era)",
            f"local {asset} = {{}}",
            "",
            f"function {asset}.Init(map)",
            f"  DEBUG.EnableDbgScript(true)",
            f"end",
            "",
            f"function {asset}.Enter(map)",
            f"  local music = '{pmu_map.get('environment', {}).get('music', '')}'",
            f"  if music ~= '' then",
            f"    SOUND:PlayBGM(music, true)",
            f"  end",
            f"end",
            "",
            f"function {asset}.Update(map, time)",
            f"end",
            "",
        ]

        # Add warp handlers
        for idx, warp in enumerate(semantics.get("warps", [])):
            t_map = warp["target_map_id"]
            tx, ty = warp["target_x"], warp["target_y"]
            lines.extend([
                f"function {asset}.Warp_{idx + 1}_Touch(obj, activator)",
                f"  GAME:FadeOut(false, 20)",
                f"  GAME:EnterGroundMap('pmu_{t_map}', 'Entrance', false)",
                f"end",
                "",
            ])

        # Add sign handlers
        for idx, sign in enumerate(semantics.get("signs", [])):
            clean_lines = [line.replace("'", "\\'") for line in sign.get("lines", []) if line.strip()]
            dialogue_code = "\n".join([f"  UI:WaitShowDialogue('{l}')" for l in clean_lines]) if clean_lines else "  UI:WaitShowDialogue('...')"
            lines.extend([
                f"function {asset}.Sign_{idx + 1}_Action(obj, activator)",
                dialogue_code,
                f"end",
                "",
            ])

        lines.extend([
            f"return {asset}",
            "",
        ])
        return "\n".join(lines)
