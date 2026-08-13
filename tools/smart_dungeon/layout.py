#!/usr/bin/env python3
"""Human-oriented hierarchy, spatial strategies and explainable candidate search."""
from __future__ import annotations
import copy
import hashlib
import math
import random
from collections import deque
from .composition import compose_decor, initial_memory
from .model import DesignBrief, FloorPlan, Room
from .quality import evaluate


def stable_seed(*parts):
    return int.from_bytes(hashlib.sha256("|".join(map(str, parts)).encode()).digest()[:8], "little") & 0x7FFFFFFF


def _phase(index, count):
    progress = index / max(1, count - 1)
    return "introduction" if progress < .18 else "development" if progress < .48 else "escalation" if progress < .78 else "climax" if progress < .96 else "finale"


def schedule(brief: DesignBrief):
    count = brief.floors
    special = {}
    if brief.boss:
        special[count] = "boss"
    mini_floors = []
    for index in range(brief.mini_bosses):
        target = round(count * (index + 1) / (brief.mini_bosses + 1))
        target = max(3, min(count - 2, target + (1 if index % 2 else -1)))
        mini_floors.append(target)
        special[target] = "mini_boss"
    relay_floors = []
    anchors = [.22, .48, .73, .88]
    for index in range(brief.relays):
        target = round(count * anchors[index % len(anchors)]) + index // len(anchors)
        while target in special and target < count - 1:
            target += 1
        target = max(2, min(count - 1, target))
        relay_floors.append(target)
        special[target] = "relay"
    if brief.boss and "preboss_calm" in brief.constraints and count - 1 not in special:
        special[count - 1] = "calm"
    return special, mini_floors, relay_floors


DEFAULT_STRATEGIES = [
    "central_landmark", "dominant_loop", "branching_pockets", "asymmetric_gradient",
    "island_clusters", "chamber_sequence", "corridor_spine", "open_field",
    "circular_progression", "protected_core",
]

STRATEGY_COMPATIBILITY = {
    "open_field": ["island_clusters", "central_landmark", "asymmetric_gradient"],
    "island_clusters": ["branching_pockets", "open_field", "dominant_loop"],
    "central_landmark": ["protected_core", "circular_progression", "branching_pockets"],
    "protected_core": ["circular_progression", "dominant_loop", "central_landmark"],
    "circular_progression": ["dominant_loop", "protected_core", "central_landmark"],
    "dominant_loop": ["branching_pockets", "circular_progression", "corridor_spine"],
    "branching_pockets": ["asymmetric_gradient", "dominant_loop", "island_clusters"],
    "asymmetric_gradient": ["chamber_sequence", "branching_pockets", "corridor_spine"],
    "chamber_sequence": ["corridor_spine", "asymmetric_gradient", "open_field"],
    "corridor_spine": ["chamber_sequence", "dominant_loop", "asymmetric_gradient"],
}


def _choose_strategy(brief, floor, progress, preferences, recent):
    candidates = list(preferences or DEFAULT_STRATEGIES)
    if progress < .24 and brief.topology_start == "open":
        candidates = ["open_field", "island_clusters", "central_landmark"] + candidates
    if progress > .56 and brief.topology_end == "labyrinth":
        candidates = ["branching_pockets", "dominant_loop", "corridor_spine", "asymmetric_gradient"] + candidates
    if recent:
        bridges = STRATEGY_COMPATIBILITY.get(recent[-1], [])
        candidates = bridges + candidates
    deduplicated = []
    for item in candidates:
        if item not in deduplicated and item not in recent[-2:]:
            deduplicated.append(item)
    if not deduplicated:
        deduplicated = [item for item in DEFAULT_STRATEGIES if item != recent[-1]]
    return deduplicated[stable_seed(brief.intent, "strategy", floor) % len(deduplicated)]


def _signature(family, secondary, floor, spectacle, brief):
    geometry = {
        "central_landmark": "large_center_with_satellites",
        "protected_core": "guarded_center_and_outer_ring",
        "circular_progression": "ring_with_cross_connections",
        "dominant_loop": "one_memorable_main_loop",
        "branching_pockets": "spine_and_optional_pockets",
        "asymmetric_gradient": "scale_and_density_gradient",
        "island_clusters": "three_room_islands",
        "chamber_sequence": "succession_of_small_thresholds",
        "corridor_spine": "dominant_directional_spine",
        "open_field": "few_large_readable_spaces",
    }.get(family, family)
    landmark_rule = "exceptional_asset" if spectacle >= .68 else "structural_anchor" if spectacle >= .42 else "local_orientation_marker"
    density_gradient = (
        "quiet_to_dense" if family in ("asymmetric_gradient", "branching_pockets")
        else "quiet_edges_focal_center" if family in ("central_landmark", "protected_core")
        else "alternating"
    )
    return {
        "signature_id": f"F{floor:03d}-{family}-{stable_seed(brief.intent, floor) % 97:02d}",
        "geometry": geometry,
        "secondary_strategy": secondary,
        "density_gradient": density_gradient,
        "landmark_rule": landmark_rule,
        "intentional_symmetry": family in ("central_landmark", "protected_core") and spectacle >= .62,
    }


