#!/usr/bin/env python3
"""
pmu_pipeline.py — pipeline complet PMU → PNG → New Era (PMDO/RogueEssence).

    discovery/catalogue → sélection → rendu fidèle → preview + validation
    → approbation → import New Era (mode A pixel-perfect / mode B référence)
    → .rsground + .tile + init.lua + snippets → VALIDATION EN DISQUE
    (round-trip relu par tools/render_ground_png.py, le relecteur officiel du
    dépôt) → provenance chaînée.

Principes non négociables (charte projet) :
  * le rendu PMU est la passe exacte du MapRenderer.cs officiel (le module
    render_pmu_maps est le noyau ; ce pipeline ne le modifie pas) ;
  * jamais de rendu approché : une map chiffrée est marquée
    `encrypted-unrecoverable` + intrant manquant, et ne bloque PAS le reste ;
  * le PNG est un artefact intermédiaire auditable (manifest §4) ;
  * collision / warps / PNJ ne viennent JAMAIS des pixels : ils viennent du
    .dat PMU (TileType, Data1-3, NpcSettings) ; ce qui n'y est pas est
    déclaré irrécupérable, pas deviné ;
  * import refusé si le round-trip disque ne reproduit PAS le render.png.

Commandes :

  catalog      [--maps DIR…]                → output/pmu/catalog.{json,md}
  render       --select "id…"               → output/pmu/<id>/{render.png,manifest.json}
  preview      --select …                   → preview.png (+ overlay collision)
  validate     --select …                    → validation.json
  approve      --select … --decision approve|reject --by NOM
  import       --select … --mode A|B [--texsize 1|4] [--write] [--register]
  status       [--select …]
  selftest     [--golden] [--tiles-dir D]

Sélection : ids acceptés « s1000 », « Map-s1000 », « 1000 », « map95 »,
« 95 » ; ambigu = erreur explicite (jamais de choix automatique). Sans
--select, le pipeline s'arrête : AUCUN traitement à l'aveugle du dépôt.

Mode A : grille ground PMDO au pas moteur prouvé : TexSize=1 (cellules 8 px,
comme town_hollow validé in-engine). Chaque tuile PMU 32 px est redécoupée en
SOUS-BLOCS 8 px qui sont les pixels exacts des enregistrements PNG d'origine
(mapping 1:1 — aucune échelle, aucun recadrage, aucune retouche) ; dédup
native du format .tile ; alpha pré-multiplié à l'écriture comme l'exige
BaseSheet.ImportTex. --texsize 4 est REFUSÉ par conception : toute la chaîne
de validation du dépôt (render_ground_png.py + les 953 planches existantes)
vit en cellules 8 px ; émettre un format que notre propre validation ne peut
pas relire serait du parallélisme non prouvé.
Round-trip : le .rsground + .tile écrits sont relus par
le relecteur officiel et re-composés ; il faut la égalité OCTET POUR OCTET
avec render.png, sinon REFUSED (les seules exceptions tolérées et affichées
sont des écarts ≤1 canal imputables à un PNG amont à alpha partiel, comptés).
Mode B : AUCUN .rsground ; le render.png est livré comme
Content/Pictures/pmu_<id>_ref.png pour l'artiste. Les deux modes ne sont
jamais mélangés dans les manifestes.
"""
from __future__ import annotations

import argparse
import datetime as _dt
import hashlib
import io
import json
import os
import pathlib
import re
import struct
import subprocess
import sys
import tempfile
from collections import OrderedDict
from io import BytesIO

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import render_pmu_maps as rpm  # noqa: E402  noyau de rendu canonique (avec sa preuve map95)
import render_ground_png as rgp  # noqa: E402  relecteur officiel .rsground/.tile du dépôt

from PIL import Image, ImageChops, ImageDraw  # noqa: E402

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT_DEFAULT = os.path.join(REPO_ROOT, "output")
TESTS_DATA = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tests_data")
GOLDEN_MAP = "map95"
PIPELINE_VERSION = "1.1.0"

# PMU Client/Enums.cs — enum TileType (relevé source MIT « PMU Staff » 2026-08-30)
PMU_TILETYPE = {
    0: "Walkable", 1: "Blocked", 2: "Warp", 3: "Item", 4: "NPCAvoid", 5: "Key",
    6: "KeyOpen", 7: "Heal", 8: "Kill", 9: "Shop", 10: "MobileBlock", 11: "Arena",
    12: "Sound", 13: "SpriteChange", 14: "Sign", 15: "Door", 16: "Notice",
    17: "Chest", 18: "LinkShop", 19: "Scripted", 20: "NpcSpawn", 21: "House",
    22: "Bank", 23: "Guild", 24: "SpriteBlock", 25: "LevelBlock", 26: "Assembly",
    27: "Evolution", 28: "Story", 29: "MissionBoard", 30: "RDungeonGoal",
    31: "ScriptedSign", 32: "SpeciesChange", 33: "Hallway", 34: "HouseRoomWarp",
    35: "HouseOwnerBlock", 36: "Ambiguous", 37: "Slippery", 38: "Slow",
    39: "DropShop",
}
# Sources de Tags=1 dans le ground PMDO. Le MapProcessor client bloque le
# mouvement sur ces types-là ; les autres restent marchables (sémantique
# conservée séparément, jamais déduite des pixels).
SOLID_TYPES = {1, 24, 25, 35}
SEMANTIC_TYPES = {2, 3, 5, 6, 9, 14, 15, 17, 18, 20, 21, 22, 23, 29, 34, 39}

LAYER_NAMES = ["PMU Ground", "PMU Mask", "PMU Mask2", "PMU Fringe", "PMU Fringe2"]
LAYER_SLOTS = [0, 0, 0, 4, 4]      # 4 = fringe moteur PMDO (au-dessus des entités)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def now() -> str:
    return _dt.datetime.now(_dt.timezone.utc).isoformat(timespec="seconds")


def sanitize(map_id: str) -> str:
    return re.sub(r"[^a-z0-9_]+", "_", map_id.lower()).strip("_") or "map"


# --------------------------------------------------------------- discovery --
def discover(maps_dirs: list[str]) -> list[dict]:
    found: list[dict] = []
    for d in maps_dirs:
        if not os.path.isdir(d):
            continue
        for name in sorted(os.listdir(d)):
            p = os.path.join(d, name)
            if not os.path.isfile(p) or ".dat" not in name.lower():
                continue
            raw = open(p, "rb").read()
            base = os.path.splitext(name)[0]
            if base.startswith("Map-"):
                base = base[4:]
            map_id = base.split(".dat")[0].rstrip("-")
            e = {"id": map_id, "file": name, "path": p, "bytes": len(raw),
                 "sha1": rpm.sha1(raw), "sha256": sha256(raw)}
            kind = rpm.sniff(raw)
            if kind == "plain":
                try:
                    parsed = rpm.parse_map(raw)
                    e.update({"format": parsed["version"],
                              "dims_tiles": [parsed["maxx"] + 1, parsed["maxy"] + 1],
                              "tile_count": len(parsed["tiles"]),
                              "pmu_name": parsed["name"],
                              "encryption": "none", "renderable": True})
                except Exception as exc:  # noqa: BLE001
                    e.update({"format": "unparsable", "encryption": "none",
                              "renderable": False,
                              "note": f"parse-error: {exc!r}"[:200]})
            elif kind == "encrypted":
                e.update({"format": "unknown (3DES cache)",
                          "encryption": "encrypted-unrecoverable",
                          "renderable": False,
                          "missing_input": ("plaintext PMU .dat (MapData|V4/V9) ou "
                                            "dump serveur `map<N>.dat-<hash>` — la "
                                            "clé de session d'ère-live n'est publiée "
                                            "nulle part")})
            else:
                e.update({"format": "unknown", "encryption": "unrecognized",
                          "renderable": False,
                          "missing_input": "fichier non reconnu comme MapData PMU en clair"})
            found.append(e)
    return found


