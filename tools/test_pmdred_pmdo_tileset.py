#!/usr/bin/env python3
from __future__ import annotations

import io
import json
import tempfile
import unittest
from pathlib import Path

from PIL import Image

from pmdred_dungeon_ground import DungeonArchive, parse_canm, parse_ground_palette
from pmdred_pmdo_tileset import (
    EU_ROM_SHA256,
    EXPECTED_DOMAIN_COUNTS,
    SOURCE_AUTOTILE_SHA256,
    SOURCE_TILE_SHA256,
    SparseTileSheet,
    TilesetError,
    adapt_autotile,
    collect_domain_coordinates,
    palette_state,
    recolor_png,
    rgb_substitution,
    secondary_phase_map,
    sha256,
)

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / ".runtime-cache/downloads/pmdred-eu.gba"
SOURCE_TILE = ROOT / ".runtime-cache/DumpAsset/Content/Tile/UproarForest.tile"
SOURCE_AUTOTILE = ROOT / ".runtime-cache/DumpAsset/Data/AutoTile"
HAS_AUTHENTIC_FIXTURE = ROM.is_file() and SOURCE_TILE.is_file() and SOURCE_AUTOTILE.is_dir()


def png(color: tuple[int, int, int, int]) -> bytes:
    image = Image.new("RGBA", (2, 2), color)
    stream = io.BytesIO()
    image.save(stream, format="PNG")
    return stream.getvalue()


def sequence(coords: list[tuple[int, int]], duration: int) -> dict:
    return {
        "Frames": [
            {"Sheet": "UproarForest", "TexLoc": {"X": x, "Y": y}}
            for x, y in coords
        ],
        "FrameLength": duration,
    }


class SparseTileSheetTests(unittest.TestCase):
    def test_round_trip_preserves_sparse_coordinates_and_deduplication(self) -> None:
        red = png((255, 0, 0, 255))
        blue = png((0, 0, 255, 255))
        source = SparseTileSheet(2, {(5, 7): red, (1, 2): blue, (9, 3): red})
        encoded = source.to_bytes()
        restored = SparseTileSheet.from_bytes(encoded)
        self.assertEqual(restored.tile_size, 2)
        self.assertEqual(restored.tiles, source.tiles)
        # Two unique payloads, each with one int64 length prefix.
        self.assertEqual(encoded.count(b"\x89PNG\r\n\x1a\n"), 2)

    def test_palette_mapping_uses_raw_source_and_display_quantized_target(self) -> None:
        source = [(0, 0, 0, 0)] * 192
        target = [(0, 0, 0, 0)] * 192
        source[1] = (223, 159, 71, 128)
        source[17] = (223, 159, 71, 128)
        target[1] = (191, 159, 55, 128)
        target[17] = (185, 156, 53, 128)
        mapping = rgb_substitution(source, target)
        self.assertEqual(mapping[(223, 159, 71)], (189, 156, 49))

    def test_palette_mapping_rejects_real_ambiguity(self) -> None:
        source = [(0, 0, 0, 0)] * 192
        target = [(0, 0, 0, 0)] * 192
        source[1] = source[17] = (8, 16, 24, 128)
        target[1] = (8, 16, 24, 128)
        target[17] = (80, 88, 96, 128)
        with self.assertRaisesRegex(TilesetError, "ambiguous palette substitution"):
            rgb_substitution(source, target)


