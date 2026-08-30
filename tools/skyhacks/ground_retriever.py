#!/usr/bin/env python3
"""
ground_retriever.py — Récupère, rend et classe les GROUND maps d'un ROM-hack
de la galaxie SkyTemple (EoS), avec détection d'exclusivité contre le vanilla.

Pipeline (aucune pixellisation "créative", aucune approximation) :
  entrée   : dossier pret-style (files/ merge région) OU ROM .nds OU patch .ips/.xdelta
  décodage : skytemple-files (BMA/BPC/BPL/BPA de MAP_BG, bg_list.dat)
  sortie   : manifest.json + renders PNG par ground (+ GIF si animation)
             + collision PNG (1 px par tuile de 8 px du jeu)
  tri      : same_as_vanilla / MODIFIED / NEW_GROUND par sha1 des fichiers sources

Exemples :
  # catalogue des grounds vanilla (baseline)
  python3 ground_retriever.py --files /path/merged_US --out out_vanilla --baseline

  # grounds d'un hack patché, classés contre le baseline vanilla
  python3 ground_retriever.py --nds hack.nds --out out_hack \
      --baseline-manifest out_vanilla/manifest.json

  # on ne fournit qu'un .ips + une ROM de base propre :
  python3 ground_retriever.py --ips soa_patch.ips --base-nds eos.us.nds \
      --out-hack-nds /tmp/patched.nds --out out_soa --baseline-manifest van.json

Note sandbox : seule la ROM patchée (ou le patch + base) permet de traiter un
hack ; les archives distantes hors GitHub (Dropbox/Drive/Discord CDN) ne sont
pas atteignables depuis l'environnement de CI.

Dépendances : skytemple-files, pillow, ndspy (+ xdelta3 optionnel).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
from collections import OrderedDict

from PIL import Image

from skytemple_files.common.types.file_types import FileType

GROUND_DEFAULT_RE = r"^G\d"
CLASS_LABELS = {
    "G": "ground (overworld)",
    "D": "dungeon map",
    "V": "dungeon visual/fixed room",
    "S": "scene/special map",
    "H": "house/interior map",
    "P": "other MAP_BG bank",
    "W": "other MAP_BG bank",
    "T": "title/other",
}


# ---------------------------------------------------------------- providers --
class FolderProvider:
    """Racine pret-style : fichiers posés dans <root>/MAP_BG, <root>/GROUND..."""

    def __init__(self, root: str):
        self.root = root
        self._root_str = root

    def getFileByName(self, filename: str) -> bytes:  # noqa: N802 (protocole)
        path = os.path.join(self.root, *filename.split("/"))
        with open(path, "rb") as fh:
            return fh.read()

    def list_folder(self, folder: str) -> list[str]:
        base = os.path.join(self.root, *folder.split("/"))
        if not os.path.isdir(base):
            return []
        return sorted(os.listdir(base))

    @property
    def as_model_arg(self):
        # les modèles skytemple-files acceptent une racine string (plus direct)
        return self._root_str


class RomProvider:
    def __init__(self, rom):
        self.rom = rom

    def getFileByName(self, filename: str) -> bytes:  # noqa: N802
        return self.rom.getFileByName(filename)

    def list_folder(self, folder: str) -> list[str]:
        out = []
        for entry in self.rom.filenames.entries:
            name = getattr(entry, "filename", None)
            if name is not None:
                p = str(name)
                if "/" in p:
                    d, f = p.rsplit("/", 1)
                    if d.upper() == folder.upper():
                        out.append(f.lower())
        return sorted(set(out))

    @property
    def as_model_arg(self):
        return self.rom


# ------------------------------------------------------------------- patching --
def apply_ips(rom_bytes: bytearray, patch: bytes) -> None:
    """IPS (Record of... / Delta Patcher) in-place. Supporte RLE et EOF."""
    if patch[:5] == b"PATCH":
        i = 5
    else:
        i = 0
    while i < len(patch):
        if patch[i : i + 3] == b"EOF":
            break
        off = int.from_bytes(patch[i : i + 3], "big")
        size = int.from_bytes(patch[i + 3 : i + 5], "big")
        i += 5
        if size == 0:  # RLE
            rle = int.from_bytes(patch[i : i + 2], "big")
            i += 2
            rom_bytes[off : off + rle] = patch[i : i + 1] * rle
        else:
            rom_bytes[off : off + size] = patch[i : i + size]
            i += size


def apply_xdelta(patch: bytes, source: bytes) -> bytes:
    try:
        import xdelta3  # pip install python-xdelta3
    except ImportError:  # pragma: no cover
        sys.exit(
            "Le patch est un .xdelta : installez `python-xdelta3` "
            "ou appliquez-le avec un outil tiers (xdelta3 -d)."
        )
    return xdelta3.decode(patch, source)


# --------------------------------------------------------------------- utils --
def sha1(data: bytes) -> str:
    return hashlib.sha1(data).hexdigest()


def read_source_bytes(provider, name: str | None, folder: str, ext: str) -> bytes | None:
    if name is None:
        return None
    try:
        return provider.getFileByName(f"{folder}/{name.lower()}{ext}")
    except (FileNotFoundError, KeyError, OSError):
        return None


def load_bg_list(provider):
    return FileType.BG_LIST_DAT.deserialize(provider.getFileByName("MAP_BG/bg_list.dat"))


def classify(name: str) -> str:
    m = re.match(r"^([A-Z])", name.upper())
    return m.group(1) if m else "?"


# ------------------------------------------------------------------ pipeline --
def extract_ground(provider, entry, out_dirs) -> dict:
    rec = OrderedDict()
    rec["name"] = entry.bma_name
    rec["bpl"] = entry.bpl_name
    rec["bpc"] = entry.bpc_name
    rec["bpas"] = [b for b in entry.bpa_names if b is not None]
    rec["class"] = classify(entry.bma_name)
    rec["files"] = {}

    blobs = {}
    for folder, ext, key, nm in (
        ("MAP_BG", ".bma", "bma", entry.bma_name),
        ("MAP_BG", ".bpc", "bpc", entry.bpc_name),
        ("MAP_BG", ".bpl", "bpl", entry.bpl_name),
    ):
        data = read_source_bytes(provider, nm, folder, ext)
        if data is None:
            rec["error"] = f"missing {folder}/{nm.lower()}{ext}"
            return rec
        rec["files"][key] = {"ref": nm, "bytes": len(data), "sha1": sha1(data)}
        blobs[key] = data
    for j, bnm in enumerate(entry.bpa_names):
        if bnm is None:
            continue
        data = read_source_bytes(provider, bnm, "MAP_BG", ".bpa")
        if data is None:
            continue
        rec["files"][f"bpa{j}"] = {"ref": bnm, "bytes": len(data), "sha1": sha1(data)}
    rec["source_sha1_all"] = sha1(
        b"".join(rec["files"][k]["sha1"].encode() for k in sorted(rec["files"]))
    )

    arg = provider.as_model_arg
    bma = entry.get_bma(arg)
    bpc = entry.get_bpc(arg)
    bpl = entry.get_bpl(arg)
    bpas = entry.get_bpas(arg)
    rec["tiles"] = [bma.map_width_camera, bma.map_height_camera]
    rec["chunks"] = [bma.map_width_chunks, bma.map_height_chunks]
    rec["pixel_size"] = [bma.map_width_camera * 8, bma.map_height_camera * 8]
    rec["layer_count"] = int(bma.number_of_layers)
    rec["collision_layers"] = int(bma.number_of_collision_layers)

    lower = os.path.join(out_dirs["renders"], f"{entry.bma_name.lower()}_frame0.png")
    try:
        frames = bma.to_pil(bpc, bpl, bpas, include_collision=False,
                            include_unknown_data_block=False, pal_ani=False)
    except Exception as exc:  # noqa: BLE001 — on journalise l'échec, jamais de PNG bidon
        rec["error"] = f"render failed: {exc!r}"
        return rec
    frames[0].convert("RGB").save(lower)
    rec["render"] = os.path.relpath(lower, out_dirs["root"])
    rec["frames"] = len(frames)
    if len(frames) > 1:
        gif = os.path.join(out_dirs["renders"], f"{entry.bma_name.lower()}_anim.gif")
        try:
            imgs = [f.convert("RGB") for f in frames]
            imgs[0].save(gif, save_all=True, append_images=imgs[1:], duration=100, loop=0)
            rec["anim_gif"] = os.path.relpath(gif, out_dirs["root"])
        except Exception:  # noqa: BLE001
            pass

    if bma.collision is not None:
        w, h = bma.map_width_camera, bma.map_height_camera
        img = Image.new("L", (w, h))
        px = img.load()
        for y in range(h):
            for x in range(w):
                i = y * w + x
                px[x, y] = 255 if (i < len(bma.collision) and bma.collision[i]) else 0
        cp = os.path.join(out_dirs["collision"], f"{entry.bma_name.lower()}_collision.png")
        img.save(cp)
        rec["collision_png"] = os.path.relpath(cp, out_dirs["root"])
        rec["solid_tiles"] = sum(1 for v in bma.collision if v)
    return rec


def orphan_ground_files(provider, bg_list) -> list[str]:
    """Fichiers MAP_BG/g*.bma présents hors bg_list.dat (le hack en ajoute parfois)."""
    files = provider.list_folder("MAP_BG")
    on_disk = {f for f in files if re.match(r"^g\d.*\.bma$", f)}
    referenced = {f"{e.bma_name.lower()}.bma" for e in bg_list.level}
    return sorted(on_disk - referenced)


def main() -> int:
    ap = argparse.ArgumentParser()
    src = ap.add_argument_group("source (au choix)")
    src.add_argument("--files", help="racine pret-style (MAP_BG/, GROUND/...)")
    src.add_argument("--nds", help="ROM .nds (propre ou déjà patchée)")
    src.add_argument("--ips", help="patch .ips/.bps brut à appliquer")
    src.add_argument("--base-nds", help="ROM propre pour --ips")
    src.add_argument("--out-hack-nds", help="écrit la ROM patchée ici (facultatif)")
    ap.add_argument("--out", required=True, help="dossier de sortie")
    ap.add_argument("--ground-pattern", default=GROUND_DEFAULT_RE,
                    help="regex sur bma_name, défaut '^G\\d'")
    ap.add_argument("--baseline-manifest", help="manifest.json vanilla pour classer les écarts")
    ap.add_argument("--baseline", action="store_true",
                    help="mode baseline : sha1 seulement, pas de rendu")
    args = ap.parse_args()

    os.makedirs(args.out, exist_ok=True)
    out_dirs = {
        "root": args.out,
        "renders": os.path.join(args.out, "renders"),
        "collision": os.path.join(args.out, "collision"),
    }
    if not args.baseline:
        os.makedirs(out_dirs["renders"], exist_ok=True)
        os.makedirs(out_dirs["collision"], exist_ok=True)

    # --- résolution de la source
    rom_path = args.nds
    if args.ips:
        patch = open(args.ips, "rb").read()
        if not args.base_nds:
            sys.exit("--ips exige --base-nds (ROM propre du bon région).")
        base = bytearray(open(args.base_nds, "rb").read())
        if patch[:5] == b"PATCH" or patch[:5] == b"bpsP1":
            if patch[:5] != b"PATCH":
                sys.exit("Format .bps non supporté ; convertissez en .ips ou utilisez xdelta.")
            apply_ips(base, patch)
        else:
            out = apply_xdelta(patch, bytes(base))
            base = bytearray(out)
        rom_path = args.out_hack_nds or os.path.join(args.out, "hacked.nds")
        with open(rom_path, "wb") as fh:
            fh.write(bytes(base))
        print(f"[patch] écrit : {rom_path}", file=sys.stderr)
    if rom_path:
        import ndspy.rom

        provider = RomProvider(ndspy.rom.NintendoDSRom.fromFile(rom_path))
    elif args.files:
        provider = FolderProvider(args.files)
    else:
        sys.exit("Indiquez --files, --nds ou --ips (+--base-nds).")

    bg_list = load_bg_list(provider)
    pattern = re.compile(args.ground_pattern, re.IGNORECASE)
    entries = [e for e in bg_list.level if pattern.match(e.bma_name.upper() if isinstance(e.bma_name, str) else str(e.bma_name))]

    base_index = {}
    if args.baseline_manifest and os.path.exists(args.baseline_manifest):
        van = json.load(open(args.baseline_manifest))
        base_index = {g["name"]: g.get("source_sha1_all") for g in van.get("grounds", [])}

    grounds = []
    for e in entries:
        print(f"[{len(grounds) + 1}/{len(entries)}] {e.bma_name}", file=sys.stderr)
        if args.baseline:
            rec = OrderedDict()
            rec["name"] = e.bma_name
            rec["files"] = {}
            for folder, ext, key, nm in (
                ("MAP_BG", ".bma", "bma", e.bma_name),
                ("MAP_BG", ".bpc", "bpc", e.bpc_name),
                ("MAP_BG", ".bpl", "bpl", e.bpl_name),
            ):
                data = read_source_bytes(provider, nm, folder, ext)
                if data is not None:
                    rec["files"][key] = {"ref": nm, "bytes": len(data), "sha1": sha1(data)}
            for j, bnm in enumerate(e.bpa_names):
                if bnm is None:
                    continue
                data = read_source_bytes(provider, bnm, "MAP_BG", ".bpa")
                if data is not None:
                    rec["files"][f"bpa{j}"] = {"ref": bnm, "bytes": len(data), "sha1": sha1(data)}
            rec["source_sha1_all"] = sha1(
                b"".join(rec["files"][k]["sha1"].encode() for k in sorted(rec["files"]))
            )
            grounds.append(rec)
            continue
        grounds.append(extract_ground(provider, e, out_dirs))

    # --- classification exclusivité
    summary = {"same_as_vanilla": 0, "MODIFIED": 0, "NEW_GROUND": 0, "error": 0}
    for g in grounds:
        if "error" in g:
            g["status"] = "error"
            summary["error"] += 1
            continue
        if base_index:
            base_hash = base_index.get(g["name"])
            if base_hash is None:
                g["status"] = "NEW_GROUND"
            elif base_hash != g.get("source_sha1_all"):
                g["status"] = "MODIFIED"
            else:
                g["status"] = "same_as_vanilla"
            summary[g["status"]] += 1
        else:
            g["status"] = "unclassified"

    manifest = OrderedDict()
    manifest["source"] = os.path.abspath(rom_path or args.files)
    manifest["ground_pattern"] = args.ground_pattern
    manifest["bg_list_total_entries"] = len(bg_list.level)
    manifest["all_classes"] = {
        c: sum(1 for e in bg_list.level if classify(str(e.bma_name)) == c)
        for c in sorted({classify(str(e.bma_name)) for e in bg_list.level})
    }
    manifest["orphan_bma_on_disk"] = orphan_ground_files(provider, bg_list)
    manifest["summary"] = summary
    manifest["grounds"] = grounds
    with open(os.path.join(args.out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1, sort_keys=False)
    print(f"OK grounds={len(grounds)} summary={summary} -> {args.out}/manifest.json",
          file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