def progression(brief: DesignBrief, direction: dict | None = None):
    special, _, _ = schedule(brief)
    preferences = (direction or {}).get("strategy_preferences", DEFAULT_STRATEGIES)
    rows, recent = [], []
    for floor in range(1, brief.floors + 1):
        progress = (floor - 1) / max(1, brief.floors - 1)
        phase = _phase(floor - 1, brief.floors)
        event = special.get(floor)
        family = _choose_strategy(brief, floor, progress, preferences, recent)
        if event == "boss":
            family = "boss_stage"
        elif event == "mini_boss":
            family = "mini_boss_stage"
        elif event in ("relay", "calm"):
            family = "relay_haven"
        secondary_candidates = STRATEGY_COMPATIBILITY.get(recent[-1], preferences) if recent else preferences
        secondary = next((item for item in secondary_candidates if item != family), "asymmetric_gradient")

        complexity = .25 + .58 * progress
        density = brief.decoration_bias * (.70 + .34 * progress)
        danger = brief.danger_bias * (.70 + .5 * progress)
        spectacle = min(.64, .14 + progress * .43 + (stable_seed(brief.intent, "spectacle", floor) % 9) / 100)
        if event in ("relay", "calm"):
            complexity *= .62
            density *= .54
            danger *= .42
            spectacle = .18
        elif event == "mini_boss":
            complexity, density, danger, spectacle = .72, .34, min(1, danger + .22), .74
        elif event == "boss":
            complexity, density, danger, spectacle = .82, .28, 1, 1

        next_event = special.get(floor + 1)
        approach_to = next_event if next_event in ("boss", "mini_boss", "relay") else None
        if approach_to in ("boss", "mini_boss"):
            density *= .62
            complexity *= .82
            spectacle = min(spectacle, .42)
        rhythm = (
            ["orientation", "tension", "preparation", "climax"] if event in ("boss", "mini_boss")
            else ["tension", "discovery", "recovery", "orientation"] if event in ("relay", "calm")
            else ["orientation", "exploration", "discovery", "tension", "reward", "breathing"]
        )
        if approach_to:
            rhythm[-2:] = ["preparation", "threshold"]
        signature = _signature(family, secondary, floor, spectacle, brief)
        archetype = (
            "arena" if event in ("boss", "mini_boss") else "refuge" if event in ("relay", "calm")
            else "open" if family in ("open_field", "island_clusters")
            else "labyrinth" if family in ("corridor_spine", "chamber_sequence") and progress > .5
            else "central" if family in ("central_landmark", "protected_core")
            else "branching" if family in ("branching_pockets", "asymmetric_gradient")
            else "loops"
        )
        row = {
            "floor": floor,
            "phase": phase,
            "act": 1 + min(3, int(progress * 4)),
            "vocabulary_priority": "exceptional" if event == "boss" else "secondary" if progress >= .25 else "primary",
            "special": event,
            "archetype": archetype,
            "composition_family": family,
            "secondary_strategy": secondary,
            "signature": signature,
            "complexity": round(complexity, 3),
            "decoration_density": round(min(1, density), 3),
            "danger": round(min(1, danger), 3),
            "spectacle": round(spectacle, 3),
            "mood": brief.mood_start if progress < .35 else brief.mood_end if progress > .7 else "transition",
            "spatial_rhythm": rhythm,
            "approach_to": approach_to,
            "surprise_budget": round(brief.surprise_budget * (.7 + progress * .6), 3),
            "visual_role": "focal" if event in ("boss", "mini_boss") else "breathing" if event in ("relay", "calm") else "support",
            "decision_reason": f"{family} traduit l'acte {phase}, la topologie {brief.topology_start}→{brief.topology_end} et évite les deux familles récentes",
        }
        rows.append(row)
        recent.append(family)
    return rows


def _overlap(a, b, padding=2):
    return not (
        a[0] + a[2] + padding <= b[0] or b[0] + b[2] + padding <= a[0]
        or a[1] + a[3] + padding <= b[1] or b[1] + b[3] + padding <= a[1]
    )


