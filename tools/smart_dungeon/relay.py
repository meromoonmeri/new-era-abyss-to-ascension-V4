#!/usr/bin/env python3
"""Native midpoint relay candidates between procedural dungeon segments.

Existing certified Grounds are read-only references. Generated copies, scripts
and manifests stay inside the Smart Dungeon project until explicit promotion.
"""
from __future__ import annotations
import copy
import hashlib
import html
import json
from pathlib import Path
from typing import Any
from .model import DesignBrief, RelayPlan

CANONICAL_TEMPLATES = [
    "searing_tunnel_midpoint",
    "crooked_cavern_midpoint",
    "cloven_ruins_midpoint",
    "mount_windswept_midpoint",
    "vast_steppe_midpoint",
    "poisonous_forest_relay",
    "frosty_forest_midpoint",
]
REQUIRED_OBJECTS = {"Kangaskhan_Rock", "North_Exit", "South_Exit"}
REQUIRED_MARKER = "Main_Entrance_Marker"


def _load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from _walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from _walk(child)


def _ground_inventory(obj):
    sheets, objects, markers = set(), {}, {}
    map_chars = spawners = 0
    for value in _walk(obj.get("Layers", [])):
        if isinstance(value, dict) and value.get("Sheet"):
            sheets.add(value["Sheet"])
    for layer in obj.get("Entities", []):
        map_chars += len(layer.get("MapChars", []))
        spawners += len(layer.get("Spawners", []))
        for item in layer.get("GroundObjects", []):
            objects[item.get("EntName", "")] = item
        for item in layer.get("Markers", []):
            markers[item.get("EntName", "")] = item
    return sheets, objects, markers, map_chars, spawners


def _template_score(name, obj, catalog, direction, order):
    sheets, objects, markers, _, _ = _ground_inventory(obj)
    if not REQUIRED_OBJECTS <= set(objects) or REQUIRED_MARKER not in markers:
        return -999
    selected = {
        row["asset_id"]
        for rows in direction.get("vocabulary", {}).values()
        for row in rows
    }
    by_id = {row["asset_id"]: row for row in catalog.get("assets", [])}
    score = 0.0
    for sheet in sheets:
        if sheet in selected:
            score += 12
        profile = by_id.get(sheet)
        if profile:
            for relation in profile.get("compatible", []):
                if relation["asset_id"] in selected:
                    score += relation["score"] * 2
    # The tunnel is the canonical structural reference requested by the user.
    if name == "searing_tunnel_midpoint" and order == 1:
        score += 5
    # Conservative deterministic fallback: canonical structural order, not an
    # invented semantic association. The decision is reported as low-confidence
    # when no analyzed sheet supports it.
    canonical_preference = (len(CANONICAL_TEMPLATES) - CANONICAL_TEMPLATES.index(name)) / 1000
    return score + canonical_preference


def _select_templates(repo, count, catalog, direction):
    candidates = []
    for name in CANONICAL_TEMPLATES:
        path = repo / "Data/Ground" / f"{name}.rsground"
        if not path.exists():
            continue
        try:
            data = _load(path)
            obj = data["Object"]
        except Exception:
            continue
        candidates.append((name, path, data, obj))
    selected = []
    for order in range(1, count + 1):
        available = [row for row in candidates if row[0] not in {item[0] for item in selected}] or candidates
        if not available:
            raise ValueError("No Ground with Kangaskhan_Rock and two exits is available")
        selected.append(max(available, key=lambda row: (_template_score(row[0], row[3], catalog, direction, order), row[0])))
    return selected


def _strip_cast(obj):
    """Keep environment/gameplay objects but no inherited cast or MissingNo."""
    for layer in obj.get("Entities", []):
        layer["MapChars"] = []
        layer["Spawners"] = []
        # Trigger-zero objects are environmental. Only the three canonical
        # gameplay objects retain interactions.
        for item in layer.get("GroundObjects", []):
            if item.get("EntName") not in REQUIRED_OBJECTS:
                item["triggerType"] = 0
    return obj


def _relay_script(relay_id, dungeon_id, previous_segment, next_segment):
    return f'''-- Generated Smart Dungeon midpoint relay; deterministic and promotion-ready.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {relay_id} = {{}}

function {relay_id}.Init(map)
  DEBUG.EnableDbgCoro()
end

function {relay_id}.Enter(map)
  GAME:FadeIn(20)
end

function {relay_id}.Update(map) end

local function enter_segment(segment)
  GAME:FadeOut(false, 40)
  if _ZONE.CurrentZoneID == '{dungeon_id}' then
    GAME:ContinueDungeon('{dungeon_id}', segment, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    GAME:EnterDungeon('{dungeon_id}', segment, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Chemin avant : seconde partie du donjon.
function {relay_id}.North_Exit_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo('Continuer vers la partie suivante du donjon ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then enter_segment({next_segment}) end
end

-- Chemin arrière : première partie du donjon.
function {relay_id}.South_Exit_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo('Revenir vers la partie précédente du donjon ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then enter_segment({previous_segment}) end
end

-- Statue de Kangourex : soin, stockage et sauvegarde natifs du projet.
function {relay_id}.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return {relay_id}
'''


