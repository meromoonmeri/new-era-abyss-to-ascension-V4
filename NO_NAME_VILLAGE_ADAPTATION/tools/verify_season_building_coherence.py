#!/usr/bin/env python3
"""Verrouille l'invariant : les memes maisons dans les quatre saisons.

Pourquoi ce fichier existe
--------------------------
`materialize_season_ground_x0125.py` garantit la coherence *par construction*
(une seule source de Decorations, le squelette ete) et compare une empreinte
semantique. C'est une preuve de donnee. Elle ne dit rien de l'image : une
planche PMU corrompue, un `StartFrame` decale ou un `MapLoc` deplace de 1 px
passeraient l'empreinte sans etre vus.

Ce verificateur travaille sur les PIXELS des quatre PNG publies. Pour chaque
batiment il projette le sprite de la planche a son `MapLoc`, ne retient que les
pixels ou le sprite est PLEINEMENT OPAQUE (alpha == 255) — la ou le terrain ne
peut pas transparaitre — et exige une egalite RGB stricte entre les saisons.

Les pixels semi-transparents sont volontairement exclus : le batiment y est
compose avec un terrain qui, lui, DOIT changer avec la saison. Les compter
serait un faux echec. Ils sont comptes et affiches pour que l'exclusion soit
visible et non silencieuse.

Sortie : code 0 si 0 divergence, 1 sinon. Aucun fichier n'est ecrit.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SEASONS = ("spring", "summer", "autumn", "winter")
PMU_SHEET = "NNV_rmvillage_PMU_Buildings.tile"
SKELETON = ROOT / "generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground"


def read_tile_sheet(path: Path) -> list[Image.Image]:
    raw = path.read_bytes()
    _, count = struct.unpack_from("<II", raw, 0)
    frames = []
    for index in range(count):
        _, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        frames.append(Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).convert("RGBA"))
    return frames


def sheet_hashes() -> dict[str, str]:
    out = {}
    for season in SEASONS:
        path = ROOT / f"generated/rmvillage/{season}/Content/Tile/{PMU_SHEET}"
        out[season] = hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else "ABSENT"
    return out


def decorations() -> list[dict]:
    obj = json.loads(SKELETON.read_text(encoding="utf-8-sig"))["Object"]
    placed = []
    for group in obj["Decorations"]:
        for anim in group["Anims"]:
            placed.append({
                "x": anim["MapLoc"]["X"],
                "y": anim["MapLoc"]["Y"],
                "sheet": anim["Anim"]["AnimIndex"],
                "frame": anim["Anim"]["StartFrame"],
            })
    return placed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--renders", type=Path, default=ROOT / "reports/season-coherence")
    parser.add_argument("--json", type=Path, default=None, help="ecrire le rapport ici")
    args = parser.parse_args()

    hashes = sheet_hashes()
    absent = [s for s, h in hashes.items() if h == "ABSENT"]
    identical_sheets = len(set(hashes.values())) == 1 and not absent

    images = {}
    for season in SEASONS:
        path = args.renders / f"ground_{season}.png"
        if not path.is_file():
            print(f"FAIL rendu manquant : {path}", file=sys.stderr)
            return 1
        images[season] = Image.open(path).convert("RGB")

    frames = read_tile_sheet(ROOT / f"generated/rmvillage/summer/Content/Tile/{PMU_SHEET}")
    placed = decorations()

    per_building, total_opaque, total_soft, total_div = [], 0, 0, 0
    width, height = images["summer"].size
    for index, deco in enumerate(placed):
        sprite = frames[deco["frame"]]
        pixels = sprite.load()
        opaque = soft = divergences = 0
        for sy in range(sprite.height):
            for sx in range(sprite.width):
                alpha = pixels[sx, sy][3]
                if alpha == 0:
                    continue
                x, y = deco["x"] + sx, deco["y"] + sy
                if not (0 <= x < width and 0 <= y < height):
                    continue
                if alpha < 255:
                    soft += 1
                    continue
                opaque += 1
                reference = images["summer"].getpixel((x, y))
                for season in SEASONS:
                    if images[season].getpixel((x, y)) != reference:
                        divergences += 1
        per_building.append({
            "building": index,
            "frame": deco["frame"],
            "map_loc": [deco["x"], deco["y"]],
            "sprite_px": [sprite.width, sprite.height],
            "opaque_px_compared": opaque,
            "semi_transparent_px_excluded": soft,
            "divergences": divergences,
        })
        total_opaque += opaque
        total_soft += soft
        total_div += divergences

    ok = total_div == 0 and identical_sheets and len(placed) == 6

    report = {
        "schema": "new-era.nnv-season-building-coherence.v1",
        "question": "les six maisons sont-elles pixel-identiques dans les quatre saisons ?",
        "method": "projection du sprite a son MapLoc, comparaison RGB stricte sur les pixels alpha==255",
        "buildings_declared": len(placed),
        "pmu_sheet_sha256_per_season": hashes,
        "pmu_sheet_identical_across_seasons": identical_sheets,
        "opaque_px_compared": total_opaque,
        "semi_transparent_px_excluded": total_soft,
        "divergences": total_div,
        "per_building": per_building,
        "verdict": "COHERENT" if ok else "DIVERGENT",
        "not_proven": "ce test prouve l'identite visuelle des batiments, PAS que le Ground se charge dans PMDO 0.8.12",
    }

    text = json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True)
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