def _shape(kind, width, height, rng):
    cells = [[1] * width for _ in range(height)]
    if kind == "irregular" and width > 5 and height > 5:
        for _ in range(max(1, (width + height) // 5)):
            corner = rng.randrange(4)
            cw, ch = rng.randint(1, max(1, width // 3)), rng.randint(1, max(1, height // 3))
            xs = range(cw) if corner % 2 == 0 else range(width - cw, width)
            ys = range(ch) if corner < 2 else range(height - ch, height)
            for y in ys:
                for x in xs:
                    cells[y][x] = 0
    elif kind in ("round", "diamond", "octagon"):
        cx, cy = (width - 1) / 2, (height - 1) / 2
        for y in range(height):
            for x in range(width):
                if kind == "diamond":
                    cells[y][x] = int(abs(x - cx) / max(1, width / 2) + abs(y - cy) / max(1, height / 2) <= 1.05)
                else:
                    cells[y][x] = int(((x - cx) / (width / 2)) ** 2 + ((y - cy) / (height / 2)) ** 2 <= (1.18 if kind == "octagon" else 1.05))
    elif kind in ("cross", "t_shape", "l_shape") and width > 6 and height > 6:
        for y in range(height):
            for x in range(width):
                if kind == "cross":
                    value = abs(x - width // 2) <= max(1, width // 4) or abs(y - height // 2) <= max(1, height // 4)
                elif kind == "t_shape":
                    value = y <= max(2, height // 3) or abs(x - width // 2) <= max(1, width // 4)
                else:
                    value = x <= max(2, width // 3) or y >= height - max(3, height // 3)
                cells[y][x] = int(value)
    return cells


def _carve_room(plan, room):
    for ry, row in enumerate(room.cells):
        for rx, value in enumerate(row):
            if value and 0 < room.x + rx < plan.width - 1 and 0 < room.y + ry < plan.height - 1:
                plan.set(room.x + rx, room.y + ry, "room")


def _center(room):
    cx, cy = room.width // 2, room.height // 2
    valid = [
        (room.x + x, room.y + y)
        for y, row in enumerate(room.cells) for x, value in enumerate(row) if value
    ]
    return list(min(valid, key=lambda point: abs(point[0] - (room.x + cx)) + abs(point[1] - (room.y + cy)))) if valid else [room.x + cx, room.y + cy]


def _corridor(plan, start, end, rng):
    ax, ay = start
    bx, by = end
    points = [(ax, ay)]
    if rng.random() < .5:
        bend = max(1, min(plan.width - 2, round((ax + bx) / 2) + rng.randint(-3, 3)))
        points += [(bend, ay), (bend, by), (bx, by)]
    else:
        bend = max(1, min(plan.height - 2, round((ay + by) / 2) + rng.randint(-3, 3)))
        points += [(ax, bend), (bx, bend), (bx, by)]
    for (x1, y1), (x2, y2) in zip(points, points[1:]):
        x, y = x1, y1
        dx = 1 if x2 > x else -1 if x2 < x else 0
        dy = 1 if y2 > y else -1 if y2 < y else 0
        while (x, y) != (x2, y2):
            if plan.get(x, y) == "wall":
                plan.set(x, y, "corridor")
            x += dx
            y += dy
        if plan.get(x, y) == "wall":
            plan.set(x, y, "corridor")


def _mst(rooms):
    if len(rooms) < 2:
        return []
    centers = {room.room_id: _center(room) for room in rooms}
    pairs = sorted(
        (math.dist(centers[a.room_id], centers[b.room_id]), a.room_id, b.room_id)
        for index, a in enumerate(rooms) for b in rooms[index + 1:]
    )
    parent = {room.room_id: room.room_id for room in rooms}

    def find(item):
        while parent[item] != item:
            parent[item] = parent[parent[item]]
            item = parent[item]
        return item

    edges = []
    for _, left, right in pairs:
        root_left, root_right = find(left), find(right)
        if root_left != root_right:
            parent[root_left] = root_right
            edges.append([left, right])
    return edges


def _add_edge(edges, left, right):
    if left == right:
        return
    pair = tuple(sorted((left, right)))
    if pair not in {tuple(sorted(edge)) for edge in edges}:
        edges.append([left, right])


def _strategy_graph(rooms, family, complexity, rng, special=None):
    focus = rooms[0] if special in ("boss", "mini_boss") else None
    graph_rooms = rooms[1:] if focus else rooms
    edges = _mst(graph_rooms)
    by_x = sorted(graph_rooms, key=lambda room: (_center(room)[0], _center(room)[1]))
    if family in ("corridor_spine", "chamber_sequence", "branching_pockets"):
        for left, right in zip(by_x, by_x[1:]):
            _add_edge(edges, left.room_id, right.room_id)
    if family in ("circular_progression", "dominant_loop", "protected_core") and len(graph_rooms) > 3:
        cx = mean_point([_center(room) for room in graph_rooms])
        ring = sorted(graph_rooms, key=lambda room: math.atan2(_center(room)[1] - cx[1], _center(room)[0] - cx[0]))
        for left, right in zip(ring, ring[1:] + ring[:1]):
            _add_edge(edges, left.room_id, right.room_id)
    if family in ("central_landmark", "protected_core") and graph_rooms:
        center_room = min(graph_rooms, key=lambda room: math.dist(_center(room), mean_point([_center(item) for item in graph_rooms])))
        for other in sorted((room for room in graph_rooms if room != center_room), key=lambda room: math.dist(_center(room), _center(center_room)))[:3]:
            _add_edge(edges, center_room.room_id, other.room_id)
    desired_extra = max(0, round(len(graph_rooms) * (.10 + complexity * .24)))
    all_pairs = [(math.dist(_center(a), _center(b)), a, b) for index, a in enumerate(graph_rooms) for b in graph_rooms[index + 1:]]
    rng.shuffle(all_pairs)
    for _, left, right in sorted(all_pairs, key=lambda row: row[0]):
        before = len(edges)
        _add_edge(edges, left.room_id, right.room_id)
        desired_extra -= len(edges) - before
        if desired_extra <= 0:
            break
    if focus:
        approach = rooms[1]
        _add_edge(edges, focus.room_id, approach.room_id)
        if len(graph_rooms) > 1 and not any(approach.room_id in edge and focus.room_id not in edge for edge in edges):
            _add_edge(edges, approach.room_id, rooms[2].room_id)
    return edges


def mean_point(points):
    return [sum(point[0] for point in points) / max(1, len(points)), sum(point[1] for point in points) / max(1, len(points))]


def _targets(family, count):
    if family in ("boss_stage", "mini_boss_stage"):
        base = [(0.78, .50), (.52, .50), (.18, .50)]
        return base + [(0.30 + (index % 2) * .18, .20 + (index // 2) * .58) for index in range(count - 3)]
    if family == "relay_haven":
        base = [(0.56, .5), (.32, .28), (.24, .72), (.78, .34), (.80, .70)]
        return (base * 2)[:count]
    if family in ("central_landmark", "protected_core"):
        base = [(0.50, .50)]
        for index in range(count - 1):
            angle = 2 * math.pi * index / max(1, count - 1)
            base.append((.5 + .36 * math.cos(angle), .5 + .34 * math.sin(angle)))
        return base
    if family in ("circular_progression", "dominant_loop"):
        return [(.5 + .38 * math.cos(2 * math.pi * index / count), .5 + .36 * math.sin(2 * math.pi * index / count)) for index in range(count)]
    if family in ("corridor_spine", "chamber_sequence"):
        return [(.10 + .80 * index / max(1, count - 1), .35 + .28 * (index % 2)) for index in range(count)]
    if family == "island_clusters":
        centers = [(.22, .32), (.55, .68), (.82, .28)]
        return [(centers[index % 3][0] + ((index // 3) % 2) * .08, centers[index % 3][1] + ((index // 6) % 2) * .10) for index in range(count)]
    if family == "asymmetric_gradient":
        return [(.12 + .76 * index / max(1, count - 1), .18 + .62 * ((index * 3) % count) / max(1, count - 1)) for index in range(count)]
    if family == "branching_pockets":
        return [(.12 + .72 * (index // 3) / max(1, math.ceil(count / 3) - 1), [.5, .22, .78][index % 3]) for index in range(count)]
    # open field: sparse, large readable spaces.
    grid = [(x, y) for y in (.25, .72) for x in (.16, .43, .72, .88)]
    return grid[:count] + [(random.Random(index).random(), random.Random(index + 1).random()) for index in range(max(0, count - len(grid)))]


def _room_specifications(row, count, rng):
    family, special = row["composition_family"], row["special"]
    specs = []
    if special in ("boss", "mini_boss"):
        size = (22, 18) if special == "boss" else (18, 15)
        specs = [
            {"size": size, "kind": "round", "function": "climax", "role": "focal", "importance": 1.0, "tags": ["stage", "landmark"]},
            {"size": (12, 8), "kind": "rect", "function": "preparation", "role": "transition", "importance": .62, "tags": ["approach"]},
            {"size": (8, 7), "kind": "rect", "function": "gateway", "role": "neutral", "importance": .35, "tags": ["orientation"]},
        ]
    elif special in ("relay", "calm"):
        specs = [
            {"size": (14, 12), "kind": "octagon", "function": "recovery", "role": "focal", "importance": .9, "tags": ["refuge", "landmark"]},
            {"size": (8, 7), "kind": "irregular", "function": "tension", "role": "support", "importance": .35, "tags": ["approach"]},
            {"size": (9, 7), "kind": "rect", "function": "orientation", "role": "neutral", "importance": .32, "tags": []},
        ]
    elif family in ("central_landmark", "protected_core"):
        specs = [{"size": (18, 14), "kind": "octagon", "function": "orientation", "role": "focal", "importance": .88, "tags": ["landmark"]}]
    elif family == "open_field":
        specs = [{"size": (18, 13), "kind": "irregular", "function": "discovery", "role": "focal", "importance": .75, "tags": ["open_space"]}]

    functions = ["gateway", "exploration", "tension", "discovery", "breathing", "reward", "orientation"]
    shapes = ["rect", "irregular", "round", "cross", "diamond", "t_shape", "l_shape"]
    while len(specs) < count:
        index = len(specs)
        if family == "chamber_sequence":
            width, height = rng.randint(6, 9), rng.randint(5, 8)
        elif family == "open_field":
            width, height = rng.randint(11, 17), rng.randint(9, 13)
        elif family == "asymmetric_gradient":
            scale = .65 + .65 * index / max(1, count - 1)
            width, height = round(rng.randint(7, 12) * scale), round(rng.randint(6, 10) * scale)
        else:
            scale = 1.35 if rng.random() < .18 else .72 if rng.random() < .22 else 1
            width, height = round(rng.randint(6, 12) * scale), round(rng.randint(5, 10) * scale)
        function = functions[index % len(functions)]
        role = "support" if function in ("tension", "discovery", "reward") else "neutral"
        specs.append({
            "size": (max(5, width), max(5, height)),
            "kind": rng.choice(shapes if row["complexity"] > .42 else shapes[:3]),
            "function": function,
            "role": role,
            "importance": .55 if function in ("discovery", "reward") else .28,
            "tags": [function] if function != "exploration" else [],
        })
    return specs


def _place_rooms(plan, row, rng, count):
    specs = _room_specifications(row, count, rng)
    targets = _targets(row["composition_family"], count)
    rectangles = []
    for index, (spec, target) in enumerate(zip(specs, targets)):
        width, height = spec["size"]
        width = min(width, plan.width - 6)
        height = min(height, plan.height - 6)
        preferred_x = round(target[0] * plan.width - width / 2)
        preferred_y = round(target[1] * plan.height - height / 2)
        placed = None
        for attempt in range(120):
            radius = 1 + attempt // 12
            x = max(2, min(plan.width - width - 3, preferred_x + rng.randint(-radius, radius)))
            y = max(2, min(plan.height - height - 3, preferred_y + rng.randint(-radius, radius)))
            rectangle = (x, y, width, height)
            if not any(_overlap(rectangle, other, 1) for other in rectangles):
                placed = rectangle
                break
        if not placed:
            for _ in range(100):
                x = rng.randint(2, max(2, plan.width - width - 3))
                y = rng.randint(2, max(2, plan.height - height - 3))
                rectangle = (x, y, width, height)
                if not any(_overlap(rectangle, other, 1) for other in rectangles):
                    placed = rectangle
                    break
        if not placed:
            continue
        x, y, width, height = placed
        rectangles.append(placed)
        plan.rooms.append(Room(
            room_id=len(plan.rooms), kind=spec["kind"], x=x, y=y, width=width, height=height,
            cells=_shape(spec["kind"], width, height, rng), importance=spec["importance"],
            tags=spec["tags"], function=spec["function"], visual_role=spec["role"],
            design_reason=f"géométrie {spec['kind']} dimensionnée pour la fonction {spec['function']} dans la stratégie {row['composition_family']}",
        ))


def _room_for_point(plan, point):
    containing = [room for room in plan.rooms if room.x <= point[0] < room.x + room.width and room.y <= point[1] < room.y + room.height]
    return containing[0] if containing else min(plan.rooms, key=lambda room: math.dist(_center(room), point))


def _path_rooms(plan, start_id, end_id):
    graph = {room.room_id: [] for room in plan.rooms}
    for left, right in plan.edges:
        graph[left].append(right)
        graph[right].append(left)
    queue = deque([start_id])
    previous = {start_id: None}
    while queue:
        current = queue.popleft()
        if current == end_id:
            break
        for neighbor in graph[current]:
            if neighbor not in previous:
                previous[neighbor] = current
                queue.append(neighbor)
    if end_id not in previous:
        return [start_id]
    result, current = [], end_id
    while current is not None:
        result.append(current)
        current = previous[current]
    return list(reversed(result))


def _annotate_composition(plan, row, brief):
    # Regions are ordered along the dominant horizontal progression and overlap
    # semantically through transition rooms, not through abrupt asset swaps.
    ordered = sorted(plan.rooms, key=lambda room: _center(room)[0])
    thirds = [ordered[:max(1, len(ordered) // 3)], ordered[max(1, len(ordered) // 3):max(2, 2 * len(ordered) // 3)], ordered[max(2, 2 * len(ordered) // 3):]]
    roles = ["neutral", "transition", "support"]
    plan.composition_regions = []
    for index, rooms in enumerate(thirds):
        if not rooms:
            continue
        if any(room.visual_role == "focal" for room in rooms):
            role = "focal"
        else:
            role = roles[index]
        plan.composition_regions.append({
            "region_id": f"F{plan.floor:03d}-R{index + 1}", "order": index,
            "room_ids": [room.room_id for room in rooms], "visual_role": role,
            "density_intent": "low" if role in ("neutral", "transition") else "high" if role == "focal" else "medium",
            "bridge_rule": "shared_primary_assets_plus_density_gradient" if index else "principal_vocabulary",
            "reason": "transition par densité et vocabulaire commun, sans rupture totale d'assets",
        })
        for room in rooms:
            if room.visual_role not in ("focal",):
                room.visual_role = role

    entrance_room = _room_for_point(plan, plan.entrance)
    exit_room = _room_for_point(plan, plan.exit)
    path = _path_rooms(plan, entrance_room.room_id, exit_room.room_id)
    beat_map = {
        "gateway": "orientation", "exploration": "exploration", "tension": "tension",
        "discovery": "discovery", "breathing": "breathing", "reward": "reward",
        "orientation": "orientation", "preparation": "preparation", "climax": "climax",
        "recovery": "recovery", "transition": "threshold",
    }
    plan.spatial_beats = [
        {
            "order": index, "room_id": room_id,
            "beat": beat_map.get(next(room for room in plan.rooms if room.room_id == room_id).function, "exploration"),
            "reason": next(room for room in plan.rooms if room.room_id == room_id).design_reason,
        }
        for index, room_id in enumerate(path)
    ]
    plan.identity = {
        "composition_family": row["composition_family"],
        "secondary_strategy": row["secondary_strategy"],
        "signature": copy.deepcopy(row["signature"]),
        "spectacle": row["spectacle"],
        "surprise_budget": row["surprise_budget"],
        "approach_to": row["approach_to"],
        "spatial_rhythm_intent": row["spatial_rhythm"],
        "selection_reason": row["decision_reason"],
        "mood": row["mood"],
        "phase": row["phase"],
    }
    plan.decisions.extend([
        {"stage": "floor_identity", "decision": row["composition_family"], "why": row["decision_reason"], "signature": row["signature"]},
        {"stage": "spatial_rhythm", "decision": [beat["beat"] for beat in plan.spatial_beats], "why": "ordre réel des salles sur le chemin principal"},
        {"stage": "special_approach", "decision": row["approach_to"], "why": "densité et circulation simplifiées avant l'événement"} if row["approach_to"] else {"stage": "spatial_transition", "decision": row["secondary_strategy"], "why": "stratégie secondaire compatible pour éviter une rupture brutale"},
    ])


def _normalize_direction(asset_roles, direction):
    if direction:
        return direction
    return {"roles": asset_roles or {}, "runtime_selection": {"roles": asset_roles or {}}, "asset_budgets": {}}


def make_candidate(brief, row, seed, asset_roles, locked=None, direction=None, memory=None):
    rng = random.Random(seed)
    family, special = row.get("composition_family", row["archetype"]), row["special"]
    width, height = 56 + rng.randrange(-3, 8), 42 + rng.randrange(-3, 7)
    if family in ("open_field", "island_clusters"):
        width, height = width + 8, height + 5
    if special in ("boss", "mini_boss"):
        width, height = 58, 42
    plan = FloorPlan(
        row["floor"], seed, width, height, row["archetype"], row["phase"], special,
        brief.theme_tokens[(row["floor"] - 1) % len(brief.theme_tokens)] if brief.theme_tokens else "principal",
        [], [], ["wall"] * (width * height), [2, height // 2], [width - 3, height // 2],
    )
    count = 7 + round(row["complexity"] * 8)
    if special in ("boss", "mini_boss"):
        count = 7
    elif special in ("relay", "calm"):
        count = 7
    elif family == "open_field":
        count = max(7, count - 2)
    _place_rooms(plan, row, rng, count)
    if len(plan.rooms) < 4:
        return make_candidate(brief, row, seed + 991, asset_roles, locked, direction, memory)
    for room in plan.rooms:
        _carve_room(plan, room)
    plan.edges = _strategy_graph(plan.rooms, family, row["complexity"], rng, special)
    by_id = {room.room_id: room for room in plan.rooms}
    for left, right in plan.edges:
        _corridor(plan, _center(by_id[left]), _center(by_id[right]), rng)
        by_id[left].entrances.append(_center(by_id[right]))
        by_id[right].entrances.append(_center(by_id[left]))

    centers = [_center(room) for room in plan.rooms]
    gateway_rooms = [room for room in plan.rooms if room.function == "gateway"]
    entrance_room = min(gateway_rooms or plan.rooms, key=lambda room: _center(room)[0])
    plan.entrance = _center(entrance_room)
    if special in ("boss", "mini_boss"):
        exit_room = plan.rooms[0]
    else:
        exit_room = max(plan.rooms, key=lambda room: abs(_center(room)[0] - plan.entrance[0]) + abs(_center(room)[1] - plan.entrance[1]))
    plan.exit = _center(exit_room)
    if special:
        plan.points_of_interest.append({"kind": special, "position": _center(plan.rooms[0]), "importance": 1.0, "locked": False})
    elif "central_landmark" in brief.constraints:
        landmark_room = max(plan.rooms, key=lambda room: room.importance)
        plan.points_of_interest.append({"kind": "landmark", "position": _center(landmark_room), "importance": .85, "locked": False})

    _annotate_composition(plan, row, brief)
    normalized_direction = _normalize_direction(asset_roles, direction)
    plan.identity["palette"] = copy.deepcopy(normalized_direction.get("palette", [[112, 118, 104]]))
    plan.identity["art_direction_id"] = normalized_direction.get("identity_id")
    compose_decor(plan, rng, normalized_direction, row, memory or initial_memory())
    return plan


def _connect_components(plan, rng):
    walkable = {(x, y) for y in range(plan.height) for x in range(plan.width) if plan.get(x, y) != "wall"}
    components = []
    while walkable:
        start = next(iter(walkable))
        seen = {start}
        queue = deque([start])
        while queue:
            x, y = queue.popleft()
            for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if point in walkable and point not in seen:
                    seen.add(point)
                    queue.append(point)
        components.append(seen)
        walkable -= seen
    if len(components) > 1:
        left = min(components[0], key=lambda point: math.dist(point, next(iter(components[1]))))
        right = min(components[1], key=lambda point: math.dist(point, left))
        _corridor(plan, left, right, rng)


def repair(plan, report, rng, direction=None, row=None, memory=None):
    for violation in sorted(report["violations"], key=lambda item: item["severity"], reverse=True):
        action = violation["repair"]
        detail = {"layer": violation.get("layer", "structural")}
        if action == "connect_components":
            _connect_components(plan, rng)
        elif action == "add_loop" and len(plan.rooms) > 3:
            existing = {tuple(sorted(edge)) for edge in plan.edges}
            pairs = [
                (math.dist(_center(left), _center(right)), left, right)
                for left in plan.rooms for right in plan.rooms
                if left.room_id < right.room_id and (left.room_id, right.room_id) not in existing
            ]
            if pairs:
                _, left, right = min(pairs)
                plan.edges.append([left.room_id, right.room_id])
                _corridor(plan, _center(left), _center(right), rng)
                detail["rooms"] = [left.room_id, right.room_id]
        elif action in ("break_corridor", "asymmetric_alcove"):
            candidates = [(x, y) for y in range(3, plan.height - 4) for x in range(3, plan.width - 4) if plan.get(x, y) == "corridor"]
            if candidates:
                x, y = rng.choice(candidates)
                side = rng.choice((-1, 1))
                x0, x1 = (x + 1, x + 4) if side > 0 else (x - 3, x)
                for yy in range(max(1, y - 2), min(plan.height - 1, y + 3)):
                    for xx in range(max(1, x0), min(plan.width - 1, x1)):
                        plan.set(xx, yy, "room")
                detail["origin"] = [x, y]
        elif action == "reshape_room" and plan.rooms:
            candidates = [room for room in plan.rooms if not room.locked]
            if candidates:
                room = rng.choice(candidates)
                for y in range(max(1, room.y - 1), min(plan.height - 1, room.y + room.height + 1)):
                    for x in range(max(1, room.x - 1), min(plan.width - 1, room.x + room.width + 1)):
                        if rng.random() < .6:
                            plan.set(x, y, "room")
                detail["room"] = room.room_id
        elif action == "clear_critical":
            critical = {tuple(plan.entrance), tuple(plan.exit)} | {tuple(point["position"]) for point in plan.points_of_interest}
            plan.decorations = [row for row in plan.decorations if (row["x"], row["y"]) not in critical]
        elif action in ("regroup_decor", "vary_motifs", "reduce_asset_repetition", "create_breathing_space") and row is not None:
            compose_decor(plan, rng, direction or {}, row, memory or initial_memory())
            detail["scope"] = "decoration_composition"
        elif action == "strengthen_landmark" and plan.rooms:
            room = max(plan.rooms, key=lambda item: item.importance)
            room.visual_role = "focal"
            room.importance = max(.82, room.importance)
            plan.landmarks = []
            compose_decor(plan, rng, direction or {}, row or {"decoration_density": .45}, memory or initial_memory())
            detail["room"] = room.room_id
        elif action == "reinforce_signature":
            plan.identity.setdefault("signature", {"geometry": plan.archetype, "landmark_rule": "structural_anchor"})
            plan.identity.setdefault("selection_reason", "signature renforcée après validation artistique")
        elif action == "reinforce_rhythm":
            plan.spatial_beats = [
                {"order": index, "room_id": room.room_id, "beat": ["orientation", "exploration", "tension", "reward", "breathing"][index % 5], "reason": room.design_reason}
                for index, room in enumerate(plan.rooms[:6])
            ]
        elif action == "clear_focal_noise":
            focal_seen = False
            for decoration in plan.decorations:
                if decoration.get("hierarchy") == "focal":
                    if focal_seen:
                        decoration["hierarchy"] = "secondary"
                    focal_seen = True
        elif action == "reduce_rare_assets":
            for decoration in plan.decorations:
                if decoration.get("hierarchy") == "rare" and rng.random() < .7:
                    decoration["hierarchy"] = "secondary"
        plan.repair_log.append({"violation": violation["code"], "action": action, "localized": True, **detail})
    return plan


def _novelty(plan, memory):
    recent = (memory or {}).get("recent_families", [])
    family = plan.identity.get("composition_family", plan.archetype)
    family_score = 0 if recent and family == recent[-1] else .5 if family in recent[-3:] else 1
    recent_assets = set((memory or {}).get("recent_assets", []))
    assets = {decoration["asset_id"] for decoration in plan.decorations}
    asset_score = 1 - len(assets & recent_assets) / max(1, len(assets | recent_assets))
    return round(family_score * .55 + asset_score * .45, 4)


def select_best(brief, row, base_seed, asset_roles, variants=6, repairs=8, locks=None, direction=None, memory=None):
    results = []
    for variant_index in range(variants):
        seed = stable_seed(base_seed, row["floor"], variant_index)
        plan = make_candidate(brief, row, seed, asset_roles, locks, direction, memory)
        report = evaluate(plan)
        for repair_index in range(repairs):
            if report["accepted"]:
                break
            plan = repair(
                plan, report, random.Random(stable_seed(seed, "repair", repair_index)),
                direction, row, memory,
            )
            report = evaluate(plan)
        plan.quality = report
        plan.visual_quality = report["artistic"]
        plan.identity["novelty_against_memory"] = _novelty(plan, memory or {})
        results.append(plan)

    def selection_key(plan):
        quality = plan.quality
        identity = quality["artistic"]["metrics"].get("identity_strength", 0)
        novelty = plan.identity.get("novelty_against_memory", 0)
        bottleneck = min(quality["structural_score"], quality["visual_score"])
        return (quality["accepted"], bottleneck, identity, novelty, quality["score"])

    selected = max(results, key=selection_key)
    selected.identity["variant_selection"] = {
        "policy": "admissibility_then_bottleneck_then_identity_then_novelty_then_aggregate",
        "why": "une excellente structure ne peut pas masquer une composition visuelle faible",
        "selected_key": list(selection_key(selected)),
    }
    comparisons = []
    for plan in results:
        comparisons.append({
            "seed": plan.seed,
            "score": plan.quality["score"],
            "structural_score": plan.quality["structural_score"],
            "visual_score": plan.quality["visual_score"],
            "bottleneck": min(plan.quality["structural_score"], plan.quality["visual_score"]),
            "identity_strength": plan.quality["artistic"]["metrics"].get("identity_strength", 0),
            "novelty": plan.identity.get("novelty_against_memory", 0),
            "accepted": plan.quality["accepted"],
            "selected": plan is selected,
            "violations": [violation["code"] for violation in plan.quality["violations"]],
        })
    return selected, comparisons


# Backward-compatible name used by local decoration regeneration.
def _decorate(plan, rng, assets, density, direction=None, row=None, memory=None):
    row = row or {
        "floor": plan.floor,
        "decoration_density": density,
        "surprise_budget": plan.identity.get("surprise_budget", .08),
        "composition_family": plan.identity.get("composition_family", plan.archetype),
    }
    return compose_decor(plan, rng, direction or {"roles": assets}, row, memory or initial_memory())
