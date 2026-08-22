"""Fixed Grounds (entrance / midpoint / end) and boss-scene resolution.

Rules implemented (per the project's canonical policy):
  * `entrance`, `mid` and the end scene are FIXED Grounds, never procedural;
  * if the dungeon owns a canonical end Ground, the final boss fight happens on
    that Ground — no separate arena is invented;
  * only when no usable end Ground exists is a dedicated `.rsmap` arena
    declared, which then has to exist in `Data/Map` before conversion.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional

ROOT = Path(__file__).resolve().parents[2]
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"

CANONICAL_GROUND = "canonical_ground"
DEDICATED_ARENA = "dedicated_arena"


@dataclass
class GroundCheck:
    entrance: str = ""
    mid: str = ""
    end: str = ""
    boss_mode: str = ""
    boss_ground: str = ""
    boss_map: str = ""
    ok: bool = True
    problems: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


def ground_exists(name: str) -> bool:
    return bool(name) and (GROUND_DIR / f"{name}.rsground").exists()


def map_exists(name: str) -> bool:
    return bool(name) and (MAP_DIR / f"{name}.rsmap").exists()


def check_grounds(definition) -> GroundCheck:
    grounds = definition.fixed_grounds or {}
    check = GroundCheck(entrance=grounds.get("entrance", ""), mid=grounds.get("mid", ""),
                        end=grounds.get("end", ""))

    for role in ("entrance", "mid", "end"):
        name = grounds.get(role, "")
        if not name:
            check.notes.append(f"no fixed '{role}' Ground declared")
            continue
        if not ground_exists(name):
            check.problems.append(f"{role} Ground '{name}.rsground' missing from Data/Ground")

    midpoint = definition.midpoint or {}
    if midpoint:
        template = midpoint.get("template", "")
        if template and not ground_exists(template):
            check.problems.append(f"midpoint template Ground '{template}' missing")
        if not midpoint.get("retexture"):
            check.problems.append("midpoint must declare 'retexture' (biome tileset of this dungeon)")
        if not grounds.get("mid"):
            check.notes.append(
                f"midpoint Ground still to be produced: template '{midpoint.get('template', '?')}' "
                f"retextured with '{midpoint.get('retexture', '?')}' "
                f"(floor {midpoint.get('floor', '?')}) — never generated procedurally")
        for feature in ("checkpoint", "heal", "save", "rest"):
            if not midpoint.get(feature, False):
                check.notes.append(f"midpoint does not provide '{feature}'")

    boss = definition.boss or {}
    check.boss_mode = boss.get("mode", "")
    if boss:
        if check.boss_mode == CANONICAL_GROUND:
            ground = boss.get("ground") or grounds.get("end", "")
            check.boss_ground = ground
            if not ground_exists(ground):
                check.problems.append(f"boss Ground '{ground}' declared canonical but missing")
            else:
                check.notes.append(f"final battle stays on the canonical end Ground '{ground}' "
                                   "(no separate arena created)")
            arena = boss.get("map", "")
            if arena:
                check.boss_map = arena
                if not map_exists(arena):
                    check.problems.append(f"boss scene map '{arena}.rsmap' declared but missing")
                else:
                    check.notes.append(f"scene source of truth: {arena}.rsmap matches the end Ground")
        elif check.boss_mode == DEDICATED_ARENA:
            arena = boss.get("map", "")
            check.boss_map = arena
            if not map_exists(arena):
                check.problems.append(
                    f"dedicated arena '{arena}.rsmap' must exist in Data/Map before conversion")
            ground = boss.get("ground", "")
            check.boss_ground = ground
            if ground and not ground_exists(ground):
                check.notes.append(f"arena Ground '{ground}' not converted yet")
        else:
            check.problems.append(
                f"boss.mode must be '{CANONICAL_GROUND}' or '{DEDICATED_ARENA}', got '{check.boss_mode}'")

    for miniboss in definition.minibosses or []:
        map_id = miniboss.get("map", "")
        if map_id and not map_exists(map_id):
            check.problems.append(f"miniboss arena '{map_id}.rsmap' missing from Data/Map")

    check.ok = not check.problems
    return check
