"""CLI d'audit : état réel de la reconstruction source (gates + couverture).

Usage :
  python -m nds2pmdo audit            # audit complet
  python -m nds2pmdo audit --json     # sortie JSON dans validation/
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

from . import __version__
from .config import (DECODED_DIR, EXTRACTED_DIR, EXTRACTED_DUNGEON_PACK,
                     EXTRACTED_FS, EXPECTED_ROM, ROM_PATH, VALIDATION_DIR)
from .provenance import Provenance

CHECKOUT = Path(__file__).resolve().parents[1]
LEGACY = CHECKOUT / "docs" / "sinister_woods_nds"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def audit_source_fidelity() -> dict:
    """A. FIDÉLITÉ SOURCE — ce qui est prouvé SOURCE_NDS vs UNKNOWN."""
    A = {}
    # ROM
    if ROM_PATH.exists():
        data = ROM_PATH.read_bytes()
        A["rom"] = {
            "gamecode": data[0x0C:0x10].decode('ascii', 'replace'),
            "size": len(data),
            "sha256": sha256(data),
            "match_expected": sha256(data) == EXPECTED_ROM["sha256"],
            "provenance": Provenance.SOURCE_NDS.value,
        }
    else:
        A["rom"] = {"status": Provenance.MISSING.value}
    # extraction
    A["extraction"] = {
        "dungeon_pack_present": (EXTRACTED_DUNGEON_PACK / "mapparam").exists(),
        "ground_pack_present": (EXTRACTED_DIR / "ground_pack").exists(),
        "sound_present": (EXTRACTED_FS / "sound.sbin").exists(),
        "provenance": Provenance.SOURCE_NDS.value,
    }
    # mapparam décodé
    mp_json = DECODED_DIR / "dungeon" / "mapparam.json"
    if mp_json.exists():
        dec = json.loads(mp_json.read_text())
        A["mapparam"] = {
            "floor_id_table": "PASS" if len(dec["floor_ids"]) == 13 else "FAIL",
            "floor_properties": "PASS" if len(dec["floor_properties"]) == 13 else "FAIL",
            "spawn_tables": "PASS" if dec["spawn_ptr_count"] > 0 else "FAIL",
            "item_tables": "PARTIAL (poids SOURCE_NDS, IDs UNKNOWN)",
            "trap_tables": "PARTIAL (u16 bruts SOURCE_NDS, noms UNKNOWN)",
        }
    else:
        A["mapparam"] = {"status": "MISSING — lancer decode"}
    # graphiques
    gfx_report = DECODED_DIR / "dungeon" / "graphics" / "graphics_report.json"
    if gfx_report.exists():
        g = json.loads(gfx_report.read_text())
        blobs = {k: v for k, v in g.items() if isinstance(v, dict)}
        decoded = [k for k, v in blobs.items() if v.get("status") == "SOURCE_NDS_DECODED"]
        A["graphics"] = {
            "blob_count": len(blobs),
            "decoded_count": len(decoded),
            "b41_fon_decoded": blobs.get("b41fon", {}).get("status"),
            "b41_canm": blobs.get("b41canm", {}).get("status"),
            "b41_pal": blobs.get("b41pal", {}).get("status"),
        }
    else:
        A["graphics"] = {"status": "MISSING — lancer decode"}
    # son
    sdat = DECODED_DIR / "sound" / "sdat.json"
    if sdat.exists():
        s = json.loads(sdat.read_text())
        fc = s.get("full_chain", {})
        sseq = {f["file_id"] for f in fc.get("fat", []) if f.get("magic") == "SSEQ"}
        chain_ok = all(e.get("hole") or e.get("file_id") in sseq
                       for e in fc.get("seq", []))
        A["sound"] = {
            "seq_names": "PASS" if s.get("ground_truth_match_docs_sinister_woods_nds")
            else "FAIL",
            "seq_chain_to_sseq": "PASS" if chain_ok else "FAIL",
            "seq_holes_preserved": fc.get("seq_hole_count"),
            "sseq_files": len(sseq),
            "bgmusic_to_seq": "UNKNOWN (table dans le code ARM9)",
        }
    else:
        A["sound"] = {"status": "MISSING — lancer decode"}
    # ground pack
    ginv = DECODED_DIR / "ground" / "ground_pack_inventory.json"
    if ginv.exists():
        g = json.loads(ginv.read_text())
        names = [e["name"] for e in g["entries"]]
        A["ground_pack"] = {
            "entry_count": g["entry_count"],
            "b10p01_present": any(n.startswith("B10P01") for n in names),
            "b10p02_present": any(n.startswith("B10P02") for n in names),
            "scripts_decode": Provenance.UNKNOWN.value,
        }
    else:
        A["ground_pack"] = {"status": "MISSING — lancer decode"}
    vals = []
    for k, v in A.items():
        if isinstance(v, dict):
            for k2, v2 in v.items():
                if isinstance(v2, str):
                    vals.append(v2)
    if any(v.startswith("FAIL") for v in vals):
        A["OVERALL"] = "FAIL"
    elif any("UNKNOWN" in v or v.startswith("PARTIAL") or v == "MISSING" for v in vals):
        A["OVERALL"] = "PARTIAL/UNKNOWN — conversion bloquée tant que des inconnues critiques restent"
    else:
        A["OVERALL"] = "PASS"
    return A


def audit_pmdo_target() -> dict:
    """B. CIBLE PMDO 0.8.12 — état du mod New Era (PMDO_VALUE, jamais une preuve NDS)."""
    zone = CHECKOUT / "Data" / "Zone" / "gloomy_forest.json"
    B = {}
    if zone.exists():
        z = json.loads(zone.read_text(encoding='utf-8-sig'))["Object"]
        B["zone_gloomy_forest"] = {
            "parses": "PASS",
            "name": z.get("Name", {}).get("DefaultText"),
            "segments": len(z.get("Segments", [])),
            "provenance": Provenance.PMDO_VALUE.value,
            "nds_equivalence": Provenance.UNKNOWN.value,
        }
    else:
        B["zone_gloomy_forest"] = {"status": "MISSING"}
    return B


def main() -> int:
    ap = argparse.ArgumentParser(prog="nds2pmdo audit")
    ap.add_argument("--json", action="store_true", help="écrit validation/audit_report.json")
    args = ap.parse_args()
    report = {
        "converter": "nds2pmdo", "version": __version__,
        "A_SOURCE_FIDELITY": audit_source_fidelity(),
        "B_PMDO_TARGET": audit_pmdo_target(),
    }
    print(json.dumps(report, indent=1, ensure_ascii=False))
    if args.json:
        VALIDATION_DIR.mkdir(parents=True, exist_ok=True)
        (VALIDATION_DIR / "audit_report.json").write_text(
            json.dumps(report, indent=1, ensure_ascii=False))
        print(f"→ validation/audit_report.json")
    overall = report["A_SOURCE_FIDELITY"].get("OVERALL", "")
    if overall.startswith("PASS"):
        return 0
    if overall.startswith("PARTIAL") or overall.startswith("UNKNOWN"):
        return 2
    return 1


if __name__ == "__main__":
    sys.exit(main())
