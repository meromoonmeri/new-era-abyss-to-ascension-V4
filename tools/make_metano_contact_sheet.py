#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""make_metano_contact_sheet.py — assemble tous les rendus Metano en un PDF/contact sheet.

Crée une planche-contact (mosaïque) des 13 rendus Metano + 1 page d'atlas des tile sheets clés.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

RENDERS = Path(".runtime-cache/metano_renders")
ATLASES = Path(".runtime-cache/metano_atlases")
OUTDIR = Path(".runtime-cache/metanol_brief")

# Order by importance for the artist
RENDER_ORDER = [
    ("metano_town.png", "Metano Town (vue principale, 189×189)"),
    ("metano_town_nuit.png", "Metano Town (variante nuit)"),
    ("metano_altere_transition.png", "Metano Outskirts (transition sud)"),
    ("metano_cafe.png", "Metano Café"),
    ("metano_inn.png", "Metano Auberge"),
    ("metano_cave.png", "Metano Cave"),
    ("metano_fire_home.png", "Fire Home"),
    ("metano_water_home.png", "Water Home"),
    ("metano_grass_home.png", "Grass Home"),
    ("metano_electric_home.png", "Electric Home"),
    ("metano_rock_home.png", "Rock Home"),
    ("metano_normal_home.png", "Normal Home"),
    ("treasure_spinda_cafe.png", "Spinda Café (autre ville)"),
]

ATLAS_ORDER = [
    ("Metano_Town_Trimmed.png", "Tile sheet complet composé (vue d'artiste)"),
    ("Metano_Town_Base.png", "Ground (sol) — 189×189"),
    ("Metano_Town_Cliffs.png", "Cliffs (falaises) — 189×68"),
    ("Metano_Town_Objects.png", "Objects (bâtiments, arbres) — 189×189"),
    ("Metano_Town_River_Animation_1.png", "Eau animée frame 1 — 142×189"),
    ("Metano_Town_Fringe.png", "Fringe (bord haut) — 133×143"),
    ("Metano_Town_Animated.png", "Animated (drapeau, fumée) — 189×??"),
    ("Metano_Town_Animation_Tileset.png", "Animation Tileset — 64×176"),
]


def make_sheet(images, out_path, cols=2, title="", caption_height=40, max_h_per_cell=800):
    """Assemble une mosaïque d'images."""
    # Filter existing
    available = [(p, c) for p, c in images if (RENDERS / p).exists() or (ATLASES / p).exists()]
    if not available:
        print(f"No images found for {out_path}")
        return
    n = len(available)
    rows = (n + cols - 1) // cols

    # Load images and compute cell sizes
    loaded = []
    max_cell_w = 0
    total_caption_h = rows * caption_height
    for fn, cap in available:
        if (RENDERS / fn).exists():
            img = Image.open(RENDERS / fn)
        else:
            img = Image.open(ATLASES / fn)
        # Scale down to fit max_h_per_cell
        if img.height > max_h_per_cell:
            ratio = max_h_per_cell / img.height
            img = img.resize((int(img.width * ratio), int(img.height * ratio)), Image.LANCZOS)
        loaded.append((img, cap))
        if img.width > max_cell_w:
            max_cell_w = img.width

    # Compute final canvas
    cell_w = max_cell_w + 40
    cell_h = max_h_per_cell + caption_height + 40
    canvas_w = cell_w * cols + 40
    canvas_h = cell_h * rows + 80 + (60 if title else 0)

    canvas = Image.new("RGBA", (canvas_w, canvas_h), (255, 255, 255, 255))
    draw = ImageDraw.Draw(canvas)

    # Title
    y_offset = 0
    if title:
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
        except Exception:
            font = ImageFont.load_default()
        draw.text((20, 20), title, fill=(0, 0, 0, 255), font=font)
        y_offset = 70

    # Place images
    for i, (img, cap) in enumerate(loaded):
        row = i // cols
        col = i % cols
        x = col * cell_w + 20
        y = y_offset + row * cell_h + 20
        canvas.paste(img, (x, y), img if img.mode == 'RGBA' else None)
        # Caption
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 18)
        except Exception:
            font = ImageFont.load_default()
        draw.text((x, y + img.height + 4), cap, fill=(0, 0, 0, 255), font=font)

    canvas.save(out_path)
    print(f"-> {out_path} ({out_path.stat().st_size / 1024:.0f} KB, {canvas.size[0]}x{canvas.size[1]} px)")


def main():
    OUTDIR.mkdir(parents=True, exist_ok=True)
    print("Creating renders contact sheet...")
    make_sheet(RENDER_ORDER, OUTDIR / "metano_renders_contact_sheet.png", cols=2,
               title="Metano Town + Peripheries - Renders (vue finale du jeu)",
               max_h_per_cell=900)
    print("\nCreating atlases contact sheet...")
    make_sheet(ATLAS_ORDER, OUTDIR / "metano_atlases_contact_sheet.png", cols=2,
               title="Metano Town - Tile Sheets (atlas sources pour le pixel artist)",
               max_h_per_cell=600)


if __name__ == "__main__":
    main()
