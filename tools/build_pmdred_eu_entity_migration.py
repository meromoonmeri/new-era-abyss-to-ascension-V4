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

MIGRATION_POLICIES = {"a02p01": A02P01_POLICY}


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
        "canonical_case_tile_identity": f"Content/Tile/{ground}_Base.tile",
        "legacy_case_tile_retained_unchanged": policy["historical_tile"],
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