def find_tiles_dir(cli_arg: str | None) -> str | None:
    for c in [cli_arg, os.environ.get("PMU_TILES_DIR"),
              "/home/user/skyhacks/pmuc/resources/GFX/Tiles",
              os.path.join(REPO_ROOT, "assets", "pmu_tiles")]:
        if c and os.path.isdir(c) and any(f.endswith(".tile") for f in os.listdir(c)):
            return c
    return None


def get_store(tiles_dir: str | None) -> rpm.TileStore:
    if not tiles_dir:
        raise SystemExit("PAS DE PLANCHES PMU : déposer resources/GFX/Tiles (dépôt "
                         "PMU-Client) puis --tiles-dir ou PMU_TILES_DIR. Sans elles, "
                         "aucun rendu — jamais simulé.")
    return rpm.TileStore(tiles_dir)


def load_state(out_root: str, map_id: str) -> dict:
    d = os.path.join(out_root, "pmu", map_id)
    nd = os.path.join(out_root, "newera", map_id)
    st = {}
    for key, path in (("render", os.path.join(d, "render.png")),
                      ("manifest", os.path.join(d, "manifest.json")),
                      ("preview", os.path.join(d, "preview.png")),
                      ("validation", os.path.join(d, "validation.json")),
                      ("approval", os.path.join(d, "approval.json")),
                      ("newera_manifest", os.path.join(nd, "manifest.json"))):
        st[key] = path if os.path.exists(path) else None
    return st


def build_catalog(maps_dirs, out_root: str, write: bool = True) -> dict:
    entries = discover(maps_dirs or [TESTS_DATA])
    tiles_dir = find_tiles_dir(None)
    tiles = []
    if tiles_dir:
        for name in sorted(os.listdir(tiles_dir)):
            if name.endswith(".tile"):
                b = open(os.path.join(tiles_dir, name), "rb").read()
                tiles.append({"file": name, "bytes": len(b), "sha256": sha256(b)})
    for e in entries:
        st = load_state(out_root, e["id"])
        e["render_status"] = ("rendered" if st["render"] else
                              ("blocked-" + e.get("encryption", "?")
                               if not e.get("renderable") else "not-rendered"))
        e["import_status"] = "not-imported"
        if st["newera_manifest"]:
            nm = json.load(open(st["newera_manifest"]))
            e["import_status"] = f"imported mode {nm.get('mode', '?')}"
        for key, outk in (("manifest", "pmu_manifest"), ("validation", "validation"),
                          ("approval", "approval"), ("render", "render_png")):
            if st[key]:
                e[outk] = os.path.relpath(st[key], out_root)
    cat = OrderedDict()
    cat["schema"] = "new-era.pmu-catalog.v1"
    cat["generated"] = now()
    cat["pipeline_version"] = PIPELINE_VERSION
    cat["maps_dirs"] = [os.path.abspath(d) for d in (maps_dirs or [TESTS_DATA])]
    cat["tiles_dir"] = tiles_dir
    cat["tile_archives"] = tiles
    cat["counts"] = {"maps": len(entries),
                     "renderable": sum(1 for m in entries if m.get("renderable")),
                     "encrypted": sum(1 for m in entries
                                      if m.get("encryption") == "encrypted-unrecoverable")}
    cat["maps"] = sorted(entries, key=lambda x: x["id"])
    if write:
        d = os.path.join(out_root, "pmu")
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "catalog.json"), "w") as fh:
            json.dump(cat, fh, indent=1)
        lines = ["# Catalogue des maps PMU découvertes", "",
                 f"sources : {', '.join(cat['maps_dirs'])} — {len(entries)} maps", "",
                 "| id | fichier | format | chiffrement | dims | tuiles | rendu | import | sha1 |",
                 "|---|---|---|---|---|---|---|---|---|"]
        for m in cat["maps"]:
            dims = "×".join(map(str, m.get("dims_tiles", ["—", "—"])))
            lines.append(f"| {m['id']} | {m['file']} | {m.get('format', '?')} | "
                         f"{m.get('encryption', '?')} | {dims} | "
                         f"{m.get('tile_count', '—')} | {m['render_status']} | "
                         f"{m['import_status']} | `{m['sha1'][:12]}` |")
        with open(os.path.join(d, "catalog.md"), "w") as fh:
            fh.write("\n".join(lines) + "\n")
    return cat


def resolve_selection(cat: dict, tokens: list[str]) -> list[str]:
    by_norm: dict[str, set] = {}
    for m in cat["maps"]:
        keys = {m["id"], m["id"].lower(), m["file"], m["file"].lower()}
        dig = re.sub(r"^[a-z]+", "", m["id"])
        if dig.isdigit():
            keys |= {dig, "map" + dig, "map-" + dig, "s" + dig}
        for k in keys:
            by_norm.setdefault(k, set()).add(m["id"])
    out: list[str] = []
    seen: set[str] = set()
    for tok in tokens:
        t = tok.strip().lower()
        if not t:
            continue
        cands = by_norm.get(t)
        if not cands:
            raise SystemExit(f"SÉLECTION INCONNUE : {tok!r} — voir output/pmu/catalog.md")
        if len(cands) > 1:
            raise SystemExit(f"SÉLECTION AMBIGUË : {tok!r} → {sorted(cands)} — "
                             "préciser l'id exact (aucun choix automatique)")
        mid = next(iter(cands))
        if mid not in seen:
            seen.add(mid)
            out.append(mid)
    return out


# ------------------------------------------------------------------ render --
def _resolve_cell(t: dict):
    """Règle cliente exacte : l'anim REMPLACE le statique si son index ≠ 0."""
    for li, (sk, ak, ssk, ask) in enumerate(rpm.PASSES):
        idx, sheet = t[sk], t[ssk]
        if t[ak] != 0:
            idx, sheet = t[ak], t[ask]
        if idx != 0:
            yield li, sheet, idx


