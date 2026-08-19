#!/usr/bin/env python3
"""Pose la structure du proprietaire sur le terrain rmvillage, aux 4 saisons.

Pourquoi in situ et pas une planche isolee
------------------------------------------
Une vignette sur fond uni ne dit rien de l'echelle. La seule question qui
compte est : posee a cote des six maisons PMU deja integrees, la nouvelle
structure a-t-elle la meme presence ? Cet apercu la place donc sur le vrai
terrain rmvillage rendu, avec les maisons existantes visibles dans le meme
cadre pour comparaison directe.

APERCU UNIQUEMENT. Rien n'est ecrit sous `Data/`, aucun `.rsground`, aucune
planche `.tile`, aucune Decoration ajoutee. Le terrain et les six batiments
proviennent des PNG deja publies sous `reports/season-coherence/`, qui sont
eux-memes rendus depuis les Grounds materialises.

L'emplacement d'apercu est choisi automatiquement : une zone qui ne recouvre
AUCUN des six batiments existants, verifiee par intersection de rectangles et
non pas a l'oeil.

Reechantillonnage : NEAREST exclusivement.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SEASONS = ("spring", "summer", "autumn", "winter")
SKELETON = ROOT / "generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground"
SHEET = ROOT / "generated/rmvillage/summer/Content/Tile/NNV_rmvillage_PMU_Buildings.tile"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def existing_buildings() -> list[tuple[int, int, int, int]]:
    """Rectangles occupes par les six maisons deja posees, lus dans le Ground."""
    import io
    import struct

    raw = SHEET.read_bytes()
    _, count = struct.unpack_from("<II", raw, 0)
    frames = []
    for index in range(count):
        _, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        frames.append(Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).size)

    obj = json.loads(SKELETON.read_text(encoding="utf-8-sig"))["Object"]
    boxes = []
    for group in obj["Decorations"]:
        for anim in group["Anims"]:
            width, height = frames[anim["Anim"]["StartFrame"]]
            boxes.append((anim["MapLoc"]["X"], anim["MapLoc"]["Y"], width, height))
    return boxes


def overlaps(a, b) -> bool:
    ax, ay, aw, ah = a
    bx, by, bw, bh = b
    return ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah


def find_free_slot(size, occupied, world, margin=8, step=8):
    width, height = size
    for y in range(margin, world - height - margin, step):
        for x in range(margin, world - width - margin, step):
            candidate = (x, y, width + margin, height + margin)
            if not any(overlaps(candidate, box) for box in occupied):
                return x, y
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--structure-dir", type=Path, default=ROOT / "reports/owner-structure")
    parser.add_argument("--widths", type=int, nargs="+", default=[114, 144, 176, 212])
    parser.add_argument("--renders", type=Path, default=ROOT / "reports/season-coherence")
    parser.add_argument("--out", type=Path, default=ROOT / "reports/owner-structure")
    parser.add_argument("--zoom", type=int, default=2)
    args = parser.parse_args()

    occupied = existing_buildings()
    grounds = {s: Image.open(args.renders / f"ground_{s}.png").convert("RGBA") for s in SEASONS}
    world = grounds["summer"].width

    placements = []
    slots = {}
    reserved = list(occupied)
    for width in args.widths:
        sprite = Image.open(args.structure_dir / f"core_w{width}_NEAREST.png").convert("RGBA")
        slot = find_free_slot(sprite.size, reserved, world)
        if slot is None:
            raise SystemExit(f"aucun emplacement libre pour la largeur {width}")
        slots[width] = (slot, sprite)
        reserved.append((slot[0], slot[1], sprite.width, sprite.height))
        placements.append({
            "target_width_px": width,
            "sprite_px": list(sprite.size),
            "preview_position_px": list(slot),
            "overlaps_existing_building": False,
        })

    outputs = []
    for season in SEASONS:
        canvas = grounds[season].copy()
        for width, (slot, sprite) in slots.items():
            canvas.alpha_composite(sprite, slot)
        target = args.out / f"IN_SITU_{season}.png"
        canvas.resize((world * args.zoom, world * args.zoom), Image.NEAREST).save(target)
        outputs.append({"season": season, "png": target.name, "sha256": sha256(target)})

    # planche de contact quatre saisons
    zoom = 1
    sheet = Image.new("RGBA", (world * 2 * zoom + 24, world * 2 * zoom + 24), (18, 18, 18, 255))
    for index, season in enumerate(SEASONS):
        canvas = grounds[season].copy()
        for width, (slot, sprite) in slots.items():
            canvas.alpha_composite(sprite, slot)
        sheet.alpha_composite(canvas.resize((world * zoom, world * zoom), Image.NEAREST),
                              (8 + (index % 2) * (world * zoom + 8),
                               8 + (index // 2) * (world * zoom + 8)))
    contact = args.out / "IN_SITU_ALL_SEASONS.png"
    sheet.save(contact)

    report = {
        "schema": "new-era.owner-structure-in-situ.v1",
        "stage": "PREVIEW_ONLY",
        "map_modified": False,
        "data_written_under_Data": False,
        "terrain_source": "reports/season-coherence/ground_<saison>.png (rendus des Grounds materialises)",
        "existing_buildings_boxes": [list(b) for b in occupied],
        "placements": placements,
        "seasons": outputs,
        "contact_sheet": contact.name,
        "contact_sheet_sha256": sha256(contact),
        "resampling": "NEAREST",
        "not_proven": "cet apercu montre l'echelle et l'integration visuelle ; il ne prouve ni la collision, ni le chargement PMDO 0.8.12",
    }
    (args.out / "in-situ.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({"placements": placements, "contact_sheet": contact.name},
                     indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
