#!/usr/bin/env python3
"""
Assemble and export ALL entire, unbroken, alpha-isolated PMDO/PMU/EoS assets.
NO tile decomposing/slicing: every asset is kept as a complete whole sprite with transparent alpha.
"""

from __future__ import annotations

import io
import json
import math
import re
import shutil
import struct
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw


def extract_whole_dir_frames(p: Path) -> List[Image.Image]:
    """Extract individual whole frame images from PMDO .dir binary."""
    data = p.read_bytes()
    png_magic = b"\x89PNG\r\n\x1a\n"
    if png_magic not in data:
        return []
    idx = data.find(png_magic)
    iend = data.find(b"IEND\xaeB`\x82", idx)
    if iend == -1:
        return []
    png_bytes = data[idx:iend+8]
    trailing = data[iend+8:]
    im = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
    tw, th = im.size
    fw, fh = tw, th
    if len(trailing) >= 8:
        w_val, h_val = struct.unpack("<ii", trailing[:8])
        if w_val > 0 and h_val > 0 and w_val <= tw and h_val <= th:
            fw, fh = w_val, h_val
    cols = tw // fw
    rows = th // fh
    frames = []
    for r in range(rows):
        for c in range(cols):
            x = c * fw
            y = r * fh
            frame = im.crop((x, y, x + fw, y + fh))
            frames.append(frame)
    return frames


