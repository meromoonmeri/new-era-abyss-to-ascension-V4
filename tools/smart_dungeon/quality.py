#!/usr/bin/env python3
"""Independent structural, artistic and whole-dungeon validation."""
from __future__ import annotations
import json
from collections import Counter, defaultdict, deque
from statistics import mean, pstdev
from .model import FloorPlan


def _neighbors(x, y, width, height):
    for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
        if 0 <= nx < width and 0 <= ny < height:
            yield nx, ny


def _walkable(plan):
    return {(x, y) for y in range(plan.height) for x in range(plan.width) if plan.get(x, y) != "wall"}


def _bfs(plan, start):
    distances = {start: 0}
    queue = deque([start])
    while queue:
        x, y = queue.popleft()
        for point in _neighbors(x, y, plan.width, plan.height):
            if point not in distances and plan.get(*point) != "wall":
                distances[point] = distances[(x, y)] + 1
                queue.append(point)
    return distances


def _longest_straight(plan):
    best = 0
    for y in range(plan.height):
        run = 0
        for x in range(plan.width):
            run = run + 1 if plan.get(x, y) == "corridor" else 0
            best = max(best, run)
    for x in range(plan.width):
        run = 0
        for y in range(plan.height):
            run = run + 1 if plan.get(x, y) == "corridor" else 0
            best = max(best, run)
    return best


