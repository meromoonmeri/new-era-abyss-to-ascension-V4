#!/usr/bin/env python3
"""Project lifecycle with Phase 2 art direction and deterministic memory."""
from __future__ import annotations
import json
import random
from pathlib import Path
from statistics import mean
from .art_direction import build_art_direction
from .assets import analyze_library
from .compiler import compile_zone
from .composition import compose_decor, initial_memory, update_memory
from .intent import parse_intent
from .layout import progression, select_best, stable_seed
from .model import DesignBrief, DungeonPlan, FloorPlan, RelayPlan, Room
from .quality import evaluate, evaluate_dungeon
from .relay import design_relays, relay_sheet_svg, validate_relay_file
from .visual import contact_svg, design_board_svg, special_rooms_svg, svg_preview


def write(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")


def read(path, default=None):
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else default


def brief_from(data):
    # Missing Phase 2 fields receive dataclass defaults.
    fields = DesignBrief.__dataclass_fields__
    return DesignBrief(**{key: value for key, value in data.items() if key in fields})


def floor_from(data):
    data = dict(data)
    room_fields = Room.__dataclass_fields__
    data["rooms"] = [Room(**{key: value for key, value in row.items() if key in room_fields}) for row in data["rooms"]]
    floor_fields = FloorPlan.__dataclass_fields__
    return FloorPlan(**{key: value for key, value in data.items() if key in floor_fields})


def relay_from(data):
    fields = RelayPlan.__dataclass_fields__
    return RelayPlan(**{key: value for key, value in data.items() if key in fields})


def copy_floor(plan):
    return floor_from(plan.to_dict())


def _asset_roles(selection):
    return selection.get("roles", {})


def _ensure_catalog(repo, project, overrides, max_assets=0):
    path = project / "asset_catalog.json"
    existing = read(path)
    # A Phase 1 cache lacks usage evidence and ambiguity; refresh once.
    if not existing or existing.get("schema_version") != "2.0.0":
        return analyze_library(repo, path, overrides, max_assets), path
    return existing, path


def _summaries(plans, comparisons, artistic, changes=None):
    structural = [plan.quality["structural_score"] for plan in plans]
    visual = [plan.quality["visual_score"] for plan in plans]
    overall = [plan.quality["score"] for plan in plans]
    result = {
        "accepted_floor_count": sum(plan.quality["accepted"] for plan in plans),
        "floor_count": len(plans),
        "mean_score": round(mean(overall), 3),
        "minimum_score": round(min(overall), 3),
        "mean_structural_score": round(mean(structural), 3),
        "minimum_structural_score": round(min(structural), 3),
        "mean_visual_score": round(mean(visual), 3),
        "minimum_visual_score": round(min(visual), 3),
        "violations": {str(plan.floor): plan.quality["violations"] for plan in plans if plan.quality["violations"]},
        "candidate_comparisons": comparisons,
        "dungeon_artistic_quality": artistic,
    }
    if changes is not None:
        result["regeneration_changes"] = changes
    return result


def _decision_log(direction, plans, comparisons, relays=None):
    return [
        {"scope": "art_direction", **decision} for decision in direction.get("decisions", [])
    ] + [
        {"scope": "floor", "floor": plan.floor, "decisions": plan.decisions,
         "variant_selection": plan.identity.get("variant_selection", {})}
        for plan in plans
    ] + [
        {"scope": "relay", "relay_id": relay.relay_id, "after_floor": relay.after_floor,
         "decisions": relay.decisions, "validation": relay.validation}
        for relay in (relays or [])
    ] + [{"scope": "candidate_comparison", **row} for row in comparisons]


def _write_visuals(project, plans, direction, relays=None):
    for plan in plans:
        write(project / f"plans/floor_{plan.floor:03d}.json", plan.to_dict())
        svg_preview(plan, project / f"previews/floor_{plan.floor:03d}.svg")
    contact_svg(plans, project / "previews/contact_sheet.svg")
    special_rooms_svg(plans, project / "previews/special_rooms.svg")
    design_board_svg(plans, direction, project / "previews/design_board.svg")
    relay_sheet_svg(relays or [], project, project / "previews/relays.svg")


def generate_project(
    repo: Path,
    project: Path,
    name: str,
    intent: str,
    floors: int | None = None,
    difficulty: str | None = None,
    boss: bool | None = None,
    mini_bosses: int | None = None,
    relays: int | None = None,
    seed: int | None = None,
    reference: str | None = None,
    variants: int = 6,
    max_assets: int = 0,
):
    repo, project = repo.resolve(), project.resolve()
    project.mkdir(parents=True, exist_ok=True)
    brief = parse_intent(name, intent, floors, difficulty, boss, mini_bosses, relays, seed)
    overrides = read(project / "asset_overrides.json", {"assets": {}, "visual_language": {}})
    locks = read(project / "locks.json", {"floors": {}, "regions": []})
    catalog, catalog_path = _ensure_catalog(repo, project, project / "asset_overrides.json", max_assets)
    direction = build_art_direction(catalog, brief, overrides)
    selection = direction["runtime_selection"]
    rows = progression(brief, direction)
    plans, comparisons = [], []
    memory = initial_memory()
    for row in rows:
        plan, variants_report = select_best(
            brief, row, brief.seed, _asset_roles(selection), variants=variants,
            locks=locks, direction=direction, memory=memory,
        )
        plans.append(plan)
        comparisons.append({
            "floor": row["floor"], "candidates": variants_report,
            "selected_seed": plan.seed,
            "selected_policy": plan.identity.get("variant_selection", {}).get("policy"),
            "selected_structural_score": plan.quality["structural_score"],
            "selected_visual_score": plan.quality["visual_score"],
            "selected_score": plan.quality["score"],
        })
        memory = update_memory(memory, plan)

    artistic = evaluate_dungeon(plans, direction)
    quality = _summaries(plans, comparisons, artistic)
    relays, zone_script = design_relays(repo, project, brief, rows, catalog, direction)
    compiler = compile_zone(repo, brief, plans, selection, project / f"zone/{brief.slug}.json", reference, relays=relays)
    compiler["zone_file"] = Path(compiler["zone_file"]).relative_to(project).as_posix()
    compiler["zone_script_candidate"] = zone_script
    decisions = _decision_log(direction, plans, comparisons, relays)
    dungeon = DungeonPlan(
        schema_version="2.1.0", brief=brief, asset_cluster=selection["cluster_id"],
        asset_selection=selection, progression=rows, floors=plans,
        quality_summary=quality, compiler=compiler, art_direction=direction,
        artistic_quality_summary=artistic, decision_log=decisions, relays=relays,
    )
    _write_visuals(project, plans, direction, relays)
    write(project / "brief.json", brief.to_dict())
    write(project / "progression.json", rows)
    write(project / "art_direction.json", direction)
    write(project / "artistic_quality_report.json", artistic)
    write(project / "decision_log.json", decisions)
    write(project / "relays/manifest.json", {"schema_version": "1.0.0", "relay_count": len(relays), "zone_script_candidate": zone_script, "relays": [relay.to_dict() for relay in relays]})
    write(project / "quality_report.json", quality)
    write(project / "project.json", dungeon.to_dict())
    write(project / "generation_manifest.json", {
        "schema_version": "2.0.0", "result": "SMART_DUNGEON_GENERATION_PASS",
        "name": brief.name, "slug": brief.slug, "seed": brief.seed,
        "floor_count": brief.floors,
        "mean_quality_score": quality["mean_score"],
        "mean_structural_score": quality["mean_structural_score"],
        "mean_visual_score": quality["mean_visual_score"],
        "dungeon_artistic_score": artistic["score"],
        "relay_count": len(relays), "segment_count": len(relays) + 1,
        "relay_ground_candidates": [relay.ground_file for relay in relays],
        "relay_script_candidates": [relay.script_file for relay in relays],
        "zone_script_candidate": zone_script,
        "asset_catalog": catalog_path.name, "art_direction": "art_direction.json",
        "decision_log": "decision_log.json", "visual_language": selection,
        "compiler": compiler, "locks_file": "locks.json",
        "overrides_file": "asset_overrides.json", "reproducible": True,
    })
    if not (project / "locks.json").exists():
        write(project / "locks.json", {"floors": {}, "regions": [], "notes": "Set floors.<n>.locked=true or add region/POI locks."})
    if not (project / "asset_overrides.json").exists():
        write(project / "asset_overrides.json", {"assets": {}, "visual_language": {}, "notes": "Override inferred role/tags/rarity or lock the visual language."})
    return dungeon


def _rebuild_memory(memory, plan):
    return update_memory(memory, plan)


def regenerate(repo: Path, project: Path, scope: str = "all", seed: int | None = None, force_unlock: bool = False, variants: int = 6):
    repo, project = repo.resolve(), project.resolve()
    old = read(project / "project.json")
    if not old:
        raise FileNotFoundError(project / "project.json")
    brief = brief_from(old["brief"])
    brief.seed = seed if seed is not None else brief.seed
    catalog = read(project / "asset_catalog.json")
    overrides = read(project / "asset_overrides.json", {})
    direction = build_art_direction(catalog, brief, overrides)
    selection = direction["runtime_selection"]
    locks = read(project / "locks.json", {"floors": {}})
    old_plans = {row["floor"]: floor_from(row) for row in old["floors"]}
    rows = progression(brief, direction)
    plans, changes, comparisons = [], [], []
    memory = initial_memory()
    target_kind, target_floor, target_room = "all", None, None
    if scope != "all":
        parts = scope.split(":")
        target_kind = parts[0]
        target_floor = int(parts[1]) if len(parts) > 1 else None
        target_room = int(parts[2]) if len(parts) > 2 else None

    for row in rows:
        floor = row["floor"]
        locked = bool(locks.get("floors", {}).get(str(floor), {}).get("locked"))
        affected = scope == "all" or floor == target_floor
        if (locked and not force_unlock) or not affected:
            plan = old_plans[floor]
            plans.append(plan)
            memory = _rebuild_memory(memory, plan)
            continue
        if target_kind == "decor" and floor in old_plans:
            plan = copy_floor(old_plans[floor])
            compose_decor(plan, random.Random(stable_seed(brief.seed, "decor", floor)), direction, row, memory)
            plan.quality = evaluate(plan)
            plan.visual_quality = plan.quality["artistic"]
            changes.append({"floor": floor, "scope": "decoration_composition"})
        elif target_kind == "room" and floor in old_plans and target_room is not None:
            plan = copy_floor(old_plans[floor])
            room = next((item for item in plan.rooms if item.room_id == target_room), None)
            room_lock = bool(locks.get("floors", {}).get(str(floor), {}).get("rooms", {}).get(str(target_room), {}).get("locked"))
            if room and not room.locked and (force_unlock or not room_lock):
                rng = random.Random(stable_seed(brief.seed, "room", floor, target_room))
                for y in range(room.y, room.y + room.height):
                    for x in range(room.x, room.x + room.width):
                        if plan.get(x, y) == "room":
                            plan.set(x, y, "wall")
                room.cells = [[1 if rng.random() > .18 else 0 for _ in range(room.width)] for _ in range(room.height)]
                for ry, line in enumerate(room.cells):
                    for rx, value in enumerate(line):
                        if value:
                            plan.set(room.x + rx, room.y + ry, "room")
                room.design_reason += "; géométrie locale régénérée sans modifier l'identité d'étage"
                changes.append({"floor": floor, "scope": "room", "room_id": target_room})
            plan.quality = evaluate(plan)
            plan.visual_quality = plan.quality["artistic"]
        else:
            plan, variants_report = select_best(
                brief, row, stable_seed(brief.seed, "regen", scope), _asset_roles(selection),
                variants=variants, locks=locks, direction=direction, memory=memory,
            )
            comparisons.append({"floor": floor, "candidates": variants_report, "selected_seed": plan.seed})
            changes.append({"floor": floor, "scope": "structure_and_composition"})
        plans.append(plan)
        memory = _rebuild_memory(memory, plan)

    artistic = evaluate_dungeon(plans, direction)
    quality = _summaries(plans, comparisons, artistic, changes)
    relays, zone_script = design_relays(repo, project, brief, rows, catalog, direction)
    compiler = compile_zone(repo, brief, plans, selection, project / f"zone/{brief.slug}.json", old.get("compiler", {}).get("reference_zone"), relays=relays)
    compiler["zone_file"] = Path(compiler["zone_file"]).relative_to(project).as_posix()
    compiler["zone_script_candidate"] = zone_script
    decisions = _decision_log(direction, plans, comparisons, relays)
    dungeon = DungeonPlan(
        schema_version="2.1.0", brief=brief, asset_cluster=selection["cluster_id"],
        asset_selection=selection, progression=rows, floors=plans,
        quality_summary=quality, compiler=compiler, art_direction=direction,
        artistic_quality_summary=artistic, decision_log=decisions, relays=relays,
    )
    _write_visuals(project, plans, direction, relays)
    write(project / "brief.json", brief.to_dict())
    write(project / "progression.json", rows)
    write(project / "art_direction.json", direction)
    write(project / "artistic_quality_report.json", artistic)
    write(project / "decision_log.json", decisions)
    write(project / "relays/manifest.json", {"schema_version": "1.0.0", "relay_count": len(relays), "zone_script_candidate": zone_script, "relays": [relay.to_dict() for relay in relays]})
    write(project / "quality_report.json", quality)
    write(project / "project.json", dungeon.to_dict())
    write(project / "generation_manifest.json", {
        "schema_version": "2.0.0", "result": "SMART_DUNGEON_REGENERATION_PASS",
        "seed": brief.seed, "scope": scope, "changes": changes,
        "mean_quality_score": quality["mean_score"],
        "mean_structural_score": quality["mean_structural_score"],
        "mean_visual_score": quality["mean_visual_score"],
        "dungeon_artistic_score": artistic["score"],
        "relay_count": len(relays), "segment_count": len(relays) + 1,
        "relay_ground_candidates": [relay.ground_file for relay in relays],
        "zone_script_candidate": zone_script,
        "locked_floor_count": sum(bool(row.get("locked")) for row in locks.get("floors", {}).values()),
        "reproducible": True,
    })
    return dungeon


def validate_project(project: Path):
    data = read(project / "project.json")
    errors, structural_scores, visual_scores, scores, plans = [], [], [], [], []
    if not data:
        return {"result": "FAIL", "errors": ["project.json missing"]}
    for row in data["floors"]:
        plan = floor_from(row)
        quality = evaluate(plan)
        plan.quality = quality
        plans.append(plan)
        structural_scores.append(quality["structural_score"])
        visual_scores.append(quality["visual_score"])
        scores.append(quality["score"])
        if not quality["accepted"]:
            errors.append({
                "floor": plan.floor,
                "structural_score": quality["structural_score"],
                "visual_score": quality["visual_score"],
                "violations": quality["violations"],
            })
    direction = data.get("art_direction", read(project / "art_direction.json", {}))
    artistic = evaluate_dungeon(plans, direction)
    if not artistic["accepted"]:
        errors.append({"dungeon_artistic_quality": artistic["violations"]})
    relays = [relay_from(row) for row in data.get("relays", [])]
    if len(relays) != data["brief"].get("relays", 0):
        errors.append({"relay_count": {"expected": data["brief"].get("relays", 0), "actual": len(relays)}})
    if any(plan.special == "relay" for plan in plans):
        errors.append({"relay_model": "a relay must be a Ground boundary, not a procedural floor"})
    for relay in relays:
        validation = validate_relay_file(project, relay)
        if validation.get("result") != "RELAY_VALIDATION_PASS":
            errors.append({"relay": relay.relay_id, "validation": validation})
        if not (project / relay.script_file).exists():
            errors.append({"relay": relay.relay_id, "script_missing": relay.script_file})
    zone = project / data["compiler"]["zone_file"]
    try:
        zone_data = read(zone)
        segments = zone_data["Object"]["Segments"]
        segment_count = len(segments)
        compiled_floor_count = sum(len(segment.get("Floors", {}).get("nodes", [])) for segment in segments)
        ground_maps = zone_data["Object"].get("GroundMaps", [])
        stairs = sum(1 for item in _walk(segments) if isinstance(item, dict) and "FloorStairsStep" in item.get("$type", ""))
        if segment_count != len(relays) + 1:
            errors.append({"segment_count": {"expected": len(relays) + 1, "actual": segment_count}})
        if compiled_floor_count != len(plans):
            errors.append({"compiled_floor_count": {"expected": len(plans), "actual": compiled_floor_count}})
        if ground_maps != [relay.relay_id for relay in relays]:
            errors.append({"ground_maps": {"expected": [relay.relay_id for relay in relays], "actual": ground_maps}})
    except Exception as exception:
        errors.append({"zone": str(exception)})
        stairs = 0
        segment_count = 0
        compiled_floor_count = 0
    passed = not errors and stairs >= len(plans)
    return {
        "result": "SMART_DUNGEON_VALIDATION_PASS" if passed else "SMART_DUNGEON_VALIDATION_FAIL",
        "floor_count": len(plans),
        "mean_score": round(mean(scores), 3),
        "minimum_score": min(scores),
        "mean_structural_score": round(mean(structural_scores), 3),
        "minimum_structural_score": min(structural_scores),
        "mean_visual_score": round(mean(visual_scores), 3),
        "minimum_visual_score": min(visual_scores),
        "dungeon_artistic_score": artistic["score"],
        "relay_count": len(relays),
        "segment_count": segment_count,
        "compiled_floor_count": compiled_floor_count,
        "stairs_step_count": stairs,
        "errors": errors,
    }


def _walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from _walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from _walk(child)
