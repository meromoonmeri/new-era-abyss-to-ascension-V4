#!/usr/bin/env python3
"""Génère output/pmu/selector.html — vignettes des maps découvrables + cases à
cocher qui produisent la commande pmu_pipeline à copier. Lecture seule, sans
serveur : ouvrir le fichier dans un navigateur. Ne modifie jamais une map.

    python3 tools/pmu_maps/selector_view.py            (relit output/pmu/catalog.json)
    python3 tools/pmu_maps/selector_view.py --maps DIR --out output
"""
from __future__ import annotations

import argparse
import html
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, ".."))

TEMPLATE = """<!doctype html><html lang=fr><head><meta charset=utf-8>
<meta name=viewport content="width=device-width,initial-scale=1">
<title>Sélecteur de maps PMU</title><style>
:root{color-scheme:dark}body{font:14px/1.4 ui-monospace,monospace;background:#15151c;color:#e6e6ee;margin:0}
header{position:sticky;top:0;background:#0d0d13ee;padding:10px 16px;border-bottom:1px solid #333;z-index:5}
h1{font-size:15px;margin:0 0 6px}button{background:#2b6;padding:#4px 10px;border:0;border-radius:5px;color:#041;font-weight:700;cursor:pointer}
#cmd{white-space:pre;background:#000;color:#8fd;border-radius:6px;padding:8px;margin:6px 0;font-size:12px;overflow:auto;border:1px solid #345}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:12px;padding:16px}
.card{background:#1d1d27;border:1px solid #2c2c38;border-radius:8px;overflow:hidden;display:flex;flex-direction:column}
.card.sel{outline:2px solid #2b6}
.card img{width:100%;height:150px;object-fit:contain;background:#0a0a10 image-rendering:pixelated;image-rendering:pixelated}
.card .b{padding:8px;font-size:11px}.card b{font-size:13px;color:#fff}
.tag{display:inline-block;padding:1px 6px;border-radius:4px;font-size:10px;margin:2px 2px 0 0}
.ok{background:#13401d;color:#9f9}.no{background:#40131a;color:#f99}.wa{background:#3a3110;color:#ed6}
.nopic{height:150px;display:flex;align-items:center;justify-content:center;color:#666;background:#0a0a10}
</style></head><body>
<header><h1>Sélecteur de maps PMU — @@NCARDS@@ maps (@@RENDERABLE@@ rendables, @@ENC@@ chiffrées) · vignettes = render.png réels quand dispo</h1>
<div><button onclick=copycmd()>copier la commande</button> <span id=hint>coche des cartes → la commande se met à jour</span></div>
<div id=cmd>@@CMD@@</div></header>
<div class=grid>@@CARDS@@</div>
<script>
function upd(){var s=[...document.querySelectorAll('.card input:checked')].map(e=>e.dataset.id);
var c='python3 tools/pmu_maps/pmu_pipeline.py @@MAPFLAG@@ '+(s.length?('render --select '+s.join(' ')):'(coche une carte)');
document.getElementById('cmd').textContent=c;document.querySelectorAll('.card').forEach(cd=>cd.classList.toggle('sel',cd.querySelector('input').checked));}
function copycmd(){navigator.clipboard.writeText(document.getElementById('cmd').textContent);document.getElementById('hint').textContent='copié ✓';setTimeout(()=>document.getElementById('hint').textContent='coche des cartes → la commande se met à jour',1200);}
document.addEventListener('change',upd);upd();
</script></body></html>"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--maps", action="append", default=None)
    ap.add_argument("--out", default="output")
    a = ap.parse_args()

    if a.maps:
        import pmu_pipeline as pp
        cat = pp.build_catalog(a.maps, a.out)
    else:
        cat = json.load(open(os.path.join(a.out, "pmu", "catalog.json")))
    renderable = cat.get("counts", {}).get("renderable", 0)
    enc = cat.get("counts", {}).get("encrypted", 0)
    cards = []
    mapflag = " ".join(f"--maps {html.escape(os.path.relpath(d, '.'))}"
                       for d in cat.get("maps_dirs", [])) or ""
    for m in cat["maps"]:
        prev = None
        for cand in (f"pmu/{m['id']}/render.png", f"pmu/{m['id']}/preview.png"):
            p = os.path.join(a.out, cand)
            if os.path.exists(p):
                prev = os.path.relpath(p, os.path.join(a.out, "pmu"))
                break
        cls = "ok" if m.get("renderable") else ("no" if "encrypted" in str(m.get("encryption")) else "wa")
        thumb = (f'<img src="{html.escape(prev)}" alt="{m["id"]}">' if prev
                 else f'<div class=nopic>{html.escape(str(m.get("encryption","?")))}</div>')
        dims = "×".join(map(str, m.get("dims_tiles", ["—", "—"])))
        cards.append(
            f'<label class=card><input type=checkbox data-id="{html.escape(m["id"])}">'
            f'{thumb}<div class=b><b>{html.escape(m["id"])}</b> · {html.escape(m.get("format","?"))}<br>'
            f'dims {dims} · tuiles {m.get("tile_count","—")}<br>'
            f'sha1 <code>{m["sha1"][:10]}</code><br>'
            f'<span class="tag {cls}">{html.escape(m.get("encryption","none"))}</span>'
            f'<span class="tag">{html.escape(m.get("render_status","?"))}</span>'
            f'<span class="tag">{html.escape(m.get("import_status","?"))}</span></div></label>')
    out_html = TEMPLATE
    for k, v in {"@@NCARDS@@": len(cat["maps"]), "@@RENDERABLE@@": renderable,
                 "@@ENC@@": enc, "@@CARDS@@": "".join(cards),
                 "@@CMD@@": "(coche une carte)", "@@MAPFLAG@@": mapflag}.items():
        out_html = out_html.replace(k, str(v))
    dest = os.path.join(a.out, "pmu", "selector.html")
    with open(dest, "w", encoding="utf-8") as fh:
        fh.write(out_html)
    print(f"selector : {dest}  ({len(cat['maps'])} cartes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
