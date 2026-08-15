#!/usr/bin/env python3
"""Generate a native PMDO candidate from one official No Name Village room.

This first production converter deliberately accepts only tile-only exterior
rooms.  It reuses PMU_ADAPTATION's proven native .tile/.rsground writer,
preserves every source tile layer, and normalizes the source's 4x pixel-art
presentation to 16 px PMDO cells with nearest-neighbour sampling.  Any source
sprite instance, social actor, unresolved transition, or unsupported layer is a
hard blocker and prevents CONVERTED status.
"""
from __future__ import annotations

import argparse
import copy
import gzip
import hashlib
import io
import json
import re
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve()
REPO = HERE.parents[2]
for path in (REPO / "PMU_ADAPTATION/src", REPO / "PMU_EXTRACTION/src", REPO / "tools"):
    sys.path.insert(0, str(path))

try:
    from PIL import Image
except ImportError as exc:  # pragma: no cover - explicit operator failure
    raise SystemExit("Pillow missing; install NO_NAME_VILLAGE_ADAPTATION/requirements-conversion.lock") from exc

from pmu_adaptation.composer import (  # noqa: E402
    _empty_cell, _empty_ground_object, _ground_shell, _marker, _png_bytes, _unpremultiply, write_tile,
)
from smart_dungeon.assets import _tile_entries  # noqa: E402

SOURCE_SHA256 = "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
TARGET_CELL = 16
SOURCE_CELL = 64
SCALE_DIVISOR = 4
TILE_INDEX_MASK = 0x0007FFFF
TILE_MIRROR = 0x10000000
TILE_FLIP = 0x20000000
TILE_ROTATE = 0x40000000
SYSTEM_REQUIRES = (
    "halcyon.LivingWorld", "halcyon.TownLife", "halcyon.TownPlace",
    "halcyon.Seasons", "halcyon.Weather", "halcyon.TownNight",
)
SUMMER_OBJECT_SPRITES = {"objtree": "bgsmtree", "objtree0": "bgsmtree0"}


def read_gzip(path: Path) -> Any:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def canonical_sha(value: Any) -> str:
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def file_sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def ref_index(value: Any) -> int | None:
    if not isinstance(value, dict):
        return None
    ref = value.get("$resourceRef")
    return ref.get("index") if isinstance(ref, dict) else None


def ref_name(value: Any) -> str | None:
    if not isinstance(value, dict):
        return None
    ref = value.get("$resourceRef")
    return ref.get("name") if isinstance(ref, dict) else None


def ensure_texture_cache(extracted: Path, cache: Path) -> None:
    if len(list(cache.glob("*_Texture_*.png"))) == 96:
        return
    structured = REPO / ".runtime-cache/nnv-official-structured"
    if structured.exists(): shutil.rmtree(structured)
    (structured / "inventory").mkdir(parents=True)
    for source in sorted((extracted / "inventory").glob("*.json.gz")):
        with gzip.open(source, "rb") as incoming:
            (structured / "inventory" / source.name[:-3]).write_bytes(incoming.read())
    (structured / "blobs").symlink_to(extracted / "blobs")
    if cache.exists(): shutil.rmtree(cache)
    subprocess.run([
        sys.executable, str(REPO / "NO_NAME_VILLAGE_ADAPTATION/tools/decode_official_textures.py"),
        str(structured), str(cache),
    ], check=True)
    if len(list(cache.glob("*_Texture_*.png"))) != 96:
        raise ValueError("official texture cache reconstruction incomplete")


