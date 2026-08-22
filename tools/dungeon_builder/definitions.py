"""Dungeon definitions: external data files loaded by the builder.

A definition lives outside the tool (`DungeonDefs/canonical/<id>.json`) so the
builder itself never hardcodes dungeon content.  Values cascade:

    dungeon defaults  ->  segment  ->  floor override

Anything omitted falls back to the RogueElements / PMDO defaults already used
by this repository's zones.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DEF_DIR = ROOT / "DungeonDefs" / "canonical"


class DefinitionError(ValueError):
    """Raised for any structurally invalid dungeon definition."""


# --------------------------------------------------------------------------
@dataclass
class ProfileChoice:
    name: str
    weight: int = 10
    overrides: Dict[str, Any] = field(default_factory=dict)


@dataclass
class MobEntry:
    species: str
    level: Tuple[int, int]
    weight: int = 10
    floors: Optional[Tuple[int, int]] = None
    tactic: str = "wander_normal"
    skills: Sequence[str] = ()
    features: Sequence[str] = ("weak",)


@dataclass
class ItemEntry:
    item: str
    weight: int = 10
    price: int = 0
    amount: int = 0


@dataclass
class ItemTable:
    name: str
    amount: Tuple[int, int] = (2, 5)
    entries: List[ItemEntry] = field(default_factory=list)


@dataclass
class Features:
    shop: Dict[str, Any] = field(default_factory=dict)
    monster_house: Dict[str, Any] = field(default_factory=dict)
    treasure_room: Dict[str, Any] = field(default_factory=dict)
    key_room: Dict[str, Any] = field(default_factory=dict)
    weather: List[Dict[str, Any]] = field(default_factory=list)
    mystery: Dict[str, Any] = field(default_factory=dict)
    traps: Dict[str, Any] = field(default_factory=dict)

    @classmethod
    def from_json(cls, data: Dict[str, Any]) -> "Features":
        known = {f for f in cls.__dataclass_fields__}
        unknown = set(data) - known
        if unknown:
            raise DefinitionError(f"unknown feature keys: {sorted(unknown)}")
        return cls(**{k: data[k] for k in data})

    def merged(self, other: Optional["Features"]) -> "Features":
        if other is None:
            return self
        out = Features(**{k: getattr(self, k) for k in self.__dataclass_fields__})
        for key in self.__dataclass_fields__:
            val = getattr(other, key)
            if val:
                setattr(out, key, val)
        return out


@dataclass
class Segment:
    name: str
    floors: Tuple[int, int]                 # inclusive 1-based floor numbers
    biome: str = ""
    dtef: Dict[str, str] = field(default_factory=dict)
    music: str = ""
    profiles: List[ProfileChoice] = field(default_factory=list)
    mobs: List[MobEntry] = field(default_factory=list)
    inherit_mobs: bool = True
    item_tables: List[ItemTable] = field(default_factory=list)
    inherit_items: bool = True
    money: Tuple[int, int] = (0, 0)
    features: Optional[Features] = None
    stairs: Dict[str, Any] = field(default_factory=dict)
    max_foes: int = 0
    respawn_time: int = 0
    fixed_floors: Dict[int, Dict[str, str]] = field(default_factory=dict)

    @property
    def floor_numbers(self) -> List[int]:
        return list(range(self.floors[0], self.floors[1] + 1))

    @property
    def length(self) -> int:
        return self.floors[1] - self.floors[0] + 1


@dataclass
class DungeonDefinition:
    id: str
    name: Dict[str, str]
    chapter: int
    floors: int
    segments: List[Segment]
    source: str = ""
    route: str = "secondary"
    biome: str = ""
    music: str = ""
    dtef: Dict[str, str] = field(default_factory=dict)
    level: int = 1
    rescues: int = 2
    released: bool = True
    comment: str = ""
    profiles: List[ProfileChoice] = field(default_factory=list)
    mobs: List[MobEntry] = field(default_factory=list)
    item_tables: List[ItemTable] = field(default_factory=list)
    money: Tuple[int, int] = (100, 140)
    features: Features = field(default_factory=Features)
    stairs: Dict[str, Any] = field(default_factory=dict)
    fixed_grounds: Dict[str, str] = field(default_factory=dict)
    minibosses: List[Dict[str, Any]] = field(default_factory=list)
    boss: Dict[str, Any] = field(default_factory=dict)
    midpoint: Dict[str, Any] = field(default_factory=dict)
    variation: Dict[str, Any] = field(default_factory=dict)
    path: Optional[Path] = None

    # -- cascade helpers ----------------------------------------------
    def segment_for_floor(self, floor: int) -> Segment:
        for seg in self.segments:
            if seg.floors[0] <= floor <= seg.floors[1]:
                return seg
        raise DefinitionError(f"floor {floor} of '{self.id}' belongs to no segment")

    def profiles_for(self, seg: Segment) -> List[ProfileChoice]:
        return seg.profiles or self.profiles

    def mobs_for(self, seg: Segment) -> List[MobEntry]:
        if seg.inherit_mobs:
            return list(self.mobs) + list(seg.mobs)
        return list(seg.mobs)

    def items_for(self, seg: Segment) -> List[ItemTable]:
        if seg.inherit_items:
            base = {t.name: t for t in self.item_tables}
            for table in seg.item_tables:
                base[table.name] = table
            return list(base.values())
        return list(seg.item_tables)

    def features_for(self, seg: Segment) -> Features:
        return self.features.merged(seg.features)

    def dtef_for(self, seg: Segment) -> Dict[str, str]:
        merged = dict(self.dtef)
        merged.update(seg.dtef or {})
        return merged

    def stairs_for(self, seg: Segment) -> Dict[str, Any]:
        merged = dict(self.stairs)
        merged.update(seg.stairs or {})
        return merged


# --------------------------------------------------------------------------
def _tuple2(value, field_name: str) -> Tuple[int, int]:
    if not isinstance(value, (list, tuple)) or len(value) != 2:
        raise DefinitionError(f"'{field_name}' must be a [min, max] pair, got {value!r}")
    lo, hi = value
    if not isinstance(lo, int) or not isinstance(hi, int):
        raise DefinitionError(f"'{field_name}' must contain integers, got {value!r}")
    if hi < lo:
        raise DefinitionError(f"'{field_name}' has max < min: {value!r}")
    return int(lo), int(hi)


def _mob(data: Dict[str, Any]) -> MobEntry:
    for required in ("species", "level"):
        if required not in data:
            raise DefinitionError(f"pokemon entry missing '{required}': {data!r}")
    return MobEntry(
        species=str(data["species"]),
        level=_tuple2(data["level"], "pokemon.level"),
        weight=int(data.get("weight", 10)),
        floors=_tuple2(data["floors"], "pokemon.floors") if "floors" in data else None,
        tactic=str(data.get("tactic", "wander_normal")),
        skills=tuple(data.get("skills", ())),
        features=tuple(data.get("features", ("weak",))),
    )


def _item_table(name: str, data: Dict[str, Any]) -> ItemTable:
    entries = []
    for raw in data.get("entries", []):
        if "item" not in raw:
            raise DefinitionError(f"item entry missing 'item': {raw!r}")
        entries.append(ItemEntry(str(raw["item"]), int(raw.get("weight", 10)),
                                 int(raw.get("price", 0)), int(raw.get("amount", 0))))
    if not entries:
        raise DefinitionError(f"item table '{name}' has no entries")
    return ItemTable(name, _tuple2(data.get("amount", [2, 5]), "item_table.amount"), entries)


def _profiles(raw: Sequence[Any], where: str) -> List[ProfileChoice]:
    out = []
    for item in raw:
        if isinstance(item, str):
            out.append(ProfileChoice(item))
        elif isinstance(item, dict):
            if "name" not in item:
                raise DefinitionError(f"{where}: profile entry needs a 'name'")
            out.append(ProfileChoice(str(item["name"]), int(item.get("weight", 10)),
                                     dict(item.get("overrides", {}))))
        else:
            raise DefinitionError(f"{where}: invalid profile entry {item!r}")
    return out


def parse_definition(data: Dict[str, Any], path: Optional[Path] = None) -> DungeonDefinition:
    for required in ("id", "name", "chapter", "floors", "segments"):
        if required not in data:
            raise DefinitionError(f"definition missing required field '{required}'")

    floors = int(data["floors"])
    if floors < 1:
        raise DefinitionError("'floors' must be >= 1")

    name = data["name"]
    if isinstance(name, str):
        name = {"en": name}
    if "en" not in name:
        raise DefinitionError("'name' needs at least an 'en' entry")

    segments: List[Segment] = []
    for raw in data["segments"]:
        for required in ("name", "floors"):
            if required not in raw:
                raise DefinitionError(f"segment missing '{required}'")
        seg = Segment(
            name=str(raw["name"]),
            floors=_tuple2(raw["floors"], "segment.floors"),
            biome=str(raw.get("biome", data.get("biome", ""))),
            dtef=dict(raw.get("dtef", {})),
            music=str(raw.get("music", "")),
            profiles=_profiles(raw.get("profiles", []), f"segment '{raw['name']}'"),
            mobs=[_mob(m) for m in raw.get("pokemon", [])],
            inherit_mobs=bool(raw.get("inherit_pokemon", True)),
            item_tables=[_item_table(k, v) for k, v in raw.get("items", {}).items()],
            inherit_items=bool(raw.get("inherit_items", True)),
            money=_tuple2(raw["money"], "segment.money") if "money" in raw else (0, 0),
            features=Features.from_json(raw["features"]) if "features" in raw else None,
            stairs=dict(raw.get("stairs", {})),
            max_foes=int(raw.get("max_foes", 0)),
            respawn_time=int(raw.get("respawn_time", 0)),
            fixed_floors={int(k): v for k, v in raw.get("fixed_floors", {}).items()},
        )
        segments.append(seg)

    if not segments:
        raise DefinitionError("a dungeon needs at least one segment")

    covered: List[int] = []
    for seg in segments:
        if seg.floors[0] < 1 or seg.floors[1] > floors:
            raise DefinitionError(
                f"segment '{seg.name}' range {seg.floors} is outside 1..{floors}")
        covered.extend(seg.floor_numbers)
    if len(covered) != len(set(covered)):
        raise DefinitionError("segments overlap on at least one floor")
    if sorted(covered) != list(range(1, floors + 1)):
        missing = sorted(set(range(1, floors + 1)) - set(covered))
        raise DefinitionError(f"segments do not cover every floor; missing {missing}")

    definition = DungeonDefinition(
        id=str(data["id"]),
        name=name,
        chapter=int(data["chapter"]),
        floors=floors,
        segments=segments,
        source=str(data.get("source", "")),
        route=str(data.get("route", "secondary")),
        biome=str(data.get("biome", "")),
        music=str(data.get("music", "")),
        dtef=dict(data.get("dtef", {})),
        level=int(data.get("level", 1)),
        rescues=int(data.get("rescues", 2)),
        released=bool(data.get("released", True)),
        comment=str(data.get("comment", "")),
        profiles=_profiles(data.get("profiles", []), "dungeon"),
        mobs=[_mob(m) for m in data.get("pokemon", [])],
        item_tables=[_item_table(k, v) for k, v in data.get("items", {}).items()],
        money=_tuple2(data.get("money", [100, 140]), "money"),
        features=Features.from_json(data.get("features", {})),
        stairs=dict(data.get("stairs", {})),
        fixed_grounds=dict(data.get("fixed_grounds", {})),
        minibosses=list(data.get("minibosses", [])),
        boss=dict(data.get("boss", {})),
        midpoint=dict(data.get("midpoint", {})),
        variation=dict(data.get("variation", {})),
        path=path,
    )

    if not definition.profiles and not all(seg.profiles for seg in segments):
        raise DefinitionError("no architecture profile declared (dungeon level or every segment)")
    if not definition.dtef and not all(seg.dtef for seg in segments):
        raise DefinitionError("no DTEF tileset declared (dungeon level or every segment)")
    return definition


def load_definition(path: Path) -> DungeonDefinition:
    path = Path(path)
    if not path.exists():
        raise DefinitionError(f"definition not found: {path}")
    with path.open(encoding="utf-8-sig") as handle:
        try:
            data = json.load(handle)
        except json.JSONDecodeError as exc:
            raise DefinitionError(f"{path.name}: invalid JSON ({exc})") from exc
    return parse_definition(data, path)


def find_definition(name: str, folder: Optional[Path] = None) -> Path:
    folder = Path(folder or DEFAULT_DEF_DIR)
    direct = Path(name)
    if direct.exists() and direct.is_file():
        return direct
    candidate = folder / f"{name}.json"
    if candidate.exists():
        return candidate
    raise DefinitionError(f"no definition '{name}' in {folder}")


def list_definitions(folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DEFAULT_DEF_DIR)
    return sorted(p for p in folder.glob("*.json"))
