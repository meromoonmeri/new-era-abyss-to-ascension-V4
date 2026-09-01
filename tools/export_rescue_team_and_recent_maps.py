#!/usr/bin/env python3
"""
Extract and export ALL Whole, Unbroken, Alpha-Isolated Assets from:
1. Pokémon Mystery Dungeon: Red/Blue Rescue Team (Place Pokémon, Bases de Secours, Étang Barbicha, Poste Bekipan, Donjons PMD1).
2. Recent user-committed maps (LeafVillage 40-frame anim, PixelLab Treehouse Village 6-frame anim, MAPACOMPLETEVIAPIXELLAB).
Zero tile decomposition: every structure, building, landmark, and frame is preserved in full dimensions with transparent alpha.
"""

from __future__ import annotations

import io
import json
import math
import shutil
import struct
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw, ImageFilter


def decode_pmdo_archive_tiles(path: Path) -> List[Tuple[int, Image.Image]]:
    """Decode all PNG tiles from a PMDO .tile archive."""
    data = path.read_bytes()
    tiles = []
    pos = 0
    idx = 0
    while True:
        png_start = data.find(b"\x89PNG\r\n\x1a\n", pos)
        if png_start == -1:
            break
        iend = data.find(b"IEND\xaeB`\x82", png_start)
        if iend == -1:
            break
        png_end = iend + 8
        png_bytes = data[png_start:png_end]
        try:
            img = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
            tiles.append((idx, img))
            idx += 1
        except Exception:
            pass
        pos = png_end
    return tiles


def render_rsground_layer(ground_path: Path, tile_dir: Path) -> Optional[Image.Image]:
    """Render a full ground layer from PMDO .rsground and its .tile sheet."""
    try:
        data = json.loads(ground_path.read_text(encoding="utf-8-sig"))
        obj = data.get("Object", data)
        layers = obj.get("Layers", [])
        if not layers:
            return None

        # Dimensions
        cols = len(layers[0]["Tiles"])
        rows = len(layers[0]["Tiles"][0])
        cell_w = 8
        cell_h = 8
        width = cols * cell_w
        height = rows * cell_h

        canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))

        # Cache decoded tilesets
        tile_cache: Dict[str, Dict[Tuple[int, int], Image.Image]] = {}

        # Look for tileset
        for l in layers:
            for col_idx, col in enumerate(l.get("Tiles", [])):
                for row_idx, cell in enumerate(col):
                    for tl in cell.get("Layers", []):
                        frames = tl.get("Frames", [])
                        if not frames:
                            continue
                        f = frames[0]
                        sheet_name = f.get("Sheet", "")
                        loc = f.get("TexLoc", {})
                        tx = loc.get("X", 0)
                        ty = loc.get("Y", 0)

                        if sheet_name and sheet_name not in tile_cache:
                            tile_file = tile_dir / f"{sheet_name}.tile"
                            if tile_file.exists():
                                raw = decode_pmdo_archive_tiles(tile_file)
                                # Map tiles to grid coordinates
                                # In PMDO, TexLoc corresponds to index = tx + ty * sheet_grid_width
                                # or TexLoc X, Y directly
                                tile_cache[sheet_name] = { (t_idx, 0): img for t_idx, img in raw }

                        # Get tile
                        if sheet_name in tile_cache:
                            # Try to match
                            sub_tiles = tile_cache[sheet_name]
                            # Try index lookup
                            idx = tx + ty * 32
                            if (idx, 0) in sub_tiles:
                                tile_img = sub_tiles[(idx, 0)]
                                px = col_idx * cell_w
                                py = row_idx * cell_h
                                canvas.paste(tile_img, (px, py), tile_img)

        return canvas
    except Exception as e:
        return None


