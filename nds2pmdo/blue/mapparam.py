"""Décodage de dungeon.sbin/mapparam (Blue Rescue Team APHP).

Tables localisées et validées sur la ROM :
  - tables floor_id (u16[8] × étages) — Sinister Woods = dungeon #3 @ 0x160
  - FloorProperties (28 B / entrée) @ 0x7380 (index global = 17..29 pour SW)
  - table de pointeurs des spawns @ 0x1FEA8
  - table de pointeurs des items @ 0x28978
  - table de pointeurs des pièges @ 0x222E4
  - structure principale @ 0x28C40 (pointeurs de tables + marqueur 0xAAAAAAAA)

Toute valeur produite ici est SOURCE_NDS (octets lus dans la ROM). Les noms de
champs proviennent de la décompilation pmd-red (CROSS_REFERENCE, jamais une preuve).
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field

FLOOR_ID_OFFSET_SW = 0x160          # Sinister Woods (dungeon #3)
FLOOR_ID_STRIDE = 16                # 8 × u16 par étage
FLOOR_COUNT_SW = 13
FLOORPROPS_BASE = 0x7380
FLOORPROPS_SIZE = 28
SPAWN_PTR_TABLE = 0x1FEA8
ITEM_PTR_TABLE = 0x28978
TRAP_PTR_TABLE = 0x222E4
MAIN_STRUCT = 0x28C40
SW_MAINDATA_FIRST = 17              # index FloorProperties du 1er étage de SW
SW_ITEM_TABLES = (11, 12)           # floor_id.Items pour SW (F1-F4=11, F5+=12)
SW_TRAP_TABLE = 2                   # floor_id.Traps pour SW
ITEM_MARKER_BASE = 0x7500           # marqueurs de catégorie 0x75xx
ITEM_TABLE_END = 0x753F             # marqueur de fin de table

FLOORPROPS_FIELDS = [
    ("layout", "u8"), ("roomDensity", "i8"), ("tileset", "u8"), ("bgMusic", "u8"),
    ("weather", "u8"), ("floorConnectivity", "u8"), ("enemyDensity", "i8"),
    ("kecleonShopChance", "u8"), ("monsterHouseChance", "u8"),
    ("mazeRoomChance", "u8"), ("itemStickyChance", "u8"), ("allowDeadEnds", "bool"),
    ("secondaryStructuresBudget", "u8"), ("roomFlags", "u8"), ("_pad", "u8"),
    ("itemDensity", "u8"), ("trapDensity", "u8"), ("floorNumber", "u8"),
    ("fixedRoomNumber", "u8"), ("numExtraHallways", "u8"),
    ("buriedItemDensity", "u8"), ("standaloneLakeDensity", "u8"),
    ("visibilityRange", "u8"), ("moneyUpperBound", "u8"),
    ("kecleonShopLayout", "u8"), ("itemlessMonsterHouseChance", "u8"), ("_pad2", "u8"),
]


@dataclass
class FloorProperties:
    global_index: int
    offset: int
    bytes_hex: str
    fields: dict = field(default_factory=dict)

    @classmethod
    def parse(cls, data: bytes, index: int, base: int = FLOORPROPS_BASE,
              names: dict[str, str] | None = None) -> "FloorProperties":
        off = base + index * FLOORPROPS_SIZE
        b = data[off:off + FLOORPROPS_SIZE]
        if len(b) != FLOORPROPS_SIZE:
            raise ValueError(f"FloorProperties #{index} hors limites @{off:#x}")
        fields = {}
        for name, kind in FLOORPROPS_FIELDS:
            if kind == "u8":
                fields[name] = b[0]
            elif kind == "i8":
                fields[name] = struct.unpack_from('<b', b, 0)[0]
            elif kind == "bool":
                fields[name] = bool(b[0])
            b = b[1:]
        return cls(global_index=index, offset=off, bytes_hex=data[off:off + 28].hex(),
                   fields=fields)


def parse_floor_id_table(data: bytes, offset: int = FLOOR_ID_OFFSET_SW,
                         floors: int = FLOOR_COUNT_SW) -> list[dict]:
    """Table floor_id : 8 × u16 par étage : [MainData, Pokemon, Traps, Items,
    KecleonShop, MonsterRoomItems, BuriedItems, 0]."""
    out = []
    for f in range(floors):
        off = offset + f * FLOOR_ID_STRIDE
        vals = struct.unpack_from('<8H', data, off)
        out.append({
            "floor": f + 1,
            "MainData": vals[0], "Pokemon": vals[1], "Traps": vals[2],
            "Items": vals[3], "KecleonShop": vals[4],
            "MonsterRoomItems": vals[5], "BuriedItems": vals[6],
            "offset": off,
        })
    return out


def parse_spawn_pointer_table(data: bytes, table_offset: int = SPAWN_PTR_TABLE
                              ) -> list[int]:
    ptrs = []
    o = table_offset
    while o + 4 <= len(data):
        p = struct.unpack_from('<I', data, o)[0]
        if not p or p >= len(data):
            break
        ptrs.append(p)
        o += 4
        if len(ptrs) > 600:
            break
    return ptrs


def parse_spawn_table(data: bytes, ptr: int) -> list[dict]:
    """Table de spawns Blue : entrées de 8 octets (u16 bits, s16 w0, s16 w1, u16 pad).
    bits : species = bits & 0x1FF, level = (bits >> 9) & 0x7F.
    Terminateur : KECLEON (id 380) à poids nuls."""
    out = []
    off = ptr
    for _ in range(32):
        bits, r0, r1, _pad = struct.unpack_from('<HhhH', data, off)
        off += 8
        sp = bits & 0x1FF
        lv = (bits >> 9) & 0x7F
        e = {"species_id": sp, "level": lv, "weight0": r0, "weight1": r1}
        if r0 == 0 and r1 == 0:
            e["special"] = True
            out.append(e)
            break
        out.append(e)
    return out


def parse_item_table(data: bytes, ptr: int, max_u16: int = 512) -> dict:
    """Table d'items : flux u16 = groupes de poids cumulés terminés par un marqueur
    de catégorie 0x75xx ; fin de table = 0x753F sans poids.
    Les IDs d'items par catégorie ne sont PAS dans ce flux (UNKNOWN, documenté)."""
    vals = []
    o = ptr
    for _ in range(max_u16):
        v = struct.unpack_from('<H', data, o)[0]
        o += 2
        if v >= ITEM_MARKER_BASE:
            break
        vals.append(v)
    groups = []
    cur: list[int] = []
    o = ptr
    first = True
    while o < ptr + max_u16 * 2:
        v = struct.unpack_from('<H', data, o)[0]
        o += 2
        if v >= ITEM_MARKER_BASE:
            if not first:
                groups.append({"category_marker": v,
                               "category_id": v - ITEM_MARKER_BASE,
                               "cumulative_weights": cur})
            cur = []
            if v == ITEM_TABLE_END:
                break
            first = False
        else:
            cur.append(v)
    weight_count = sum(len(g["cumulative_weights"]) for g in groups)
    return {"offset": ptr, "u16_count": weight_count + len(groups) + 1, "groups": groups}