class OfficialTiles:
    def __init__(self, extracted: Path, textures: Path):
        self.backgrounds = read_gzip(extracted / "inventory/Backgrounds.json.gz")
        self.items = read_gzip(extracted / "inventory/TexturePageItems.json.gz")
        self.textures = read_gzip(extracted / "inventory/EmbeddedTextures.json.gz")
        self.sprites = read_gzip(extracted / "inventory/Sprites.json.gz")
        self.sprite_by_name = {row["Name"].casefold(): index for index, row in enumerate(self.sprites)}
        self.texture_dir = textures
        self.page_cache: dict[int, Image.Image] = {}
        self.atlas_cache: dict[int, Image.Image] = {}
        self.tile_cache: dict[tuple[int, int, int], Image.Image | None] = {}
        self.sprite_cache: dict[tuple[int, int], Image.Image] = {}

    def page(self, index: int) -> Image.Image:
        if index not in self.page_cache:
            name = self.textures[index].get("Name") or f"Texture_{index}"
            path = self.texture_dir / f"{index:04d}_{name.replace(' ', '_')}.png"
            if not path.is_file():
                candidates = list(self.texture_dir.glob(f"{index:04d}_*.png"))
                if len(candidates) != 1:
                    raise FileNotFoundError(f"official texture page {index}")
                path = candidates[0]
            image = Image.open(path).convert("RGBA"); image.load()
            self.page_cache[index] = image
        return self.page_cache[index]

    def atlas(self, item_index: int) -> Image.Image:
        if item_index not in self.atlas_cache:
            item = self.items[item_index]
            page_index = ref_index(item.get("TexturePage"))
            if page_index is None:
                raise ValueError(f"texture page item {item_index} has no page")
            image = self.page(page_index).crop((
                int(item["SourceX"]), int(item["SourceY"]),
                int(item["SourceX"] + item["SourceWidth"]), int(item["SourceY"] + item["SourceHeight"]),
            ))
            target = (int(item["TargetWidth"]), int(item["TargetHeight"]))
            if image.size != target:
                image = image.resize(target, Image.Resampling.NEAREST)
            self.atlas_cache[item_index] = image
        return self.atlas_cache[item_index]

    def sprite(self, sprite_index: int, frame: int = 0) -> Image.Image:
        sprite = self.sprites[sprite_index]
        textures = sprite.get("Textures") or []
        if not textures:
            return Image.new("RGBA", (int(sprite["Width"]), int(sprite["Height"])), (0, 0, 0, 0))
        frame %= len(textures); key = (sprite_index, frame)
        if key not in self.sprite_cache:
            item_index = ref_index(textures[frame].get("Texture"))
            if item_index is None:
                raise ValueError(f"sprite {sprite['Name']} frame {frame} has no texture")
            item = self.items[item_index]
            canvas = Image.new("RGBA", (int(sprite["Width"]), int(sprite["Height"])), (0, 0, 0, 0))
            canvas.alpha_composite(self.atlas(item_index), (int(item["TargetX"]), int(item["TargetY"])))
            self.sprite_cache[key] = canvas
        return self.sprite_cache[key].copy()

    def tile(self, background_index: int, raw: int, frame: int = 0) -> Image.Image | None:
        tile_index = raw & TILE_INDEX_MASK
        key = (background_index, tile_index, frame)
        if key in self.tile_cache:
            base = self.tile_cache[key]
            return base.copy() if base is not None else None
        bg = self.backgrounds[background_index]
        frames = max(1, int(bg["GMS2ItemsPerTileCount"]))
        if tile_index <= 0 or tile_index >= int(bg["GMS2TileCount"]):
            self.tile_cache[key] = None
            return None
        ids = bg["GMS2TileIds"]
        mapped = int(ids[tile_index * frames + (frame % frames)]["ID"])
        item_index = ref_index(bg.get("Texture"))
        if item_index is None:
            self.tile_cache[key] = None
            return None
        atlas = self.atlas(item_index)
        border_x, border_y = int(bg["GMS2OutputBorderX"]), int(bg["GMS2OutputBorderY"])
        width, height = int(bg["GMS2TileWidth"]), int(bg["GMS2TileHeight"])
        columns = int(bg["GMS2TileColumns"])
        x = border_x + (mapped % columns) * (width + 2 * border_x)
        y = border_y + (mapped // columns) * (height + 2 * border_y)
        image = atlas.crop((x, y, x + width, y + height))
        if raw & TILE_MIRROR:
            image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if raw & TILE_FLIP:
            image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        if raw & TILE_ROTATE:
            image = image.transpose(Image.Transpose.ROTATE_90)
        image = image.resize((width // SCALE_DIVISOR, height // SCALE_DIVISOR), Image.Resampling.NEAREST)
        self.tile_cache[key] = image
        return image.copy()


def transformed_sprite(tiles: OfficialTiles, sprite_index: int, frame: int, scale_x: float, scale_y: float, rotation: float) -> tuple[Image.Image, int, int]:
    sprite = tiles.sprites[sprite_index]
    image = tiles.sprite(sprite_index, frame)
    width = max(1, round(image.width * abs(scale_x))); height = max(1, round(image.height * abs(scale_y)))
    image = image.resize((width, height), Image.Resampling.NEAREST)
    if scale_x < 0: image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    if scale_y < 0: image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
    if rotation: image = image.rotate(-rotation, resample=Image.Resampling.NEAREST, expand=True)
    image = image.resize((max(1, image.width // SCALE_DIVISOR), max(1, image.height // SCALE_DIVISOR)), Image.Resampling.NEAREST)
    return image, round(int(sprite["OriginX"]) * scale_x / SCALE_DIVISOR), round(int(sprite["OriginY"]) * scale_y / SCALE_DIVISOR)


def draw_sprite(canvas: Image.Image, tiles: OfficialTiles, sprite_index: int, frame: int, x: float, y: float, scale_x: float, scale_y: float, rotation: float) -> None:
    image, origin_x, origin_y = transformed_sprite(tiles, sprite_index, frame, scale_x, scale_y, rotation)
    canvas.alpha_composite(image, (round(x / SCALE_DIVISOR) - origin_x, round(y / SCALE_DIVISOR) - origin_y))


def canvas_layer(name: str, canvas: Image.Image, sheet: str, add_image) -> dict[str, Any]:
    width, height = canvas.width // TARGET_CELL, canvas.height // TARGET_CELL
    columns = []
    for x in range(width):
        column = []
        for y in range(height):
            image = canvas.crop((x * TARGET_CELL, y * TARGET_CELL, (x + 1) * TARGET_CELL, (y + 1) * TARGET_CELL))
            if image.getbbox() is None:
                column.append(_empty_cell())
            else:
                tx, ty = add_image(image)
                column.append({"AutoTileset": "", "Associates": [], "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": tx, "Y": ty}}], "FrameLength": 60}], "NeighborCode": -1})
        columns.append(column)
    return {"Name": name, "Layer": 0, "Visible": True, "Tiles": columns}


def collision_mask(extracted: Path, sprite: dict[str, Any], scale_x: float, scale_y: float, rotation: float) -> Image.Image | None:
    masks = sprite.get("CollisionMasks") or []
    width, height = int(sprite["Width"]), int(sprite["Height"])
    image = Image.new("L", (width, height), 0)
    if masks:
        mask = masks[0]; binary = ((mask.get("Data") or {}).get("$binary") or {}); path = binary.get("path")
        if not path: return None
        bits = (extracted / path).read_bytes(); width, height = int(mask["Width"]), int(mask["Height"]); stride = (width + 7) // 8
        image = Image.new("L", (width, height), 0); pixels = image.load()
        for y in range(height):
            for x in range(width):
                if bits[y * stride + x // 8] & (1 << (7 - x % 8)): pixels[x, y] = 255
    else:
        left, top = int(sprite.get("MarginLeft") or 0), int(sprite.get("MarginTop") or 0)
        right, bottom = int(sprite.get("MarginRight") or width - 1), int(sprite.get("MarginBottom") or height - 1)
        if right < left or bottom < top: return None
        image.paste(255, (left, top, right + 1, bottom + 1))
    image = image.resize((max(1, round(width * abs(scale_x))), max(1, round(height * abs(scale_y)))), Image.Resampling.NEAREST)
    if scale_x < 0: image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    if scale_y < 0: image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
    if rotation: image = image.rotate(-rotation, resample=Image.Resampling.NEAREST, expand=True)
    target = (max(1, image.width // SCALE_DIVISOR), max(1, image.height // SCALE_DIVISOR))
    image = image.resize(target, Image.Resampling.BOX).point(lambda value: 255 if value else 0)
    return image


def room_creation_code(gml: dict[str, str], placement: dict[str, Any]) -> dict[str, Any]:
    code = ref_name(placement.get("CreationCode"))
    text = gml.get(f"{code}.gml", "") if code else ""
    match = re.search(r"\bnewroom\s*=\s*(-?\d+)", text)
    return {"code": code, "newroom": int(match.group(1)) if match else None, "code_sha256": hashlib.sha256(text.encode()).hexdigest() if text else None}


def controller(asset: str, transitions: list[dict[str, Any]]) -> str:
    lines = ["-- Generated NNV→PMDO candidate; not a production route.", "require 'origin.common'"]
    lines.extend(f"require '{name}'" for name in SYSTEM_REQUIRES)
    lines += ["local M = {}", "function M.Init(map)", "  LivingWorld.Ensure()", "  TownNight.Ensure()", "end", "function M.Enter(map)", "  LivingWorld.SyncStory()", "  M.Context = LivingWorld.Context('no_name_village', '" + asset + "')", "  M.Day = TownLife.Today()", "  LivingWorld.ApplyOutdoor(true)", "  Seasons.Setup()", "  local preset = Weather.ForChapter((SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1)", "  if preset ~= nil then Weather.Set(preset) end", "end", "function M.PlaceDialogue(inst)", "  return TownPlace.Line(inst)", "end", "function M.Exit(map) end", "function M.Update(map) end"]
    for row in transitions:
        lines += [
            f"function M.{row['entity']}_Touch(obj, activator)",
            "  GAME:FadeOut(false, 20)",
            f"  GAME:EnterGroundMap('nnv_{row['target']}', '{row['target_marker']}')",
            "end",
        ]
    lines += ["function M.GameSave(map) end", "function M.GameLoad(map) end", "return M", ""]
    return "\n".join(lines)


def render_ground(ground: dict[str, Any], tile_path: Path) -> Image.Image:
    size, entries = _tile_entries(tile_path)
    images = {}
    for key, payload in entries:
        with Image.open(io.BytesIO(payload)) as image:
            decoded = _unpremultiply(image); decoded.load(); images[key] = decoded
    obj = ground["Object"]
    width = len(obj["Layers"][0]["Tiles"]); height = len(obj["Layers"][0]["Tiles"][0])
    canvas = Image.new("RGBA", (width * size, height * size), (0, 0, 0, 0))
    for layer in obj["Layers"]:
        if not layer.get("Visible", True):
            continue
        for x, column in enumerate(layer["Tiles"]):
            for y, cell in enumerate(column):
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames") or []
                    if not frames:
                        continue
                    loc = frames[0]["TexLoc"]; key = int(loc["X"]) | (int(loc["Y"]) << 32)
                    canvas.alpha_composite(images[key], (x * size, y * size))
    return canvas


def convert(repo: Path, room_name: str, extracted: Path, texture_cache: Path, output: Path) -> dict[str, Any]:
    source_summary = json.loads((repo / "NO_NAME_VILLAGE_ADAPTATION/reports/source-summary.json").read_text())
    if source_summary["source"]["sha256"] != SOURCE_SHA256:
        raise ValueError("No Name Village source authority mismatch")
    rooms = read_gzip(extracted / "inventory/Rooms.json.gz")
    objects = read_gzip(extracted / "inventory/GameObjects.json.gz")
    room_names = [row["Name"] for row in rooms]
    room = next((row for row in rooms if row["Name"] == room_name), None)
    if room is None:
        raise ValueError(f"unknown official room {room_name}")
    if [room["Width"], room["Height"]] != [4992, 4992]:
        raise ValueError("first exterior converter requires the official 4992×4992 room contract")
    ensure_texture_cache(extracted, texture_cache)
    with tarfile.open(extracted / "decompiled-gml.tar.gz", "r:gz") as archive:
        gml = {name: archive.extractfile(name).read().decode(errors="replace") for name in archive.getnames() if name.startswith("gml_RoomCC_")}

    # Every source placement remains represented either visually, spatially or
    # as an explicit blocker. Human/social source actors are never imported.
    blockers = []
    transitions_source = []
    source_objects = []
    for placement in room.get("GameObjects") or []:
        object_index = ref_index(placement.get("ObjectDefinition"))
        object_name = objects[object_index]["Name"] if object_index is not None else "UNKNOWN"
        source_objects.append((placement, object_index, object_name))
        if object_name in {"objtransit", "objdoor"}:
            code = room_creation_code(gml, placement)
            transitions_source.append({
                "instance_id": placement.get("InstanceID"), "object": object_name,
                "position_source_px": [placement.get("X"), placement.get("Y")],
                "scale": [placement.get("ScaleX"), placement.get("ScaleY")], **code,
            })
            if code["newroom"] is None or not 0 <= code["newroom"] < len(rooms):
                blockers.append(f"unresolved transition {placement.get('InstanceID')} newroom={code['newroom']}")
        elif object_name.startswith("objmob") or object_name in {"objlogger", "objhunter", "objcarpenter"}:
            blockers.append(f"social role {placement.get('InstanceID')}:{object_name} requires native Pokemon casting")

    if room_name == "rmvillage":
        blockers.append("native Pokemon living cast and TownLife/TownPlace routines are not bound yet")
    tiles = OfficialTiles(extracted, texture_cache)
    payload_locations: dict[bytes, tuple[int, int]] = {}
    tile_entries: list[tuple[int, bytes]] = []
    sheet = f"NNV_{room_name}_Source"

    def add_image(image: Image.Image) -> tuple[int, int]:
        payload = _png_bytes(image)
        if payload not in payload_locations:
            index = len(payload_locations); loc = (index % 64, index // 64)
            payload_locations[payload] = loc; tile_entries.append((loc[0] | (loc[1] << 32), payload))
        return payload_locations[payload]

    source_layers = []
    source_canvas = Image.new("RGBA", (1248, 1248), (0, 0, 0, 0))
    source_tile_layers = []
    for layer in sorted(room.get("Layers") or [], key=lambda row: int(row.get("LayerDepth") or 0), reverse=True):
        data = layer.get("Data")
        layer_type = (layer.get("LayerType") or {}).get("name")
        if layer_type == "Tiles" and isinstance(data, dict) and "TileData" in data:
            background_index = ref_index(data.get("Background"))
            rows = data.get("TileData") or []
            if not rows or background_index is None:
                continue
            bg = tiles.backgrounds[background_index]
            tile_width, tile_height = int(bg["GMS2TileWidth"]), int(bg["GMS2TileHeight"])
            if tile_width != tile_height or tile_width not in {64, 128}:
                if any(raw & TILE_INDEX_MASK for row in rows for raw in row): blockers.append(f"active unsupported tileset size {bg['Name']}:{tile_width}x{tile_height}")
                continue
            factor = tile_width // 64
            columns = []
            for x in range(len(rows[0]) * factor):
                column = []
                for y in range(len(rows) * factor):
                    raw = int(rows[y // factor][x // factor]); image = tiles.tile(background_index, raw, 0)
                    if image is None:
                        column.append(_empty_cell()); continue
                    crop = image.crop(((x % factor) * TARGET_CELL, (y % factor) * TARGET_CELL, (x % factor + 1) * TARGET_CELL, (y % factor + 1) * TARGET_CELL))
                    frame_count = max(1, int(bg["GMS2ItemsPerTileCount"])); frames = []
                    for frame in range(frame_count):
                        frame_image = tiles.tile(background_index, raw, frame)
                        frame_crop = frame_image.crop(((x % factor) * TARGET_CELL, (y % factor) * TARGET_CELL, (x % factor + 1) * TARGET_CELL, (y % factor + 1) * TARGET_CELL))
                        frames.append(add_image(frame_crop))
                    frame_length = max(1, round(int(bg["GMS2FrameLength"]) * 60 / 1_000_000))
                    column.append({"AutoTileset": "", "Associates": [], "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": fx, "Y": fy}} for fx, fy in frames], "FrameLength": frame_length}], "NeighborCode": -1})
                    if bool(layer.get("IsVisible", True)): source_canvas.alpha_composite(crop, (x * TARGET_CELL, y * TARGET_CELL))
                columns.append(column)
            source_layers.append({"Name": f"NNV {layer['LayerName']}", "Layer": 0, "Visible": bool(layer.get("IsVisible", True)), "Tiles": columns})
            source_tile_layers.append({"name": layer["LayerName"], "depth": layer.get("LayerDepth"), "background": bg["Name"], "matrix_sha256": canonical_sha(rows)})
        elif layer_type in {"Instances", "Assets"}:
            visual = Image.new("RGBA", (1248, 1248), (0, 0, 0, 0))
            rendered = 0
            if layer_type == "Instances" and isinstance(data, dict):
                for entry in data.get("Instances") or []:
                    cycle = entry.get("$cycleRef", "") if isinstance(entry, dict) else ""
                    match = re.search(r"GameObjects\[(\d+)\]", cycle)
                    if match is None: continue
                    placement = room["GameObjects"][int(match.group(1))]
                    object_index = ref_index(placement.get("ObjectDefinition"))
                    if object_index is None: continue
                    obj = objects[object_index]; object_name = obj["Name"]
                    if object_name.startswith("objsp"):
                        replacement = "objsm" + object_name[5:]
                        obj = next((row for row in objects if row["Name"] == replacement), obj)
                    sprite_index = ref_index(obj.get("Sprite"))
                    override = SUMMER_OBJECT_SPRITES.get(object_name)
                    if override is not None:
                        sprite_index = tiles.sprite_by_name.get(override.casefold(), sprite_index)
                    if not obj.get("Visible", True) or sprite_index is None: continue
                    sprite = tiles.sprites[sprite_index]; frame_count = len(sprite.get("Textures") or [])
                    if frame_count > 1:
                        blockers.append(f"animated source sprite {sprite['Name']} requires full frame-cycle conversion")
                    draw_sprite(visual, tiles, sprite_index, round(placement.get("ImageIndex") or 0), placement["X"], placement["Y"], float(placement.get("ScaleX") or 1), float(placement.get("ScaleY") or 1), float(placement.get("Rotation") or 0))
                    rendered += 1
            else:
                assets = layer.get("AssetsData") or {}
                for placement in assets.get("Sprites") or []:
                    sprite_index = ref_index(placement.get("Sprite"))
                    if sprite_index is None: continue
                    if layer.get("LayerName", "").casefold() == "below":
                        current = tiles.sprites[sprite_index]["Name"]
                        wanted = "ssm" + current[3:] if len(current) >= 3 else current
                        sprite_index = tiles.sprite_by_name.get(wanted.casefold(), sprite_index)
                    sprite = tiles.sprites[sprite_index]; frame_count = len(sprite.get("Textures") or [])
                    if frame_count > 1:
                        blockers.append(f"animated source asset {sprite['Name']} requires full frame-cycle conversion")
                    draw_sprite(visual, tiles, sprite_index, round(placement.get("FrameIndex") or 0), placement["X"], placement["Y"], float(placement.get("ScaleX") or 1), float(placement.get("ScaleY") or 1), float(placement.get("Rotation") or 0))
                    rendered += 1
            if rendered and visual.getbbox() is not None:
                visual_layer = canvas_layer(f"NNV {layer['LayerName']}", visual, sheet, add_image)
                visual_layer["Visible"] = bool(layer.get("IsVisible", True))
                source_layers.append(visual_layer)
                if visual_layer["Visible"]: source_canvas.alpha_composite(visual)
        elif layer_type not in {None, "Instances", "Assets", "Background"}:
            blockers.append(f"unsupported layer type {layer_type}:{layer.get('LayerName')}")

    if not source_layers:
        raise ValueError("room has no convertible source tile layers")
    visual_width = len(source_layers[0]["Tiles"]); visual_height = len(source_layers[0]["Tiles"][0])
    collision_width, collision_height = visual_width * 2, visual_height * 2
    collision_canvas = Image.new("L", (visual_width * TARGET_CELL, visual_height * TARGET_CELL), 0)
    solid_instance_count = 0
    for placement, object_index, object_name in source_objects:
        if object_index is None or not objects[object_index].get("Solid", False): continue
        if object_name in {"objtransit", "objdoor"}: continue
        solid_instance_count += 1; sprite_index = ref_index(objects[object_index].get("Sprite"))
        if sprite_index is None:
            blockers.append(f"solid source instance {placement.get('InstanceID')}:{object_name} has no sprite mask"); continue
        mask = collision_mask(extracted, tiles.sprites[sprite_index], float(placement.get("ScaleX") or 1), float(placement.get("ScaleY") or 1), float(placement.get("Rotation") or 0))
        if mask is None:
            blockers.append(f"solid source instance {placement.get('InstanceID')}:{object_name} has no collision mask"); continue
        sprite = tiles.sprites[sprite_index]
        left = round(placement["X"] / 4 - int(sprite["OriginX"]) * float(placement.get("ScaleX") or 1) / 4)
        top = round(placement["Y"] / 4 - int(sprite["OriginY"]) * float(placement.get("ScaleY") or 1) / 4)
        collision_canvas.paste(mask, (left, top), mask)
    obstacles = []
    for x in range(collision_width):
        column = []
        for y in range(collision_height):
            blocked = collision_canvas.crop((x * 8, y * 8, (x + 1) * 8, (y + 1) * 8)).getbbox() is not None
            column.append({"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": 1 if blocked else 0})
        obstacles.append(column)

    known = []
    objects_out = []
    markers = [
        _marker("Entry_North", 624, 16, direction=0), _marker("Entry_South", 624, 1216, direction=4),
        _marker("Entry_West", 16, 624, direction=6), _marker("Entry_East", 1216, 624, direction=2),
    ]
    for placement, _, object_name in source_objects:
        if object_name == "objspawnpoint":
            markers.append(_marker(f"SourceSpawn_{placement['InstanceID']}", round(placement["X"] / 4), round(placement["Y"] / 4), direction=0))
    for row in transitions_source:
        target_index = row["newroom"]
        if target_index is None or not 0 <= target_index < len(rooms):
            continue
        sx, sy = row["position_source_px"]
        if row.get("object") == "objdoor":
            edge = f"Door_{row['instance_id']}"; rect = (round(sx / 4), round(sy / 4), 16, 16); target_marker = "Entry_Door"
        elif sy < 0 and sx > -128:
            edge, rect, target_marker = "North", (0, 0, 1248, 8), "Entry_South"
        elif sx > room["Width"]:
            edge, rect, target_marker = "East", (1240, 0, 8, 1248), "Entry_West"
        elif sy > room["Height"]:
            edge, rect, target_marker = "South", (0, 1240, 1248, 8), "Entry_North"
        else:
            edge, rect, target_marker = "West", (0, 0, 8, 1248), "Entry_East"
        entity = f"Exit_{edge}"
        target = room_names[target_index]
        objects_out.append(_empty_ground_object(entity, *rect, passable=True, trigger=2))
        known.append({"entity": entity, "edge": edge, "target": target, "target_marker": target_marker, "source_instance_id": row["instance_id"]})

    entity_layer = {"Name": "NNV adaptation entities", "Visible": True, "MapChars": [], "GroundObjects": objects_out, "Spawners": [], "Markers": markers}
    asset = f"nnv_{room_name}"
    ground = _ground_shell(asset, f"No Name Village — {room_name}", 2, source_layers, obstacles, [entity_layer], "")
    ground["Object"]["Comment"] = (
        f"NNV official room {room_name}; source data.win SHA-256 {SOURCE_SHA256}; 4x pixel-art normalization 64px→16px nearest; "
        "source tile layers preserved independently; candidate only, no promotion."
    )

    if output.exists():
        import shutil; shutil.rmtree(output)
    tile_path = output / f"Content/Tile/{sheet}.tile"
    ground_path = output / f"Data/Ground/{asset}.rsground"
    script_path = output / f"Data/Script/halcyon/ground/{asset}/init.lua"
    tile_path.parent.mkdir(parents=True, exist_ok=True); ground_path.parent.mkdir(parents=True, exist_ok=True); script_path.parent.mkdir(parents=True, exist_ok=True)
    write_tile(tile_path, TARGET_CELL, tile_entries)
    ground_path.write_text("\ufeff" + json.dumps(ground, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    script_path.write_text(controller(asset, known), encoding="utf-8")

    candidate = render_ground(ground, tile_path)
    candidate_path = output / "validation/candidate_tick0.png"; source_path = output / "validation/source_normalized_tick0.png"
    candidate_path.parent.mkdir(parents=True, exist_ok=True)
    candidate.save(candidate_path, format="PNG", optimize=False, compress_level=9)
    source_canvas.save(source_path, format="PNG", optimize=False, compress_level=9)
    source_pixels = list(source_canvas.get_flattened_data()); candidate_pixels = list(candidate.get_flattened_data())
    differing_pixels = sum(left != right for left, right in zip(source_pixels, candidate_pixels))
    max_channel_error = max((max(abs(a - b) for a, b in zip(left, right)) for left, right in zip(source_pixels, candidate_pixels)), default=0)
    alpha_exact = all(left[3] == right[3] for left, right in zip(source_pixels, candidate_pixels))
    pixel_exact = differing_pixels == 0
    pmdo_roundtrip_valid = max_channel_error <= 1 and alpha_exact
    checks = {
        "ground_json_round_trip": json.loads(ground_path.read_text(encoding="utf-8-sig")) == ground,
        "source_dimensions_normalized_exactly": [visual_width, visual_height, TARGET_CELL] == [78, 78, 16],
        "collision_grid_matches_visual_extent": [collision_width, collision_height] == [156, 156],
        "tile_dependency_exists": tile_path.is_file() and bool(tile_entries),
        "all_source_tile_layers_preserved": len(source_tile_layers) == sum(1 for layer in room["Layers"] if (layer.get("LayerType") or {}).get("name") == "Tiles" and isinstance(layer.get("Data"), dict) and layer["Data"].get("TileData") and ref_index(layer["Data"].get("Background")) is not None and int(tiles.backgrounds[ref_index(layer["Data"].get("Background"))]["GMS2TileWidth"]) in {64, 128}),
        "tick0_visual_pmdo_premultiply_roundtrip": pmdo_roundtrip_valid,
        "entities_in_bounds": all(0 <= e["Collider"]["X"] <= 1248 and 0 <= e["Collider"]["Y"] <= 1248 for e in objects_out + markers),
        "existing_new_era_systems_required": all(f"require '{name}'" in script_path.read_text() for name in SYSTEM_REQUIRES),
    }
    static_pass = all(checks.values())
    status = "GENERATED_CANDIDATE" if static_pass else "FAILED"
    manifest = {
        "schema": "new-era.nnv-pmdo-room-conversion.v1", "room": room_name, "asset": asset,
        "source": {"data_win_sha256": SOURCE_SHA256, "room_record_sha256": canonical_sha(room), "official_inventory": "extracted/official/inventory/Rooms.json.gz"},
        "transform": {"kind": "deterministic_pixel_art_normalization", "scale": "1/4", "source_cell_px": 64, "target_cell_px": 16, "resampler": "nearest"},
        "status": status, "conversion_status": "UNIMPLEMENTED" if blockers else "STRUCTURALLY_VALID",
        "runtime_status": "NOT_RUN", "visual_status": "TICK0_PIXEL_EXACT" if pixel_exact else "TICK0_PMDO_PREMULTIPLY_ROUNDTRIP_VALID" if pmdo_roundtrip_valid else "FAILED",
        "visual_metrics": {"differing_pixels": differing_pixels, "max_channel_error": max_channel_error, "alpha_exact": alpha_exact, "pixel_exact": pixel_exact},
        "source_tile_layers": source_tile_layers, "source_transitions": transitions_source, "mapped_transitions": known,
        "collision_metrics": {"source_solid_instances": solid_instance_count, "blocked_pmdo_cells_8px": sum(cell["Tags"] != 0 for column in obstacles for cell in column)},
        "checks": checks, "blockers": sorted(set(blockers)),
        "new_era_systems": list(SYSTEM_REQUIRES),
        "outputs": {
            "ground": str(ground_path.relative_to(output)), "ground_sha256": file_sha(ground_path),
            "tile": str(tile_path.relative_to(output)), "tile_sha256": file_sha(tile_path),
            "script": str(script_path.relative_to(output)), "script_sha256": file_sha(script_path),
            "source_render": str(source_path.relative_to(output)), "source_render_sha256": file_sha(source_path),
            "candidate_render": str(candidate_path.relative_to(output)), "candidate_render_sha256": file_sha(candidate_path),
        },
        "promotion_allowed": False,
    }
    manifest["manifest_semantic_sha256"] = canonical_sha(manifest)
    (output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    root = REPO / "NO_NAME_VILLAGE_ADAPTATION"
    parser.add_argument("--room", required=True)
    parser.add_argument("--extracted", type=Path, default=root / "extracted/official")
    parser.add_argument("--texture-cache", type=Path, default=REPO / ".runtime-cache/nnv-official-textures")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    output = args.output or root / "generated" / args.room
    result = convert(REPO, args.room, args.extracted, args.texture_cache, output)
    print(json.dumps({key: result[key] for key in ("room", "status", "conversion_status", "runtime_status", "visual_status", "blockers")}, ensure_ascii=False))
    return 0 if result["status"] != "FAILED" else 1


if __name__ == "__main__":
    raise SystemExit(main())