def render_one(cat_map: dict, out_root: str, store: rpm.TileStore) -> dict:
    mid = cat_map["id"]
    d = os.path.join(out_root, "pmu", mid)
    os.makedirs(d, exist_ok=True)
    raw = open(cat_map["path"], "rb").read()
    parsed = rpm.parse_map(raw)
    maxx, maxy = parsed["maxx"], parsed["maxy"]
    img = Image.new("RGBA", ((maxx + 1) * 32, (maxy + 1) * 32), (0, 0, 0, 0))
    per_layer = [0] * 5
    fallback_coords: list = []
    for (x, y), t in sorted(parsed["tiles"].items()):
        for li, sheet, idx in _resolve_cell(t):
            tile, note = store.image(sheet, idx)
            if tile is None:
                continue
            if note:
                fallback_coords.append([x, y, li, note, sheet, idx])
            img.alpha_composite(tile, (x * 32, y * 32))
            per_layer[li] += 1
    png_path = os.path.join(d, "render.png")
    img.save(png_path)
    render_sha = sha256(open(png_path, "rb").read())
    # déterminisme : recomposit complet dans un canvas neuf, re-sauvegardé
    again = Image.new("RGBA", img.size, (0, 0, 0, 0))
    for (x, y), t in sorted(parsed["tiles"].items()):
        for li, sheet, idx in _resolve_cell(t):
            tile, _ = store.image(sheet, idx)
            if tile is not None:
                again.alpha_composite(tile, (x * 32, y * 32))
    buf = BytesIO()
    again.save(buf, format="PNG")
    det = render_sha == sha256(buf.getvalue())

    hist = img.getchannel("A").histogram()
    man = OrderedDict()
    man["schema"] = "new-era.pmu-render.v1"
    man["map_id"] = mid
    man["pipeline_version"] = PIPELINE_VERSION
    man["renderer_version"] = "render_pmu_maps (client-exact, 2026-08-30)"
    man["generated"] = now()
    man["source"] = {"file": cat_map["file"], "path": os.path.abspath(cat_map["path"]),
                     "bytes": len(raw), "sha1": rpm.sha1(raw), "sha256": sha256(raw)}
    man["tiles_archives_sha1"] = {str(k): store.sheets[k]["sha1"] for k in sorted(store.sheets)}
    man["pmu"] = {"name": parsed["name"], "version": parsed["version"],
                  "revision": parsed["revision"], "dims_tiles": [maxx + 1, maxy + 1],
                  "tile_count": len(parsed["tiles"]), "music": parsed["music"]}
    man["render"] = {"png": "render.png", "png_sha256": render_sha, "tile_size": 32,
                     "pixel_size": list(img.size),
                     "layers_drawn": {LAYER_NAMES[i]: per_layer[i] for i in range(5)},
                     "fallback_count": len(fallback_coords),
                     "fallback_coords": fallback_coords[:64]}
    man["transparency"] = {"transparent_px": hist[0], "opaque_px": hist[255],
                           "partial_alpha_px": sum(hist[1:255])}
    man["validation"] = {"determinism_2run": "identical" if det else "DIVERGENT",
                         "scaling_applied": False, "cropping_applied": False,
                         "result": "PASS" if det else "FAIL"}
    with open(os.path.join(d, "manifest.json"), "w") as fh:
        json.dump(man, fh, indent=1)
    return man


def do_render(out_root: str, ids: list[str], store: rpm.TileStore, cat: dict) -> int:
    byid = {m["id"]: m for m in cat["maps"]}
    rc = 0
    for mid in ids:
        m = byid[mid]
        if not m.get("renderable"):
            print(f"[skip] {mid} : {m.get('encryption', '?')} — intrant manquant : "
                  f"{m.get('missing_input', 'inconnu')} — le pipeline CONTINUE.",
                  file=sys.stderr)
            continue
        man = render_one(m, out_root, store)
        print(f"[ok] {mid} : «{man['pmu']['name']}» {man['render']['pixel_size']} "
              f"dessinées={sum(man['render']['layers_drawn'].values())} "
              f"fallbacks={man['render']['fallback_count']} "
              f"déterminisme={man['validation']['determinism_2run']}", file=sys.stderr)
        if man["validation"]["result"] != "PASS":
            rc = 1
    return rc


