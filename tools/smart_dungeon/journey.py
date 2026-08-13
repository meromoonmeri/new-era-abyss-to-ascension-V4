#!/usr/bin/env python3
"""Data-driven whole-dungeon biome and gameplay progression."""
from __future__ import annotations
import hashlib
import math
import random
from collections import Counter
from typing import Any
from .model import DesignBrief, FloorPlan, RelayPlan


def stable_float(*parts):
    raw = hashlib.sha256("|".join(map(str, parts)).encode()).digest()
    return int.from_bytes(raw[:8], "little") / 0xFFFFFFFFFFFFFFFF


def _tokens(text):
    import re
    stop = {"floor", "wall", "secondary", "ground", "block", "tileset", "unused", "base"}
    return {token for token in re.findall(r"[a-z0-9]+", text.casefold()) if len(token) > 2 and token not in stop}


def _reference_score(zone, brief, selection):
    text = " ".join([zone["zone_id"], zone.get("comment", ""), str(zone.get("name", {}))]).casefold()
    themes = set(brief.theme_tokens + brief.visual_keywords)
    semantic = sum(token.casefold() in text for token in themes) * 4
    target = set(selection.get("texture_values") or [])
    texture = max((len(target & set(bundle)) for bundle in zone.get("texture_bundles", [])), default=0) * 8
    completeness = min(5, len(zone.get("species_ids", [])) / 5) + min(4, len(zone.get("item_ids", [])) / 10)
    return semantic + texture + completeness


def _select_references(knowledge, brief, selection, count=4):
    zones = [zone for zone in knowledge.get("zones", []) if zone.get("species_ids")]
    return sorted(zones, key=lambda zone: (-_reference_score(zone, brief, selection), zone["zone_id"]))[:count]


def _stage_name(index, count, brief):
    phases = ["seuil", "strate_interieure", "profondeurs", "coeur_ancien", "approche_finale"]
    if count == 1:
        return "parcours_principal"
    position = index / max(1, count - 1)
    return phases[min(len(phases) - 1, round(position * (len(phases) - 1)))]


def _texture_candidates(knowledge, references, selection):
    primary = selection.get("texture_values")
    candidates = []
    if primary:
        candidates.append(primary)
    anchor_tokens = _tokens(" ".join(primary or []))
    for zone in references:
        for bundle in zone.get("texture_bundles", []):
            if bundle in candidates:
                continue
            overlap = len(anchor_tokens & _tokens(" ".join(bundle)))
            if overlap or not candidates:
                candidates.append(bundle)
    return candidates or [["", "", ""]]


def _species_pool(references):
    rows, seen = [], set()
    for zone in references:
        for row in zone.get("species", []):
            species = row["species"]
            if species in seen or species in ("missingno", "kecleon"):
                continue
            seen.add(species)
            rows.append({
                "species": species, "native_level": row.get("level"),
                "native_tactic": row.get("tactic"), "source_zone": zone["zone_id"],
                "source_path": row.get("path"),
            })
    return rows


def _item_pool(references):
    rows, seen = [], set()
    for zone in references:
        for row in zone.get("items", []):
            item_id = row["item_id"]
            if item_id in seen:
                continue
            seen.add(item_id)
            rows.append({
                "item_id": item_id, "category": row["category"],
                "native_rate": row.get("rate"), "source_zone": zone["zone_id"],
                "source_path": row.get("path"),
            })
    return rows


