#!/usr/bin/env python3
"""
render_pmu_maps.py — rendu pixel-perfect des cartes de Pokémon Mystery
Universe (PMU), au format texte `.dat` du client (MapData|V4 / MapData|V9).

Fidélité : reproduit exactement la passe du MapRenderer.cs officiel
(Client/Graphics/Renderers/Maps/MapRenderer.cs, source MIT « PMU Staff ») :

    par tuile (x, y) :
        ground        dessine Tiles[GroundSet][Ground]   si Ground != 0
        ground anim   si GroundAnim != 0  → remplace le ground
        mask          dessine si Mask  != 0   (Anim != 0 → remplacé par Anim)
        mask anim     dessine si Anim  != 0
        mask2         idem (Mask2 / M2Anim)
        fringe        idem (Fringe / FAnim)       — passe objects+
        fringe2       idem (Fringe2 / F2Anim)

Règles de rendu vérifiées dans le code du client :
  - index 0            → rien n'est dessiné (« // Do Nothing ») ;
  - index hors bornes  → tuile 0 du même set (fallback GetTileGraphic) ;
  - tuiles 32×32 PNG   → composées source-over, alpha natif, aucun filtre ;
  - échelle 1:1        → image = (MaxX+1)×32  ×  (MaxY+1)×32 px.

Les archives `.tile` sont lues au format PMU (en-tête <ii w,h puis n×(u64
offset, u32 size), un PNG 32×32 complet par enregistrement) — mêmes octets
que tools/inventory_pmu_assets.py, déjà validé sur les 11 archives du client.

Entrée .dat : plaintext « MapData|V4|rev|maxX|maxY » ou « …V9… ». Les lignes
« Tile|x|y|…30 champs » sont lues ; « NpcData/SpawnX/… » et « NpcSettings »
sont ignorées (non pertinentes pour le rendu) ; la ligne « Data » fournit le
nom. Les fichiers chiffrés 3DES (cache d'ère live du client, clé de session)
sont DÉTECTÉS et marqués `encrypted-unrecoverable` — jamais rendus
approximativement.

Usage :
    python3 render_pmu_maps.py --tiles-dir <doss. Tiles*.tile> \
        --maps <fichier|.dat|.dat-* ou dossier> --out <dossier> \
        [--scale N nearest-neighbor uniquement, défaut 1]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import struct
import sys
from io import BytesIO

from PIL import Image

TILE = 32
FIELD = {  # index de champ dans une ligne « Tile|… » (split sur '|')
    "ground": 3, "ground_anim": 4, "mask": 5, "mask_anim": 6,
    "mask2": 7, "mask2_anim": 8, "fringe": 9, "fringe_anim": 10,
    "fringe2": 11, "fringe2_anim": 12, "type": 13,
    "data1": 14, "data2": 15, "data3": 16,
    "string1": 17, "string2": 18, "string3": 19, "rval": 20,
    "ground_set": 21, "ground_anim_set": 22, "mask_set": 23,
    "mask_anim_set": 24, "mask2_set": 25, "mask2_anim_set": 26,
    "fringe_set": 27, "fringe_anim_set": 28, "fringe2_set": 29,
    "fringe2_anim_set": 30,
}
# paires (statique, anim, set statique, set anim) dans l'ordre de dessin du
# client ; l'anim REMPLACE le statique quand son index est non nul.
PASSES = [
    ("ground", "ground_anim", "ground_set", "ground_anim_set"),
    ("mask", "mask_anim", "mask_set", "mask_anim_set"),
    ("mask2", "mask2_anim", "mask2_set", "mask2_anim_set"),
    ("fringe", "fringe_anim", "fringe_set", "fringe_anim_set"),
    ("fringe2", "fringe2_anim", "fringe2_set", "fringe2_anim_set"),
]


def sha1(data: bytes) -> str:
    return hashlib.sha1(data).hexdigest()


# ---------------------------------------------------------------- archives --
class TileStore:
    """Tuiles PMU : (set, index) -> PNG bytes 32×32. Chargées une fois."""

    def __init__(self, tiles_dir: str):
        self.sheets = {}
        for name in sorted(os.listdir(tiles_dir)):
            if not name.lower().endswith(".tile"):
                continue
            num = int("".join(ch for ch in name if ch.isdigit()))
            self._load(os.path.join(tiles_dir, name), num)
        if not self.sheets:
            sys.exit(f"aucun .tile trouvé dans {tiles_dir}")

    def _load(self, path: str, num: int) -> None:
        data = open(path, "rb").read()
        width, height = struct.unpack_from("<ii", data, 0)
        cols, rows = width // TILE, height // TILE
        count = cols * rows
        header = 8 + count * 12
        table = {}
        for i in range(count):
            pos, size = struct.unpack_from("<qi", data, 8 + i * 12)
            raw = data[header + pos : header + pos + size]
            if not raw.startswith(b"\x89PNG\r\n\x1a\n"):
                raise ValueError(f"{path}:{i} enregistrement PNG invalide")
            table[i] = raw
        self.sheets[num] = {"table": table, "count": count, "path": path,
                            "sha1": sha1(data), "grid": [cols, rows]}

    def image(self, sheet: int, index: int):
        s = self.sheets.get(sheet)
        if s is None:
            return None, "missing-set"
        if index in s["table"]:
            return Image.open(BytesIO(s["table"][index])).convert("RGBA"), None
        fallback = s["table"].get(0)
        if fallback is None:
            return None, "no-tile0"
        # le client retombe sur GetTileGraphic(0) pour tout index invalide
        return Image.open(BytesIO(fallback)).convert("RGBA"), "fallback0"

    def blank(self):
        return Image.new("RGBA", (TILE, TILE), (0, 0, 0, 0))


# --------------------------------------------------------------------- .dat --
class ParseError(Exception):
    pass


def sniff(raw: bytes) -> str:
    head = raw[:64]
    if b"MapData" in head or b"M\x00a\x00p\x00D\x00a\x00t\x00a\x00" in head:
        return "plain"
    # Cache chiffré 3DES du client (TripleDESCryptoServiceProvider) : taille
    # multiple de 8 par construction. Un plaintext PMU commence toujours par
    # « MapData » (vu au-dessus) ; tout le reste aligné 8 est traité comme du
    # 3DES (chiffré — jamais deviné).
    if len(raw) % 8 == 0 and len(raw) >= 64:
        return "encrypted"
    return "unknown"


def parse_map(raw: bytes) -> dict:
    if raw[:2] == b"\xff\xfe":
        text = raw.decode("utf-16", errors="strict")
    elif b"\x00" in raw[:16]:
        text = raw.decode("utf-16-le", errors="strict")
    else:
        text = raw.decode("utf-8", errors="strict")
    text = text.lstrip("\ufeff")
    lines = text.replace("\r\n", "\n").split("\n")
    header = lines[0].split("|") if lines else []
    if len(header) < 5 or header[0] != "MapData":
        raise ParseError("en-tête MapData absent")
    version = header[1]
    if version not in ("V4", "V9"):
        raise ParseError(f"version non supportée {version}")
    rev = int(header[2])
    maxx, maxy = int(header[3]), int(header[4])
    if maxx < 19:
        maxx = 19
    if maxy < 14:
        maxy = 14
    out = {"version": version, "revision": rev, "maxx": maxx, "maxy": maxy,
           "name": "", "tiles": {}, "music": "", "indoors": None, "weather": None}
    for line in lines[1:]:
        if not line:
            continue
        f = line.split("|")
        kind = f[0]
        if kind == "Data":
            out["name"] = f[1] if len(f) > 1 else ""
            out["music"] = f[7] if len(f) > 7 else ""
        elif kind == "Tile":
            if len(f) < 31:
                raise ParseError(f"ligne Tile courte: {line[:60]}")
            x, y = int(f[1]), int(f[2])
            vals = {}
            for key, idx in FIELD.items():
                raw_v = f[idx].strip()
                vals[key] = int(raw_v) if raw_v.lstrip("-").isdigit() else 0
            out["tiles"][(x, y)] = vals
        # NpcData/SpawnX/NpcSettings/… : ignorés (hors périmètre rendu)
    return out


def render(store: TileStore, parsed: dict):
    maxx, maxy = parsed["maxx"], parsed["maxy"]
    img = Image.new("RGBA", ((maxx + 1) * TILE, (maxy + 1) * TILE), (0, 0, 0, 0))
    stats = {"drawn": 0, "fallback0": 0, "missing_set": 0}
    for (x, y), t in sorted(parsed["tiles"].items()):
        if not (0 <= x <= maxx and 0 <= y <= maxy):
            continue
        for static_k, anim_k, sset_k, aset_k in PASSES:
            idx, sheet = t[static_k], t[sset_k]
            anim_idx, anim_sheet = t[anim_k], t[aset_k]
            if anim_idx != 0:
                idx, sheet = anim_idx, anim_sheet
            if idx == 0:
                continue
            tile, note = store.image(sheet, idx)
            if tile is None:
                stats["missing_set"] += 1
                continue
            if note:
                stats["fallback0"] += 1
            img.alpha_composite(tile, (x * TILE, y * TILE))
            stats["drawn"] += 1
    return img, stats


# ----------------------------------------------------------------------- cli --
def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--tiles-dir", required=True)
    ap.add_argument("--maps", required=True, help="fichier ou dossier de .dat")
    ap.add_argument("--out", required=True)
    ap.add_argument("--scale", type=int, default=1)
    args = ap.parse_args()
    os.makedirs(args.out, exist_ok=True)
    store = TileStore(args.tiles_dir)

    if os.path.isdir(args.maps):
        files = sorted(
            os.path.join(args.maps, f) for f in os.listdir(args.maps)
            if os.path.isfile(os.path.join(args.maps, f)) and ".dat" in f.lower()
        )
    else:
        files = [args.maps]

    manifest = {"tiles_sha1": {str(k): v["sha1"] for k, v in store.sheets.items()},
                "maps": []}
    rendered = blocked = errors = 0
    for path in files:
        fname = os.path.basename(path)
        base = os.path.splitext(fname)[0]
        if base.startswith("Map-"):
            base = base[4:]
        mapid = base.rstrip("-")
        raw = open(path, "rb").read()
        entry = {"file": fname, "id": mapid, "bytes": len(raw), "sha1": sha1(raw)}
        kind = sniff(raw)
        if kind != "plain":
            entry["status"] = "encrypted-unrecoverable" if kind == "encrypted" else "unrecognized"
            blocked += kind == "encrypted"
            errors += kind != "encrypted"
            manifest["maps"].append(entry)
            continue
        try:
            parsed = parse_map(raw)
        except (ParseError, UnicodeDecodeError) as exc:
            entry.update({"status": "parse-error", "error": str(exc)[:200]})
            errors += 1
            manifest["maps"].append(entry)
            continue
        img, stats = render(store, parsed)
        if args.scale > 1:
            img = img.resize((img.width * args.scale, img.height * args.scale), Image.NEAREST)
        out_png = os.path.join(args.out, f"pmu_map_{mapid or fname}.png")
        img.save(out_png)
        entry.update({
            "status": "rendered", "version": parsed["version"],
            "name": parsed["name"], "tiles_xy": [parsed["maxx"] + 1, parsed["maxy"] + 1],
            "pixel_size": [img.width, img.height],
            "tiles_referenced": len(parsed["tiles"]), "drawn_ops": stats,
            "png": os.path.basename(out_png),
        })
        rendered += 1
        manifest["maps"].append(entry)
        print(f"[ok] {mapid or fname}  «{parsed['name']}» {img.width}x{img.height} "
              f"(dessinés {stats['drawn']}, fallbacks {stats['fallback0']})", file=sys.stderr)

    with open(os.path.join(args.out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    print(f"rendues={rendered} chiffrées/bloquées={blocked} erreurs={errors} "
          f"-> {args.out}/manifest.json", file=sys.stderr)
    return 0 if errors == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