def main() -> None:
    root = Path("data/pmdo_assets_alpha_entiers")
    root.mkdir(parents=True, exist_ok=True)

    # Subdirectories
    dir_signs = root / "01_panneaux_et_missions"
    dir_shops = root / "02_boutiques_et_marche"
    dir_buildings = root / "03_batiments_et_tentes"
    dir_veg = root / "04_vegetation_et_nature"
    dir_anim = root / "05_objets_animes_frames_completes"
    dir_interior = root / "06_accessoires_et_decor_interieur"
    dir_pmu_buildings = dir_buildings / "pmuniverse_143_batiments"

    for d in [dir_signs, dir_shops, dir_buildings, dir_veg, dir_anim, dir_interior, dir_pmu_buildings]:
        d.mkdir(parents=True, exist_ok=True)

    manifest = {
        "version": "1.0.0",
        "description": "Collection complète des assets PMDO / PMU / EoS entiers en Alpha Isolate (zéro découpage en tuiles)",
        "categories": {
            "01_panneaux_et_missions": {},
            "02_boutiques_et_marche": {},
            "03_batiments_et_tentes": {},
            "04_vegetation_et_nature": {},
            "05_objets_animes_frames_completes": {},
            "06_accessoires_et_decor_interieur": {}
        },
        "total_assets_entiers": 0
    }

    # 1. PANNEAUX & TABLEAUX DE MISSIONS ENTIERS
    print("=== 1. Panneaux et Tableaux de Missions Entiers ===")
    signs_map = {
        "grand_panneau_carrefour_4_directions": "docs/pmdo_isolated_structures/market_components/Sign_Crossroads.png",
        "tableau_affichage_missions_guilde": "docs/pmdo_isolated_structures/market_components/Mission_Board.png",
        "panneau_bois_simple": "docs/pmdo_isolated_structures/market_components/Sign.png",
    }
    for key, src in signs_map.items():
        sp = Path(src)
        if sp.exists():
            im = Image.open(sp).convert("RGBA")
            dst = dir_signs / f"{key}.png"
            im.save(dst, "PNG")
            manifest["categories"]["01_panneaux_et_missions"][key] = {
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Asset entier {key.replace('_', ' ').title()}"
            }
            print(f"  -> {dst.name} ({im.size})")

    # 2. BOUTIQUES & ÉLÉMENTS DE MARCHÉ ENTIERS
    print("\n=== 2. Boutiques et Marché Entiers ===")
    shops_map = {
        "boutique_kecleon_vert_jour": "docs/metano_origins_structure_library/buildings/metano_kecleon_shop_day.png",
        "boutique_kecleon_violet_nuit": "docs/metano_origins_structure_library/buildings/metano_kecleon_shop_night.png",
        "grand_cafe_spinda_terrasse_jour": "docs/metano_origins_structure_library/buildings/metano_cafe_day.png",
        "grand_cafe_spinda_terrasse_nuit": "docs/metano_origins_structure_library/buildings/metano_cafe_night.png",
        "eventaire_marche_bois": "docs/pmd_structure_library/buildings/merchant_stand_01.png",
        "comptoir_marchand_bas": "docs/pmd_structure_library/buildings/merchant_counter_01.png",
        "reserve_coffre_kangourex": "docs/pmdo_isolated_structures/market_components/Storage.png",
        "panier_baies_rouges": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Red.png",
        "panier_baies_bleues": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Blue.png",
        "jarre_terre_cuite": "docs/pmdo_isolated_structures/market_components/Pot.png",
        "cloture_bois_palissade": "docs/pmdo_isolated_structures/market_components/Fence.png",
        "table_souche_bois": "docs/pmdo_isolated_structures/market_components/Stump_Table.png",
        "chaise_souche_bois": "docs/pmdo_isolated_structures/market_components/Stump_Chair.png",
    }
    for key, src in shops_map.items():
        sp = Path(src)
        if sp.exists():
            im = Image.open(sp).convert("RGBA")
            dst = dir_shops / f"{key}.png"
            im.save(dst, "PNG")
            manifest["categories"]["02_boutiques_et_marche"][key] = {
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Asset entier {key.replace('_', ' ').title()}"
            }
            print(f"  -> {dst.name} ({im.size})")

    # 3. BÂTIMENTS & TENTES ENTIÈRES
    print("\n=== 3. Bâtiments et Tentes Entières ===")
    buildings_map = {
        "tente_expedition_bleue": "docs/pmd_structure_library/buildings/tent_01.png",
        "grande_tente_campement_unie": "docs/pmd_structure_library/buildings/tent_02.png",
        "tente_plage_cotiere": "docs/waves_nostalgia_structures/overw4/beach_tent_01.png",
        "maison_standard_bourg_tresor": "docs/pmd_structure_library/buildings/house_01.png",
        "chaumiere_feuilles_foret_1": "docs/waves_nostalgia_structures/overw1/house_leaf_01.png",
        "chaumiere_feuilles_foret_2": "docs/waves_nostalgia_structures/overw1/house_leaf_02.png",
        "grand_bazar_guilde": "docs/waves_nostalgia_structures/overw1/shop_01.png",
        "maison_style_feu": "docs/metano_origins_structure_library/buildings/metano_house_fire_day.png",
        "maison_style_roche": "docs/metano_origins_structure_library/buildings/metano_house_rock_day.png",
        "maison_style_normal": "docs/metano_origins_structure_library/buildings/metano_house_normal_day.png",
    }
    for key, src in buildings_map.items():
        sp = Path(src)
        if sp.exists():
            im = Image.open(sp).convert("RGBA")
            dst = dir_buildings / f"{key}.png"
            im.save(dst, "PNG")
            manifest["categories"]["03_batiments_et_tentes"][key] = {
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Bâtiment entier {key.replace('_', ' ').title()}"
            }
            print(f"  -> {dst.name} ({im.size})")

    # PMUniverse 143 Whole Buildings
    print("\n=== PMUniverse 143 Bâtiments Entiers ===")
    pmu_bld_dir = Path("docs/pmuniverse_buildings/buildings")
    if pmu_bld_dir.exists():
        count_pmu = 0
        for bp in sorted(pmu_bld_dir.glob("*.png")):
            im = Image.open(bp).convert("RGBA")
            dst = dir_pmu_buildings / bp.name
            im.save(dst, "PNG")
            manifest["categories"]["03_batiments_et_tentes"][bp.stem] = {
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Bâtiment complet PMUniverse {bp.stem}"
            }
            count_pmu += 1
        print(f"  -> Copié {count_pmu} bâtiments entiers dans {dir_pmu_buildings.name}/")

    # 4. VÉGÉTATION & NATURE ENTIÈRE
    print("\n=== 4. Végétation et Nature Entière ===")
    veg_objects = [
        ("noigrume_geant", "Content/Object/Apricorn_Big.dir"),
        ("rocher_riviere_rond", "Content/Object/River_Stone_Round.dir"),
        ("rocher_riviere_diamant", "Content/Object/River_Stone_Diamond.dir"),
        ("stele_pierre_kangourex", "Content/Object/Kangaskhan_Rock.dir"),
        ("porte_guilde_fermee", "Content/Object/Closed_Guild_Door.dir"),
        ("couchette_paille_dortoir", "Content/Object/Hay_Bed.dir"),
        ("sac_provisions_herbe", "Content/Object/Grassy_Bag.dir"),
        ("panier_gros_vivres", "Content/Object/Food_Big.dir"),
        ("tablette_zarbi_mystere", "Content/Object/Tablette_Zarbi.dir"),
        ("fenetre_nocturne_eclairee", "Content/Object/Night_Window.dir"),
    ]
    for key, src in veg_objects:
        sp = Path(src)
        if sp.exists():
            frames = extract_whole_dir_frames(sp)
            if frames:
                dst = dir_veg / f"{key}.png"
                frames[0].save(dst, "PNG")
                manifest["categories"]["04_vegetation_et_nature"][key] = {
                    "file": str(dst.relative_to(root)),
                    "dimensions": [frames[0].width, frames[0].height],
                    "frames": 1,
                    "description": f"Élément naturel entier {key.replace('_', ' ').title()}"
                }
                print(f"  -> {dst.name} ({frames[0].size})")

    # 5. OBJETS ANIMÉS FRAMES COMPLÈTES ENTIÈRES
    print("\n=== 5. Objets Animés avec Frames Complètes Entières ===")
    anim_sources = {
        "feu_de_camp_bivouac": ("Content/Object/Campfire.dir", 4),
        "moulin_a_vent_ailes_tournantes": ([
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_0.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_1.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_2.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_3.png"
        ], 4),
        "puits_village_manivelle_et_eau": ([
            "docs/metano_origins_structure_library/buildings/origins_well_frame_0.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_1.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_2.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_3.png"
        ], 4),
        "boite_tresor_scintillante": ("Content/Object/Yellow_Box.dir", 6),
        "coeur_energie_animique": ("Content/Object/Anima_Core.dir", 36),
        "racines_telluriques_lueur": ("Content/Object/Anima_Root_Glow.dir", 16),
        "journal_bleu_ouverture": ("Content/Object/Diary_Blue_Opening.dir", 4),
        "journal_bleu_fermeture": ("Content/Object/Diary_Blue_Closing.dir", 4),
        "journal_rouge_ouverture": ("Content/Object/Diary_Red_Opening.dir", 4),
        "journal_rouge_fermeture": ("Content/Object/Diary_Red_Closing.dir", 4),
        "grande_cascade_de_lave": ("Content/Object/Spring_Cave_Pit_Big_Lava_Stream.dir", 64),
        "petite_cascade_de_lave": ("Content/Object/Spring_Cave_Pit_Small_Lava_Stream.dir", 64),
        "bassin_lave_bouillonnante": ("Content/Object/Spring_Cave_Pit_Lava_Pool_Connected.dir", 66),
    }

    # Add Content/Objects animation strips
    objects_folder = Path("Content/Objects")
    if objects_folder.exists():
        for p in sorted(objects_folder.glob("*.png")):
            m = re.search(r'\.(\d+)\.png$', p.name)
            if m:
                fc = int(m.group(1))
                if fc > 1 and fc <= 48:
                    im = Image.open(p).convert("RGBA")
                    fw = im.width // fc
                    if fw >= 8 and im.height >= 8:
                        slug = p.name.replace(".", "_").replace(" ", "_").lower()
                        # Extract frames
                        frames_list = []
                        for i in range(fc):
                            fr = im.crop((i * fw, 0, (i + 1) * fw, im.height))
                            frames_list.append(fr)
                        
                        target_sub = dir_anim / slug
                        target_sub.mkdir(parents=True, exist_ok=True)
                        for i, fr in enumerate(frames_list):
                            fr.save(target_sub / f"frame_{i}.png", "PNG")
                        strip_p = target_sub / f"{slug}_animation_strip.png"
                        im.save(strip_p, "PNG")

                        manifest["categories"]["05_objets_animes_frames_completes"][slug] = {
                            "folder": str(target_sub.relative_to(root)),
                            "frame_count": fc,
                            "frame_dimensions": [fw, im.height],
                            "strip_file": str(strip_p.relative_to(root)),
                            "frames": [f"frame_{i}.png" for i in range(fc)],
                            "description": f"Effet animé entier {slug.replace('_', ' ').title()}"
                        }

    for key, (src, exp_frames) in anim_sources.items():
        sub_dir = dir_anim / key
        sub_dir.mkdir(parents=True, exist_ok=True)
        frame_list = []

        if isinstance(src, list):
            for i, sf in enumerate(src):
                p = Path(sf)
                if p.exists():
                    im = Image.open(p).convert("RGBA")
                    dst_f = sub_dir / f"frame_{i}.png"
                    im.save(dst_f, "PNG")
                    frame_list.append(im)
        else:
            p = Path(src)
            if p.exists():
                extracted = extract_whole_dir_frames(p)
                for i, fr in enumerate(extracted):
                    dst_f = sub_dir / f"frame_{i}.png"
                    fr.save(dst_f, "PNG")
                    frame_list.append(fr)
                shutil.copy(p, sub_dir / p.name)

        if frame_list:
            w, h = frame_list[0].size
            strip = Image.new("RGBA", (w * len(frame_list), h), (0, 0, 0, 0))
            for i, fr in enumerate(frame_list):
                strip.paste(fr, (i * w, 0), fr)
            strip_path = sub_dir / f"{key}_animation_strip.png"
            strip.save(strip_path, "PNG")

            manifest["categories"]["05_objets_animes_frames_completes"][key] = {
                "folder": str(sub_dir.relative_to(root)),
                "frame_count": len(frame_list),
                "frame_dimensions": [w, h],
                "strip_file": str(strip_path.relative_to(root)),
                "frames": [f"frame_{i}.png" for i in range(len(frame_list))],
                "description": f"Objet animé entier {key.replace('_', ' ').title()}"
            }
            print(f"  -> [{key}] {len(frame_list)} frames entières ({w}x{h} px)")

    # 6. PMU QUALIFIED WHOLE INTERIOR PROPS
    print("\n=== 6. Accessoires et Décors Intérieurs Entiers PMU ===")
    pmu_inv_manifest = Path("docs/pmu_asset_inventory/manifest.json")
    if pmu_inv_manifest.exists():
        pmu_data = json.loads(pmu_inv_manifest.read_text())
        pmu_objects = pmu_data.get("objects", [])
        count_int = 0
        for obj in pmu_objects:
            png_rel = obj.get("png") or obj.get("file", "")
            src_file = Path("docs/pmu_asset_inventory") / png_rel
            if src_file.exists() and src_file.is_file():
                im = Image.open(src_file).convert("RGBA")
                label_slug = obj.get("label", f"item_{count_int}").replace(" ", "_").lower()
                dst = dir_interior / f"{label_slug}_{count_int}.png"
                im.save(dst, "PNG")
                manifest["categories"]["06_accessoires_et_decor_interieur"][f"{label_slug}_{count_int}"] = {
                    "file": str(dst.relative_to(root)),
                    "dimensions": [im.width, im.height],
                    "category": obj.get("category", "decor"),
                    "frames": 1,
                    "description": f"Objet entier {label_slug.replace('_', ' ').title()}"
                }
                count_int += 1
        print(f"  -> Copié {count_int} objets entiers dans {dir_interior.name}/")

    # Total assets count
    total_count = sum(len(c) for c in manifest["categories"].values())
    manifest["total_assets_entiers"] = total_count

    # Write Manifest
    manifest_p = root / "manifest_assets_entiers.json"
    manifest_p.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nWrote manifest: {manifest_p} (Total: {total_count} assets entiers)")

    # Generate Grand Showcase Contact Sheet
    print("Building Grand Showcase for all Whole Assets...")
    showcase_w = 1280
    showcase_h = 920
    showcase = Image.new("RGBA", (showcase_w, showcase_h), (24, 28, 38, 255))
    draw = ImageDraw.Draw(showcase)

    draw.rectangle([(0, 0), (showcase_w, 60)], fill=(36, 44, 60, 255))

    highlights = [
        (dir_signs / "grand_panneau_carrefour_4_directions.png", (40, 80)),
        (dir_signs / "tableau_affichage_missions_guilde.png", (120, 80)),
        (dir_shops / "boutique_kecleon_vert_jour.png", (220, 70)),
        (dir_shops / "reserve_coffre_kangourex.png", (360, 80)),
        (dir_buildings / "tente_expedition_bleue.png", (430, 80)),
        (dir_buildings / "maison_standard_bourg_tresor.png", (540, 80)),
        (dir_buildings / "grand_bazar_guilde.png", (680, 80)),
        (dir_shops / "grand_cafe_spinda_terrasse_jour.png", (40, 230)),
        (dir_anim / "moulin_a_vent_ailes_tournantes/moulin_a_vent_ailes_tournantes_animation_strip.png", (330, 240)),
        (dir_anim / "feu_de_camp_bivouac/feu_de_camp_bivouac_animation_strip.png", (630, 240)),
        (dir_anim / "puits_village_manivelle_et_eau/puits_village_manivelle_et_eau_animation_strip.png", (800, 240)),
        (dir_veg / "stele_pierre_kangourex.png", (110, 390)),
        (dir_veg / "porte_guilde_fermee.png", (160, 370)),
        (dir_buildings / "chaumiere_feuilles_foret_1.png", (330, 370)),
        (dir_buildings / "chaumiere_feuilles_foret_2.png", (440, 360)),
        (dir_buildings / "tente_plage_cotiere.png", (550, 370)),
    ]

    for item_p, pos in highlights:
        if item_p.exists():
            try:
                im = Image.open(item_p)
                draw.rectangle([(pos[0] - 2, pos[1] - 2), (pos[0] + im.width + 1, pos[1] + im.height + 1)], outline=(60, 72, 95, 255))
                showcase.paste(im, pos, im)
            except Exception:
                pass

    showcase_path = root / "showcase_assets_entiers.png"
    showcase.save(showcase_path, "PNG")
    print(f"Saved Grand Showcase: {showcase_path}")


if __name__ == "__main__":
    main()
