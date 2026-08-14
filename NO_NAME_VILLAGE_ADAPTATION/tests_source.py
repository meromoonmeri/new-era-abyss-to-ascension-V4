#!/usr/bin/env python3
from __future__ import annotations

import gzip
import hashlib
import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
CACHE = ROOT / ".runtime-cache/no-name-village/extracted"
REPORTS = ROOT / "NO_NAME_VILLAGE_ADAPTATION/reports"

def digest(path: Path) -> str: return hashlib.sha256(path.read_bytes()).hexdigest()

global_ir = json.loads((CACHE / "global-ir.json").read_text())
assert global_ir["status"] == "SOURCE_EXTRACTED"
assert global_ir["counts"] == {
    "code": 2144, "objects": 727, "rooms": 98, "sounds": 388,
    "sprites": 2775, "strings": 22228, "texture_page_items": 9134,
    "texture_pages": 96, "tilesets": 30,
}
assert global_ir["source"]["sha256"] == "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
assert len(global_ir["rooms"]) == 98
for row in global_ir["rooms"]:
    path = Path(row["ir"])
    with gzip.open(path, "rb") as stream: payload = stream.read()
    assert hashlib.sha256(payload).hexdigest() == row["ir_json_sha256"]
    room = json.loads(payload)
    assert room["id"] == row["id"] and room["name"] == row["name"]
    for layer in room["layers"]:
        if layer["type"] == 4:
            width, height = layer["grid"]
            assert len(layer["tile_data"]) == width * height
for index in range(96):
    with Image.open(CACHE / f"textures/texture-{index:03d}.png") as image:
        image.verify()
room_index = json.loads((REPORTS / "room-index.json").read_text())
village = next(row for row in room_index if row["name"] == "rmvillage")
assert village["dimensions_px"] == [4992, 4992]
assert village["layer_count"] == 18
assert village["transition_count"] == 8
assert village["spawn_count"] == 6
assert village["house_instance_count"] == 4
assert village["solid_collision_instance_count"] == 259
season = json.loads((REPORTS / "season-system.json").read_text())
assert season["states"] == ["spring", "summer", "autumn", "winter"]
assert season["status"] == "SOURCE_PROVEN_PARTIAL_VM_LOGIC"
print("No Name Village source tests: OK")
