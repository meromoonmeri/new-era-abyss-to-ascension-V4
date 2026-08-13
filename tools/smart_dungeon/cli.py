#!/usr/bin/env python3
"""Command-line interface for Smart Dungeon Designer."""
from __future__ import annotations
import argparse
import json
from pathlib import Path
from .assets import analyze_library
from .ground_gen import generate_ground
from .knowledge import analyze_references
from .project import generate_project, read, regenerate, validate_project, write
from .runtime import validate_runtime_index


def parser():
    root = argparse.ArgumentParser(prog="smart-dungeon", description="Level designer procédural explicable PMDO/RogueElements")
    root.add_argument("--repo", type=Path, default=Path.cwd())
    commands = root.add_subparsers(dest="command", required=True)
    analyze = commands.add_parser("analyze-assets", help="Analyse la bibliothèque par plusieurs sources")
    analyze.add_argument("--output", type=Path, required=True)
    analyze.add_argument("--overrides", type=Path)
    analyze.add_argument("--max-sheets", type=int, default=0)
    analyze.add_argument("--max-grounds", type=int, default=96)
    analyze.add_argument("--samples", type=int, default=24)
    create = commands.add_parser("create", help="Crée un donjon complet depuis une intention naturelle")
    create.add_argument("--project", type=Path, required=True)
    create.add_argument("--name", required=True)
    create.add_argument("--intent", required=True)
    create.add_argument("--floors", type=int)
    create.add_argument("--difficulty")
    create.add_argument("--boss", action=argparse.BooleanOptionalAction, default=None)
    create.add_argument("--mini-bosses", type=int)
    create.add_argument("--relays", type=int)
    create.add_argument("--seed", type=int)
    create.add_argument("--reference-zone")
    create.add_argument("--variants", type=int, default=6)
    create.add_argument("--max-assets", type=int, default=0)
    create.add_argument("--boss-species", help="Espèce explicite du boss; sinon inférence conservatrice")
    create.add_argument("--boss-category", choices=["auto", "classique", "legendaire", "fabuleux"], default="auto")
    create.add_argument("--narrative-prompt", default="", help="Contexte servant aux contrats de scène et dialogue")
    references = commands.add_parser("analyze-references", help="Indexe zones, Grounds, shops, PNJ, boss et grammaires de tiles")
    references.add_argument("--output", type=Path, required=True)
    references.add_argument("--max-zones", type=int, default=0)
    references.add_argument("--max-grounds", type=int, default=96)
    ground = commands.add_parser("generate-ground", help="Compose un Ground par géométrie abstraite et grammaire de tiles")
    ground.add_argument("--output-dir", type=Path, required=True)
    ground.add_argument("--id", required=True)
    ground.add_argument("--intent", required=True)
    ground.add_argument("--seed", type=int, required=True)
    ground.add_argument("--variants", type=int, default=4)
    ground.add_argument("--reference-ground")
    ground.add_argument("--width", type=int, default=64)
    ground.add_argument("--height", type=int, default=48)
    regen = commands.add_parser("regenerate", help="Régénère tout ou seulement une partie")
    regen.add_argument("--project", type=Path, required=True)
    regen.add_argument("--scope", default="all", help="all, floor:N, room:N:M ou decor:N")
    regen.add_argument("--seed", type=int)
    regen.add_argument("--force-unlock", action="store_true")
    regen.add_argument("--variants", type=int, default=6)
    validate = commands.add_parser("validate", help="Réévalue séparément structure, art et ZoneData")
    validate.add_argument("--project", type=Path, required=True)
    validate.add_argument("--output", type=Path)
    runtime = commands.add_parser("runtime-index", help="Valide le ZoneData dans PMDO 0.8.12 exact")
    runtime.add_argument("--project", type=Path, required=True)
    lock = commands.add_parser("lock", help="Verrouille/déverrouille un étage ou une salle")
    lock.add_argument("--project", type=Path, required=True)
    lock.add_argument("--floor", type=int, required=True)
    lock.add_argument("--room", type=int)
    lock.add_argument("--unlock", action="store_true")
    override = commands.add_parser("override-asset", help="Corrige une classification apprise")
    override.add_argument("--project", type=Path, required=True)
    override.add_argument("--asset", required=True)
    override.add_argument("--role", choices=["floor", "wall", "border", "structure", "decoration", "hazard", "water", "transition", "focal"])
    override.add_argument("--tags", nargs="*")
    override.add_argument("--rarity", type=float)
    explain_assets = commands.add_parser("explain-assets", help="Explique preuves, confiance et ambiguïtés des assets")
    explain_assets.add_argument("--project", type=Path, required=True)
    explain_assets.add_argument("--query", default="")
    explain_assets.add_argument("--limit", type=int, default=20)
    explain_design = commands.add_parser("explain-design", help="Explique la direction et les décisions d'un étage")
    explain_design.add_argument("--project", type=Path, required=True)
    explain_design.add_argument("--floor", type=int)
    return root


