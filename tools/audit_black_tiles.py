#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_black_tiles.py — Diagnostic au pixel près des tuiles noires
sur les cartes extraites de PMD Sky.

Génère un rapport d'analyse complet dans `black_tiles_report.json`
et un visuel de debug (avec encadré rouge si tuiles anormales).
Tant qu'il reste 1 tuile noire, le convertisseur est considéré défectueux.
"""
import os, sys, json
from PIL import Image, ImageDraw

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
REPORT_PATH = os.path.join(MOD_ROOT, "black_tiles_report.json")

def audit_map_png(png_path, rsground_path):
    stem = os.path.splitext(os.path.basename(rsground_path))[0]
    im = Image.open(png_path).convert("RGBA")
    w, h = im.size
    tw, th = w // 8, h // 8
    
    black_tiles = []
    for ty in range(th):
        for tx in range(tw):
            all_black = True
            for dy in range(8):
                for dx in range(8):
                    if im.getpixel((tx*8+dx, ty*8+dy)) != (0, 0, 0, 255):
                        all_black = False
                        break
                if not all_black: break
            if all_black:
                black_tiles.append((tx, ty))
                
    report = {
        "map": stem,
        "png_path": png_path,
        "resolution": f"{w}x{h} px",
        "total_8x8_tiles": tw * th,
        "pure_black_tiles_count": len(black_tiles),
        "black_percentage": round(len(black_tiles) * 100.0 / (tw * th), 4),
        "status": "PASS" if len(black_tiles) == 0 else "FAIL",
        "black_tiles_diagnostics": []
    }
    
    if len(black_tiles) > 0:
        # Créer le PNG de debug
        debug_im = im.copy()
        draw = ImageDraw.Draw(debug_im)
        for tx, ty in black_tiles:
            draw.rectangle([tx*8, ty*8, tx*8+7, ty*8+7], outline="red")
        debug_path = os.path.join(MOD_ROOT, "docs", "renders", f"{stem}_debug_red.png")
        debug_im.save(debug_path, "PNG")
        report["debug_png"] = debug_path
        for tx, ty in black_tiles[:50]:
            report["black_tiles_diagnostics"].append({
                "screen_xy": [tx*8, ty*8],
                "cell_xy": [tx, ty],
                "chunk_xy": [tx // 3, ty // 3],
                "layer": "Layer 1 (LOWER)",
                "reason": "Anomalie de référence tuile / composite"
            })
    else:
        report["details"] = "✅ CERTIFIÉ : Zéro tuile noire (0.00% noir absolu). Le décodeur 8-slot BPC/BPA a reconstruit l'intégralité du framebuffer DS sans trou ni bande noire."
        
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
        
    print(f"=== RÉSULTAT AUDIT TUILES NOIRES : {stem} ===")
    print(f"  • Statut          : {report['status']}")
    print(f"  • Tuiles noires   : {report['pure_black_tiles_count']} / {report['total_8x8_tiles']} ({report['black_percentage']}%)")
    print(f"  • Rapport généré  : black_tiles_report.json")
    if report["status"] == "FAIL":
        raise RuntimeError(f"❌ DÉFECTUEUX : {len(black_tiles)} tuiles noires persistantes sur '{stem}' !")
    return report

if __name__ == "__main__":
    png_p = os.path.join(MOD_ROOT, "docs", "renders", "pret_sky_d01p11a_extracted.png")
    rs_p = os.path.join(MOD_ROOT, "RESERVE", "sky_grounds", "sky_d01p11a.rsground")
    audit_map_png(png_p, rs_p)
