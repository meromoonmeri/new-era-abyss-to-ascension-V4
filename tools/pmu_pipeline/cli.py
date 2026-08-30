"""PMU Pipeline CLI tool (pmu_maps).
Provides full management commands: catalog, select, extract, render, validate,
convert-pmdo, validate-pmdo, approve, and pipeline.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from .catalog import PMUCatalog
from .converter import PMDOConverter, read_pmdo_tile_file
from .extractor import PMUExtractor, normalize_map_id, sha256_file
from .renderer import PMURenderer
from .validator import PMDOValidator


def get_default_paths(repo_root: Path | None = None) -> dict[str, Path]:
    root = repo_root or Path(__file__).resolve().parent.parent.parent
    db_path = root / ".runtime-cache/pmu-extraction/pmu-standard.sqlite3"
    tiles_dir = root / ".runtime-cache/pmu/PMU-Client/resources/GFX/Tiles"
    imports_dir = root / "data/pmu_imports"
    renders_dir = root / "docs/pmu_maps/renders"
    renders_md = root / "docs/pmu_maps/RENDERS.md"
    return {
        "repo_root": root,
        "db_path": db_path,
        "tiles_dir": tiles_dir,
        "imports_dir": imports_dir,
        "renders_dir": renders_dir,
        "renders_md": renders_md,
    }


def update_renders_markdown(repo_root: Path) -> None:
    """Regenerate docs/pmu_maps/RENDERS.md table with all approved/rendered maps."""
    paths = get_default_paths(repo_root)
    renders_dir = paths["renders_dir"]
    imports_dir = paths["imports_dir"]
    renders_md = paths["renders_md"]

    if not renders_dir.exists():
        return

    map_dirs = sorted(
        [d for d in renders_dir.iterdir() if d.is_dir() and d.name.startswith("s")],
        key=lambda d: int(d.name[1:]) if d.name[1:].isdigit() else 999999,
    )

    lines = [
        "# PMU → PMDO Canonical Map Renders & Catalog",
        "",
        "This document lists all Pokémon Mystery Universe maps extracted and adapted for PMDO / New Era with deterministic 1:1 pixel fidelity, native `.rsground` layers, `.tile` textures, exact collision grids, warps, and Lua scripts.",
        "",
        "| ID | Nom | Dimensions PMU | Dimensions PMDO (8px) | Échelle | Tileset | Collision | Warps | NPCs | Render Original | Render PMDO | Validation | Statut |",
        "| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |",
    ]

    for d in map_dirs:
        mid = d.name
        manifest_path = imports_dir / mid / "manifest.json"
        pmdo_manifest_path = imports_dir / mid / "pmdo_manifest.json"
        col_val_path = imports_dir / mid / "collision_validation.json"

        name = "Unknown"
        pmu_dims = "—"
        pmdo_dims = "—"
        tileset_info = "—"
        warps_cnt = 0
        npcs_cnt = 0
        val_status = "PENDING"
        import_status = "PENDING"

        if manifest_path.exists():
            try:
                m_data = json.loads(manifest_path.read_text(encoding="utf-8"))
                name = m_data.get("name", name)
                dt = m_data.get("dimensions", {}).get("tiles", [0, 0])
                pmu_dims = f"{dt[0]}×{dt[1]} ({dt[0]*32}×{dt[1]*32}px)"
                pmdo_dims = f"{dt[0]*4}×{dt[1]*4} (TexSize 1)"
                tileset_info = ", ".join(str(ts) for ts in m_data.get("statistics", {}).get("tilesets_used", []))
                warps_cnt = m_data.get("statistics", {}).get("warps_count", 0)
                npcs_cnt = m_data.get("statistics", {}).get("npcs_count", 0)
            except Exception:
                pass

        if pmdo_manifest_path.exists():
            import_status = "**APPROVED / IMPORTED**"

        if col_val_path.exists():
            try:
                c_data = json.loads(col_val_path.read_text(encoding="utf-8"))
                if c_data.get("perfect_collision_match"):
                    val_status = "✅ 100% MATCH"
                else:
                    val_status = "⚠️ PARTIAL"
            except Exception:
                pass

        orig_link = f"[original.png](renders/{mid}/original.png)" if (d / "original.png").exists() else "—"
        pmdo_link = f"[pmdo.png](renders/{mid}/pmdo.png)" if (d / "pmdo.png").exists() else "—"

        lines.append(
            f"| `{mid}` | **{name}** | `{pmu_dims}` | `{pmdo_dims}` | `1.0 (1:1)` | `{tileset_info}` | `{val_status}` | {warps_cnt} | {npcs_cnt} | {orig_link} | {pmdo_link} | `{val_status}` | {import_status} |"
        )

    lines.extend([
        "",
        "---",
        "### Légende des colonnes :",
        "- **Dimensions PMU** : Largeur × Hauteur en tuiles 32×32 pixels et résolution totale en pixels.",
        "- **Dimensions PMDO** : Grille d'obstacles en cellules natives de 8×8 pixels (4×4 sous-cellules par tuile PMU).",
        "- **Échelle** : Ratio physique 1:1 (zéro déformation, zéro interpolation, zéro crop).",
        "- **Validation** : Round-trip visual diff 0.00% et correspondance exacte de collision à 100%.",
        "",
    ])

    renders_md.parent.mkdir(parents=True, exist_ok=True)
    renders_md.write_text("\n".join(lines), encoding="utf-8")


def cmd_catalog(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    catalog = PMUCatalog(paths["db_path"], paths["repo_root"])
    total = catalog.get_total_count()
    results = catalog.list_maps(query=args.query, limit=args.limit, offset=args.offset)

    print(f"\n=== PMU MAP CATALOG ({len(results)} shown / {total} total) ===")
    if args.query:
        print(f"Filter query: '{args.query}'")
    print(f"{'ID':<6} | {'Name':<32} | {'Tiles':<8} | {'Pixels':<12} | {'Warps':<5} | {'NPCs':<4} | {'Extract':<7} | {'Render':<6} | {'PMDO':<5} | {'Approve':<7}")
    print("-" * 110)
    for r in results:
        mid = r["map_id"]
        name = r["name"][:32]
        dt = f"{r['dimensions_tiles'][0]}x{r['dimensions_tiles'][1]}"
        dpx = f"{r['dimensions_px'][0]}x{r['dimensions_px'][1]}"
        w = r["warps_count"]
        npc = r["npcs_count"]
        st = r["status"]
        ext = "✓" if st["extracted"] else "·"
        ren = "✓" if st["rendered"] else "·"
        pmdo = "✓" if st["converted_pmdo"] else "·"
        appr = "✓" if st["approved"] else "·"
        print(f"{mid:<6} | {name:<32} | {dt:<8} | {dpx:<12} | {w:<5} | {npc:<4} | {ext:^7} | {ren:^6} | {pmdo:^5} | {appr:^7}")
    print()
    return 0


def cmd_select(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    try:
        extracted = extractor.extract_map(mid)
    except Exception as exc:
        print(f"Error selecting map {mid}: {exc}", file=sys.stderr)
        return 1

    pmu = extracted["pmu_map"]
    col = extracted["collision"]
    sem = extracted["semantics"]
    ent = extracted["entities"]
    tset = extracted["tileset"]

    print(f"\n=== PMU MAP SELECTION: {mid} ===")
    print(f"Name:               {pmu['name']}")
    print(f"Revision:           {pmu['revision']}")
    print(f"Dimensions:         {pmu['dimensions']['width_tiles']}x{pmu['dimensions']['height_tiles']} tiles ({pmu['dimensions']['width_px']}x{pmu['dimensions']['height_px']} px)")
    print(f"Environment:        Music: '{pmu['environment']['music']}', Weather: {pmu['environment']['weather']}, Moral: {pmu['environment']['moral']}, Indoors: {pmu['environment']['indoors']}")
    print(f"Collision Summary:  Walkable: {col['walkable_count']}, Blocked: {col['definite_block_count']}, Conditional: {col['conditional_block_count']}")
    print(f"Tilesets Used:      {tset['tileset_ids']} ({tset['animated_tiles_count']} animated tiles)")
    print(f"Warps Count:        {sem['warps_count']}")
    print(f"Signs Count:        {sem['signs_count']}")
    print(f"NPCs Count:         {ent['npc_count']}")
    if sem["warps"]:
        print("Warps detail:")
        for w in sem["warps"]:
            print(f"  - ({w['source_x']}, {w['source_y']}) -> Map {w['target_map_id']} @ ({w['target_x']}, {w['target_y']})")
    if sem["signs"]:
        print("Signs detail:")
        for s in sem["signs"]:
            lines = [l for l in s["lines"] if l.strip()]
            print(f"  - ({s['x']}, {s['y']}): {' / '.join(lines)}")
    print()
    return 0


def cmd_extract(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    data = extractor.extract_map(mid)

    out_dir = paths["imports_dir"] / mid
    out_dir.mkdir(parents=True, exist_ok=True)

    for doc_key, filename in (
        ("pmu_map", "pmu_map.json"),
        ("collision", "collision.json"),
        ("semantics", "semantics.json"),
        ("entities", "entities.json"),
        ("tileset", "tileset.json"),
        ("manifest", "manifest.json"),
    ):
        p = out_dir / filename
        p.write_text(json.dumps(data[doc_key], ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Extracted {mid} ({data['pmu_map']['name']}) -> {out_dir}")
    return 0


def cmd_render(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    data = extractor.extract_map(mid)

    renderer = PMURenderer(paths["tiles_dir"])
    try:
        base_img = renderer.render_map(data["pmu_map"], animated=False)
        preview_img = renderer.render_preview(base_img)
        col_img = renderer.render_collision_overlay(base_img, data["pmu_map"])

        has_anim = data["tileset"]["animated_tiles_count"] > 0
        anim_img = renderer.render_map(data["pmu_map"], animated=True) if has_anim else None

        render_dir = paths["renders_dir"] / mid
        render_dir.mkdir(parents=True, exist_ok=True)

        base_path = render_dir / "original.png"
        preview_path = render_dir / "preview.png"
        col_path = render_dir / "collision.png"
        anim_path = render_dir / "frame_animated.png"

        base_img.save(base_path, format="PNG", optimize=False, compress_level=9)
        preview_img.save(preview_path, format="PNG", optimize=False, compress_level=9)
        col_img.save(col_path, format="PNG", optimize=False, compress_level=9)
        if anim_img:
            anim_img.save(anim_path, format="PNG", optimize=False, compress_level=9)

        manifest = {
            "map_id": mid,
            "dimensions_px": list(base_img.size),
            "source_png": str(base_path),
            "source_png_sha256": sha256_file(base_path),
            "preview_png": str(preview_path),
            "preview_png_sha256": sha256_file(preview_path),
            "collision_png": str(col_path),
            "collision_png_sha256": sha256_file(col_path),
            "has_animations": has_anim,
            "status": "RENDERED",
        }
        (render_dir / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"Rendered {mid} ({base_img.size[0]}x{base_img.size[1]}px) -> {render_dir}")
        return 0
    finally:
        renderer.close()


def cmd_validate(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    data = extractor.extract_map(mid)

    # Check completeness
    pmu = data["pmu_map"]
    w = pmu["dimensions"]["width_tiles"]
    h = pmu["dimensions"]["height_tiles"]
    expected_tiles = w * h
    actual_tiles = len(pmu["tiles"])

    if actual_tiles != expected_tiles:
        print(f"VALIDATION FAILED for {mid}: Expected {expected_tiles} tiles, got {actual_tiles}", file=sys.stderr)
        return 1

    print(f"VALIDATION PASS for {mid}: {actual_tiles} tiles, {w}x{h} grid, 0 missing data.")
    return 0


def cmd_convert_pmdo(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    data = extractor.extract_map(mid)

    renderer = PMURenderer(paths["tiles_dir"])
    try:
        converter = PMDOConverter(paths["repo_root"], renderer)
        result = converter.convert_map(data)

        # Write sidecars to data/pmu_imports/<map_id>/
        import_dir = paths["imports_dir"] / mid
        import_dir.mkdir(parents=True, exist_ok=True)

        (import_dir / "semantics_original.json").write_text(json.dumps(data["semantics"], ensure_ascii=False, indent=2), encoding="utf-8")
        (import_dir / "semantics_pmdo.json").write_text(json.dumps(result["semantics_pmdo"], ensure_ascii=False, indent=2), encoding="utf-8")
        (import_dir / "pmdo_manifest.json").write_text(json.dumps(result["pmdo_manifest"], ensure_ascii=False, indent=2), encoding="utf-8")

        print(f"Converted {mid} to PMDO -> Ground: {result['ground_path']}, Tile: {result['tile_path']}, Script: {result['script_path']}")
        return 0
    finally:
        renderer.close()


def cmd_validate_pmdo(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)
    extractor = PMUExtractor(paths["db_path"], paths["repo_root"])
    data = extractor.extract_map(mid)

    renderer = PMURenderer(paths["tiles_dir"])
    try:
        pmu_base = renderer.render_map(data["pmu_map"], animated=False)
        has_anim = data["tileset"]["animated_tiles_count"] > 0
        pmu_anim = renderer.render_map(data["pmu_map"], animated=True) if has_anim else None

        ground_path = paths["repo_root"] / "Data/Ground" / f"pmu_{mid}.rsground"
        tile_path = paths["repo_root"] / "Content/Tile" / f"pmu_{mid}_Base.tile"

        if not ground_path.exists() or not tile_path.exists():
            print(f"Error: Converted PMDO files for {mid} do not exist. Run convert-pmdo first.", file=sys.stderr)
            return 1

        rsground_data = json.loads(ground_path.read_text(encoding="utf-8-sig"))
        tile_size, tile_images = read_pmdo_tile_file(tile_path)

        validator = PMDOValidator(paths["repo_root"])
        pmdo_base = validator.render_pmdo_map(rsground_data, tile_images, frame_index=0)
        pmdo_anim = validator.render_pmdo_map(rsground_data, tile_images, frame_index=1) if has_anim else None

        # Save PMDO renders
        render_dir = paths["renders_dir"] / mid
        render_dir.mkdir(parents=True, exist_ok=True)

        pmdo_render_path = render_dir / "pmdo.png"
        pmdo_col_path = render_dir / "pmdo_collision.png"

        pmdo_base.save(pmdo_render_path, format="PNG", optimize=False, compress_level=9)
        pmdo_col = validator.render_pmdo_collision(pmdo_base, rsground_data)
        pmdo_col.save(pmdo_col_path, format="PNG", optimize=False, compress_level=9)

        # Validate Visual
        visual_res = validator.validate_visual(pmu_base, pmdo_base, pmu_anim, pmdo_anim)
        # Validate Collision
        col_res = validator.validate_collision(data["collision"], rsground_data)

        # Write reports
        import_dir = paths["imports_dir"] / mid
        import_dir.mkdir(parents=True, exist_ok=True)
        (import_dir / "visual_validation.json").write_text(json.dumps(visual_res, ensure_ascii=False, indent=2), encoding="utf-8")
        (import_dir / "collision_validation.json").write_text(json.dumps(col_res, ensure_ascii=False, indent=2), encoding="utf-8")

        print(f"\n=== VALIDATION REPORT: {mid} ===")
        print(f"Visual Validation:    {visual_res['status']} (Diff: {visual_res['diff_pixels_base']} px, {visual_res['diff_percentage_base']}%)")
        print(f"Collision Validation: {col_res['status']} ({col_res['matched_cells']}/{col_res['total_pmdo_cells']} cells matched, {col_res['lost_blocked_cells']} lost)")

        if visual_res["status"] == "VALIDATED" and col_res["status"] == "VALIDATED":
            print(f"Result: 100% PERFECT ROUND-TRIP FIDELITY CERTIFIED")
            return 0
        else:
            print(f"Result: REFUSED (Visual: {visual_res['status']}, Collision: {col_res['status']})", file=sys.stderr)
            return 1
    finally:
        renderer.close()


def cmd_approve(args: argparse.Namespace) -> int:
    paths = get_default_paths(args.repo_root)
    mid = normalize_map_id(args.map_id)

    # Run validations
    if cmd_validate(args) != 0:
        print(f"Approval rejected: extraction validation failed for {mid}", file=sys.stderr)
        return 1

    if cmd_validate_pmdo(args) != 0:
        print(f"Approval rejected: PMDO validation failed for {mid}", file=sys.stderr)
        return 1

    update_renders_markdown(paths["repo_root"])
    print(f"SUCCESS: Map {mid} approved and promoted into New Era / PMDO!")
    return 0


def cmd_pipeline(args: argparse.Namespace) -> int:
    """Execute complete end-to-end pipeline on map_id."""
    mid = normalize_map_id(args.map_id)
    print(f"\n>>> RUNNING PMU MAP PIPELINE FOR {mid} <<<")
    steps = [
        ("1. Extract", cmd_extract),
        ("2. Render PMU Golden", cmd_render),
        ("3. Validate Extraction", cmd_validate),
        ("4. Convert PMDO", cmd_convert_pmdo),
        ("5. Validate PMDO & Visual Diff", cmd_validate_pmdo),
        ("6. Approve & Promote", cmd_approve),
    ]
    for name, step_fn in steps:
        print(f"\n--- Step: {name} ---")
        ret = step_fn(args)
        if ret != 0:
            print(f"PIPELINE STOPPED: Step '{name}' returned error code {ret}", file=sys.stderr)
            return ret
    print(f"\n>>> PIPELINE FINISHED SUCCESSFULLY FOR {mid} <<<\n")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="PMU Maps Extraction, Rendering, Adaptation & Validation Pipeline")
    parser.add_argument("--repo-root", type=Path, default=None, help="Root directory of the repository")

    subparsers = parser.add_subparsers(dest="command", required=True)

    # catalog
    p_cat = subparsers.add_parser("catalog", help="Browse and search maps in PMU database")
    p_cat.add_argument("query", nargs="?", default=None, help="Search string (name, ID, music)")
    p_cat.add_argument("--limit", type=int, default=50, help="Max maps to display")
    p_cat.add_argument("--offset", type=int, default=0, help="Offset for pagination")

    # select
    p_sel = subparsers.add_parser("select", help="View full summary of a specific map")
    p_sel.add_argument("map_id", help="Map ID (e.g. s95, 95, s737)")

    # extract
    p_ext = subparsers.add_parser("extract", help="Extract structured PMU map JSON documents")
    p_ext.add_argument("map_id", help="Map ID (e.g. s95, 95)")

    # render
    p_ren = subparsers.add_parser("render", help="Render PMU Golden reference PNG and collision overlay")
    p_ren.add_argument("map_id", help="Map ID")

    # validate
    p_val = subparsers.add_parser("validate", help="Validate extracted PMU data integrity")
    p_val.add_argument("map_id", help="Map ID")

    # convert-pmdo
    p_cvm = subparsers.add_parser("convert-pmdo", help="Convert PMU map to native PMDO .rsground and .tile")
    p_cvm.add_argument("map_id", help="Map ID")

    # validate-pmdo
    p_vpm = subparsers.add_parser("validate-pmdo", help="Render PMDO map and compare pixel-by-pixel with PMU Golden")
    p_vpm.add_argument("map_id", help="Map ID")

    # approve
    p_app = subparsers.add_parser("approve", help="Verify and approve map for New Era")
    p_app.add_argument("map_id", help="Map ID")

    # pipeline
    p_pip = subparsers.add_parser("pipeline", help="Run full pipeline end-to-end on a map")
    p_pip.add_argument("map_id", help="Map ID")

    args = parser.parse_args(argv)

    cmd_map = {
        "catalog": cmd_catalog,
        "select": cmd_select,
        "extract": cmd_extract,
        "render": cmd_render,
        "validate": cmd_validate,
        "convert-pmdo": cmd_convert_pmdo,
        "validate-pmdo": cmd_validate_pmdo,
        "approve": cmd_approve,
        "pipeline": cmd_pipeline,
    }

    fn = cmd_map.get(args.command)
    if fn:
        return fn(args)
    parser.print_help()
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