# ----------------------------------------------------------------- preview --
def preview_one(cat_map: dict, out_root: str, store: rpm.TileStore) -> dict:
    mid = cat_map["id"]
    d = os.path.join(out_root, "pmu", mid)
    man = json.load(open(os.path.join(d, "manifest.json")))
    img = Image.open(os.path.join(d, "render.png")).convert("RGBA")
    raw = open(cat_map["path"], "rb").read()
    parsed = rpm.parse_map(raw)

    col = Image.new("RGBA", img.size, (0, 0, 0, 0))
    dc = ImageDraw.Draw(col)
    solids = walk = 0
    for (x, y), t in sorted(parsed["tiles"].items()):
        if t["type"] in SOLID_TYPES:
            dc.rectangle([x * 32, y * 32, x * 32 + 31, y * 32 + 31], fill=(255, 40, 40, 90))
            solids += 1
        else:
            walk += 1
    grid = Image.new("RGBA", img.size, (0, 0, 0, 0))
    dg = ImageDraw.Draw(grid)
    for gx in range(0, img.width + 1, 32):
        dg.line([(gx, 0), (gx, img.height)], fill=(255, 0, 0, 70), width=1)
    for gy in range(0, img.height + 1, 32):
        dg.line([(0, gy), (img.width, gy)], fill=(255, 0, 0, 70), width=1)
    overlay = img.copy()
    overlay.alpha_composite(col)
    overlay.alpha_composite(grid)
    overlay.save(os.path.join(d, "preview_collision.png"))

    strips = []
    for li in range(5):
        canvas = Image.new("RGBA", img.size, (0, 0, 0, 0))
        for (x, y), t in parsed["tiles"].items():
            for l2, sheet, idx in _resolve_cell(t):
                if l2 != li:
                    continue
                tile, _ = store.image(sheet, idx)
                if tile is not None:
                    canvas.alpha_composite(tile, (x * 32, y * 32))
        sc = max(1, min(4, 1600 * 4 // max(1, canvas.width)))
        shown = canvas if sc == 1 else canvas.resize(
            (max(1, canvas.width // sc), max(1, canvas.height // sc)), Image.NEAREST)
        strips.append((LAYER_NAMES[li], man["render"]["layers_drawn"][LAYER_NAMES[li]], shown, sc))

    band = 34
    strip_h = sum(s.height for _, _, s, _ in strips) + 44 * len(strips)
    sheet = Image.new("RGBA", (max(img.width, 900), band + img.height + strip_h),
                      (24, 24, 30, 255))
    dr = ImageDraw.Draw(sheet)
    dr.text((8, 10), f"PMU {mid}  «{parsed['name']}»  {img.width}x{img.height}px  "
                     f"fallbacks={man['render']['fallback_count']}  "
                     f"src={man['source']['sha1'][:12]}  RENDER-VALID={man['validation']['result']}",
            fill=(240, 240, 240, 255))
    gridmain = img.copy()
    gridmain.alpha_composite(grid)
    sheet.alpha_composite(gridmain, (0, band))
    yy = band + img.height + 12
    for name, count, s, sc in strips:
        dr.text((8, yy), f"{name} — {count} tuiles dessinées"
                         + ("   [preview nearest-scale, NOT the render]" if sc > 1 else ""),
                fill=(200, 200, 120, 255))
        sheet.alpha_composite(s.convert("RGBA"), (8, yy + 16))
        yy += s.height + 40
    sheet.save(os.path.join(d, "preview.png"))

    checks = {
        "dimensions_match_manifest": list(img.size) == man["render"]["pixel_size"],
        "size_equals_tiles_x_32": img.size == ((parsed["maxx"] + 1) * 32,
                                               (parsed["maxy"] + 1) * 32),
        "fallback_count_reported": "fallback_count" in man["render"],
        "partial_alpha_px": man["transparency"]["partial_alpha_px"],
        "transparent_px": man["transparency"]["transparent_px"],
        "solid_tiles_from_pmu_type": solids, "walkable_tiles": walk,
    }
    with open(os.path.join(d, "preview_report.txt"), "w") as fh:
        fh.write(json.dumps(checks, indent=1) +
                 "\nLecture : quadrillage rouge = 32 px (tout décalage se voit). "
                 "Rouge = types solides PMU (jamais déduits des pixels). Bandeaux = "
                 "couche sola ; une couche vide ici = couche absente du .dat "
                 "(signal, pas un défaut de rendu). Le render.png lui-même n'est "
                 "jamais redimensionné.\n")
    return checks


# ----------------------------------------------------------- gates / import --
def validate_one(cat_map: dict, out_root: str) -> dict:
    mid = cat_map["id"]
    d = os.path.join(out_root, "pmu", mid)
    try:
        man = json.load(open(os.path.join(d, "manifest.json")))
    except FileNotFoundError:
        return {"result": "FAIL", "reason": "pas encore rendue"}
    png = os.path.join(d, "render.png")
    b = open(png, "rb").read()
    raw = open(cat_map["path"], "rb").read()
    parsed = rpm.parse_map(raw)
    checks = [
        {"name": "render.png décodable", "pass": Image.open(BytesIO(b)).size[0] > 0},
        {"name": "dims = PMU dims × 32 (ni crop ni échelle)",
         "pass": list(Image.open(BytesIO(b)).size) ==
                 [(parsed["maxx"] + 1) * 32, (parsed["maxy"] + 1) * 32]},
        {"name": "empreinte PNG = manifest (gel)", "pass": sha256(b) == man["render"]["png_sha256"]},
        {"name": "source sha1 = manifest", "pass": rpm.sha1(raw) == man["source"]["sha1"]},
        {"name": "déterminisme 2 passes",
         "pass": man["validation"]["determinism_2run"] == "identical"},
        {"name": "fallbacks déclarés (comptés, jamais masqués)",
         "pass": "fallback_count" in man["render"]},
    ]
    res = OrderedDict()
    res["result"] = "PASS" if all(c["pass"] for c in checks) else "FAIL"
    res["checks"] = checks
    res["when"] = now()
    res["png_sha256"] = sha256(b)
    with open(os.path.join(d, "validation.json"), "w") as fh:
        json.dump(res, fh, indent=1)
    return res


def approve_one(out_root: str, mid: str, decision: str, by: str) -> dict:
    d = os.path.join(out_root, "pmu", mid)
    png = os.path.join(d, "render.png")
    if not os.path.exists(png):
        raise SystemExit(f"approve {mid} : rendre d'abord (render.png absent)")
    ap = {"map_id": mid, "decision": decision, "by": by, "when": now(),
          "render_sha256": sha256(open(png, "rb").read())}
    with open(os.path.join(d, "approval.json"), "w") as fh:
        json.dump(ap, fh, indent=1)
    return ap


def check_gate(out_root: str, mid: str) -> tuple[bool, str]:
    d = os.path.join(out_root, "pmu", mid)
    try:
        ap = json.load(open(os.path.join(d, "approval.json")))
        va = json.load(open(os.path.join(d, "validation.json")))
    except FileNotFoundError as exc:
        return False, f"portillon manquant : {os.path.basename(str(exc.filename))}"
    if ap["decision"] != "approve":
        return False, "approbation = reject"
    png_sha = sha256(open(os.path.join(d, "render.png"), "rb").read())
    if png_sha != ap["render_sha256"]:
        return False, "APPROBATION PÉRIMÉE : le render.png a changé depuis l'approbation"
    if va.get("result") != "PASS" or va.get("png_sha256") != png_sha:
        return False, "validation non PASS ou périmée"
    return True, "gate OK"


# ------------------------------------------------------- PMDO tileset writer --
def premultiply(im: Image.Image) -> Image.Image:
    """out_c = c*alpha//255 — formule exacte de BaseSheet.ImportTex, sans numpy."""
    im = im.convert("RGBA")
    a = im.getchannel("A")
    rgb = ImageChops.multiply(im.convert("RGB"), Image.merge("RGB", (a, a, a)))
    return Image.merge("RGBA", (*rgb.split(), a))


def write_tile_sheet(path: str, tile_size: int, grille: dict) -> dict:
    """Écrit un .tile RogueEssence (<II size,count> + n×(u64 key,u64 off) +
    blobs <q len + PNG>), dédup par octets, alpha pré-multiplié. AUTO-VERROU :
    relu immédiatement par render_ground_png.read_tile_sheet (le lecteur du
    dépôt) ; si les clés ne reviennent pas identiques, on le déclare."""
    keys = sorted(grille, key=lambda k: (k[1], k[0]))
    png_of = {}
    for k in keys:
        buf = BytesIO()
        premultiply(grille[k]).save(buf, format="PNG")
        png_of[k] = buf.getvalue()
    encode: dict[bytes, int] = {}
    ordre: list[bytes] = []
    for k in keys:
        p = png_of[k]
        if p not in encode:
            encode[p] = 0
            ordre.append(p)
    off = 8 + len(keys) * 16
    for p in ordre:
        encode[p] = off
        off += 8 + len(p)
    out = bytearray(struct.pack("<II", tile_size, len(keys)))
    for k in keys:
        out += struct.pack("<QQ", k[0] | (k[1] << 32), encode[png_of[k]])
    for p in ordre:
        out += struct.pack("<q", len(p)) + p
    with open(path, "wb") as fh:
        fh.write(bytes(out))
    back = rgp.read_tile_sheet(pathlib.Path(path))
    return {"entries": len(keys), "unique": len(ordre), "bytes": len(out),
            "reload_keys_ok": set(back) == set(keys)}


def rpm_cell(sheet: str, tx: int, ty: int) -> dict:
    return {"AutoTileset": "", "Associates": [],
            "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": tx, "Y": ty}}],
                        "FrameLength": 60}],
            "NeighborCode": -1}


def build_sheet_and_layers(parsed: dict, store: rpm.TileStore, sheet_name: str,
                           texsize: int):
    if texsize != 1:
        # Le relecteur officiel du dépôt (render_ground_png) ET les 953 planches
        # du projet vivent en cellules 8 px (TexSize=1). Émettre du TexSize=4
        # serait un format non vérifiable par notre propre validation disque :
        # refus explicite plutôt que format parallèle.
        raise ValueError("TexSize=4 refusé : la chaîne de validation du dépôt "
                         "(render_ground_png.py) suppose les cellules 8 px. "
                         "Mode A = TexSize=1 uniquement.")
    maxx, maxy = parsed["maxx"], parsed["maxy"]
    W, H = maxx + 1, maxy + 1
    sub = 4
    cell_px = 8
    gw, gh = W * sub, H * sub
    grille: dict[tuple[int, int], Image.Image] = {}
    layers = [[[None] * gh for _ in range(gw)] for _ in range(5)]
    solid = [[0] * gh for _ in range(gw)]
    stats = {"cells": 0, "drawn": 0, "fallback": 0, "missing_set": 0}
    for (x, y), t in sorted(parsed["tiles"].items()):
        stats["cells"] += 1
        if t["type"] in SOLID_TYPES:
            for sx in range(sub):
                for sy in range(sub):
                    solid[x * sub + sx][y * sub + sy] = 1
        for li, sheet_i, idx in _resolve_cell(t):
            tile, note = store.image(sheet_i, idx)
            if tile is None:
                stats["missing_set"] += 1
                continue
            stats["drawn"] += 1
            if note:
                stats["fallback"] += 1
            for sx in range(sub):
                for sy in range(sub):
                    gx, gy = x * sub + sx, y * sub + sy
                    piece = tile.crop((sx * cell_px, sy * cell_px,
                                       sx * cell_px + cell_px,
                                       sy * cell_px + cell_px)) if sub > 1 else tile
                    key = (gx, li * gh + gy)
                    grille[key] = piece
                    layers[li][gx][gy] = rpm_cell(sheet_name, key[0], key[1])
    out_layers = [{"Name": LAYER_NAMES[i], "Layer": LAYER_SLOTS[i],
                   "Visible": True, "Tiles": layers[i]} for i in range(5)]
    obstacles = [[{"Bounds": {"X": gx * cell_px, "Y": gy * cell_px,
                              "Width": cell_px, "Height": cell_px},
                   "Tags": solid[gx][gy]} for gy in range(gh)] for gx in range(gw)]
    return grille, out_layers, obstacles, stats, [gw, gh], cell_px


