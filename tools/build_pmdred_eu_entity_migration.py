#!/usr/bin/env python3
"""Build narrow, hash-gated PMD Red EU Ground entity migrations.

The authenticated converter owns visual, palette, animation, and collision data.
A migration policy may preserve only additive project Markers and Spawners from
an occupied historical Ground.  The complete historical files remain separate
provenance and are never treated as canonical ROM proof.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any


A02P01_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a02p01",
    "historical_ground_sha256": "2b6d651a9fd7d25f159f50fc9d1cd6fa7006899988822eda217f4bf60923aad7",
    "historical_tile": "Content/Tile/A02p01_Base.tile",
    "historical_tile_sha256": "7f80a67d0d6823541dbed67e77b68d1d005eb09b53d79a0d3a66e7a1bae027e3",
    "canonical_ground_sha256": "4cb74d9c04c7473359f8b8360caac80df825dff91775917dbfe0d5dd201fc389",
    "canonical_tile_sha256": "7f80a67d0d6823541dbed67e77b68d1d005eb09b53d79a0d3a66e7a1bae027e3",
    "integrated_ground_sha256": "016551d87ddf6b5556a4f9181ec8061a5af2df1bda97e3f43e376f3dc64dc3b2",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {
        "Markers": ["Main_Entrance_Marker", "Cutscene_Marker"],
        "Spawners": ["TEAMMATE_1", "TEAMMATE_2", "TEAMMATE_3"],
    },
    "historical_reserves": {
        "RESERVE/red_grounds/a02p01.rsground": "51e08f36ecc2975ba6ca9b0ae4fc2590400eb559608bf7f38246a7168e8aa9fb",
        "RESERVE/red_tiles/a02p01_Base.tile": "7f80a67d0d6823541dbed67e77b68d1d005eb09b53d79a0d3a66e7a1bae027e3",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a02p01/init.lua": "e74cd013a6f7f0d2273e8eccded5aebb8b2ee89e7e31b869cefc8cb33f3af388",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a02p01.lua": "bd8752a9ccb27350b6bcb2e588818f3e98410a40fd0b1aa8f1ac25dabf684ec9",
    },
}

A02P02_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a02p02",
    "historical_ground_sha256": "dc60ccc9b2d714a91a725a86397b6af3b4aadd6dfe40aaef981423794c7d6083",
    "historical_tile": "Content/Tile/A02p02_Base.tile",
    "historical_tile_sha256": "9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904",
    "canonical_ground_sha256": "4aa76d598b3171a513f6a4ba8d17b71ef5403f725278c24c49ff9e02d41bba82",
    "canonical_tile_sha256": "9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904",
    "integrated_ground_sha256": "f9aac6971906cbb93eab368bcd91bb4a9723180bd854d17b19811474c3484a3c",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {
        "Markers": ["Main_Entrance_Marker", "Cutscene_Marker"],
        "Spawners": ["TEAMMATE_1"],
    },
    "historical_reserves": {
        "RESERVE/red_grounds/a02p02.rsground": "6b373ccc45b65ffabfb3d8df2fda372d96bd0f8afca3516aaf7c713faee4fd31",
        "RESERVE/red_tiles/a02p02_Base.tile": "9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a02p02/init.lua": "fdaa6bbec4f7bcf9c2031e1b1f02a14dec4080e330f5cedc4d8ec8247dacc6a4",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a02p02.lua": "6721f3b91720060db21cad2b13f014779d44f9370d65e0c6ae851fc004e90a85",
    },
}

A02P03_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a02p03",
    "historical_ground_sha256": "7f91bdf9d4ff3574ee00ffe8fcacd30aae83bc9bdec8fb2c18b0135c06ba456e",
    "historical_tile": "Content/Tile/A02p03_Base.tile",
    "historical_tile_sha256": "94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b",
    "canonical_ground_sha256": "b6cfa6d2cfc5e550cf85f23f321af8ffe5c862b11a8332ec6d1444dd84c32bbc",
    "canonical_tile_sha256": "94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b",
    "integrated_ground_sha256": "f939c874590008a7db4217f7fd77f65d548a32ba5ccfa0701e77a0da070982a3",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {
        "Markers": ["Main_Entrance_Marker", "Cutscene_Marker"],
        "Spawners": ["TEAMMATE_1"],
    },
    "historical_reserves": {
        "RESERVE/red_grounds/a02p03.rsground": "3904f90e0454b5863c74aab0d6455e09253e7bafdb747bbc816cefa1f2b20191",
        "RESERVE/red_tiles/a02p03_Base.tile": "94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a02p03/init.lua": "e058192f2e857701e3616a4a93fb2fc6bf4185b5812e28820dbbc196ee415405",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a02p03.lua": "8d541ac52cc8325f4ad34cef09525da3f02a4bd630eb85ec332b806b200bb387",
    },
}

A02P04_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a02p04",
    "historical_ground_sha256": "b792870dc610761c89fe9fd5c26fcee343714311b04d9a17a52521fa5c9f738f",
    "historical_tile": "Content/Tile/A02p04_Base.tile",
    "historical_tile_sha256": "2270fe64e93dca7b7c15dca06c8e87e7d4b1aeae4ff558ad9c86853207eb7ea0",
    "canonical_ground_sha256": "15d18cb20ccaadb38887e2c3c722e2b5983d3184f1409960bed15c951451a209",
    "canonical_tile_sha256": "2270fe64e93dca7b7c15dca06c8e87e7d4b1aeae4ff558ad9c86853207eb7ea0",
    "integrated_ground_sha256": "9add5df8383ddb077c832ddae9e06287ad29cd6db695437b7d1f655af8a2c790",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {
        "Markers": ["Main_Entrance_Marker", "Cutscene_Marker"],
        "Spawners": ["TEAMMATE_1"],
    },
    "historical_reserves": {
        "RESERVE/red_grounds/a02p04.rsground": "5a91344deb7e0c8682aa421486d603592d53d12df5b8c8476ffb1b026f88daed",
        "RESERVE/red_tiles/a02p04_Base.tile": "2270fe64e93dca7b7c15dca06c8e87e7d4b1aeae4ff558ad9c86853207eb7ea0",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a02p04/init.lua": "b280ed09c6c7ba25586a680e1db74562b9c4f0158e2fdedacb150b75965523a0",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a02p04.lua": "2c827064a8ee97a8b20ef57ce645d2566a6f5cd9aa255efbf4497b5ac1111f70",
    },
}

A03P01_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a03p01",
    "historical_ground_sha256": "b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc",
    "historical_tile": "Content/Tile/a03p01_Base.tile",
    "historical_tile_sha256": "4b8f2b3729a32685206ee5c37bc346e53b83685da4a9bdb6964bbb4d1f4642b0",
    "canonical_ground_sha256": "36b389989c2ed916b95bc79aa5236a03c42911d81116d8f4f3c1f59679f1c3b3",
    "canonical_tile_sha256": "877fd56336e417ed7690db8baeeedf465657eaf37a345d2010fa356333bf8cf4",
    "integrated_ground_sha256": "b0217e3fa2963faf0ee340c639b80d8a2cd33f7c3a8a585db21f8eecc0be0beb",
    "tile_migration_mode": "reserve_and_replace_canonical_identity",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {"Markers": ["Main_Entrance_Marker"], "Spawners": []},
    "historical_reserves": {
        "RESERVE/red_grounds/a03p01.rsground": "b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc",
        "RESERVE/red_tiles/a03p01_Base.tile": "877fd56336e417ed7690db8baeeedf465657eaf37a345d2010fa356333bf8cf4",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a03p01/init.lua": "314759f57c7e9fa38905193d94e8c8e377b7f137ff7bf9c7adbdb4e63928a64e",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a03p01.lua": "0a46bb9f145b82db1e5a7bfdf67473ab4e910271a029740f182034e18492c5c3",
    },
}

A03P02_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a03p02",
    "historical_ground_sha256": "ca7278d2c16e3843a089ab20904b7c3b5d85542d24987573604ffe12e83c9ff3",
    "historical_tile": "Content/Tile/a03p02_Base.tile",
    "historical_tile_sha256": "5d492bd32d1c0fbebce449bf85624865d333eb5743b0acb5adacf5ce7fb9cf2a",
    "canonical_ground_sha256": "1802dc409408b7ae85f12ba5e318babe74b232632c3b055fc7a252586b51a463",
    "canonical_tile_sha256": "076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c",
    "integrated_ground_sha256": "4c685a550e2cc6a9cf58f0b640ed3f206700639ac9dd0c39e1a35d1d8c16634c",
    "tile_migration_mode": "reserve_and_replace_canonical_identity",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {"Markers": ["Main_Entrance_Marker"], "Spawners": []},
    "historical_reserves": {
        "RESERVE/red_grounds/a03p02.rsground": "62afb6275c527e997ec5225505328559f14a9671fd07a684b8b7b6de1d1bc749",
        "RESERVE/red_tiles/a03p02_Base.tile": "076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a03p02/init.lua": "9d72fb9f94fa6e291a4e48e06c74e6b470a583496b1169c3dc42fbeb27632b6b",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a03p02.lua": "f6f59a474c70da53edf6339026225c8610a98d38cf528a89c1be3838136c0492",
    },
}

A03P03_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a03p03",
    "historical_ground_sha256": "056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae",
    "historical_tile": "Content/Tile/a03p03_Base.tile",
    "historical_tile_sha256": "314207f03b49c0908a801ee10ee0cbcb29c700d8500539444625e56da05489f9",
    "canonical_ground_sha256": "4025e48c9cf24be8a321da31115e933b05f994b89bcf01f827f4c46af3a8d22a",
    "canonical_tile_sha256": "fa9b2e916bf28714e4614964f7589d6ef83e81754ee358c147c09c975a7a5281",
    "integrated_ground_sha256": "8a0124252466f4adcdbfad6ab2097920e34d863c663e141772a034e602039589",
    "tile_migration_mode": "reserve_and_replace_canonical_identity",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {"Markers": ["Main_Entrance_Marker"], "Spawners": []},
    "historical_reserves": {
        "RESERVE/red_grounds/a03p03.rsground": "056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae",
        "RESERVE/red_tiles/a03p03_Base.tile": "fa9b2e916bf28714e4614964f7589d6ef83e81754ee358c147c09c975a7a5281",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a03p03/init.lua": "700409fe2421b0bbbeaf7ec4e47bd78ae7ccffd0ad2525bef41f35c5946fc1a1",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a03p03.lua": "8ce94deaded0feca1efdc80a8f19cb6a7710877a2f518aa668e61146d6e56d70",
    },
}

A04P01_POLICY: dict[str, Any] = {
    "schema": "new-era.pmdred-eu-occupied-ground-migration-policy.v1",
    "ground": "a04p01",
    "historical_ground_sha256": "c44840e6dca2e1462f98b63204f4d60f5b6a86304b04c81faa379ae416039a5b",
    "historical_tile": "Content/Tile/a04p01_Base.tile",
    "historical_tile_sha256": "b376149a921c935a8f803b36559627302fb0fb5f00832a602d5c83a54af28adf",
    "canonical_ground_sha256": "b511cfe2a90b46a3c01ba4809582bfcef63aff4898b73ff5970e8c5d08086c92",
    "canonical_tile_sha256": "b376149a921c935a8f803b36559627302fb0fb5f00832a602d5c83a54af28adf",
    "integrated_ground_sha256": "c6b2b6938f37f2c5f4d10f0686c7b7734aab500144ed036ecc5eeee53c79d6af",
    "tile_migration_mode": "reserve_and_replace_canonical_identity",
    "preserved_fields": ["Markers", "Spawners"],
    "expected_entities": {
        "Markers": ["Main_Entrance_Marker", "Boss_Marker", "PNJ_Marker_1", "Cutscene_Marker"],
        "Spawners": ["TEAMMATE_1", "TEAMMATE_2"],
    },
    "historical_reserves": {
        "RESERVE/red_grounds/a04p01.rsground": "8ca6d9d60743b11b98c8d30fabd47c8108871187a2018f8f7df678ef7162f230",
        "RESERVE/red_tiles/a04p01_Base.tile": "98bfcfafcfde3d0abbff80861148c34699ba506de5f0aa0c10697a791166908d",
    },
    "related_scripts": {
        "Data/Script/halcyon/ground/a04p01/init.lua": "4d6791577c184d7a00207fce75ddf649072a44ec252ec7751e2acedad968159b",
        "Data/Script/halcyon/FugitiveArc.lua": "cf9ffe31cb90c7301808d920522463cc66e0e7349f74a1c8fdfca061c1621519",
        "Data/Script/halcyon/FugitiveCinematics.lua": "1fea1611e0f9636f6fd8ca6268ba9d2d676972f3b153162b694950c7f32eb484",
        "Data/Script/halcyon/arc_fugitif/scene/a04p01.lua": "55ed095da6d27e089431bf9a28b9e9e4cf21d92b4fff121e93697cbf492bb8f4",
    },
}

MIGRATION_POLICIES = {
    policy["ground"]: policy
    for policy in (
        A02P01_POLICY, A02P02_POLICY, A02P03_POLICY, A02P04_POLICY,
        A03P01_POLICY, A03P02_POLICY, A03P03_POLICY, A04P01_POLICY,
    )
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_json(value: Any) -> str:
    encoded = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json_bom(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\ufeff" + json.dumps(value, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


def require_hash(path: Path, expected: str, label: str) -> None:
    if not path.is_file():
        raise RuntimeError(f"{label} is absent: {path}")
    actual = sha256_file(path)
    if actual != expected:
        raise RuntimeError(f"{label} hash gate failed: expected {expected}, got {actual}")


def entity_names(layer: dict[str, Any], field: str) -> list[str]:
    if field == "Markers":
        return [item.get("EntName") for item in layer[field]]
    return [item.get("EntName") for item in layer[field]]


def validate_collider(entity: dict[str, Any], width: int, height: int, label: str) -> dict[str, int]:
    collider = entity.get("Collider")
    if not isinstance(collider, dict):
        raise RuntimeError(f"{label} has no serialized Collider")
    values = {name: collider.get(name) for name in ("X", "Y", "Width", "Height")}
    if not all(isinstance(value, int) for value in values.values()):
        raise RuntimeError(f"{label} Collider is not integral: {values}")
    if not (
        values["X"] >= 0
        and values["Y"] >= 0
        and values["Width"] > 0
        and values["Height"] > 0
        and values["X"] + values["Width"] <= width
        and values["Y"] + values["Height"] <= height
    ):
        raise RuntimeError(f"{label} Collider is outside canonical geometry: {values}")
    return values


def integrate_additive_entities(
    historical: dict[str, Any], canonical: dict[str, Any], policy: dict[str, Any]
) -> tuple[dict[str, Any], dict[str, Any]]:
    """Return canonical data with only exact historical Markers/Spawners appended."""
    if policy.get("preserved_fields") != ["Markers", "Spawners"]:
        raise RuntimeError("migration policy may preserve only Markers and Spawners")
    historical_layers = historical.get("Object", {}).get("Entities")
    canonical_layers = canonical.get("Object", {}).get("Entities")
    if not isinstance(historical_layers, list) or not isinstance(canonical_layers, list):
        raise RuntimeError("Ground entity layers are not serialized lists")
    if len(historical_layers) != len(canonical_layers) or len(historical_layers) != 1:
        raise RuntimeError("migration requires exactly one corresponding entity layer")

    old_layer = historical_layers[0]
    base_layer = canonical_layers[0]
    for field in ("MapChars", "GroundObjects", "Markers", "Spawners"):
        if not isinstance(old_layer.get(field), list) or not isinstance(base_layer.get(field), list):
            raise RuntimeError(f"entity field {field} is not a list")
    if old_layer["MapChars"] or old_layer["GroundObjects"]:
        raise RuntimeError("migration refuses historical MapChars or GroundObjects")
    if base_layer["MapChars"] or base_layer["GroundObjects"] or base_layer["Markers"] or base_layer["Spawners"]:
        raise RuntimeError("migration refuses to replace, reorder, or merge canonical entities")
    for field in ("Markers", "Spawners"):
        observed = entity_names(old_layer, field)
        if observed != policy["expected_entities"][field]:
            raise RuntimeError(
                f"historical {field} identity gate failed: expected "
                f"{policy['expected_entities'][field]}, got {observed}"
            )

    obstacles = canonical.get("Object", {}).get("obstacles")
    if not isinstance(obstacles, list) or not obstacles or not isinstance(obstacles[0], list):
        raise RuntimeError("canonical collision geometry is absent")
    pixel_width = len(obstacles) * 8
    pixel_height = len(obstacles[0]) * 8
    colliders: dict[str, dict[str, int]] = {}
    entity_payload_hashes: dict[str, str] = {}
    for field in ("Markers", "Spawners"):
        for entity in old_layer[field]:
            name = entity["EntName"]
            colliders[name] = validate_collider(entity, pixel_width, pixel_height, name)
            entity_payload_hashes[name] = sha256_json(entity)

    integrated = copy.deepcopy(canonical)
    integrated_layer = integrated["Object"]["Entities"][0]
    integrated_layer["Markers"] = copy.deepcopy(old_layer["Markers"])
    integrated_layer["Spawners"] = copy.deepcopy(old_layer["Spawners"])

    normalized = copy.deepcopy(integrated)
    normalized["Object"]["Entities"][0]["Markers"] = []
    normalized["Object"]["Entities"][0]["Spawners"] = []
    if normalized != canonical:
        raise RuntimeError("integrated Ground differs outside additive Markers/Spawners")
    if integrated_layer["Markers"] != old_layer["Markers"] or integrated_layer["Spawners"] != old_layer["Spawners"]:
        raise RuntimeError("historical entity payloads changed during integration")

    proof = {
        "mode": "additive_markers_spawners_only",
        "canonical_entity_layer_count": len(canonical_layers),
        "preserved_entity_layer_count": len(historical_layers),
        "entity_counts": {
            "markers": len(old_layer["Markers"]),
            "spawners": len(old_layer["Spawners"]),
            "map_characters": 0,
            "ground_objects": 0,
        },
        "ordered_names": {
            "markers": entity_names(old_layer, "Markers"),
            "spawners": entity_names(old_layer, "Spawners"),
        },
        "entity_payload_sha256": entity_payload_hashes,
        "colliders": colliders,
        "canonical_dimensions_pixels": [pixel_width, pixel_height],
        "all_colliders_within_canonical_geometry": True,
        "all_entity_payloads_preserved_byte_for_byte_at_json_value_level": True,
        "canonical_data_unchanged_outside_additive_entities": True,
    }
    return integrated, proof


def locate_historical_ground(root: Path, policy: dict[str, Any]) -> Path:
    ground = policy["ground"]
    active = root / f"Data/Ground/{ground}.rsground"
    reserve = root / f"RESERVE/pmdred_pre_promotion/{ground}/{ground}.rsground"
    for candidate in (active, reserve):
        if candidate.is_file() and sha256_file(candidate) == policy["historical_ground_sha256"]:
            return candidate
    raise RuntimeError(
        f"no exact historical Ground source for {ground}; checked active destination and durable reserve"
    )


def build_migration(
    root: Path,
    ground: str,
    output: Path,
    *,
    policy: dict[str, Any] | None = None,
    historical_ground: Path | None = None,
    historical_tile: Path | None = None,
    canonical_root: Path | None = None,
) -> dict[str, Any]:
    policy = copy.deepcopy(policy or MIGRATION_POLICIES.get(ground))
    if not policy or policy.get("ground") != ground:
        raise RuntimeError(f"no entity-aware migration policy for {ground}")
    if output.exists():
        raise FileExistsError(f"create-only migration output exists: {output}")
    canonical_root = canonical_root or root / ".runtime-cache/pmdred-eu-remaining-regenerated-v201"
    historical_ground = historical_ground or locate_historical_ground(root, policy)
    historical_tile = historical_tile or root / policy["historical_tile"]
    canonical_ground = canonical_root / f"grounds/{ground}.rsground"
    canonical_tile = canonical_root / f"tiles/{ground}_Base.tile"
    conversion_report = canonical_root / "conversion_report.json"
    canonical_tile_identity = f"Content/Tile/{ground}_Base.tile"
    tile_migration_mode = policy.get(
        "tile_migration_mode", "retain_distinct_historical_identity"
    )
    if tile_migration_mode not in {
        "retain_distinct_historical_identity",
        "reserve_and_replace_canonical_identity",
    }:
        raise RuntimeError(f"unsupported historical tile migration mode: {tile_migration_mode}")
    same_tile_identity = policy["historical_tile"] == canonical_tile_identity
    if same_tile_identity != (tile_migration_mode == "reserve_and_replace_canonical_identity"):
        raise RuntimeError(
            "historical tile identity does not match its migration mode: "
            f"{policy['historical_tile']} / {tile_migration_mode}"
        )

    require_hash(historical_ground, policy["historical_ground_sha256"], "historical Ground")
    require_hash(historical_tile, policy["historical_tile_sha256"], "historical tile")
    require_hash(canonical_ground, policy["canonical_ground_sha256"], "authenticated canonical Ground")
    require_hash(canonical_tile, policy["canonical_tile_sha256"], "authenticated canonical tile")
    if not conversion_report.is_file():
        raise RuntimeError(f"authenticated conversion report is absent: {conversion_report}")
    reserve_provenance: dict[str, str] = {}
    for relative, expected in policy.get("historical_reserves", {}).items():
        path = root / relative
        require_hash(path, expected, f"historical reserve {relative}")
        reserve_provenance[relative] = expected
    script_provenance: dict[str, str] = {}
    for relative, expected in policy.get("related_scripts", {}).items():
        path = root / relative
        require_hash(path, expected, f"related script {relative}")
        script_provenance[relative] = expected

    historical = read_json(historical_ground)
    canonical = read_json(canonical_ground)
    integrated, entity_proof = integrate_additive_entities(historical, canonical, policy)

    output_ground = output / f"grounds/{ground}.rsground"
    output_tile = output / f"tiles/{ground}_Base.tile"
    write_json_bom(output_ground, integrated)
    output_tile.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(canonical_tile, output_tile)
    shutil.copyfile(conversion_report, output / "conversion_report.json")

    # Independently prove the serialized output by normalizing the two allowed fields.
    serialized = read_json(output_ground)
    normalized = copy.deepcopy(serialized)
    normalized["Object"]["Entities"][0]["Markers"] = []
    normalized["Object"]["Entities"][0]["Spawners"] = []
    if normalized != canonical:
        raise RuntimeError("serialized migration changed canonical data outside entities")
    if serialized["Object"]["Entities"][0]["Markers"] != historical["Object"]["Entities"][0]["Markers"]:
        raise RuntimeError("serialized migration changed historical Markers")
    if serialized["Object"]["Entities"][0]["Spawners"] != historical["Object"]["Entities"][0]["Spawners"]:
        raise RuntimeError("serialized migration changed historical Spawners")
    integrated_hash = sha256_file(output_ground)
    expected_integrated = policy.get("integrated_ground_sha256")
    if expected_integrated is not None and integrated_hash != expected_integrated:
        raise RuntimeError(
            f"integrated Ground hash gate failed: expected {expected_integrated}, got {integrated_hash}"
        )

    def display_path(path: Path) -> str:
        try:
            return str(path.relative_to(root))
        except ValueError:
            return str(path)

    manifest = {
        "schema": "new-era.pmdred-eu-occupied-ground-migration.v1",
        "ground": ground,
        "result": "PASS_HASH_GATED_ENTITY_INTEGRATION",
        "policy_schema": policy["schema"],
        "historical": {
            "ground": display_path(historical_ground),
            "ground_sha256": policy["historical_ground_sha256"],
            "tile": display_path(historical_tile),
            "tile_sha256": policy["historical_tile_sha256"],
            "complete_historical_ground_reserved_before_active_replacement_required": True,
            "complete_historical_tile_reserved_before_active_replacement_required": True,
        },
        "canonical_baseline": {
            "ground": display_path(canonical_ground),
            "ground_sha256": policy["canonical_ground_sha256"],
            "tile": display_path(canonical_tile),
            "tile_sha256": policy["canonical_tile_sha256"],
        },
        "integrated_candidate": {
            "ground": display_path(output_ground),
            "ground_sha256": integrated_hash,
            "tile": display_path(output_tile),
            "tile_sha256": sha256_file(output_tile),
        },
        "entity_integration": entity_proof,
        "historical_reserve_provenance": reserve_provenance,
        "related_scripts_unchanged": script_provenance,
        "tile_migration": {
            "mode": tile_migration_mode,
            "historical_active_path": policy["historical_tile"],
            "historical_active_sha256": policy["historical_tile_sha256"],
            "canonical_active_path": canonical_tile_identity,
            "canonical_active_sha256": policy["canonical_tile_sha256"],
            "same_active_identity": same_tile_identity,
            "historical_bytes_must_be_reserved_before_replacement": True,
            "historical_active_path_retained_unchanged": not same_tile_identity,
            "canonical_identity_created_additively": not same_tile_identity,
            "canonical_identity_replaced_only_after_reserve": same_tile_identity,
        },
        "canonical_case_tile_identity": canonical_tile_identity,
        "legacy_case_tile_retained_unchanged": (
            policy["historical_tile"] if not same_tile_identity else None
        ),
        "historical_tile_replaced_after_reserve": (
            policy["historical_tile"] if same_tile_identity else None
        ),
        "existing_asset_discarded": False,
        "existing_entity_silently_deactivated": False,
        "scripts_modified": False,
    }
    (output / "migration_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ground", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--canonical-root", type=Path)
    parser.add_argument("--historical-ground", type=Path)
    parser.add_argument("--historical-tile", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]

    def rooted(path: Path | None) -> Path | None:
        if path is None or path.is_absolute():
            return path
        return root / path

    manifest = build_migration(
        root,
        args.ground,
        rooted(args.output),
        historical_ground=rooted(args.historical_ground),
        historical_tile=rooted(args.historical_tile),
        canonical_root=rooted(args.canonical_root),
    )
    print(manifest["integrated_candidate"]["ground"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