def _zone_script(brief, relays):
    routes = "\n".join(
        f"  [{relay.previous_segment}] = '{relay.relay_id}',"
        for relay in relays
    )
    return f'''-- Generated Smart Dungeon segment/relay router.
-- Requires promotion of the generated Ground candidates and their scripts.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {brief.slug} = {{}}
local RELAY_AFTER_SEGMENT = {{
{routes}
}}

function {brief.slug}.Init(zone) end

function {brief.slug}.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
end

function {brief.slug}.ExitSegment(zone, result, rescue, segmentID, mapID)
  local relay = RELAY_AFTER_SEGMENT[segmentID]
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared and relay ~= nil then
    GAME:EnterGroundMap(relay, 'Main_Entrance_Marker')
    return
  end
  -- Final completion/failure policy remains an explicit integration hook;
  -- no narrative destination is invented by the designer.
end

function {brief.slug}.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

return {brief.slug}
'''


def _validate_generated(data, relay):
    obj = data["Object"]
    _, objects, markers, map_chars, spawners = _ground_inventory(obj)
    missing = sorted(REQUIRED_OBJECTS - set(objects))
    if REQUIRED_MARKER not in markers:
        missing.append(REQUIRED_MARKER)
    text = json.dumps(data, ensure_ascii=False).casefold()
    errors = []
    if missing:
        errors.append({"code": "MISSING_RELAY_ENTITY", "entities": missing})
    if map_chars:
        errors.append({"code": "INHERITED_CAST", "count": map_chars})
    if spawners:
        errors.append({"code": "INHERITED_SPAWNERS", "count": spawners})
    if "missingno" in text:
        errors.append({"code": "MISSINGNO_LEAK"})
    if relay.north_route.get("segment") == relay.south_route.get("segment"):
        errors.append({"code": "ROUTES_NOT_DISTINCT"})
    return {
        "result": "RELAY_VALIDATION_PASS" if not errors else "RELAY_VALIDATION_FAIL",
        "two_distinct_routes": not any(row["code"] == "ROUTES_NOT_DISTINCT" for row in errors),
        "kangaskhan_rock": "Kangaskhan_Rock" in objects,
        "north_exit": "North_Exit" in objects,
        "south_exit": "South_Exit" in objects,
        "main_entrance_marker": REQUIRED_MARKER in markers,
        "inherited_cast_count": map_chars,
        "inherited_spawner_count": spawners,
        "errors": errors,
    }


def design_relays(repo: Path, project: Path, brief: DesignBrief, rows: list[dict[str, Any]], catalog: dict, direction: dict):
    boundaries = [row["floor"] for row in rows if row.get("relay_after")]
    templates = _select_templates(repo, len(boundaries), catalog, direction)
    relays = []
    for order, (after_floor, template) in enumerate(zip(boundaries, templates), 1):
        source_name, source_path, source_data, source_obj = template
        relay_id = f"{brief.slug}_relais_{order:02d}"
        data = copy.deepcopy(source_data)
        obj = _strip_cast(data["Object"])
        obj["AssetName"] = relay_id
        obj["Name"] = {
            "DefaultText": f"{brief.name} Relay {order}",
            "LocalTexts": {"fr": f"Relais de {brief.name} — palier {order}"},
        }
        source_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
        obj["Comment"] = (
            f"Relais médian généré après l'étage {after_floor}; source structurelle "
            f"en lecture seule {source_name} sha256={source_hash}. Statue Kangourex, "
            "sortie avant vers le segment suivant, sortie arrière vers le précédent."
        )
        obj["Released"] = False
        ground_relative = Path("relays/grounds") / f"{relay_id}.rsground"
        script_relative = Path("relays/scripts/ground") / relay_id / "init.lua"
        ground_path, script_path = project / ground_relative, project / script_relative
        ground_path.parent.mkdir(parents=True, exist_ok=True)
        script_path.parent.mkdir(parents=True, exist_ok=True)
        ground_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
        script_path.write_text(_relay_script(relay_id, brief.slug, order - 1, order), encoding="utf-8")
        sheets, objects, markers, _, _ = _ground_inventory(obj)
        analyzed_ids = {row["asset_id"] for row in catalog.get("assets", [])}
        selected_ids = {row["asset_id"] for entries in direction.get("vocabulary", {}).values() for row in entries}
        analyzed_sheets = sorted(sheets & analyzed_ids)
        selected_sheets = sorted(sheets & selected_ids)
        selection_confidence = .9 if selected_sheets else .55 if analyzed_sheets else .25
        relay = RelayPlan(
            relay_id=relay_id,
            order=order,
            after_floor=after_floor,
            previous_segment=order - 1,
            next_segment=order,
            source_ground=source_name,
            ground_file=ground_relative.as_posix(),
            script_file=script_relative.as_posix(),
            north_route={"direction": "avant", "segment": order, "entry_floor": 0},
            south_route={"direction": "arrière", "segment": order - 1, "entry_floor": 0},
            composition={
                "role": "point_median_entre_segments",
                "sheet_vocabulary": sorted(sheets),
                "statue_position": objects["Kangaskhan_Rock"].get("Collider"),
                "north_exit_collider": objects["North_Exit"].get("Collider"),
                "south_exit_collider": objects["South_Exit"].get("Collider"),
                "entrance_marker": markers[REQUIRED_MARKER].get("Collider"),
                "source_sha256": source_hash,
                "source_modified": False,
                "cast_policy": "environment_only_no_inherited_cast",
                "template_selection": {
                    "confidence": selection_confidence,
                    "analyzed_sheets": analyzed_sheets,
                    "selected_vocabulary_sheets": selected_sheets,
                    "strategy": "visual_evidence" if selected_sheets else "analyzed_conservative_fallback" if analyzed_sheets else "canonical_structural_fallback_no_visual_claim",
                },
            },
            decisions=[
                {"decision": "segment_boundary", "why": f"sépare les étages 1–{after_floor} de la partie suivante"},
                {"decision": "kangaskhan_checkpoint", "why": "repère immédiatement reconnaissable offrant soin, stockage et sauvegarde"},
                {"decision": "two_routes", "why": "North_Exit avance; South_Exit revient au segment précédent"},
                {"decision": "source_template", "source": source_name, "confidence": selection_confidence, "why": "Ground PMDO existant avec collisions et placements fiables; choix visuel déclaré conservateur si ses sheets ne figurent pas dans le catalogue analysé; original non modifié"},
            ],
        )
        relay.validation = _validate_generated(data, relay)
        relays.append(relay)
    zone_script = project / "relays/scripts/zone" / brief.slug / "init.lua"
    zone_script.parent.mkdir(parents=True, exist_ok=True)
    zone_script.write_text(_zone_script(brief, relays), encoding="utf-8")
    return relays, zone_script.relative_to(project).as_posix()


