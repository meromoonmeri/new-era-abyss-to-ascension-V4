#!/usr/bin/env python3
"""Convertit les 11 rooms NO_PROOF en Grounds PMDO normalises x0,125.

Le blocage
----------
57 entites de faune sont retenues `NO_PROOF` avec ce motif : "ni rendu ni
collision". Le rendu a ete produit (`reports/noproof-rooms/`, 11/11 rooms,
152 creatures, 0 sans Pokemon). Restent la conversion en Ground PMDO et la
collision 8 px.

Chaine appliquee, par room
--------------------------
1. `convert_environment_room.py` : Ground natif 4992 px, TexSize 8, grille de
   collision 624, planche `.tile` de cellules 64 px. Tous les layers source
   preserves, mapping identite, aucun reechantillonnage.
2. Normalisation x0,125, exactement les regles deja validees et versionnees
   dans `apply_nnv_normalisation.py` :
       cellule de tuile   64 -> 8 px      (NEAREST, 0 couleur inventee)
       TexSize             8 -> 1
       grille de collision 624 -> 78      (regle MAJORITE sur chaque bloc 8x8)
       monde            4992 -> 624 px
       positions d'entites  /8
   La regle de majorite n'est pas reinventee ici : elle est importee du module
   deja en place, pour qu'une divergence soit impossible.

Fail-closed
-----------
Toute room dont la collision, la geometrie ou la palette ne se verifie pas
apres coup est marquee `FAILED` et n'est pas comptee comme convertie. Les
blockers du convertisseur (faune non liee, transitions non resolues, couches
Effect) sont conserves tels quels : ils ne sont ni filtres ni minimises.

Ce que cet outil ne fait PAS
----------------------------
Il n'ecrit rien sous `Data/`, ne promeut aucune entite, ne modifie aucun
manifeste de promotion. Les Grounds (~47 Mo piece avant normalisation) restent
hors Git, sous `.runtime-cache/`. Seuls les rapports et les hashes sont
versionnes.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import importlib.util
import io
import json
import subprocess
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
TOOLS = ROOT / "tools"

NOPROOF_ROOMS = ("rm38", "rm47", "rm48", "rm49", "rm57", "rm68", "rm77",
                 "rmcave1", "rmcave1_0", "rmcave1_1", "rmcave1_2")

FACTOR = 8
NEW_TEX_SIZE = 1
NEW_CELL_PX = 8


def load_normaliser():
    """Importe les regles de normalisation deja validees, sans les recopier."""
    spec = importlib.util.spec_from_file_location(
        "apply_nnv_normalisation", TOOLS / "apply_nnv_normalisation.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules["apply_nnv_normalisation"] = module
    spec.loader.exec_module(module)
    for name, expected in (("FACTOR", FACTOR), ("NEW_TEX_SIZE", NEW_TEX_SIZE),
                           ("NEW_CELL_PX", NEW_CELL_PX)):
        if getattr(module, name) != expected:
            raise SystemExit(f"regle de normalisation divergente : {name}")
    return module


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def convert_room(room: str, season: str, outdir: Path, texture_cache: Path) -> dict:
    target = outdir / room
    result = subprocess.run(
        [sys.executable, str(TOOLS / "convert_environment_room.py"),
         "--room", room, "--season", season,
         "--texture-cache", str(texture_cache),
         "--output", str(target)],
        capture_output=True, text=True)
    if result.returncode != 0:
        return {"room": room, "status": "FAILED", "stage": "convert",
                "stderr": result.stderr.strip()[-800:]}
    return {"room": room, "status": "CONVERTED", "output": target,
            "manifest": json.loads((target / "manifest.json").read_text())}


def verify_normalised(ground: Path, tile: Path) -> dict:
    obj = json.loads(ground.read_text(encoding="utf-8-sig"))["Object"]
    grid = len(obj["obstacles"])
    tiles = len(obj["Layers"][0]["Tiles"])
    blocked = sum(1 for column in obj["obstacles"] for cell in column if cell["Tags"])

    import struct
    raw = tile.read_bytes()
    cell_px, count = struct.unpack_from("<II", raw, 0)
    sizes = set()
    for index in range(min(count, 64)):
        _, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        sizes.add(Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).size)

    return {
        "tex_size": obj["TexSize"],
        "collision_grid": grid,
        "tile_grid": tiles,
        "world_px": grid * NEW_CELL_PX,
        "blocked_cells_8px": blocked,
        "blocked_ratio": round(blocked / max(1, grid * grid), 4),
        "tile_cell_px": cell_px,
        "tile_sprite_sizes_sampled": sorted(f"{w}x{h}" for w, h in sizes),
        "geometry_conforms": (obj["TexSize"] == NEW_TEX_SIZE and grid == tiles
                              and cell_px == NEW_CELL_PX and grid * NEW_CELL_PX == 624),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--rooms", nargs="+", default=list(NOPROOF_ROOMS))
    parser.add_argument("--season", default="summer")
    parser.add_argument("--outdir", type=Path, default=REPO / ".runtime-cache/nnv-noproof-grounds")
    parser.add_argument("--texture-cache", type=Path,
                        default=REPO / ".runtime-cache/nnv-official-textures")
    parser.add_argument("--report", type=Path, default=ROOT / "reports/noproof-rooms/CONVERSION.json")
    args = parser.parse_args()

    normaliser = load_normaliser()
    args.outdir.mkdir(parents=True, exist_ok=True)

    rooms = []
    for room in args.rooms:
        print(f"[{room}] conversion...", flush=True)
        converted = convert_room(room, args.season, args.outdir, args.texture_cache)
        if converted["status"] == "FAILED":
            print(f"[{room}] ECHEC conversion")
            rooms.append(converted)
            continue

        target = converted["output"]
        ground = target / f"Data/Ground/nnv_{room}_{args.season}.rsground"
        tiles = sorted((target / "Content/Tile").glob("*.tile"))

        before = {
            "ground_sha256": sha256_file(ground),
            "tex_size": json.loads(ground.read_text(encoding="utf-8-sig"))["Object"]["TexSize"],
        }

        print(f"[{room}] normalisation x0,125...", flush=True)
        tileset_report, ground_report, issues = {}, {}, []
        try:
            for tile in tiles:
                normaliser.shrink_tileset(tile, tileset_report)
            normaliser.transform_ground(ground, ground_report, issues)
        except Exception as error:  # fail-closed : on rapporte, on ne corrige pas
            rooms.append({"room": room, "status": "FAILED", "stage": "normalise",
                          "error": f"{type(error).__name__}: {error}"})
            print(f"[{room}] ECHEC normalisation : {error}")
            continue

        checks = verify_normalised(ground, tiles[0])
        manifest = converted["manifest"]
        record = {
            "room": room,
            "season": args.season,
            "status": "CONVERTED_NORMALISED" if checks["geometry_conforms"] else "FAILED",
            "stage": "verify" if not checks["geometry_conforms"] else None,
            "source_checks": manifest["checks"],
            "source_collision_metrics": manifest["collision_metrics"],
            "converter_blockers": manifest["blockers"],
            "normalisation": {
                "factor": 0.125,
                "resample": "NEAREST",
                "collision_rule": "MAJORITE >= 32/64 par bloc 8x8",
                "rules_imported_from": "tools/apply_nnv_normalisation.py",
                "tilesets": tileset_report,
                "ground": ground_report,
                "entity_issues": issues,
            },
            "after": checks,
            "ground_sha256_before_normalisation": before["ground_sha256"],
            "ground_sha256_after_normalisation": sha256_file(ground),
            "ground_path": str(ground.relative_to(REPO)),
            "ground_tracked_in_git": False,
        }
        rooms.append(record)
        print(f"[{room}] {record['status']}  monde {checks['world_px']}px  "
              f"collision {checks['collision_grid']}  bloquees {checks['blocked_cells_8px']}",
              flush=True)

    converted_ok = [r for r in rooms if r["status"] == "CONVERTED_NORMALISED"]
    report = {
        "schema": "new-era.nnv-noproof-conversion.v1",
        "question": "les 11 rooms NO_PROOF peuvent-elles devenir des Grounds PMDO avec collision ?",
        "rooms_requested": len(args.rooms),
        "rooms_converted_and_normalised": len(converted_ok),
        "rooms_failed": [r["room"] for r in rooms if r["status"] == "FAILED"],
        "geometry_target": {"world_px": 624, "tex_size": 1, "collision_grid": 78,
                            "tile_cell_px": 8},
        "rooms": rooms,
        "promotion_allowed": False,
        "why_promotion_still_refused": (
            "la conversion et la collision existent maintenant, mais les blockers du "
            "convertisseur restent ouverts (faune non liee au moteur, transitions non "
            "resolues, couches Effect non portees) et le runtime PMDO 0.8.12 n'a jamais "
            "ete execute : ni dotnet ni mono disponibles"),
        "runtime_status": "NOT_CERTIFIED",
        "grounds_tracked_in_git": False,
        "grounds_location": ".runtime-cache/nnv-noproof-grounds (hors Git, reproductible)",
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("rooms_requested", "rooms_converted_and_normalised", "rooms_failed")},
                     indent=2))
    return 0 if not report["rooms_failed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