def main(argv=None):
    args = parser().parse_args(argv)
    repo = args.repo.resolve()
    if args.command == "analyze-assets":
        result = analyze_library(repo, args.output, args.overrides, args.max_sheets, args.max_grounds, args.samples)
        summary = {key: result[key] for key in ("result", "asset_count", "ground_sheet_count", "dungeon_texture_bundle_count", "cluster_count", "ambiguous_asset_count")}
    elif args.command == "analyze-references":
        result = analyze_references(repo, args.output, args.max_zones, args.max_grounds)
        summary = {key: result[key] for key in ("result", "zone_count", "ground_count", "map_template_count", "autotile_count", "shop_reference_zones", "neutral_reference_zones", "boss_reference_grounds")}
    elif args.command == "generate-ground":
        result = generate_ground(repo, args.output_dir, args.id, args.intent, args.seed, args.variants, args.reference_ground, args.width, args.height)
        summary = {"result": result["validation"]["result"], "ground": result["ground_file"], "metadata": result["metadata_file"], "preview": result["preview_file"], "score": result["score"], "validation": result["validation"]}
    elif args.command == "create":
        result = generate_project(repo, args.project, args.name, args.intent, args.floors, args.difficulty, args.boss, args.mini_bosses, args.relays, args.seed, args.reference_zone, args.variants, args.max_assets, args.boss_species, args.boss_category, args.narrative_prompt)
        summary = {
            "result": "SMART_DUNGEON_GENERATION_PASS", "project": str(args.project),
            "seed": result.brief.seed, "floors": len(result.floors),
            "mean_score": result.quality_summary["mean_score"],
            "mean_structural_score": result.quality_summary["mean_structural_score"],
            "mean_visual_score": result.quality_summary["mean_visual_score"],
            "dungeon_artistic_score": result.artistic_quality_summary["score"],
            "relays": len(result.relays), "segments": result.compiler.get("segment_count", 1),
            "content_profile": result.dungeon_profile.get("profile_id"),
            "boss_arena": result.boss_encounter.ground_file if result.boss_encounter else None,
            "boss_distance_tiles": result.boss_encounter.distance_tiles if result.boss_encounter else None,
            "zone": result.compiler["zone_file"],
        }
    elif args.command == "regenerate":
        result = regenerate(repo, args.project, args.scope, args.seed, args.force_unlock, args.variants)
        summary = {
            "result": "SMART_DUNGEON_REGENERATION_PASS", "scope": args.scope,
            "seed": result.brief.seed, "mean_score": result.quality_summary["mean_score"],
            "mean_structural_score": result.quality_summary["mean_structural_score"],
            "mean_visual_score": result.quality_summary["mean_visual_score"],
        }
    elif args.command == "validate":
        summary = validate_project(args.project)
        write(args.output or args.project / "validation_report.json", summary)
    elif args.command == "runtime-index":
        summary = validate_runtime_index(repo, args.project)
    elif args.command == "lock":
        path = args.project / "locks.json"
        data = read(path, {"floors": {}, "regions": []})
        floor = data.setdefault("floors", {}).setdefault(str(args.floor), {})
        floor["locked"] = not args.unlock
        if args.room is not None:
            floor.setdefault("rooms", {})[str(args.room)] = {"locked": not args.unlock}
        write(path, data)
        summary = {"result": "LOCK_UPDATED", "floor": args.floor, "room": args.room, "locked": not args.unlock}
    elif args.command == "override-asset":
        path = args.project / "asset_overrides.json"
        data = read(path, {"assets": {}, "visual_language": {}})
        row = data.setdefault("assets", {}).setdefault(args.asset, {})
        if args.role:
            row["role"] = args.role
        if args.tags is not None:
            row["tags"] = args.tags
        if args.rarity is not None:
            row["rarity"] = max(0, min(1, args.rarity))
        write(path, data)
        summary = {"result": "ASSET_OVERRIDE_UPDATED", "asset": args.asset, "override": row}
    elif args.command == "explain-assets":
        data = read(args.project / "asset_catalog.json", {"assets": []})
        query = args.query.casefold()
        rows = [row for row in data["assets"] if query in row["asset_id"].casefold()][:args.limit]
        summary = {
            "result": "ASSET_EXPLANATION",
            "assets": [{
                "asset_id": row["asset_id"], "kind": row["kind"],
                "roles": sorted(row["role_scores"].items(), key=lambda item: item[1], reverse=True)[:3],
                "tags": row["tags"], "rarity": row["rarity"], "cluster": row["cluster_id"],
                "confidence": row["confidence"], "ambiguous": row.get("ambiguous", False),
                "uncertainty_reasons": row.get("uncertainty_reasons", []),
                "evidence_sources": row.get("evidence_sources", []),
                "usage_contexts": row.get("usage_contexts", []),
                "compatible": row["compatible"][:5],
            } for row in rows],
        }
    else:
        project = read(args.project / "project.json", {})
        floors = project.get("floors", [])
        selected = next((row for row in floors if row["floor"] == args.floor), None) if args.floor else None
        summary = {
            "result": "DESIGN_EXPLANATION",
            "art_direction": project.get("art_direction", {}).get("decisions", []),
            "vocabulary": project.get("art_direction", {}).get("vocabulary", {}),
            "dungeon_artistic_quality": project.get("artistic_quality_summary", {}),
            "dungeon_profile": project.get("dungeon_profile", {}),
            "relays": project.get("relays", []),
            "boss_encounter": project.get("boss_encounter"),
            "floor": ({
                "floor": selected["floor"], "identity": selected.get("identity", {}),
                "rooms": [{"room_id": room["room_id"], "function": room.get("function"), "reason": room.get("design_reason")} for room in selected["rooms"]],
                "landmarks": selected.get("landmarks", []),
                "decoration_groups": selected.get("decoration_groups", []),
                "decisions": selected.get("decisions", []),
                "quality": selected.get("quality", {}),
            } if selected else None),
        }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0 if not str(summary.get("result", "")).endswith("FAIL") else 1


if __name__ == "__main__":
    raise SystemExit(main())
