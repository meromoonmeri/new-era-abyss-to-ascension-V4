"""Data models and type definitions for PMDO Outdoor Town Layout Generator."""
from __future__ import annotations

import json
from dataclasses import asdict, dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional, Tuple


class BiomeType(str, Enum):
    GRASSLAND = "grassland"
    FOREST = "forest"
    COASTAL = "coastal"
    MOUNTAIN = "mountain"
    SWAMP = "swamp"
    SNOW = "snow"
    DESERT = "desert"


class SeasonType(str, Enum):
    SPRING = "spring"
    SUMMER = "summer"
    AUTUMN = "autumn"
    WINTER = "winter"


class TileCollision(int, Enum):
    WALKABLE = 0
    BLOCKED = 1
    WARP = 2
    ITEM = 3
    SCRIPTED = 7
    SIGN = 8
    SHOP = 10
    NPC_AVOID = 24


class LayerType(int, Enum):
    GROUND = 0
    GROUND_ANIM = 1
    MASK = 2
    MASK_ANIM = 3
    MASK2 = 4
    MASK2_ANIM = 5
    FRINGE = 6
    FRINGE_ANIM = 7
    FRINGE2 = 8
    FRINGE2_ANIM = 9


class RoadHierarchy(str, Enum):
    PRIMARY_AVENUE = "primary_avenue"      # 3-4 tiles wide
    SECONDARY_STREET = "secondary_street"  # 2 tiles wide
    MICRO_PATH = "micro_path"              # 1 tile wide


class DistrictType(str, Enum):
    PLAZA = "plaza"
    RESIDENTIAL = "residential"
    COMMERCIAL = "commercial"
    NATURE = "nature"
    WATERFRONT = "waterfront"
    TERRACE = "terrace"
    ENTRANCE = "entrance"


@dataclass
class EntranceSpec:
    side: str  # "north", "south", "east", "west"
    position: Optional[int] = None  # Coordinate along the side; None = centered/auto
    width: int = 4
    target_map_id: Optional[str] = None


@dataclass
class TownSpec:
    name: str = "starter_village"
    display_name: str = "Starter Village"
    biome: BiomeType = BiomeType.GRASSLAND
    season: SeasonType = SeasonType.SPRING
    seed: int = 184729
    width: int = 64
    height: int = 48
    elevation_levels: int = 2
    reference_style: Optional[str] = None  # "metano", "grasstown", "novel"
    entrances: List[EntranceSpec] = field(default_factory=lambda: [EntranceSpec(side="south", width=4)])
    exits: List[EntranceSpec] = field(default_factory=lambda: [EntranceSpec(side="north", width=4)])
    has_river: bool = False
    river_side: str = "east"  # "east", "west", "center"
    districts: List[str] = field(default_factory=lambda: ["plaza", "residential", "commercial", "nature"])
    structures: Dict[str, int] = field(default_factory=lambda: {
        "pokemon_center": 1,
        "shop": 1,
        "house_small": 4,
        "house_medium": 2,
        "fountain": 1,
        "well": 1,
    })
    locked_elements: Dict[str, Any] = field(default_factory=dict)
    tree_density: float = 0.20
    prop_density: float = 0.15

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> TownSpec:
        d = dict(data)
        if "biome" in d and isinstance(d["biome"], str):
            d["biome"] = BiomeType(d["biome"].lower())
        if "season" in d and isinstance(d["season"], str):
            d["season"] = SeasonType(d["season"].lower())
        if "entrances" in d:
            d["entrances"] = [EntranceSpec(**e) if isinstance(e, dict) else e for e in d["entrances"]]
        if "exits" in d:
            d["exits"] = [EntranceSpec(**e) if isinstance(e, dict) else e for e in d["exits"]]
        return cls(**d)


@dataclass
class StairConnection:
    id: str
    from_level: int
    to_level: int
    x: int
    y: int
    width: int = 2
    length: int = 3
    orientation: str = "north"  # Direction climbing: "north", "south", "east", "west"
    walkable_bounds: Tuple[int, int, int, int] = (0, 0, 0, 0)  # x0, y0, x1, y1


@dataclass
class RoadNode:
    id: str
    x: int
    y: int
    elevation: int
    node_type: str  # "entrance", "plaza_center", "district_hub", "stair_top", "stair_bottom", "intersection"


@dataclass
class RoadEdge:
    node_a: str
    node_b: str
    path_points: List[Tuple[int, int]]
    hierarchy: RoadHierarchy = RoadHierarchy.SECONDARY_STREET
    width: int = 2


@dataclass
class District:
    id: str
    district_type: DistrictType
    center_x: int
    center_y: int
    radius: int
    elevation: int
    bounds: Tuple[int, int, int, int]  # x0, y0, x1, y1