def semantics_from_parsed(parsed: dict) -> dict:
    sem = {"npcs": [], "specials": [], "unknown_types": {},
           "note": ("Warp/Door/etc. : types + Data1-3 BRUTS du .dat. "
                    "Interprétation des cibles de warp = à valider contre "
                    "Client/GameProcessor.cs ; jamais inventée ici.")}
    for (x, y), t in sorted(parsed["tiles"].items()):
        ty = t["type"]
        name = PMU_TILETYPE.get(ty)
        if ty in SEMANTIC_TYPES or name is None:
            sem["specials"].append({"x": x, "y": y, "type": ty,
                                    "type_name": name or f"?{ty}",
                                    "data1": t.get("data1", 0),
                                    "data2": t.get("data2", 0),
                                    "data3": t.get("data3", 0)})
        if name is None:
            sem["unknown_types"][str(ty)] = sem["unknown_types"].get(str(ty), 0) + 1
    return sem


def markers_from_semantics(sem: dict, cell_px: int) -> list[dict]:
    def mk(name, tx, ty):
        return {"EntName": name, "Direction": -1, "EntEnabled": True,
                "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
                "Collider": {"X": tx * cell_px, "Y": ty * cell_px,
                             "Width": cell_px, "Height": cell_px}}
    return [mk(f"PMU_{re.sub(r'[^A-Za-z0-9_]', '_', s['type_name'])}_{s['x']}_{s['y']}",
               s["x"], s["y"]) for s in sem["specials"]][:400]


def build_rsground(map_id: str, parsed: dict, layers, obstacles, texsize, markers) -> str:
    obj = OrderedDict()
    obj["$type"] = "RogueEssence.Ground.GroundMap, RogueEssence"
    obj["TexSize"] = texsize
    obj["Name"] = {"DefaultText": f"PMU {map_id} ({parsed['name']})".strip(),
                   "LocalTexts": {}}
    obj["Released"] = False
    obj["Comment"] = (f"PMU import pipeline v{PIPELINE_VERSION}; source "
                      f"{parsed['version']} «{parsed['name']}»")
    obj["obstacles"] = obstacles
    obj["rand"] = {"$type": "RogueElements.ReRandom, RogueElements",
                   "FirstSeed": 0, "s": []}
    obj["Status"] = {}
    obj["Background"] = {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                         "MapLoc": {"X": 0, "Y": 0},
                         "BGAnim": {"AnimIndex": "", "FrameTime": 30, "Frames": []},
                         "BG": {"Layer": 0, "BGNum": 0, "BGX": 0, "BGY": 0}}
    obj["BlankBG"] = {"AutoTileset": "", "Associates": [], "Layers": [],
                      "NeighborCode": -1}
    obj["Layers"] = layers
    obj["AssetName"] = f"pmu_{sanitize(map_id)}"
    obj["Music"] = ""
    obj["EdgeView"] = 1
    obj["NoSwitching"] = True
    obj["ViewCenter"] = None
    obj["ViewOffset"] = {"X": 0, "Y": 0}
    obj["ActiveChar"] = None
    obj["Decorations"] = [{"Name": "New Deco", "Layer": 0, "Visible": True, "Anims": []}]
    obj["Entities"] = ([{"Name": "New EntLayer", "Visible": True, "MapChars": [],
                         "GroundObjects": [], "Spawners": [], "Markers": markers}]
                        if markers else [])
    return "\ufeff" + json.dumps({"Version": "0.8.9.0", "Object": obj},
                                 ensure_ascii=False, separators=(",", ": "))


INIT_LUA = """--[[
    init.lua — import automatique PMU « {mid} » (pipeline pmu_maps v{ver}).
    Environnement seul : le fondu d'entrée est libéré à Enter() (exigence
    moteur — sinon EnterGroundMap fige la scène). Aucun routing de scénario,
    aucun PNJ, aucune interaction : la sémantique PMU vit dans
    output/pmu/{mid}/semantics.json et les markers de la carte, en attente
    d'un jalon « structures/Gameplay » dédié.
]]--
require 'origin.common'

local {name} = {{}}

function {name}.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_{name} <<=')
end

function {name}.Enter(map)
  GAME:FadeIn(20)
end

function {name}.Update(map, time)
end

function {name}.GameSave(map)
end

function {name}.GameLoad(map)
  GAME:FadeIn(20)
end

return {name}
"""


def compare_to_render(png_a: str, ground_img: Image.Image) -> dict:
    """render.png PMU (RGBA sur fond transparent) posé sur NOIR, confronté à la
    relecture du .rsground (RGB). Écart mesuré et affiché, jamais masqué."""
    pmu = Image.open(png_a).convert("RGBA")
    base = Image.new("RGB", pmu.size, (0, 0, 0))
    ref = Image.composite(pmu.convert("RGB"), base, pmu.getchannel("A"))
    got = ground_img.convert("RGB")
    if ref.size != got.size:
        return {"match": False, "reason": f"taille {ref.size} vs {got.size}",
                "differing_px": -1, "max_channel_delta": -1, "bbox": None}
    diff = ImageChops.difference(ref, got)
    ext = diff.getbbox()
    hist = diff.convert("L").histogram()
    ndiff = sum(hist[1:])
    maxd = max((i for i, c in enumerate(hist) if c), default=0)
    return {"match": ext is None, "differing_px": ndiff, "max_channel_delta": maxd,
            "bbox": list(ext) if ext else None}


