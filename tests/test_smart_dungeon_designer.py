#!/usr/bin/env python3
import json
import random
import shutil
import tempfile
import unittest
from pathlib import Path
import sys

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "tools"))

from smart_dungeon.art_direction import build_art_direction
from smart_dungeon.assets import analyze_library
from smart_dungeon.ground_gen import generate_ground
from smart_dungeon.ground_library import interpret_ground_intent
from smart_dungeon.intent import parse_intent
from smart_dungeon.knowledge import analyze_references
from smart_dungeon.layout import progression, repair, select_best
from smart_dungeon.model import FloorPlan, Room
from smart_dungeon.project import copy_floor, generate_project, regenerate, validate_project, write
from smart_dungeon.quality import evaluate, evaluate_dungeon


class TestSmartDungeonDesigner(unittest.TestCase):
    def test_01_natural_intent_and_semantic_special_schedule(self):
        brief = parse_intent(
            "Sanctuaire",
            "Un donjon ancien et majestueux de 25 étages, ouvert au début puis "
            "labyrinthique et inquiétant, avec un boss final, deux mini-boss, "
            "trois relais, une progression circulaire, sans eau.",
            seed=42,
        )
        self.assertEqual(brief.floors, 25)
        self.assertTrue(brief.boss)
        self.assertEqual(brief.mini_bosses, 2)
        self.assertEqual(brief.relays, 3)
        self.assertEqual(brief.topology_start, "open")
        self.assertEqual(brief.topology_end, "labyrinth")
        self.assertEqual(brief.water_policy, "forbid")
        self.assertIn("circular_progression", brief.composition_preferences)
        rows = progression(brief)
        self.assertIsNone(rows[-1]["special"])
        self.assertTrue(rows[-1]["final_approach"])
        self.assertEqual(rows[-1]["approach_to"], "boss_ground")
        relay_floors = [row["floor"] for row in rows if row["relay_after"]]
        self.assertEqual(len(relay_floors), 3)
        self.assertEqual(relay_floors, [6, 12, 19])
        self.assertTrue(all(row["special"] != "relay" for row in rows))
        self.assertGreaterEqual(rows[-1]["spectacle"], .8)

    def test_02_candidate_search_is_deterministic_and_not_scalar_only(self):
        brief = parse_intent("Test", "12 étages, début ouvert puis labyrinthique, boss final", seed=777, boss=True)
        row = progression(brief)[5]
        roles = {"common": ["a", "b"], "secondary": ["c"], "rare": ["d"], "focal": ["e"]}
        first, first_variants = select_best(brief, row, brief.seed, roles, variants=4)
        second, second_variants = select_best(brief, row, brief.seed, roles, variants=4)
        self.assertEqual(first.to_dict(), second.to_dict())
        self.assertEqual(first_variants, second_variants)
        self.assertEqual(sum(row["selected"] for row in first_variants), 1)
        self.assertEqual(first.identity["variant_selection"]["policy"], "admissibility_then_bottleneck_then_identity_then_novelty_then_aggregate")
        self.assertEqual(first.quality["metrics"]["accessibility"], 1)
        self.assertIn("structural_score", first.quality)
        self.assertIn("visual_score", first.quality)

    def test_03_local_repair_connects_only_the_broken_structure(self):
        tiles = ["wall"] * (20 * 15)
        rooms = [
            Room(0, "rect", 2, 2, 3, 3, [[1] * 3 for _ in range(3)]),
            Room(1, "rect", 15, 10, 3, 3, [[1] * 3 for _ in range(3)]),
        ]
        plan = FloorPlan(1, 1, 20, 15, "loops", "development", None, "test", rooms, [], tiles, [3, 3], [16, 11])
        for room in rooms:
            for y in range(room.y, room.y + room.height):
                for x in range(room.x, room.x + room.width):
                    plan.set(x, y, "room")
        before = evaluate(plan)
        self.assertIn("DISCONNECTED", {row["code"] for row in before["violations"]})
        repair(plan, before, random.Random(1))
        after = evaluate(plan)
        self.assertGreater(after["metrics"]["accessibility"], before["metrics"]["accessibility"])
        self.assertIn("connect_components", {row["action"] for row in plan.repair_log})
        self.assertTrue(all(row["localized"] for row in plan.repair_log))

    def test_04_asset_analysis_is_multi_source_and_reports_uncertainty(self):
        with tempfile.TemporaryDirectory(dir=REPO / ".runtime-cache") as temp:
            output = Path(temp) / "assets.json"
            data = analyze_library(REPO, output, max_sheets=5, max_grounds=12, samples_per_sheet=4)
            self.assertEqual(data["result"], "ASSET_SEMANTIC_ANALYSIS_PASS")
            self.assertEqual(data["schema_version"], "2.0.0")
            self.assertEqual(data["ground_sheet_count"], 5)
            self.assertGreater(data["dungeon_texture_bundle_count"], 0)
            self.assertIn("ambiguous_asset_count", data)
            sheets = [row for row in data["assets"] if row["kind"] == "ground_tile_sheet"]
            self.assertTrue(all(row["role_scores"] and row["cluster_id"] for row in sheets))
            self.assertTrue(all("evidence_sources" in row and "uncertainty_reasons" in row for row in sheets))
            self.assertTrue(any(row["compatible"] for row in data["assets"] if row["kind"] == "dungeon_texture_bundle"))

    @classmethod
    def setUpClass(cls):
        (REPO / ".runtime-cache").mkdir(exist_ok=True)
        cls.temp = Path(tempfile.mkdtemp(dir=REPO / ".runtime-cache", prefix="smart-phase2-test-"))
        cls.p1, cls.p2 = cls.temp / "one", cls.temp / "two"
        cls.intent = (
            "Un sanctuaire ancien et majestueux de 8 étages, ouvert au début puis "
            "labyrinthique et inquiétant, avec un boss final, un mini-boss, deux "
            "relais et une grande salle centrale."
        )
        cls.plan1 = generate_project(REPO, cls.p1, "Sanctuaire Test", cls.intent, 8, "difficile", True, 1, 2, 12345, None, 3, 5)
        cls.p2.mkdir(exist_ok=True)
        shutil.copy2(cls.p1 / "reference_knowledge.json", cls.p2 / "reference_knowledge.json")
        cls.plan2 = generate_project(REPO, cls.p2, "Sanctuaire Test", cls.intent, 8, "difficile", True, 1, 2, 12345, None, 3, 5)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.temp, ignore_errors=True)

    def test_05_art_direction_is_selective_hierarchical_and_explainable(self):
        direction = self.plan1.art_direction
        self.assertEqual(direction["schema_version"], "2.0.0")
        self.assertTrue(direction["vocabulary"]["primary"])
        ids = [row["asset_id"] for tier in direction["vocabulary"].values() for row in tier]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertLessEqual(len(ids), self.plan1.asset_selection["asset_count"])
        self.assertTrue(all(row["reason"] and row["purpose"] for tier in direction["vocabulary"].values() for row in tier))
        self.assertTrue(direction["asset_budgets"])
        self.assertTrue(direction["decisions"])

    def test_06_complete_project_has_two_quality_layers_and_native_zone(self):
        project = self.p1
        required = [
            "asset_catalog.json", "reference_knowledge.json", "brief.json", "progression.json", "project.json",
            "dungeon_profile.json", "quality_report.json", "artistic_quality_report.json", "art_direction.json",
            "decision_log.json", "finale/boss_encounter.json", "generation_manifest.json", "previews/contact_sheet.svg",
            "previews/design_board.svg", "previews/special_rooms.svg", "previews/relays.svg",
            "relays/manifest.json", "zone/sanctuaire_test.json",
        ]
        self.assertTrue(all((project / path).exists() for path in required))
        self.assertEqual(len(list((project / "plans").glob("floor_*.json"))), 8)
        self.assertEqual(len(list((project / "previews").glob("floor_*.svg"))), 8)
        result = validate_project(project)
        self.assertEqual(result["result"], "SMART_DUNGEON_VALIDATION_PASS")
        self.assertGreaterEqual(result["stairs_step_count"], 8)
        self.assertEqual(result["relay_count"], 2)
        self.assertEqual(result["segment_count"], 4)
        self.assertEqual(result["compiled_floor_count"], 8)
        self.assertLessEqual(result["boss_distance_tiles"], 6)
        self.assertEqual(result["profile_validation"], "DUNGEON_PROFILE_PASS")
        self.assertGreater(result["minimum_structural_score"], 72)
        self.assertGreater(result["minimum_visual_score"], 60)
        zone = json.loads((project / "zone/sanctuaire_test.json").read_text(encoding="utf-8-sig"))["Object"]
        self.assertTrue(zone["Released"])
        self.assertEqual(len(zone["Segments"]), 4)
        self.assertEqual(sum(len(segment["Floors"]["nodes"]) for segment in zone["Segments"] if isinstance(segment.get("Floors"), dict)), 8)
        self.assertEqual(zone["GroundMaps"], [relay.relay_id for relay in self.plan1.relays] + [self.plan1.boss_encounter.arena_id])
        boss_segment = zone["Segments"][self.plan1.boss_encounter.battle_segment]
        self.assertNotIn("FloorStairsStep", json.dumps(boss_segment))
        self.assertIn(self.plan1.boss_encounter.arena_id, json.dumps(boss_segment))
        self.assertTrue(all((project / relay.ground_file).exists() and (project / relay.script_file).exists() for relay in self.plan1.relays))
        self.assertTrue(all("missingno" not in (project / relay.ground_file).read_text(encoding="utf-8-sig").casefold() for relay in self.plan1.relays))
        boss = self.plan1.boss_encounter
        self.assertTrue((project / boss.ground_file).exists() and (project / boss.ground_script_file).exists() and (project / boss.scene_script_file).exists() and (project / boss.preview_file).exists())
        self.assertNotIn("missingno", (project / boss.ground_file).read_text(encoding="utf-8-sig").casefold())

    def test_07_floor_identity_groups_landmarks_and_room_functions_are_realized(self):
        families = set()
        landmark_floor_count = 0
        for floor in self.plan1.floors:
            families.add(floor.identity["composition_family"])
            self.assertTrue(floor.identity["signature"])
            self.assertTrue(floor.composition_regions)
            self.assertTrue(floor.spatial_beats)
            self.assertTrue(floor.decoration_groups)
            landmark_floor_count += bool(floor.landmarks)
            self.assertTrue(floor.decisions)
            self.assertTrue(any(room.function != "exploration" and room.design_reason for room in floor.rooms))
            self.assertGreaterEqual(floor.quality["visual_score"], 60)
        self.assertGreaterEqual(len(families), 5)
        self.assertGreaterEqual(landmark_floor_count, 4)
        self.assertTrue(self.plan1.artistic_quality_summary["accepted"])

    def test_08_structurally_valid_but_visually_flat_floor_is_rejected(self):
        good = self.plan1.floors[0]
        bad = copy_floor(good)
        for decoration in bad.decorations:
            decoration["asset_id"] = "repeated_asset"
            decoration.pop("group_id", None)
        bad.decoration_groups = []
        bad.landmarks = []
        bad.identity = {}
        bad.composition_regions = []
        bad.spatial_beats = []
        quality = evaluate(bad)
        self.assertTrue(quality["structural"]["accepted"])
        self.assertFalse(quality["artistic"]["accepted"])
        self.assertFalse(quality["accepted"])
        self.assertLess(quality["visual_score"], good.quality["visual_score"])

    def test_09_same_library_different_intents_create_different_identities(self):
        catalog_path = self.p1 / "asset_catalog.json"
        catalog = json.loads(catalog_path.read_text())
        open_brief = parse_intent("Clairière", "8 étages très ouverts, calmes, épurés, avec plusieurs îlots et une grande zone ouverte", seed=10)
        maze_brief = parse_intent("Dédale", "8 étages inquiétants, très labyrinthiques, asymétriques, dominés par des couloirs", seed=10)
        open_direction = build_art_direction(catalog, open_brief)
        maze_direction = build_art_direction(catalog, maze_brief)
        open_rows = progression(open_brief, open_direction)
        maze_rows = progression(maze_brief, maze_direction)
        self.assertNotEqual(open_direction["identity_id"], maze_direction["identity_id"])
        self.assertNotEqual([row["composition_family"] for row in open_rows], [row["composition_family"] for row in maze_rows])
        self.assertNotEqual(open_direction["visual_axes"], maze_direction["visual_axes"])

        # End-to-end proof: exact same catalog and seed, same special-event count,
        # but a different intent changes actual selected architectures.
        alternative_path = self.temp / "alternative"
        alternative_path.mkdir(exist_ok=True)
        shutil.copy2(catalog_path, alternative_path / "asset_catalog.json")
        alternative = generate_project(
            REPO, alternative_path, "Clairière Test",
            "Un sanctuaire calme et épuré de 8 étages, très ouvert, composé de plusieurs îlots, avec un boss, un mini-boss et deux relais.",
            8, "difficile", True, 1, 2, 12345, None, 2, 5,
        )
        self.assertEqual(catalog_path.read_bytes(), (alternative_path / "asset_catalog.json").read_bytes())
        self.assertNotEqual(self.plan1.art_direction["identity_id"], alternative.art_direction["identity_id"])
        first_families = [floor.identity["composition_family"] for floor in self.plan1.floors]
        alternative_families = [floor.identity["composition_family"] for floor in alternative.floors]
        self.assertNotEqual(first_families, alternative_families)
        changed_tiles = sum(left.tiles != right.tiles for left, right in zip(self.plan1.floors, alternative.floors))
        self.assertGreaterEqual(changed_tiles, 5)

    def test_10_same_seed_same_phase2_plans_direction_decisions_and_zone(self):
        first = json.loads((self.p1 / "project.json").read_text())
        second = json.loads((self.p2 / "project.json").read_text())
        self.assertEqual(first["brief"], second["brief"])
        self.assertEqual(first["art_direction"], second["art_direction"])
        self.assertEqual(first["progression"], second["progression"])
        self.assertEqual(first["floors"], second["floors"])
        self.assertEqual(first["decision_log"], second["decision_log"])
        self.assertEqual(first["relays"], second["relays"])
        self.assertEqual(first["dungeon_profile"], second["dungeon_profile"])
        self.assertEqual(first["boss_encounter"], second["boss_encounter"])
        self.assertEqual((self.p1 / "zone/sanctuaire_test.json").read_bytes(), (self.p2 / "zone/sanctuaire_test.json").read_bytes())
        for relay in self.plan1.relays:
            self.assertEqual((self.p1 / relay.ground_file).read_bytes(), (self.p2 / relay.ground_file).read_bytes())
            self.assertEqual((self.p1 / relay.script_file).read_bytes(), (self.p2 / relay.script_file).read_bytes())
        for path in (self.plan1.boss_encounter.ground_file, self.plan1.boss_encounter.ground_script_file, self.plan1.boss_encounter.scene_script_file, self.plan1.boss_encounter.preview_file):
            self.assertEqual((self.p1 / path).read_bytes(), (self.p2 / path).read_bytes())

    def test_11_locks_and_local_regeneration_remain_compatible(self):
        project = self.p1
        before = json.loads((project / "plans/floor_008.json").read_text())
        locks = json.loads((project / "locks.json").read_text())
        locks.setdefault("floors", {})["8"] = {"locked": True}
        write(project / "locks.json", locks)
        regenerate(REPO, project, "floor:8", 99999, False, 2)
        after = json.loads((project / "plans/floor_008.json").read_text())
        self.assertEqual(before, after)
        floor2_before = json.loads((project / "plans/floor_002.json").read_text())
        floor3_before = json.loads((project / "plans/floor_003.json").read_text())
        regenerate(REPO, project, "decor:3", 12345, False, 2)
        floor2_after = json.loads((project / "plans/floor_002.json").read_text())
        floor3_after = json.loads((project / "plans/floor_003.json").read_text())
        self.assertEqual(floor2_before, floor2_after)
        self.assertEqual(floor3_before["tiles"], floor3_after["tiles"])
        self.assertEqual(floor3_before["rooms"], floor3_after["rooms"])
        self.assertNotEqual(floor3_before["decorations"], floor3_after["decorations"])

    def test_12_special_rooms_have_spatial_context_contracts(self):
        compiler = self.plan2.compiler
        boss = compiler["boss_contract"]
        self.assertIsNotNone(boss)
        self.assertEqual(len(compiler["mini_boss_contracts"]), 1)
        self.assertEqual(len(compiler["relay_contracts"]), 2)
        self.assertEqual(boss["battle_segment"], 3)
        self.assertLessEqual(boss["distance_tiles"], 6)
        self.assertFalse(boss["completion"]["stairs"])
        self.assertFalse(boss["completion"]["physical_exit"])
        self.assertEqual(boss["validation"]["result"], "BOSS_ENCOUNTER_PASS")
        self.assertEqual(boss["flow"], ["arrivee", "introduction", "dialogue_precombat", "transition_combat", "combat", "victoire", "conclusion", "fin_donjon"])
        self.assertTrue(all(contract["kangaskhan_rock"] for contract in compiler["relay_contracts"]))
        self.assertTrue(all(contract["validation"]["two_distinct_routes"] for contract in compiler["relay_contracts"]))
        self.assertEqual([(relay.previous_segment, relay.next_segment) for relay in self.plan2.relays], [(0, 1), (1, 2)])
        self.assertEqual([relay.after_floor for relay in self.plan2.relays], [3, 5])
        self.assertTrue(all(floor.special not in ("relay", "boss") for floor in self.plan2.floors))
        self.assertTrue(self.plan2.floors[-1].identity["approach_to"] == "boss_ground")
        self.assertEqual(len(compiler["floor_design_contracts"]), 8)

    def test_13_reference_knowledge_reuses_native_gameplay_models(self):
        knowledge = json.loads((self.p1 / "reference_knowledge.json").read_text())
        self.assertEqual(knowledge["result"], "REFERENCE_KNOWLEDGE_PASS")
        self.assertEqual(knowledge["ground_count"], len(list((REPO / "Data/Ground").glob("*.rsground"))))
        self.assertGreater(knowledge["map_template_count"], 0)
        self.assertGreater(knowledge["autotile_count"], 0)
        self.assertGreater(knowledge["controller_count"], 0)
        self.assertTrue(knowledge["external_libraries"])
        self.assertTrue(any(row["variant_count"] >= 16 and row["orientation_policy"] == "native_neighbor_variant_keys_no_arbitrary_flip" for row in knowledge["autotiles"]))
        self.assertIn("vast_steppe", knowledge["shop_reference_zones"])
        self.assertIn("desert_oublies", knowledge["neutral_reference_zones"])
        self.assertIn("vast_steppe_guardian", knowledge["boss_reference_grounds"])
        tunnel = next(zone for zone in knowledge["zones"] if zone["zone_id"] == "searing_tunnel")
        self.assertGreaterEqual(tunnel["segment_count"], 3)
        self.assertTrue(tunnel["shops"] and tunnel["species_ids"] and tunnel["item_ids"])
        altere = next(ground for ground in knowledge["grounds"] if ground["ground_id"] == "altere_pond")
        self.assertTrue(altere["topology_grammar"])
        self.assertGreater(altere["water_visual_cell_count"], 0)
        self.assertTrue(altere["animation_frame_lengths"])

    def test_14_each_floor_has_own_population_loot_shop_and_rule_tables(self):
        profile = self.plan1.dungeon_profile
        self.assertEqual(profile["validation"]["result"], "DUNGEON_PROFILE_PASS")
        self.assertEqual(len(profile["floor_rules"]), 8)
        for floor in profile["floor_rules"]:
            self.assertTrue(floor["enemy_table"])
            self.assertTrue(floor["ground_loot_table"])
            self.assertIn("chance_percent", floor["shop"])
            self.assertIn("starting_enemies", floor["rules"])
            self.assertFalse(floor["special_room_permissions"]["relay"])
            self.assertFalse(floor["special_room_permissions"]["boss_arena"])
        for left, right in zip(profile["segments"], profile["segments"][1:]):
            overlap = {row["species"] for row in left["enemy_table"]} & {row["species"] for row in right["enemy_table"]}
            self.assertGreaterEqual(len(overlap), 4)
        neutral = [row for stage in profile["segments"] for row in stage["neutral_table"]]
        self.assertTrue(neutral)
        self.assertTrue(all(row["behavior"] == "neutral_interactable" and row["ally"] for row in neutral))
        zone = json.loads((self.p1 / "zone/sanctuaire_test.json").read_text(encoding="utf-8-sig"))
        self.assertIn("SpreadPlanChance", json.dumps(zone))
        self.assertIn("ShopkeeperInteract", json.dumps(zone))
        for segment, stage in zip(zone["Object"]["Segments"][:3], profile["segments"]):
            shop_steps = []
            def collect(value):
                if isinstance(value, dict):
                    if "ShopStep" in value.get("$type", ""):
                        shop_steps.append(value)
                    for child in value.values():
                        collect(child)
                elif isinstance(value, list):
                    for child in value:
                        collect(child)
            collect(segment)
            eligible_count = sum(1 for floor in profile["floor_rules"] if floor["segment"] == stage["segment"] and floor["shop"]["eligible"])
            self.assertEqual(bool(shop_steps), eligible_count > 0)
            if eligible_count:
                self.assertEqual(len(shop_steps), eligible_count * 2)  # two native Kecleon variants per eligible floor
            profile_items = {row["item_id"] for row in stage["kecleon"]["assortment"]}
            for shop_step in shop_steps:
                compiled_items = {row["Spawn"]["Value"] for row in shop_step["Items"]}
                self.assertEqual(compiled_items, profile_items)

    def test_15_topology_aware_ground_generation_with_animated_lakes(self):
        first_dir, second_dir = self.temp / "ground_first", self.temp / "ground_second"
        knowledge = json.loads((self.p1 / "reference_knowledge.json").read_text())
        intent = "Une clairière de forêt sombre avec trois petits lacs animés, des groupes d'arbres et des rochers"
        first = generate_ground(REPO, first_dir, "clairiere_lacs", intent, 20260813, 3, None, 64, 48, knowledge, "altere_pond")
        second = generate_ground(REPO, second_dir, "clairiere_lacs", intent, 20260813, 3, None, 64, 48, knowledge, "altere_pond")
        self.assertEqual(first["validation"]["result"], "GROUND_VALIDATION_PASS")
        self.assertEqual(first["validation"]["water_component_count"], 3)
        self.assertGreater(first["validation"]["topology_exact_ratio"], .90)
        self.assertGreater(first["validation"]["water_animation_coverage"], .9)
        self.assertGreaterEqual(first["validation"]["decoration_group_count"], 4)
        self.assertTrue(all(not group["transformed"] for group in first["decoration"]["groups"]))
        self.assertNotIn("metano", first["reference_selection"]["base_ground"])
        self.assertGreater(first["reference_selection"]["confidence"], .5)
        self.assertTrue(first["tile_grammar"]["topology_roles"])
        self.assertGreater(first["quality_scores"]["structural"], 70)
        self.assertGreater(first["quality_scores"]["artistic"], 70)
        self.assertIn("not_scalar_only", first["quality_scores"]["selection_policy"])
        self.assertEqual(first["validation"]["viewport_policy"], "local_follow_camera_no_forced_zoom")
        self.assertEqual(first["controller"]["status"], "routed")
        self.assertIn("EnterGroundMap", Path(first["controller_file"]).read_text())
        self.assertEqual(Path(first["ground_file"]).read_bytes(), Path(second["ground_file"]).read_bytes())
        self.assertEqual(Path(first["metadata_file"]).read_bytes(), Path(second["metadata_file"]).read_bytes())
        data = json.loads(Path(first["ground_file"]).read_text(encoding="utf-8-sig"))["Object"]
        self.assertEqual([len(data["obstacles"]), len(data["obstacles"][0])], [64, 48])
        self.assertTrue(all(len(layer["Tiles"]) == 64 and all(len(column) == 48 for column in layer["Tiles"]) for layer in data["Layers"]))
        self.assertTrue(Path(first["preview_file"]).exists())
        self.assertIn("data:image/png;base64", Path(first["preview_file"]).read_text())

    def test_16_multiple_ground_strategies_are_functionally_distinct(self):
        canyon = generate_ground(REPO, self.temp / "ground_canyon", "canyon", "Un canyon sinueux avec poches latérales", 10, 1, "altere_pond", 40, 32)
        courtyard = generate_ground(REPO, self.temp / "ground_courtyard", "courtyard", "Une cour de ruines anciennes avec structure centrale et piliers", 11, 1, "altere_pond", 40, 32)
        self.assertEqual(canyon["validation"]["result"], "GROUND_VALIDATION_PASS")
        self.assertEqual(courtyard["validation"]["result"], "GROUND_VALIDATION_PASS")
        self.assertEqual(canyon["concept"], "winding_canyon")
        self.assertEqual(courtyard["concept"], "ancient_courtyard")
        self.assertNotEqual(canyon["geometry"]["regions"], courtyard["geometry"]["regions"])
        self.assertNotEqual(Path(canyon["ground_file"]).read_bytes(), Path(courtyard["ground_file"]).read_bytes())
        self.assertTrue(any(region["kind"] == "canyon_pocket" for region in canyon["geometry"]["regions"]))
        self.assertTrue(any(region.get("intentional_symmetry") for region in courtyard["geometry"]["regions"]))
        self.assertTrue(all(not group["transformed"] for result in (canyon, courtyard) for group in result["decoration"]["groups"]))

    def test_17_crystal_cavern_boss_contract_and_ambiguity_policy(self):
        crystal = generate_ground(
            REPO, self.temp / "ground_crystal", "caverne_cristalline",
            "Une caverne cristalline avec bassins, ramifications et chambres latérales",
            8080, 2, "altere_pond", 38, 30,
        )
        arena = generate_ground(
            REPO, self.temp / "ground_arena", "arene_boss",
            "Une arène finale spectaculaire avec boss, entrée resserrée et espaces tactiques",
            9090, 2, "searing_tunnel_miniboss", 40, 32,
        )
        self.assertEqual(crystal["concept"], "crystal_cavern")
        self.assertGreaterEqual(crystal["validation"]["geometry"]["functional_region_count"], 3)
        self.assertEqual(crystal["validation"]["result"], "GROUND_VALIDATION_PASS")
        self.assertEqual(arena["concept"], "boss_arena")
        self.assertLessEqual(arena["validation"]["geometry"]["boss_distance"], 6)
        self.assertEqual(arena["validation"]["result"], "GROUND_VALIDATION_PASS")
        ambiguous = interpret_ground_intent("Un endroit étrange")
        self.assertEqual(ambiguous["concept"], "organic_exploration")
        self.assertLess(ambiguous["confidence"], 0.55)


if __name__ == "__main__":
    unittest.main(verbosity=2)
