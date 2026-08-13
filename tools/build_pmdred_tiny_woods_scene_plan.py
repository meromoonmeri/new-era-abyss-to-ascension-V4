#!/usr/bin/env python3
"""Build the executable neutral-voice French plan for Tiny Woods scenes.

Every line is selected by authenticated EU-ROM text pointer.  D0 grammatical
alternatives remain in the complete scene graph; this first executable plan
uses each D1/default branch, which is canonical when no Red talk-kind mapping
exists for a PMDO partner profile.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
GRAPH = ROOT / "docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json"
GRAPH_SHA256 = "6cc155b0302602e7edb223243a43e65aa3b0b3ff296df7742e79686db07ee1d1"

SCENES: dict[str, list[tuple[str, str]]] = {
    "d01p01_g1": [
        ("narrator", "0x084CBACC"), ("narrator", "0x084CBA64"),
        ("narrator", "0x084CB9B8"), ("narrator", "0x084CB90C"),
        ("narrator", "0x084CB740"), ("unknown", "0x084CB724"),
        ("unknown", "0x084CB6FC"), ("unknown", "0x084CB6B8"),
        ("partner", "0x084CB584"), ("partner", "0x084CB490"),
        ("partner", "0x084CF5B4"), ("hero_thought", "0x084CF554"),
        ("partner", "0x084CF170"), ("partner", "0x084CEF10"),
        ("partner", "0x084CEB24"), ("partner", "0x084CE694"),
        ("partner", "0x084CE59C"), ("hero_thought", "0x084CE52C"),
        ("hero_thought", "0x084CE4A8"), ("hero_thought", "0x084CE3B8"),
        ("partner", "0x084CE190"), ("partner", "0x084CE0E4"),
        ("hero_thought", "0x084CE018"), ("partner", "0x084CDE20"),
        ("partner", "0x084CDC84"), ("butterfree", "0x084CDBD8"),
        ("partner", "0x084CDA4C"), ("partner", "0x084CD998"),
        ("butterfree", "0x084CD818"), ("partner", "0x084CD7EC"),
        ("butterfree", "0x084CD680"), ("butterfree", "0x084CD58C"),
        ("butterfree", "0x084CD424"), ("partner", "0x084CD318"),
        ("butterfree", "0x084CD15C"), ("butterfree", "0x084CCF88"),
        ("butterfree", "0x084CCE94"), ("partner", "0x084CCC60"),
    ],
    "d01p01_g2": [
        ("hero", "0x084D0060"), ("butterfree", "0x084D1624"),
        ("partner", "0x084D15D4"), ("butterfree", "0x084D158C"),
        ("butterfree", "0x084D1484"), ("partner", "0x084D11F4"),
        ("partner", "0x084D0DD4"), ("partner", "0x084D0D04"),
        ("butterfree", "0x084D0BE0"), ("partner", "0x084D08D8"),
        ("partner", "0x084D0824"),
    ],
    "d01p02_g1": [
        ("caterpie", "0x084D5478"), ("caterpie", "0x084D53D0"),
        ("partner", "0x084D51F4"), ("caterpie", "0x084D51D4"),
        ("partner", "0x084D50E4"), ("caterpie", "0x084D50BC"),
    ],
    "d01p01_g3": [
        ("butterfree", "0x084D42C4"), ("partner", "0x084D3D58"),
        ("partner", "0x084D3C30"), ("butterfree", "0x084D3B44"),
        ("partner", "0x084D3A5C"), ("partner", "0x084D39F0"),
        ("caterpie", "0x084D3974"), ("hero_thought", "0x084D3894"),
        ("hero_thought", "0x084D375C"), ("hero_thought", "0x084D35F4"),
        ("hero_thought", "0x084D349C"), ("caterpie", "0x084D341C"),
        ("butterfree", "0x084D3220"), ("butterfree", "0x084D3180"),
        ("partner", "0x084D3050"), ("partner", "0x084D2DDC"),
        ("partner", "0x084D2B78"), ("hero_thought", "0x084D2B30"),
        ("partner", "0x084D27D0"),
    ],
}

SCENE_META = {
    "d01p01_g1": {
        "music": ["stop", "PMD Red - Heartwarming.ogg", "fadeout", "PMD Red - There's Trouble.ogg"],
        "actors": {"hero": [200, 196], "partner": [232, 196], "butterfree_entry": [72, 188]},
        "choreography": ["hero_sleep_wake", "hero_look_around", "butterfree_enters", "party_turns_to_butterfree", "party_exits_west"],
        "destination": "tiny_woods:0",
    },
    "d01p01_g2": {
        "music": ["stop"],
        "actors": {"hero": [200, 196], "partner": [232, 196], "butterfree": [216, 172]},
        "choreography": ["hero_partner_sleep_wake", "look_around", "turn_to_butterfree", "party_exits_west"],
        "destination": "tiny_woods:0",
    },
    "d01p02_g1": {
        "music": ["PMD Red - In the Depths of the Pit.ogg"],
        "actors": {"hero": [164, 276], "partner": [196, 276], "caterpie": [180, 148]},
        "choreography": ["caterpie_cry", "hero_partner_approach", "caterpie_turns_south", "caterpie_happy"],
        "destination": "d01p01:g3",
    },
    "d01p01_g3": {
        "music": ["PMD Red - A Successful Rescue.ogg", "fadeout"],
        "actors": {"hero": [200, 196], "partner": [232, 196], "butterfree": [232, 172], "caterpie": [200, 172]},
        "choreography": ["caterpie_admires_hero", "reward_sequence", "butterfree_caterpie_exit_east", "partner_invites_hero", "party_exits_east"],
        "destination": "post_tiny_woods_continuation_pending",
    },
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pmdo_text(value: str) -> str:
    value = value.replace("~27", "'").replace("~2c", ",")
    value = value.replace("#W", "[pause=30]").replace("#+", "")
    value = value.replace("#C4", "").replace("#R", "")
    value = value.replace("$n0", "{hero}").replace("$n1", "{partner}")
    value = value.replace("$n3", "Chenipan").replace("$m0", "{hero_species}")
    value = re.sub(r"#(?:C|R|\+)[0-9]*", "", value)
    return value.strip()


def build() -> dict[str, Any]:
    if sha256(GRAPH) != GRAPH_SHA256:
        raise ValueError("authenticated Tiny Woods EU scene graph hash differs")
    graph = json.loads(GRAPH.read_text())
    text_by_pointer: dict[str, dict[str, Any]] = {}
    owner_by_pointer: dict[str, str] = {}
    for candidate in graph["candidates"]:
        for block in candidate["text_blocks"]:
            if block["address"] in text_by_pointer:
                raise ValueError(f"duplicate EU text pointer {block['address']}")
            text_by_pointer[block["address"]] = block
        for script in candidate["scripts"]:
            for command in script["commands"]:
                pointer = command.get("text_block")
                if pointer:
                    owner_by_pointer[pointer] = script["name"]

    scenes: dict[str, Any] = {}
    selected: set[str] = set()
    sequence = 0
    for scene, rows in SCENES.items():
        lines = []
        for speaker, pointer in rows:
            if pointer not in text_by_pointer or pointer not in owner_by_pointer:
                raise ValueError(f"{scene}: unauthenticated text pointer {pointer}")
            if pointer in selected:
                raise ValueError(f"text pointer selected twice: {pointer}")
            selected.add(pointer)
            sequence += 1
            block = text_by_pointer[pointer]
            french = block["languages"]["fr"]
            lines.append({
                "sequence": sequence,
                "speaker": speaker,
                "pointer": pointer,
                "owner_script": owner_by_pointer[pointer],
                "raw_hex": french["raw_hex"],
                "raw_text": french["text"],
                "pmdo_text": pmdo_text(french["text"]),
            })
        scenes[scene] = {**SCENE_META[scene], "dialogue_count": len(lines), "dialogue": lines}
    if sequence != 74:
        raise ValueError(f"selected neutral scene line count differs: {sequence}")
    return {
        "schema": "new-era.pmdred-eu-tiny-woods-scene-plan.v1",
        "authority": {
            "region": "EU",
            "rom_sha256": graph["authority"]["rom_sha256"],
            "scene_graph": str(GRAPH.relative_to(ROOT)),
            "scene_graph_sha256": GRAPH_SHA256,
        },
        "variant_policy": {
            "selected": "D1/default neutral Red branch",
            "reason": "PMDO has no authenticated mapping for Red PARTNER_TALK_KIND; all alternatives remain in eu_scene_graph.json",
            "invented_text_count": 0,
        },
        "scenes": scenes,
        "totals": {
            "scene_count": len(scenes),
            "selected_french_dialogue_count": sequence,
            "authenticated_french_text_pool": graph["totals"]["french_text_count"],
        },
        "validation": {"status": "pass"},
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise FileExistsError(f"refusing to overwrite scene plan: {args.output}")
    plan = build()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(plan, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(
        "TINY_WOODS_SCENE_PLAN_PASS "
        f"scenes={plan['totals']['scene_count']} "
        f"dialogue={plan['totals']['selected_french_dialogue_count']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
