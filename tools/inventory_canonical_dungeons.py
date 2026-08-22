#!/usr/bin/env python3
"""Inventory the canonical Ch.6–32 scope before any replacement work.

This report is intentionally read-only.  It distinguishes active zone data,
protected/shared Grounds, archived canonical visual sources and the DTEF
packages already imported into the mod.  It prevents another broad deletion of
unrelated work.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TIMELINE = ROOT / "docs/canonical/MASTER_TIMELINE_CH5_CH32.json"
ROSTER = ROOT / "docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md"
PURGE = ROOT / "docs/pmdred_eu/chapter6_32_dungeon_purge_manifest.json"
OUT_JSON = ROOT / "docs/canonical_dungeons/INVENTORY_CH6_CH32.json"
OUT_MD = ROOT / "docs/canonical_dungeons/INVENTORY_CH6_CH32.md"


def main() -> int:
    timeline = json.loads(TIMELINE.read_text())["chapters"]
    roster = []
    for line in ROSTER.read_text(encoding="utf-8").splitlines():
        if not re.match(r"^\|\s*\d+\s*\|", line):
            continue
        values = [value.strip() for value in line.split("|")[1:-1]]
        if len(values) != 8:
            continue
        number, source, floors, boss, _asset, _tier, chapter, french = values
        roster.append({"number": int(number), "source": source, "floors": int(floors), "boss": re.sub(r"[*_`]", "", boss), "chapter": chapter, "french": re.sub(r"[*_`]", "", french)})
    zones = {path.stem for path in (ROOT / "Data/Zone").glob("*.json")}
    grounds = {path.stem for path in (ROOT / "Data/Ground").glob("*.rsground")}
    reserve_grounds = {path.stem for path in (ROOT / "RESERVE/red_grounds").glob("*.rsground")}
    dtef = {path.name for path in (ROOT / "Content/TileDtef/canonical").glob("*") if path.is_dir()}
    purge = json.loads(PURGE.read_text()) if PURGE.is_file() else {}
    active_main = []
    for row in timeline:
        if row["chapter"] < 6:
            continue
        active_main.append({"chapter": row["chapter"], "id": row["main"], "title": row["title"], "zone_present": row["main"] in zones})
    payload = {
        "schema": "new-era.canonical-dungeon-inventory.v1",
        "authority": "MASTER_TIMELINE_CH5_CH32 plus ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32",
        "main_route": active_main,
        "pmd_red_roster": roster,
        "counts": {"main_route": len(active_main), "pmd_red_roster": len(roster), "active_zone_files": len(zones), "active_ground_files": len(grounds), "archived_red_grounds": len(reserve_grounds), "imported_dtef_packages": len(dtef)},
        "protected_from_prior_purge": purge.get("retained_safety_exceptions", {}),
        "dtef_packages": sorted(dtef),
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    lines = ["# Inventaire canonique Ch.6–32", "", "Rapport produit avant reconstruction ; il ne supprime aucun fichier.", "", "## Synthèse", "", f"- routes principales : **{len(active_main)}** ;", f"- roster PMD Red : **{len(roster)}** ;", f"- Grounds Red archivés utilisables : **{len(reserve_grounds)}** ;", f"- packages DTEF importés localement : **{len(dtef)}**.", "", "## Routes principales", "", "| Ch. | ID | Lieu | Zone active |", "|---:|---|---|---|"]
    for row in active_main:
        lines.append(f"| {row['chapter']} | `{row['id']}` | {row['title']} | {'oui' if row['zone_present'] else 'non'} |")
    lines += ["", "## Roster PMD Red", "", "| # | Donjon | Étages | Boss | Affectation |", "|---:|---|---:|---|---|"]
    for row in roster:
        lines.append(f"| {row['number']} | {row['source']} / {row['french']} | {row['floors']} | {row['boss']} | {row['chapter']} |")
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(json.dumps(payload["counts"], ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
