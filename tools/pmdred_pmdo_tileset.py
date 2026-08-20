#!/usr/bin/env python3
"""Adapt an authenticated PMDO sparse tilesheet between EU dungeon palettes.

The PMD Red EU dungeon families share FON/CEL geometry but can use different
PAL/CANM colour states.  PMDO's procedural tilesheets are sparse collections
of individual PNG payloads.  This module preserves every sparse coordinate
and substitutes colours from one authenticated EU palette state to another.

Animated secondary tiles are sparse overlays rather than complete CEL chunks.
Their AutoTile frame position declares the CANM phase to use.  Wall and floor
coordinates deliberately use only the base PAL state.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import io
import json
import struct
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

try:
    from PIL import Image
except ImportError as exc:  # pragma: no cover - exercised by the CLI guard
    raise SystemExit(
        "Pillow is required (campaign recovery: PYTHONPATH=.runtime-cache/pydeps:tools)"
    ) from exc

from pmdred_dungeon_ground import (
    AnimationRecord,
    DungeonArchive,
    gba_display_rgb,
    parse_canm,
    parse_ground_palette,
)

EU_ROM_SIZE = 33_554_432
EU_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
SOURCE_TILE_SHA256 = "c76035db7044346684ed8e399211cf0c7470317a5010d3ead0d45b9da1ea59e0"
SOURCE_AUTOTILE_SHA256 = {
    "floor": "4df7fefbd6f762d5328e10909fb21916201197d08d96617e25307c6f479f01a1",
    "secondary": "02bf936212993e32b8d5d5c4ac567f330b3bd328af39e5e687b7a30e18ad7dfa",
    "wall": "db51712d7f223f57a5dc636bbb12b1420b2b6fec284280ba2f2626fdbf9a7921",
}
TILE_SIZE = 24
EXPECTED_COORDINATES = 1_598
EXPECTED_DOMAIN_COUNTS = {"wall": 63, "floor": 48, "secondary": 1_487}
EXPECTED_SHARED_RESOURCES = {
    "fon": (13_280, "3ef1d008554a1b3bed72e7af2d199b590d682235aa010533bd2a367c7e661661"),
    "cel": (4_500, "dedf44516ad9305d64ff67e14bb3c26b4ab53c2c439f3c078a43fa44c976e222"),
    "cex": (2_352, "2396fa857763baea97cd2104e52c29434e560a390ffaaa95f69da667d87016ea"),
}
TARGET_SHEET = "SinisterWoods"
TARGET_PREFIX = "sinister_woods"
TARGET_NAME = "Sinister Woods"


class TilesetError(RuntimeError):
    """Raised when an authenticity or losslessness gate fails."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise TilesetError(message)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8-sig"))
    require(isinstance(value, dict), f"{path}: JSON root must be an object")
    return value


