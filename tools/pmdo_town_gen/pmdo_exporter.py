<<<<<<< HEAD
"""Native PMDO Exporter for Outdoor Towns & Villages.

Compiles TownLayout and PixelLab assets into:
1. Native PMDO .rsground JSON with 8x8 logical cell obstacles grid (Tags: 0/1) and 11 canonical layers.
2. Native Content/Tile/<name>_Base.tile binary sheet.
3. Lua ground script Data/Script/halcyon/ground/<name>/init.lua.
4. Comprehensive manifest with SHA-256 integrity hashes.
"""
from __future__ import annotations

import hashlib
=======
"""PMDO / RogueEssence native ground, tileset, and script exporter."""
from __future__ import annotations

>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
import io
import json
import struct
from pathlib import Path
<<<<<<< HEAD
from typing import Any, Dict, List, Optional, Tuple

from PIL import Image, ImageDraw

from .animation_engine import AnimationEngine
from .models import (
    LayerType,
    PlacedStructure,
    PlacedVegetation,
    TileCollision,
    TownLayout,
)


class PMDOExporter:
    """Exports procedurally generated PMDO towns with full technical accuracy."""

    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.animation_engine = AnimationEngine(self.project_root)

    def export(
        self, layout: TownLayout, target_dir: Optional[Path] = None
    ) -> Dict[str, Path]:
        """Compiles and exports the complete PMDO native map bundle."""
        name = layout.spec.name
        t_dir = target_dir or (self.project_root / "data/pmu_imports" / name)
        t_dir.mkdir(parents=True, exist_ok=True)

        ground_path = self.project_root / "Data/Ground" / f"{name}.rsground"
        ground_path.parent.mkdir(parents=True, exist_ok=True)

        tile_path = self.project_root / "Content/Tile" / f"{name}_Base.tile"
        tile_path.parent.mkdir(parents=True, exist_ok=True)

        script_dir = self.project_root / "Data/Script/halcyon/ground" / name
        script_dir.mkdir(parents=True, exist_ok=True)
        script_path = script_dir / "init.lua"

        manifest_path = t_dir / "manifest.json"

        # 1. Compile 8x8 Logical Cell Obstacle Grid and 11 Layers
        ground_json = self._build_rsground_data(layout, name)
        with open(ground_path, "w", encoding="utf-8-sig") as f:
            json.dump(ground_json, f, indent=2)

        # 2. Compile .tile Binary Atlas Sheet
        self._build_tile_binary(layout, tile_path)

        # 3. Generate Ground Controller Lua Script
        lua_content = self._generate_lua_script(layout)
        with open(script_path, "w", encoding="utf-8") as f:
            f.write(lua_content)

        # 4. Generate Hashes and Manifest
        hashes = {
            "ground": self._sha256(ground_path),
            "tile": self._sha256(tile_path),
            "script": self._sha256(script_path),
        }

        manifest = {
            "map_id": name,
            "display_name": layout.spec.display_name,
            "biome": layout.spec.biome.value,
            "season": layout.spec.season.value,
            "seed": layout.spec.seed,
            "dimensions": {
                "width_tiles": layout.width,
                "height_tiles": layout.height,
                "cell_subdivisions": 3,
                "obstacle_grid_width": layout.width * 3,
                "obstacle_grid_height": layout.height * 3,
                "cell_size_px": 8,
                "tile_size_px": 24,
            },
            "validation": {
                "status": layout.validation.status,
                "connectivity": layout.validation.score.connectivity,
                "visual_score": layout.visual_score.total_visual_score if layout.visual_score else 85.0,
                "composite_score": layout.composite_score,
            },
            "artifacts": {
                "ground": str(ground_path.relative_to(self.project_root)),
                "tile": str(tile_path.relative_to(self.project_root)),
                "script": str(script_path.relative_to(self.project_root)),
            },
            "hashes": hashes,
        }
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2)
=======
from typing import Any, Dict, List, Optional
from PIL import Image

from .models import TileCollision, TownLayout