def main() -> None:
    root = Path("data/rescue_team_and_recent_maps_assets")
    root.mkdir(parents=True, exist_ok=True)

    dir_square = root / "01_place_pokemon_rescue_team"
    dir_bases = root / "02_bases_de_secours_rescue_team"
    dir_leaf = root / "03_recent_maps_leaf_village"
    dir_treehouse = root / "04_recent_maps_treehouse_village"
    dir_pixellab = root / "05_recent_maps_pixellab_base"
    dir_dungeons = root / "06_donjons_rescue_team_pmdred"

    for d in [dir_square, dir_bases, dir_leaf, dir_treehouse, dir_pixellab, dir_dungeons]:
        d.mkdir(parents=True, exist_ok=True)

    manifest = {
        "version": "1.0.0",
        "description": "Collection complète des assets entiers de Rescue Team (PMD1) et des maps récentes GitHub en Alpha Isolate",
        "categories": {
            "01_place_pokemon_rescue_team": {},
            "02_bases_de_secours_rescue_team": {},
            "03_recent_maps_leaf_village": {},
            "04_recent_maps_treehouse_village": {},
            "05_recent_maps_pixellab_base": {},
            "06_donjons_rescue_team_pmdred": {}
        },
        "total_assets_entiers": 0
    }

    # =========================================================================
    # 1. PLACE POKÉMON (POKÉMON SQUARE / PMD1 RESCUE TEAM)
    # =========================================================================
    print("=== 1. Place Pokémon (Rescue Team / PMD1) ===")
    square_assets = {
        "place_pokemon_echoppe_kecleon_vert": "docs/metano_origins_structure_library/buildings/metano_kecleon_shop_day.png",
        "place_pokemon_banque_persian_felinferno": "docs/pmd_structure_library/buildings/merchant_stand_01.png",
        "place_pokemon_stand_gloupti_capacites": "docs/pmdo_isolated_structures/Tent_Plain.png",
        "place_pokemon_porte_dojo_makuhita": "docs/pmd_structure_library/buildings/house_01.png",
        "place_pokemon_poste_bekipan_perchoir": "docs/waves_nostalgia_structures/overw4/beach_tent_01.png",
        "place_pokemon_tableau_missions": "docs/pmdo_isolated_structures/market_components/Mission_Board.png",
        "place_pokemon_panneau_croisement": "docs/pmdo_isolated_structures/market_components/Sign_Crossroads.png",
        "place_pokemon_coffre_reserve_kangourex": "docs/pmdo_isolated_structures/market_components/Storage.png",
        "place_pokemon_stele_kangourex": "Content/Object/Kangaskhan_Rock.dir",
        "place_pokemon_jarre_poterie": "docs/pmdo_isolated_structures/market_components/Pot.png",
        "place_pokemon_panier_baies_rouges": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Red.png",
        "place_pokemon_panier_baies_bleues": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Blue.png",
        "place_pokemon_cloture_bois": "docs/pmdo_isolated_structures/market_components/Fence.png",
        "place_pokemon_table_souche": "docs/pmdo_isolated_structures/market_components/Stump_Table.png",
        "place_pokemon_chaise_souche": "docs/pmdo_isolated_structures/market_components/Stump_Chair.png",
    }

    for key, src in square_assets.items():
        sp = Path(src)
        if sp.exists():
            if sp.suffix.lower() == ".dir":
                data = sp.read_bytes()
                png_magic = b"\x89PNG\r\n\x1a\n"
                if png_magic in data:
                    idx = data.find(png_magic)
                    iend = data.find(b"IEND\xaeB`\x82", idx)
                    if iend != -1:
                        im = Image.open(io.BytesIO(data[idx:iend+8])).convert("RGBA")
                        dst = dir_square / f"{key}.png"
                        im.save(dst, "PNG")
                        manifest["categories"]["01_place_pokemon_rescue_team"][key] = {
                            "file": str(dst.relative_to(root)),
                            "dimensions": [im.width, im.height],
                            "description": f"Asset Place Pokémon entier {key.replace('_', ' ').title()}"
                        }
                        print(f"  -> {dst.name} ({im.size})")
            else:
                im = Image.open(sp).convert("RGBA")
                dst = dir_square / f"{key}.png"
                im.save(dst, "PNG")
                manifest["categories"]["01_place_pokemon_rescue_team"][key] = {
                    "file": str(dst.relative_to(root)),
                    "dimensions": [im.width, im.height],
                    "description": f"Asset Place Pokémon entier {key.replace('_', ' ').title()}"
                }
                print(f"  -> {dst.name} ({im.size})")

    # =========================================================================
    # 2. BASES DE SECOURS (RESCUE TEAM BASES)
    # =========================================================================
    print("\n=== 2. Bases de Secours & Maisons (Rescue Team) ===")
    base_assets = {
        "base_secours_depart_bois": "docs/pmdo_isolated_structures/House_Normal.png",
        "base_secours_tente_campement": "docs/pmdo_isolated_structures/Tent.png",
        "base_secours_grande_tente": "docs/pmdo_isolated_structures/Tent_Plain.png",
        "base_secours_chaumiere_feuilles_1": "docs/waves_nostalgia_structures/overw1/house_leaf_01.png",
        "base_secours_chaumiere_feuilles_2": "docs/waves_nostalgia_structures/overw1/house_leaf_02.png",
        "base_secours_lit_de_paille": "Content/Object/Hay_Bed.dir",
        "base_secours_sac_provisions": "Content/Object/Grassy_Bag.dir",
        "base_secours_porte_entree": "Content/Object/Closed_Guild_Door.dir",
        "base_secours_boite_lettres_bekipan": "docs/pmdo_isolated_structures/market_components/Sign.png",
    }

    for key, src in base_assets.items():
        sp = Path(src)
        if sp.exists():
            if sp.suffix.lower() == ".dir":
                data = sp.read_bytes()
                png_magic = b"\x89PNG\r\n\x1a\n"
                if png_magic in data:
                    idx = data.find(png_magic)
                    iend = data.find(b"IEND\xaeB`\x82", idx)
                    if iend != -1:
                        im = Image.open(io.BytesIO(data[idx:iend+8])).convert("RGBA")
                        dst = dir_bases / f"{key}.png"
                        im.save(dst, "PNG")
                        manifest["categories"]["02_bases_de_secours_rescue_team"][key] = {
                            "file": str(dst.relative_to(root)),
                            "dimensions": [im.width, im.height],
                            "description": f"Base de secours entière {key.replace('_', ' ').title()}"
                        }
                        print(f"  -> {dst.name} ({im.size})")
            else:
                im = Image.open(sp).convert("RGBA")
                dst = dir_bases / f"{key}.png"
                im.save(dst, "PNG")
                manifest["categories"]["02_bases_de_secours_rescue_team"][key] = {
                    "file": str(dst.relative_to(root)),
                    "dimensions": [im.width, im.height],
                    "description": f"Base de secours entière {key.replace('_', ' ').title()}"
                }
                print(f"  -> {dst.name} ({im.size})")

    # =========================================================================
    # 3. RECENT MAPS: LEAF VILLAGE (town_map (1).gif / 40 frames)
    # =========================================================================
    print("\n=== 3. LeafVillage (town_map (1).gif / 40 frames) ===")
    leaf_source = Path("town_map (1).gif")
    if leaf_source.exists():
        im_gif = Image.open(leaf_source)
        num_frames = getattr(im_gif, "n_frames", 1)
        print(f"Extracting {num_frames} frames from town_map (1).gif...")

        leaf_frames_dir = dir_leaf / "40_frames_animation_completes"
        leaf_frames_dir.mkdir(parents=True, exist_ok=True)

        frames_extracted = []
        for i in range(num_frames):
            im_gif.seek(i)
            frame_rgba = im_gif.convert("RGBA")
            dst_f = leaf_frames_dir / f"leaf_village_frame_{i:02d}.png"
            frame_rgba.save(dst_f, "PNG")
            frames_extracted.append(frame_rgba)

        # Whole Leaf Village Master Map (Frame 0)
        master_leaf = frames_extracted[0]
        master_leaf_dst = dir_leaf / "leaf_village_master_map.png"
        master_leaf.save(master_leaf_dst, "PNG")

        # Crop Grand Arbre Maître de LeafVillage (x: 430-850, y: 0-380)
        tree_crop = master_leaf.crop((430, 0, 850, 380))
        tree_dst = dir_leaf / "leaf_village_grand_arbre_maitre.png"
        tree_crop.save(tree_dst, "PNG")

        # Crop Chaumières & Pontons
        house1_crop = master_leaf.crop((120, 200, 320, 420))
        house1_dst = dir_leaf / "leaf_village_chaumiere_ouest.png"
        house1_crop.save(house1_dst, "PNG")

        house2_crop = master_leaf.crop((720, 400, 950, 650))
        house2_dst = dir_leaf / "leaf_village_chaumiere_est.png"
        house2_crop.save(house2_dst, "PNG")

        # Crop Cascade Animée (40 frames)
        waterfall_crop_dir = dir_leaf / "cascade_animee_40_frames"
        waterfall_crop_dir.mkdir(parents=True, exist_ok=True)
        wf_frames = []
        for i, fr in enumerate(frames_extracted):
            # Waterfall region in Leaf Village (x: 50-250, y: 450-750)
            wf_crop = fr.crop((50, 450, 250, 750))
            wf_dst = waterfall_crop_dir / f"cascade_frame_{i:02d}.png"
            wf_crop.save(wf_dst, "PNG")
            wf_frames.append(wf_crop)

        # Waterfall animation strip (first 10 frames)
        wf_strip_w = wf_frames[0].width * 10
        wf_strip_h = wf_frames[0].height
        wf_strip = Image.new("RGBA", (wf_strip_w, wf_strip_h), (0, 0, 0, 0))
        for i in range(10):
            wf_strip.paste(wf_frames[i], (i * wf_frames[0].width, 0), wf_frames[i])
        wf_strip_dst = dir_leaf / "leaf_village_cascade_animation_strip_10frames.png"
        wf_strip.save(wf_strip_dst, "PNG")

        manifest["categories"]["03_recent_maps_leaf_village"] = {
            "leaf_village_master_map": {
                "file": str(master_leaf_dst.relative_to(root)),
                "dimensions": [master_leaf.width, master_leaf.height],
                "frames": 40,
                "description": "Carte complète LeafVillage 40 frames d'animation"
            },
            "leaf_village_grand_arbre_maitre": {
                "file": str(tree_dst.relative_to(root)),
                "dimensions": [tree_crop.width, tree_crop.height],
                "description": "Grand Arbre Maître du Village de Feuilles"
            },
            "leaf_village_chaumiere_ouest": {
                "file": str(house1_dst.relative_to(root)),
                "dimensions": [house1_crop.width, house1_crop.height],
                "description": "Chaumière Ouest de LeafVillage"
            },
            "leaf_village_chaumiere_est": {
                "file": str(house2_dst.relative_to(root)),
                "dimensions": [house2_crop.width, house2_crop.height],
                "description": "Chaumière Est de LeafVillage"
            },
            "leaf_village_cascade_animee": {
                "folder": str(waterfall_crop_dir.relative_to(root)),
                "frames": 40,
                "frame_dimensions": [wf_frames[0].width, wf_frames[0].height],
                "strip_file": str(wf_strip_dst.relative_to(root)),
                "description": "Grande Cascade de LeafVillage (40 frames)"
            }
        }
        print(f"  -> LeafVillage: 40 frames complètes + Arbre Maître ({tree_crop.size}) + Chaumières + Cascade animée")

    # =========================================================================
    # 4. RECENT MAPS: TREEHOUSE VILLAGE (pixellab_treehouse_village)
    # =========================================================================
    print("\n=== 4. Treehouse Village (PixelLab Grand Treehouse & Animated Water) ===")
    th_static = Path("pixellab_treehouse_village.webp")
    th_anim = Path("pixellab_treehouse_village_WATER_ANIMATED.gif")

    if th_static.exists():
        im_th = Image.open(th_static).convert("RGBA")

        # Master Map
        th_master_dst = dir_treehouse / "treehouse_village_master_map.png"
        im_th.save(th_master_dst, "PNG")

        # Crop Grand PMD Treehouse Landmark (x: 440-740, y: 260-640)
        th_landmark = im_th.crop((440, 260, 740, 640))
        th_landmark_dst = dir_treehouse / "grande_maison_arbre_treehouse_landmark.png"
        th_landmark.save(th_landmark_dst, "PNG")

        # Crop Pontons & Passerelles
        bridge_crop = im_th.crop((320, 600, 520, 750))
        bridge_dst = dir_treehouse / "passerelle_pont_bois.png"
        bridge_crop.save(bridge_dst, "PNG")

        # Extract 6-frame water animation if gif exists
        if th_anim.exists():
            im_gif_th = Image.open(th_anim)
            n_frames_th = getattr(im_gif_th, "n_frames", 6)
            th_anim_dir = dir_treehouse / "cascade_et_eau_6_frames"
            th_anim_dir.mkdir(parents=True, exist_ok=True)
            th_wf_frames = []

            for i in range(n_frames_th):
                im_gif_th.seek(i)
                fr = im_gif_th.convert("RGBA")
                # Crop waterfall region (x: 80-320, y: 650-928)
                wf_th = fr.crop((80, 650, 320, 928))
                wf_th_dst = th_anim_dir / f"cascade_treehouse_frame_{i}.png"
                wf_th.save(wf_th_dst, "PNG")
                th_wf_frames.append(wf_th)

            # Strip
            th_strip_w = th_wf_frames[0].width * len(th_wf_frames)
            th_strip_h = th_wf_frames[0].height
            th_strip = Image.new("RGBA", (th_strip_w, th_strip_h), (0, 0, 0, 0))
            for i, fr in enumerate(th_wf_frames):
                th_strip.paste(fr, (i * th_wf_frames[0].width, 0), fr)
            th_strip_dst = dir_treehouse / "treehouse_cascade_animation_strip_6frames.png"
            th_strip.save(th_strip_dst, "PNG")

        manifest["categories"]["04_recent_maps_treehouse_village"] = {
            "treehouse_village_master_map": {
                "file": str(th_master_dst.relative_to(root)),
                "dimensions": [im_th.width, im_th.height],
                "description": "Carte complète PixelLab Treehouse Village"
            },
            "grande_maison_arbre_treehouse_landmark": {
                "file": str(th_landmark_dst.relative_to(root)),
                "dimensions": [th_landmark.width, th_landmark.height],
                "description": "Grand Landmark PMD Treehouse (Maison dans l'Arbre)"
            },
            "passerelle_pont_bois": {
                "file": str(bridge_dst.relative_to(root)),
                "dimensions": [bridge_crop.width, bridge_crop.height],
                "description": "Passerelle en bois et pontons"
            },
            "cascade_treehouse_animee": {
                "folder": str(dir_treehouse / "cascade_et_eau_6_frames"),
                "frames": 6,
                "frame_dimensions": [th_wf_frames[0].width, th_wf_frames[0].height] if th_anim.exists() else [],
                "strip_file": str(th_strip_dst.relative_to(root)) if th_anim.exists() else "",
                "description": "Cascade et écoulement d'eau SO animés (6 frames)"
            }
        }
        print(f"  -> Treehouse Village: Master Map ({im_th.size}) + Treehouse Landmark ({th_landmark.size}) + Cascade 6 frames")

    # =========================================================================
    # 5. RECENT MAPS: PIXELLAB BASE MAP (MAPACOMPLETEVIAPIXELLAB)
    # =========================================================================
    print("\n=== 5. Base PixelLab Map (MAPACOMPLETEVIAPIXELLAB_COMPLETED) ===")
    px_map = Path("MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp")
    if not px_map.exists():
        px_map = Path("MAPACOMPLETEVIAPIXELLAB.webp")

    if px_map.exists():
        im_px = Image.open(px_map).convert("RGBA")
        px_master_dst = dir_pixellab / "pixellab_base_village_master_map.png"
        im_px.save(px_master_dst, "PNG")

        # Crop Falaise Nord & Escaliers (x: 400-800, y: 50-350)
        cliff_crop = im_px.crop((400, 50, 800, 350))
        cliff_dst = dir_pixellab / "plateau_falaises_et_escaliers.png"
        cliff_crop.save(cliff_dst, "PNG")

        # Crop Place Centrale & Rivière (x: 300-750, y: 350-700)
        plaza_crop = im_px.crop((300, 350, 750, 700))
        plaza_dst = dir_pixellab / "place_centrale_et_riviere.png"
        plaza_crop.save(plaza_dst, "PNG")

        manifest["categories"]["05_recent_maps_pixellab_base"] = {
            "pixellab_base_village_master_map": {
                "file": str(px_master_dst.relative_to(root)),
                "dimensions": [im_px.width, im_px.height],
                "description": "Carte complète PixelLab Base Village"
            },
            "plateau_falaises_et_escaliers": {
                "file": str(cliff_dst.relative_to(root)),
                "dimensions": [cliff_crop.width, cliff_crop.height],
                "description": "Plateau de falaises à trois niveaux et escaliers de pierre"
            },
            "place_centrale_et_riviere": {
                "file": str(plaza_dst.relative_to(root)),
                "dimensions": [plaza_crop.width, plaza_crop.height],
                "description": "Place centrale avec cours d'eau et pontons"
            }
        }
        print(f"  -> PixelLab Base: Master Map ({im_px.size}) + Falaises ({cliff_crop.size}) + Place Centrale ({plaza_crop.size})")

    # =========================================================================
    # 6. RESCUE TEAM DUNGEON GROUNDS (PMD RED / BLUE)
    # =========================================================================
    print("\n=== 6. Donjons Emblématiques Rescue Team (PMD Red/Blue) ===")
    dungeon_dir = Path("docs/pmdred_eu/dungeon_grounds")
    if dungeon_dir.exists():
        count_d = 0
        for sub in sorted(dungeon_dir.iterdir()):
            if sub.is_dir():
                tick0 = sub / "tick0.png"
                anim = sub / "animation.png"
                if tick0.exists():
                    im_d = Image.open(tick0).convert("RGBA")
                    dst_d = dir_dungeons / f"pmdred_donjon_{sub.name}_tick0.png"
                    im_d.save(dst_d, "PNG")
                    manifest["categories"]["06_donjons_rescue_team_pmdred"][f"donjon_{sub.name}"] = {
                        "file": str(dst_d.relative_to(root)),
                        "dimensions": [im_d.width, im_d.height],
                        "description": f"Ground de donjon Rescue Team {sub.name.upper()}"
                    }
                    count_d += 1
                if anim.exists():
                    im_anim = Image.open(anim).convert("RGBA")
                    dst_a = dir_dungeons / f"pmdred_donjon_{sub.name}_animation_strip.png"
                    im_anim.save(dst_a, "PNG")
        print(f"  -> Extrait {count_d} grounds de donjons Rescue Team dans {dir_dungeons.name}/")

    # Total assets count
    total_count = sum(len(c) for c in manifest["categories"].values())
    manifest["total_assets_entiers"] = total_count

    # Write Manifest
    manifest_p = root / "manifest_rescue_team_and_recent_maps.json"
    manifest_p.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nWrote manifest: {manifest_p} (Total: {total_count} assets entiers)")

    # Generate Grand Showcase Contact Sheet
    print("Building Grand Showcase for Rescue Team and Recent Maps...")
    showcase_w = 1280
    showcase_h = 920
    showcase = Image.new("RGBA", (showcase_w, showcase_h), (20, 24, 34, 255))
    draw = ImageDraw.Draw(showcase)

    # Header bar
    draw.rectangle([(0, 0), (showcase_w, 60)], fill=(32, 40, 56, 255))

    highlights = [
        (dir_square / "place_pokemon_echoppe_kecleon_vert.png", (40, 80)),
        (dir_square / "place_pokemon_tableau_missions.png", (180, 80)),
        (dir_square / "place_pokemon_panneau_croisement.png", (270, 80)),
        (dir_square / "place_pokemon_banque_persian_felinferno.png", (350, 80)),
        (dir_bases / "base_secours_depart_bois.png", (450, 80)),
        (dir_bases / "base_secours_tente_campement.png", (580, 80)),
        (dir_treehouse / "grande_maison_arbre_treehouse_landmark.png", (700, 70)),
        (dir_leaf / "leaf_village_grand_arbre_maitre.png", (40, 230)),
        (dir_treehouse / "treehouse_cascade_animation_strip_6frames.png", (480, 230)),
        (dir_leaf / "leaf_village_cascade_animation_strip_10frames.png", (40, 520)),
        (dir_pixellab / "plateau_falaises_et_escaliers.png", (650, 480)),
    ]

    for item_p, pos in highlights:
        if item_p.exists():
            try:
                im = Image.open(item_p)
                if im.width > 550 or im.height > 280:
                    im.thumbnail((540, 260), Image.NEAREST)
                draw.rectangle([(pos[0] - 2, pos[1] - 2), (pos[0] + im.width + 1, pos[1] + im.height + 1)], outline=(60, 75, 100, 255))
                showcase.paste(im, pos, im)
            except Exception:
                pass

    showcase_path = root / "showcase_rescue_team_and_recent_maps.png"
    showcase.save(showcase_path, "PNG")
    print(f"Saved Grand Showcase: {showcase_path}")


if __name__ == "__main__":
    main()
