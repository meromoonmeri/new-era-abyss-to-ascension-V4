#!/usr/bin/env python3
"""Landmarks, decorative groups, negative space and design memory."""
from __future__ import annotations
from collections import Counter, deque
from copy import deepcopy
from typing import Any
from .model import FloorPlan, Room

GROUP_PATTERNS = {
    "anchor_satellites": [(0, 0), (-1, 1), (1, 1), (0, 2)],
    "framing_pair": [(-2, 0), (2, 0)],
    "corner_cluster": [(0, 0), (1, 0), (0, 1)],
    "edge_rhythm": [(-3, 0), (0, 0), (3, 0)],
    "asymmetric_echo": [(0, 0), (2, 1), (-1, 3)],
    "threshold_markers": [(0, -1), (0, 1)],
}


def initial_memory():
    return {
        "asset_usage": {},
        "focal_last_floor": {},
        "recent_assets": [],
        "recent_families": [],
        "recent_motifs": [],
        "floor_signatures": [],
    }


def _vocabulary(direction, tier):
    if not direction:
        return []
    if "vocabulary" in direction:
        return direction["vocabulary"].get(tier, [])
    # Backward-compatible Phase 1 role dictionary.
    aliases = {"primary": "common", "secondary": "secondary", "exceptional": "focal", "transition": "rare"}
    roles = direction.get("roles", direction)
    return [
        {"asset_id": asset_id, "tier": tier, "purpose": "legacy_role", "budget": 999, "confidence": 1}
        for asset_id in roles.get(aliases[tier], [])
    ]


def _room_cells(plan: FloorPlan, room: Room):
    cells = []
    for y in range(room.y, room.y + room.height):
        for x in range(room.x, room.x + room.width):
            if 0 <= x < plan.width and 0 <= y < plan.height and plan.get(x, y) == "room":
                cells.append((x, y))
    return cells


def _near_wall(plan, point):
    x, y = point
    return sum(
        plan.get(nx, ny) == "wall"
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1))
        if 0 <= nx < plan.width and 0 <= ny < plan.height
    )


def _transform(pattern, rotation, mirror):
    result = []
    for x, y in pattern:
        if mirror:
            x = -x
        for _ in range(rotation % 4):
            x, y = -y, x
        result.append((x, y))
    return result


def _critical_points(plan):
    result = {tuple(plan.entrance), tuple(plan.exit)}
    result |= {tuple(point["position"]) for point in plan.points_of_interest}
    return result


def _safe(plan, point, occupied, critical, distance=2):
    x, y = point
    if not (1 <= x < plan.width - 1 and 1 <= y < plan.height - 1):
        return False
    if plan.get(x, y) not in ("room", "corridor") or point in occupied:
        return False
    if any(abs(x - cx) + abs(y - cy) <= distance for cx, cy in critical):
        return False
    return True


def _choose_asset(pool, usage, local_recent, budgets, rng):
    if not pool:
        return None
    candidates = []
    for entry in pool:
        asset_id = entry["asset_id"]
        budget = budgets.get(asset_id, entry.get("budget", 999))
        if usage.get(asset_id, 0) >= budget:
            continue
        recency = local_recent.count(asset_id)
        candidates.append((usage.get(asset_id, 0) * 3 + recency * 5, -entry.get("confidence", 0), asset_id, entry))
    if not candidates:
        return None
    best_penalty = min(row[0] for row in candidates)
    shortlist = [row for row in candidates if row[0] <= best_penalty + 2]
    return shortlist[rng.randrange(len(shortlist))][3]


