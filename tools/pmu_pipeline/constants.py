"""PMU pipeline constants and specifications."""
from __future__ import annotations

PMU_TILE_SIZE = 32
PMDO_SUBTILE_SIZE = 8
SUBTILES_PER_PMU_TILE = 4  # 32 / 8 = 4 (4x4 = 16 sub-cells)
ANIMATION_HALF_PERIOD_MS = 250
ANIMATION_PERIOD_MS = 500
PMDO_ANIMATION_FRAME_LENGTH = 15  # 15 ticks at 60Hz = 250ms

TILE_TYPES: dict[int, str] = {
    0: "Walkable",
    1: "Blocked",
    2: "Warp",
    3: "Item",
    4: "NPCAvoid",
    5: "Key",
    6: "KeyOpen",
    7: "Heal",
    8: "Kill",
    9: "Shop",
    10: "MobileBlock",
    11: "Arena",
    12: "Sound",
    13: "SpriteChange",
    14: "Sign",
    15: "Door",
    16: "Notice",
    17: "Chest",
    18: "LinkShop",
    19: "Scripted",
    20: "NpcSpawn",
    21: "House",
    22: "Bank",
    23: "Guild",
    24: "SpriteBlock",
    25: "LevelBlock",
    26: "Assembly",
    27: "Evolution",
    28: "Story",
    29: "MissionBoard",
    30: "RDungeonGoal",
    31: "ScriptedSign",
    32: "SpeciesChange",
    33: "Hallway",
    34: "HouseRoomWarp",
    35: "HouseOwnerBlock",
    36: "Ambiguous",
    37: "Slippery",
    38: "Slow",
    39: "DropShop",
}

DEFINITE_BLOCK_TYPES: set[int] = {1, 14, 31}  # Blocked, Sign, ScriptedSign
CONDITIONAL_BLOCK_TYPES: set[int] = {10, 24, 25, 35}  # MobileBlock, SpriteBlock, LevelBlock, HouseOwnerBlock
WALKABLE_INTERACTIVE_TYPES: set[int] = {
    0, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 26, 27, 28, 29, 30, 32, 33, 34, 36, 37, 38, 39,
}

WEATHER: dict[int, str] = {
    0: "Ambiguous",
    1: "None",
    2: "Raining",
    3: "Snowing",
    4: "Thunder",
    5: "Hail",
    6: "DiamondDust",
    7: "Cloudy",
    8: "Fog",
    9: "Sunny",
    10: "Sandstorm",
    11: "Snowstorm",
    12: "Ashfall",
}

MAP_MORAL: dict[int, str] = {
    0: "None",
    1: "Safe",
    2: "NoPenalty",
    3: "House",
}

DIRECTIONS: dict[int, str] = {
    0: "Up",
    1: "Down",
    2: "Left",
    3: "Right",
    4: "UpRight",
    5: "DownLeft",
    6: "UpLeft",
    7: "DownRight",
}

NPC_BEHAVIOR: dict[int, str] = {
    0: "AttackOnSight",
    1: "AttackWhenAttacked",
    2: "Friendly",
    3: "Shopkeeper",
    4: "Guard",
    5: "Scripted",
    6: "FullyScriptedAI",
    7: "FleeOnSight",
}

TILE_FIELDS = (
    "ground", "ground_anim", "mask", "mask_anim", "mask2", "mask2_anim",
    "fringe", "fringe_anim", "fringe2", "fringe2_anim", "type", "data1",
    "data2", "data3", "string1", "string2", "string3", "light",
    "ground_tileset", "ground_anim_tileset", "mask_tileset", "mask_anim_tileset",
    "mask2_tileset", "mask2_anim_tileset", "fringe_tileset",
    "fringe_anim_tileset", "fringe2_tileset", "fringe2_anim_tileset",
)

LAYER_PAIRS = (
    ("ground", "ground_tileset", "ground_anim", "ground_anim_tileset"),
    ("mask", "mask_tileset", "mask_anim", "mask_anim_tileset"),
    ("mask2", "mask2_tileset", "mask2_anim", "mask2_anim_tileset"),
    ("fringe", "fringe_tileset", "fringe_anim", "fringe_anim_tileset"),
    ("fringe2", "fringe2_tileset", "fringe2_anim", "fringe2_anim_tileset"),
)

LAYER_NAMES = ("Ground", "Mask", "Mask2", "Fringe", "Fringe2")
