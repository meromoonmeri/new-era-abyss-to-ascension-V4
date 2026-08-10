"""CLI de décodage : extracted/ → decoded/ (avec provenance).

Usage :
  python -m nds2pmdo decode            # tout décoder
  python -m nds2pmdo decode --scope dungeon|graphics|sound|ground
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from . import __version__
from .blue.graphics import decode_all_graphics
from .blue.mapparam import decode_mapparam
from .blue.sdat import Sdat
from .config import (DECODED_DIR, EXTRACTED_DUNGEON_PACK, EXTRACTED_DIR,
                     EXTRACTED_FS)
from .provenance import Provenance


def decode_dungeon() -> dict:
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    dec = decode_mapparam(mp)
    out = DECODED_DIR / "dungeon"
    out.mkdir(parents=True, exist_ok=True)
    # les octets bruts (blobs) des tables restent accessibles pour traçabilité
    report = {
        "converter": "nds2pmdo", "version": __version__,
        "provenance": Provenance.SOURCE_NDS.value,
        "source": "dungeon.sbin/mapparam",
        "floor_ids": dec["floor_ids"],
        "floor_properties": dec["floor_properties"],
        "spawns": dec["spawns"],
        "item_tables": dec["item_tables"],
        "trap_tables": dec["trap_tables"],
        "spawn_ptr_count": dec["spawn_ptr_count"],
        "unknowns": [
            "per-item ID mapping within item table streams (categories + poids cumulés SOURCE_NDS, IDs items non présents dans le flux)",
            "trap name for index 17 (poids 10000) — nom non démontré dans la ROM",
            "semantics of canm animations",
        ],
    }
    (out / "mapparam.json").write_text(json.dumps(report, indent=1, ensure_ascii=False))
    return report


def decode_graphics() -> dict:
    return decode_all_graphics(EXTRACTED_DUNGEON_PACK, DECODED_DIR / "dungeon" / "graphics")


def decode_sound() -> dict:
    sd = Sdat.open((EXTRACTED_FS / "sound.sbin").read_bytes())
    out = DECODED_DIR / "sound"
    out.mkdir(parents=True, exist_ok=True)
    names = sd.seq_names()
    # vérification contre le ground truth committé (docs/sinister_woods_nds) :
    # ordre des noms non-nuls (l'indexation exacte des trous reste UNKNOWN)
    legacy = Path(__file__).resolve().parents[1] / "docs" / "sinister_woods_nds" \
        / "sdat_seq_names.json"
    match = None
    if legacy.exists():
        gt = json.loads(legacy.read_text())
        gt_vals = [v for v in gt.values() if v is not None]
        mine = [n for n in names if n is not None
                and n.startswith(("SND_BGM_M", "SND_ME_M"))]
        match = gt_vals == mine
    full = sd.parse_full()
    made = sd.extract_files(out / "files")
    report = {
        "converter": "nds2pmdo", "version": __version__,
        "provenance": Provenance.SOURCE_NDS.value,
        "source": "sound.sbin (SDAT)",
        "seq_names": {str(i): n for i, n in enumerate(names)},
        "ground_truth_match_docs_sinister_woods_nds": match,
        "full_chain": full,
        "extracted_files": made,
        "unknowns": full["unknowns"],
    }
    (out / "sdat.json").write_text(json.dumps(report, indent=1, ensure_ascii=False))
    return report


def decode_ground() -> dict:
    from .rom.pack import parse_pack
    gs = (EXTRACTED_FS / "ground.sbin").read_bytes()
    entries = parse_pack(gs)
    out = DECODED_DIR / "ground"
    out.mkdir(parents=True, exist_ok=True)
    inv = {
        "converter": "nds2pmdo", "version": __version__,
        "provenance": Provenance.SOURCE_NDS.value,
        "source": "ground.sbin",
        "entry_count": len(entries),
        "entries": [{"name": e.name, "offset": e.offset, "size": e.size,
                     "absolute": e.absolute} for e in entries],
    }
    (out / "ground_pack_inventory.json").write_text(
        json.dumps(inv, indent=1, ensure_ascii=False))
    return inv


def main() -> int:
    ap = argparse.ArgumentParser(prog="nds2pmdo decode")
    ap.add_argument("--scope", default="all",
                    choices=["all", "dungeon", "graphics", "sound", "ground"])
    args = ap.parse_args()
    if not EXTRACTED_DIR.exists():
        print("ERROR: extracted/ absent. Lancez d'abord: python -m nds2pmdo extract",
              file=sys.stderr)
        return 2
    DECODED_DIR.mkdir(parents=True, exist_ok=True)
    results = {}
    if args.scope in ("all", "dungeon"):
        results["dungeon"] = decode_dungeon()
        print("décodé: dungeon/mapparam.json")
    if args.scope in ("all", "graphics"):
        g = decode_graphics()
        n = sum(1 for v in g.values() if isinstance(v, dict)
                and v.get("status") == "SOURCE_NDS_DECODED")
        print(f"décodé: graphics ({n} blobs AT4PX décompressés) → decoded/dungeon/graphics/")
    if args.scope in ("all", "sound"):
        s = decode_sound()
        print(f"décodé: sound/sdat.json ({len(s['seq_names'])} noms SEQ)")
    if args.scope in ("all", "ground"):
        g = decode_ground()
        print(f"décodé: ground/ground_pack_inventory.json ({g['entry_count']} entrées)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