def _slice_with_overlap(rows, stage_index, stage_count, width=9):
    if not rows:
        return []
    if len(rows) <= width:
        return rows
    # Consecutive sections deliberately retain roughly half their population;
    # progression is visible without turning each segment into another biome.
    start = min(max(0, len(rows) - width), stage_index * max(1, width // 2))
    return rows[start:start + width]


def _weighted_items(pool, stage_index, stage_count):
    if not pool:
        return []
    progress = stage_index / max(1, stage_count - 1)
    common = [row for row in pool if row["category"] in ("food", "berry", "ammo", "seed")]
    utility = [row for row in pool if row["category"] in ("orb", "wand", "held", "machine")]
    rare = [row for row in pool if row["category"] in ("evolution", "treasure", "key")]
    chosen = common[:10] + utility[:4 + round(progress * 5)] + rare[:round(progress * 3)]
    if not chosen:
        chosen = pool[:12]
    result = []
    for row in chosen:
        weight = 14 if row["category"] in ("food", "berry") else 9 if row["category"] in ("seed", "ammo") else max(2, round(7 - progress * 2))
        result.append({**row, "weight": weight})
    return result


def _shop_assortment(items, progress):
    allowed = []
    for row in items:
        category = row["category"]
        if category in ("food", "berry", "seed", "ammo") or progress >= .35 and category in ("orb", "wand", "held") or progress >= .68 and category in ("machine", "evolution", "treasure"):
            allowed.append({**row, "shop_weight": max(2, row.get("weight", 8)), "price_policy": "native_item_price"})
    return allowed[:24]


def _neutral_pool(references, knowledge):
    neutral_sources = {zone["zone_id"] for zone in knowledge.get("zones", []) if zone.get("neutral_encounters")}
    rows = []
    for zone in knowledge.get("zones", []):
        if zone["zone_id"] not in neutral_sources:
            continue
        for species in zone.get("species", []):
            if species.get("tactic") == "wait_only":
                rows.append({
                    "species": species["species"], "behavior": "neutral_interactable",
                    "tactic": "wait_only", "ally": True,
                    "prototype_zone": zone["zone_id"],
                    "prototype": "PresetMultiTeamSpawner+MobSpawnInteractable+NpcDialogueBattleEvent",
                    "dialogue_contract": "SMART_DUNGEON_NEUTRAL_GENERIC",
                })
    unique = []
    for row in rows:
        if row["species"] not in {item["species"] for item in unique}:
            unique.append(row)
    return unique


def build_dungeon_profile(
    knowledge: dict[str, Any], brief: DesignBrief, plans: list[FloorPlan], rows: list[dict[str, Any]],
    relays: list[RelayPlan], direction: dict, selection: dict,
):
    references = _select_references(knowledge, brief, selection)
    species_pool = _species_pool(references)
    item_pool = _item_pool(references)
    neutral_pool = _neutral_pool(references, knowledge)
    stage_count = len(relays) + 1
    boundaries = [relay.after_floor for relay in relays] + [brief.floors]
    textures = _texture_candidates(knowledge, references, selection)
    stages, floor_rules = [], []
    start = 1
    base_level = {"facile": 10, "normal": 18, "difficile": 26, "extrême": 34}.get(brief.difficulty, 18)
    for stage_index, end in enumerate(boundaries):
        progress = stage_index / max(1, stage_count - 1)
        stage_species = _slice_with_overlap(species_pool, stage_index, stage_count, 9)
        if not stage_species:
            stage_species = [{"species": "unresolved", "source_zone": None, "native_level": None, "native_tactic": None, "source_path": None}]
        enemies = []
        for index, entry in enumerate(stage_species):
            enemies.append({
                **entry,
                "level": [base_level + round(progress * 7) + index % 3, base_level + round(progress * 7) + index % 3 + 2],
                "weight": max(3, 14 - index),
                "category": "enemy",
                "floor_range": [start, end],
            })
        loot = _weighted_items(item_pool, stage_index, stage_count)
        shop_chance = round(8 + brief.danger_bias * 5 + progress * 4, 2)
        stage = {
            "segment": stage_index,
            "global_floor_range": [start, end],
            "stage_name": _stage_name(stage_index, stage_count, brief),
            "biome_continuity": {
                "global_tokens": brief.theme_tokens,
                "texture_bundle": textures[min(stage_index, len(textures) - 1)],
                "light_progression": round(max(.18, .72 - progress * .42), 3),
                "detail_progression": round(min(.92, .38 + progress * .42), 3),
                "decoration_density": round(brief.decoration_bias * (.72 + progress * .38), 3),
                "transition_rule": "shared_primary_vocabulary_then_density_palette_and_effect_shift",
            },
            "enemy_table": enemies,
            "neutral_table": [dict(row, floor_range=[start, end], chance_percent=round(max(1, 8 - progress * 5), 2)) for row in neutral_pool[:2]],
            "loot": {
                "ground": loot,
                "buried": [dict(row, weight=max(1, row["weight"] // 3)) for row in loot if row["category"] in ("ammo", "treasure", "seed")][:6],
                "rare": [row for row in loot if row["category"] in ("machine", "evolution", "treasure", "key")],
            },
            "kecleon": {
                "chance_percent_per_eligible_floor": shop_chance,
                "prototype_zone": next((zone["zone_id"] for zone in references if zone.get("shops")), "vast_steppe"),
                "native_contract": "ShopStep+ShopkeeperInteract+shop_security",
                "assortment": _shop_assortment(loot, progress),
                "amount": [5, 9],
            },
            "rules": {
                "ground_items": [1 + round(progress), 3 + round(progress * 2)],
                "buried_items": [0 if not loot else round(progress), round(2 + progress * 3)],
                "starting_enemies": [2 + round(progress), 4 + round(progress * 2)],
                "traps": progress >= .25,
                "monster_house_chance_percent": 0 if progress < .35 else round(2 + progress * 5, 2),
                "water_policy": brief.water_policy,
                "darkness": "none" if progress < .3 else "light" if progress < .72 else "deep",
                "turn_limit": 1800,
            },
            "provenance": {
                "reference_zones": [zone["zone_id"] for zone in references],
                "external_structure_reference": "Aegis Cave sectioned tables; no external data copied",
            },
        }
        stages.append(stage)
        for floor in range(start, end + 1):
            local_progress = (floor - start) / max(1, end - start)
            eligible_shop = floor not in (start, end) and not any(plan.floor == floor and plan.special for plan in plans)
            shop_roll = stable_float(brief.seed, "shop", floor) * 100
            neutral_roll = stable_float(brief.seed, "neutral", floor) * 100
            floor_rules.append({
                "floor": floor, "segment": stage_index,
                "stage_name": stage["stage_name"],
                "enemy_table": [dict(enemy, weight=max(2, enemy["weight"] + ((floor + index) % 3) - 1)) for index, enemy in enumerate(enemies)],
                "ground_loot_table": loot,
                "buried_loot_table": stage["loot"]["buried"],
                "shop": {
                    "eligible": eligible_shop,
                    "chance_percent": shop_chance,
                    "control_roll": round(shop_roll, 4),
                    "present_in_control_realization": eligible_shop and shop_roll < shop_chance,
                    "assortment": stage["kecleon"]["assortment"],
                },
                "neutral_encounter": {
                    "chance_percent": round(max(1, 8 - progress * 5), 2),
                    "control_roll": round(neutral_roll, 4),
                    "present_in_control_realization": bool(stage["neutral_table"]) and neutral_roll < max(1, 8 - progress * 5),
                    "table": stage["neutral_table"],
                },
                "rules": dict(stage["rules"], danger_scale=round(progress * .65 + local_progress * .35, 3)),
                "special_room_permissions": {
                    "shop": eligible_shop, "treasure": floor != start,
                    "neutral_npc": bool(stage["neutral_table"]),
                    "monster_house": stage["rules"]["monster_house_chance_percent"] > 0,
                    "relay": False, "boss_arena": False,
                },
            })
        start = end + 1
    boss_species = brief.boss_species or next((enemy["species"] for enemy in reversed(stages[-1]["enemy_table"]) if enemy["species"] != "unresolved"), "unresolved")
    profile = {
        "schema_version": "1.0.0",
        "profile_id": "journey_" + hashlib.sha256((brief.intent + str(brief.seed)).encode()).hexdigest()[:12],
        "biome": {
            "global_tokens": brief.theme_tokens,
            "visual_keywords": brief.visual_keywords,
            "direction_id": direction.get("identity_id"),
            "continuity_rule": "one_biome_progressively_transformed_not_independent_biomes",
        },
        "reference_zones": [{"zone_id": zone["zone_id"], "score": round(_reference_score(zone, brief, selection), 3), "sha256": zone["source_sha256"]} for zone in references],
        "segments": stages,
        "floor_rules": floor_rules,
        "relays": [relay.to_dict() for relay in relays],
        "final_approach": {
            "floors": [max(1, brief.floors - 1), brief.floors],
            "distraction_reduction": True, "path_readability_priority": True,
            "spectacle_ramp": [round(plans[-2].identity.get("spectacle", 0), 3), round(plans[-1].identity.get("spectacle", 0), 3)],
        },
        "boss": {
            "species": boss_species, "category": brief.boss_category,
            "companion_policy": "pre_evolutions_only_with_local_evolution_evidence_and_never_automatic_for_legendary_or_mythical",
            "narrative_prompt": brief.narrative_prompt,
        },
        "data_driven": True,
        "control_realization_seed": brief.seed,
        "validation": {},
    }
    profile["validation"] = validate_profile(profile, brief)
    return profile


def validate_profile(profile, brief):
    errors = []
    segments = profile.get("segments", [])
    floors = profile.get("floor_rules", [])
    if len(floors) != brief.floors:
        errors.append({"code": "FLOOR_RULE_COUNT", "expected": brief.floors, "actual": len(floors)})
    for floor in floors:
        if not floor.get("enemy_table"):
            errors.append({"code": "EMPTY_ENEMY_TABLE", "floor": floor["floor"]})
        if not floor.get("ground_loot_table"):
            errors.append({"code": "EMPTY_LOOT_TABLE", "floor": floor["floor"]})
        if floor["special_room_permissions"].get("relay") or floor["special_room_permissions"].get("boss_arena"):
            errors.append({"code": "SPECIAL_GROUND_AS_NORMAL_ROOM", "floor": floor["floor"]})
    for stage in segments:
        if not stage["kecleon"].get("assortment"):
            errors.append({"code": "EMPTY_SHOP_ASSORTMENT", "segment": stage["segment"]})
        if not all(row.get("source_zone") for row in stage["enemy_table"] if row["species"] != "unresolved"):
            errors.append({"code": "UNPROVEN_SPECIES", "segment": stage["segment"]})
        if not all(row.get("source_zone") for row in stage["loot"]["ground"]):
            errors.append({"code": "UNPROVEN_ITEM", "segment": stage["segment"]})
    for left, right in zip(segments, segments[1:]):
        left_texture = _tokens(" ".join(left["biome_continuity"]["texture_bundle"]))
        right_texture = _tokens(" ".join(right["biome_continuity"]["texture_bundle"]))
        if left_texture and right_texture and not left_texture & right_texture:
            errors.append({"code": "BIOME_TEXTURE_DISCONTINUITY", "segments": [left["segment"], right["segment"]], "textures": [sorted(left_texture), sorted(right_texture)]})
        enemy_overlap = {row["species"] for row in left["enemy_table"]} & {row["species"] for row in right["enemy_table"]}
        if len(enemy_overlap) < min(3, len(left["enemy_table"]), len(right["enemy_table"])):
            errors.append({"code": "POPULATION_DISCONTINUITY", "segments": [left["segment"], right["segment"]], "overlap": sorted(enemy_overlap)})
    return {"result": "DUNGEON_PROFILE_PASS" if not errors else "DUNGEON_PROFILE_FAIL", "errors": errors}