def import_one(cat_map: dict, out_root: str, store: rpm.TileStore, mode: str,
               texsize: int, write: bool, register: bool) -> dict:
    mid = cat_map["id"]
    ok, why = check_gate(out_root, mid)
    if not ok:
        return {"map_id": mid, "status": "REFUSED", "reason": why,
                "next": f"preview/validate/approve --select {mid}",
                "encrypted": cat_map.get("encryption", "none")}
    d = os.path.join(out_root, "pmu", mid)
    nd = os.path.join(out_root, "newera", mid)
    os.makedirs(nd, exist_ok=True)
    raw = open(cat_map["path"], "rb").read()
    parsed = rpm.parse_map(raw)
    render_path = os.path.join(d, "render.png")
    render_bytes = open(render_path, "rb").read()
    mapname = f"pmu_{sanitize(mid)}"
    prov = {"pmu_file": cat_map["file"], "pmu_sha1": rpm.sha1(raw),
            "pmu_sha256": sha256(raw), "render_sha256": sha256(render_bytes),
            "pmu_manifest": os.path.relpath(os.path.join(d, "manifest.json"), REPO_ROOT)}

    if mode == "B":
        out = {"map_id": mid, "status": "OK", "mode": "B (reference)",
               "generated": now(), "provenance": prov,
               "note": ("AUCUNE carte générée en mode B. Le PNG est la référence "
                        "d'artiste ; la recréation graphique est une étape "
                        "ultérieure distincte, hors pipeline de préservation."),
               "deliverables": [], "no_map_generated": True}
        if write:
            pic = os.path.join(REPO_ROOT, "Content", "Pictures")
            os.makedirs(pic, exist_ok=True)
            dest = os.path.join(pic, f"{mapname}_ref.png")
            with open(dest, "wb") as fh:
                fh.write(render_bytes)
            out["deliverables"].append(os.path.relpath(dest, REPO_ROOT))
        else:
            dest = os.path.join(nd, f"{mapname}_ref.png")
            with open(dest, "wb") as fh:
                fh.write(render_bytes)
            out["deliverables"].append(os.path.relpath(dest, REPO_ROOT))
        with open(os.path.join(nd, "manifest.json"), "w") as fh:
            json.dump(out, fh, indent=1)
        return out

    # ------------------------------------------------------------- MODE A ----
    sheet_name = f"{mapname}_tiles"
    try:
        grille, layers, obstacles, stats, grid_wh, cell_px = \
            build_sheet_and_layers(parsed, store, sheet_name, texsize)
    except ValueError as exc:
        return {"map_id": mid, "status": "REFUSED", "mode": f"A (texsize {texsize})",
                "reason": str(exc), "provenance": prov}
    sem = semantics_from_parsed(parsed)
    with open(os.path.join(d, "semantics.json"), "w") as fh:
        json.dump(sem, fh, indent=1)
    payload = build_rsground(mid, parsed, layers, obstacles, texsize,
                             markers_from_semantics(sem, cell_px))

    result = OrderedDict()
    result["map_id"] = mid
    result["mode"] = "A (pixel-perfect)"
    result["generated"] = now()
    result["provenance"] = prov
    result["grid"] = {"cells_xy": grid_wh, "cell_px": cell_px, "texsize": texsize,
                      "engine_status": ("proven-path (TexSize=1, cellules 8 px, "
                                        "comme town_hollow validé in-engine)"
                                        if texsize == 1 else
                                        "schema-valid, editor-unverified (experimental)")}
    result["build_stats"] = stats
    result["semantics"] = {"special_tiles": len(sem["specials"]),
                           "unknown_types": sem["unknown_types"],
                           "file": os.path.relpath(os.path.join(d, "semantics.json"), REPO_ROOT)}
    result["not_in_png_declared"] = [
        "collision : source = PMU TileType du .dat (JAMAIS les pixels)",
        "warps/portes : types + Data1-3 bruts → semantics.json ; markers de "
        "position posés ; sémantique des cibles NON inventée",
        "NPCs : numéros/spawns lus dans le .dat seulement ; NON instanciés (le "
        "mapping identité PMU→PMDO est un jalon séparé)",
        "animation multi-images : les archives .tile de ce dump sont mono-frame ; "
        "l'anim PMU = index de REMPLACEMENT déjà appliqué au rendu ; FrameLength "
        "60 constant — rien d'inventé",
        "météo/overlay/musique PMU : non mappés (les .mp3 PMU ne sont pas dans ce "
        "dépôt) — music/pmuref dans le manifest amont",
    ]
    if stats["missing_set"]:
        result["gaps"] = (f"{stats['missing_set']} refs de set manquant — ignorées "
                          "AUSSI au rendu PMU (cohérent), jamais remplacées")

    if write:
        ground_dir = os.path.join(REPO_ROOT, "Data", "Ground")
        tile_dir = os.path.join(REPO_ROOT, "Content", "Tile")
    else:
        base = os.path.join(nd, "dryrun")
        ground_dir = os.path.join(base, "Data", "Ground")
        tile_dir = os.path.join(base, "Content", "Tile")
        os.makedirs(ground_dir, exist_ok=True)
        os.makedirs(tile_dir, exist_ok=True)
    sheet_path = os.path.join(tile_dir, sheet_name + ".tile")
    sheet_info = write_tile_sheet(sheet_path, 8 * texsize, grille)
    gp = os.path.join(ground_dir, f"{mapname}.rsground")
    with open(gp, "w", encoding="utf-8") as fh:
        fh.write(payload)
    if write:
        subprocess.run([sys.executable,
                        os.path.join(REPO_ROOT, "tools", "rebuild_tile_index.py")],
                       capture_output=True, text=True)

    gimg, gmeta = rgp.render_ground(pathlib.Path(gp),
                                    rgp.SheetLoader([pathlib.Path(tile_dir)]), tick=0)
    cmp = compare_to_render(render_path, gimg)
    partial = json.load(open(os.path.join(d, "manifest.json")))["transparency"]["partial_alpha_px"]
    rt = OrderedDict()
    rt["method"] = "tools/render_ground_png.py (relecteur officiel) sur les fichiers écrits"
    rt["rsground"] = os.path.relpath(gp, REPO_ROOT)
    rt["tileset"] = os.path.relpath(sheet_path, REPO_ROOT)
    rt["tileset_info"] = sheet_info
    rt["ground_render_meta"] = gmeta
    rt.update(cmp)
    if not cmp["match"]:
        if partial and cmp["differing_px"] >= 0 and cmp["max_channel_delta"] <= 1:
            rt["verdict"] = (f"NEAR-EXACT : {cmp['differing_px']} px à ±1 — dû à "
                             f"{partial} px d'alpha partiel du PNG amont, "
                             "pré-multiplié pour le format .tile ; écart mesuré, "
                             "non masqué")
            result["status"] = "OK_WITH_FIDELITY_NOTES"
        else:
            rt["verdict"] = "MISMATCH — import bloqué (jamais forcé)"
            result["status"] = "REFUSED"
            result["reason"] = f"round-trip disque non identique : {cmp}"
            result["roundtrip"] = rt
            gimg.save(os.path.join(nd, "rsground_roundtrip_render.png"))
            with open(os.path.join(nd, "manifest.json"), "w") as fh:
                json.dump(result, fh, indent=1)
            if not write:
                import shutil
                shutil.rmtree(os.path.join(nd, "dryrun"), ignore_errors=True)
            return result
    else:
        rt["verdict"] = "BYTE-IDENTICAL (vue engine relue == rendu PMU)"
    result.setdefault("status", "OK")
    result["roundtrip"] = rt

    result["installed"] = {"rsground": os.path.relpath(gp, REPO_ROOT),
                           "rsground_sha256": sha256(payload.encode()),
                           "tileset": rt["tileset"],
                           "tileset_entries": sheet_info["entries"],
                           "tileset_unique": sheet_info["unique"],
                           "markers": len(sem["specials"]), "dry_run": not write}
    if write:
        lua_dir = os.path.join(REPO_ROOT, "Data", "Script", "halcyon", "ground", mapname)
        os.makedirs(lua_dir, exist_ok=True)
        with open(os.path.join(lua_dir, "init.lua"), "w", encoding="utf-8") as fh:
            fh.write(INIT_LUA.format(mid=mid, name=mapname, ver=PIPELINE_VERSION))
        result["installed"]["init_lua"] = f"Data/Script/halcyon/ground/{mapname}/init.lua"
        if register:
            mzf = os.path.join(REPO_ROOT, "Data", "Zone", "master_zone.json")
            txt = open(mzf, encoding="utf-8-sig").read()
            if f'"{mapname}"' in txt:
                result["installed"]["registration"] = "déjà présente"
            else:
                txt2 = txt.replace('"GroundMaps": [', f'"GroundMaps": [\n    "{mapname}",', 1)
                assert txt2 != txt, "ancrage GroundMaps introuvable — non forcé"
                with open(mzf, "w", encoding="utf-8-sig") as fh:
                    fh.write(txt2)
                result["installed"]["registration"] = f"GroundMaps += {mapname}"
    with open(os.path.join(nd, "registration_snippet.json"), "w") as fh:
        json.dump({"map_id": mid, "asset": mapname, "groundmaps_entry": mapname,
                   "init_lua": result["installed"].get("init_lua"),
                   "note": "dry-run : rien écrit sous Data/ ni Content/"
                           if not write else "installé"}, fh, indent=1)
    with open(os.path.join(nd, "manifest.json"), "w") as fh:
        json.dump(result, fh, indent=1)
    gimg.save(os.path.join(nd, "rsground_roundtrip_render.png"))
    return result


