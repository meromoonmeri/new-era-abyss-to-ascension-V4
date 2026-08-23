#!/usr/bin/env python3
"""Résumé du JSONL produit par le service moteur `mapgen_validator`.

Entrée : une ligne JSON par étage réellement généré par RogueEssence.
Sortie : un rapport Markdown exploitable (échecs d'abord, puis statistiques).
"""
from __future__ import annotations

import json
import statistics
import sys
from collections import defaultdict
from pathlib import Path


def main(argv: list[str]) -> int:
    if len(argv) < 3:
        print("usage: summarize_engine_mapgen.py <jsonl> <report.md>", file=sys.stderr)
        return 2
    source, target = Path(argv[1]), Path(argv[2])
    rows = []
    begin = end = None
    for line in source.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("event") == "floor":
            rows.append(row)
        elif row.get("event") == "begin":
            begin = row
        elif row.get("event") == "end":
            end = row

    failures = [r for r in rows if r.get("status") == "FAIL"]
    ok = [r for r in rows if r.get("status") == "OK"]
    per_zone: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        per_zone[row["zone"]].append(row)

    lines = [
        "# Validation runtime de la génération — moteur RogueEssence",
        "",
        "Généré par `tools/runtime/run_engine_mapgen.sh` : chaque ligne provient d'un appel",
        "réel à `ZoneSegmentBase.GetMap(ZoneGenContext)` dans le moteur (même chemin que",
        "MapGenTest), binaire PMDO officiel en headless ANGLE/SwiftShader.",
        "",
        f"- zones testées : **{len(per_zone)}**",
        f"- itérations : **{(begin or {}).get('iterations', '?')}**",
        f"- générations tentées : **{len(rows)}**",
        f"- réussies : **{len(ok)}**",
        f"- échecs : **{len(failures)}**",
        "",
    ]

    if failures:
        lines += ["## Échecs", "", "| Zone | Segment | Étage | Type | Message | Seed |", "|---|---|---|---|---|---|"]
        for row in failures:
            lines.append("| `{zone}` | {segment} | {floor} | `{type}` | {message} | `{seed}` |".format(
                zone=row.get("zone"), segment=row.get("segment"), floor=row.get("floor"),
                type=row.get("type", "?"), message=str(row.get("message", ""))[:160],
                seed=row.get("seed")))
        lines.append("")
        lines += ["### Piles d'appel", ""]
        for row in failures:
            lines.append(f"- `{row.get('zone')}` seg {row.get('segment')} étage {row.get('floor')} : "
                         f"{row.get('stack', '')[:600]}")
        lines.append("")
    else:
        lines += ["## Échecs", "", "Aucun. Tous les étages demandés ont été construits par le moteur.", ""]

    lines += ["## Par donjon", "",
              "| Donjon | Étages générés | Salles min/moy/max | Largeur moy | Hauteur moy | ms moy |",
              "|---|---|---|---|---|---|"]
    for zone in sorted(per_zone):
        entries = [r for r in per_zone[zone] if r.get("status") == "OK"]
        if not entries:
            lines.append(f"| `{zone}` | 0 | — | — | — | — |")
            continue
        rooms = [r.get("rooms", -1) for r in entries if r.get("rooms", -1) >= 0]
        widths = [r["width"] for r in entries]
        heights = [r["height"] for r in entries]
        times = [r["ms"] for r in entries]
        rooms_txt = (f"{min(rooms)}/{statistics.mean(rooms):.1f}/{max(rooms)}" if rooms else "—")
        lines.append(f"| `{zone}` | {len(entries)} | {rooms_txt} | {statistics.mean(widths):.0f} | "
                     f"{statistics.mean(heights):.0f} | {statistics.mean(times):.1f} |")

    if end:
        lines += ["", f"Ligne terminale du moteur : `{json.dumps(end, ensure_ascii=False)}`", ""]
    else:
        lines += ["", "**Aucune ligne terminale : le run ne s'est pas terminé proprement.**", ""]

    target.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"{len(ok)}/{len(rows)} générations réussies, {len(failures)} échec(s) -> {target}")
    return 1 if failures or not end else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