class AutoTileTests(unittest.TestCase):
    def setUp(self) -> None:
        self.document = {
            "Version": "0.8.12.0",
            "Object": {
                "Name": {"DefaultText": "Uproar Forest Secondary", "LocalTexts": {}},
                "Tiles": {
                    "Static": [[sequence([(1, 1)], 999)]],
                    "Slow": [[sequence([(2, phase) for phase in range(16)], 10)]],
                    "Fast": [[sequence([(3, phase) for phase in range(16)], 4)]],
                },
            },
        }

    def test_phase_map_and_target_timings(self) -> None:
        phases, timings = secondary_phase_map(self.document, "UproarForest")
        self.assertEqual(phases[(1, 1)], 0)
        self.assertEqual(phases[(2, 15)], 15)
        self.assertEqual(phases[(3, 7)], 7)
        self.assertEqual(timings, {999: 1, 10: 1, 4: 1})
        adapted = adapt_autotile(
            self.document,
            domain="secondary",
            source_sheet="UproarForest",
            target_sheet="SinisterWoods",
        )
        sequences = list(
            item
            for item in adapted["Object"]["Tiles"].values()
            for row in item
            for item2 in row
            for item in [item2]
        )
        self.assertEqual([item["FrameLength"] for item in sequences], [999, 12, 8])
        self.assertTrue(
            all(frame["Sheet"] == "SinisterWoods" for item in sequences for frame in item["Frames"])
        )
        self.assertEqual(adapted["Object"]["Name"]["DefaultText"], "Sinister Woods Secondary")


@unittest.skipUnless(HAS_AUTHENTIC_FIXTURE, "authenticated ignored runtime fixture is unavailable")
class AuthenticatedFixtureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.rom = ROM.read_bytes()
        cls.archive = DungeonArchive(cls.rom)
        cls.sheet_raw = SOURCE_TILE.read_bytes()
        cls.sheet = SparseTileSheet.from_bytes(cls.sheet_raw)
        cls.documents = {
            domain: json.loads(
                (SOURCE_AUTOTILE / f"uproar_forest_{domain}.json").read_text(encoding="utf-8-sig")
            )
            for domain in ("wall", "floor", "secondary")
        }

    def test_authority_hashes_and_exact_coordinate_domains(self) -> None:
        self.assertEqual(sha256(self.rom), EU_ROM_SHA256)
        self.assertEqual(sha256(self.sheet_raw), SOURCE_TILE_SHA256)
        self.assertEqual(self.sheet.tile_size, 24)
        self.assertEqual(len(self.sheet.tiles), 1_598)
        self.assertEqual(len(set(self.sheet.tiles.values())), 718)
        domains = {
            domain: collect_domain_coordinates(document, "UproarForest")
            for domain, document in self.documents.items()
        }
        self.assertEqual({domain: len(coords) for domain, coords in domains.items()}, EXPECTED_DOMAIN_COUNTS)
        self.assertEqual(set().union(*domains.values()), set(self.sheet.tiles))
        self.assertFalse(domains["wall"] & domains["floor"])
        self.assertFalse(domains["wall"] & domains["secondary"])
        self.assertFalse(domains["floor"] & domains["secondary"])
        for domain in domains:
            raw = (SOURCE_AUTOTILE / f"uproar_forest_{domain}.json").read_bytes()
            self.assertEqual(sha256(raw), SOURCE_AUTOTILE_SHA256[domain])

    def test_all_palette_states_are_unambiguous_and_one_tile_recolors(self) -> None:
        source_base = parse_ground_palette(self.archive.raw("b52pal", 768)[0])
        target_base = parse_ground_palette(self.archive.raw("b41pal", 768)[0])
        source_animation = parse_canm(self.archive, "b52canm")[0]
        target_animation = parse_canm(self.archive, "b41canm")[0]
        for phase in [None, *range(16)]:
            mapping = rgb_substitution(
                palette_state(source_base, source_animation, phase),
                palette_state(target_base, target_animation, phase),
            )
            self.assertTrue(mapping)
        phases, _ = secondary_phase_map(self.documents["secondary"], "UproarForest")
        coord = (10, 1)
        phase = phases[coord]
        mapping = rgb_substitution(
            palette_state(source_base, source_animation, phase),
            palette_state(target_base, target_animation, phase),
        )
        converted, source_colors, target_colors = recolor_png(
            self.sheet.tiles[coord], mapping, coord, self.sheet.tile_size
        )
        self.assertTrue(source_colors)
        self.assertTrue(target_colors)
        with Image.open(io.BytesIO(converted)) as image:
            self.assertEqual(image.size, (24, 24))
            self.assertLessEqual({pixel[3] for pixel in image.convert("RGBA").get_flattened_data()}, {0, 255})


if __name__ == "__main__":
    unittest.main()