def parse_trap_table(data: bytes, ptr: int) -> list[int]:
    """Table de pièges : u16[20] (poids par type de piège)."""
    return list(struct.unpack_from('<20H', data, ptr))


def decode_mapparam(mapparam: bytes) -> dict:
    """Décodage complet du mapparam pour Sinister Woods (portée pilote)."""
    floor_ids = parse_floor_id_table(mapparam)
    props = {f["MainData"]: FloorProperties.parse(mapparam, f["MainData"]) for f in floor_ids}
    spawn_ptrs = parse_spawn_pointer_table(mapparam)
    item_ptrs = [struct.unpack_from('<I', mapparam, ITEM_PTR_TABLE + i * 4)[0] for i in range(32)]
    trap_ptrs = [struct.unpack_from('<I', mapparam, TRAP_PTR_TABLE + i * 4)[0] for i in range(32)]
    return {
        "floor_ids": floor_ids,
        "floor_properties": {str(k): v.__dict__ for k, v in props.items()},
        "spawns": {str(i): parse_spawn_table(mapparam, p) for i, p in enumerate(spawn_ptrs)},
        "item_tables": {str(i): parse_item_table(mapparam, p) for i, p in enumerate(item_ptrs)
                        if p < len(mapparam)},
        "trap_tables": {str(i): parse_trap_table(mapparam, p) for i, p in enumerate(trap_ptrs)
                        if p < len(mapparam)},
        "spawn_ptr_count": len(spawn_ptrs),
    }