def evaluate_structure(plan: FloorPlan):
    walkable = _walkable(plan)
    distances = _bfs(plan, tuple(plan.entrance))
    accessibility = len(distances) / max(1, len(walkable))
    exit_distance = distances.get(tuple(plan.exit), 0)
    room_sizes = [sum(sum(row) for row in room.cells) for room in plan.rooms]
    size_bins = {min(4, size // 35) for size in room_sizes}
    shape_types = {room.kind for room in plan.rooms}
    variety = min(1, len(size_bins) / 3 * .5 + len(shape_types) / 4 * .5)
    edge_count = len(plan.edges)
    loops = max(0, edge_count - len(plan.rooms) + 1)
    loop_score = min(1, loops / max(1, len(plan.rooms) // 4))
    straight = _longest_straight(plan)
    corridor_score = max(0, 1 - straight / max(12, plan.width * .45))
    symmetry_difference = 0
    for y in range(plan.height):
        for x in range(plan.width // 2):
            symmetry_difference += plan.get(x, y) != plan.get(plan.width - 1 - x, y)
    asymmetry = min(1, symmetry_difference / max(1, plan.height * plan.width // 2))
    critical = [plan.entrance, plan.exit] + [point["position"] for point in plan.points_of_interest]
    critical_clear = all(
        not (decoration["x"] == point[0] and decoration["y"] == point[1] and decoration.get("blocking"))
        for decoration in plan.decorations for point in critical
    )
    poi_clear = all(plan.get(*point["position"]) != "wall" for point in plan.points_of_interest)
    density = len(walkable) / max(1, plan.width * plan.height)
    family = plan.identity.get("composition_family", plan.archetype)
    density_target = .28 if family in ("corridor_spine", "chamber_sequence", "labyrinth") else .43 if family in ("open_field", "island_clusters", "open") else .35
    density_score = max(0, 1 - abs(density - density_target) / .35)
    path_score = min(1, exit_distance / max(1, (plan.width + plan.height) * .52))
    readability = accessibility * .48 + corridor_score * .22 + density_score * .2 + (1 if critical_clear and poi_clear else 0) * .1
    spatial = variety * .30 + loop_score * .19 + asymmetry * .12 + path_score * .24 + density_score * .15
    score = 100 * (readability * .56 + spatial * .44)
    violations = []
    if accessibility < 1:
        violations.append({"code": "DISCONNECTED", "severity": 1 - accessibility, "repair": "connect_components", "layer": "structural"})
    if straight > max(14, int(plan.width * .34)):
        violations.append({"code": "LONG_CORRIDOR", "severity": straight / plan.width, "repair": "break_corridor", "layer": "structural"})
    if variety < .42:
        violations.append({"code": "LOW_ROOM_VARIETY", "severity": 1 - variety, "repair": "reshape_room", "layer": "structural"})
    if loop_score < .28 and family not in ("corridor_spine", "chamber_sequence", "arena", "boss_stage", "mini_boss_stage"):
        violations.append({"code": "TOO_LINEAR", "severity": 1 - loop_score, "repair": "add_loop", "layer": "structural"})
    if asymmetry < .16 and not plan.identity.get("signature", {}).get("intentional_symmetry"):
        violations.append({"code": "ACCIDENTAL_SYMMETRY", "severity": 1 - asymmetry, "repair": "asymmetric_alcove", "layer": "structural"})
    if not critical_clear or not poi_clear:
        violations.append({"code": "BLOCKED_CRITICAL_POINT", "severity": 1, "repair": "clear_critical", "layer": "structural"})
    metrics = {
        "accessibility": accessibility,
        "exit_distance": exit_distance,
        "room_variety": variety,
        "loop_score": loop_score,
        "longest_straight_corridor": straight,
        "asymmetry": asymmetry,
        "walkable_density": density,
        "readability": readability,
        "spatial_quality": spatial,
    }
    return {
        "accepted": score >= 72 and not any(row["code"] in ("DISCONNECTED", "BLOCKED_CRITICAL_POINT") for row in violations),
        "score": round(score, 3),
        "metrics": {key: round(value, 4) if isinstance(value, float) else value for key, value in metrics.items()},
        "violations": violations,
    }


def _decor_by_room(plan):
    result = defaultdict(list)
    for decoration in plan.decorations:
        for room in plan.rooms:
            if room.x <= decoration["x"] < room.x + room.width and room.y <= decoration["y"] < room.y + room.height:
                result[room.room_id].append(decoration)
                break
    return result


def evaluate_artistry(plan: FloorPlan):
    decorations = plan.decorations
    count = len(decorations)
    by_room = _decor_by_room(plan)
    room_densities = []
    for room in plan.rooms:
        area = max(1, sum(sum(row) for row in room.cells))
        room_densities.append(len(by_room[room.room_id]) / area)
    quiet_fraction = sum(value <= .012 for value in room_densities) / max(1, len(room_densities))
    negative_space = max(0, 1 - abs(quiet_fraction - .28) / .45)
    density_variation = min(1, pstdev(room_densities) / .025) if len(room_densities) > 1 else 0

    assets = Counter(decoration["asset_id"] for decoration in decorations)
    largest_share = max(assets.values(), default=0) / max(1, count)
    repetition = max(0, min(1, (1 - largest_share) * .72 + min(1, len(assets) / max(2, count / 4)) * .28))
    motifs = Counter(group.get("motif") for group in plan.decoration_groups)
    motif_share = max(motifs.values(), default=0) / max(1, len(plan.decoration_groups))
    motif_diversity = 1 if not plan.decoration_groups else max(0, 1 - (motif_share - .34) / .66)
    grouped_positions = {tuple(position) for group in plan.decoration_groups for position in group.get("positions", [])}
    group_coverage = sum((decoration["x"], decoration["y"]) in grouped_positions for decoration in decorations) / max(1, count)

    hierarchy = Counter(decoration.get("hierarchy", "common") for decoration in decorations)
    focal_count = hierarchy["focal"]
    expected_focal = 1 if plan.landmarks else 0
    focal_hierarchy = max(0, 1 - abs(focal_count - expected_focal) / max(1, expected_focal + 1))
    rare_ratio = (hierarchy["rare"] + hierarchy["focal"]) / max(1, count)
    rarity_discipline = max(0, 1 - max(0, rare_ratio - .16) / .28)

    landmark_quality = 0
    if plan.landmarks:
        landmark = plan.landmarks[0]
        room = next((room for room in plan.rooms if room.room_id == landmark.get("room_id")), None)
        reachable = tuple(landmark.get("position", [-1, -1])) in _bfs(plan, tuple(plan.entrance))
        landmark_quality = (.35 if room and room.visual_role == "focal" else .15) + (.30 if reachable else 0) + (.25 if landmark.get("reason") else 0) + (.10 if landmark.get("orientation_role") else 0)
    elif not any(room.importance >= .8 for room in plan.rooms):
        landmark_quality = .65

    identity = plan.identity
    signature = identity.get("signature", {})
    family = identity.get("composition_family")
    identity_strength = 0
    if family:
        identity_strength += .28
    if signature:
        identity_strength += .24
    if any(room.function != "exploration" for room in plan.rooms):
        identity_strength += .20
    if len(plan.composition_regions) >= 2:
        identity_strength += .16
    if identity.get("selection_reason"):
        identity_strength += .12

    beat_names = [beat.get("beat") for beat in plan.spatial_beats]
    rhythm = min(1, len(set(beat_names)) / 5) if beat_names else 0
    if plan.special and any(name in beat_names for name in ("preparation", "rupture", "recovery", "climax")):
        rhythm = min(1, rhythm + .15)

    visual_roles = Counter(room.visual_role for room in plan.rooms)
    hierarchy_regions = min(1, len(visual_roles) / 3)
    functional_geometry = sum(
        bool(room.design_reason) and room.function != "exploration"
        for room in plan.rooms
    ) / max(1, len(plan.rooms))

    region_densities = []
    for region in sorted(plan.composition_regions, key=lambda item: item.get("order", 0)):
        room_ids = set(region.get("room_ids", []))
        area = sum(max(1, sum(sum(row) for row in room.cells)) for room in plan.rooms if room.room_id in room_ids)
        decor = sum(len(by_room[room_id]) for room_id in room_ids)
        region_densities.append(decor / max(1, area))
    if len(region_densities) >= 2:
        jumps = [abs(a - b) for a, b in zip(region_densities, region_densities[1:])]
        transition_coherence = max(0, 1 - mean(jumps) / .09)
    else:
        transition_coherence = .55

    surprise_budget = identity.get("surprise_budget", .08)
    surprises = sum(group.get("purpose") == "surprise_controlee" for group in plan.decoration_groups)
    realized_surprise = surprises / max(1, len(plan.decoration_groups))
    surprise_control = max(0, 1 - abs(realized_surprise - surprise_budget) / max(.12, surprise_budget + .06))
    if not plan.decoration_groups:
        surprise_control = .45

    metrics = {
        "visual_hierarchy": focal_hierarchy * .55 + hierarchy_regions * .45,
        "negative_space": negative_space,
        "density_variation": density_variation,
        "asset_repetition_control": repetition,
        "motif_diversity": motif_diversity,
        "composition_group_coverage": group_coverage,
        "rarity_discipline": rarity_discipline,
        "landmark_quality": landmark_quality,
        "identity_strength": min(1, identity_strength),
        "spatial_rhythm": rhythm,
        "transition_coherence": transition_coherence,
        "functional_geometry": functional_geometry,
        "surprise_control": surprise_control,
    }
    weights = {
        "visual_hierarchy": .10,
        "negative_space": .09,
        "density_variation": .08,
        "asset_repetition_control": .10,
        "motif_diversity": .07,
        "composition_group_coverage": .08,
        "rarity_discipline": .06,
        "landmark_quality": .10,
        "identity_strength": .10,
        "spatial_rhythm": .08,
        "transition_coherence": .05,
        "functional_geometry": .06,
        "surprise_control": .03,
    }
    score = 100 * sum(metrics[key] * weight for key, weight in weights.items())
    violations = []
    rules = [
        ("VISUAL_MONOTONY", repetition, .42, "reduce_asset_repetition"),
        ("FLAT_VISUAL_DENSITY", density_variation, .26, "create_breathing_space"),
        ("WEAK_LANDMARK", landmark_quality, .52, "strengthen_landmark"),
        ("WEAK_IDENTITY", identity_strength, .58, "reinforce_signature"),
        ("MECHANICAL_DECOR", group_coverage, .68, "regroup_decor"),
        ("MOTIF_REPETITION", motif_diversity, .48, "vary_motifs"),
        ("WEAK_SPATIAL_RHYTHM", rhythm, .48, "reinforce_rhythm"),
    ]
    for code, value, threshold, repair in rules:
        if value < threshold:
            violations.append({"code": code, "severity": round(threshold - value, 4), "repair": repair, "layer": "artistic"})
    if focal_count > expected_focal + 1:
        violations.append({"code": "FOCAL_NOISE", "severity": focal_count / max(1, count), "repair": "clear_focal_noise", "layer": "artistic"})
    if rare_ratio > .24:
        violations.append({"code": "RARE_ASSET_OVERUSE", "severity": rare_ratio, "repair": "reduce_rare_assets", "layer": "artistic"})
    return {
        "accepted": score >= 66 and not any(row["code"] in ("FOCAL_NOISE", "RARE_ASSET_OVERUSE") for row in violations),
        "score": round(score, 3),
        "metrics": {key: round(value, 4) for key, value in metrics.items()},
        "violations": violations,
    }


def evaluate(plan: FloorPlan, visual_compatibility: float = 1.0):
    structure = evaluate_structure(plan)
    artistry = evaluate_artistry(plan)
    # Harmonic-like bottleneck: excellence in one layer cannot hide failure in the other.
    structural_score, visual_score = structure["score"], artistry["score"]
    overall = .50 * min(structural_score, visual_score) + .25 * structural_score + .25 * visual_score
    all_violations = structure["violations"] + artistry["violations"]
    metrics = dict(structure["metrics"])
    metrics.update({f"visual_{key}": value for key, value in artistry["metrics"].items()})
    metrics.update({
        "structural_score": structural_score,
        "visual_score": visual_score,
        "visual_compatibility": visual_compatibility,
        "score": overall,
    })
    accepted = structure["accepted"] and artistry["accepted"]
    result = {
        "accepted": accepted,
        "score": round(overall, 3),
        "structural_score": structural_score,
        "visual_score": visual_score,
        "structural": structure,
        "artistic": artistry,
        "metrics": metrics,
        "violations": all_violations,
    }
    plan.visual_quality = artistry
    return result


def _asset_set(plan):
    return {decoration["asset_id"] for decoration in plan.decorations}


def evaluate_dungeon(plans: list[FloorPlan], direction: dict | None = None):
    if not plans:
        return {"accepted": False, "score": 0, "violations": [{"code": "NO_FLOORS"}]}
    families = [plan.identity.get("composition_family", plan.archetype) for plan in plans]
    signatures = [json.dumps(plan.identity.get("signature", {}), sort_keys=True) for plan in plans]
    family_diversity = min(1, len(set(families)) / min(6, len(plans)))
    signature_diversity = min(1, len(set(signatures)) / max(1, len(plans) * .72))

    adjacent_similarities = []
    for left, right in zip(plans, plans[1:]):
        family_match = families[left.floor - 1] == families[right.floor - 1]
        left_assets, right_assets = _asset_set(left), _asset_set(right)
        union = left_assets | right_assets
        asset_similarity = len(left_assets & right_assets) / max(1, len(union))
        left_density = left.identity.get("composition", {}).get("decoration_density_realized", 0)
        right_density = right.identity.get("composition", {}).get("decoration_density_realized", 0)
        density_similarity = max(0, 1 - abs(left_density - right_density) / .08)
        adjacent_similarities.append(family_match * .45 + asset_similarity * .3 + density_similarity * .25)
    adjacent_differentiation = 1 - mean(adjacent_similarities) if adjacent_similarities else 1

    spectacle = [plan.identity.get("spectacle", 0) for plan in plans]
    peaks = [index for index, value in enumerate(spectacle) if value >= .68]
    rare_peaks = max(0, 1 - max(0, len(peaks) - max(2, len(plans) // 4)) / max(1, len(plans)))
    finale = 1 if not spectacle or spectacle[-1] >= max(spectacle) - .02 else .4
    spectacle_progression = rare_peaks * .55 + finale * .45

    focal_assets = [landmark["asset_id"] for plan in plans for landmark in plan.landmarks if landmark.get("rare")]
    focal_counts = Counter(focal_assets)
    focal_repetition = 1 if not focal_counts else max(0, 1 - (max(focal_counts.values()) - 1) / max(1, len(plans) / 3))
    all_assets = Counter(decoration["asset_id"] for plan in plans for decoration in plan.decorations)
    budget_violations = []
    for asset_id, budget in (direction or {}).get("asset_budgets", {}).items():
        if all_assets[asset_id] > budget:
            budget_violations.append({"asset_id": asset_id, "used": all_assets[asset_id], "budget": budget})
    budget_discipline = 1 if not budget_violations else max(0, 1 - len(budget_violations) / max(1, len(all_assets)))
    mean_visual = mean(plan.quality.get("visual_score", 0) for plan in plans) / 100
    metrics = {
        "mean_visual_quality": mean_visual,
        "composition_family_diversity": family_diversity,
        "signature_diversity": signature_diversity,
        "adjacent_floor_differentiation": adjacent_differentiation,
        "spectacle_progression": spectacle_progression,
        "focal_asset_repetition_control": focal_repetition,
        "asset_budget_discipline": budget_discipline,
    }
    weights = {
        "mean_visual_quality": .24,
        "composition_family_diversity": .17,
        "signature_diversity": .17,
        "adjacent_floor_differentiation": .15,
        "spectacle_progression": .12,
        "focal_asset_repetition_control": .08,
        "asset_budget_discipline": .07,
    }
    score = 100 * sum(metrics[key] * weight for key, weight in weights.items())
    violations = []
    if len(plans) >= 6 and family_diversity < .5:
        violations.append({"code": "DUNGEON_COMPOSITION_REPETITION", "severity": .5 - family_diversity})
    if adjacent_differentiation < .28:
        violations.append({"code": "ADJACENT_FLOORS_TOO_SIMILAR", "severity": .28 - adjacent_differentiation})
    if spectacle_progression < .62:
        violations.append({"code": "FLAT_SPECTACLE_CURVE", "severity": .62 - spectacle_progression})
    if budget_violations:
        violations.append({"code": "ASSET_BUDGET_EXCEEDED", "assets": budget_violations})
    return {
        "accepted": score >= 62 and not budget_violations and not any(row["code"] == "DUNGEON_COMPOSITION_REPETITION" for row in violations),
        "score": round(score, 3),
        "metrics": {key: round(value, 4) for key, value in metrics.items()},
        "violations": violations,
        "family_sequence": families,
        "spectacle_curve": spectacle,
        "asset_usage": dict(sorted(all_assets.items())),
        "focal_asset_usage": dict(sorted(focal_counts.items())),
    }