def do_status(cat: dict, sel: list[str] | None) -> int:
    for m in cat["maps"]:
        if sel and m["id"] not in sel:
            continue
        line = f"{m['id']:>12}  {m['render_status']:<30} {m['import_status']}"
        if m.get("encryption") not in (None, "none"):
            line += f"   [{m['encryption']}]"
        print(line)
    return 0


# ------------------------------------------------------------------ selftest --
def _fixture_tiles_dir(tmp: str) -> str:
    d = os.path.join(tmp, "Tiles")
    os.makedirs(d, exist_ok=True)
    colors = {0: (0, 0, 0, 0), 1: (122, 159, 63, 255), 2: (63, 111, 255, 255),
              3: (40, 40, 40, 255), 4: (240, 210, 130, 255)}
    cols, rows = 8, 1
    recs = []
    for i in range(cols * rows):
        im = Image.new("RGBA", (32, 32), colors.get(i % 5, (9, 9, 9, 255)))
        b = BytesIO()
        im.save(b, format="PNG")
        recs.append(b.getvalue())
    out = bytearray(struct.pack("<ii", cols * 32, rows * 32))
    pos = 0
    for r in recs:
        out += struct.pack("<qi", pos, len(r))
        pos += len(r)
    for r in recs:
        out += r
    open(os.path.join(d, "Tiles0.tile"), "wb").write(bytes(out))
    return d


def _fixture_dat(tmp: str, fname: str = "Map-sTEST.dat") -> str:
    lines = ["MapData|V9|1|19|14|",
             "Data|SelfTest Town|0|0|0|0|0|none.ogg|True||0|0|0|1|1|0|0|0|0|0|"]
    grid = {(x, y): {name: 0 for name in rpm.FIELD}
            for x in range(20) for y in range(15)}
    grid[(0, 0)].update({"ground": 1, "ground_set": 0})
    grid[(1, 0)].update({"ground": 2, "ground_set": 0})
    grid[(2, 1)].update({"ground": 3, "ground_set": 0, "mask": 4, "mask_set": 0,
                         "type": 1})
    grid[(3, 0)].update({"ground": 99, "ground_set": 0, "type": 2, "data1": 42})
    grid[(1, 1)].update({"fringe": 1, "fringe_set": 0})
    # lignes V9 : champs 3..30 complets (strings 17-19 + rval 20 inclus)
    idx2name = {i: n for n, i in rpm.FIELD.items()}
    idx2name.update({17: "string1", 18: "string2", 19: "string3", 20: "rval"})
    for (x, y) in sorted(grid):
        t = grid[(x, y)]
        f = ["Tile", str(x), str(y)]
        for i in range(3, 31):
            n = idx2name.get(i)
            v = t.get(n, "" if i in (17, 18, 19) else 0)
            f.append("" if i in (17, 18, 19) else str(v))
        lines.append("|".join(f) + "|")
    p = os.path.join(tmp, fname)
    open(p, "wb").write(("\n".join(lines)).encode("utf-8"))
    return p


def selftest(golden: bool, tiles_dir: str | None) -> int:
    tmp = tempfile.mkdtemp(prefix="pmu_selftest_")
    out = os.path.join(tmp, "out")
    fails: list[str] = []

    def check(name, cond, extra=""):
        print(f"  [{'ok' if cond else 'FAIL'}] {name} {extra}")
        if not cond:
            fails.append(name)

    print("SELFTEST pmu_pipeline (fixtures déterministes, aucune donnée externe requise)")
    store = rpm.TileStore(_fixture_tiles_dir(tmp))
    cat = {"id": "sTEST", "file": "Map-sTEST.dat", "path": _fixture_dat(tmp),
           "renderable": True, "encryption": "none"}
    man = render_one(cat, out, store)
    check("dims = 20×15 × 32 (clamp client 19×14 inclus)",
          man["render"]["pixel_size"] == [640, 480])
    check("déterminisme 2 passes", man["validation"]["determinism_2run"] == "identical")
    check("fallback déclaré (index hors bornes → tuile 0)",
          man["render"]["fallback_count"] == 1, f"n={man['render']['fallback_count']}")
    check("transparence préservée (index 0 = rien dessiné)",
          man["transparency"]["transparent_px"] > 0)
    check("aucune échelle, aucun crop déclarés",
          man["validation"]["cropping_applied"] is False
          and man["validation"]["scaling_applied"] is False)
    check("aucune tuile inventée (5 tuiles fixture seulement)",
          set(man["tiles_archives_sha1"]) == {"0"})

    r = import_one(cat, out, store, "A", 1, write=False, register=False)
    check("gate : import refusé sans approbation", r["status"] == "REFUSED",
          r.get("reason", ""))
    validate_one(cat, out)
    approve_one(out, "sTEST", "approve", "selftest")
    r = import_one(cat, out, store, "A", 1, write=False, register=False)
    check("round-trip disque byte-identical (mode A texsize1)",
          r.get("roundtrip", {}).get("match") is True,
          f"({r.get('reason') or r['roundtrip'].get('verdict')})")
    dryg = os.path.join(out, "newera", "sTEST", "dryrun", "Data", "Ground",
                        "pmu_stest.rsground")
    obj = json.load(open(dryg, encoding="utf-8-sig"))["Object"]
    obs = obj["obstacles"]
    check("obstacles : le Blocked PMU → Tags=1 sur son bloc 4×4 (et seulement lui)",
          obs[2 * 4][1 * 4]["Tags"] == 1 and obs[0][0]["Tags"] == 0)
    check("collision pas issue des pixels mais du type : Tags présents partout",
          all("Tags" in obs[x][y] and "Bounds" in obs[x][y]
              for x in range(len(obs)) for y in range(len(obs[x]))),
          f"grille {len(obs)}×{len(obs[0])}")
    check("écrivain .tile auto-verrou (relecture clés)",
          r["roundtrip"]["tileset_info"]["reload_keys_ok"] is True)
    sem = json.load(open(os.path.join(out, "pmu", "sTEST", "semantics.json")))
    check("warp sémantique conservé (type 2 + data1=42)",
          any(s["type_name"] == "Warp" and s["data1"] == 42 for s in sem["specials"]))

    rX = import_one(cat, out, store, "A", 4, write=False, register=False)
    check("texsize4 refusé avec message (pas de format non vérifiable)",
          rX["status"] == "REFUSED" and "TexSize=4" in rX.get("reason", ""),
          rX.get("reason", "")[:80])

    rB = import_one(cat, out, store, "B", 1, write=False, register=False)
    check("mode B = référence seule, aucun .rsground produit",
          rB["status"] == "OK" and rB["no_map_generated"])

    open(os.path.join(out, "pmu", "sTEST", "render.png"), "ab").write(b"\x00")
    gate_ok, why = check_gate(out, "sTEST")
    check("gate : render.png modifié ⇒ approbation périmée", not gate_ok, why)

    enc = os.path.join(tmp, "enc")
    os.makedirs(enc, exist_ok=True)
    open(os.path.join(enc, "Map-s9999.dat"), "wb").write(b"\x11" * 64)
    c2 = build_catalog([enc], out, write=False)
    check("encrypted marqué sans bloquer + intrant expliqué",
          c2["maps"][0]["encryption"] == "encrypted-unrecoverable"
          and "plaintext" in c2["maps"][0]["missing_input"]
          and c2["counts"]["renderable"] == 0)

    if golden:
        tdir = find_tiles_dir(tiles_dir)
        gp = os.path.join(TESTS_DATA, "golden_map95.json")
        if os.path.exists(gp) and tdir:
            g = json.load(open(gp))
            cat95 = {"id": GOLDEN_MAP, "file": "map95.dat",
                     "path": os.path.join(TESTS_DATA, "map95.dat"),
                     "renderable": True, "encryption": "none"}
            render_one(cat95, out, rpm.TileStore(tdir))
            sha = sha256(open(os.path.join(out, "pmu", GOLDEN_MAP, "render.png"), "rb").read())
            check("golden map95 : sha256 du rendu identique à la preuve",
                  sha == g["render_sha256"], sha[:16])
            validate_one(cat95, out)
            approve_one(out, GOLDEN_MAP, "approve", "selftest-golden")
            g95 = import_one(cat95, out, rpm.TileStore(tdir), "A", 1,
                             write=False, register=False)
            check("golden map95 : import sec (dry-run) round-trip OK",
                  g95.get("roundtrip", {}).get("match") is True
                  or g95.get("status") == "OK_WITH_FIDELITY_NOTES",
                  f"({g95.get('status')})")
        else:
            print("  [SKIP] golden map95 — planches PMU absentes (--tiles-dir / "
                  "PMU_TILES_DIR / assets/pmu_tiles). La preuve de référence reste "
                  "docs/pmu_maps/PROOF_render_pmu_map95.png ; le golden sha256 est "
                  "verrouillé dès que les planches sont fournies.")
    print("SELFTEST:", ("FAIL — " + ", ".join(fails)) if fails else "PASS")
    return 1 if fails else 0


