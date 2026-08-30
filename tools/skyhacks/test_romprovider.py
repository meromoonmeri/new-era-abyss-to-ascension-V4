#!/usr/bin/env python3
"""Test de ground_retriever en mode « ROM » sans ROM officielle.

Construit un faux objet de type ROM (API ndspy minimale : getFileByName +
filenames) branché sur le dossier pret-style vanilla, et vérifie que le
pipeline produit exactement le même manifest que le mode --files.

But : valider la branche RomProvider (celle qui sera utilisée sur le .nds
d'un hack réel, p. ex. Seal of Ancients) sans dépendre d'un dump NDS.

Usage : python3 test_romprovider.py <racine_merged_US> <out_dir>
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import types

HERE = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.join(HERE, "ground_retriever.py")


def main() -> int:
    root, out = sys.argv[1], sys.argv[2]
    os.makedirs(out, exist_ok=True)

    # 1) référence : mode dossier
    a = os.path.join(out, "run_folder")
    subprocess.run([sys.executable, TOOL, "--files", root, "--out", a, "--baseline"], check=True)

    # 2) même source via un faux ROM-provider
    import importlib.util

    spec = importlib.util.spec_from_file_location("gr", TOOL)
    gr = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(gr)

    class FakeFolderTable:
        def __init__(self, root):
            self.root = root

        @property
        def entries(self):
            for folder in sorted(os.listdir(self.root)):
                p = os.path.join(self.root, folder)
                if not os.path.isdir(p):
                    continue
                for f in sorted(os.listdir(p)):
                    if os.path.isfile(os.path.join(p, f)):
                        yield types.SimpleNamespace(filename=f"{folder}/{f}")

    class FakeRom:
        def __init__(self, root):
            self.root = root
            self.filenames = FakeFolderTable(root)

        def getFileByName(self, name):  # noqa: N802
            with open(os.path.join(self.root, *name.split("/")), "rb") as fh:
                return fh.read()

    rom = FakeRom(root)
    provider = gr.RomProvider(rom)
    bg_list = gr.load_bg_list(provider)
    import re

    pattern = re.compile(gr.GROUND_DEFAULT_RE, re.IGNORECASE)
    entries = [e for e in bg_list.level if pattern.match(str(e.bma_name).upper())]
    out_root = os.path.join(out, "run_rom")
    out_dirs = {
        "root": out_root,
        "renders": os.path.join(out_root, "renders"),
        "collision": os.path.join(out_root, "collision"),
    }
    os.makedirs(out_dirs["renders"], exist_ok=True)
    os.makedirs(out_dirs["collision"], exist_ok=True)
    recs = []
    for e in entries:
        recs.append(gr.extract_ground(provider, e, out_dirs))

    folder_manifest = json.load(open(os.path.join(a, "manifest.json")))
    folder_hashes = {g["name"]: g["source_sha1_all"] for g in folder_manifest["grounds"] if "source_sha1_all" in g}
    rom_hashes = {g["name"]: g.get("source_sha1_all") for g in recs if "source_sha1_all" in g}
    ok = folder_hashes == rom_hashes and len(recs) == len(entries)
    errors = [g["name"] for g in recs if "error" in g]
    print(f"grounds rom-mode : {len(recs)}, hashes identiques au mode dossier : {ok}, erreurs : {errors}")
    print("PASS" if ok and not errors else "FAIL")
    return 0 if (ok and not errors) else 1


if __name__ == "__main__":
    sys.exit(main())
