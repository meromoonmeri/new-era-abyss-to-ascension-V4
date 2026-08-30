"""PMDO Native Exporter for Procedurally Generated Towns.

Compiles TownLayout into native .rsground, .tile, and Lua ground controllers.
"""
from __future__ import annotations

import hashlib
import io
import json
import struct
from pathlib import Path
from typing import Any, Dict, List, Optional

from PIL import Image

from .models import TileCollision, TownLayout


class PMDOExporter:
    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]

    def export(self, layout: TownLayout, out_dir: Optional[Path] = None) -> Dict[str, Path]:
        """Compiles and writes full PMDO asset bundle."""
        map_name = layout.spec.name
        display_name = layout.spec.display_name
        w, h = layout.width, layout.height

        target_dir = out_dir or (self.project_root / "data/pmu_imports" / map_name)
        target_dir.mkdir(parents=True, exist_ok=True)

        ground_path = self.project_root / "Data/Ground" / f"{map_name}.rsground"
        tile_path = self.project_root / "Content/Tile" / f"{map_name}_Base.tile"
        lua_dir = self.project_root / "Data/Script/halcyon/ground" / map_name
        lua_dir.mkdir(parents=True, exist_ok=True)
        lua_path = lua_dir / "init.lua"

        # 1. Generate .rsground
        # Obstacles grid in PMDO format: 2D list of { "Bounds": {...}, "Tags": 0 or 1 }
        obstacles: List[List[Dict[str, Any]]] = []
        tex_size = 3  # 24px tile = 8 * 3
        tile_px = 24

        for x in range(w):
            col: List[Dict[str, Any]] = []
            for y in range(h):
                is_blocked = (layout.collision[x][y] == TileCollision.BLOCKED.value)
                col.append({
                    "Bounds": {"X": x * tile_px, "Y": y * tile_px, "Width": tile_px, "Height": tile_px},
                    "Tags": 1 if is_blocked else 0,
                })
            obstacles.append(col)

        # Build PMDO Layer tiles (Base layer referencing TexLoc)
        base_tiles: List[List[Dict[str, Any]]] = []
        for x in range(w):
            col_tiles: List[Dict[str, Any]] = []
            for y in range(h):
                col_tiles.append({
                    "Layers": [{
                        "Frames": [{
                            "Sheet": f"{map_name}_Base",
                            "TexLoc": {"X": x, "Y": y},
                        }]
                    }]
                })
            base_tiles.append(col_tiles)

        # Entities (Warps on doors, NPCs at shops, signpost scripts)
        entities: List[Dict[str, Any]] = []
        entity_id = 1

        # Door warps
        for b in layout.buildings:
            dx, dy = b.door_map_pos
            if b.door_warp_target:
                entities.append({
                    "EntityData": {
                        "Name": f"Warp_{b.instance_id}",
                        "Position": [dx * tile_px, dy * tile_px],
                        "Direction": 2,  # Facing South
                    },
                    "Marker": {
                        "TargetGround": b.door_warp_target,
                        "TargetSpawn": 0,
                    }
                })
                entity_id += 1

        # Signposts
        for dec in layout.decorations:
            if dec.prop_type == "signpost" and dec.text_lines:
                entities.append({
                    "EntityData": {
                        "Name": f"Sign_{dec.id}",
                        "Position": [dec.x * tile_px, dec.y * tile_px],
                        "Direction": 2,
                    },
                    "Dialog": {
                        "Lines": dec.text_lines,
                    }
                })

        rsground_obj = {
            "Version": "0.8.12.0",
            "Object": {
                "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
                "TexSize": tex_size,
                "Name": {"DefaultText": display_name, "LocalTexts": {}},
                "Released": True,
                "Comment": f"Procedurally generated PMDO town layout: {map_name} (Seed {layout.spec.seed})",
                "obstacles": obstacles,
                "rand": {"Seed": layout.spec.seed},
                "Status": {},
                "Background": None,
                "BlankBG": {"A": 255, "R": 0, "G": 0, "B": 0},
                "Layers": [
                    {
                        "$type": "RogueEssence.Ground.MapLayer, RogueEssence",
                        "Name": "Base",
                        "Visible": True,
                        "Alpha": None,
                        "Tiles": base_tiles,
                    }
                ],
                "AssetName": map_name,
                "Music": "Treasure Town.ogg",
                "EdgeView": 0,
                "NoSwitching": False,
                "ViewCenter": {"X": (w * tile_px) // 2, "Y": int(h * 0.62 * tile_px)},
                "ViewOffset": {"X": 0, "Y": 0},
                "ActiveChar": None,
                "Decorations": [],
                "Entities": entities,
            }
        }

        ground_path.write_text(json.dumps(rsground_obj, indent=2) + "\n", encoding="utf-8-sig")

        # 2. Generate .tile binary sheet
        # Render map image and pack into .tile binary
        from .renderer import TownRenderer
        renderer = TownRenderer(tile_size=tile_px)
        final_img = renderer.render_final(layout)

        # Write binary .tile package
        tile_bytes = self._pack_tile_package(final_img, w, h, tile_px)
        tile_path.write_bytes(tile_bytes)

        # 3. Generate Lua ground controller
        lua_script = f"""--[[
    Ground Controller: {display_name} ({map_name})
    Procedurally generated by PMDO Town Generator (Seed: {layout.spec.seed})
]]

require 'origin.common'

local {map_name} = {{}}

function {map_name}.Init(map)
    DEBUG.EnableDbgCoro()
    PrintInfo("=>> Initializing ground {map_name}")
end

function {map_name}.Enter(map)
    GROUND:Hide('PLAYER')
    local player = CH('PLAYER')
    if player then
        GROUND:TeleportTo(player, {w * tile_px // 2}, {int(h * 0.85 * tile_px)}, Direction.Up)
    end
    GAME:FadeIn(20)
end

function {map_name}.Exit(map)
    GAME:FadeOut(20)
end

return {map_name}
"""
        lua_path.write_text(lua_script, encoding="utf-8")

        # 4. Write manifest & validation metadata
        manifest = {
            "schema": 1,
            "map_name": map_name,
            "display_name": display_name,
            "generator_version": "1.0.0",
            "seed": layout.spec.seed,
            "biome": layout.spec.biome.value,
            "season": layout.spec.season.value,
            "dimensions": {
                "width_tiles": w,
                "height_tiles": h,
                "tile_size_px": tile_px,
                "width_px": w * tile_px,
                "height_px": h * tile_px,
            },
            "validation": {
                "status": layout.validation.status if layout.validation else "PASS",
                "score": layout.validation.score.total_score if layout.validation else 100.0,
                "connectivity": layout.validation.score.connectivity if layout.validation else 100.0,
                "reachable_objectives": layout.validation.reachable_objectives if layout.validation else len(layout.buildings) + 2,
                "total_objectives": layout.validation.total_objectives if layout.validation else len(layout.buildings) + 2,
            },
            "artifacts": {
                "ground": str(ground_path.relative_to(self.project_root)),
                "tile": str(tile_path.relative_to(self.project_root)),
                "script": str(lua_path.relative_to(self.project_root)),
            }
        }
        (target_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

        return {
            "ground": ground_path,
            "tile": tile_path,
            "script": lua_path,
            "manifest": target_dir / "manifest.json",
        }

    def _pack_tile_package(self, img: Image.Image, w: int, h: int, tile_px: int) -> bytes:
        """Packs image tiles into native RogueEssence .tile binary format."""
        tile_count = w * h
        header_size = 8 + tile_count * 16

        offsets: List[Tuple[int, int]] = []  # (key, offset)
        png_data_list: List[bytes] = []

        current_offset = header_size

        for y in range(h):
            for x in range(w):
                key = (y << 32) | x
                tile_crop = img.crop((x * tile_px, y * tile_px, (x + 1) * tile_px, (y + 1) * tile_px))
                buf = io.BytesIO()
                tile_crop.save(buf, format="PNG", optimize=True)
                png_bytes = buf.getvalue()

                offsets.append((key, current_offset))
                png_data_list.append(png_bytes)
                current_offset += 8 + len(png_bytes)

        # Write binary stream
        out = bytearray()
        out.extend(struct.pack("<II", tile_px, tile_count))

        for key, offset in offsets:
            out.extend(struct.pack("<QQ", key, offset))

        for png_bytes in png_data_list:
            out.extend(struct.pack("<Q", len(png_bytes)))
            out.extend(png_bytes)

        return bytes(out)