def validate_relay_file(project: Path, relay: RelayPlan):
    path = project / relay.ground_file
    if not path.exists():
        return {"result": "RELAY_VALIDATION_FAIL", "errors": [{"code": "GROUND_FILE_MISSING", "path": relay.ground_file}]}
    try:
        data = _load(path)
    except Exception as exception:
        return {"result": "RELAY_VALIDATION_FAIL", "errors": [{"code": "GROUND_PARSE_ERROR", "detail": str(exception)}]}
    return _validate_generated(data, relay)


def relay_sheet_svg(relays: list[RelayPlan], project: Path, path: Path):
    panel_width, panel_height = 560, 390
    width, height = panel_width * max(1, len(relays)), panel_height
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#11141a"/>',
    ]
    for index, relay in enumerate(relays):
        offset = index * panel_width
        data = _load(project / relay.ground_file)["Object"]
        obstacles = data.get("obstacles", [])
        grid_width = len(obstacles)
        grid_height = len(obstacles[0]) if obstacles else 0
        scale = min((panel_width - 30) / max(1, grid_width), 285 / max(1, grid_height))
        parts.append(f'<text x="{offset + 15}" y="25" fill="#f3f0df" font-family="sans-serif" font-weight="bold" font-size="15">Relais {relay.order} — après étage {relay.after_floor}</text>')
        parts.append(f'<text x="{offset + 15}" y="43" fill="#9eabbc" font-family="sans-serif" font-size="10">{html.escape(relay.source_ground)} · segment {relay.previous_segment} ↔ {relay.next_segment}</text>')
        base_x, base_y = offset + 15, 58
        for x, column in enumerate(obstacles):
            for y, cell in enumerate(column):
                color = "#222832" if cell.get("Tags", 0) else "#767968"
                parts.append(f'<rect x="{base_x + x * scale:.2f}" y="{base_y + y * scale:.2f}" width="{scale + .15:.2f}" height="{scale + .15:.2f}" fill="{color}"/>')
        _, objects, markers, _, _ = _ground_inventory(data)
        for name, color in [("Kangaskhan_Rock", "#f4ce63"), ("North_Exit", "#62c98a"), ("South_Exit", "#e67a64")]:
            collider = objects[name]["Collider"]
            x, y = collider["X"] / 8, collider["Y"] / 8
            parts.append(f'<circle cx="{base_x + x * scale:.2f}" cy="{base_y + y * scale:.2f}" r="{max(4, scale * 1.3):.2f}" fill="{color}"><title>{name}</title></circle>')
        marker = markers[REQUIRED_MARKER]["Collider"]
        parts.append(f'<rect x="{base_x + marker["X"] / 8 * scale:.2f}" y="{base_y + marker["Y"] / 8 * scale:.2f}" width="{max(5, scale * 2):.2f}" height="{max(5, scale * 2):.2f}" fill="#56d3ff"><title>Entrée</title></rect>')
        parts.append(f'<text x="{offset + 15}" y="{height - 25}" fill="#cbd2dc" font-family="sans-serif" font-size="10">Jaune: Kangourex · vert: suite · rouge: retour · bleu: arrivée</text>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts), encoding="utf-8")
