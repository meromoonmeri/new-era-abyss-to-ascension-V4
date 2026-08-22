#!/usr/bin/env python3
"""Build the single canonical dungeon deliverable selected for Ch. 6–32.

The bundle merges:

* the 27 main-route entries in ``MASTER_TIMELINE_CH5_CH32.json``; and
* the 51 PMD Red entries in ``ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md``.

Duplicate places are represented once as shared canonical zones (Sinister
Woods, Magma Cavern, Sky Tower) instead of quietly creating two incompatible
copies.  Every generated exploration floor is a native RogueElements
``ChanceFloorGen`` with three different topology families and contains no
serialized production seed.

The registry is generated once from a pinned pret/pmd-red checkout and checked
in, so normal ``--write`` use never depends on a ROM/source checkout.

Usage:
    python3 tools/build_complete_canonical_bundle.py --source /path/to/pmd-red --write-registry --write --check
    python3 tools/build_complete_canonical_bundle.py --write --check
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import re
import shutil
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Iterable

ROOT = Path(__file__).resolve().parents[1]
REGISTRY_PATH = ROOT / "docs/canonical_dungeons/complete_bundle_registry.json"
TIMELINE_PATH = ROOT / "docs/canonical/MASTER_TIMELINE_CH5_CH32.json"
ROSTER_PATH = ROOT / "docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md"
DB_PATH = ROOT / "tools/mapgen/data/tilesets_donjons.json"
VERSION = "0.8.12.0"

# PMDO's base game already ships these AutoTile triplets.  The DTEF source
# folder is registered next to every biome in the registry; no handmade
# transition sheet is produced by this tool.
BIOMES: dict[str, dict[str, str]] = {
    "forest": {"folder": "TreeshroudForest1", "floor": "treeshroud_forest_1_floor"},
    "tiny": {"folder": "TinyWoods", "floor": "tiny_meadow_floor"},
    "electric": {"folder": "MtThunder", "floor": "mt_thunder_floor"},
    "chasm": {"folder": "ChasmCave1", "floor": "chasm_cave_1_floor"},
    "cave": {"folder": "LapisCave", "floor": "lapis_cave_floor"},
    "mountain": {"folder": "MtSteel1", "floor": "mt_thunder_floor"},
    "fire": {"folder": "MtBlaze", "floor": "mt_blaze_floor"},
    "ice": {"folder": "FrostyForest", "floor": "frosty_forest_floor"},
    "magma": {"folder": "MagmaCavern2", "floor": "magma_cavern_2_floor"},
    "water": {"folder": "StormySea1", "floor": "stormy_sea_1_floor"},
    "deep_water": {"folder": "SilverTrench3Floor", "floor": "silver_trench_3_floor"},
    "ruins": {"folder": "BuriedRelic1", "floor": "buried_relic_1_floor"},
    "desert": {"folder": "DesertRegion", "floor": "desert_region_floor"},
    "dragon": {"folder": "WyvernHill", "floor": "wyvern_hill_floor"},
    "dark": {"folder": "DarknightRelic", "floor": "darknight_relic_floor"},
    "sky": {"folder": "SkyTower", "floor": "sky_tower_floor"},
    "purity": {"folder": "PurityForest2", "floor": "purity_forest_2_floor"},
    "crystal": {"folder": "CrystalCave1", "floor": "crystal_cave_1_floor"},
    "amp": {"folder": "AmpPlains", "floor": "amp_plains_floor"},
    "quicksand": {"folder": "QuicksandCave", "floor": "quicksand_cave_floor"},
    "brine": {"folder": "BrineCave", "floor": "brine_cave_floor"},
    "temporal": {"folder": "TemporalTower", "floor": "temporal_tower_floor"},
    "space": {"folder": "SpacialRift1", "floor": "spacial_rift_1_floor"},
    "crater": {"folder": "DarkCrater", "floor": "deep_dark_crater_floor"},
    "waterfall": {"folder": "WaterfallPond", "floor": "waterfall_pond_floor"},
    "joy": {"folder": "JoyousTower", "floor": "joyous_tower_floor"},
    "howling": {"folder": "HowlingForest1", "floor": "howling_forest_1_floor"},
}

# Explicit lore/theme pools for main-route places that do not have a matching
# PMD Red data directory.  These are used only for the New Era/EoS route; PMD
# Red roster entries always come from normalized pret tables below.
THEME_POOLS: dict[str, list[str]] = {
    "forest": ["oddish", "shroomish", "sentret", "ledyba", "paras", "hoothoot", "scyther", "slakoth", "exeggutor", "tropius", "yanma", "poochyena"],
    "tiny": ["pidgey", "sunkern", "wurmple", "caterpie", "weedle", "sentret", "zigzagoon", "oddish", "seedot", "taillow"],
    "electric": ["pikachu", "electrike", "magnemite", "mareep", "voltorb", "plusle", "minun", "luxio", "jolteon", "ampharos"],
    "chasm": ["zubat", "geodude", "machop", "aron", "sandshrew", "onix", "nosepass", "larvitar", "gible", "gligar"],
    "cave": ["zubat", "paras", "geodude", "sableye", "lunatone", "solrock", "mawile", "meditite", "bagon", "drilbur"],
    "mountain": ["geodude", "machop", "aron", "onix", "nosepass", "meditite", "skarmory", "vibrava", "swablu", "absol"],
    "fire": ["vulpix", "growlithe", "numel", "torkoal", "slugma", "magmar", "houndour", "camerupt", "magcargo", "charmeleon"],
    "ice": ["swinub", "snorunt", "spheal", "sneasel", "delibird", "sealeo", "glalie", "snover", "abomasnow", "froslass"],
    "magma": ["sandshrew", "raticate", "nidoqueen", "nidoking", "torkoal", "numel", "camerupt", "magcargo", "houndour", "charmeleon"],
    "water": ["tentacool", "shellder", "omanyte", "wingull", "chinchou", "staryu", "carvanha", "wailmer", "lapras", "lanturn"],
    "deep_water": ["chinchou", "lanturn", "relicanth", "cloyster", "mantine", "sharpedo", "walrein", "milotic", "kingdra", "wailord"],
    "ruins": ["unown", "baltoy", "claydol", "bronzor", "bronzong", "sableye", "shuppet", "duskull", "nosepass", "golem"],
    "desert": ["sandshrew", "trapinch", "cacnea", "baltoy", "hippopotas", "numel", "vibrava", "cacturne", "claydol", "flygon"],
    "dragon": ["bagon", "swablu", "vibrava", "dratini", "gabite", "shelgon", "altaria", "dragonair", "salamence", "flygon"],
    "dark": ["zubat", "murkrow", "poochyena", "shuppet", "duskull", "sableye", "misdreavus", "absol", "honchkrow", "dusknoir"],
    "sky": ["pidgeotto", "swellow", "skarmory", "swablu", "altaria", "tropius", "aerodactyl", "salamence", "dragonair", "noivern"],
    "purity": ["celebi", "sentret", "oddish", "sunkern", "skiploom", "aipom", "yanma", "shuckle", "heracross", "tropius"],
    "crystal": ["sableye", "mawile", "nosepass", "lunatone", "solrock", "carbink", "diancie", "froslass", "glaceon", "cradily"],
    "amp": ["electrike", "mareep", "magnemite", "luxio", "raichu", "ampharos", "manectric", "magnezone", "electabuzz", "raikou"],
    "quicksand": ["sandshrew", "trapinch", "cacnea", "hippopotas", "gligar", "vibrava", "cacturne", "claydol", "flygon", "hippowdon"],
    "brine": ["corphish", "carvanha", "chinchou", "tentacool", "shellos", "staryu", "wailmer", "sharpedo", "lanturn", "kingdra"],
    "temporal": ["porygon", "bronzor", "beldum", "klink", "magnemite", "metang", "bronzong", "magnezone", "porygon2", "dialga"],
    "space": ["ralts", "lunatone", "solrock", "baltoy", "bronzor", "kirlia", "claydol", "gallade", "gardevoir", "palkia"],
    "crater": ["houndour", "murkrow", "shuppet", "duskull", "sableye", "absol", "weavile", "dusknoir", "darkrai", "tyranitar"],
    "waterfall": ["psyduck", "wooper", "poliwag", "goldeen", "marill", "azumarill", "gyarados", "ludicolo", "milotic", "manaphy"],
    "joy": ["sentret", "hoppip", "swinub", "skarmory", "miltank", "aipom", "yanma", "porygon", "chansey", "blissey"],
    "howling": ["poochyena", "houndour", "murkrow", "zubat", "shuppet", "absol", "mightyena", "houndoom", "honchkrow", "zoroark"],
}

MUSIC_BY_BIOME = {
    "forest": "Mystifying Forest.ogg", "tiny": "Apple Woods.ogg", "electric": "Mt. Thunder.ogg",
    "chasm": "Chasm Cave.ogg", "cave": "Lapis Cave.ogg", "mountain": "Mt. Horn.ogg",
    "fire": "Mt. Blaze.ogg", "ice": "Frosty Forest.ogg", "magma": "Magma Cavern.ogg",
    "water": "Water Cave.ogg", "deep_water": "Brine Cave.ogg", "ruins": "Relic Tower.ogg",
    "desert": "Northern Desert.ogg", "dragon": "Mt. Horn.ogg", "dark": "Dark Hill.ogg",
    "sky": "Sky Tower.ogg", "purity": "Healing Forest.ogg", "crystal": "Crystal Cave.ogg",
    "amp": "Amp Plains.ogg", "quicksand": "Quicksand Cave.ogg", "brine": "Brine Cave.ogg",
    "temporal": "Temporal Tower.ogg", "space": "Star Cave.ogg", "crater": "Dark Crater.ogg",
    "waterfall": "Waterfall Cave.ogg", "joy": "Healing Forest.ogg", "howling": "Dark Hill.ogg",
}

# The deep binding always reuses a RawAsset folder already mirrored by this
# bundle. It gives long routes a readable base -> intermediate atmosphere ->
# final-biome progression without inventing a new hand-painted tileset.
DEEP_BIOME = {
    "forest": "dark", "tiny": "forest", "electric": "dark", "chasm": "cave", "cave": "ruins",
    "mountain": "dark", "fire": "magma", "ice": "dark", "magma": "crater", "water": "deep_water",
    "deep_water": "dark", "ruins": "dark", "desert": "ruins", "dragon": "sky", "dark": "crater",
    "sky": "temporal", "purity": "forest", "crystal": "ruins", "amp": "electric", "quicksand": "desert",
    "brine": "deep_water", "temporal": "space", "space": "crater", "crater": "dark", "waterfall": "water",
    "joy": "purity", "howling": "dark",
}

ITEM_CONVERSION = {
    "ITEM_APPLE": "food_apple", "ITEM_BIG_APPLE": "food_apple_big", "ITEM_HUGE_APPLE": "food_apple_huge",
    "ITEM_ORAN_BERRY": "berry_oran", "ITEM_CHERI_BERRY": "berry_cheri", "ITEM_PECHA_BERRY": "berry_pecha",
    "ITEM_RAWST_BERRY": "berry_rawst", "ITEM_CHESTO_BERRY": "berry_chesto", "ITEM_ASPEAR_BERRY": "berry_aspear",
    "ITEM_REVIVER_SEED": "seed_reviver", "ITEM_BLAST_SEED": "seed_blast", "ITEM_SLEEP_SEED": "seed_sleep",
    "ITEM_WARP_SEED": "seed_warp", "ITEM_HUNGER_SEED": "seed_hunger", "ITEM_MAX_ELIXIR": "medicine_max_elixir",
    "ITEM_ELIXIR": "medicine_elixir", "ITEM_ESCAPE_ORB": "orb_escape", "ITEM_LUMINOUS_ORB": "orb_luminous",
    "ITEM_SCANNER_ORB": "orb_scanner", "ITEM_PETRIFY_ORB": "orb_petrify", "ITEM_WARP_ORB": "orb_stayaway",
    "ITEM_BLOWBACK_ORB": "orb_spurn", "ITEM_HURL_ORB": "orb_spurn", "ITEM_RADAR_ORB": "orb_scanner",
    "ITEM_ROLLCALL_ORB": "orb_rollcall", "ITEM_SLOW_ORB": "orb_slow", "ITEM_SLUMBER_ORB": "orb_slumber",
    "ITEM_TOTTER_ORB": "orb_totter", "ITEM_TRAPBUST_ORB": "orb_trapbust", "ITEM_TRAP_SEE_ORB": "orb_trap_see",
    "ITEM_CLEANSE_ORB": "orb_cleanse", "ITEM_NULLIFY_ORB": "orb_nullify", "ITEM_WHITE_GUMMI": "gummi_white",
    "ITEM_BLUE_GUMMI": "gummi_blue", "ITEM_BROWN_GUMMI": "gummi_brown", "ITEM_CLEAR_GUMMI": "gummi_clear",
    "ITEM_GOLD_GUMMI": "gummi_gold", "ITEM_GRASS_GUMMI": "gummi_grass", "ITEM_GREEN_GUMMI": "gummi_green",
    "ITEM_ORANGE_GUMMI": "gummi_orange", "ITEM_PINK_GUMMI": "gummi_pink", "ITEM_SKY_GUMMI": "gummi_sky",
    "ITEM_YELLOW_GUMMI": "gummi_yellow",
}

BOSS_ALIASES = {
    "Regis": ["regirock", "regice", "registeel"],
    "Team Meanies": ["gengar", "ekans", "medicham"],
}

MAIN_META: dict[int, dict[str, Any]] = {
    7: {"biome": "magma", "floors": 26, "sources": ["MagmaCavern", "MagmaCavernPit"], "boss": ["groudon"]},
    8: {"biome": "crystal", "floors": 25, "boss": ["diancie"]},
    9: {"biome": "water", "floors": 40, "boss": ["kyogre"]},
    10: {"biome": "sky", "floors": 34, "sources": ["SkyTower", "SkyTowerSummit"], "boss": ["rayquaza"]},
    11: {"biome": "forest", "floors": 20, "boss": []},
    12: {"biome": "waterfall", "floors": 19, "boss": []},
    13: {"biome": "waterfall", "floors": 8, "boss": []},
    14: {"biome": "crystal", "floors": 20, "boss": ["uxie"]},
    15: {"biome": "amp", "floors": 15, "boss": []},
    16: {"biome": "quicksand", "floors": 15, "boss": ["mesprit"]},
    17: {"biome": "crystal", "floors": 17, "boss": ["azelf"]},
    18: {"biome": "brine", "floors": 24, "boss": []},
    19: {"biome": "temporal", "floors": 24, "boss": ["dialga"]},
    20: {"biome": "forest", "floors": 20, "boss": []},
    21: {"biome": "ice", "floors": 16, "boss": ["froslass"]},
    22: {"biome": "water", "floors": 24, "boss": []},
    23: {"biome": "crater", "floors": 20, "boss": ["darkrai"]},
    24: {"biome": "sky", "floors": 20, "boss": ["shaymin"]},
    25: {"biome": "space", "floors": 25, "boss": ["palkia"]},
    26: {"biome": "dark", "floors": 30, "boss": ["giratina"]},
    27: {"biome": "joy", "floors": 99, "boss": []},
    28: {"biome": "sky", "floors": 99, "boss": ["arceus"]},
    29: {"biome": "temporal", "floors": 40, "boss": ["yveltal"]},
    30: {"biome": "sky", "floors": 40, "boss": ["zygarde"]},
    31: {"biome": "sky", "floors": 45, "boss": ["necrozma"]},
    32: {"biome": "temporal", "floors": 60, "boss": ["necrozma", "eternatus", "arceus"]},
}


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def save_json(path: Path, value: Any, *, bom: bool = True) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(("\ufeff" if bom else "") + json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def priority(*parts: int) -> dict[str, list[int]]:
    return {"str": list(parts)}


def loc(x: int, y: int) -> dict[str, int]:
    return {"X": x, "Y": y}


def autotile(name: str, associates: list[str] | None = None, code: int = -1) -> dict[str, Any]:
    return {"AutoTileset": name, "Associates": associates or [], "Layers": [], "NeighborCode": code}


def normalized(text: str) -> str:
    return re.sub(r"[^a-z0-9]", "", text.lower().replace("é", "e").replace("è", "e").replace("ô", "o"))


def snake(text: str) -> str:
    value = re.sub(r"[^a-z0-9]+", "_", text.lower().replace("'", "").replace(".", ""))
    return value.strip("_")


def dtef_binding(biome: str) -> dict[str, str]:
    db = load_json(DB_PATH)["tilesets"]
    row = BIOMES[biome]
    floor = row["floor"]
    if floor not in db:
        raise ValueError(f"runtime AutoTile {floor} is missing from tools/mapgen DB")
    return {
        "biome": biome,
        "rawasset_folder": row["folder"],
        "runtime_floor": floor,
        "runtime_wall": db[floor]["wall"],
        "runtime_secondary": db[floor]["water_wall"],
    }


def progressive_binding(entry: dict[str, Any], segment_index: int, segment_count: int) -> dict[str, str]:
    """Return a progressively deeper DTEF family for later 10-floor segments."""
    if segment_index == 0 or segment_count <= 1:
        return entry["dtef"]
    return dtef_binding(DEEP_BIOME[entry["biome"]])


def source_directory_lookup() -> dict[str, str]:
    source = load_json(ROOT / "docs/canonical/red/dungeon_floor_reference.json")
    lookup: dict[str, str] = {}
    for row in source["dungeons"]:
        directory = row.get("source_directory")
        if directory:
            lookup[normalized(directory)] = directory
    return lookup


def parse_roster() -> list[dict[str, Any]]:
    lookup = source_directory_lookup()
    rows: list[dict[str, Any]] = []
    for line in ROSTER_PATH.read_text(encoding="utf-8").splitlines():
        if not re.match(r"^\|\s*\d+\s*\|", line):
            continue
        fields = [field.strip() for field in line.split("|")[1:-1]]
        if len(fields) != 8:
            continue
        number, name, floors, boss, _asset, _tier, chapter, fr_name = fields
        try:
            roster_number, floor_count = int(number), int(floors)
        except ValueError:
            continue
        chapter_match = re.search(r"(\d+)", chapter)
        if not chapter_match:
            continue
        source_dir = lookup.get(normalized(name))
        if source_dir is None:
            raise ValueError(f"No pret source directory matches roster name {name!r}")
        clean_boss = re.sub(r"[*_`]+", "", boss).strip()
        boss_species = [] if clean_boss in {"—", "-", ""} else BOSS_ALIASES.get(clean_boss, [snake(clean_boss)])
        rows.append(
            {
                "roster_number": roster_number,
                "source_name": name,
                "source_directory": source_dir,
                "canonical_floor_count": floor_count,
                "boss_label": clean_boss,
                "boss_species": boss_species,
                "chapter": int(chapter_match.group(1)),
                "public_name": name,
                "french_name": re.sub(r"[*_`]+", "", fr_name).strip(),
            }
        )
    if len(rows) != 51:
        raise ValueError(f"Expected 51 PMD Red roster rows, got {len(rows)}")
    return rows


def choose_biome(name: str) -> str:
    value = normalized(name)
    if any(token in value for token in ("stormysea", "grandsea", "marveloussea", "fantasy", "faroffsea", "waterfall", "pond")):
        return "water"
    if any(token in value for token in ("silvertrench",)):
        return "deep_water"
    if any(token in value for token in ("blaze", "fiery", "magma")):
        return "fire" if "blaze" in value else "magma"
    if any(token in value for token in ("frost", "freeze", "snow", "northwind")):
        return "ice"
    if any(token in value for token in ("thunder", "lightning")):
        return "electric"
    if any(token in value for token in ("desert", "quicksand")):
        return "desert"
    if any(token in value for token in ("sky", "tower", "faraway")):
        return "sky"
    if any(token in value for token in ("buried", "unown", "darknight", "relic")):
        return "ruins" if "darknight" not in value else "dark"
    if any(token in value for token in ("dark", "murky", "oddity")):
        return "dark"
    if any(token in value for token in ("wyvern",)):
        return "dragon"
    if any(token in value for token in ("joyous", "purity")):
        return "purity"
    if any(token in value for token in ("cave", "cavern", "chasm", "path", "canyon")):
        return "cave"
    return "forest"


def canonical_species(value: str) -> str:
    species = value.removeprefix("MONSTER_").lower()
    # PMD Red encodes form suffixes in the species enum; PMDO stores those
    # under the same base species plus a Form value. The generic bundle keeps
    # form 0 rather than emitting non-existent IDs such as `unown_c`.
    if species.startswith("unown_"):
        return "unown"
    if species.startswith("deoxys_"):
        return "deoxys"
    fixes = {"mr_mime": "mr_mime", "nidoran_f": "nidoran_f", "nidoran_m": "nidoran_m", "farfetchd": "farfetchd"}
    return fixes.get(species, species)


def extract_source_data(source_root: Path, source_dir: str, floor_count: int) -> dict[str, Any]:
    folder = source_root / "data/dungeon" / source_dir
    floor_ids = load_json(folder / "floor_id.json")["tables"]
    pokemon_tables = load_json(folder / "pokemon_found.json")["tables"]
    item_tables = load_json(source_root / "data/dungeon/dungeon_item_data.json")
    floors: list[list[dict[str, Any]]] = []
    items_per_floor: list[list[str]] = []
    has_shop = False
    has_house = False
    traps = False
    for floor_id in floor_ids[:floor_count]:
        table_index = int(floor_id["Pokemon"])
        if table_index >= len(pokemon_tables):
            table_index = len(pokemon_tables) - 1
        entries = []
        for monster in pokemon_tables[table_index]["pokemon"]:
            if monster.get("probability", 0) <= 0:
                continue
            species = canonical_species(monster["species"])
            if species in {"kecleon", "decoy"}:
                continue
            entries.append({"species": species, "level": int(monster["level"]), "weight": int(monster["probability"])})
        floors.append(entries)

        item_index = int(floor_id.get("Items", 0))
        if 0 <= item_index < len(item_tables):
            candidate: list[tuple[int, str]] = []
            for category in item_tables[item_index].get("categories", []):
                for item in category.get("items", []):
                    converted = ITEM_CONVERSION.get(item["item"])
                    if converted:
                        candidate.append((int(item.get("itemProbability", 1)), converted))
            candidate.sort(reverse=True)
            unique: list[str] = []
            for _, item in candidate:
                if item not in unique:
                    unique.append(item)
                if len(unique) >= 12:
                    break
            items_per_floor.append(unique)
        else:
            items_per_floor.append([])
        has_shop |= int(floor_id.get("KecleonShop", 1)) not in {0, 1}
        has_house |= int(floor_id.get("MonsterRoomItems", 2)) not in {0, 2}
        traps |= int(floor_id.get("Traps", 0)) not in {0}

    # Some source folders include a separate peak/pit.  The registry controls
    # its canonical count; repeat the final authenticated table only when the
    # composed main route intentionally includes that linked location.
    while len(floors) < floor_count:
        floors.append(copy.deepcopy(floors[-1] if floors else []))
        items_per_floor.append(copy.deepcopy(items_per_floor[-1] if items_per_floor else []))
    return {
        "floor_spawns": floors[:floor_count],
        "floor_items": items_per_floor[:floor_count],
        "mechanics": {"kecleon": has_shop, "monster_house": has_house, "traps": traps},
    }


def combine_source_data(source_root: Path, source_dirs: list[str], floor_count: int) -> dict[str, Any]:
    """Concatenate linked canonical locations (for example cave -> peak)."""
    floor_spawns: list[list[dict[str, Any]]] = []
    floor_items: list[list[str]] = []
    mechanics = {"kecleon": False, "monster_house": False, "traps": False}
    for directory in source_dirs:
        native_count = len(load_json(source_root / "data/dungeon" / directory / "floor_id.json")["tables"])
        extracted = extract_source_data(source_root, directory, native_count)
        floor_spawns.extend(extracted["floor_spawns"])
        floor_items.extend(extracted["floor_items"])
        for key, value in extracted["mechanics"].items():
            mechanics[key] |= bool(value)
    while len(floor_spawns) < floor_count:
        floor_spawns.append(copy.deepcopy(floor_spawns[-1]))
        floor_items.append(copy.deepcopy(floor_items[-1]))
    return {"floor_spawns": floor_spawns[:floor_count], "floor_items": floor_items[:floor_count], "mechanics": mechanics}


def generic_source_data(biome: str, floor_count: int, chapter: int) -> dict[str, Any]:
    pool = THEME_POOLS[biome]
    base_level = min(86, max(4, 3 + chapter * 3))
    floors: list[list[dict[str, Any]]] = []
    items: list[list[str]] = []
    for floor in range(floor_count):
        start = (floor * 3) % len(pool)
        species = [pool[(start + index) % len(pool)] for index in range(min(12, len(pool)))]
        floors.append(
            [
                {"species": mon, "level": min(100, base_level + floor // 10 + index // 5), "weight": 120 - index * 7}
                for index, mon in enumerate(species)
            ]
        )
        items.append(["food_apple", "berry_oran", "berry_pecha", "seed_reviver", "medicine_max_elixir", "orb_escape"])
    return {"floor_spawns": floors, "floor_items": items, "mechanics": {"kecleon": floor_count >= 20, "monster_house": floor_count >= 25, "traps": floor_count >= 15}}


def main_french_name(title: str) -> str:
    names = {
        "Magma Cavern": "Grotte Magma", "Crystal Sanctuary": "Sanctuaire de Cristal", "Bottomless Sea": "Mer Sans Fond",
        "Sky Tower": "Tour Céleste", "Those Accused": "Les Accusés", "A New Guild Road": "Nouvelle Route de Guilde",
        "Waterfall Cave": "Grotte Cascade", "Fogbound Lake": "Lac Brumeux", "Amp Plains": "Plaines Ampère",
        "Quicksand Cave": "Grotte Sables Mouvants", "Crystal Crossing": "Passage Cristal", "Brine Cave and Hidden Land": "Grotte Saumâtre et Terre Cachée",
        "Temporal Tower Restored": "Tour du Temps Restaurée", "Graduation Legacy": "Héritage de la Remise de Diplôme",
        "Crevice Cave": "Grotte Fissure", "Miracle Sea": "Mer Miracle", "Dark Crater": "Cratère Obscur",
        "Sky Peak": "Pic Céleste", "Spacial Rift": "Faille Spatiale", "World Abyss": "Abîme du Monde",
        "Zero Isle Network": "Réseau Île Zéro", "Destiny Tower": "Tour du Destin", "Hidden Land Fracture": "Fracture de la Terre Cachée",
        "Sky Suspended": "Ciel Suspendu", "The Two Lights": "Les Deux Lumières", "Abyss to Ascension": "Des Abysses à l’Ascension",
    }
    return names.get(title, title)


def build_registry(source_root: Path) -> dict[str, Any]:
    roster = parse_roster()
    timeline = load_json(TIMELINE_PATH)["chapters"]
    red_records: list[dict[str, Any]] = []
    aliases = {"SinisterWoods": "gloomy_forest", "MagmaCavern": "magma_cavern", "MagmaCavernPit": "magma_cavern", "SkyTower": "sky_tower", "SkyTowerSummit": "sky_tower"}
    for row in roster:
        source_dir = row["source_directory"]
        biome = choose_biome(row["source_name"])
        binding = dtef_binding(biome)
        record = {
            "id": f"red_{snake(source_dir)}",
            "family": "pmd_red_roster",
            **row,
            "biome": biome,
            "music": MUSIC_BY_BIOME[biome],
            "dtef": binding,
            "bulbapedia": "https://bulbapedia.bulbagarden.net/wiki/" + row["source_name"].replace(" ", "_"),
            **extract_source_data(source_root, source_dir, row["canonical_floor_count"]),
        }
        if source_dir in aliases:
            record["alias_of"] = aliases[source_dir]
        red_records.append(record)

    main_records: list[dict[str, Any]] = []
    for row in timeline:
        chapter = int(row["chapter"])
        if chapter < 6:
            continue
        if chapter == 6:
            # Ch6 has a handcrafted canonical implementation in the prior
            # deliverable. Keep it in the unified registry without replacing it.
            main_records.append({"id": "gloomy_forest", "family": "main_route", "chapter": 6, "public_name": "Sinister Woods", "french_name": "Forêt Sinistre", "existing": True, "music": "Sinister Woods.ogg", "bulbapedia": "https://bulbapedia.bulbagarden.net/wiki/Sinister_Woods", "dtef": dtef_binding("forest")})
            continue
        meta = MAIN_META[chapter]
        biome = meta["biome"]
        source_dirs = meta.get("sources") or ([meta["source"]] if meta.get("source") else [])
        if source_dirs:
            data = combine_source_data(source_root, source_dirs, meta["floors"])
        else:
            data = generic_source_data(biome, meta["floors"], chapter)
        main_records.append(
            {
                "id": row["main"],
                "family": "main_route",
                "chapter": chapter,
                "public_name": row["title"],
                "french_name": main_french_name(row["title"]),
                "canonical_floor_count": meta["floors"],
                "boss_species": meta["boss"],
                "boss_label": row.get("boss") or "",
                "biome": biome,
                "music": MUSIC_BY_BIOME[biome],
                "dtef": dtef_binding(biome),
                "bulbapedia": "https://bulbapedia.bulbagarden.net/wiki/" + row["title"].replace(" ", "_"),
                "source_directory": source_dirs,
                **data,
            }
        )

    physical = [row for row in main_records + red_records if not row.get("alias_of") and not row.get("existing")]
    return {
        "schema": "new-era.complete-canonical-dungeon-bundle.v1",
        "scope": {"main_route_entries": len(main_records), "pmd_red_roster_entries": len(red_records), "shared_aliases": len([r for r in red_records if r.get("alias_of")]), "physical_generated_entries": len(physical), "existing_handcrafted_entries": 1},
        "sources": {
            "master_timeline": "docs/canonical/MASTER_TIMELINE_CH5_CH32.json",
            "pmd_red_roster": "docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md",
            "pmd_red_data": "pret/pmd-red data/dungeon",
            "bulbapedia_policy": "Each record retains its public Bulbapedia URL; runtime tables are adapted PMDO weights, never copied wiki tables.",
            "dtef": "PMDCollab/RawAsset/TileDtef",
        },
        "main_route": main_records,
        "pmd_red_roster": red_records,
    }


def neighbor_codes(cells: list[list[dict[str, Any]]]) -> None:
    width, height = len(cells), len(cells[0])
    cardinals = ((0, 1), (-1, 0), (0, -1), (1, 0))
    diagonals = ((-1, 1), (-1, -1), (1, -1), (1, 1))
    for x in range(width):
        for y in range(height):
            cell = cells[x][y]
            tile = cell.get("AutoTileset", "")
            if not tile:
                cell["NeighborCode"] = -1
                continue
            blocked = []
            for dx, dy in cardinals:
                nx, ny = x + dx, y + dy
                blocked.append(not (0 <= nx < width and 0 <= ny < height and cells[nx][ny].get("AutoTileset") == tile))
            code = sum((1 << idx) for idx, state in enumerate(blocked) if state)
            for idx, (dx, dy) in enumerate(diagonals):
                if blocked[idx] and blocked[(idx + 1) % 4]:
                    nx, ny = x + dx, y + dy
                    if not (0 <= nx < width and 0 <= ny < height and cells[nx][ny].get("AutoTileset") == tile):
                        code |= 1 << (idx + 4)
            cell["NeighborCode"] = code


def material_grid(binding: dict[str, str], *, openings: set[tuple[int, int]] = set()) -> tuple[list[list[dict[str, Any]]], list[list[dict[str, Any]]]]:
    # Generic bundle Grounds deliberately use a compact native 8px grid.
    # Repeating a 57×57 collision matrix 216 times would add more than 120 MB
    # of duplicate JSON to the deliverable without improving gameplay.  The
    # 19×19 room still leaves a 15×15 walkable arena and all auto-tile edges
    # are calculated from topology rather than pre-painted.
    visual_w = visual_h = 19
    classes: list[list[str]] = [["floor" for _ in range(visual_h)] for _ in range(visual_w)]
    for x in range(visual_w):
        for y in range(visual_h):
            if x < 2 or y < 2 or x >= visual_w - 2 or y >= visual_h - 2:
                classes[x][y] = "wall"
    for x, y in openings:
        classes[x][y] = "floor"
    visuals = [[autotile(binding[f"runtime_{classes[x][y]}"]) for y in range(visual_h)] for x in range(visual_w)]
    neighbor_codes(visuals)
    obstacles: list[list[dict[str, Any]]] = []
    for x in range(visual_w):
        column = []
        for y in range(visual_h):
            material = classes[x][y]
            column.append({"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": 1 if material == "wall" else 0})
        obstacles.append(column)
    return visuals, obstacles


def copy_entity(template: dict[str, Any], collection: str, name: str) -> dict[str, Any]:
    for item in template["Entities"][0].get(collection, []):
        if item.get("EntName") == name or item.get("NPCName") == name:
            return copy.deepcopy(item)
    raise ValueError(f"template entity missing: {collection}/{name}")


def generic_ground(entry: dict[str, Any], role: str, binding: dict[str, str] | None = None) -> dict[str, Any]:
    template = load_json(ROOT / "Data/Ground/crooked_cavern_midpoint.rsground")["Object"]
    binding = binding or entry["dtef"]
    openings = {(9, 1), (9, 2), (9, 16), (9, 17)}
    visuals, obstacles = material_grid(binding, openings=openings)
    slug = entry["id"]
    asset = f"{slug}_{role}"
    layer = {"Name": "DTEF Base", "Layer": 0, "Visible": True, "Tiles": visuals}
    obj = copy.deepcopy(template)
    obj.update(
        {
            "Name": {"DefaultText": f"{entry['public_name']} {role.title()}", "LocalTexts": {"fr": f"{entry['french_name']} { {'entrance':'Entrée','mid':'Relais','boss':'Final'}[role]}"}},
            "AssetName": asset,
            "Released": True,
            "Comment": f"Canonical bundle {entry['family']} / Ch{entry['chapter']}; fixed {role} Ground, DTEF topology only.",
            "Music": "Boss Battle!.ogg" if role == "boss" and entry.get("boss_species") else entry.get("music", "Mystifying Forest.ogg"),
            "TexSize": 1,
            "Layers": [layer],
            "obstacles": obstacles,
            "BlankBG": autotile(binding["runtime_wall"]),
        }
    )
    marker = copy_entity(template, "Markers", "Main_Entrance_Marker")
    marker["Collider"] = {"X": 64, "Y": 120, "Width": 16, "Height": 16}
    marker["EntName"] = "Main_Entrance_Marker"
    spawner = copy_entity(template, "Spawners", "TEAMMATE_1")
    spawner["Collider"] = {"X": 88, "Y": 120, "Width": 16, "Height": 16}
    entities = {"Name": "Canonical Entities", "Visible": True, "MapChars": [], "Markers": [marker], "Spawners": [spawner], "GroundObjects": []}
    if role == "mid":
        north = copy_entity(template, "GroundObjects", "North_Exit")
        south = copy_entity(template, "GroundObjects", "South_Exit")
        rock = copy_entity(template, "GroundObjects", "Kangaskhan_Rock")
        north["Collider"] = {"X": 64, "Y": 16, "Width": 24, "Height": 8}
        south["Collider"] = {"X": 64, "Y": 128, "Width": 24, "Height": 8}
        rock["Collider"] = {"X": 112, "Y": 64, "Width": 24, "Height": 24}
        entities["GroundObjects"] = [north, south, rock]
    elif role == "entrance":
        north = copy_entity(template, "GroundObjects", "North_Exit")
        south = copy_entity(template, "GroundObjects", "South_Exit")
        north["Collider"] = {"X": 64, "Y": 16, "Width": 24, "Height": 8}
        south["Collider"] = {"X": 64, "Y": 128, "Width": 24, "Height": 8}
        entities["GroundObjects"] = [north, south]
    obj["Entities"] = [entities]
    return obj


def boss_template_map(entry: dict[str, Any], binding: dict[str, str] | None = None) -> dict[str, Any]:
    template = load_json(ROOT / "Data/Map/chapter_3_boss_fight.rsmap")["Object"]
    binding = binding or entry["dtef"]
    obj = copy.deepcopy(template)
    obj.update({"Name": {"DefaultText": f"{entry['public_name']} {entry['canonical_floor_count']}", "LocalTexts": {"fr": f"{entry['french_name']} {entry['canonical_floor_count']}"}}, "AssetName": f"{entry['id']}_boss", "Released": True, "Music": "Boss Battle!.ogg", "Comment": "Canonical bundle fixed boss map; DTEF AutoTiles, no manual transition painting."})
    floor = binding["runtime_floor"]
    wall = binding["runtime_wall"]
    bosses = entry.get("boss_species", [])
    # Boss rooms are fixed by design, but their footprint is calibrated rather
    # than mechanically cloned: early/small encounters stay compact, trios get
    # flanking space, and late legendary encounters receive room to manoeuvre.
    giant = {"groudon", "kyogre", "lugia", "mewtwo", "rayquaza", "palkia", "giratina", "arceus", "necrozma", "eternatus", "zygarde", "regigigas"}
    if len(bosses) >= 3:
        width, height = 19, 19
    elif bosses and (bosses[0] in giant or entry["chapter"] >= 20):
        width, height = 21, 19
    else:
        width, height = 15, 18
    floor_proto = next(copy.deepcopy(cell) for column in obj["Tiles"] for cell in column if cell["Data"]["ID"] == "floor")
    wall_proto = next(copy.deepcopy(cell) for column in obj["Tiles"] for cell in column if cell["Data"]["ID"] != "floor")
    tiles = []
    for x in range(width):
        column = []
        for y in range(height):
            cell = copy.deepcopy(wall_proto if x < 2 or y < 2 or x >= width - 2 or y >= height - 2 else floor_proto)
            cell["Data"]["ID"] = "unbreakable" if x < 2 or y < 2 or x >= width - 2 or y >= height - 2 else "floor"
            cell["Effect"]["TileLoc"] = loc(x, y)
            column.append(cell)
        tiles.append(column)
    obj["Tiles"] = tiles
    obj["DiscoveryArray"] = [[0 for _ in range(height)] for _ in range(width)]
    for column in obj["Tiles"]:
        for cell in column:
            material = floor if cell["Data"]["ID"] == "floor" else wall
            cell["Data"]["TileTex"] = autotile(material)
    neighbor_codes([[cell["Data"]["TileTex"] for cell in col] for col in obj["Tiles"]])
    visual = [[copy.deepcopy(cell["Data"]["TileTex"]) for cell in col] for col in obj["Tiles"]]
    neighbor_codes(visual)
    obj["Layers"] = [{"Name": "DTEF Base", "Layer": 0, "Visible": True, "Tiles": visual}]
    obj["TextureMap"] = {"floor": autotile(floor), "wall": autotile(wall), "unbreakable": autotile(wall), "water": autotile(binding["runtime_secondary"], [floor])}
    bosses = entry.get("boss_species", [])
    teams = obj.get("MapTeams", [])
    if not teams:
        return obj
    base_level = min(100, max(10, 5 + entry["chapter"] * 3))
    new_teams = []
    center_x = width // 2
    positions = [(center_x, 4), (center_x - 2, 5), (center_x + 2, 5)]
    for index, species in enumerate(bosses[:3]):
        team = copy.deepcopy(teams[index % len(teams)])
        mon = team["Players"][0]
        form = {"Species": species, "Form": 0, "Skin": "normal", "Gender": -1}
        mon["BaseForm"] = form
        mon["CurrentForm"] = copy.deepcopy(form)
        mon["Level"] = min(100, base_level + max(0, len(bosses) - index - 1) * 2)
        mon["HP"] = max(60, 60 + entry["chapter"] * 6)
        mon["Unrecruitable"] = True
        mon["Nickname"] = species.replace("_", " ").title()
        mon["serializationLoc"] = loc(*positions[index])
        team["Name"] = mon["Nickname"]
        new_teams.append(team)
    obj["MapTeams"] = new_teams
    obj["EntryPoints"] = [{"Loc": loc(center_x, height - 5), "Dir": 4}, {"Loc": loc(center_x - 1, height - 5), "Dir": 4}, {"Loc": loc(center_x + 1, height - 5), "Dir": 4}]
    return obj


def item_entry(item: str, rate: int, max_floor: int) -> dict[str, Any]:
    return {"Spawn": {"ID": item, "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": rate, "Range": {"Min": 0, "Max": max_floor}}


def aggregate_pool(entry: dict[str, Any], start: int, end: int) -> list[dict[str, Any]]:
    counts: dict[str, int] = defaultdict(int)
    level_sum: dict[str, int] = defaultdict(int)
    weighted: dict[str, int] = defaultdict(int)
    for floor in entry["floor_spawns"][start:end]:
        for mon in floor:
            species = mon["species"]
            counts[species] += 1
            level_sum[species] += mon["level"]
            weighted[species] += mon["weight"]
    ordered = sorted(counts, key=lambda species: (weighted[species], counts[species]), reverse=True)[:20]
    # The framework asks for 10–20 species.  Early Rescue Team tables can be
    # shorter (Tiny Woods is the obvious case), so complete only with a
    # coherent biome pool and retain the source entries as the highest-weight
    # residents.  Long source tables are never expanded past 20.
    if len(ordered) < 10:
        for species in THEME_POOLS[entry["biome"]]:
            if species not in ordered:
                ordered.append(species)
            if len(ordered) >= 10:
                break
    source_level = max(1, round(sum(level_sum.values()) / max(1, sum(counts.values()))))
    return [
        {
            "species": species,
            "level": max(1, round(level_sum[species] / counts[species])) if species in counts else source_level,
            "weight": max(1, weighted[species] // counts[species]) if species in counts else 1,
        }
        for species in ordered[:20]
    ]


def zone_team_step(entry: dict[str, Any], start: int, end: int, template: dict[str, Any]) -> dict[str, Any]:
    step = copy.deepcopy(template)
    row_template = step["Spawns"][0]
    step["Spawns"] = []
    for mon in aggregate_pool(entry, start, end):
        row = copy.deepcopy(row_template)
        char = row["Spawn"]["Spawn"]
        char["BaseForm"] = {"Species": mon["species"], "Form": 0, "Skin": "", "Gender": -1}
        char["Level"] = {"Min": mon["level"], "Max": min(101, mon["level"] + 1)}
        char["SpecifiedSkills"] = []
        char["Intrinsic"] = ""
        char["Tactic"] = "wander_dumb"
        char["SpawnConditions"] = []
        char["SpawnFeatures"] = [{"$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"}]
        char["Comment"] = "CANONICAL_SOURCE_ADAPTED_PMDO"
        row["Rate"] = max(1, mon["weight"])
        row["Range"] = {"Min": 0, "Max": end - start}
        step["Spawns"].append(row)
    return step


def optional_zone_steps(entry: dict[str, Any], base_segment: dict[str, Any], crooked_segment: dict[str, Any], segment_length: int) -> list[dict[str, Any]]:
    """Bring over native Kecleon/Monster House/trap mechanics only when source data permits them."""
    mechanics = entry.get("mechanics", {})
    result: list[dict[str, Any]] = []
    if mechanics.get("kecleon"):
        shop = next((copy.deepcopy(step) for step in base_segment.get("ZoneSteps", []) if "ShopStep" in json.dumps(step)), None)
        if shop is not None:
            # Keep PMDO's validated shop schema, but scope its spread to the
            # local segment rather than inheriting a donor's floor range.
            for node in shop.get("Spawns", []):
                node["Range"] = {"Min": 0, "Max": segment_length}
            plan = shop.get("SpreadPlan", {})
            if isinstance(plan, dict) and "FloorRange" in plan:
                plan["FloorRange"] = {"Min": 0, "Max": segment_length}
            result.append(shop)
    if mechanics.get("monster_house"):
        house = next((copy.deepcopy(step) for step in crooked_segment.get("ZoneSteps", []) if "SpreadHouseZoneStep" in step.get("$type", "")), None)
        if house is not None:
            for collection in (house.get("Items", []), house.get("ItemThemes", []), house.get("Mobs", [])):
                for node in collection:
                    node["Range"] = {"Min": 0, "Max": segment_length}
            result.append(house)
    return result


def zone_item_step(entry: dict[str, Any], start: int, end: int) -> dict[str, Any]:
    counts: Counter[str] = Counter()
    for pool in entry["floor_items"][start:end]:
        counts.update(pool)
    chosen = [item for item, _ in counts.most_common(12)] or ["food_apple", "berry_oran", "seed_reviver", "medicine_max_elixir"]
    groups = {"necessities": [], "Seeds": [], "Orbs": [], "Other": []}
    for item in chosen:
        target = "necessities"
        if item.startswith("seed_"):
            target = "Seeds"
        elif item.startswith("orb_"):
            target = "Orbs"
        elif not (item.startswith("food_") or item.startswith("berry_")):
            target = "Other"
        groups[target].append(item_entry(item, max(1, counts.get(item, 1)), end - start))
    payload = {}
    for group, items in groups.items():
        if not items:
            continue
        payload[group] = {"Spawns": items, "SpawnRates": {"nodes": [{"Item": 10, "Range": {"Min": 0, "Max": end - start}}]}}
    return {"$type": "RogueEssence.LevelGen.ItemSpawnZoneStep, RogueEssence", "Priority": priority(2, 1), "Spawns": payload}


def remove_steps(grid: dict[str, Any], tokens: tuple[str, ...]) -> None:
    grid["GenSteps"] = [entry for entry in grid["GenSteps"] if not any(token in entry.get("Value", {}).get("$type", "") for token in tokens)]


def find_step(grid: dict[str, Any], token: str) -> dict[str, Any]:
    for entry in grid["GenSteps"]:
        value = entry.get("Value", {})
        if token in value.get("$type", ""):
            return value
    raise ValueError(f"Missing {token}")


def build_grid(template: dict[str, Any], branch_template: dict[str, Any], entry: dict[str, Any], start_floor: int, family: str, name_offset: int, binding: dict[str, str]) -> dict[str, Any]:
    grid = copy.deepcopy(branch_template if family in {"branch", "loop"} else template)
    remove_steps(grid, ("PerlinWaterStep", "AddTunnelStep", "MapEffectStep", "ScriptGenStep"))
    data = find_step(grid, "MapDataStep")
    data.update({"Music": entry.get("music", "Mystifying Forest.ogg"), "TimeLimit": 1000 + min(1000, entry["chapter"] * 20), "TileSight": 0, "CharSight": 1, "ClampCamera": False})
    texture = find_step(grid, "MapTextureStep")
    texture.update({"GroundTileset": binding["runtime_floor"], "BlockTileset": binding["runtime_wall"], "WaterTileset": binding["runtime_secondary"], "LayeredGround": False, "IndependentGround": False, "GroundElement": "water" if entry["biome"] in {"water", "deep_water", "waterfall", "brine"} else "grass" if entry["biome"] in {"forest", "tiny", "purity"} else "rock"})
    init = find_step(grid, "InitGridPlanStep")
    shapes = [(4, 3, 9, 9), (5, 3, 8, 9), (4, 4, 8, 8), (5, 4, 7, 8), (6, 3, 7, 9)]
    sx, sy, sw, sh = shapes[(start_floor + len(family)) % len(shapes)]
    init.update({"CellX": sx, "CellY": sy, "CellWidth": sw, "CellHeight": sh, "CellWall": 3 if family != "loop" else 2, "Wrap": False})
    stairs = find_step(grid, "FloorStairsStep")
    stairs["MinDistance"] = 8
    stairs["Exits"][0]["Tile"]["ID"] = "stairs_go_down"
    paths = [entry2["Value"] for entry2 in grid["GenSteps"] if "GridPath" in entry2.get("Value", {}).get("$type", "")]
    path = paths[0]
    if family == "tiered":
        path["TierAxis"] = start_floor % 2
        path["TierConnections"] = {"Min": 2, "Max": 4}
    else:
        path["RoomRatio"] = {"Min": 55, "Max": 75}
        path["BranchRatio"] = {"Min": 35, "Max": 65}
        path["NoForcedBranches"] = False
    if family == "loop":
        tunnel = {"$type": "RogueEssence.AddTunnelStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence", "TurnLength": {"Min": 2, "Max": 6}, "MaxLength": {"Min": 2, "Max": 7}, "AllowDeadEnd": False, "TraverseFloor": False, "Halls": {"Min": 4, "Max": 7}, "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"}}
        grid["GenSteps"].append({"Key": priority(0, 3), "Value": tunnel})
    grid["GenSteps"].extend([
        {"Key": priority(-6, 1), "Value": {"$type": "RogueEssence.LevelGen.MapNameIDStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence", "Name": {"DefaultText": f"{entry['public_name']} {{0}}", "LocalTexts": {"fr": f"{entry['french_name']} {{0}}"}}, "IDOffset": name_offset}},
        {"Key": priority(-6, 2), "Value": {"$type": "PMDC.LevelGen.MapTitleDropStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC", "DropPriority": priority(-15)}},
    ])
    grid["Comment"] = f"Canonical bundle runtime family={family}; floor block begins at {start_floor}; no fixed seed."
    return grid


def generic_zone(entry: dict[str, Any]) -> dict[str, Any]:
    base = load_json(ROOT / "Data/Zone/mt_blaze.json")["Object"]
    crooked = load_json(ROOT / "Data/Zone/crooked_cavern.json")["Object"]
    tiered = copy.deepcopy(base["Segments"][0]["Floors"]["nodes"][0]["Item"]["Spawns"][0]["Spawn"])
    branch = copy.deepcopy(crooked["Segments"][0]["Floors"]["nodes"][0]["Item"])
    team_template = copy.deepcopy(base["Segments"][0]["ZoneSteps"][4])
    total = int(entry["canonical_floor_count"])
    has_boss = bool(entry.get("boss_species"))
    explore = max(1, total - (1 if has_boss else 0))
    # A midpoint after the last floor of a 3F/5F route is not a checkpoint.
    # Short canonical dungeons therefore split around their middle; long ones
    # retain the 10-floor segment cadence requested by the framework.
    if explore <= 10 and explore > 1:
        split = max(1, explore // 2)
        chunks = [(0, split), (split, explore)]
    else:
        chunks = [(start, min(explore, start + 10)) for start in range(0, explore, 10)]
    segments = []
    for segment_index, (start, end) in enumerate(chunks):
        seg = copy.deepcopy(base["Segments"][0])
        material = progressive_binding(entry, segment_index, len(chunks))
        chance = {"$type": "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence", "Spawns": []}
        for family, rate in (("branch", 8), ("tiered", 7), ("loop", 6)):
            chance["Spawns"].append({"Spawn": build_grid(tiered, branch, entry, start, family, start + 1, material), "Rate": rate})
        seg["Floors"] = {"nodes": [{"Item": chance, "Range": {"Min": 0, "Max": end - start}}]}
        trap_spawns = []
        if entry.get("mechanics", {}).get("traps"):
            trap_spawns = [
                {"Spawn": {"TileLoc": loc(0, 0), "ID": "trap_trip", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 8, "Range": {"Min": 0, "Max": end - start}},
                {"Spawn": {"TileLoc": loc(0, 0), "ID": "trap_slumber", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 5, "Range": {"Min": 0, "Max": end - start}},
                {"Spawn": {"TileLoc": loc(0, 0), "ID": "trap_warp", "Revealed": False, "Owner": 0, "TileStates": []}, "Rate": 4, "Range": {"Min": 0, "Max": end - start}},
            ]
        seg["ZoneSteps"] = [
            {"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC", "Priority": priority(1, 1)},
            {"$type": "RogueEssence.LevelGen.MoneySpawnZoneStep, RogueEssence", "Priority": priority(2), "StartAmount": {"Min": 5 + entry["chapter"] * 3, "Max": 18 + entry["chapter"] * 4}, "AddAmount": {"Min": 1, "Max": 7}, "ModStates": []},
            zone_item_step(entry, start, end),
            zone_team_step(entry, start, end, team_template),
            {"$type": "RogueEssence.LevelGen.TileSpawnZoneStep, RogueEssence", "Priority": priority(2, 3), "Spawns": trap_spawns},
            *optional_zone_steps(entry, base["Segments"][0], crooked["Segments"][0], end - start),
        ]
        seg["IsRelevant"] = True
        seg["Comment"] = f"{entry['public_name']} canonical procedural floors {start + 1}-{end}; three RogueElements families per visit."
        segments.append(seg)
    if has_boss:
        boss_seg = copy.deepcopy(base["Segments"][2])
        boss_seg["Floors"][0]["GenSteps"][0]["Value"]["MapID"] = f"{entry['id']}_boss"
        boss_seg["ZoneSteps"] = [{"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC", "Priority": priority(1, 1)}, {"$type": "PMDC.LevelGen.FloorNameDropZoneStep, PMDC", "DropPriority": priority(-15), "Name": {"DefaultText": f"{entry['public_name']} {total}", "LocalTexts": {"fr": f"{entry['french_name']} {total}"}}, "Priority": priority(-6)}]
        boss_seg["IsRelevant"] = True
        boss_seg["Comment"] = f"Fixed canonical boss/final room {total}F."
        segments.append(boss_seg)
    grounds = [f"{entry['id']}_entrance", f"{entry['id']}_mid", f"{entry['id']}_boss"]
    final_binding = progressive_binding(entry, len(chunks) - 1, len(chunks))
    zone = copy.deepcopy(base)
    zone.update({"Name": {"DefaultText": entry["public_name"], "LocalTexts": {"fr": entry["french_name"]}}, "Released": True, "Comment": f"Single canonical bundle / {entry['family']} / Bulbapedia: {entry['bulbapedia']}", "Level": -1, "TeamSize": 3, "Rescues": 10, "Segments": segments, "GroundMaps": grounds, "CanonicalBundle": {"source": entry["family"], "source_directory": entry.get("source_directory"), "bulbapedia": entry["bulbapedia"], "dtef": entry["dtef"], "final_dtef": final_binding}})
    return zone


def ground_script(entry: dict[str, Any], role: str, exploration_segments: int, has_boss: bool) -> str:
    zone = entry["id"]
    # JSON string serialization is valid Lua for these simple strings and
    # safely handles French apostrophes (ex. Fosse d'Argent).
    enter_prompt = json.dumps(f"Entrer dans {entry['french_name']} ?", ensure_ascii=False)
    continue_prompt = json.dumps(f"Continuer dans {entry['french_name']} ?", ensure_ascii=False)
    if role == "entrance":
        body = f"""function map.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo({enter_prompt}, true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('{zone}', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function map.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
"""
    elif role == "mid":
        # A short dungeon has one exploration segment followed directly by its
        # fixed finale.  Longer dungeons continue to segment 1 after the same
        # Kangaskhan checkpoint.
        onward = (
            f"GAME:EnterDungeon('{zone}', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)"
            if exploration_segments > 1
            else f"GAME:EnterGroundMap('{zone}_boss', 'Main_Entrance_Marker')"
        )
        body = f"""function map.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo({continue_prompt}, true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    {onward}
  end
end
function map.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('{zone}_entrance', 'Main_Entrance_Marker')
end
function map.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
"""
    elif has_boss:
        body = f"""function map.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {{}}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('{zone}', {exploration_segments}, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
"""
    else:
        body = """function map.Enter(map_data)
  GAME:FadeIn(20)
  UI:WaitShowDialogue('Le voyage est terminé.')
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
end
"""
    init = """require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local map = {}
function map.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
"""
    if role != "boss":
        init += "function map.Enter(map_data) GAME:FadeIn(20) end\n"
    init += body + "return map\n"
    # Match PMDO's conventional map-script table name.  Lua technically only
    # needs the returned table, but using the AssetName keeps registration and
    # static callback validators deterministic.
    asset = f"{entry['id']}_{role}"
    return init.replace("local map = {}", f"local {asset} = {{}}").replace("map.", f"{asset}.").replace("return map", f"return {asset}")


def zone_script(entry: dict[str, Any], exploration_segments: int, has_boss: bool) -> str:
    zone = entry["id"]
    final_explore = exploration_segments - 1
    boss_segment = exploration_segments
    script = f"""require 'origin.common'
require 'halcyon.GeneralFunctions'
local zone = {{}}
function zone.Init(data)
  SV.TemporaryFlags = SV.TemporaryFlags or {{}}
  SV.TemporaryFlags.LastDungeonEntered = '{zone}'
end
function zone.EnterSegment(data, rescuing, segmentID, mapID)
  GAME:SetRescueAllowed(segmentID < {boss_segment})
  if rescuing ~= true then COMMON.BeginDungeon(data.ID, segmentID, mapID) end
end
function zone.Rescued(data, name, mail) COMMON.Rescued(data, name, mail) end
function zone.ExitSegment(data, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, data.ID, segmentID) then return end
  SV.adventure.Thief = false
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if segmentID > 0 then GAME:EnterGroundMap('{zone}_mid', 'Main_Entrance_Marker')
    else GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true) end
    return
  end
  if segmentID == 0 then
    GAME:EnterGroundMap('{zone}_mid', 'Main_Entrance_Marker')
    return
  end
  if segmentID < {final_explore} then
    GAME:ContinueDungeon('{zone}', segmentID + 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == {final_explore} then
    GAME:EnterGroundMap('{zone}_boss', 'Main_Entrance_Marker')
    return
  end
  -- Any segment after the final exploration segment is the fixed boss map.
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end
return zone
"""
    return script.replace("local zone = {}", f"local {zone} = {{}}").replace("zone.", f"{zone}.").replace("return zone", f"return {zone}")


def update_indices(entries: list[dict[str, Any]], zones: dict[str, dict[str, Any]]) -> None:
    idx_path = ROOT / "Data/Zone/index.idx"
    master_path = ROOT / "Data/Zone/master_zone.json"
    idx = load_json(idx_path)
    master = load_json(master_path)
    summaries = idx["Object"]
    template = copy.deepcopy(summaries["mt_blaze"])
    grounds = master["Object"]["GroundMaps"]
    for entry in entries:
        zone = zones[entry["id"]]
        maps = []
        for segment in zone["Segments"]:
            floors = segment.get("Floors")
            if isinstance(floors, dict):
                ids = []
                for node in floors.get("nodes", []):
                    ids.extend(range(node["Range"]["Min"], node["Range"]["Max"]))
                maps.append(ids)
            else:
                maps.append(list(range(len(floors or []))))
        summary = copy.deepcopy(template)
        summary.update({"Level": zone["Level"], "TeamSize": zone["TeamSize"], "Rescues": zone["Rescues"], "CountedFloors": entry["canonical_floor_count"], "Grounds": zone["GroundMaps"], "Maps": maps, "Name": zone["Name"], "Comment": zone["Comment"]})
        summaries[entry["id"]] = summary
        for ground in zone["GroundMaps"]:
            if ground not in grounds:
                grounds.append(ground)
    summaries["master_zone"]["Grounds"] = list(grounds)
    save_json(master_path, master, bom=False)
    save_json(idx_path, idx, bom=False)


def write_bundle(registry: dict[str, Any]) -> list[dict[str, Any]]:
    physical = [entry for entry in registry["main_route"] + registry["pmd_red_roster"] if not entry.get("existing") and not entry.get("alias_of")]
    zones: dict[str, dict[str, Any]] = {}
    for entry in physical:
        zone = generic_zone(entry)
        zones[entry["id"]] = zone
        save_json(ROOT / "Data/Zone" / f"{entry['id']}.json", {"Version": VERSION, "Object": zone})
        explore_segments = len([segment for segment in zone["Segments"] if "RangeDictSegment" in segment["$type"]])
        has_boss = bool(entry.get("boss_species"))
        final_binding = progressive_binding(entry, explore_segments - 1, explore_segments)
        for role in ("entrance", "mid", "boss"):
            ground = generic_ground(entry, role, final_binding if role == "boss" else entry["dtef"])
            save_json(ROOT / "Data/Ground" / f"{entry['id']}_{role}.rsground", {"Version": VERSION, "Object": ground})
            script_path = ROOT / "Data/Script/halcyon/ground" / f"{entry['id']}_{role}" / "init.lua"
            script_path.parent.mkdir(parents=True, exist_ok=True)
            script_path.write_text(ground_script(entry, role, explore_segments, has_boss), encoding="utf-8")
        script_path = ROOT / "Data/Script/halcyon/zone" / entry["id"] / "init.lua"
        script_path.parent.mkdir(parents=True, exist_ok=True)
        script_path.write_text(zone_script(entry, explore_segments, has_boss), encoding="utf-8")
        if has_boss:
            save_json(ROOT / "Data/Map" / f"{entry['id']}_boss.rsmap", {"Version": VERSION, "Object": boss_template_map(entry, final_binding)})
    update_indices(physical, zones)
    return physical


def validate_bundle(registry: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    physical = [entry for entry in registry["main_route"] + registry["pmd_red_roster"] if not entry.get("existing") and not entry.get("alias_of")]
    idx = load_json(ROOT / "Data/Zone/index.idx")["Object"]
    master = load_json(ROOT / "Data/Zone/master_zone.json")["Object"]
    for entry in physical:
        zone_path = ROOT / "Data/Zone" / f"{entry['id']}.json"
        if not zone_path.is_file():
            errors.append(f"missing zone {entry['id']}")
            continue
        zone = load_json(zone_path)["Object"]
        if zone.get("GroundMaps") != [f"{entry['id']}_entrance", f"{entry['id']}_mid", f"{entry['id']}_boss"]:
            errors.append(f"ground convention broken: {entry['id']}")
        payload = json.dumps(zone)
        if "FirstSeed" in payload or '"seed"' in payload.lower():
            errors.append(f"fixed procedural seed: {entry['id']}")
        if entry["id"] not in idx:
            errors.append(f"missing index entry: {entry['id']}")
        if entry["id"] not in {entry2["id"] for entry2 in physical}:
            errors.append(f"registry mismatch: {entry['id']}")
        for role in ("entrance", "mid", "boss"):
            name = f"{entry['id']}_{role}"
            if not (ROOT / "Data/Ground" / f"{name}.rsground").is_file():
                errors.append(f"missing ground {name}")
            if name not in master["GroundMaps"]:
                errors.append(f"ground not in master zone {name}")
        if entry.get("boss_species") and not (ROOT / "Data/Map" / f"{entry['id']}_boss.rsmap").is_file():
            errors.append(f"missing boss map {entry['id']}")
    # All aliases must point to either an existing handcrafted zone or a zone
    # generated by this same delivery.
    all_ids = set(idx)
    for entry in registry["pmd_red_roster"]:
        if entry.get("alias_of") and entry["alias_of"] not in all_ids:
            errors.append(f"dangling shared alias {entry['id']} -> {entry['alias_of']}")
    return errors


def write_complete_dtef_bindings(registry: dict[str, Any]) -> None:
    rows: dict[str, Any] = {}
    for entry in registry["main_route"] + registry["pmd_red_roster"]:
        if "dtef" not in entry:
            continue
        final = None
        zone_path = ROOT / "Data/Zone" / f"{entry['id']}.json"
        if zone_path.is_file() and not entry.get("existing") and not entry.get("alias_of"):
            final = load_json(zone_path)["Object"].get("CanonicalBundle", {}).get("final_dtef")
        rows[entry["id"]] = {
            "public_name": entry["public_name"],
            "chapter": entry["chapter"],
            "rawasset_path": "TileDtef/" + entry["dtef"]["rawasset_folder"],
            "local_path": "Content/TileDtef/canonical/" + entry["dtef"]["rawasset_folder"],
            "runtime": entry["dtef"],
            "final_runtime": final,
            "shared_alias_of": entry.get("alias_of"),
        }
    save_json(ROOT / "docs/canonical_dungeons/complete_dtef_bindings.json", {"schema": "new-era.complete-canonical-dtef-bindings.v1", "policy": {"source": "PMDCollab/RawAsset TileDtef", "importer": "PMDO native Import DTEF", "manual_transition_painting": False, "custom_converter": False}, "bindings": rows}, bom=False)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, help="pret/pmd-red checkout; needed only for --write-registry")
    parser.add_argument("--write-registry", action="store_true")
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if not (args.write_registry or args.write or args.check):
        parser.error("choose --write-registry, --write and/or --check")
    if args.write_registry:
        if args.source is None:
            parser.error("--write-registry requires --source")
        registry = build_registry(args.source)
        save_json(REGISTRY_PATH, registry, bom=False)
    if not REGISTRY_PATH.is_file():
        parser.error("registry missing; use --source ... --write-registry first")
    registry = load_json(REGISTRY_PATH)
    if args.write:
        physical = write_bundle(registry)
        write_complete_dtef_bindings(registry)
        print(f"wrote {len(physical)} physical canonical zones")
    elif args.write_registry:
        write_complete_dtef_bindings(registry)
    if args.check:
        errors = validate_bundle(registry)
        if errors:
            print("canonical bundle validation failed:", file=sys.stderr)
            for error in errors:
                print(" - " + error, file=sys.stderr)
            return 1
        print("complete canonical bundle: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