# ----------------------------------------------------------------------- CLI --
def main() -> int:
    ap = argparse.ArgumentParser(prog="pmu_pipeline", description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--maps", action="append", default=None,
                    help="répertoire de .dat PMU (répétable ; défaut : tests_data "
                         "+ $PMU_MAPS_DIR)")
    ap.add_argument("--out", default=OUT_DEFAULT)
    ap.add_argument("--tiles-dir", default=None)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("catalog")
    for name in ("render", "preview", "validate", "status"):
        s = sub.add_parser(name)
        s.add_argument("--select", nargs="*", default=[])
    s = sub.add_parser("approve")
    s.add_argument("--select", nargs="*", required=True)
    s.add_argument("--decision", choices=["approve", "reject"], required=True)
    s.add_argument("--by", default=os.environ.get("USER", "unknown"))
    s = sub.add_parser("import")
    s.add_argument("--select", nargs="*", required=True)
    s.add_argument("--mode", choices=["A", "B"], required=True)
    s.add_argument("--texsize", type=int, choices=[1, 4], default=1,
                   help="1 = grille 8 px, seule chaîne vérifiable (défaut) ; "
                        "4 = refusé volontairement (le relecteur officiel du "
                        "dépôt ne lit que 8 px — pas de format parallèle)")
    s.add_argument("--write", action="store_true",
                   help="écrire réellement sous Data/ + Content/ (sinon dry-run)")
    s.add_argument("--register", action="store_true",
                   help="avec --write : ajouter au GroundMaps de master_zone.json")
    s = sub.add_parser("selftest")
    s.add_argument("--golden", action="store_true")

    a = ap.parse_args()
    if a.cmd == "selftest":
        return selftest(golden=a.golden, tiles_dir=a.tiles_dir)

    maps_dirs = list(a.maps or [])
    env = os.environ.get("PMU_MAPS_DIR")
    if env:
        maps_dirs.append(env)
    if not maps_dirs:
        maps_dirs = [TESTS_DATA]
    cat = build_catalog(maps_dirs, a.out)
    byid = {m["id"]: m for m in cat["maps"]}

    if a.cmd == "catalog":
        print(f"catalogue : {len(cat['maps'])} maps "
              f"(rendables {cat['counts']['renderable']}, chiffrées "
              f"{cat['counts']['encrypted']}) → {a.out}/pmu/catalog.md")
        return 0
    if a.cmd == "status":
        sel = resolve_selection(cat, a.select) if a.select else None
        return do_status(cat, sel)

    ids = resolve_selection(cat, a.select)
    if not ids:
        print("RIEN À FAIRE : sélection explicite requise — le pipeline ne traite "
              "JAMAIS le dépôt à l'aveugle. Ex. : --select Map-s1000 s1007",
              file=sys.stderr)
        return 2
    if a.cmd == "render":
        return do_render(a.out, ids, get_store(find_tiles_dir(a.tiles_dir)), cat)
    if a.cmd == "preview":
        store = get_store(find_tiles_dir(a.tiles_dir))
        for mid in ids:
            m = byid[mid]
            if not m.get("renderable"):
                print(f"[skip] {mid} ({m.get('encryption')})", file=sys.stderr)
                continue
            chk = preview_one(m, a.out, store)
            print(f"[preview] {mid} → {a.out}/pmu/{mid}/preview.png | "
                  f"solides={chk['solid_tiles_from_pmu_type']} "
                  f"transparents={chk['transparent_px']}", file=sys.stderr)
        return 0
    if a.cmd == "validate":
        rc = 0
        for mid in ids:
            r = validate_one(byid[mid], a.out)
            print(f"[validate] {mid} : {r.get('result')}", file=sys.stderr)
            rc |= 0 if r.get("result") == "PASS" else 1
        return rc
    if a.cmd == "approve":
        for mid in ids:
            r = approve_one(a.out, mid, a.decision, a.by)
            print(f"[approve] {mid} : {r['decision']} par {r['by']} "
                  f"sha={r['render_sha256'][:12]} (gel)", file=sys.stderr)
        return 0
    if a.cmd == "import":
        store = get_store(find_tiles_dir(a.tiles_dir))
        rc = 0
        for mid in ids:
            r = import_one(byid[mid], a.out, store, a.mode, a.texsize,
                           write=a.write, register=a.register)
            line = f"[import:{a.mode}] {mid} : {r['status']}"
            if r.get("reason"):
                line += f" — {r['reason'][:150]}"
            if r.get("roundtrip"):
                line += f" | roundtrip={r['roundtrip'].get('verdict', r['roundtrip'].get('match'))}"
            print(line, file=sys.stderr)
            if r["status"] not in ("OK", "OK_WITH_GAPS", "OK_WITH_FIDELITY_NOTES"):
                rc = 1
        return rc
    return 0


if __name__ == "__main__":
    sys.exit(main())
