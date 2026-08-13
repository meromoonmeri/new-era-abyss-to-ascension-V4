#!/usr/bin/env python3
"""Art-direction-aware, dependency-free SVG review output."""
from __future__ import annotations
import html
import math
from collections import defaultdict
from pathlib import Path
from typing import Any
from .art_direction import build_art_direction
from .model import DesignBrief, FloorPlan


def select_visual_language(catalog: dict[str, Any], brief: DesignBrief, overrides: dict | None = None):
    """Backward-compatible Phase 1 API backed by the Phase 2 art director."""
    return build_art_direction(catalog, brief, overrides)["runtime_selection"]


def _rgb(rgb, factor=1):
    values = [max(0, min(255, round(value * factor))) for value in (rgb or [96, 96, 96])]
    return "#" + "".join(f"{value:02x}" for value in values)


def _room_region_map(plan):
    result = {}
    for region in plan.composition_regions:
        for room_id in region.get("room_ids", []):
            result[room_id] = region.get("visual_role", "neutral")
    return result


def svg_preview(plan: FloorPlan, path: Path, cell: int = 9):
    palette = plan.identity.get("palette", [[112, 118, 104], [160, 145, 110], [190, 120, 95]])
    while len(palette) < 3:
        palette.append(palette[-1] if palette else [96, 96, 96])
    room_colors = {
        "neutral": _rgb(palette[0], .72),
        "support": _rgb(palette[min(1, len(palette) - 1)], .86),
        "transition": _rgb(palette[0], .9),
        "focal": _rgb(palette[min(2, len(palette) - 1)], 1.05),
    }
    base_colors = {"wall": "#171a20", "corridor": "#a49a7d", "secret": "#4f5360"}
    width, height = plan.width * cell, plan.height * cell
    room_roles = _room_region_map(plan)
    tile_roles = {}
    for room in plan.rooms:
        role = room_roles.get(room.room_id, room.visual_role)
        for y in range(room.y, room.y + room.height):
            for x in range(room.x, room.x + room.width):
                if 0 <= x < plan.width and 0 <= y < plan.height and plan.get(x, y) == "room":
                    tile_roles[(x, y)] = role
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#101217"/>',
    ]
    for y in range(plan.height):
        for x in range(plan.width):
            tile = plan.get(x, y)
            color = room_colors.get(tile_roles.get((x, y), "neutral"), room_colors["neutral"]) if tile == "room" else base_colors.get(tile, "#777")
            parts.append(f'<rect x="{x * cell}" y="{y * cell}" width="{cell}" height="{cell}" fill="{color}"/>')
    # Group links reveal composition rather than isolated random dots.
    for group in plan.decoration_groups:
        points = group.get("positions", [])
        if len(points) > 1:
            coords = " ".join(f"{(x + .5) * cell},{(y + .5) * cell}" for x, y in points)
            parts.append(f'<polyline points="{coords}" fill="none" stroke="#e9e1c7" stroke-width="{max(1, cell * .10)}" opacity=".25"/>')
    for decoration in plan.decorations:
        color = {"common": "#6b9b58", "secondary": "#72a5ad", "rare": "#c28bc9", "focal": "#f1c75b"}.get(decoration["hierarchy"], "#fff")
        radius = cell * (.34 if decoration["hierarchy"] == "focal" else .24)
        parts.append(
            f'<circle cx="{(decoration["x"] + .5) * cell}" cy="{(decoration["y"] + .5) * cell}" r="{radius}" fill="{color}" opacity=".9">'
            f'<title>{html.escape(decoration["asset_id"])} — {html.escape(decoration.get("reason", ""))}</title></circle>'
        )
    for landmark in plan.landmarks:
        x, y = landmark["position"]
        parts.append(
            f'<circle cx="{(x + .5) * cell}" cy="{(y + .5) * cell}" r="{cell * .7}" fill="none" stroke="#ffd45e" stroke-width="{max(2, cell * .2)}">'
            f'<title>Landmark: {html.escape(landmark["asset_id"])}</title></circle>'
        )
    for point, color, label in [(plan.entrance, "#56d3ff", "Entrée"), (plan.exit, "#ffef68", "Escalier")]:
        parts.append(f'<rect x="{point[0] * cell + 1}" y="{point[1] * cell + 1}" width="{cell - 2}" height="{cell - 2}" fill="{color}"><title>{label}</title></rect>')
    for point in plan.points_of_interest:
        x, y = point["position"]
        parts.append(f'<polygon points="{(x + .5) * cell},{y * cell} {(x + 1) * cell},{(y + 1) * cell} {x * cell},{(y + 1) * cell}" fill="#ff685f"><title>{html.escape(point["kind"])}</title></polygon>')
    structural = plan.quality.get("structural_score", 0)
    visual = plan.quality.get("visual_score", 0)
    family = plan.identity.get("composition_family", plan.archetype)
    parts.append(f'<rect x="4" y="4" width="{min(width - 8, 390)}" height="35" rx="4" fill="#101217" opacity=".84"/>')
    parts.append(f'<text x="9" y="18" fill="white" font-family="sans-serif" font-size="12">Étage {plan.floor} — {html.escape(family)}</text>')
    parts.append(f'<text x="9" y="33" fill="#c7cfdb" font-family="sans-serif" font-size="10">structure {structural:.1f} · visuel {visual:.1f} · spectacle {plan.identity.get("spectacle", 0):.2f}</text>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts), encoding="utf-8")


def contact_svg(plans: list[FloorPlan], path: Path):
    thumb_width, thumb_height, columns = 265, 205, 4
    rows = math.ceil(len(plans) / columns)
    parts = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{columns * thumb_width}" height="{rows * thumb_height}" viewBox="0 0 {columns * thumb_width} {rows * thumb_height}"><rect width="100%" height="100%" fill="#11141a"/>']
    for index, plan in enumerate(plans):
        offset_x, offset_y = (index % columns) * thumb_width, (index // columns) * thumb_height
        scale = min((thumb_width - 12) / plan.width, (thumb_height - 42) / plan.height)
        roles = _room_region_map(plan)
        room_lookup = {}
        for room in plan.rooms:
            for y in range(room.y, room.y + room.height):
                for x in range(room.x, room.x + room.width):
                    room_lookup[(x, y)] = roles.get(room.room_id, room.visual_role)
        role_colors = {"neutral": "#56625a", "transition": "#727966", "support": "#8a7d63", "focal": "#a76153"}
        for y in range(plan.height):
            for x in range(plan.width):
                if plan.get(x, y) != "wall":
                    color = "#a99d7f" if plan.get(x, y) == "corridor" else role_colors.get(room_lookup.get((x, y), "neutral"), "#788171")
                    parts.append(f'<rect x="{offset_x + 6 + x * scale:.2f}" y="{offset_y + 36 + y * scale:.2f}" width="{scale + .2:.2f}" height="{scale + .2:.2f}" fill="{color}"/>')
        family = plan.identity.get("composition_family", plan.archetype)
        parts.append(f'<text x="{offset_x + 6}" y="{offset_y + 14}" fill="white" font-family="sans-serif" font-size="11">{plan.floor:02d} {html.escape(family)}</text>')
        parts.append(f'<text x="{offset_x + 6}" y="{offset_y + 28}" fill="#aeb8c6" font-family="sans-serif" font-size="9">S {plan.quality.get("structural_score", 0):.1f} · V {plan.quality.get("visual_score", 0):.1f} · spectacle {plan.identity.get("spectacle", 0):.2f}</text>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts), encoding="utf-8")


def design_board_svg(plans: list[FloorPlan], direction: dict, path: Path):
    width, height = 1180, 520
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#11141a"/>',
        '<text x="22" y="31" fill="#f3f0df" font-family="sans-serif" font-weight="bold" font-size="20">Direction artistique et rythme du donjon</text>',
        f'<text x="22" y="52" fill="#aeb8c6" font-family="sans-serif" font-size="11">{html.escape(direction.get("identity_id", "direction inconnue"))}</text>',
    ]
    x = 22
    for tier, label in [("primary", "PRINCIPAL"), ("secondary", "SECONDAIRE"), ("transition", "TRANSITION"), ("exceptional", "EXCEPTIONNEL")]:
        rows = direction.get("vocabulary", {}).get(tier, [])
        parts.append(f'<text x="{x}" y="84" fill="#d4d9e2" font-family="sans-serif" font-size="10">{label}</text>')
        if rows:
            for index, row in enumerate(rows[:3]):
                color = _rgb(row.get("dominant_rgb", [96, 96, 96]))
                parts.append(f'<rect x="{x + index * 50}" y="94" width="42" height="42" rx="4" fill="{color}" stroke="#e4e0d5" stroke-width="1"><title>{html.escape(row["asset_id"])} — {html.escape(row["reason"])}</title></rect>')
        else:
            parts.append(f'<rect x="{x}" y="94" width="42" height="42" fill="#222833" stroke="#5b6270"/><path d="M{x} 94 l42 42 M{x + 42} 94 l-42 42" stroke="#5b6270"/>')
        x += 280
    chart_x, chart_y, chart_w, chart_h = 48, 185, 1085, 150
    parts.append(f'<rect x="{chart_x}" y="{chart_y}" width="{chart_w}" height="{chart_h}" fill="#171c24" stroke="#3f4857"/>')
    points = []
    for index, plan in enumerate(plans):
        px = chart_x + (index / max(1, len(plans) - 1)) * chart_w
        py = chart_y + chart_h - plan.identity.get("spectacle", 0) * chart_h
        points.append((px, py))
    if points:
        coords = " ".join(f"{x:.1f},{y:.1f}" for x, y in points)
        parts.append(f'<polyline points="{coords}" fill="none" stroke="#f1c75b" stroke-width="3"/>')
    for plan, (px, py) in zip(plans, points):
        color = "#ff685f" if plan.special in ("boss", "mini_boss") else "#62c98a" if plan.special == "relay" else "#78b7d0"
        parts.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="5" fill="{color}"/><text x="{px - 5:.1f}" y="{chart_y + chart_h + 17}" fill="#aeb8c6" font-family="sans-serif" font-size="9">{plan.floor}</text>')
    parts.append(f'<text x="{chart_x}" y="{chart_y - 10}" fill="#f1c75b" font-family="sans-serif" font-size="12">Courbe de spectacle (pics volontairement rares)</text>')
    y = 375
    for index, plan in enumerate(plans):
        col = index % 4
        row = index // 4
        px, py = 22 + col * 288, y + row * 42
        family = plan.identity.get("composition_family", plan.archetype)
        signature = plan.identity.get("signature", {}).get("geometry", "")
        parts.append(f'<text x="{px}" y="{py}" fill="#e3e6ea" font-family="sans-serif" font-size="10">{plan.floor:02d} · {html.escape(family)}</text>')
        parts.append(f'<text x="{px}" y="{py + 14}" fill="#8793a3" font-family="sans-serif" font-size="8">{html.escape(signature[:44])}</text>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts), encoding="utf-8")


def special_rooms_svg(plans: list[FloorPlan], path: Path):
    selected = [plan for plan in plans if plan.special in ("relay", "mini_boss", "boss")]
    panel_width, panel_height, columns = 390, 350, 3
    rows = max(1, math.ceil(len(selected) / columns))
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{panel_width * columns}" height="{panel_height * rows + 54}" viewBox="0 0 {panel_width * columns} {panel_height * rows + 54}"><rect width="100%" height="100%" fill="#11141a"/>',
        '<text x="18" y="28" fill="#f3f0df" font-family="sans-serif" font-weight="bold" font-size="19">Salles spéciales — scène et approche</text>',
        '<text x="18" y="47" fill="#a9b4c4" font-family="sans-serif" font-size="12">Vert = relais · rouge = combat · jaune = landmark · bleu = entrée · ivoire = escalier</text>',
    ]
    labels = {"relay": "Relais / récupération", "mini_boss": "Rupture mini-boss", "boss": "Climax final"}
    for index, plan in enumerate(selected):
        offset_x, offset_y = (index % columns) * panel_width, 54 + (index // columns) * panel_height
        focus = plan.rooms[0]
        x0, y0 = max(0, focus.x - 9), max(0, focus.y - 7)
        x1, y1 = min(plan.width, focus.x + focus.width + 9), min(plan.height, focus.y + focus.height + 7)
        scale = min((panel_width - 28) / max(1, x1 - x0), (panel_height - 75) / max(1, y1 - y0))
        accent = {"relay": "#62c98a", "mini_boss": "#e67a64", "boss": "#ff4f4f"}[plan.special]
        parts.append(f'<rect x="{offset_x + 5}" y="{offset_y + 5}" width="{panel_width - 10}" height="{panel_height - 10}" rx="8" fill="#191d25" stroke="{accent}" stroke-width="2"/>')
        parts.append(f'<text x="{offset_x + 15}" y="{offset_y + 27}" fill="{accent}" font-family="sans-serif" font-weight="bold" font-size="15">Étage {plan.floor} — {labels[plan.special]}</text>')
        parts.append(f'<text x="{offset_x + 15}" y="{offset_y + 44}" fill="#b9c0ca" font-family="sans-serif" font-size="11">{focus.kind} {focus.width}×{focus.height} · fonction {focus.function}</text>')
        base_x, base_y = offset_x + 14, offset_y + 58
        for y in range(y0, y1):
            for x in range(x0, x1):
                tile = plan.get(x, y)
                color = {"wall": "#252a34", "room": "#7d826f", "corridor": "#b2a27c", "secret": "#575d70"}.get(tile, "#555")
                parts.append(f'<rect x="{base_x + (x - x0) * scale:.2f}" y="{base_y + (y - y0) * scale:.2f}" width="{scale + .15:.2f}" height="{scale + .15:.2f}" fill="{color}"/>')
        for decoration in plan.decorations:
            if x0 <= decoration["x"] < x1 and y0 <= decoration["y"] < y1:
                color = {"common": "#6ca45d", "secondary": "#72acb8", "rare": "#c38bcc", "focal": "#f4ce63"}.get(decoration["hierarchy"], "#fff")
                parts.append(f'<circle cx="{base_x + (decoration["x"] - x0 + .5) * scale:.2f}" cy="{base_y + (decoration["y"] - y0 + .5) * scale:.2f}" r="{max(1.5, scale * .22):.2f}" fill="{color}"><title>{html.escape(decoration["asset_id"])}</title></circle>')
        for landmark in plan.landmarks:
            x, y = landmark["position"]
            if x0 <= x < x1 and y0 <= y < y1:
                parts.append(f'<circle cx="{base_x + (x - x0 + .5) * scale:.2f}" cy="{base_y + (y - y0 + .5) * scale:.2f}" r="{max(4, scale * .5):.2f}" fill="none" stroke="#f4ce63" stroke-width="3"/>')
        for location, color, label in [(plan.entrance, "#45bde8", "Entrée"), (plan.exit, "#fff0a0", "Escalier")]:
            if x0 <= location[0] < x1 and y0 <= location[1] < y1:
                parts.append(f'<rect x="{base_x + (location[0] - x0 + .15) * scale:.2f}" y="{base_y + (location[1] - y0 + .15) * scale:.2f}" width="{scale * .7:.2f}" height="{scale * .7:.2f}" fill="{color}"><title>{label}</title></rect>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts), encoding="utf-8")