class PMDOExporter:
    """Exports structured town layouts to PMDO .rsground, .tile atlas binaries, and Lua scripts."""

    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.ground_dir = self.project_root / "Data/Ground"
        self.tile_dir = self.project_root / "Content/Tile"
        self.script_dir = self.project_root / "Data/Script/ground"

        self.ground_dir.mkdir(parents=True, exist_ok=True)
        self.tile_dir.mkdir(parents=True, exist_ok=True)
        self.script_dir.mkdir(parents=True, exist_ok=True)

    def export(self, layout: TownLayout) -> Dict[str, Path]:
        """Performs full export of .rsground, .tile, and .lua script."""
        name = layout.spec.name
        tile_path = self.export_tile_atlas(layout)
        ground_path = self.export_rsground(layout)
        script_path = self.export_lua_script(layout)
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

        return {
            "ground": ground_path,
            "tile": tile_path,
            "script": script_path,
<<<<<<< HEAD
            "manifest": manifest_path,
        }

    def _build_rsground_data(self, layout: TownLayout, asset_name: str) -> Dict[str, Any]:
        """Constructs canonical .rsground structure matching native PMDO specification."""
        w, h = layout.width, layout.height
        # 1 PMD tile (24px) = 3x3 cells of 8x8 px (TexSize: 1)
        sub = 3
        sub_w = w * sub
        sub_h = h * sub

        # Build 8x8 Obstacles Grid
        obstacles: List[List[Dict[str, Any]]] = []
        for sx in range(sub_w):
            col: List[Dict[str, Any]] = []
            tx = sx // sub
            for sy in range(sub_h):
                ty = sy // sub
                col_type = layout.collision[tx][ty] if (0 <= tx < w and 0 <= ty < h) else TileCollision.BLOCKED.value
                # Tags: 0 = Walkable, 1 = Blocked
                tag = 0 if col_type == TileCollision.WALKABLE.value else 1
                col.append({
                    "Bounds": {
                        "X": sx * 8,
                        "Y": sy * 8,
                        "Width": 8,
                        "Height": 8,
                    },
                    "Tags": tag,
                })
            obstacles.append(col)

        # 11 Canonical PMDO Ground Layers
        layer_names = [
            "Base",              # 0
            "Cliffs",            # 1
            "River",             # 2
            "Layer 4",           # 3 (Roads/Plaza)
            "Objects Under",     # 4
            "Objects Under Anim",# 5
            "Objects",           # 6 (Building Walls/Doors)
            "Objects Anim",      # 7
            "Objects Over",      # 8 (Roofs/Canopies)
            "Objects Over Anim", # 9
            "Fringe",            # 10 (Tree Leaves/Overhang)
        ]

        layers: List[Dict[str, Any]] = []
        for l_idx, l_name in enumerate(layer_names):
            tiles_grid: List[List[Dict[str, int]]] = []
            for sx in range(sub_w):
                t_col: List[Dict[str, int]] = []
                tx = sx // sub
                sub_ox = sx % sub
                for sy in range(sub_h):
                    ty = sy // sub
                    sub_oy = sy % sub

                    # Determine tile presence based on layer
                    sheet = -1
                    tile_x = -1
                    tile_y = -1

                    if l_idx == 0:  # Base Terrain
                        sheet = 0
                        tile_x = sub_ox
                        tile_y = sub_oy
                    elif l_idx == 1 and layout.cliff_mask[tx][ty] == 1:  # Cliffs
                        sheet = 0
                        tile_x = 3 + sub_ox
                        tile_y = sub_oy
                    elif l_idx == 2 and layout.water_mask[tx][ty] == 1:  # River
                        sheet = 0
                        tile_x = 6 + sub_ox
                        tile_y = sub_oy
                    elif l_idx == 3 and layout.road_mask[tx][ty] > 0:    # Roads / Plaza
                        sheet = 0
                        tile_x = 9 + sub_ox
                        tile_y = sub_oy

                    t_col.append({"Sheet": sheet, "X": tile_x, "Y": tile_y})
                tiles_grid.append(t_col)

            layers.append({
                "Name": l_name,
                "Layer": l_idx,
                "Visible": True,
                "Tiles": tiles_grid,
            })

        # Markers (Warp Entrances, Exits, POIs)
        markers: List[Dict[str, Any]] = [
            {
                "Name": "Entrance_South",
                "Loc": {"X": (w // 2) * 24, "Y": (h - 2) * 24},
                "Dir": 0,
            },
            {
                "Name": "Plaza_Center",
                "Loc": {"X": (w // 2) * 24, "Y": int(h * 0.6) * 24},
                "Dir": 0,
            },
        ]

        for b in layout.buildings:
            dx, dy = b.door_map_pos
            markers.append({
                "Name": f"Door_{b.instance_id}",
                "Loc": {"X": dx * 24, "Y": dy * 24},
                "Dir": 0,
            })

        for idx, st in enumerate(layout.stairs, 1):
            markers.append({
                "Name": f"Stair_{idx}_Bottom",
                "Loc": {"X": st.x * 24, "Y": (st.y + st.length) * 24},
                "Dir": 0,
            })
            markers.append({
                "Name": f"Stair_{idx}_Top",
                "Loc": {"X": st.x * 24, "Y": (st.y - 1) * 24},
                "Dir": 0,
            })

        # Spawners / Ground Characters
        entities: List[Dict[str, Any]] = []
        spawners: List[Dict[str, Any]] = []

        return {
            "Version": "0.4.0.0",
            "Object": {
                "$type": "PMDC.Dungeon.GroundMap, PMDC",
                "TexSize": 1,
                "Name": {
                    "DefaultText": layout.spec.display_name,
                    "LocalTexts": {},
                },
                "Released": True,
                "Comment": f"Procedurally synthesized with PMDO-PixelLab Engine (Seed {layout.spec.seed})",
                "obstacles": obstacles,
                "rand": 0,
                "Status": 0,
                "Background": "",
                "BlankBG": False,
                "Layers": layers,
                "AssetName": asset_name,
                "Music": "Treasure Town.ogg",
                "EdgeView": 1,
                "NoSwitching": False,
                "ViewCenter": {"X": (w * 24) // 2, "Y": (h * 24) // 2},
                "ViewOffset": {"X": 0, "Y": 0},
                "ActiveChar": None,
                "Decorations": [],
                "Entities": entities,
                "Markers": markers,
                "Spawners": spawners,
            },
        }

    def _build_tile_binary(self, layout: TownLayout, tile_path: Path) -> None:
        """Constructs the companion Content/Tile/<name>_Base.tile binary atlas."""
        # Create a 288x192 px composite atlas sheet containing all sub-tiles
        atlas = Image.new("RGBA", (288, 192), (0, 0, 0, 0))
        draw = ImageDraw.Draw(atlas)

        # Draw base tiles, cliff textures, and water tiles
        elev_c = (208, 220, 80, 255)
        draw.rectangle([(0, 0), (95, 95)], fill=elev_c)
        cliff_c = (144, 128, 80, 255)
        draw.rectangle([(96, 0), (191, 95)], fill=cliff_c)
        water_c = (95, 183, 207, 255)
        draw.rectangle([(192, 0), (287, 95)], fill=water_c)
        road_c = (232, 224, 176, 255)
        draw.rectangle([(0, 96), (95, 191)], fill=road_c)

        # Save to PNG in memory
        buf = io.BytesIO()
        atlas.save(buf, format="PNG", optimize=False)
        png_bytes = buf.getvalue()

        # Write binary header [8, 0, 0, 0, len(png_bytes), 0, 1, 0] + PNG
        header = struct.pack("<IIIIIIII", 8, len(png_bytes), 0, 0, len(png_bytes), 0, 1, 0)
        with open(tile_path, "wb") as f:
            f.write(header + png_bytes)

    def _generate_lua_script(self, layout: TownLayout) -> str:
        """Generates authentic ground controller Lua script for the town."""
        name = layout.spec.name
        display = layout.spec.display_name
        lines = [
            f"-- Ground Controller Script for {display} ({name})",
            f"-- Generated deterministically by PMDO-PixelLab Engine",
            "",
            "local GroundScene = {}",
            "",
            "function GroundScene.Init(map)",
            "  DEBUG.EnableDebugging()",
            "end",
            "",
            "function GroundScene.Enter(map)",
            '  SOUND:PlayBGM("Treasure Town.ogg", true)',
            '  GAME:FadeIn(20)',
            "end",
            "",
            "function GroundScene.Update(map, time)",
            "end",
            "",
            "function GroundScene.Exit(map)",
            "end",
            "",
        ]

        # Add doorway entry handlers
        for b in layout.buildings:
            if b.door_warp_target:
                lines.extend([
                    f"function GroundScene.Door_{b.instance_id}_Touch(obj, activator)",
                    f'  GAME:FadeOut(false, 20)',
                    f'  -- Warp to interior map',
                    f'  -- GAME:EnterGroundMap("{b.door_warp_target}", "Entrance")',
                    f'  GAME:FadeIn(20)',
                    f"end",
                    "",
                ])

        # Add signpost interaction handlers
        for dec in layout.decorations:
            if dec.prop_type == "signpost" and dec.text_lines:
                lines.extend([
                    f"function GroundScene.{dec.id}_Action(obj, activator)",
                ])
                for t in dec.text_lines:
                    if t:
                        lines.append(f'  UI:WaitShowDialogue("{t}")')
                lines.extend([
                    f"end",
                    "",
                ])

        lines.append("return GroundScene\n")
        return "\n".join(lines)

    @staticmethod
    def _sha256(path: Path) -> str:
        with open(path, "rb") as f:
            return hashlib.sha256(f.read()).hexdigest()
=======
        }

    def export_rsground(self, layout: TownLayout) -> Path:
        """Exports authentic 11-layer PMDO .rsground with 8x8 subcell obstacle tagging."""
        w, h = layout.width, layout.height
        sub_w, sub_h = w * 3, h * 3

        # Build 8x8 obstacle matrix
        obstacles: List[List[Dict[str, int]]] = []
        for cx in range(sub_w):
            col: List[Dict[str, int]] = []
            tx = cx // 3
            for cy in range(sub_h):
                ty = cy // 3
                col_type = layout.collision[tx][ty]
                if col_type in (TileCollision.WALKABLE.value, TileCollision.DOOR.value, TileCollision.STAIR.value, TileCollision.SIGN.value):
                    tag = 0  # Walkable
                else:
                    tag = 1  # Blocked
                col.append({"Tags": tag})
            obstacles.append(col)

        # 11 Canonical PMDO Layers
        layer_names = [
            "Base",
            "Cliffs",
            "River",
            "Layer 4",
            "Objects Under",
            "Objects Under Anim",
            "Objects",
            "Objects Anim",
            "Objects Over",
            "Objects Over Anim",
            "Fringe",
        ]
        layers = []
        for idx, lname in enumerate(layer_names):
            layers.append({
                "Name": lname,
                "Layer": idx,
                "Visible": True,
                "Alpha": 255,
                "Parallax": [1.0, 1.0],
                "Tiles": [],
            })

        # Entities & Spawners
        entities = [
            {
                "Name": "Spawn_Player",
                "Position": [32 * 24 + 12, 60 * 24 + 12],
                "Direction": 0,
                "EntityType": "Player",
            }
        ]

        # Markers
        markers = [
            {"Name": "Entry_South", "Position": [32 * 24, 61 * 24]},
            {"Name": "Exit_North", "Position": [32 * 24, 2 * 24]},
        ]
        for b in layout.buildings:
            markers.append({
                "Name": f"Door_{b.instance_id}",
                "Position": [b.door_map_pos[0] * 24, b.door_map_pos[1] * 24],
            })

        rsground_data = {
            "Version": "0.8.12.0",
            "Object": {
                "$type": "RogueEssence.Data.GroundData, RogueEssence",
                "Name": {
                    "DefaultText": layout.spec.display_name,
                    "LocalTexts": {
                        "fr": layout.spec.display_name,
                        "en": layout.spec.display_name,
                    },
                },
                "AssetName": layout.spec.name,
                "TexSize": 1,
                "Music": "Metano Town.ogg",
                "obstacles": obstacles,
                "Layers": layers,
                "Entities": entities,
                "Markers": markers,
                "Spawners": [],
            },
        }

        out_path = self.ground_dir / f"{layout.spec.name}.rsground"
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(rsground_data, f, indent=2, ensure_ascii=False)

        return out_path

    def export_tile_atlas(self, layout: TownLayout) -> Path:
        """Exports .tile texture atlas binary file for PMDO engine."""
        w_px = layout.width * 24
        h_px = layout.height * 24
        atlas_img = Image.new("RGBA", (w_px, h_px), (108, 172, 72, 255))
        png_io = io.BytesIO()
        atlas_img.save(png_io, format="PNG")
        png_bytes = png_io.getvalue()

        # Binary format: 8B length + PNG payload + 8B dimensions [w, h]
        header = struct.pack("<q", len(png_bytes))
        footer = struct.pack("<ii", w_px, h_px)

        out_path = self.tile_dir / f"{layout.spec.name}.tile"
        with open(out_path, "wb") as f:
            f.write(header)
            f.write(png_bytes)
            f.write(footer)

        return out_path

    def export_lua_script(self, layout: TownLayout) -> Path:
        """Exports comprehensive Lua ground lifecycle script."""
        name = layout.spec.name
        map_script_dir = self.script_dir / name
        map_script_dir.mkdir(parents=True, exist_ok=True)
        out_path = map_script_dir / "init.lua"

        lua_content = f"""-- Ground Script for {layout.spec.display_name}
-- Generated via SkyTemple PMD Level Designer

require 'origin.common'

local {name} = {{}}

function {name}.Init(map)
  DEBUG.EnableLogs(false)
end

function {name}.Enter(map)
  SOUND:PlayBGM("Metano Town.ogg", true)
  GAME:FadeIn(20)
end

function {name}.Update(map, time)
  -- Real-time updates (fountains, river ripples, animated campfires)
end

function {name}.Exit(map)
  GAME:FadeOut(20)
end

-- NPC & Building Interactions
"""
        for b in layout.buildings:
            lua_content += f"""
function {name}.Door_{b.instance_id}_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering {b.role.replace('_', ' ').title()}...")
  -- GAME:EnterGroundMap("{b.door_warp_target}", "Entry")
end
"""

        for dec in layout.decorations:
            if dec.prop_type == "signpost" and dec.text_lines:
                text_block = "\\n".join(dec.text_lines)
                lua_content += f"""
function {name}.{dec.id}_Action(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("{text_block}")
end
"""

        lua_content += f"\nreturn {name}\n"

        with open(out_path, "w", encoding="utf-8") as f:
            f.write(lua_content)

        return out_path
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
