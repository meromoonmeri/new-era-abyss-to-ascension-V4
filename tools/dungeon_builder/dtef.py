"""DTEF / auto-tile integration.

The project already imports DTEF packages as RogueEssence `AutoTileData`
(`Data/AutoTile/<id>.json`), each backed by a tile sheet in `Content/Tile`.
The builder never paints transitions itself: it points `MapTextureStep` at the
imported auto-tilesets, which is what applies the 256 adjacency combinations at
runtime.  This module only *resolves and verifies* those references.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
AUTOTILE_DIR = ROOT / "Data" / "AutoTile"
TILE_DIR = ROOT / "Content" / "Tile"
ZONE_DIR = ROOT / "Data" / "Zone"
MAP_DIR = ROOT / "Data" / "Map"
GROUND_DIR = ROOT / "Data" / "Ground"

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
    origin: str = "mod"          # mod = imported in Data/AutoTile, base = shipped by PMDO
    justification: str = ""

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


@lru_cache(maxsize=1)
def base_tilesets() -> frozenset:
    """Auto-tilesets referenced by the data already shipped and working.

    PMDO ships hundreds of auto-tilesets that a mod does not re-import; the only
    trustworthy evidence that a name resolves at runtime is that an existing
    zone/map/ground already uses it.
    """
    names = set()
    pattern = re.compile(r'"(?:AutoTileset|GroundTileset|BlockTileset|WaterTileset)"\s*:\s*"([a-z0-9_]+)"')
    for folder, suffix in ((ZONE_DIR, "*.json"), (MAP_DIR, "*.rsmap"), (GROUND_DIR, "*.rsground")):
        if not folder.exists():
            continue
        for path in folder.glob(suffix):
            try:
                names.update(pattern.findall(path.read_text(encoding="utf-8-sig")))
            except (UnicodeDecodeError, OSError):
                continue
    names.discard("")
    return frozenset(names)


def known_tilesets() -> set:
    return set(available_autotiles()) | set(base_tilesets())


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

    package.justification = spec.get("justification", "")

    if strict:
        imported = set(available_autotiles(autotile_dir))
        shipped = base_tilesets()
        origins = set()
        for role in ROLES:
            tile_id = getattr(package, role)
            if not tile_id:
                continue
            if tile_id in imported:
                origins.add("mod")
            elif tile_id in shipped:
                origins.add("base")
            else:
                raise DtefError(
                    f"auto-tileset '{tile_id}' is neither imported in Data/AutoTile nor used by "
                    "any shipped zone/map/ground: import its DTEF package first")
        package.origin = "mod" if origins == {"mod"} else ("base" if origins == {"base"} else "mixed")
        sheets = set()
        for role in ROLES:
            sheets.update(sheets_of(getattr(package, role), autotile_dir))
        package.sheets = sorted(sheets)
        for sheet in package.sheets:
            if sheet and not (tile_dir / f"{sheet}.tile").exists():
                raise DtefError(f"tile sheet '{sheet}.tile' referenced by "
                                f"'{package.name}' is missing from Content/Tile")
    return package


# ---------------------------------------------------------------------------
def triplet_of(spec: Dict[str, str], autotile_dir: Path = AUTOTILE_DIR) -> Tuple[str, str, str]:
    package = resolve(spec, autotile_dir, strict=False)
    return package.floor, package.wall, package.secondary


def check_tileset_uniqueness(definitions: Sequence) -> List[str]:
    """No two dungeons may share the same DTEF triplet without a justification.

    Sharing a raw tileset is what makes two dungeons look identical; when no
    exact canonical equivalent exists, the definition must say so explicitly via
    `dtef.justification`.
    """
    problems: List[str] = []
    owners: Dict[Tuple[str, str, str], List[Tuple[str, str]]] = {}
    for definition in definitions:
        for segment in definition.segments:
            spec = definition.dtef_for(segment)
            if not spec:
                continue
            try:
                triplet = triplet_of(spec)
            except DtefError:
                continue
            owners.setdefault(triplet, []).append(
                (definition.id, str(spec.get("justification", ""))))
    for triplet, users in owners.items():
        dungeons = {name for name, _ in users}
        if len(dungeons) < 2:
            continue
        unjustified = sorted({name for name, why in users if not why})
        if len(unjustified) > 1:
            problems.append(
                f"tileset {triplet[0]}/{triplet[1]}/{triplet[2]} is shared by {unjustified} "
                "without any 'justification' in their dtef block")
    return problems