def _room_anchor(plan, room, pattern_name, rng):
    cells = _room_cells(plan, room)
    if not cells:
        return None
    center = (room.x + room.width // 2, room.y + room.height // 2)
    if pattern_name in ("framing_pair", "anchor_satellites") and center in cells:
        return center
    wall_cells = [point for point in cells if _near_wall(plan, point)]
    source = wall_cells if wall_cells else cells
    return source[rng.randrange(len(source))]


def assign_landmark(plan: FloorPlan, direction: dict, row: dict, memory: dict, rng):
    focal_rooms = [room for room in plan.rooms if room.visual_role == "focal" or room.importance >= .8]
    if not focal_rooms:
        return
    room = max(focal_rooms, key=lambda item: (item.importance, item.width * item.height, -item.room_id))
    exceptional = _vocabulary(direction, "exceptional")
    if plan.special == "boss" and exceptional:
        pool = exceptional[-1:]
    elif plan.special == "mini_boss" and exceptional:
        # Preserve the last exceptional asset for the final climax.
        pool = exceptional[:-1] or _vocabulary(direction, "transition")
    else:
        pool = _vocabulary(direction, "secondary") or _vocabulary(direction, "transition")
    budgets = direction.get("asset_budgets", {}) if direction else {}
    usage = Counter(memory.get("asset_usage", {}))
    recent = list(memory.get("recent_assets", []))
    entry = _choose_asset(pool, usage, recent, budgets, rng)
    position = [room.x + room.width // 2, room.y + room.height // 2]
    if entry:
        asset_id = entry["asset_id"]
        # Exceptional assets should not recur on adjacent floors.
        last = memory.get("focal_last_floor", {}).get(asset_id, -999)
        if plan.floor - last <= 2 and len(pool) > 1:
            alternatives = [item for item in pool if item["asset_id"] != asset_id]
            entry = _choose_asset(alternatives, usage, recent, budgets, rng) or entry
            asset_id = entry["asset_id"]
    else:
        asset_id = "structural_landmark"
    landmark = {
        "landmark_id": f"F{plan.floor:03d}-L01",
        "room_id": room.room_id,
        "position": position,
        "asset_id": asset_id,
        "orientation_role": "global_anchor" if room.importance >= .9 else "local_anchor",
        "visibility": "room_arrival",
        "reason": f"la fonction {room.function} et son importance {room.importance:.2f} nécessitent un repère mémorisable",
        "rare": bool(entry and entry.get("tier") == "exceptional"),
    }
    plan.landmarks = [landmark]
    if not any(point.get("kind") in ("boss", "mini_boss", "relay") for point in plan.points_of_interest):
        plan.points_of_interest.append({"kind": "landmark", "position": position, "importance": room.importance, "locked": False})
    plan.decisions.append({
        "stage": "landmark",
        "decision": asset_id,
        "room_id": room.room_id,
        "why": landmark["reason"],
        "evidence": entry.get("evidence", []) if entry else ["geometry_only"],
    })


def compose_decor(
    plan: FloorPlan,
    rng,
    direction: dict | None,
    row: dict,
    memory: dict | None = None,
):
    """Compose decorations in groups after identity, structure and landmarks."""
    memory = deepcopy(memory or initial_memory())
    direction = direction or {}
    plan.decorations = []
    plan.decoration_groups = []
    if not plan.landmarks:
        assign_landmark(plan, direction, row, memory, rng)

    pools = {
        tier: _vocabulary(direction, tier)
        for tier in ("primary", "secondary", "exceptional", "transition")
    }
    budgets = direction.get("asset_budgets", {})
    usage = Counter(memory.get("asset_usage", {}))
    # Reserve the landmark's budget before composing its supporting groups.
    for landmark in plan.landmarks:
        if landmark.get("asset_id") != "structural_landmark":
            usage[landmark["asset_id"]] += 1
    local_recent = deque(memory.get("recent_assets", [])[-5:], maxlen=7)
    critical = _critical_points(plan)
    occupied = set()
    target_density = row.get("decoration_density", .5)
    patterns = list(GROUP_PATTERNS)
    recent_motifs = list(memory.get("recent_motifs", []))
    group_index = 0
    surprise_enabled = rng.random() < row.get("surprise_budget", .08) and plan.special not in ("boss", "relay")
    surprise_used = False

    # At least one room remains deliberately quiet; gateways and preparation
    # rooms are kept low-noise to support orientation and anticipation.
    breathing_candidates = [room for room in plan.rooms if room.function in ("breathing", "gateway", "preparation", "transition")]
    if not breathing_candidates and plan.rooms:
        breathing_candidates = [min(plan.rooms, key=lambda room: room.importance)]
    breathing_ids = {room.room_id for room in breathing_candidates[:max(1, len(plan.rooms) // 6)]}

    for room in sorted(plan.rooms, key=lambda item: (item.visual_role == "focal", item.room_id)):
        area = len(_room_cells(plan, room))
        if area < 12:
            continue
        if room.room_id in breathing_ids:
            group_count = 0 if area < 80 else 1
        else:
            multiplier = {"neutral": .55, "support": .9, "transition": .65, "focal": 1.2}.get(room.visual_role, .7)
            group_count = max(0, round(area / 90 * (.5 + target_density) * multiplier))
            if area >= 22 and room.visual_role in ("support", "focal"):
                group_count = max(1, group_count)
            group_count = min(group_count, 3 if room.visual_role == "focal" else 2)

        for local_index in range(group_count):
            available_patterns = [name for name in patterns if name not in recent_motifs[-2:]] or patterns
            if room.function in ("gateway", "preparation"):
                pattern_name = "threshold_markers"
            elif room.visual_role == "focal" and local_index == 0:
                pattern_name = "anchor_satellites"
            else:
                pattern_name = available_patterns[rng.randrange(len(available_patterns))]
            anchor = _room_anchor(plan, room, pattern_name, rng)
            if not anchor:
                continue
            rotation = rng.randrange(4)
            mirror = bool(rng.randrange(2))
            offsets = _transform(GROUP_PATTERNS[pattern_name], rotation, mirror)
            is_surprise = surprise_enabled and not surprise_used and room.visual_role == "support" and local_index == 0
            tier = (
                "transition" if is_surprise
                else "secondary" if room.visual_role in ("support", "focal")
                else "transition" if room.visual_role == "transition"
                else "primary"
            )
            anchor_entry = _choose_asset(pools[tier] or pools["primary"], usage, list(local_recent), budgets, rng)
            satellite_entry = _choose_asset(pools["primary"] or pools[tier], usage, list(local_recent), budgets, rng)
            if not anchor_entry and not satellite_entry:
                continue
            placements = []
            for offset_index, (dx, dy) in enumerate(offsets):
                point = (anchor[0] + dx, anchor[1] + dy)
                if not _safe(plan, point, occupied, critical, 3 if room.visual_role == "focal" else 2):
                    continue
                entry = anchor_entry if offset_index == 0 else satellite_entry or anchor_entry
                asset_id = entry["asset_id"]
                budget = budgets.get(asset_id, entry.get("budget", 999))
                if usage[asset_id] >= budget:
                    entry = _choose_asset(pools["primary"], usage, list(local_recent), budgets, rng)
                    if not entry:
                        continue
                    asset_id = entry["asset_id"]
                hierarchy = {
                    "primary": "common", "secondary": "secondary",
                    "transition": "rare", "exceptional": "focal",
                }.get(entry.get("tier", tier), "common")
                decoration = {
                    "x": point[0], "y": point[1], "asset_id": asset_id,
                    "hierarchy": hierarchy, "blocking": False,
                    "placement_rule": pattern_name,
                    "group_id": f"F{plan.floor:03d}-G{group_index + 1:02d}",
                    "purpose": entry.get("purpose", "composition_support"),
                    "visual_zone": room.visual_role,
                    "reason": f"élément {'principal' if offset_index == 0 else 'secondaire'} du motif {pattern_name} dans une salle {room.function}",
                }
                plan.decorations.append(decoration)
                placements.append([point[0], point[1]])
                occupied.add(point)
                usage[asset_id] += 1
                local_recent.append(asset_id)
            if placements:
                group_index += 1
                group = {
                    "group_id": f"F{plan.floor:03d}-G{group_index:02d}",
                    "motif": pattern_name,
                    "room_id": room.room_id,
                    "anchor": list(anchor),
                    "rotation": rotation,
                    "mirrored": mirror,
                    "positions": placements,
                    "purpose": "surprise_controlee" if is_surprise else "point_fort" if room.visual_role == "focal" else "structuration_locale",
                    "reason": "variation rare mais issue du vocabulaire de transition" if is_surprise else "composition groupée pour éviter des placements indépendants et mécaniques",
                }
                plan.decoration_groups.append(group)
                recent_motifs.append(pattern_name)
                surprise_used = surprise_used or is_surprise

    # A landmark is a composition center, not a decoration dropped on its POI.
    for landmark in plan.landmarks:
        if landmark["asset_id"] == "structural_landmark":
            continue
        x, y = landmark["position"]
        # The visible marker is offset if the exact POI must remain clear.
        candidates = [(x - 2, y), (x + 2, y), (x, y - 2), (x, y + 2)]
        point = next((item for item in candidates if _safe(plan, item, occupied, critical, 1)), None)
        if point:
            group_index += 1
            decoration = {
                "x": point[0], "y": point[1], "asset_id": landmark["asset_id"],
                "hierarchy": "focal", "blocking": False,
                "placement_rule": "landmark_court", "group_id": f"F{plan.floor:03d}-G{group_index:02d}",
                "purpose": "orientation_et_point_fort", "visual_zone": "focal",
                "reason": "placé près du centre fonctionnel sans bloquer le point interactif",
            }
            plan.decorations.append(decoration)
            plan.decoration_groups.append({
                "group_id": decoration["group_id"], "motif": "landmark_court",
                "room_id": landmark["room_id"], "anchor": landmark["position"],
                "rotation": 0, "mirrored": False, "positions": [list(point)],
                "purpose": "landmark", "reason": landmark["reason"],
            })

    walkable = sum(tile != "wall" for tile in plan.tiles)
    actual_density = len(plan.decorations) / max(1, walkable)
    plan.identity.setdefault("composition", {})["negative_space_rooms"] = sorted(breathing_ids)
    plan.identity["composition"]["decoration_density_realized"] = round(actual_density, 4)
    plan.identity["composition"]["group_count"] = len(plan.decoration_groups)
    plan.decisions.append({
        "stage": "decoration",
        "decision": f"{len(plan.decoration_groups)} groupes, {len(plan.decorations)} éléments",
        "why": "densité différenciée par fonction; salles de respiration volontairement sobres",
        "negative_space_rooms": sorted(breathing_ids),
        "motifs": [group["motif"] for group in plan.decoration_groups],
    })
    return plan


def update_memory(memory: dict, plan: FloorPlan):
    memory = deepcopy(memory or initial_memory())
    usage = Counter(memory.get("asset_usage", {}))
    for decoration in plan.decorations:
        usage[decoration["asset_id"]] += 1
    memory["asset_usage"] = dict(sorted(usage.items()))
    for landmark in plan.landmarks:
        if landmark.get("rare"):
            memory.setdefault("focal_last_floor", {})[landmark["asset_id"]] = plan.floor
    recent_assets = memory.setdefault("recent_assets", [])
    recent_assets.extend(decoration["asset_id"] for decoration in plan.decorations[-8:])
    memory["recent_assets"] = recent_assets[-18:]
    recent_families = memory.setdefault("recent_families", [])
    recent_families.append(plan.identity.get("composition_family", plan.archetype))
    memory["recent_families"] = recent_families[-5:]
    recent_motifs = memory.setdefault("recent_motifs", [])
    recent_motifs.extend(group["motif"] for group in plan.decoration_groups[-3:])
    memory["recent_motifs"] = recent_motifs[-8:]
    memory.setdefault("floor_signatures", []).append(plan.identity.get("signature", {}))
    return memory
