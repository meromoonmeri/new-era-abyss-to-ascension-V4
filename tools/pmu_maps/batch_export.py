#!/usr/bin/env python3
"""
batch_export.py — export documentaire du pipeline PMU → PNG.

Rend TOUTES les maps d'un dossier de .dat clairs (via le noyau
render_pmu_maps + les règles du pipeline), puis prépare l'artefact GitHub :

  docs/pmu_maps/renders/<map_id>/render.png     (pixel-perfect, échelle 1)
  docs/pmu_maps/renders/<map_id>/manifest.json  (empreintes, dims, couches,
                                                 fallbacks, validation)
  docs/pmu_maps/sheets/sheet_NN.png             (contact sheets : les N maps
                                                 en vignettes nearest 96 px —
                                                 navigation visuelle globale ;
                                                 les vignettes sont ÉTIQUETÉES
                                                 commeaperçus, jamais des
                                                 remplacements du render)
  docs/pmu_maps/RENDERS.md                      (index : id, nom, dims,
                                                 taille render, sha, statut,
                                                 lien render + manifest)

Budget : --budget-mb limite la somme des render.png complets commités
(les plus grandes maps d'abord — les villes sont multi-écrans ; les maps
20×15 mono-écran restent couvertes par la contact sheet + manifest).
--all rend TOUT en full (à utiliser hors dépôt).

Déterministe : même entrée ⇒ mêmes octets (le renderer l'est, et les
listings sont triés).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import render_pmu_maps as rpm  # noqa: E402

from PIL import Image  # noqa: E402

PIPELINE = os.path.join(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, PIPELINE)
import pmu_pipeline as pp  # noqa: E402


def render_map(store, path, out_dir):
    raw = open(path, "rb").read()
    cat_map = {"id": os.path.splitext(os.path.basename(path))[0].replace("Map-", ""),
               "file": os.path.basename(path), "path": path}
    man = pp.render_one(cat_map, out_dir, store)
    return cat_map["id"], man


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--maps", required=True, help="dossier de Map-*.dat clairs")
    ap.add_argument("--tiles-dir", required=True)
    ap.add_argument("--work", required=True, help="répertoire de rendu complet")
    ap.add_argument("--docs", required=True, help="docs/pmu_maps (renders/, sheets/, RENDERS.md)")
    ap.add_argument("--budget-mb", type=int, default=80)
    ap.add_argument("--all", action="store_true", help="ignore le budget (tout en full)")
    ap.add_argument("--from-work", action="store_true",
                    help="ne pas re-rendre : réutiliser <work>/pmu/*/*.png (cache "
                         "de batch précédent ; mêmes octets donc même sha)")
    ap.add_argument("--no-sheets", action="store_true",
                    help="garder les contact sheets existants (avec --from-work)")
    ap.add_argument("--keep-render", default="copy", choices=["copy", "move"])
    a = ap.parse_args()

    os.makedirs(a.work, exist_ok=True)
    store = rpm.TileStore(a.tiles_dir)
    files = sorted(f for f in os.listdir(a.maps) if f.lower().endswith(".dat"))
    results = {}
    if a.from_work:
        base = os.path.join(a.work, "pmu")
        for mid in sorted(os.listdir(base)):
            mf = os.path.join(base, mid, "manifest.json")
            rp = os.path.join(base, mid, "render.png")
            if not (os.path.exists(mf) and os.path.exists(rp)):
                continue
            man = json.load(open(mf))
            results[mid] = {"file": f"Map-{mid}.dat", "manifest": man,
                            "ok": man["validation"]["result"] == "PASS",
                            "area": man["pmu"]["dims_tiles"][0] * man["pmu"]["dims_tiles"][1],
                            "png_bytes": os.path.getsize(rp)}
    else:
        for i, f in enumerate(files, 1):
            mid, man = render_map(store, os.path.join(a.maps, f), a.work)
            ok = man["validation"]["result"] == "PASS"
            results[mid] = {"file": f, "manifest": man, "ok": ok,
                            "area": (man["pmu"]["dims_tiles"][0]) * (man["pmu"]["dims_tiles"][1]),
                            "png_bytes": os.path.getsize(os.path.join(a.work, "pmu", mid, "render.png"))
                            if os.path.exists(os.path.join(a.work, "pmu", mid, "render.png")) else 0}
            if i % 200 == 0:
                print(f"… {i}/{len(files)}", file=sys.stderr)
    failed = [k for k, v in results.items() if not v["ok"]]

    # sélection full : toutes si --all, sinon par surface décroissante sous budget
    order = sorted(results, key=lambda k: (-results[k]["area"], k))
    chosen, total = [], 0
    for mid in order:
        sz = results[mid]["png_bytes"]
        if not a.all and total + sz > a.budget_mb * 1_000_000:
            continue
        chosen.append(mid)
        total += sz
    chosen_set = set(chosen)
    print(f"full renders retenus : {len(chosen)}/{len(results)} pour {total/1e6:.1f} MB",
          file=sys.stderr)

    # docs/pmu_maps/renders/<id>/
    rd = os.path.join(a.docs, "renders")
    os.makedirs(rd, exist_ok=True)
    import shutil
    for mid in chosen:
        src = os.path.join(a.work, "pmu", mid)
        dst = os.path.join(rd, mid)
        os.makedirs(dst, exist_ok=True)
        shutil.copy2(os.path.join(src, "render.png"), os.path.join(dst, "render.png"))
        shutil.copy2(os.path.join(src, "manifest.json"), os.path.join(dst, "manifest.json"))

    # contact sheets de TOUTES les maps rendues (les absentes du full y restent visibles)
    sd = os.path.join(a.docs, "sheets")
    os.makedirs(sd, exist_ok=True)
    for old in os.listdir(sd):
        os.remove(os.path.join(sd, old))
    TW = 96
    per_sheet_cols, per_sheet_rows = 12, 10
    per = per_sheet_cols * per_sheet_rows
    keys = sorted(results)
    from PIL import ImageDraw
    for si in range(0, (len(keys) + per - 1) // per):
        chunk = keys[si * per:(si + 1) * per]
        rows = (len(chunk) + per_sheet_cols - 1) // per_sheet_cols
        sheet = Image.new("RGBA", (per_sheet_cols * (TW + 2), rows * (TW + 16)), (16, 16, 22, 255))
        dr = ImageDraw.Draw(sheet)
        for j, mid in enumerate(chunk):
            p = os.path.join(a.work, "pmu", mid, "render.png")
            x, y = (j % per_sheet_cols) * (TW + 2), (j // per_sheet_cols) * (TW + 16)
            if os.path.exists(p):
                im = Image.open(p).convert("RGBA")
                im.thumbnail((TW, TW), Image.NEAREST)
                sheet.alpha_composite(im, (x, y + 13))
                if mid in chosen_set:
                    dr.rectangle([x - 1, y + 12, x + TW + 1, y + TW + 14], outline=(60, 220, 90, 255))
            dr.text((x, y), mid[:14], fill=(220, 220, 230, 255))
        sheet.convert("RGB").save(os.path.join(sd, f"sheet_{si:02d}.png"), optimize=True)

    # RENDERS.md
    lines = ["# Index des renders PMU (docs/pmu_maps)", "",
             f"{len(results)} maps rendues depuis les données structurées "
             f"(dump officiel pmu_data.sql du dépôt PMU-Server) — "
             f"{len(chosen)} render.png complets pixel-perfect commités sous "
             f"`renders/`, les autres couvertes par les contact sheets "
             f"`sheets/` (vignettes nearest — aperçus, jamais des remplacements). "
             f"Échec : {len(failed)}.", "",
             "| id | nom | dims (tuiles) | px | rendu | sha1 source | lien |",
             "|---|---|---|---|---|---|---|"]
    for mid in keys:
        r = results[mid]
        man = r["manifest"]
        dims = "×".join(map(str, man["pmu"]["dims_tiles"]))
        px = "×".join(map(str, man["render"]["pixel_size"]))
        if mid in chosen_set:
            link = f"[render](renders/{mid}/render.png) · [manifest](renders/{mid}/manifest.json)"
            status = "full"
        else:
            link = "contact sheet (voir `sheets/`)"
            status = "thumb"
        name = (man["pmu"]["name"] or "")[:38].replace("|", "¦")
        lines.append(f"| {mid} | {name} | {dims} | {px} | {status} | "
                     f"`{man['source']['sha1'][:10]}` | {link} |")
    with open(os.path.join(a.docs, "RENDERS.md"), "w") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"RENDERS.md : {len(keys)} lignes ; sheets : {si + 1}", file=sys.stderr)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
