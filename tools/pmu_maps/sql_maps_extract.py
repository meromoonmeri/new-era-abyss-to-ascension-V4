#!/usr/bin/env python3
"""
sql_maps_extract.py — reconstruit les fichiers MapData PMU en clair (format
client V9) à partir du dump MySQL officiel `pmu_data.sql` fourni DANS LE DÉPÔT
`Sprinkoringo/PMU-Server` (Content_Data.zip). C'est la source de vérité
serveur 2014 : aucune crypto à forcer, aucune donnée inventée — on régénère
exactement ce que le serveur envoyait au client.

Tables consommées (schémas relevés dans le dump) :
  map_general      (MapID, Version, Revision, MaxX, MaxY)
  map_data         (MapID, Name, Moral, Music, Indoors, Weather, Darkness,
                    HungerEnabled, RecruitmentEnabled, ExpEnabled, TimeLimit,
                    MinNpcs, MaxNpcs, NpcSpawnTime)
  map_tiles        (MapID, X, Y, Ground, GroundAnim, Mask, MaskAnim, Mask2,
                    Mask2Anim, Fringe, FringeAnim, Fringe2, Fringe2Anim, Type,
                    Data1, Data2, Data3, String1, String2, String3, Light,
                    GroundTileset, GroundAnimTileset, MaskTileset,
                    MaskAnimTileset, Mask2Tileset, Mask2AnimTileset,
                    FringeTileset, FringeAnimTileset, Fringe2Tileset,
                    Fringe2AnimTileset)
  map_npcs         (MapID, slot, NpcNum, SpawnX, SpawnY, MinLevel, MaxLevel,
                    AppearanceRate, StartStatus, StartStatusCounter, StartStatusChance)
  map_switchovers  (MapID, UpMap, DownMap, LeftMap, RightMap)

Sortie : un `Map-<id>.dat` UTF-8 par map retenue, au format texte que
`MapHelper.LoadMap` (client) lit et que notre render_pmu_maps parse déjà.
Le champ `Light` de la DB (sans équivalent dans la ligne Tile V9 du client)
est conservé à l'index champ 20 (RDMV du client) comme dans les fichiers
d'origine du dépôt serveur — documenté, pas inventé.

    python3 sql_maps_extract.py --sql pmu_data.sql --out MapData_sql \
        [--prefix s]      préfixes MapID à extraire (s = cartes du monde)
                          --prefix all = tout y compris maisons
    [--limit N]           s'arrêter après N maps (pour tests de volume)
"""
from __future__ import annotations

import argparse
import os
import re
import sys

TABLES = ("map_general", "map_data", "map_tiles", "map_npcs", "map_switchovers")
TUPLE_SPLIT = "),("
FIELD_RE = re.compile(r"'((?:[^']|'')*)'|(-?\d+)|\bNULL\b")


def iter_table_rows(path: str, wanted: set[str]):
    """Streaming ligne à ligne : ce dump mysqldump met un INSERT géant par
    table sur une seule ligne ; on la découpe aux frontières de tuples.
    Frontière sûre = "),('" — un tuple commence toujours par (' et une
    chaîne SQL ne peut PAS contenre "),('" sans échapper son apostrophe."""
    with open(path, "rb") as fh:
        for line in fh:
            if not line.startswith(b"INSERT INTO `"):
                continue
            m = re.match(rb"INSERT INTO `([a-z_]+)` VALUES ", line)
            if not m or m.group(1).decode() not in wanted:
                continue
            table = m.group(1).decode()
            body = line[m.end():].rstrip(b"\r\n;").decode("utf-8", "replace")
            for tup in body.replace("),('", ")\u0001('").split("\u0001"):
                yield table, tup


def split_fields(tup: str) -> list[str]:
    """Découpe '(a,b,'c'',d)' en valeurs brutes (sans parenthèses englobantes)."""
    if tup.startswith("("):
        tup = tup[1:]
    if tup.endswith(")"):
        tup = tup[:-1]
    vals, buf = [], []
    in_str = False
    i, n = 0, len(tup)
    while i < n:
        ch = tup[i]
        if in_str:
            if ch == "\\" and i + 1 < n:
                buf.append(ch); buf.append(tup[i + 1]); i += 2; continue
            if ch == "'":
                if i + 1 < n and tup[i + 1] == "'":
                    buf.append("'"); i += 2; continue
                in_str = False; i += 1; continue
            buf.append(ch); i += 1; continue
        if ch == "'":
            in_str = True; i += 1; continue
        if ch == ",":
            vals.append("".join(buf).strip()); buf = []; i += 1; continue
        buf.append(ch); i += 1
    vals.append("".join(buf).strip())
    return vals