def canonical_json_bytes(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8-sig")


@dataclass(frozen=True)
class SparseTileSheet:
    tile_size: int
    tiles: Mapping[tuple[int, int], bytes]

    @classmethod
    def from_bytes(cls, data: bytes) -> "SparseTileSheet":
        require(len(data) >= 8, "sparse .tile is truncated")
        tile_size, count = struct.unpack_from("<ii", data, 0)
        require(tile_size > 0, "sparse .tile has an invalid tile size")
        require(count >= 0, "sparse .tile has a negative coordinate count")
        table_end = 8 + count * 16
        require(table_end <= len(data), "sparse .tile coordinate table is truncated")
        records: list[tuple[tuple[int, int], int]] = []
        for index in range(count):
            x, y, offset = struct.unpack_from("<iiq", data, 8 + index * 16)
            require(offset >= table_end, f"sparse .tile coordinate {index} has an invalid offset")
            require(offset < len(data), f"sparse .tile coordinate {index} offset is out of range")
            records.append(((x, y), offset))
        require(len({coord for coord, _ in records}) == count, "sparse .tile has duplicate coordinates")
        # Several coordinates may intentionally share one length-prefixed PNG
        # payload.  The coordinate table therefore need not be monotonic:
        # later coordinates can point back to an earlier deduplicated payload.
        payloads: dict[int, bytes] = {}
        for offset in sorted(set(offset for _, offset in records)):
            require(offset + 8 <= len(data), f"sparse .tile payload at {offset} has no length")
            length = struct.unpack_from("<q", data, offset)[0]
            require(length > 0, f"sparse .tile payload at {offset} has an invalid length")
            end = offset + 8 + length
            require(end <= len(data), f"sparse .tile payload at {offset} is truncated")
            payloads[offset] = data[offset + 8 : end]
        tiles = {coord: payloads[offset] for coord, offset in records}
        return cls(tile_size, tiles)

    @classmethod
    def read(cls, path: Path) -> "SparseTileSheet":
        return cls.from_bytes(path.read_bytes())

    def to_bytes(self) -> bytes:
        coords = sorted(self.tiles, key=lambda coord: (coord[1], coord[0]))
        payload_start = 8 + len(coords) * 16
        payload = bytearray()
        payload_offsets: dict[bytes, int] = {}
        coord_offsets: dict[tuple[int, int], int] = {}
        for coord in coords:
            png = self.tiles[coord]
            if png not in payload_offsets:
                payload_offsets[png] = payload_start + len(payload)
                payload.extend(struct.pack("<q", len(png)))
                payload.extend(png)
            coord_offsets[coord] = payload_offsets[png]
        table = bytearray(struct.pack("<ii", self.tile_size, len(coords)))
        for coord in coords:
            table.extend(struct.pack("<iiq", coord[0], coord[1], coord_offsets[coord]))
        return bytes(table + payload)


def iter_frame_sequences(value: Any) -> Iterable[dict[str, Any]]:
    """Yield PMDO frame-sequence dictionaries from an AutoTile JSON tree."""

    if isinstance(value, dict):
        if "Frames" in value and "FrameLength" in value:
            yield value
        for child in value.values():
            yield from iter_frame_sequences(child)
    elif isinstance(value, list):
        for child in value:
            yield from iter_frame_sequences(child)


def sequence_coordinates(sequence: Mapping[str, Any], expected_sheet: str) -> list[tuple[int, int]]:
    frames = sequence.get("Frames")
    require(isinstance(frames, list) and frames, "AutoTile frame sequence is empty")
    coords: list[tuple[int, int]] = []
    for frame in frames:
        require(isinstance(frame, dict), "AutoTile frame is not an object")
        require(frame.get("Sheet") == expected_sheet, "AutoTile frame references an unexpected sheet")
        loc = frame.get("TexLoc")
        require(isinstance(loc, dict), "AutoTile frame has no TexLoc object")
        x, y = loc.get("X"), loc.get("Y")
        require(isinstance(x, int) and isinstance(y, int), "AutoTile coordinate is not integral")
        coords.append((x, y))
    return coords


def collect_domain_coordinates(document: Mapping[str, Any], expected_sheet: str) -> set[tuple[int, int]]:
    coords: set[tuple[int, int]] = set()
    sequences = list(iter_frame_sequences(document))
    require(sequences, "AutoTile document contains no frame sequences")
    for sequence in sequences:
        coords.update(sequence_coordinates(sequence, expected_sheet))
    return coords


def secondary_phase_map(
    document: Mapping[str, Any], expected_sheet: str
) -> tuple[dict[tuple[int, int], int], dict[int, int]]:
    """Return each secondary coordinate's declared phase and source timings."""

    phases: dict[tuple[int, int], int] = {}
    timing_counts: dict[int, int] = {}
    for sequence in iter_frame_sequences(document):
        coords = sequence_coordinates(sequence, expected_sheet)
        frame_length = sequence.get("FrameLength")
        require(isinstance(frame_length, int) and frame_length > 0, "invalid AutoTile FrameLength")
        require(
            (len(coords), frame_length) in ((1, 999), (16, 10), (16, 4)),
            f"unexpected secondary animation shape ({len(coords)} frames, {frame_length} ticks)",
        )
        timing_counts[frame_length] = timing_counts.get(frame_length, 0) + 1
        for phase, coord in enumerate(coords):
            prior = phases.setdefault(coord, phase)
            require(prior == phase, f"secondary coordinate {coord} has conflicting phases")
    require(set(timing_counts) == {999, 10, 4}, "secondary AutoTile does not exercise timings 999/10/4")
    return phases, timing_counts


def palette_state(
    base: Sequence[tuple[int, int, int, int]],
    animations: Sequence[AnimationRecord],
    phase: int | None,
) -> list[tuple[int, int, int, int]]:
    state = list(base)
    require(len(state) == 192, "palette state must contain 192 colours")
    if phase is not None:
        require(0 <= phase < 16, f"invalid CANM phase {phase}")
        for record in animations:
            if record.active:
                require(record.count == 16, f"CANM record {record.index} is not a 16-phase sequence")
                state[160 + record.index] = record.colors[phase]
    return state


def rgb_substitution(
    source: Sequence[tuple[int, int, int, int]],
    target: Sequence[tuple[int, int, int, int]],
) -> dict[tuple[int, int, int], tuple[int, int, int]]:
    require(len(source) == len(target) == 192, "source/target palette lengths differ")
    mapping: dict[tuple[int, int, int], tuple[int, int, int]] = {}
    # Index zero of every 4bpp palette row is transparent and is not a visible
    # colour-domain requirement.
    for index, (source_color, target_color) in enumerate(zip(source, target)):
        if index % 16 == 0:
            continue
        # DumpAsset's source PNGs retain the archive's literal source RGB.
        # The target must use the colour actually displayed by the GBA's
        # 5-bit channels.  Quantising the target is also what makes duplicate
        # source RGB records converge unambiguously when their insignificant
        # low target bits differ.
        source_rgb = tuple(source_color[:3])
        target_rgb = gba_display_rgb(target_color)
        prior = mapping.setdefault(source_rgb, target_rgb)
        require(
            prior == target_rgb,
            f"ambiguous palette substitution for RGB {source_rgb}: {prior} versus {target_rgb}",
        )
    return mapping


def recolor_png(
    payload: bytes,
    mapping: Mapping[tuple[int, int, int], tuple[int, int, int]],
    coord: tuple[int, int],
    tile_size: int,
) -> tuple[bytes, set[tuple[int, int, int]], set[tuple[int, int, int]]]:
    try:
        with Image.open(io.BytesIO(payload)) as opened:
            image = opened.convert("RGBA")
    except Exception as exc:
        raise TilesetError(f"tile {coord}: invalid PNG payload") from exc
    require(image.size == (tile_size, tile_size), f"tile {coord}: unexpected dimensions {image.size}")
    pixels = list(image.get_flattened_data())
    require({pixel[3] for pixel in pixels} <= {0, 255}, f"tile {coord}: alpha is not binary")
    visible_source = {tuple(pixel[:3]) for pixel in pixels if pixel[3]}
    missing = visible_source - set(mapping)
    require(not missing, f"tile {coord}: visible RGB values outside source palette: {sorted(missing)}")
    converted = [
        (*mapping[tuple(pixel[:3])], 255) if pixel[3] else (0, 0, 0, 0)
        for pixel in pixels
    ]
    output = Image.new("RGBA", image.size)
    output.putdata(converted)
    stream = io.BytesIO()
    output.save(stream, format="PNG", optimize=False, compress_level=6)
    visible_target = {tuple(pixel[:3]) for pixel in converted if pixel[3]}
    return stream.getvalue(), visible_source, visible_target


def adapt_autotile(
    source: Mapping[str, Any], *, domain: str, source_sheet: str, target_sheet: str
) -> dict[str, Any]:
    target = copy.deepcopy(source)
    root = target.get("Object")
    require(isinstance(root, dict), f"{domain}: AutoTile has no Object")
    name = root.get("Name")
    require(isinstance(name, dict), f"{domain}: AutoTile has no Name")
    name["DefaultText"] = f"{TARGET_NAME} {domain.capitalize()}"
    timing_map = {999: 999, 10: 12, 4: 8}
    for sequence in iter_frame_sequences(target):
        # Validate all source references before replacing only the sheet name;
        # sparse coordinates are intentionally unchanged.
        sequence_coordinates(sequence, source_sheet)
        frames = sequence["Frames"]
        for frame in frames:
            frame["Sheet"] = target_sheet
        old_length = sequence["FrameLength"]
        if domain == "secondary":
            require(old_length in timing_map, f"secondary: unsupported frame timing {old_length}")
            sequence["FrameLength"] = timing_map[old_length]
        else:
            require(old_length == 999 and len(frames) == 1, f"{domain}: unexpectedly animated sequence")
    return target


def animation_gate(source: Sequence[AnimationRecord], target: Sequence[AnimationRecord]) -> dict[str, Any]:
    require(len(source) == len(target) == 32, "CANM record count differs")
    source_groups: dict[int, list[int]] = {}
    target_groups: dict[int, list[int]] = {}
    for source_record, target_record in zip(source, target):
        require(source_record.index == target_record.index, "CANM record indexes differ")
        require(source_record.count == target_record.count, f"CANM record {source_record.index} phase count differs")
        require(source_record.active == target_record.active, f"CANM record {source_record.index} active state differs")
        if source_record.active:
            source_groups.setdefault(source_record.duration, []).append(source_record.index)
            target_groups.setdefault(target_record.duration, []).append(target_record.index)
            expected = 12 if source_record.duration == 10 else 8 if source_record.duration == 4 else None
            require(expected is not None, f"unexpected source CANM timing {source_record.duration}")
            require(target_record.duration == expected, f"CANM record {source_record.index}: expected target timing {expected}")
    require(set(source_groups) == {10, 4}, "source CANM timing groups are not 10/4")
    require(set(target_groups) == {12, 8}, "target CANM timing groups are not 12/8")
    return {
        "source_duration_groups": {str(key): value for key, value in sorted(source_groups.items())},
        "target_duration_groups": {str(key): value for key, value in sorted(target_groups.items())},
    }


def archive_resource(archive: DungeonArchive, name: str) -> tuple[bytes, dict[str, Any]]:
    entry = archive.entry(name)
    payload = archive.rom.bytes(entry.container_span)
    return payload, {
        "archive_entry_index": entry.index,
        "archive_data_address_hex": f"0x{entry.data_address:08X}",
        "size": len(payload),
        "sha256": sha256(payload),
    }


def add_artifact(
    outputs: dict[Path, bytes], path: Path, data: bytes, *, allow_existing_exact: bool = False
) -> None:
    if path.exists():
        if allow_existing_exact and path.read_bytes() == data:
            return
        raise TilesetError(f"create-only destination already exists: {path}")
    require(path not in outputs, f"duplicate output destination: {path}")
    outputs[path] = data


def convert(
    *,
    rom_path: Path,
    source_tile_path: Path,
    source_autotile_dir: Path,
    output_root: Path,
    evidence_dir: Path,
    source_family: str = "b52",
    target_family: str = "b41",
) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    require(len(rom) == EU_ROM_SIZE, f"EU ROM size mismatch: {len(rom)}")
    require(sha256(rom) == EU_ROM_SHA256, "EU ROM SHA-256 mismatch")
    source_tile_bytes = source_tile_path.read_bytes()
    require(sha256(source_tile_bytes) == SOURCE_TILE_SHA256, "UproarForest.tile SHA-256 mismatch")

    source_documents: dict[str, dict[str, Any]] = {}
    for domain in ("wall", "floor", "secondary"):
        path = source_autotile_dir / f"uproar_forest_{domain}.json"
        raw = path.read_bytes()
        require(sha256(raw) == SOURCE_AUTOTILE_SHA256[domain], f"{path.name} SHA-256 mismatch")
        source_documents[domain] = load_json(path)

    sheet = SparseTileSheet.from_bytes(source_tile_bytes)
    require(sheet.tile_size == TILE_SIZE, f"expected tile size {TILE_SIZE}, got {sheet.tile_size}")
    require(len(sheet.tiles) == EXPECTED_COORDINATES, f"expected {EXPECTED_COORDINATES} coordinates, got {len(sheet.tiles)}")
    require(len(set(sheet.tiles.values())) == 718, "expected 718 unique source PNG payloads")

    domains = {
        domain: collect_domain_coordinates(document, "UproarForest")
        for domain, document in source_documents.items()
    }
    for domain, expected in EXPECTED_DOMAIN_COUNTS.items():
        require(len(domains[domain]) == expected, f"{domain}: expected {expected} coordinates, got {len(domains[domain])}")
    require(not (domains["wall"] & domains["floor"]), "wall/floor coordinate domains overlap")
    require(not (domains["wall"] & domains["secondary"]), "wall/secondary coordinate domains overlap")
    require(not (domains["floor"] & domains["secondary"]), "floor/secondary coordinate domains overlap")
    require(set().union(*domains.values()) == set(sheet.tiles), "AutoTile coordinate union does not equal sparse atlas")
    phases, source_timing_counts = secondary_phase_map(source_documents["secondary"], "UproarForest")
    require(set(phases) == domains["secondary"], "secondary phase map does not cover its coordinate domain")

    archive = DungeonArchive(rom)
    source_pal_raw, source_pal_evidence = archive.raw(f"{source_family}pal", 192 * 4)
    target_pal_raw, target_pal_evidence = archive.raw(f"{target_family}pal", 192 * 4)
    source_base = parse_ground_palette(source_pal_raw)
    target_base = parse_ground_palette(target_pal_raw)
    source_animations, source_canm_evidence = parse_canm(archive, f"{source_family}canm")
    target_animations, target_canm_evidence = parse_canm(archive, f"{target_family}canm")
    animation = animation_gate(source_animations, target_animations)

    state_maps: dict[int | None, dict[tuple[int, int, int], tuple[int, int, int]]] = {}
    target_domains: dict[int | None, set[tuple[int, int, int]]] = {}
    for phase in [None, *range(16)]:
        source_state = palette_state(source_base, source_animations, phase)
        target_state = palette_state(target_base, target_animations, phase)
        state_maps[phase] = rgb_substitution(source_state, target_state)
        target_domains[phase] = set(state_maps[phase].values())

    converted_tiles: dict[tuple[int, int], bytes] = {}
    source_rgb: set[tuple[int, int, int]] = set()
    target_rgb: set[tuple[int, int, int]] = set()
    conversion_cache: dict[
        tuple[bytes, int | None],
        tuple[bytes, set[tuple[int, int, int]], set[tuple[int, int, int]]],
    ] = {}
    static_count = 0
    animated_count = 0
    for coord, payload in sheet.tiles.items():
        phase: int | None = phases[coord] if coord in domains["secondary"] else None
        if phase is None:
            static_count += 1
        else:
            animated_count += 1
        cache_key = (payload, phase)
        if cache_key not in conversion_cache:
            conversion_cache[cache_key] = recolor_png(
                payload, state_maps[phase], coord, sheet.tile_size
            )
        converted, visible_source, visible_target = conversion_cache[cache_key]
        require(visible_target <= target_domains[phase], f"tile {coord}: target colour-domain failure")
        converted_tiles[coord] = converted
        source_rgb.update(visible_source)
        target_rgb.update(visible_target)
    converted_sheet = SparseTileSheet(sheet.tile_size, converted_tiles)
    converted_tile_bytes = converted_sheet.to_bytes()
    reparsed = SparseTileSheet.from_bytes(converted_tile_bytes)
    require(reparsed.tile_size == sheet.tile_size, "round-trip tile size changed")
    require(set(reparsed.tiles) == set(sheet.tiles), "round-trip coordinate set changed")

    adapted_documents = {
        domain: adapt_autotile(
            document, domain=domain, source_sheet="UproarForest", target_sheet=TARGET_SHEET
        )
        for domain, document in source_documents.items()
    }
    adapted_timing_counts: dict[int, int] = {}
    for sequence in iter_frame_sequences(adapted_documents["secondary"]):
        length = sequence["FrameLength"]
        adapted_timing_counts[length] = adapted_timing_counts.get(length, 0) + 1
    require(set(adapted_timing_counts) == {999, 12, 8}, "adapted secondary timings are not 999/12/8")

    outputs: dict[Path, bytes] = {}
    add_artifact(outputs, output_root / "Content/Tile/SinisterWoods.tile", converted_tile_bytes)
    for domain, document in adapted_documents.items():
        add_artifact(
            outputs,
            output_root / f"Data/AutoTile/{TARGET_PREFIX}_{domain}.json",
            canonical_json_bytes(document),
        )

    resource_evidence: dict[str, Any] = {}
    resource_dir = evidence_dir / "resources"
    for family in (source_family, target_family):
        for suffix in ("fon", "cel", "cex"):
            name = f"{family}{suffix}"
            compressed = archive.rom.bytes(archive.stream_span(archive.entry(name)))
            decompressed, decomposition = archive.decompress(name)
            expected_size, expected_hash = EXPECTED_SHARED_RESOURCES[suffix]
            require(
                len(decompressed) == expected_size and sha256(decompressed) == expected_hash,
                f"{name}: authenticated decompressed resource gate failed",
            )
            add_artifact(outputs, resource_dir / f"{name}.at4px", compressed)
            add_artifact(outputs, resource_dir / f"{name}.bin", decompressed)
            resource_evidence[name] = {
                "compressed_size": len(compressed),
                "compressed_sha256": sha256(compressed),
                "decompressed_size": len(decompressed),
                "decompressed_sha256": sha256(decompressed),
                "archive": decomposition,
            }
        pal_name = f"{family}pal"
        pal_raw, pal_info = archive.raw(pal_name, 192 * 4)
        add_artifact(outputs, resource_dir / f"{pal_name}.bin", pal_raw)
        resource_evidence[pal_name] = {**pal_info, "size": len(pal_raw), "sha256": sha256(pal_raw)}
        canm_name = f"{family}canm"
        canm_container, canm_info = archive_resource(archive, canm_name)
        add_artifact(outputs, resource_dir / f"{canm_name}.siro", canm_container)
        resource_evidence[canm_name] = canm_info

    manifest: dict[str, Any] = {
        "schema": "pmdred-eu-pmdo-tileset-adaptation-v1",
        "status": "PASS_AUTHENTIC_ADAPTATION",
        "authority": {
            "rom_path": str(rom_path),
            "rom_size": len(rom),
            "rom_sha256": sha256(rom),
            "source_family": source_family,
            "target_family": target_family,
            "source_tilesheet": str(source_tile_path),
            "source_tilesheet_sha256": sha256(source_tile_bytes),
            "source_autotiles": {
                domain: {
                    "path": str(source_autotile_dir / f"uproar_forest_{domain}.json"),
                    "sha256": SOURCE_AUTOTILE_SHA256[domain],
                }
                for domain in ("wall", "floor", "secondary")
            },
        },
        "palette": {
            "source": source_pal_evidence,
            "target": target_pal_evidence,
            "source_canm": source_canm_evidence,
            "target_canm": target_canm_evidence,
            "animation": animation,
            "ambiguity_gate": "PASS_ALL_17_STATES",
        },
        "coverage": {
            "tile_size": sheet.tile_size,
            "coordinate_count": len(sheet.tiles),
            "source_unique_png_count": len(set(sheet.tiles.values())),
            "target_unique_png_count": len(set(converted_tiles.values())),
            "unique_phase_conversion_count": len(conversion_cache),
            "coordinate_bounds": {
                "x": [min(x for x, _ in sheet.tiles), max(x for x, _ in sheet.tiles)],
                "y": [min(y for _, y in sheet.tiles), max(y for _, y in sheet.tiles)],
            },
            "domain_counts": {domain: len(coords) for domain, coords in domains.items()},
            "union_exact": True,
            "static_palette_coordinate_count": static_count,
            "phase_palette_coordinate_count": animated_count,
            "source_visible_rgb_count": len(source_rgb),
            "target_visible_rgb_count": len(target_rgb),
            "binary_alpha": True,
            "dimensions_exact": True,
        },
        "timings": {
            "source_frame_lengths": {str(key): value for key, value in sorted(source_timing_counts.items())},
            "target_frame_lengths": {str(key): value for key, value in sorted(adapted_timing_counts.items())},
        },
        "outputs": {},
        "scope": {
            "certified": "exact EU source resources, lossless sparse-coordinate adaptation, palette/CANM states, and AutoTile references",
            "deferred": "native PMDO gameplay/audio/unload certification in the grouped final batch",
        },
    }
    # Resource files are outputs too and are included before the manifest hash list.
    manifest["resources"] = resource_evidence
    for path, data in sorted(outputs.items(), key=lambda pair: str(pair[0])):
        try:
            display_path = str(path.resolve().relative_to(Path.cwd().resolve()))
        except ValueError:
            display_path = str(path)
        manifest["outputs"][display_path] = {
            "size": len(data),
            "sha256": sha256(data),
        }
    manifest_path = evidence_dir / "tileset_adaptation_manifest.json"
    add_artifact(outputs, manifest_path, canonical_json_bytes(manifest))

    # All gates run before promotion; promotion itself remains create-only.
    for path, data in outputs.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    return manifest


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=Path(".runtime-cache/downloads/pmdred-eu.gba"))
    parser.add_argument(
        "--source-tile",
        type=Path,
        default=Path(".runtime-cache/DumpAsset/Content/Tile/UproarForest.tile"),
    )
    parser.add_argument(
        "--source-autotile-dir",
        type=Path,
        default=Path(".runtime-cache/DumpAsset/Data/AutoTile"),
    )
    parser.add_argument("--output-root", type=Path, default=Path("."))
    parser.add_argument(
        "--evidence-dir",
        type=Path,
        default=Path("docs/pmdred_eu/playable/sinister_woods/tileset"),
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        manifest = convert(
            rom_path=args.rom,
            source_tile_path=args.source_tile,
            source_autotile_dir=args.source_autotile_dir,
            output_root=args.output_root,
            evidence_dir=args.evidence_dir,
        )
    except (OSError, TilesetError, ValueError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1
    print(json.dumps({
        "status": manifest["status"],
        "coordinate_count": manifest["coverage"]["coordinate_count"],
        "domain_counts": manifest["coverage"]["domain_counts"],
        "target_frame_lengths": manifest["timings"]["target_frame_lengths"],
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
