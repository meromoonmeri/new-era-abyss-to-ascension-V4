<<<<<<< HEAD
"""CLI interface for PMDO Town Generator with PixelLab integration."""
=======
"""CLI interface for PMDO Town Generator (SkyTemple & PixelLab Powered)."""
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
from __future__ import annotations

import argparse
import json
from pathlib import Path

from .generator import TownGenerator
from .hybrid_town_synthesizer import HybridTownSynthesizer
from .models import BiomeType, SeasonType, TownSpec
from .pixellab_client import DEFAULT_PIXELLAB_TOKEN, PixelLabClient
from .reference_analyzer import ReferenceAnalyzer
<<<<<<< HEAD
=======
from .skytemple_engine import SkyTempleMapEngine
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
from .viewer_server import run_viewer_server


def main() -> None:
<<<<<<< HEAD
    parser = argparse.ArgumentParser(description="PMDO Outdoor Town Layout Generator (PixelLab Powered)")
=======
    parser = argparse.ArgumentParser(description="PMDO Outdoor Town Layout Generator (SkyTemple Powered)")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    parser.add_argument(
        "--pixellab-token",
        default=DEFAULT_PIXELLAB_TOKEN,
        help="PixelLab API Bearer token",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # 1. Analyze command
    subparsers.add_parser("analyze", help="Analyze canonical references (Metano Town & Grasstown)")

    # 1.1 Recreate Metano Canonical command
    subparsers.add_parser("metano-exact", help="Recreate high-fidelity Metano Town using exact canonical colorimetry & layout")

    # 1.2 Novel Hybrid Town Synthesis
<<<<<<< HEAD
    syn_parser = subparsers.add_parser("synthesize-novel", help="Generate a novel PMDO town combining canonical assets & PixelLab procedural elements")
=======
    syn_parser = subparsers.add_parser("synthesize-novel", help="Generate a novel PMDO town combining canonical assets & procedural elements")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    syn_parser.add_argument("--name", default="metano_waterfall_haven", help="Town ID")
    syn_parser.add_argument("--display-name", default="Metano Waterfall Haven", help="Town title")
    syn_parser.add_argument("--seed", type=int, default=20260830, help="Random seed")

<<<<<<< HEAD
    # 2. Generate command
    gen_parser = subparsers.add_parser("generate", help="Generate a procedural Pokémon town with PixelLab")
=======
    # 1.3 SkyTemple Map Engine Command
    st_parser = subparsers.add_parser("skytemple-build", help="Build a new PMD map using SkyTemple rules & PMDO native pipeline")
    st_parser.add_argument("--name", default="skytemple_metano_outskirts", help="Map ID")
    st_parser.add_argument("--display-name", default="Metano Outskirts (Clairière de Metano)", help="Map title")
    st_parser.add_argument("--seed", type=int, default=20260830, help="Random seed")

    # 2. Generate command
    gen_parser = subparsers.add_parser("generate", help="Generate a procedural Pokémon town")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    gen_parser.add_argument("--name", default="starter_village", help="Town internal ID")
    gen_parser.add_argument("--display-name", default="Starter Village", help="User-facing town title")
    gen_parser.add_argument("--biome", default="grassland", choices=[b.value for b in BiomeType], help="Primary biome")
    gen_parser.add_argument("--season", default="spring", choices=[s.value for s in SeasonType], help="Season")
    gen_parser.add_argument("--seed", type=int, default=184729, help="Random seed")
    gen_parser.add_argument("--width", type=int, default=64, help="Width in tiles")
    gen_parser.add_argument("--height", type=int, default=48, help="Height in tiles")
    gen_parser.add_argument("--levels", type=int, default=2, help="Elevation levels (1, 2, or 3)")
    gen_parser.add_argument("--reference", choices=["metano", "grasstown", "novel"], help="Reference style to adopt")
    gen_parser.add_argument("--river", action="store_true", help="Include river")
    gen_parser.add_argument("--river-side", default="east", choices=["east", "west"], help="River position")
    gen_parser.add_argument("--out", type=Path, help="Custom output directory")

    # 3. Variants command
    var_parser = subparsers.add_parser("variants", help="Generate multiple distinct variants of a town intent")
    var_parser.add_argument("--name", default="starter_village", help="Town base ID")
    var_parser.add_argument("--reference", choices=["metano", "grasstown", "novel"], help="Reference style to adopt")
    var_parser.add_argument("--count", type=int, default=5, help="Number of variants to generate")
    var_parser.add_argument("--seed", type=int, default=184729, help="Base seed")

    # 4. Batch ranking command
    batch_parser = subparsers.add_parser("batch", help="Generate N seeds, evaluate visual & gameplay scores, and rank layouts")
    batch_parser.add_argument("--name", default="batch_town", help="Base name")
    batch_parser.add_argument("--reference", default="metano", choices=["metano", "grasstown", "novel"], help="Reference style")
    batch_parser.add_argument("--count", type=int, default=20, help="Number of layouts to evaluate (e.g. 20, 50, 100)")
    batch_parser.add_argument("--seed", type=int, default=100000, help="Starting base seed")

    # 5. PixelLab Sync command
    subparsers.add_parser("pixellab-sync", help="Precompute and synchronize core PixelLab Wang tilesets and building stamps")

    # 6. PixelLab Tileset command
    ts_parser = subparsers.add_parser("pixellab-tileset", help="Generate a Wang tileset via PixelLab")
<<<<<<< HEAD
    ts_parser.add_argument("--lower", required=True, help="Lower terrain description (e.g. 'water', 'grass')")
    ts_parser.add_argument("--upper", required=True, help="Upper terrain description (e.g. 'grass', 'dirt path')")
=======
    ts_parser.add_argument("--lower", required=True, help="Lower terrain description")
    ts_parser.add_argument("--upper", required=True, help="Upper terrain description")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    ts_parser.add_argument("--tile-size", type=int, default=24, help="Tile size in pixels (16, 24, 32)")

    # 7. PixelLab Building command
    b_parser = subparsers.add_parser("pixellab-building", help="Generate a building sprite via PixelLab")
    b_parser.add_argument("--prompt", required=True, help="Text description of the building")
<<<<<<< HEAD
    b_parser.add_argument("--category", default="shop", help="Building category (e.g. shop, cafe, house)")
=======
    b_parser.add_argument("--category", default="shop", help="Building category")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    b_parser.add_argument("--width", type=int, default=96, help="Width in pixels")
    b_parser.add_argument("--height", type=int, default=96, help="Height in pixels")

    # 8. Serve command
    serve_parser = subparsers.add_parser("serve", help="Start the interactive live web viewer")
    serve_parser.add_argument("--port", type=int, default=8080, help="Port to bind (default: 8080)")

    args = parser.parse_args()

    pixellab_client = PixelLabClient(api_token=args.pixellab_token)

    if args.command == "analyze":
        analyzer = ReferenceAnalyzer()
        res = analyzer.run_and_save()
        print("Analysis successfully completed:")
        print("  - docs/pmu_maps/town_generator/reference_analysis_metano.json")
        print("  - docs/pmu_maps/town_generator/reference_analysis_grasstown.json")
        print("  - docs/pmu_maps/town_generator/pokemon_town_style_profile.json")
        print("  - docs/pmu_maps/town_generator/REFERENCE_ANALYSIS.md")

    elif args.command == "metano-exact":
        from .metano_recreator import MetanoRecreator
        rec = MetanoRecreator(pixellab_client=pixellab_client)
        layout, artifacts = rec.execute_and_export()
<<<<<<< HEAD
        print("Metano Town High-Fidelity Canonical Recreation Complete (PixelLab Integrated):")
=======
        print("Metano Town High-Fidelity Canonical Recreation Complete:")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        print(f"  - Validation Status: {layout.validation.status}")
        print(f"  - Connectivity: {layout.validation.score.connectivity}% (100% reachability)")
        print(f"  - Visual Score: {layout.visual_score.total_visual_score}/100")
        print(f"  - Composite Score: {layout.composite_score}/100")
        print(f"  - PMDO Ground: {artifacts['ground']}")
        print(f"  - PMDO Tile: {artifacts['tile']}")
        print(f"  - Render: docs/pmu_maps/renders/metano_town_recreated/final.png")

<<<<<<< HEAD
=======
    elif args.command == "skytemple-build":
        st_engine = SkyTempleMapEngine()
        layout, report, artifacts = st_engine.build_new_era_map(
            map_id=args.name,
            display_name=args.display_name,
            seed=args.seed,
        )
        print(report.format_report())
        print(f"Artifacts exported to:")
        print(f"  - Ground: {artifacts['ground']}")
        print(f"  - Tile:   {artifacts['tile']}")
        print(f"  - Script: {artifacts['script']}")
        print(f"  - Render: docs/pmu_maps/renders/{args.name}/final.png")

>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
    elif args.command == "synthesize-novel":
        synth = HybridTownSynthesizer(pixellab_client=pixellab_client)
        layout, artifacts = synth.synthesize_waterfall_haven(
            name=args.name,
            display_name=args.display_name,
            seed=args.seed,
        )
        print(f"Novel Hybrid Town Synthesis Complete ('{args.display_name}'):")
<<<<<<< HEAD
        print(f"  - Composition: Canonical Terrain + PixelLab River & 4-Frame Waterfall (.dir)")
=======
        print(f"  - Composition: Canonical Terrain + River & 4-Frame Waterfall (.dir)")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        print(f"  - Validation Status: {layout.validation.status}")
        print(f"  - Connectivity: {layout.validation.score.connectivity}% (100% reachability)")
        print(f"  - Visual Score: {layout.visual_score.total_visual_score}/100")
        print(f"  - Composite Score: {layout.composite_score}/100")
        print(f"  - PMDO Ground: {artifacts['ground']}")
        print(f"  - PMDO Tile: {artifacts['tile']}")
        print(f"  - Render: docs/pmu_maps/renders/{args.name}/final.png")

    elif args.command == "generate":
        spec = TownSpec(
            name=args.name,
            display_name=args.display_name,
            biome=BiomeType(args.biome),
            season=SeasonType(args.season),
            seed=args.seed,
            width=args.width,
            height=args.height,
            elevation_levels=args.levels,
            reference_style=args.reference,
            has_river=args.river or (args.reference == "metano"),
            river_side=args.river_side,
        )
        generator = TownGenerator(pixellab_client=pixellab_client)
        layout, artifacts = generator.generate_and_export(spec, out_dir=args.out)
<<<<<<< HEAD
        print(f"Successfully generated '{spec.display_name}' (Seed {spec.seed}) via PixelLab Engine:")
=======
        print(f"Successfully generated '{spec.display_name}' (Seed {spec.seed}):")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        print(f"  - Validation Status: {layout.validation.status}")
        print(f"  - Gameplay Score: {layout.validation.score.connectivity}% (100% reachability)")
        print(f"  - Visual Quality Score: {layout.visual_score.total_visual_score}/100")
        print(f"  - Composite Score: {layout.composite_score}/100")
        print(f"  - Structures placed: {len(layout.buildings)}")
        print(f"  - PMDO Ground: {artifacts['ground']}")
        print(f"  - PMDO Tile: {artifacts['tile']}")
        print(f"  - PMDO Script: {artifacts['script']}")

    elif args.command == "variants":
        spec = TownSpec(
            name=args.name,
            display_name=args.name.replace("_", " ").title(),
            reference_style=args.reference,
            seed=args.seed,
        )
        generator = TownGenerator(pixellab_client=pixellab_client)
        variants = generator.generate_variants(spec, count=args.count)
<<<<<<< HEAD
        print(f"Generated {len(variants)} variants for '{spec.name}' with PixelLab:")
=======
        print(f"Generated {len(variants)} variants for '{spec.name}':")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        for v in variants:
            print(f"  - {v.spec.display_name} (Seed {v.spec.seed}): Status={v.validation.status}, Composite={v.composite_score}/100 (Gameplay={v.validation.score.connectivity}%, Visual={v.visual_score.total_visual_score}/100)")

    elif args.command == "batch":
        spec = TownSpec(
            name=args.name,
            display_name=args.name.replace("_", " ").title(),
            reference_style=args.reference,
            seed=args.seed,
        )
        generator = TownGenerator(pixellab_client=pixellab_client)
        ranked = generator.generate_batch_and_rank(spec, count=args.count)
<<<<<<< HEAD
        print(f"\n=== BATCH RANKING REPORT ({args.count} Layouts Generated via PixelLab) ===")
=======
        print(f"\n=== BATCH RANKING REPORT ({args.count} Layouts Generated) ===")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
        print(f"Reference Style: {args.reference.upper()}")
        print("-" * 75)
        print(f"{'Rank':<6}{'Layout ID':<24}{'Seed':<10}{'Status':<8}{'Gameplay':<10}{'Visual':<10}{'Composite'}")
        print("-" * 75)
        for rank, layout in enumerate(ranked, 1):
            sc = layout.validation.score
            vc = layout.visual_score
            print(f"#{rank:<5}{layout.spec.name:<24}{layout.spec.seed:<10}{layout.validation.status:<8}{sc.connectivity:<10.1f}{vc.total_visual_score:<10.1f}{layout.composite_score:.1f}/100")
        
        top = ranked[0]
        layout_top, artifacts = generator.generate_and_export(top.spec)
        print("-" * 75)
        print(f"🏆 Top Ranked Layout #{1} ({top.spec.name}, Seed {top.spec.seed}) exported to PMDO bundle:")
        print(f"   Ground: {artifacts['ground']}")
        print(f"   Tile: {artifacts['tile']}")

    elif args.command == "pixellab-sync":
        from .pixellab_structure_engine import PixelLabStructureEngine
        from .pixellab_tileset_engine import PixelLabTilesetEngine

        print("Synchronizing PixelLab Core Assets...")
        ts_engine = PixelLabTilesetEngine(client=pixellab_client)
        ts1 = ts_engine.get_or_create_tileset("water", "grass")
        ts2 = ts_engine.get_or_create_tileset("dirt", "grass")
        ts3 = ts_engine.get_or_create_tileset("cliff", "grass")
        print(f"  ✓ Tileset Water<->Grass: {ts1.tileset_id} (SHA256: {ts1.sha256[:12]}...)")
        print(f"  ✓ Tileset Dirt<->Grass: {ts2.tileset_id} (SHA256: {ts2.sha256[:12]}...)")
        print(f"  ✓ Tileset Cliff<->Grass: {ts3.tileset_id} (SHA256: {ts3.sha256[:12]}...)")

        struct_engine = PixelLabStructureEngine(client=pixellab_client)
        for pid, p in struct_engine.prefabs.items():
            print(f"  ✓ Building '{p.id}': {p.width}x{p.height} tiles, Role: {p.role}")
        print("PixelLab synchronization complete. Manifest updated at data/pixellab_cache/manifest.json.")

    elif args.command == "pixellab-tileset":
        from .pixellab_tileset_engine import PixelLabTilesetEngine
        ts_engine = PixelLabTilesetEngine(client=pixellab_client, tile_size=args.tile_size)
        ts = ts_engine.get_or_create_tileset(args.lower, args.upper)
        print(f"PixelLab Wang Tileset Generated:")
        print(f"  - Tileset ID: {ts.tileset_id}")
        print(f"  - Lower: {ts.lower_terrain}")
        print(f"  - Upper: {ts.upper_terrain}")
        print(f"  - Atlas File: {ts.image_path}")
        print(f"  - SHA256: {ts.sha256}")

    elif args.command == "pixellab-building":
        from .pixellab_structure_engine import PixelLabStructureEngine
        struct_engine = PixelLabStructureEngine(client=pixellab_client)
        asset = pixellab_client.create_structure_stamp(
            description=args.prompt,
            category=args.category,
            width=args.width,
            height=args.height,
            no_background=True,
        )
        print(f"PixelLab Building Stamp Generated:")
        print(f"  - Asset ID: {asset.asset_id}")
        print(f"  - Image Path: {asset.image_path}")
        print(f"  - SHA256: {asset.sha256}")
        print(f"  - Source: {asset.source}")

    elif args.command == "serve":
        run_viewer_server(args.port)


if __name__ == "__main__":
    main()
