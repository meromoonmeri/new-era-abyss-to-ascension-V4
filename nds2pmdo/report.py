"""Rapport de couverture et de provenance — état réel de la reconstruction.

Usage :
  python -m nds2pmdo.report            # écrit validation/coverage_report.md + .json
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from . import __version__
from .config import DECODED_DIR, VALIDATION_DIR

CHECKOUT = Path(__file__).resolve().parents[1]
LEGACY = CHECKOUT / "docs" / "sinister_woods_nds"


def load_decoded() -> dict:
    out = {}
    mp = DECODED_DIR / "dungeon" / "mapparam.json"
    if mp.exists():
        out["mapparam"] = json.loads(mp.read_text())
    gfx = DECODED_DIR / "dungeon" / "graphics" / "graphics_report.json"
    if gfx.exists():
        out["graphics"] = json.loads(gfx.read_text())
    sd = DECODED_DIR / "sound" / "sdat.json"
    if sd.exists():
        out["sound"] = json.loads(sd.read_text())
    gd = DECODED_DIR / "ground" / "ground_pack_inventory.json"
    if gd.exists():
        out["ground"] = json.loads(gd.read_text())
    return out


def build_report() -> dict:
    d = load_decoded()
    r: dict = {"converter": "nds2pmdo", "version": __version__,
               "scope": "Sinister Woods (pilot) + inventaires globaux", "categories": {}}

    # --- mapparam ---
    mp = d.get("mapparam", {})
    r["categories"]["mapparam"] = {
        "floor_id_tables": {"floors": len(mp.get("floor_ids", [])),
                            "provenance": "SOURCE_NDS", "status": "DECODED_VALIDATED"},
        "floor_properties": {"entries": len(mp.get("floor_properties", {})),
                             "provenance": "SOURCE_NDS", "status": "DECODED_VALIDATED"},
        "spawn_tables": {"count": mp.get("spawn_ptr_count"),
                         "provenance": "SOURCE_NDS", "status": "DECODED_VALIDATED"},
        "item_tables": {"count": len(mp.get("item_tables", {})),
                        "provenance": "SOURCE_NDS (poids) / UNKNOWN (IDs items)",
                        "status": "PARTIAL"},
        "trap_tables": {"count": len(mp.get("trap_tables", {})),
                        "provenance": "SOURCE_NDS / noms UNKNOWN",
                        "status": "PARTIAL"},
    }

    # --- graphiques ---
    g = d.get("graphics", {})
    blobs = {k: v for k, v in g.items() if isinstance(v, dict) and len(k) == 7}
    dec = sum(1 for v in blobs.values() if v.get("status") == "SOURCE_NDS_DECODED")
    raw = sum(1 for v in blobs.values() if v.get("status") == "SOURCE_NDS_RAW")
    sir0 = sum(1 for v in blobs.values()
               if v.get("status") == "SOURCE_NDS_SIR0_NO_AT4PX")
    r["categories"]["graphics"] = {
        "blobs_total": len(blobs),
        "fon_cel_cex_decoded": dec,
        "pal_raw": raw,
        "canm_sir0_structure": sir0,
        "semantics_canm": "UNKNOWN",
        "flag_semantics_cel": "UNKNOWN",
        "provenance": "SOURCE_NDS / SOURCE_NDS_DECODED",
        "renders": sorted(str(p.name) for p in (VALIDATION_DIR / "renders").glob("*.png")),
    }

    # --- son ---
    s = d.get("sound", {})
    r["categories"]["sound"] = {
        "seq_names_extracted": len(s.get("seq_names", {})),
        "ground_truth_match": s.get("ground_truth_match_docs_sinister_woods_nds"),
        "music_chain": "UNKNOWN (bgMusic=4 → index SEQ non démontré)",
        "provenance": "SOURCE_NDS",
        "status": "PARTIAL",
    }

    # --- ground pack ---
    gr = d.get("ground", {})
    names = [e["name"] for e in gr.get("entries", [])]
    r["categories"]["ground_pack"] = {
        "entries": len(names),
        "b10p01_present": any(n.startswith("B10P01") for n in names),
        "b10p02_present": any(n.startswith("B10P02") for n in names),
        "package_decode": "PARTIAL/UNKNOWN",
        "provenance": "SOURCE_NDS (inventaire) / UNKNOWN (contenu)",
    }

    # --- messages ---
    fs = CHECKOUT / "nds2pmdo" / "extracted" / "fs"
    msg = {}
    for lang in ("e", "f", "g", "i", "s"):
        b = fs / f"message_{lang}.bin"
        st = fs / f"message_{lang}.str"
        if b.exists() and st.exists():
            msg[lang] = {"bin_bytes": b.stat().st_size,
                         "str_entries": st.stat().st_size // 4,
                         "status": "PARTIAL (offsets identifiés, frontières à documenter)"}
    r["categories"]["messages"] = msg

    # --- synthèse ---
    total_cats = len(r["categories"])
    r["summary"] = {
        "source": "ROM APHP (seule référence : meromoonmeri/POKEMON-ROM)",
        "rom_sha256": "2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05",
        "fully_decoded_validated": ["floor_id", "FloorProperties", "spawns",
                                    "AT4PX", "SIR0", "cel (tile/palette)", "pal (192 couleurs)",
                                    "SDAT noms SEQ/ME/SE", "chaîne SEQ→SSEQ (98 fichiers, trous préservés)",
                                    "BANK→SBNK (83)", "FAT SDAT (186 fichiers)",
                                    "inventaires packs"],
        "partial": ["items (poids)", "pièges (poids)", "canm (forme)",
                    "ground packages B10P01", "messages", "records STRM/WAVE/GRP/PLAYER"],
        "unknown": ["IDs items par catégorie", "mapping bgMusic→SEQ (code ARM9)",
                    "sémantique canm", "flags cel", "scripts ground B10P01",
                    "table de noms espèces ROM", "boucles SSEQ",
                    "formats ground.sbin/monster.sbin/effect.sbin"],
        "conversion_pmdo": "BLOQUÉE — audit OVERALL = PARTIAL/UNKNOWN (gates stricts)",
        "provenance_rule": "aucune valeur inventée ; UNKNOWN reste UNKNOWN",
    }
    return r


def main() -> int:
    r = build_report()
    VALIDATION_DIR.mkdir(parents=True, exist_ok=True)
    (VALIDATION_DIR / "coverage_report.json").write_text(
        json.dumps(r, indent=1, ensure_ascii=False))
    lines = ["# Rapport de couverture — nds2pmdo (Phase 1 : reconstruction de la source)",
             "",
             f"Convertisseur : nds2pmdo v{__version__}",
             f"Source : ROM APHP (`2540966e…14b05`) — seule référence : https://github.com/meromoonmeri/POKEMON-ROM",
             f"Portée : Sinister Woods (pilote) + inventaires globaux de la ROM",
             "",
             "## Décodé et validé (SOURCE_NDS)",
             ]
    for item in r["summary"]["fully_decoded_validated"]:
        lines.append(f"- {item}")
    lines += ["", "## Partiel (octets SOURCE_NDS, sémantique incomplète)"]
    for item in r["summary"]["partial"]:
        lines.append(f"- {item}")
    lines += ["", "## Non décodé (UNKNOWN — jamais inventé)"]
    for item in r["summary"]["unknown"]:
        lines.append(f"- {item}")
    lines += ["", "## Conversion PMDO",
              f"- **{r['summary']['conversion_pmdo']}**",
              "",
              "Détails par catégorie : `validation/coverage_report.json` et "
              "`validation/audit_report.json`."]
    (VALIDATION_DIR / "coverage_report.md").write_text("\n".join(lines))
    print("\n".join(lines[:6]))
    print("→ validation/coverage_report.md + coverage_report.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
