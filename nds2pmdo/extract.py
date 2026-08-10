"""CLI d'extraction : ROM APHP → extracted/.

Usage :
  python -m nds2pmdo extract            # extraction complète (FS + packs)
  python -m nds2pmdo extract --verify   # vérifie la ROM puis s'arrête
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path

from . import __version__
from .config import (EXTRACTED_DUNGEON_PACK, EXTRACTED_DIR, EXTRACTED_FS,
                     EXPECTED_ROM, ROM_PATH, SOURCE_DIR)
from .rom.nds_fs import NdsRom
from .rom.pack import parse_pack, unpack_pack


def verify_rom(data: bytes) -> dict:
    checks = {
        "gamecode": data[0x0C:0x10].decode('ascii', 'replace'),
        "makercode": data[0x10:0x12].decode('ascii', 'replace'),
        "size": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
    }
    ok = (checks["gamecode"] == EXPECTED_ROM["gamecode"]
          and checks["makercode"] == EXPECTED_ROM["makercode"]
          and checks["size"] == EXPECTED_ROM["size"]
          and checks["sha256"] == EXPECTED_ROM["sha256"])
    return {"checks": checks, "expected": EXPECTED_ROM, "match": ok}


def main() -> int:
    ap = argparse.ArgumentParser(prog="nds2pmdo extract")
    ap.add_argument("--rom", default=str(ROM_PATH), help="chemin vers la ROM .nds")
    ap.add_argument("--verify", action="store_true",
                    help="vérifie la ROM puis s'arrête (sans extraire)")
    args = ap.parse_args()

    rom_path = Path(args.rom)
    if not rom_path.exists():
        print(f"ERROR: ROM introuvable: {rom_path}", file=sys.stderr)
        print("La seule référence source est https://github.com/meromoonmeri/POKEMON-ROM",
              file=sys.stderr)
        return 2

    rom = NdsRom.open(rom_path)
    v = verify_rom(rom.data)
    print(f"ROM: {rom.gamecode} ({rom.makercode}) {len(rom.data)} octets")
    print(f"sha256: {v['checks']['sha256']}")
    print(f"match attendu: {v['match']}")
    if not v["match"]:
        print("ERROR: la ROM ne correspond pas à la référence APHP attendue.", file=sys.stderr)
        return 2
    if args.verify:
        return 0

    # 1) système de fichiers NDS : fichiers FNT nommés + entrées FAT brutes
    files = rom.extract_all(EXTRACTED_FS)
    raw_dir = EXTRACTED_FS / "raw_fat"
    raw_dir.mkdir(parents=True, exist_ok=True)
    fat_entries = []
    off = rom.fat_offset
    while off + 8 <= len(rom.data):
        start, end = struct.unpack_from('<II', rom.data, off)
        if end < start or end > len(rom.data):
            break
        fat_entries.append((start, end))
        off += 8
    fat_manifest = {"converter": "nds2pmdo", "version": __version__,
                    "rom_sha256": v["checks"]["sha256"], "entries": []}
    for fid, (start, end) in enumerate(fat_entries):
        blob = rom.data[start:end]
        (raw_dir / f"fat_{fid:03d}.bin").write_bytes(blob)
        fat_manifest["entries"].append({
            "id": fid, "start": start, "end": end, "size": len(blob),
            "sha256": hashlib.sha256(blob).hexdigest()})
    (EXTRACTED_FS / "fat_manifest.json").write_text(
        json.dumps(fat_manifest, indent=1, ensure_ascii=False))
    print(f"Fichiers extraits (FNT/FAT): {len(files)} nommés + {len(fat_entries)} FAT bruts")

    # 2) dungeon.sbin → pack nommé (mapparam, bXX*, zmappat, trappat, talkp*, …)
    ds = rom.get("dungeon.sbin")
    if ds is None:
        print("ERROR: dungeon.sbin absent de la ROM", file=sys.stderr)
        return 2
    EXTRACTED_DUNGEON_PACK.mkdir(parents=True, exist_ok=True)
    entries = parse_pack(ds)
    manifest = {"converter": "nds2pmdo", "version": __version__,
                "rom_sha256": v["checks"]["sha256"],
                "container": "dungeon.sbin",
                "container_absolute": rom.get("dungeon.sbin").start if False else None,
                "entries": []}
    for e in entries:
        blob = ds[e.offset:e.end]
        (EXTRACTED_DUNGEON_PACK / e.name).write_bytes(blob)
        manifest["entries"].append({
            "name": e.name, "offset": e.offset, "size": e.size,
            "sha256": hashlib.sha256(blob).hexdigest()})
    (EXTRACTED_DUNGEON_PACK / "manifest.json").write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False))
    print(f"dungeon.sbin: {len(entries)} entrées → extracted/dungeon_pack/")

    # 3) ground.sbin → pack nommé (A01P01*, B10P01*, …)
    gs = rom.get("ground.sbin")
    if gs is not None:
        gentries = parse_pack(gs)
        unpack_pack(gs, EXTRACTED_DIR / "ground_pack")
        print(f"ground.sbin: {len(gentries)} entrées → extracted/ground_pack/")

    # 4) pointeur de source
    SOURCE_DIR.mkdir(parents=True, exist_ok=True)
    (SOURCE_DIR / "ROM.pointer").write_text(
        f"# Source de vérité (seule référence) : https://github.com/meromoonmeri/POKEMON-ROM\n"
        f"rom_path: {rom_path}\n"
        f"gamecode: {rom.gamecode}\n"
        f"sha256: {v['checks']['sha256']}\n"
        f"note: la ROM n'est jamais copiée dans ce dépôt.\n")
    print("Extraction terminée.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
