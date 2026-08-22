#!/usr/bin/env python3
"""Structural regression suite for the one-delivery canonical dungeon bundle."""
from __future__ import annotations

import json
import subprocess
import unittest
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "docs/canonical_dungeons/complete_bundle_registry.json"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))["Object"]


class CompleteCanonicalBundleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = json.loads(REGISTRY.read_text())
        cls.physical = [
            row
            for row in cls.registry["main_route"] + cls.registry["pmd_red_roster"]
            if not row.get("existing") and not row.get("alias_of")
        ]

    def test_requested_combined_scope_is_complete(self):
        scope = self.registry["scope"]
        self.assertEqual(scope["main_route_entries"], 27)
        self.assertEqual(scope["pmd_red_roster_entries"], 51)
        self.assertEqual(scope["shared_aliases"], 5)
        self.assertEqual(scope["physical_generated_entries"], 72)
        self.assertEqual(len(self.physical), 72)

    def test_every_physical_zone_has_grounds_index_and_runtime_families(self):
        index = load(ROOT / "Data/Zone/index.idx")
        master = load(ROOT / "Data/Zone/master_zone.json")
        for entry in self.physical:
            zone_id = entry["id"]
            zone_path = ROOT / "Data/Zone" / f"{zone_id}.json"
            self.assertTrue(zone_path.is_file(), zone_id)
            zone = load(zone_path)
            self.assertEqual(zone["Name"]["DefaultText"], entry["public_name"])
            self.assertTrue((ROOT / "Content/Music" / entry["music"]).is_file(), entry["music"])
            self.assertEqual(zone["GroundMaps"], [f"{zone_id}_entrance", f"{zone_id}_mid", f"{zone_id}_boss"])
            self.assertIn(zone_id, index)
            self.assertEqual(index[zone_id]["CountedFloors"], entry["canonical_floor_count"])
            expected_maps = []
            for segment in zone["Segments"]:
                floors = segment.get("Floors")
                if isinstance(floors, dict):
                    expected_maps.append([floor for node in floors["nodes"] for floor in range(node["Range"]["Min"], node["Range"]["Max"])])
                else:
                    expected_maps.append(list(range(len(floors or []))))
            self.assertEqual(index[zone_id]["Maps"], expected_maps, zone_id)
            payload = json.dumps(zone, ensure_ascii=False)
            self.assertNotIn("FirstSeed", payload)
            self.assertNotIn('"seed"', payload.lower())
            self.assertIn("ChanceFloorGen", payload)
            mechanics = entry.get("mechanics", {})
            if mechanics.get("traps"):
                self.assertIn("trap_trip", payload, zone_id)
            if mechanics.get("kecleon"):
                self.assertIn("ShopStep", payload, zone_id)
            if mechanics.get("monster_house"):
                self.assertIn("SpreadHouseZoneStep", payload, zone_id)
            self.assertIn("GridPath", payload)
            exploration = [segment for segment in zone["Segments"] if "RangeDictSegment" in segment["$type"]]
            segment_materials = []
            for segment in exploration:
                texture = next(value["Value"] for node in segment["Floors"]["nodes"] for choice in node["Item"]["Spawns"] for value in choice["Spawn"]["GenSteps"] if "MapTextureStep" in value.get("Value", {}).get("$type", ""))
                segment_materials.append(texture["GroundTileset"])
            if len(segment_materials) > 1:
                self.assertGreaterEqual(len(set(segment_materials)), 2, f"biome gradient missing: {zone_id}")
            for name in zone["GroundMaps"]:
                self.assertIn(name, master["GroundMaps"], name)
                ground_path = ROOT / "Data/Ground" / f"{name}.rsground"
                self.assertTrue(ground_path.is_file(), name)
                script_path = ROOT / "Data/Script/halcyon/ground" / name / "init.lua"
                self.assertTrue(script_path.is_file(), name)
                script = script_path.read_text(encoding="utf-8")
                self.assertIn(f"function {name}.Init", script, name)
                self.assertIn(f"function {name}.Enter", script, name)
                ground = load(ground_path)
                materials = {cell["AutoTileset"] for layer in ground["Layers"] for column in layer["Tiles"] for cell in column}
                binding = entry["dtef"] if not name.endswith("_boss") else zone["CanonicalBundle"]["final_dtef"]
                self.assertEqual(materials, {binding["runtime_floor"], binding["runtime_wall"]}, name)
                obstacles = ground["obstacles"]
                marker = next(item for item in ground["Entities"][0]["Markers"] if item["EntName"] == "Main_Entrance_Marker")
                start = (marker["Collider"]["X"] // 8, marker["Collider"]["Y"] // 8)
                self.assertEqual(obstacles[start[0]][start[1]]["Tags"], 0, name)
                seen = {start}
                todo = deque([start])
                while todo:
                    x, y = todo.popleft()
                    for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                        px, py = point
                        if 0 <= px < len(obstacles) and 0 <= py < len(obstacles[0]) and obstacles[px][py]["Tags"] == 0 and point not in seen:
                            seen.add(point)
                            todo.append(point)
                for item in ground["Entities"][0].get("GroundObjects", []):
                    position = (item["Collider"]["X"] // 8, item["Collider"]["Y"] // 8)
                    self.assertTrue(any((position[0] + dx, position[1] + dy) in seen for dx in (-1, 0, 1) for dy in (-1, 0, 1)), f"{name}/{item['EntName']}")
            zone_script = ROOT / "Data/Script/halcyon/zone" / zone_id / "init.lua"
            self.assertTrue(zone_script.is_file(), zone_id)
            source = zone_script.read_text(encoding="utf-8")
            self.assertIn(f"function {zone_id}.Init", source, zone_id)
            self.assertIn(f"function {zone_id}.ExitSegment", source, zone_id)

    def test_spawn_pools_are_between_ten_and_twenty_and_keep_source_provenance(self):
        known = set(load(ROOT / "Data/Misc/MonsterFeature.json")["FeatureData"])
        for entry in self.physical:
            zone = load(ROOT / "Data/Zone" / f"{entry['id']}.json")
            for segment in zone["Segments"]:
                if "RangeDictSegment" not in segment["$type"]:
                    continue
                team = next(step for step in segment["ZoneSteps"] if "TeamSpawnZoneStep" in step["$type"])
                species = {row["Spawn"]["Spawn"]["BaseForm"]["Species"] for row in team["Spawns"]}
                self.assertGreaterEqual(len(species), 10, entry["id"])
                self.assertLessEqual(len(species), 20, entry["id"])
                self.assertTrue(species <= known, f"unknown species in {entry['id']}: {species - known}")
                self.assertTrue(all(row["Spawn"]["Spawn"].get("Comment") == "CANONICAL_SOURCE_ADAPTED_PMDO" for row in team["Spawns"]))

    def test_fixed_boss_maps_match_the_registered_bosses(self):
        for entry in self.physical:
            expected = entry.get("boss_species", [])
            path = ROOT / "Data/Map" / f"{entry['id']}_boss.rsmap"
            if not expected:
                self.assertFalse(path.exists(), entry["id"])
                continue
            self.assertTrue(path.is_file(), entry["id"])
            game_map = load(path)
            actual = [team["Players"][0]["BaseForm"]["Species"] for team in game_map["MapTeams"]]
            self.assertEqual(actual, expected[:3], entry["id"])
            self.assertTrue(all(team["Players"][0]["Unrecruitable"] for team in game_map["MapTeams"]), entry["id"])

    def test_aliases_resolve_to_real_canonical_zones_without_duplicate_files(self):
        index = load(ROOT / "Data/Zone/index.idx")
        aliases = [row for row in self.registry["pmd_red_roster"] if row.get("alias_of")]
        self.assertEqual(len(aliases), 5)
        for alias in aliases:
            self.assertIn(alias["alias_of"], index)
            self.assertFalse((ROOT / "Data/Zone" / f"{alias['id']}.json").exists())

    def test_dtef_source_manifest_exists_for_each_unique_biome(self):
        bindings = json.loads((ROOT / "docs/canonical_dungeons/complete_dtef_bindings.json").read_text())
        self.assertEqual(len(bindings["bindings"]), 78)
        folders = {row["dtef"]["rawasset_folder"] for row in self.registry["main_route"] + self.registry["pmd_red_roster"]}
        for folder in folders:
            source = ROOT / "Content/TileDtef/canonical" / folder / "RAWASSET_PROVENANCE.json"
            self.assertTrue(source.is_file(), folder)
            payload = json.loads(source.read_text())
            self.assertEqual(payload["path"], f"TileDtef/{folder}")
            self.assertTrue(payload["files"])

    def test_builder_and_dtef_checker_pass(self):
        subprocess.run(["python3", str(ROOT / "tools/build_complete_canonical_bundle.py"), "--check"], cwd=ROOT, check=True)
        subprocess.run(["python3", str(ROOT / "tools/fetch_canonical_dtef_sources.py"), "--check"], cwd=ROOT, check=True)
        subprocess.run(["python3", str(ROOT / "tools/validate_complete_canonical_variation.py")], cwd=ROOT, check=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
