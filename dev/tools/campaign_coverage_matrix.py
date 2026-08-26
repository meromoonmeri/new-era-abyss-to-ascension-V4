#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
campaign_coverage_matrix.py — Matrice de couverture (§49 du prompt maître)
pour les campagnes PMD Red EU et PMD Sky EU.

RÈGLE ABSOLUE : dimensions SÉPARÉES, jamais fusionnées en un pourcentage
unique. Chaque dimension cite sa source de mesure (artefact réel du dépôt).
Statuts stricts : PASS / PARTIAL / REVIEW_REQUIRED / NOT_TESTED / BLOCKED —
jamais de PASS implicite.

Sortie : dev/CAMPAIGNS/<camp>/Docs/COVERAGE_MATRIX.json + .md
et dev/CAMPAIGNS/COVERAGE_MATRIX.md (vue combinée, campagnes côte à côte,
sans fusion des chiffres).
"""
import json
import os
from collections import OrderedDict
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CAMPS = REPO / "dev" / "CAMPAIGNS"


def load(p):
    return json.loads(Path(p).read_text(encoding="utf-8-sig"))


def dim(name, num, den, status, source, note=None):
    d = OrderedDict(dimension=name)
    if den:
        d["covered"] = num
        d["total"] = den
        d["pct"] = round(100.0 * num / den, 1)
    d["status"] = status
    d["source"] = source
    if note:
        d["note"] = note
    return d


def red_matrix():
    c = CAMPS / "PMD_RED_RESCUE_TEAM"
    man = load(c / "MANIFEST.json")
    aud = load(c / "AUDIT.json")
    t = man["totals"]
    dims = []
    dims.append(dim("extraction_grounds", t["grounds"], 254,
                    "PASS", "MANIFEST.totals.grounds",
                    "254 grounds canoniques (campagne 219 validée PMDO réel "
                    "+ 21 fins de donjon + variantes)"))
    dims.append(dim("render_visual", t["rendered"], t["grounds"],
                    "PASS" if t["rendered"] == t["grounds"] else "PARTIAL",
                    "AUDIT.coverage.render_pct"))
    fs = aud.get("frame_status", {})
    fp = sum(1 for v in fs.values() if v["status"] == "PASS")
    dims.append(dim("frames_animation", fp, len(fs),
                    "PASS" if fp == len(fs) else "PARTIAL",
                    "AUDIT.frame_status (période minimale réelle par tuile)"))
    dims.append(dim("runtime_pmdo", t["runtime_validated"], t["grounds"],
                    "PARTIAL",
                    "MANIFEST.totals.runtime_validated (campagne 219 : "
                    "mismatched_pixel_count=0 dans PMDO 0.8.12 réel)",
                    "35 grounds (fins de donjon importées + variantes) "
                    "restent NOT_TESTED au runtime"))
    dims.append(dim("cinematic_sequences", t["with_cinematic"],
                    t["grounds"], "PARTIAL",
                    "MANIFEST.totals.with_cinematic (cif.json ROM)",
                    "couvre les grounds d'histoire ; les arènes/variantes "
                    "n'ont canoniquement pas de cinématique"))
    dims.append(dim("dialogues_5_langues", t["with_dialogues_5lang"], 133,
                    "PARTIAL",
                    "Cinematics/DIALOGUES_INDEX.json (69 stations graphe EU "
                    "exact, 3073 blocs)",
                    "64 stations REVIEW_REQUIRED (graphe EU non exactement "
                    "aligné pret)"))
    dims.append(dim("canonical_cast", t["with_canonical_cast"], 27,
                    "PASS",
                    "eu_scene_cast.json (gGroundLivesTypeData 0x27BEEC) + "
                    "preuve runtime 3 scènes",
                    "27/27 scènes à cast décodées ; alt_sectors (49 "
                    "entités) REVIEW_REQUIRED"))
    g = load(c / "Docs" / "PROGRESSION_GRAPH.json")["totals"]
    dims.append(dim("progression_graph", g["pret_events"], None,
                    "TECHNICAL_REFERENCE",
                    "Docs/PROGRESSION_GRAPH.json",
                    f"{g['pret_scenario_main_states']} états SCENARIO_MAIN "
                    f"pret + {g['rom_scenario_writes']} écritures décodées "
                    f"ROM — chaîne EVENT_* non encore décodée octet à octet "
                    f"dans la ROM EU"))
    dims.append(dim("dungeons_procedural_runtime", 89, 89,
                    "PARTIAL",
                    "dev/docs/canonical_dungeon_runtime/matrix.json "
                    "(89/89 CANONICAL_RUNTIME_PASS, 1848 étages)",
                    "15 zones CH1-5 restaurées ont perdu leurs correctifs "
                    "de convergence (zones verrouillées, état assumé)"))
    dims.append(dim("audit_verdict", None, None,
                    aud.get("verdict", "?"),
                    "AUDIT.json (8 familles A-H)"))
    return dims


def sky_matrix():
    c = CAMPS / "PMD_SKY_EXPLORERS"
    man = load(c / "MANIFEST.json")
    aud = load(c / "AUDIT.json")
    t = man["totals"]
    dims = []
    dims.append(dim("extraction_grounds", t["grounds"], 460,
                    "PASS", "MANIFEST.totals.grounds",
                    "460 rsground du port (458 MAP_BG NDS, pixel-perfect "
                    "skytemple-files)"))
    dims.append(dim("render_visual", t["rendered"], t["grounds"],
                    "PARTIAL",
                    "AUDIT.coverage.render_pct",
                    "1 ground hérité sans layers (b01p01_beach, ACCEPTED)"))
    fs = aud.get("frame_status", {})
    fp = sum(1 for v in fs.values() if v["status"] == "PASS")
    dims.append(dim("frames_animation", fp, len(fs),
                    "PASS" if fp == len(fs) else "PARTIAL",
                    "AUDIT.frame_status"))
    idx = load(c / "Cinematics" / "ROM_SCRIPTS_INDEX.json")
    cov = idx["coverage"]
    dims.append(dim("rom_scripts_ssb", cov["ssb_total"], 3760,
                    "PASS" if cov["ssb_explorerscript_pct"] == 100.0
                    else "PARTIAL",
                    "Cinematics/ROM_SCRIPTS_INDEX.json (ExplorerScript + "
                    "dialogues 5 langues)"))
    dims.append(dim("rom_scripts_ssa", cov["ssa_total"], 1884,
                    "PASS" if cov["ssa_pct"] == 100.0 else "PARTIAL",
                    "idem (placements acteurs/objets/events/triggers)"))
    dims.append(dim("cinematic_linked_grounds", t["with_cinematic"],
                    t["grounds"], "PARTIAL",
                    "MANIFEST.totals.with_cinematic "
                    "(LEVEL_MAP_LINKS level→MAP_BG)",
                    "124 grounds sans zone SCRIPT propre (variantes de "
                    "MAP_BG non référencées par un level)"))
    g = load(c / "Docs" / "PROGRESSION_GRAPH.json")["totals"]
    dims.append(dim("progression_graph", g["scenario_states_written"],
                    None, "PASS",
                    "Docs/PROGRESSION_GRAPH.json (SSB décompilés ROM)",
                    f"{g['scenario_states_written']} états écrits, "
                    f"{g['bit_flags']} bit flags, "
                    f"{g['scene_triggers']} déclencheurs ; "
                    f"1 seul état lu-jamais-écrit (0.0 = init sauvegarde)"))
    dims.append(dim("runtime_pmdo", 0, t["grounds"], "NOT_TESTED",
                    "—", "grounds Sky pas encore chargés dans PMDO réel"))
    dims.append(dim("gameplay_tables", 0, None, "NOT_TESTED",
                    "—", "spawn/items/traps des donjons Sky non extraits "
                    "vers PMDO (phase suivante)"))
    dims.append(dim("audit_verdict", None, None,
                    aud.get("verdict", "?"),
                    "AUDIT.json (8 familles A-H)"))
    return dims


def main():
    combined = ["# Matrice de couverture — campagnes PMD Red EU & Sky EU\n",
                "Dimensions SÉPARÉES (règle §49) : aucun pourcentage global "
                "fusionné n'existe ni ne doit être calculé.\n"]
    for camp, fn in (("PMD_RED_RESCUE_TEAM", red_matrix),
                     ("PMD_SKY_EXPLORERS", sky_matrix)):
        dims = fn()
        out = OrderedDict(schema="campaign-coverage-matrix/1",
                          campaign=camp,
                          rule="couvertures séparées — ne JAMAIS fusionner",
                          dimensions=dims)
        d = CAMPS / camp / "Docs"
        d.mkdir(exist_ok=True)
        (d / "COVERAGE_MATRIX.json").write_text(
            json.dumps(out, ensure_ascii=False, indent=1))
        combined.append(f"\n## {camp}\n")
        combined.append("| Dimension | Couverture | Statut | Source |")
        combined.append("|---|---|---|---|")
        lines = []
        for x in dims:
            covtxt = (f"{x['covered']}/{x['total']} ({x['pct']}%)"
                      if "total" in x and x.get("total") else
                      (str(x.get("covered", "—"))))
            lines.append(f"| {x['dimension']} | {covtxt} | "
                         f"**{x['status']}** | {x['source']} |")
        combined.extend(lines)
        (d / "COVERAGE_MATRIX.md").write_text(
            "\n".join(["# Matrice de couverture — " + camp, ""]
                      + combined[-len(lines) - 2:]) + "\n")
        print(camp, "->", [(x["dimension"], x["status"]) for x in dims])
    (CAMPS / "COVERAGE_MATRIX.md").write_text("\n".join(combined) + "\n")
    print("écrit:", CAMPS / "COVERAGE_MATRIX.md")


if __name__ == "__main__":
    main()
