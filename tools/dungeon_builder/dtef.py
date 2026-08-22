"""DTEF / auto-tile integration.

The project already imports DTEF packages as RogueEssence `AutoTileData`
(`Data/AutoTile/<id>.json`), each backed by a tile sheet in `Content/Tile`.
The builder never paints transitions itself: it points `MapTextureStep` at the
imported auto-tilesets, which is what applies the 256 adjacency combinations at
runtime.  This module only *resolves and verifies* those references.
"""
from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional

ROOT = Path(__file__).resolve().parents[2]
AUTOTILE_DIR = ROOT / "Data" / "AutoTile"
TILE_DIR = ROOT / "Content" / "Tile"

ROLES = ("floor", "wall", "secondary")


class DtefError(ValueError):
    pass


@dataclass
class DtefPackage:
    name: str
    floor: str
    wall: str
    secondary: str
    element: str = "normal"
    sheets: Optional[List[str]] = None

    def as_texture_args(self):
        return self.floor, self.wall, self.secondary, self.element


def available_autotiles(autotile_dir: Path = AUTOTILE_DIR) -> List[str]:
    if not autotile_dir.exists():
        return []
    return sorted(p.stem for p in autotile_dir.glob("*.json"))


def available_packages(autotile_dir: Path = AUTOTILE_DIR) -> Dict[str, DtefPackage]:
    """Group imported auto-tiles into <name>_floor / _wall / _secondary triplets."""
    found: Dict[str, Dict[str, str]] = {}
    for tile_id in available_autotiles(autotile_dir):
        for role in ROLES:
            suffix = f"_{role}"
            if tile_id.endswith(suffix):
                found.setdefault(tile_id[: -len(suffix)], {})[role] = tile_id
    packages = {}
    for base, roles in found.items():
        if set(roles) == set(ROLES):
            packages[base] = DtefPackage(base, roles["floor"], roles["wall"], roles["secondary"])
    return packages


def sheets_of(tile_id: str, autotile_dir: Path = AUTOTILE_DIR) -> List[str]:
    path = autotile_dir / f"{tile_id}.json"
    if not path.exists():
        return []
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    sheets = set()

    def walk(node):
        if isinstance(node, dict):
            if "Sheet" in node and isinstance(node["Sheet"], str):
                sheets.add(node["Sheet"])
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    walk(data)
    return sorted(sheets)


def resolve(spec: Dict[str, str], autotile_dir: Path = AUTOTILE_DIR,
            tile_dir: Path = TILE_DIR, strict: bool = True) -> DtefPackage:
    """Resolve a definition's `dtef` block into a verified package."""
    if not spec:
        raise DtefError("no DTEF tileset specified")

    if "package" in spec:
        packages = available_packages(autotile_dir)
        base = spec["package"]
        if base not in packages:
            raise DtefError(f"DTEF package '{base}' is not imported "
                            f"(available: {', '.join(sorted(packages)) or 'none'})")
        package = packages[base]
        package.element = spec.get("element", "normal")
    else:
        missing = [role for role in ROLES if role not in spec]
        if missing:
            raise DtefError(f"DTEF spec missing {missing}; give either 'package' or all of {list(ROLES)}")
        package = DtefPackage(spec.get("name", spec["floor"]), spec["floor"], spec["wall"],
                              spec["secondary"], spec.get("element", "normal"))

    if strict:
        known = set(available_autotiles(autotile_dir))
        for role in ROLES:
            tile_id = getattr(package, role)
            if tile_id and tile_id not in known:
                raise DtefError(f"auto-tileset '{tile_id}' is not imported in Data/AutoTile")
        sheets = set()
        for role in ROLES:
            sheets.update(sheets_of(getattr(package, role), autotile_dir))
        package.sheets = sorted(sheets)
        for sheet in package.sheets:
            if sheet and not (tile_dir / f"{sheet}.tile").exists():
                raise DtefError(f"tile sheet '{sheet}.tile' referenced by "
                                f"'{package.name}' is missing from Content/Tile")
    return package
