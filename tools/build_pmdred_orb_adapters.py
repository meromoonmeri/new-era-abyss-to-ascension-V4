#!/usr/bin/env python3
"""Promote the six functional PMD Red orb adapters used by early dungeons.

PMD Red's early item tables contain directional orbs that do not have direct
PMDO item IDs.  This create-only builder adapts PMDO's native displacement
battle events and splits the upstream Scanner map status into the two original
Red contracts: item-only Révélorbe and character-only Radarorbe.

The source templates and item sprites are pinned to authenticated PMDO 0.8.12
DumpAsset data.  Existing tracked PMDO data is never overwritten.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from pmdred_early_dungeon import append_index_entries, dump_container

ROOT = Path(__file__).resolve().parents[1]
DUMPASSET_COMMIT = "9d864d1425f002b051e7a54fffc639988d8ef9c9"
DOC_PATH = ROOT / "docs/pmdred_eu/playable/common/orb_adapters.json"

ITEM_SPECS: dict[str, dict[str, Any]] = {
    "pmdred_permutorbe": {
        "template": "wand_switcher",
        "sprite": "Orb_Red",
        "name_en": "Switcher Orb",
        "name_fr": "Permutorbe",
        "desc_en": "Switches the user's position with the target's position.",
        "desc_fr": "Échange la position du lanceur avec celle de la cible.",
        "event": "PMDC.Dungeon.SwitcherEvent, PMDC",
    },
    "pmdred_soufflorbe": {
        "template": "wand_whirlwind",
        "sprite": "Orb_Blue",
        "name_en": "Blowback Orb",
        "name_fr": "Soufflorbe",
        "desc_en": "Knocks the target flying in a straight line.",
        "desc_fr": "Projette la cible en ligne droite.",
        "event": "PMDC.Dungeon.KnockBackEvent, PMDC",
        "distance": 10,
    },
    "pmdred_teleporbe": {
        "template": "wand_warp",
        "sprite": "Orb_Pink",
        "name_en": "Warp Orb",
        "name_fr": "Téléporbe",
        "desc_en": "Warps the target to another place on the floor.",
        "desc_fr": "Téléporte la cible ailleurs dans l'étage.",
        "event": "PMDC.Dungeon.RandomWarpEvent, PMDC",
    },
    "pmdred_revelorbe": {
        "template": "orb_scanner",
        "sprite": "Orb_DarkBlue",
        "name_en": "Scanner Orb",
        "name_fr": "Révélorbe",
        "desc_en": "Reveals only the locations of items on the floor.",
        "desc_fr": "Révèle uniquement l'emplacement des objets de l'étage.",
        "event": "PMDC.Dungeon.GiveMapStatusEvent, PMDC",
        "status": "pmdred_items_revealed",
    },
    "pmdred_radarorbe": {
        "template": "orb_scanner",
        "sprite": "Orb_Purple",
        "name_en": "Radar Orb",
        "name_fr": "Radarorbe",
        "desc_en": "Reveals only the locations of Pokémon on the floor.",
        "desc_fr": "Révèle uniquement l'emplacement des Pokémon de l'étage.",
        "event": "PMDC.Dungeon.GiveMapStatusEvent, PMDC",
        "status": "pmdred_characters_revealed",
    },
    "pmdred_projectorbe": {
        "template": "wand_whirlwind",
        "sprite": "Orb_Red",
        "name_en": "Hurl Orb",
        "name_fr": "Projectorbe",
        "desc_en": "Hurls the target until it strikes a wall or another Pokémon.",
        "desc_fr": "Projette la cible jusqu'à ce qu'elle heurte un mur ou un autre Pokémon.",
        "event": "PMDC.Dungeon.ThrowBackEvent, PMDC",
        "distance": 10,
        "collision_damage": 10,
    },
}

STATUS_SPECS = {
    "pmdred_items_revealed": {
        "name_en": "Items Revealed",
        "name_fr": "Objets révélés",
        "desc_en": "The team's map shows item locations only.",
        "desc_fr": "La carte de l'équipe indique uniquement les objets.",
        "refresh_event": "PMDC.Dungeon.SeeItemsEvent, PMDC",
    },
    "pmdred_characters_revealed": {
        "name_en": "Pokémon Revealed",
        "name_fr": "Pokémon révélés",
        "desc_en": "The team's map shows Pokémon locations only.",
        "desc_fr": "La carte de l'équipe indique uniquement les Pokémon.",
        "refresh_event": "PMDC.Dungeon.SeeCharsEvent, PMDC",
    },
}

SOURCE_HASHES = {
    "Data/Item/wand_switcher.json": "a0025809a04570d1dcfe5dea1183c36efdaf42c942262ac69b11094f1a62d70d",
    "Data/Item/wand_whirlwind.json": "51c668cb568c4988b31b62fa50243e5c2ead4ce62b8494a573f26c1a34c23096",
    "Data/Item/wand_warp.json": "2d1f22964525abcd5eb5b4a1b9488ccd7b05ad7043549a37d38ee8eeaaf0347b",
    "Data/Item/orb_scanner.json": "6f7568cf2b211022effa84eefa74775d901f187b13b378167f34d197f6ca63ed",
    ".runtime-cache/DumpAsset/Data/MapStatus/scanner.json": "2cc6b4c1b7c2d8724b34c580c7cfb9230e03406d8ffb202685a9b6910a39cfa7",
    ".runtime-cache/DumpAsset/Content/Item/Orb_Blue.dir": "150fd369848cb46f1d93fc4f96dd591026057ee7ddeeb2087da7ef118b513dd8",
    ".runtime-cache/DumpAsset/Content/Item/Orb_DarkBlue.dir": "bb291a001b548004e11c2a46b63841f924a7076098e32c3a51e7d8a4d165e580",
    ".runtime-cache/DumpAsset/Content/Item/Orb_Pink.dir": "3ec4c548469d527b8e8494ed06697d7cd576de1297ca1ded084842feec39de56",
    ".runtime-cache/DumpAsset/Content/Item/Orb_Purple.dir": "d1fcdac5449f4c48feed16552f324b9f79bc32859bfcb663848a459e77f22ceb",
    ".runtime-cache/DumpAsset/Content/Item/Orb_Red.dir": "54df7fe612cfc05b9b896dfc34feefb846fdd1ce81b37f0a5cc906e0bafb7912",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_container(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def validate_sources() -> None:
    for relative, expected in SOURCE_HASHES.items():
        path = ROOT / relative
        if not path.is_file():
            raise FileNotFoundError(f"required pinned source is absent: {relative}")
        actual = sha256(path)
        if actual != expected:
            raise RuntimeError(f"source hash gate failed for {relative}: {actual}")


def item_event(item: dict[str, Any]) -> dict[str, Any]:
    on_hits = item["Object"]["UseEvent"]["OnHits"]
    if len(on_hits) != 1:
        raise RuntimeError("orb adapter template must expose exactly one OnHits event")
    return on_hits[0]["Value"]


def build_item(item_id: str, spec: dict[str, Any]) -> dict[str, Any]:
    source = read_container(ROOT / f"Data/Item/{spec['template']}.json")
    item = copy.deepcopy(source)
    item["Version"] = "0.8.12.0"
    obj = item["Object"]
    obj["Name"] = {
        "DefaultText": spec["name_en"],
        "LocalTexts": {"fr": spec["name_fr"]},
    }
    obj["Desc"] = {
        "DefaultText": spec["desc_en"],
        "LocalTexts": {"fr": spec["desc_fr"]},
    }
    obj["Comment"] = (
        f"PMD Red EU functional adapter; source template {spec['template']}; "
        f"DumpAsset {DUMPASSET_COMMIT}."
    )
    obj["Sprite"] = spec["sprite"]
    obj["Icon"] = 9
    obj["SortCategory"] = 11
    obj["Price"] = 50
    obj["MaxStack"] = 0
    obj["ItemStates"] = [{"$type": "PMDC.Dungeon.OrbState, PMDC"}]

    event = item_event(item)
    if item_id == "pmdred_soufflorbe":
        event["Distance"] = spec["distance"]
    elif item_id in ("pmdred_revelorbe", "pmdred_radarorbe"):
        event["StatusID"] = spec["status"]
    elif item_id == "pmdred_projectorbe":
        event.clear()
        event.update({
            "$type": spec["event"],
            "Distance": spec["distance"],
            "HitEvent": {
                "$type": "PMDC.Dungeon.SpecificDamageEvent, PMDC",
                "Damage": spec["collision_damage"],
            },
        })

    if item_event(item).get("$type") != spec["event"]:
        raise RuntimeError(f"functional event mismatch while adapting {item_id}")
    return item


def build_status(status_id: str, spec: dict[str, Any]) -> dict[str, Any]:
    status = copy.deepcopy(read_container(
        ROOT / ".runtime-cache/DumpAsset/Data/MapStatus/scanner.json"
    ))
    obj = status["Object"]
    obj["Name"] = {
        "DefaultText": spec["name_en"],
        "LocalTexts": {"fr": spec["name_fr"]},
    }
    obj["Desc"] = {
        "DefaultText": spec["desc_en"],
        "LocalTexts": {"fr": spec["desc_fr"]},
    }
    obj["Comment"] = (
        "PMD Red EU split scanner contract; exposes exactly one map category; "
        f"DumpAsset {DUMPASSET_COMMIT}."
    )
    filtered = []
    for entry in obj["OnRefresh"]:
        base_type = entry["Value"].get("BaseEvent", {}).get("$type")
        if base_type == spec["refresh_event"]:
            filtered.append(entry)
    if len(filtered) != 1:
        raise RuntimeError(f"could not isolate {spec['refresh_event']} for {status_id}")
    obj["OnRefresh"] = filtered
    return status


def item_summary(item: dict[str, Any]) -> dict[str, Any]:
    obj = item["Object"]
    return {
        "$type": "RogueEssence.Data.ItemEntrySummary, RogueEssence",
        "Icon": obj["Icon"],
        "UsageType": obj["UsageType"],
        "States": [{
            "assembly": "PMDC, Version=0.8.12.0, Culture=neutral, PublicKeyToken=null",
            "type": "PMDC.Dungeon.OrbState",
        }],
        "MaxStack": obj["MaxStack"],
        "CannotDrop": obj["CannotDrop"],
        "BagEffect": obj["BagEffect"],
        "Name": copy.deepcopy(obj["Name"]),
        "Released": obj["Released"],
        "Comment": obj["Comment"],
        "SortOrder": obj["SortCategory"],
    }


def status_summary(status: dict[str, Any]) -> dict[str, Any]:
    obj = status["Object"]
    return {
        "Name": copy.deepcopy(obj["Name"]),
        "Released": obj["Released"],
        "Comment": obj["Comment"],
        "SortOrder": 0,
    }


def destination_paths() -> list[Path]:
    return [
        *[ROOT / f"Data/Item/{item_id}.json" for item_id in ITEM_SPECS],
        *[ROOT / f"Data/MapStatus/{status_id}.json" for status_id in STATUS_SPECS],
        *[ROOT / f"Content/Item/Orb_{name}.dir"
          for name in ("Blue", "DarkBlue", "Pink", "Purple", "Red")],
        DOC_PATH,
    ]


def validate_create_only() -> None:
    existing = [str(path.relative_to(ROOT)) for path in destination_paths() if path.exists()]
    if existing:
        raise FileExistsError("create-only destinations already exist: " + ", ".join(existing))
    for index_path, keys in (
        (ROOT / "Data/Item/index.idx", ITEM_SPECS),
        (ROOT / "Data/MapStatus/index.idx", STATUS_SPECS),
    ):
        index = read_container(index_path)["Object"]
        duplicates = [key for key in keys if key in index]
        if duplicates:
            raise FileExistsError(
                f"create-only index keys already exist in {index_path.relative_to(ROOT)}: "
                + ", ".join(duplicates)
            )


def validate_contracts(items: dict[str, dict[str, Any]], statuses: dict[str, dict[str, Any]]) -> None:
    for item_id, spec in ITEM_SPECS.items():
        obj = items[item_id]["Object"]
        if obj["Name"]["LocalTexts"].get("fr") != spec["name_fr"]:
            raise RuntimeError(f"French name contract failed for {item_id}")
        if obj["ItemStates"] != [{"$type": "PMDC.Dungeon.OrbState, PMDC"}]:
            raise RuntimeError(f"OrbState contract failed for {item_id}")
        if item_event(items[item_id]).get("$type") != spec["event"]:
            raise RuntimeError(f"event contract failed for {item_id}")
    exposed = {}
    for status_id, status in statuses.items():
        entries = status["Object"]["OnRefresh"]
        if len(entries) != 1:
            raise RuntimeError(f"split status exposes more than one category: {status_id}")
        exposed[status_id] = entries[0]["Value"]["BaseEvent"]["$type"]
    if exposed != {key: value["refresh_event"] for key, value in STATUS_SPECS.items()}:
        raise RuntimeError("split scanner status contracts overlap")


def verify_resume_outputs(
    items: dict[str, dict[str, Any]], statuses: dict[str, dict[str, Any]]
) -> None:
    """Accept only byte-semantic matches left by an interrupted create-only run."""
    for item_id, expected in items.items():
        path = ROOT / f"Data/Item/{item_id}.json"
        if not path.is_file() or read_container(path) != expected:
            raise RuntimeError(f"resume gate failed for {path.relative_to(ROOT)}")
    for status_id, expected in statuses.items():
        path = ROOT / f"Data/MapStatus/{status_id}.json"
        if not path.is_file() or read_container(path) != expected:
            raise RuntimeError(f"resume gate failed for {path.relative_to(ROOT)}")
    for name in ("Blue", "DarkBlue", "Pink", "Purple", "Red"):
        source = ROOT / f".runtime-cache/DumpAsset/Content/Item/Orb_{name}.dir"
        destination = ROOT / f"Content/Item/Orb_{name}.dir"
        if not destination.is_file() or sha256(destination) != sha256(source):
            raise RuntimeError(f"resume gate failed for {destination.relative_to(ROOT)}")


def append_missing_index_entries(path: Path, expected: dict[str, dict[str, Any]]) -> None:
    existing = read_container(path)["Object"]
    for key in set(existing).intersection(expected):
        if existing[key] != expected[key]:
            raise RuntimeError(f"resume index gate failed: {path.relative_to(ROOT)}:{key}")
    missing = {key: value for key, value in expected.items() if key not in existing}
    append_index_entries(path, missing)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--resume-exact", action="store_true",
        help="resume only an interrupted run whose existing outputs match exactly",
    )
    args = parser.parse_args()

    validate_sources()
    items = {item_id: build_item(item_id, spec) for item_id, spec in ITEM_SPECS.items()}
    statuses = {
        status_id: build_status(status_id, spec)
        for status_id, spec in STATUS_SPECS.items()
    }
    validate_contracts(items, statuses)

    if args.resume_exact:
        verify_resume_outputs(items, statuses)
    else:
        validate_create_only()
        for item_id, value in items.items():
            dump_container(ROOT / f"Data/Item/{item_id}.json", value)
        for status_id, value in statuses.items():
            dump_container(ROOT / f"Data/MapStatus/{status_id}.json", value)
        for name in ("Blue", "DarkBlue", "Pink", "Purple", "Red"):
            source = ROOT / f".runtime-cache/DumpAsset/Content/Item/Orb_{name}.dir"
            destination = ROOT / f"Content/Item/Orb_{name}.dir"
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, destination)

    append_missing_index_entries(
        ROOT / "Data/Item/index.idx",
        {item_id: item_summary(value) for item_id, value in items.items()},
    )
    append_missing_index_entries(
        ROOT / "Data/MapStatus/index.idx",
        {status_id: status_summary(value) for status_id, value in statuses.items()},
    )

    outputs = [path for path in destination_paths() if path != DOC_PATH]
    manifest = {
        "schema": "pmdred-eu-orb-adapters-v1",
        "dumpasset_commit": DUMPASSET_COMMIT,
        "create_only": True,
        "items": {
            item_id: {
                "french_name": spec["name_fr"],
                "event": spec["event"],
                "map_status": spec.get("status"),
            }
            for item_id, spec in ITEM_SPECS.items()
        },
        "map_status_contracts": {
            status_id: spec["refresh_event"] for status_id, spec in STATUS_SPECS.items()
        },
        "source_hashes": SOURCE_HASHES,
        "outputs": {
            str(path.relative_to(ROOT)): sha256(path) for path in outputs
        },
    }
    if DOC_PATH.exists():
        if not args.resume_exact or read_container(DOC_PATH) != manifest:
            raise RuntimeError(f"create-only manifest gate failed: {DOC_PATH.relative_to(ROOT)}")
    else:
        dump_container(DOC_PATH, manifest)
    print(json.dumps({
        "status": "PASS",
        "items": len(items),
        "map_statuses": len(statuses),
        "sprites": 5,
        "manifest": str(DOC_PATH.relative_to(ROOT)),
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