def sql_int(v: str, default=0) -> int:
    if v in ("NULL", "", None):
        return default
    return int(v)


def sql_str(v: str) -> str:
    if v in ("NULL", None):
        return ""
    # backslash-escapes MySQL courants
    return v.replace("\\'", "'").replace('\\"', '"').replace("\\n", " ").replace("\\r", "").replace("\\\\", "\\")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sql", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--prefix", default="s", help="préfixe MapID ('s' = monde ; 'all')")
    ap.add_argument("--limit", type=int, default=0)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)

    prefixes = None if a.prefix == "all" else tuple(p for p in [a.prefix] if p)
    geo, meta, npcs, swi = {}, {}, {}, {}
    tiles: dict[str, list[str]] = {}
    stats = {"rows": 0}

    for table, tup in iter_table_rows(a.sql, set(TABLES)):
        f = split_fields(tup)
        if not f or not f[0]:
            continue
        mid = sql_str(f[0])
        if prefixes and not any(mid.startswith(p) for p in prefixes):
            continue
        stats["rows"] += 1
        if table == "map_general" and len(f) >= 5:
            geo[mid] = (sql_int(f[3], 19), sql_int(f[4], 14), sql_int(f[2]))
        elif table == "map_data" and len(f) >= 14:
            meta[mid] = f
        elif table == "map_npcs" and len(f) >= 11:
            npcs.setdefault(mid, []).append(f)
        elif table == "map_switchovers" and len(f) >= 5:
            swi[mid] = f
        elif table == "map_tiles" and len(f) >= 31:
            tiles.setdefault(mid, []).append(f)

    done = 0
    for mid in sorted(tiles):
        if a.limit and done >= a.limit:
            break
        maxx, maxy, rev = geo.get(mid, (19, 14, 0))
        m = meta.get(mid)
        sw = swi.get(mid)
        def sfield(i, default=""):
            return sql_str(m[i]) if m and len(m) > i else default
        def ifield(i, default=0):
            return sql_int(m[i], default) if m and len(m) > i else default
        up, dn, lf, rt = ((sql_int(sw[1], -1), sql_int(sw[2], -1),
                           sql_int(sw[3], -1), sql_int(sw[4], -1)) if sw else (0, 0, 0, 0))
        lines = [f"MapData|V9|{rev}|{maxx}|{maxy}|"]
        lines.append("Data|" + "|".join([
            sfield(1, mid), str(ifield(2)), str(up), str(dn), str(lf), str(rt),
            sfield(3), sfield(4), "", str(ifield(5)), str(ifield(6)),
            str(ifield(7)), str(ifield(8)), str(ifield(9)), str(ifield(10)),
            "0", str(ifield(11)), str(ifield(12)), str(ifield(13)), "0"]) + "|")
        for nf in npcs.get(mid, []):
            slot = sql_int(nf[1])
            lines.append(f"NpcSettings|{slot}|{sql_int(nf[2])}|{sql_int(nf[3])}|{sql_int(nf[4])}|"
                         f"{sql_int(nf[5])}|{sql_int(nf[6])}|{sql_int(nf[7])}|{sql_int(nf[8])}|"
                         f"{sql_int(nf[9])}|{sql_int(nf[10])}|")
        for t in tiles[mid]:
            # → ligne V9 du client (30 champs après Tile|x|y)
            g, ga, msk, msk_a, m2, m2_a, fr, fr_a, f2, f2_a = (sql_int(t[i]) for i in range(3, 13))
            typ = sql_int(t[13])
            d1, d2, d3 = sql_int(t[14]), sql_int(t[15]), sql_int(t[16])
            s1, s2, s3 = (sql_str(t[17]).replace("|", " "), sql_str(t[18]).replace("|", " "),
                          sql_str(t[19]).replace("|", " "))
            light = sql_int(t[20])
            ts = [sql_int(t[i]) for i in range(21, 31)]
            lines.append(f"Tile|{sql_int(t[1])}|{sql_int(t[2])}|{g}|{ga}|{msk}|{msk_a}|{m2}|{m2_a}|"
                         f"{fr}|{fr_a}|{f2}|{f2_a}|{typ}|{d1}|{d2}|{d3}|{s1}|{s2}|{s3}|{light}|"
                         f"{ts[0]}|{ts[1]}|{ts[2]}|{ts[3]}|{ts[4]}|{ts[5]}|{ts[6]}|{ts[7]}|{ts[8]}|{ts[9]}|")
        with open(os.path.join(a.out, f"Map-{mid}.dat"), "w", encoding="utf-8", newline="\n") as fh:
            fh.write("\n".join(lines))
        done += 1
    print(f"maps écrites : {done} (lignes utiles {stats['rows']}) → {a.out}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
