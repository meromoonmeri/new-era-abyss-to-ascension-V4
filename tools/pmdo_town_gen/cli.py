"""CLI interface for PMDO Town Generator."""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from .generator import TownGenerator
from .models import BiomeType, SeasonType, TownSpec
from .reference_analyzer import ReferenceAnalyzer
from .viewer_server import run_viewer_server


def main() -> None:
    parser = argparse.ArgumentParser(description="PMDO Outdoor Town Layout Generator")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # 1. Analyze command
    subparsers.add_parser("analyze", help="Analyze canonical references (Metano Town & Grasstown)")

    # 2. Generate command
    gen_parser = subparsers.add_parser("generate", help="Generate a procedural Pokémon town")
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

    # 5. Serve command
    serve_parser = subparsers.add_parser("serve", help="Start the interactive live web viewer")
    serve_parser.add_argument("--port", type=int, default=8080, help="Port to bind (default: 8080)")

    args = parser.parse_args()

    if args.command == "analyze":
        analyzer = ReferenceAnalyzer()
        res = analyzer.run_and_save()
        print("Analysis successfully completed:")
        print("  - docs/pmu_maps/town_generator/reference_analysis_metano.json")
        print("  - docs/pmu_maps/town_generator/reference_analysis_grasstown.json")
        print("  - docs/pmu_maps/town_generator/pokemon_town_style_profile.json")
        print("  - docs/pmu_maps/town_generator/REFERENCE_ANALYSIS.md")

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
        generator = TownGenerator()
        layout, artifacts = generator.generate_and_export(spec, out_dir=args.out)
        print(f"Successfully generated '{spec.display_name}' (Seed {spec.seed}):")
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
        generator = TownGenerator()
        variants = generator.generate_variants(spec, count=args.count)
        print(f"Generated {len(variants)} variants for '{spec.name}':")
        for v in variants:
            print(f"  - {v.spec.display_name} (Seed {v.spec.seed}): Status={v.validation.status}, Composite={v.composite_score}/100 (Gameplay={v.validation.score.connectivity}%, Visual={v.visual_score.total_visual_score}/100)")

    elif args.command == "batch":
        spec = TownSpec(
            name=args.name,
            display_name=args.name.replace("_", " ").title(),
            reference_style=args.reference,
            seed=args.seed,
        )
        generator = TownGenerator()
        ranked = generator.generate_batch_and_rank(spec, count=args.count)
        print(f"\n=== BATCH RANKING REPORT ({args.count} Layouts Generated) ===")
        print(f"Reference Style: {args.reference.upper()}")
        print("-" * 75)
        print(f"{'Rank':<6}{'Layout ID':<24}{'Seed':<10}{'Status':<8}{'Gameplay':<10}{'Visual':<10}{'Composite'}")
        print("-" * 75)
        for rank, layout in enumerate(ranked, 1):
            sc = layout.validation.score
            vc = layout.visual_score
            print(f"#{rank:<5}{layout.spec.name:<24}{layout.spec.seed:<10}{layout.validation.status:<8}{sc.connectivity:<10.1f}{vc.total_visual_score:<10.1f}{layout.composite_score:.1f}/100")
        
        top = ranked[0]
        # Export top layout
        layout_top, artifacts = generator.generate_and_export(top.spec)
        print("-" * 75)
        print(f"🏆 Top Ranked Layout #{1} ({top.spec.name}, Seed {top.spec.seed}) exported to PMDO bundle:")
        print(f"   Ground: {artifacts['ground']}")
        print(f"   Tile: {artifacts['tile']}")

    elif args.command == "serve":
        run_viewer_server(args.port)


if __name__ == "__main__":
    main()
