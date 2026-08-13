#!/usr/bin/env python3
"""Canonical Ground → scripted battle segment → Ground conclusion boss flow."""
from __future__ import annotations
import copy
import hashlib
import json
from collections import deque
from pathlib import Path
from typing import Any
from .model import BossEncounterPlan, DesignBrief


def load_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))


def _open(obj, x, y):
    obstacles = obj.get("obstacles", [])
    return 0 <= x < len(obstacles) and 0 <= y < len(obstacles[0]) and not obstacles[x][y].get("Tags", 0)


def _marker(obj, name):
    for layer in obj.get("Entities", []):
        for marker in layer.get("Markers", []):
            if marker.get("EntName") == name:
                collider = marker["Collider"]
                return [collider["X"] // 8, collider["Y"] // 8]
    return None


def _find_confrontation(obj):
    width = len(obj.get("obstacles", []))
    height = len(obj.get("obstacles", [[]])[0]) if width else 0
    boss = _marker(obj, "Boss_Marker") or [width // 2, max(5, height // 3)]
    if not _open(obj, *boss):
        candidates = [(x, y) for x in range(width) for y in range(height) if _open(obj, x, y)]
        boss = list(min(candidates, key=lambda point: abs(point[0] - width // 2) + abs(point[1] - height // 3)))
    candidates = []
    for x in range(width):
        for y in range(height):
            distance = abs(x - boss[0]) + abs(y - boss[1])
            if 3 <= distance <= 6 and _open(obj, x, y):
                candidates.append((distance, -y, x, y))
    if not candidates:
        raise ValueError("Boss reference has no walkable confrontation position within 6 tiles")
    _, _, px, py = max(candidates)
    return [px, py], boss


def _replace_spawner_placeholders(obj, species_pool):
    replacements = species_pool or ["pikachu"]
    index = 0
    for layer in obj.get("Entities", []):
        layer["MapChars"] = []
        for spawner in layer.get("Spawners", []):
            npc = spawner.get("NPCChar", {})
            form = npc.get("BaseForm")
            if isinstance(form, dict) and form.get("Species") == "missingno":
                form["Species"] = replacements[index % len(replacements)]
                index += 1
        # A final arena has no generic exits or stairs.
        layer["GroundObjects"] = [row for row in layer.get("GroundObjects", []) if "Exit" not in row.get("EntName", "") and "Stair" not in row.get("EntName", "")]
    return index


def _scene_script(brief, encounter):
    boss = encounter.boss_species
    px, py = [value * 8 for value in encounter.player_position]
    bx, by = [value * 8 for value in encounter.boss_position]
    camera_x, camera_y = (px + bx) // 2, (py + by) // 2
    slug = brief.slug
    arena = encounter.arena_id
    pre_line = encounter.dialogue["pre_combat"][0]
    victory_line = encounter.dialogue["post_combat"][0]
    return f'''-- Smart Dungeon boss scene; flow modeled after Vast Steppe Guardian.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {arena}_scene = {{}}

local function state()
  SV.smart_dungeon = SV.smart_dungeon or {{}}
  SV.smart_dungeon['{slug}'] = SV.smart_dungeon['{slug}'] or {{seen=false, won=false, lost=false, completed=false}}
  return SV.smart_dungeon['{slug}']
end

local function make_boss()
  local monster = RogueEssence.Dungeon.MonsterID('{boss}', 0, 'normal', Gender.Genderless)
  local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc({bx}, {by}), Direction.Down, '', 'Boss')
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  return chara
end

function {arena}_scene.Introduction()
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local boss = make_boss()
  GROUND:Hide('Boss')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, {px}, {py}, Direction.Up)
  GAME:MoveCamera({camera_x}, {camera_y}, 1, false)
  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)
  GROUND:Unhide('Boss')
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  GAME:WaitFrames(20)
  UI:SetSpeaker(boss)
  UI:WaitShowDialogue('{pre_line}')
  COMMON.BossTransition()
  state().seen = true
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon('{slug}', {encounter.battle_segment}, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function {arena}_scene.Victory()
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local boss = make_boss()
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, {px}, {py}, Direction.Up)
  GAME:MoveCamera({camera_x}, {camera_y}, 1, false)
  GAME:FadeIn(40)
  UI:SetSpeaker(boss)
  UI:WaitShowDialogue('{victory_line}')
  state().completed = true
  GAME:FadeOut(false, 40)
  -- Fallback project route. A narrative destination can override this candidate.
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function {arena}_scene.Defeat()
  state().lost = false
  GAME:CutsceneMode(true)
  GAME:FadeIn(20)
  UI:ResetSpeaker()
  UI:WaitShowDialogue('La confrontation est perdue. Il faudra reprendre le parcours.')
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Downed,
    'master_zone', -1, 1, 0, true, true)
end

return {arena}_scene
'''


def _ground_script(encounter, state_key):
    arena = encounter.arena_id
    return f'''-- Smart Dungeon final arena controller.
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.{arena}.{arena}_scene'

local {arena} = {{}}

function {arena}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function {arena}.Enter(map)
  SV.smart_dungeon = SV.smart_dungeon or {{}}
  SV.smart_dungeon['{state_key}'] = SV.smart_dungeon['{state_key}'] or {{}}
  local state = SV.smart_dungeon['{state_key}']
  if state.won then
    state.won = false
    {arena}_scene.Victory()
  elseif state.lost then
    state.lost = false
    {arena}_scene.Defeat()
  else
    {arena}_scene.Introduction()
  end
end

function {arena}.Update(map) end
return {arena}
'''


def _boss_preview(data, encounter, path):
    obj=data['Object'];obstacles=obj.get('obstacles',[]);width=len(obstacles);height=len(obstacles[0]) if obstacles else 0;cell=8
    parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{width*cell}" height="{height*cell+42}" viewBox="0 0 {width*cell} {height*cell+42}"><rect width="100%" height="100%" fill="#11141a"/>']
    for x,col in enumerate(obstacles):
        for y,tile in enumerate(col):parts.append(f'<rect x="{x*cell}" y="{42+y*cell}" width="{cell}" height="{cell}" fill="{"#252a34" if tile.get("Tags",0) else "#7d826f"}"/>')
    px,py=encounter.player_position;bx,by=encounter.boss_position;parts.append(f'<circle cx="{(px+.5)*cell}" cy="{42+(py+.5)*cell}" r="5" fill="#56d3ff"><title>Position joueur</title></circle>');parts.append(f'<circle cx="{(bx+.5)*cell}" cy="{42+(by+.5)*cell}" r="6" fill="#ff685f"><title>Boss {encounter.boss_species}</title></circle>');parts.append(f'<line x1="{(px+.5)*cell}" y1="{42+(py+.5)*cell}" x2="{(bx+.5)*cell}" y2="{42+(by+.5)*cell}" stroke="#f4ce63" stroke-width="2"/>');parts.append(f'<text x="8" y="17" fill="white" font-family="sans-serif" font-size="12">Arène finale — {encounter.boss_species}</text><text x="8" y="33" fill="#b8c2cf" font-family="sans-serif" font-size="10">distance joueur/boss {encounter.distance_tiles}/6 · aucun escalier · caméra locale</text></svg>');path.parent.mkdir(parents=True,exist_ok=True);path.write_text('\n'.join(parts),encoding='utf-8')


def design_boss_encounter(repo: Path, project: Path, brief: DesignBrief, profile: dict[str, Any], battle_segment: int):
    source_id = "mount_windswept_guardian"
    source_path = repo / "Data/Ground" / f"{source_id}.rsground"
    data = load_json(source_path)
    obj = data["Object"]
    player_position, boss_position = _find_confrontation(obj)
    distance = abs(player_position[0] - boss_position[0]) + abs(player_position[1] - boss_position[1])
    arena_id = f"{brief.slug}_arene_finale"
    species = profile["boss"]["species"]
    roster = [row["species"] for segment in profile["segments"] for row in segment["enemy_table"] if row["species"] not in ("unresolved", "missingno")]
    placeholder_count = _replace_spawner_placeholders(obj, roster)
    obj["AssetName"] = arena_id
    obj["Name"] = {"DefaultText": f"{brief.name} Final Arena", "LocalTexts": {"fr": f"Cœur de {brief.name}"}}
    obj["Comment"] = f"Arène finale Smart Dungeon; référence Ground {source_id}; aucune sortie/escalier; distance confrontation {distance}."
    obj["Released"] = False
    ground_rel = Path("finale/ground") / f"{arena_id}.rsground"
    init_rel = Path("finale/scripts/ground") / arena_id / "init.lua"
    scene_rel = Path("finale/scripts/ground") / arena_id / f"{arena_id}_scene.lua"
    preview_rel = Path("finale/previews") / f"{arena_id}.svg"
    dialogue = {
        "status": "generated_conservative_placeholder" if not brief.narrative_prompt else "derived_from_user_narrative_prompt",
        "pre_combat": [f"Vous avez atteint le cœur de ce lieu. Montrez-moi votre détermination !"],
        "post_combat": ["Votre force est réelle. Le passage peut désormais s'achever."],
        "narrative_prompt": brief.narrative_prompt,
        "language": "fr-FR",
    }
    encounter = BossEncounterPlan(
        arena_id=arena_id, source_ground=source_id,
        ground_file=ground_rel.as_posix(), ground_script_file=init_rel.as_posix(), scene_script_file=scene_rel.as_posix(), preview_file=preview_rel.as_posix(),
        battle_segment=battle_segment, boss_species=species, boss_category=brief.boss_category,
        player_position=player_position, boss_position=boss_position, distance_tiles=distance,
        companions=[], dialogue=dialogue,
        completion={"mode": "scripted_after_victory", "fallback": "master_zone ground 1", "physical_exit": False, "stairs": False},
        decisions=[
            {"decision": "canonical_flow", "source": "vast_steppe_guardian+mount_windswept_guardian", "why": "Ground introduction, BossTransition, mapped battle segment, Ground conclusion"},
            {"decision": "arena_scale", "size_cells": [len(obj.get("obstacles", [])), len(obj.get("obstacles", [[]])[0])], "why": "arène compacte validée avec caméra locale"},
            {"decision": "boss_distance", "distance": distance, "limit": 6},
            {"decision": "companions", "value": [], "why": "aucune donnée locale d'évolution fiable; aucune sous-évolution inventée"},
        ],
    )
    encounter.validation = validate_boss_ground(data, encounter)
    for rel in (ground_rel, init_rel, scene_rel, preview_rel):
        (project / rel).parent.mkdir(parents=True, exist_ok=True)
    (project / ground_rel).write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    (project / init_rel).write_text(_ground_script(encounter, brief.slug), encoding="utf-8")
    (project / scene_rel).write_text(_scene_script(brief, encounter), encoding="utf-8")
    _boss_preview(data, encounter, project / preview_rel)
    return encounter


def validate_boss_ground(data, encounter):
    text = json.dumps(data, ensure_ascii=False).casefold()
    errors = []
    if encounter.distance_tiles > 6:
        errors.append({"code": "BOSS_TOO_FAR", "distance": encounter.distance_tiles})
    if "stairs_go_" in text or '"stairs"' in text:
        errors.append({"code": "GENERIC_STAIRS_IN_BOSS_ARENA"})
    if "missingno" in text:
        errors.append({"code": "MISSINGNO_LEAK"})
    obj = data["Object"]
    width, height = len(obj.get("obstacles", [])), len(obj.get("obstacles", [[]])[0])
    for label, position in (("player", encounter.player_position), ("boss", encounter.boss_position)):
        if not _open(obj, *position):
            errors.append({"code": "BLOCKED_BOSS_POSITION", "label": label, "position": position})
    if width > 64 or height > 56:
        errors.append({"code": "ARENA_VIEWPORT_EXCESS", "size": [width, height]})
    required_flow = {"introduction", "dialogue_precombat", "combat", "victoire", "conclusion", "fin_donjon"}
    if not required_flow <= set(encounter.flow):
        errors.append({"code": "INCOMPLETE_BOSS_FLOW"})
    return {
        "result": "BOSS_ENCOUNTER_PASS" if not errors else "BOSS_ENCOUNTER_FAIL",
        "errors": errors, "distance_tiles": encounter.distance_tiles,
        "distance_limit": 6, "stairs": False, "physical_exit": False,
        "viewport_policy": "local_camera_no_forced_zoom",
    }
