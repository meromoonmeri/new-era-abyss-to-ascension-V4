#!/usr/bin/env python3
"""Tests for the RogueElements-driven Dungeon Builder."""
from __future__ import annotations

import copy
import json
import re
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "tools"))

from dungeon_builder import steps as S
from dungeon_builder.definitions import (DefinitionError, find_definition, load_definition,
                                         parse_definition)
from dungeon_builder.dtef import DtefError, available_packages, resolve as resolve_dtef
from dungeon_builder.grounds import check_grounds
from dungeon_builder.profiles import BUILTIN_PROFILES, customize, get_profile
from dungeon_builder.re_sim.pipeline import measure, similarity
from dungeon_builder.rng import DungeonRng, fresh_seed
from dungeon_builder.validation import Thresholds, check_layout, validate_floor
from dungeon_builder.zone_export import build_zone

SINISTER = REPO / "DungeonDefs" / "canonical" / "sinister_woods.json"


def load_sinister():
    return load_definition(SINISTER)


class TestDefinitions(unittest.TestCase):
    def test_load_sinister_woods(self):
        d = load_sinister()
        self.assertEqual(d.id, "gloomy_forest")
        self.assertEqual(d.floors, 14)
        self.assertEqual(len(d.segments), 3)
        self.assertTrue(d.profiles)
        # every floor resolves to exactly one segment
        for floor in range(1, d.floors + 1):
            self.assertIsNotNone(d.segment_for_floor(floor))

    def test_inheritance_and_override(self):
        d = load_sinister()
        seg1 = d.segments[0]
        base_species = {m.species for m in d.mobs}
        seg_species = {m.species for m in d.mobs_for(seg1)}
        self.assertTrue(base_species <= seg_species)
        self.assertIn("sudowoodo", seg_species)
        self.assertGreaterEqual(len(seg_species), 8)
        # item tables are inherited by default
        self.assertTrue({t.name for t in d.items_for(seg1)} >= {"necessities", "gummis"})

    def test_segment_gap_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][1]["floors"] = [7, 10]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_segment_overlap_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][1]["floors"] = [5, 10]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_missing_required_field_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        del raw["floors"]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_invalid_level_pair_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["pokemon"][0]["level"] = [20, 5]
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_unknown_feature_key_rejected(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["features"]["teleporters"] = {"enabled": True}
        with self.assertRaises(DefinitionError):
            parse_definition(raw)

    def test_unknown_profile_rejected(self):
        with self.assertRaises(KeyError):
            get_profile("does_not_exist")
        with self.assertRaises(KeyError):
            customize("branching", {"not_a_field": 3})


class TestRng(unittest.TestCase):
    def test_no_fixed_default_seed(self):
        seeds = {DungeonRng().seed for _ in range(8)}
        self.assertGreater(len(seeds), 6, "default seeds must come from OS entropy")
        self.assertNotEqual(fresh_seed(), fresh_seed())

    def test_explicit_seed_is_reproducible_for_debug(self):
        a = DungeonRng(seed=1234)
        b = DungeonRng(seed=1234)
        self.assertEqual([a.next_seed() for _ in range(5)], [b.next_seed() for _ in range(5)])
        self.assertTrue(a.explicit)
        self.assertEqual(len(a.used_seeds), 5)

    def test_same_profile_different_seed_gives_different_topology(self):
        profile = get_profile("branching")
        a = measure(profile.simulate(11))
        b = measure(profile.simulate(12))
        self.assertNotEqual(a.signature, b.signature)


class TestGeneration(unittest.TestCase):
    def test_every_profile_produces_a_real_dungeon_floor(self):
        thresholds = Thresholds()
        for name, profile in BUILTIN_PROFILES.items():
            ok = 0
            for seed in range(20):
                result = profile.simulate(seed * 7919 + 13)
                metrics, problems = check_layout(result, thresholds)
                if not problems:
                    ok += 1
                    self.assertGreaterEqual(metrics.rooms, 4, name)
                    self.assertGreaterEqual(metrics.halls, 3, name)
                    self.assertGreater(metrics.hall_tiles, 0, name)
                    self.assertGreater(metrics.room_area_max, metrics.room_area_min, name)
            self.assertGreaterEqual(ok, 14, f"profile {name} produced too many invalid floors")

    def test_profiles_have_distinct_architecture_signatures(self):
        loops_looping = sum(measure(get_profile("looping").simulate(s)).loops for s in range(15))
        loops_branching = sum(measure(get_profile("branching").simulate(s)).loops for s in range(15))
        self.assertGreater(loops_looping, loops_branching)

        dead_branching = sum(measure(get_profile("branching").simulate(s)).dead_ends for s in range(15))
        dead_looping = sum(measure(get_profile("looping").simulate(s)).dead_ends for s in range(15))
        self.assertGreater(dead_branching, dead_looping)

        rooms_dense = sum(measure(get_profile("dense").simulate(s)).rooms for s in range(15))
        rooms_large = sum(measure(get_profile("large_rooms").simulate(s)).rooms for s in range(15))
        self.assertGreater(rooms_dense, rooms_large)

        area_large = max(measure(get_profile("large_rooms").simulate(s)).room_area_max for s in range(15))
        area_dense = max(measure(get_profile("dense").simulate(s)).room_area_max for s in range(15))
        self.assertGreater(area_large, area_dense)

    def test_no_floor_is_a_single_square_room(self):
        for name in BUILTIN_PROFILES:
            for seed in range(10):
                m = measure(get_profile(name).simulate(seed + 100))
                self.assertGreater(m.rooms + m.hall_cells, 3, name)
                self.assertGreater(m.connections, 1, name)

    def test_traversability_and_stairs(self):
        for name in BUILTIN_PROFILES:
            for seed in range(10):
                result = get_profile(name).simulate(seed + 500)
                m, problems = check_layout(result, Thresholds())
                if problems:
                    continue
                self.assertTrue(m.stairs_reachable)
                self.assertEqual(m.components, 1)
                self.assertGreaterEqual(m.reachable_ratio, 0.97)


class TestVariationAndRejection(unittest.TestCase):
    def test_ten_variants_per_floor_are_structurally_distinct(self):
        d = load_sinister()
        rng = DungeonRng(seed=987654321, label="test")
        for floor in (1, 7, 14):
            profiles = [customize(c.name, c.overrides)
                        for c in d.profiles_for(d.segment_for_floor(floor))]
            report, _ = validate_floor(floor, profiles, rng, count=10)
            self.assertTrue(report.ok, report.notes)
            self.assertEqual(len(report.accepted()), 10)
            self.assertEqual(report.distinct_signatures, 10)
            self.assertLessEqual(report.max_pair_similarity, 1.0)

    def test_clone_layouts_are_rejected(self):
        d = load_sinister()
        rng = DungeonRng(seed=42)
        profiles = [customize("branching", None)]
        strict = Thresholds(max_similarity=0.0, max_attempts_per_variant=3)
        report, _ = validate_floor(1, profiles, rng, count=3, thresholds=strict)
        self.assertGreater(report.rejected, 0)

    def test_invalid_layout_is_detected(self):
        profile = customize("branching", {"grid_x": [1, 2], "grid_y": [1, 2], "room_ratio": [100, 100]})
        result = profile.simulate(3)
        _, problems = check_layout(result, Thresholds())
        self.assertTrue(problems)


class TestDtef(unittest.TestCase):
    def test_sinister_package_is_imported_and_backed_by_sheets(self):
        packages = available_packages()
        self.assertIn("sinister_woods_b41", packages)
        package = resolve_dtef({"package": "sinister_woods_b41", "element": "grass"})
        self.assertEqual(package.floor, "sinister_woods_b41_floor")
        self.assertEqual(package.wall, "sinister_woods_b41_wall")
        self.assertEqual(package.secondary, "sinister_woods_b41_secondary")
        self.assertTrue(package.sheets)
        for sheet in package.sheets:
            self.assertTrue((REPO / "Content" / "Tile" / f"{sheet}.tile").exists(), sheet)

    def test_autotile_covers_the_full_adjacency_table(self):
        """RogueEssence stores the 256 neighbour codes as the 47 canonical
        AutoTileAdjacent classes; all of them must be present for every role."""
        for role in ("floor", "wall", "secondary"):
            data = json.loads((REPO / "Data" / "AutoTile" / f"sinister_woods_b41_{role}.json")
                              .read_text(encoding="utf-8-sig"))
            tiles = data["Object"]["Tiles"]
            self.assertIn("AutoTileAdjacent", tiles["$type"], role)
            keys = [k for k in tiles if re.fullmatch(r"Tilex[0-9A-F]{2}", k)]
            self.assertEqual(len(keys), 47,
                             f"{role}: incomplete DTEF adjacency table ({len(keys)} classes)")
            self.assertIn("Tilex00", keys)
            self.assertIn("TilexFF", keys)

    def test_unknown_tileset_is_rejected(self):
        with self.assertRaises(DtefError):
            resolve_dtef({"package": "not_imported_biome"})
        with self.assertRaises(DtefError):
            resolve_dtef({"floor": "nope_floor", "wall": "nope_wall", "secondary": "nope_secondary"})


class TestZoneExport(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.definition = load_sinister()
        cls.export = build_zone(cls.definition, DungeonRng(seed=2026))
        cls.zone = cls.export.zone_json["Object"]

    def test_zone_shape(self):
        self.assertEqual(self.zone["$type"], "RogueEssence.Data.ZoneData, RogueEssence")
        self.assertEqual(len(self.zone["Segments"]), 3)
        total = sum(len(seg["Floors"]) for seg in self.zone["Segments"])
        self.assertEqual(total, self.definition.floors)

    def test_every_floor_uses_native_grid_steps(self):
        needed = {"InitGridPlanStep", "DrawGridToFloorStep", "DrawFloorToTileStep",
                  "FloorStairsStep", "MapTextureStep", "DetectIsolatedStairsStep"}
        paths = set()
        for segment in self.zone["Segments"]:
            for floor in segment["Floors"]:
                names = {gs["Value"]["$type"].split("`")[0].split(",")[0].split(".")[-1]
                         for gs in floor["GenSteps"]}
                self.assertTrue(needed <= names, names)
                paths |= {n for n in names if n.startswith("GridPath")}
        self.assertGreaterEqual(len(paths), 1)

    def test_not_a_single_architecture_for_every_floor(self):
        comments = [floor["Comment"] for segment in self.zone["Segments"] for floor in segment["Floors"]]
        profiles = {c.split("profile ")[1].split(" —")[0] for c in comments}
        grids = {c.split("grid ")[1].split(" ")[0] for c in comments}
        self.assertGreaterEqual(len(profiles), 3, profiles)
        self.assertGreaterEqual(len(grids), 3, grids)

    def test_zone_steps_carry_spawns_items_shop_and_house(self):
        for segment in self.zone["Segments"]:
            names = {zs["$type"].split("`")[0].split(",")[0].split(".")[-1] for zs in segment["ZoneSteps"]}
            self.assertIn("TeamSpawnZoneStep", names)
            self.assertIn("ItemSpawnZoneStep", names)
            self.assertIn("MoneySpawnZoneStep", names)
            self.assertIn("SpreadStepRangeZoneStep", names)   # Kecleon shop
            self.assertIn("SpreadHouseZoneStep", names)       # monster house

    def test_shop_uses_native_kecleon_template(self):
        shop = None
        for zs in self.zone["Segments"][0]["ZoneSteps"]:
            if "SpreadStepRangeZoneStep" in zs["$type"]:
                shop = zs["Spawns"][0]["Spawn"]
        self.assertIsNotNone(shop)
        self.assertIn("ShopStep", shop["$type"])
        self.assertTrue(shop["Items"])
        self.assertTrue(shop["Mobs"])
        self.assertEqual(shop["StartMob"]["BaseForm"]["Species"], "kecleon")
        self.assertEqual(shop["SecurityStatus"], "shop_security")

    def test_weather_steps_only_on_declared_floors(self):
        for segment_index, segment in enumerate(self.zone["Segments"]):
            first_floor = self.definition.segments[segment_index].floors[0]
            for offset, floor in enumerate(segment["Floors"]):
                names = [gs["Value"]["$type"] for gs in floor["GenSteps"]]
                has_weather = any("DefaultMapStatusStep" in n for n in names)
                if has_weather:
                    self.assertGreaterEqual(first_floor + offset, 6)

    def test_minibosses_are_emitted_on_their_floor_and_stronger(self):
        placements = []
        for seg_index, segment in enumerate(self.zone["Segments"]):
            first = self.definition.segments[seg_index].floors[0]
            for offset, floor in enumerate(segment["Floors"]):
                for gs in floor["GenSteps"]:
                    if "MobSpawnStep" in gs["Value"]["$type"]:
                        spawn = gs["Value"]["Spawns"][0]["Spawn"]["Spawns"][0]["Spawn"]["Spawn"]
                        placements.append((first + offset, spawn["BaseForm"]["Species"],
                                           spawn["Level"]["Min"]))
        declared = {(int(m["floor"]), m["species"]) for m in self.definition.minibosses}
        self.assertEqual({(f, s) for f, s, _ in placements}, declared)
        residents = max(m.level[1] for m in self.definition.mobs_for(self.definition.segments[1]))
        for _, _, level in placements:
            self.assertGreater(level, residents, "a miniboss must outclass the segment residents")

    def test_no_precomputed_layout_in_output(self):
        blob = json.dumps(self.zone)
        self.assertNotIn("MappedRoomStep", blob)   # no static map baked into procedural floors
        self.assertNotIn('"Seed"', blob)           # never a stored seed

    def test_fixed_floor_uses_loadgen(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["segments"][2]["fixed_floors"] = {"14": {"map": "searing_crucible", "comment": "test"}}
        definition = parse_definition(raw)
        export = build_zone(definition, DungeonRng(seed=7))
        last = export.zone_json["Object"]["Segments"][2]["Floors"][-1]
        self.assertIn("LoadGen", last["$type"])
        self.assertIn("MappedRoomStep", last["GenSteps"][0]["Value"]["$type"])
        self.assertFalse(export.warnings, export.warnings)

    def test_type_vocabulary_matches_shipped_zones(self):
        known = set()
        for path in (REPO / "Data" / "Zone").glob("*.json"):
            if path.name == "gloomy_forest.json":
                continue
            known.update(re.findall(r'"\$type": "([^"]+)"', path.read_text(encoding="utf-8-sig")))
        produced = set(re.findall(r'"\$type": "([^"]+)"', json.dumps(self.export.zone_json)))
        unknown = produced - known
        allowed = {"RogueElements.GridPathCross`1[[RogueEssence.LevelGen.MapGenContext, "
                   "RogueEssence]], RogueElements"}
        self.assertTrue(unknown <= allowed, unknown - allowed)


class TestGroundsAndBoss(unittest.TestCase):
    def test_canonical_end_ground_is_reused_for_the_boss(self):
        d = load_sinister()
        check = check_grounds(d)
        self.assertTrue(check.ok, check.problems)
        self.assertEqual(check.boss_mode, "canonical_ground")
        self.assertEqual(check.boss_ground, "sinister_woods_clearing")
        self.assertTrue((REPO / "Data" / "Ground" / "sinister_woods_clearing.rsground").exists())
        self.assertTrue(any("canonical end Ground" in n for n in check.notes))

    def test_dedicated_arena_requires_an_existing_rsmap(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["boss"] = {"mode": "dedicated_arena", "map": "no_such_arena"}
        d = parse_definition(raw)
        check = check_grounds(d)
        self.assertFalse(check.ok)
        self.assertTrue(any("no_such_arena" in p for p in check.problems))

    def test_midpoint_is_a_fixed_retextured_ground(self):
        d = load_sinister()
        self.assertTrue(d.midpoint["template"])
        self.assertTrue((REPO / "Data" / "Ground" / f"{d.midpoint['template']}.rsground").exists())
        self.assertEqual(d.midpoint["retexture"], "sinister_woods_b41")
        for feature in ("checkpoint", "heal", "save", "rest"):
            self.assertTrue(d.midpoint[feature])

    def test_pending_midpoint_ground_is_reported(self):
        check = check_grounds(load_sinister())
        self.assertTrue(any("midpoint Ground still to be produced" in n for n in check.notes))

    def test_declared_missing_ground_is_reported(self):
        raw = json.loads(SINISTER.read_text(encoding="utf-8-sig"))
        raw["fixed_grounds"]["mid"] = "ground_that_does_not_exist"
        check = check_grounds(parse_definition(raw))
        self.assertFalse(check.ok)


class TestNonRegression(unittest.TestCase):
    def test_other_zones_remain_valid_json(self):
        for path in sorted((REPO / "Data" / "Zone").glob("*.json")):
            data = json.loads(path.read_text(encoding="utf-8-sig"))
            self.assertIn("Object", data, path.name)

    def test_zone_index_contains_the_generated_dungeon(self):
        index = json.loads((REPO / "Data" / "Zone" / "index.idx").read_text(encoding="utf-8-sig"))
        entry = index["Object"].get("gloomy_forest")
        self.assertIsNotNone(entry, "the builder must register the zone in index.idx")
        self.assertEqual(entry["CountedFloors"], 14)
        self.assertIn("sinister_woods_clearing", entry["Grounds"])

    def test_aegis_cloven_ruins_untouched(self):
        path = REPO / "Data" / "Zone" / "cloven_ruins.json"
        data = json.loads(path.read_text(encoding="utf-8-sig"))
        self.assertIn("Segments", data["Object"])

    def test_generated_zone_matches_definition(self):
        zone = json.loads((REPO / "Data" / "Zone" / "gloomy_forest.json").read_text(encoding="utf-8-sig"))
        obj = zone["Object"]
        self.assertEqual(obj["Name"]["DefaultText"], "Sinister Woods")
        self.assertEqual(sum(len(s["Floors"]) for s in obj["Segments"]), 14)
        blob = json.dumps(obj)
        self.assertIn("sinister_woods_b41_floor", blob)
        self.assertIn("sinister_woods_b41_wall", blob)


if __name__ == "__main__":
    unittest.main(verbosity=2)