@dataclass
class Parcel:
    id: str
    district_id: str
    bounds: Tuple[int, int, int, int]  # x, y, width, height
    elevation: int
    front_road_side: str  # "north", "south", "east", "west"
    road_connection_point: Tuple[int, int]
    door_target_pos: Tuple[int, int]
    clearance: int = 1
    assigned_structure_id: Optional[str] = None


@dataclass
class StructurePrefab:
    id: str
    role: str
    width: int
    height: int
    layers: Dict[str, List[List[Dict[str, Any]]]]  # LayerType -> 2D grid of tile refs or RGBA pixel stamps
    collision: List[List[int]]  # 2D grid: 0 walkable, 1 blocked
    door_pos: Tuple[int, int]  # Relative (x, y) of doorway
    door_warp_target: str
    allowed_biomes: List[BiomeType] = field(default_factory=lambda: list(BiomeType))
    allowed_seasons: List[SeasonType] = field(default_factory=lambda: list(SeasonType))
    allowed_elevations: List[int] = field(default_factory=lambda: [0, 1, 2])
    clearance_margin: int = 1


@dataclass
class PlacedStructure:
    instance_id: str
    prefab_id: str
    role: str
    x: int
    y: int
    width: int
    height: int
    elevation: int
    door_map_pos: Tuple[int, int]
    door_warp_target: str
    parcel_id: str


@dataclass
class PlacedVegetation:
    id: str
    veg_type: str  # "tree_large", "tree_small", "bush", "flower_cluster"
    x: int
    y: int
    width: int
    height: int
    elevation: int
    trunk_bounds: Tuple[int, int, int, int]  # x, y, w, h
    canopy_bounds: Tuple[int, int, int, int]


@dataclass
class PlacedDecoration:
    id: str
    prop_type: str  # "signpost", "lamppost", "bench", "fence", "mailbox", "barrel"
    x: int
    y: int
    width: int
    height: int
    elevation: int
    collision_type: TileCollision = TileCollision.BLOCKED
    text_lines: Optional[List[str]] = None


@dataclass
class ValidationScore:
    geometry: float = 100.0
    connectivity: float = 100.0
    collision: float = 100.0
    elevation: float = 100.0
    cliffs: float = 100.0
    stairs: float = 100.0
    road_network: float = 100.0
    parcel_quality: float = 100.0
    building_placement: float = 100.0
    vegetation: float = 100.0
    visual_composition: float = 100.0

    @property
    def total_score(self) -> float:
        weights = {
            "geometry": 0.10,
            "connectivity": 0.20,
            "collision": 0.15,
            "elevation": 0.10,
            "cliffs": 0.05,
            "stairs": 0.10,
            "road_network": 0.10,
            "parcel_quality": 0.05,
            "building_placement": 0.05,
            "vegetation": 0.05,
            "visual_composition": 0.05,
        }
        score = sum(getattr(self, k) * w for k, w in weights.items())
        return round(score, 1)

    @property
    def status(self) -> str:
        if self.connectivity < 95.0 or self.collision < 95.0 or self.stairs < 95.0:
            return "FAIL"
        if self.total_score >= 90.0:
            return "PASS"
        if self.total_score >= 75.0:
            return "REVIEW"
        return "FAIL"


@dataclass
class ValidationReport:
    status: str
    score: ValidationScore
    reachable_objectives: int
    total_objectives: int
    stair_connections_valid: bool
    building_overlap_count: int
    unreachable_nodes: List[str] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)
    errors: List[str] = field(default_factory=list)


@dataclass
class TownLayout:
    spec: TownSpec
    width: int
    height: int
    heightmap: List[List[int]]  # 2D [width][height] elevation (0, 1, 2)
    terrain_types: List[List[str]]  # "grass", "dirt", "water", "cliff", "stair"
    cliff_mask: List[List[int]]  # 0 or 1
    water_mask: List[List[int]]  # 0 or 1
    road_mask: List[List[int]]  # 0, 1, 2 (hierarchy level)
    stairs: List[StairConnection] = field(default_factory=list)
    districts: List[District] = field(default_factory=list)
    parcels: List[Parcel] = field(default_factory=list)
    buildings: List[PlacedStructure] = field(default_factory=list)
    vegetation: List[PlacedVegetation] = field(default_factory=list)
    decorations: List[PlacedDecoration] = field(default_factory=list)
    collision: List[List[int]] = field(default_factory=list)  # TileCollision values
    validation: Optional[ValidationReport] = None
    visual_score: Optional[Any] = None
    composite_score: float = 100.0
    manifest: Optional[Dict[str, Any]] = None

    def get_elevation(self, x: int, y: int) -> int:
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.heightmap[x][y]
        return 0

    def is_walkable(self, x: int, y: int) -> bool:
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.collision[x][y] == TileCollision.WALKABLE.value or self.collision[x][y] == TileCollision.WARP.value
        return False
