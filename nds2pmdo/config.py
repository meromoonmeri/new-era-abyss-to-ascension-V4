"""Configuration des chemins du pipeline nds2pmdo.

Séparation stricte des états :
  source/     → pointeur vers la ROM (la ROM elle-même reste dans NDS_ROOT, hors dépôt)
  extracted/  → fichiers bruts extraits de la ROM (regénérables, gitignorés)
  decoded/    → données décompressées/décodées (artefacts ground truth, committés)
  manifest/   → manifests de mapping NDS ↔ PMDO (committés)
  generated/  → contenu PMDO 0.8.12 généré (committé)
  validation/ → rendus de comparaison, diff, rapports (committés)
"""
from __future__ import annotations

import os
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[0]  # nds2pmdo/ = repo convertisseur autonome

# Source
SOURCE_DIR = REPO_ROOT / "source"
# ROM (hors dépôt, fournie par l'utilisateur — seule référence : meromoonmeri/POKEMON-ROM)
NDS_ROOT = Path(os.environ.get("NDS_ROOT", "/home/user/nds_sources"))
ROM_REL = Path(os.environ.get(
    "NDS_ROM_REL",
    "POKEMON-ROM/Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds"))
ROM_PATH = Path(os.environ.get("NDS_ROM", str(NDS_ROOT / ROM_REL)))

EXPECTED_ROM = {
    "gamecode": "APHP",
    "makercode": "01",
    "size": 33_554_432,
    "sha256": "2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05",
}

# États
EXTRACTED_DIR = REPO_ROOT / "extracted"
EXTRACTED_FS = EXTRACTED_DIR / "fs"                 # système de fichiers NDS complet
EXTRACTED_DUNGEON_PACK = EXTRACTED_DIR / "dungeon_pack"   # entrées dungeon.sbin (brutes)
DECODED_DIR = REPO_ROOT / "decoded"
MANIFEST_DIR = REPO_ROOT / "manifest"
GENERATED_DIR = REPO_ROOT / "generated"
VALIDATION_DIR = REPO_ROOT / "validation"
DOCS_DIR = REPO_ROOT / "docs"
TESTS_DIR = REPO_ROOT / "tests"
