#!/usr/bin/env python3
from __future__ import annotations
import hashlib,json,struct,subprocess,sys,unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parent
CANDIDATES=("summer",)
VILLAGE=ROOT/"generated/rmvillage"
SYSTEMS=("halcyon.LivingWorld","halcyon.TownLife","halcyon.TownPlace","halcyon.Seasons","halcyon.Weather","halcyon.TownNight")

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

class EnvironmentConversionTests(unittest.TestCase):
 def test_black_tile_audit_passes_all_seasons_and_runtime_captures(self):
  report=json.loads((VILLAGE/'black_tile_audit.json').read_text());self.assertEqual(report['result'],'BLACK_TILE_AUDIT_PASS')
  self.assertEqual(report['problem_seasons'],[])
  for season in report['seasons']:
   self.assertEqual(season['missing_tile_references'],0);self.assertEqual(season['full_black_visual_cells'],[])
   self.assertEqual(season['transparent_visual_cells'],[]);self.assertEqual(season['walkable_dark_holes_8px'],[])
   self.assertEqual(season['runtime_capture_count'],12);self.assertTrue(all(not row['all_black'] and row['magenta_error_pixels']==0 for row in season['runtime_captures']))

 def test_validated_summer_runtime_baseline_is_immutable(self):
  run=subprocess.run([sys.executable,str(ROOT/'tools/verify_rmvillage_summer_baseline.py')],cwd=ROOT.parent,capture_output=True,text=True)
  self.assertEqual(run.returncode,0,run.stdout+run.stderr);self.assertIn('RMVILLAGE_SUMMER_BASELINE_PASS',run.stdout)

 def test_candidates_are_native_but_not_falsely_promoted(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   self.assertEqual(m["status"],"GENERATED_CANDIDATE")
   self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
   self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS")
   self.assertFalse(m["promotion_allowed"])
   self.assertTrue(all(m["checks"].values()))
   for kind in ("ground","tile","script","source_render","candidate_render"):
    self.assertEqual(sha(root/m["outputs"][kind]),m["outputs"][kind+"_sha256"])

 def test_ground_geometry_and_native_tile_package(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   g=json.loads((root/m["outputs"]["ground"]).read_text(encoding="utf-8-sig"))["Object"]
   self.assertEqual(g["TexSize"],8);self.assertEqual(g["AssetName"],"nnv_rmvillage_"+room)
   self.assertTrue(all(len(layer["Tiles"])==78 and all(len(col)==78 for col in layer["Tiles"]) for layer in g["Layers"]))
   self.assertEqual((len(g["obstacles"]),len(g["obstacles"][0])),(624,624))
   self.assertEqual(m["transform"]["kind"],"identity_spatial_mapping")
   self.assertEqual(m["transform"]["source_dimensions_px"],m["transform"]["target_dimensions_px"])
   png=(root/m["outputs"]["candidate_render"]).read_bytes();self.assertEqual(struct.unpack_from(">II",png,16),(4992,4992))
   tile=(root/m["outputs"]["tile"]).read_bytes();size,count=struct.unpack_from("<II",tile,0)
   self.assertEqual(size,64);self.assertGreater(count,0)

 def test_four_canonical_season_bundles_exist_with_distinct_renders(self):
  render_hashes=set()
  for season in ("spring","summer","autumn","winter"):
   root=VILLAGE/season;m=json.loads((root/"manifest.json").read_text())
   self.assertEqual(m["season"],season);self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
   self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS");self.assertFalse(m["promotion_allowed"])
   runtime=root/m["outputs"]["runtime_report"];self.assertEqual(sha(runtime),m["outputs"]["runtime_report_sha256"])
   runtime_data=json.loads(runtime.read_text());self.assertEqual(runtime_data["functional_runtime_status"],"PASS");self.assertEqual(runtime_data["termination_status"],"PASS")
   runtime_log=(root/"runtime/runtime.log").read_text().casefold()
   for signature in ("exception depth","unhandled exception","failed to load","missing data:","index was outside the bounds"):self.assertNotIn(signature,runtime_log)
   self.assertTrue(all(m["checks"].values()));render_hashes.add(m["outputs"]["candidate_render_sha256"])
   for kind in ("tile","script","source_render","candidate_render"):
    self.assertEqual(sha(root/m["outputs"][kind]),m["outputs"][kind+"_sha256"])
   if season=="summer": self.assertEqual(m["status"],"GENERATED_CANDIDATE")
   else:
    self.assertEqual(m["status"],"SEASON_LAYER_BUNDLE")
    bundle=root/m["outputs"]["season_layers"]
    self.assertEqual(sha(bundle),m["outputs"]["season_layers_sha256"])
    import gzip
    with gzip.open(bundle,"rt",encoding="utf-8") as stream:data=json.load(stream)
    self.assertEqual(data["dimensions_px"],[4992,4992]);self.assertEqual(data["tex_size"],8)
    self.assertTrue(data["layers"])
  self.assertEqual(len(render_hashes),4)
  summary=json.loads((VILLAGE/"seasons_summary.json").read_text())
  self.assertEqual(summary["visual_bundle_count"],4);self.assertTrue(summary["visual_bundles_generated"])
  self.assertTrue(summary["all_four_variants_runtime_tested"]);self.assertEqual(len(summary["runtime_variants"]),4)
  self.assertFalse(summary["runtime_switch_validated"]);self.assertFalse(summary["canonical_particles_validated"])
  self.assertEqual(summary["conversion_status"],"UNIMPLEMENTED");self.assertFalse(summary["promotion_allowed"])
  self.assertEqual(sha(VILLAGE/summary["contact_sheet"]),summary["contact_sheet_sha256"])

 def test_canonical_winter_particle_graphics_are_compiled_without_false_completion(self):
  root=VILLAGE/"winter/particles";m=json.loads((root/"manifest.json").read_text())
  self.assertEqual(m["status"],"ASSETS_COMPILED");self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
  self.assertEqual(m["runtime_status"],"NOT_RUN");self.assertFalse(m["promotion_allowed"])
  self.assertEqual(len(m["assets"]),3)
  for row in m["assets"]:
   path=root/row["output"];self.assertEqual(sha(path),row["output_sha256"])
   data=path.read_bytes();png_size,zero=struct.unpack_from("<II",data,0);self.assertEqual(zero,0)
   width,height,loc_height,frames=struct.unpack_from("<IIII",data,8+png_size)
   self.assertEqual([width,height],row["source_dimensions"]);self.assertEqual(frames,row["frame_count"])
   self.assertEqual(loc_height,row["loc_height"]);self.assertEqual(row["pixel_transform"],"identity_1_to_1")
  self.assertTrue(m["blockers"]);self.assertEqual(m["footprint_audio"]["asset_status"],"MISSING_BINARY_OUTSIDE_TRACKED_EXTRACTION")

 def test_four_season_router_is_explicit_but_not_falsely_runtime_validated(self):
  manifest=json.loads((VILLAGE/"season_router_manifest.json").read_text());router=VILLAGE/manifest["router"]
  self.assertEqual(sha(router),manifest["router_sha256"]);self.assertEqual(manifest["status"],"ROUTER_IMPLEMENTED")
  self.assertEqual(manifest["runtime_status"],"NOT_RUN_AS_COMBINED_FLOW");self.assertEqual(manifest["conversion_status"],"UNIMPLEMENTED")
  self.assertFalse(manifest["promotion_allowed"]);self.assertEqual(len(manifest["variants"]),4)
  self.assertEqual(manifest["individual_variant_runtime_status"],"RUNTIME_TESTED_PASS")
  self.assertTrue(all(row["runtime_status"]=="RUNTIME_TESTED_PASS" for row in manifest["variants"]))
  text=router.read_text()
  for season in ("printemps","ete","automne","hiver"):self.assertIn(season,text)
  self.assertIn("error('unsupported canonical NNV season",text);self.assertNotIn("or 'nnv_rmvillage_summer'",text)

 def test_native_pokemon_life_patch_is_deterministic_and_not_promoted(self):
  root=VILLAGE/'life';patch=json.loads((root/'entities_patch.json').read_text())
  self.assertEqual(patch['status'],'LIFE_PATCH_GENERATED');self.assertEqual(patch['runtime_status'],'NOT_RUN')
  self.assertEqual(patch['conversion_status'],'UNIMPLEMENTED');self.assertEqual(patch['certification_status'],'NOT_CERTIFIED');self.assertFalse(patch['promotion_allowed'])
  self.assertEqual(patch['entity_count'],49);self.assertEqual(patch['social_count'],5);self.assertEqual(patch['wild_count'],44);self.assertEqual(patch['wild_group_count'],8)
  self.assertEqual(patch['source_animal_count'],31);self.assertEqual(patch['source_bird_count'],12);self.assertEqual(patch['source_butterfly_count'],19)
  self.assertIsNone(patch['dominant_selection']['pokemon']);self.assertEqual(patch['dominant_selection']['status'],'NOT_APPLICABLE_FOR_RMVILLAGE')
  species={row['species'] for row in patch['evidence']};self.assertEqual(species,{'timburr','bidoof','decidueye','roselia','leavanny','fletchling','scatterbug','caterpie','hoppip','oddish','deerling','vivillon'})
  wild=[row for row in patch['evidence'] if row['kind'].startswith('wild:')];self.assertEqual(len(wild),44);self.assertEqual(len({row['entity'] for row in wild}),44)
  self.assertEqual({row['group'] for row in wild},{'flock','colony','drift','patch','territory','source_birds','source_butterflies'})
  self.assertTrue(all(row['behavior'] in {'timid','social','nocturnal','territorial','flying_social'} for row in wild))
  source_animals=[row for row in wild if row['source_anchor']['type']=='source_animal_instance'];self.assertEqual(len(source_animals),31)
  self.assertTrue(all(row['flying'] and row['walkability_adjustment_px']==0 for row in source_animals))
  self.assertTrue(all(row['rationale'] and row['position'][0]>=0 and row['position'][1]>=0 for row in patch['evidence']))
  self.assertEqual(sha(root/patch['script']),patch['script_sha256']);self.assertEqual(sha(root/patch['ground_script']),patch['ground_script_sha256'])
  script=(root/patch['script']).read_text();ground_script=(root/patch['ground_script']).read_text()
  self.assertIn('Life.Setup()',ground_script);self.assertIn('Life.Update()',ground_script);self.assertIn("Life.WildTalk",ground_script)
  for module in ('LivingWorld','TownLife','TownPlace','TownNight'):self.assertIn("require 'halcyon."+module+"'",script)
  self.assertIn("halcyon.ai.ground_default",script);self.assertIn('TASK:StartEntityTask',script)
  self.assertIn("behavior='timid'",script);self.assertIn("behavior='territorial'",script);self.assertIn("behavior='nocturnal'",script)
  self.assertIn('Life.Update',script);self.assertIn('GROUND:MoveToPosition',script)

 def test_living_summer_ground_contains_native_independent_mapchars_without_promotion(self):
  root=VILLAGE/'living/summer';manifest=json.loads((root/'manifest.json').read_text())
  self.assertEqual(manifest['status'],'LIFE_INTEGRATED_CANDIDATE');self.assertEqual(manifest['runtime_status'],'NOT_RUN')
  self.assertEqual(manifest['conversion_status'],'UNIMPLEMENTED');self.assertEqual(manifest['certification_status'],'NOT_CERTIFIED');self.assertFalse(manifest['promotion_allowed'])
  ground=json.loads((root/manifest['outputs']['ground']).read_text(encoding='utf-8-sig'))['Object'];chars=[c for layer in ground['Entities'] for c in layer['MapChars']]
  self.assertEqual(len(chars),49);self.assertEqual(len({c['EntName'] for c in chars}),49);self.assertTrue(all(c['AIEnabled'] for c in chars))
  self.assertEqual(sum(c['EntName'].startswith('NNV_SourceBird_') for c in chars),12);self.assertEqual(sum(c['EntName'].startswith('NNV_SourceButterfly_') for c in chars),19)
  self.assertTrue(all(c['CollisionDisabled'] for c in chars if c['EntName'].startswith(('NNV_SourceBird_','NNV_SourceButterfly_'))))
  tile=ROOT/manifest['outputs']['tile_source'];self.assertTrue(tile.is_file());self.assertEqual(sha(tile),manifest['outputs']['tile_sha256'])
  self.assertFalse(manifest['source_animal_sprites_in_visual_layers'])

 def test_life_patch_is_bound_to_four_animal_free_seasons_without_false_runtime_pass(self):
  summary=json.loads((VILLAGE/'living/summary.json').read_text());self.assertEqual(summary['variant_count'],4);self.assertEqual(summary['entity_count_per_variant'],49)
  self.assertEqual(summary['source_animals_converted'],31);self.assertEqual(summary['status'],'FOUR_SEASON_LIFE_BOUND')
  self.assertEqual(summary['runtime_status'],'NOT_RUN_ALL_VARIANTS');self.assertEqual(summary['conversion_status'],'UNIMPLEMENTED');self.assertFalse(summary['promotion_allowed'])
  for row in summary['variants']:
   manifest=json.loads((ROOT/row['manifest']).read_text());self.assertEqual(sha(ROOT/row['manifest']),row['manifest_sha256'])
   self.assertEqual(manifest['entity_count'],49);self.assertEqual(manifest['source_animal_count'],31);self.assertFalse(manifest['source_animal_sprites_in_visual_layers'])
   self.assertEqual(manifest['conversion_status'],'UNIMPLEMENTED');self.assertEqual(manifest['certification_status'],'NOT_CERTIFIED');self.assertFalse(manifest['promotion_allowed'])

 def test_existing_new_era_living_systems_are_reused(self):
  for room in CANDIDATES:
   root=VILLAGE/room;m=json.loads((root/"manifest.json").read_text())
   script=(root/m["outputs"]["script"]).read_text()
   self.assertEqual(tuple(m["new_era_systems"]),SYSTEMS)
   for system in SYSTEMS:self.assertIn("require '"+system+"'",script)
   self.assertIn("LivingWorld.ApplyOutdoor(false)",script)
   self.assertNotIn("Seasons.Setup()",script);self.assertNotIn("Seasons.Apply()",script)
   self.assertEqual(m["source"]["repository_commit"],"d1245878861fc76dc5455dbad68bcb45c83f7e1f")
   self.assertFalse(m["canonical_environment_authority"]["generic_new_era_season_particles_allowed_as_substitute"])
   self.assertTrue(any("objwinter particle families" in blocker for blocker in m["blockers"]))
   self.assertTrue(any("wild exploration population" in blocker for blocker in m["blockers"]))
  village=json.loads((VILLAGE/"summer/manifest.json").read_text())
  self.assertTrue(any("native Pokemon living cast" in blocker for blocker in village["blockers"]))

 def test_source_animation_cycles_are_materialized_in_ground_cells(self):
  m=json.loads((VILLAGE/"summer/manifest.json").read_text())
  periods={row["layer"]:row["period_frames"] for row in m["source_animation_layers"]}
  self.assertEqual(periods["trees"],12);self.assertEqual(periods["plants"],12)
  self.assertEqual(periods["instances"],3);self.assertEqual(periods["HouseBelow"],2)
  self.assertTrue(m["checks"]["source_sprite_animation_cycles_compiled"])
  g=json.loads((VILLAGE/"summer"/m["outputs"]["ground"]).read_text(encoding="utf-8-sig"))["Object"]
  frame_counts=[len(tl["Frames"]) for layer in g["Layers"] for col in layer["Tiles"] for cell in col for tl in cell.get("Layers",[])]
  self.assertGreater(max(frame_counts),1);self.assertIn(12,frame_counts)

 def test_runtime_functional_probes_and_native_termination_pass_without_certification(self):
  root=VILLAGE/"summer";m=json.loads((root/"manifest.json").read_text());report=json.loads((root/m["outputs"]["runtime_report"]).read_text())
  self.assertEqual(sha(root/m["outputs"]["runtime_report"]),m["outputs"]["runtime_report_sha256"])
  self.assertEqual(report["functional_runtime_status"],"PASS");self.assertEqual(report["probes"]["load"],"PASS")
  self.assertEqual(report["probes"]["movement"],"PASS");self.assertEqual(report["probes"]["blocked"],"PASS")
  self.assertEqual(report["animation_capture"]["status"],"PASS");self.assertEqual(len(report["captures"]),12)
  for capture in report["captures"]:self.assertEqual(sha(root/"runtime"/capture["file"]),capture["sha256"])
  self.assertEqual(report["termination_status"],"PASS");self.assertEqual(report["runtime_status"],"RUNTIME_TESTED_PASS")
  self.assertTrue(report["termination"]["graceful_exit_observed"]);self.assertEqual(report["termination"]["termination"]["kind"],"NORMAL_EXIT")
  self.assertEqual(m["runtime_status"],"RUNTIME_TESTED_PASS");self.assertEqual(report["certification_status"],"NOT_CERTIFIED");self.assertFalse(report["promotion_allowed"])

 def test_visual_differential_is_bounded_by_pmdo_premultiplication(self):
  for room in CANDIDATES:
   m=json.loads((VILLAGE/room/"manifest.json").read_text());metrics=m["visual_metrics"]
   self.assertTrue(metrics["alpha_exact"]);self.assertLessEqual(metrics["max_channel_error"],1)
   self.assertIn(m["visual_status"],{"TICK0_PIXEL_EXACT","TICK0_PMDO_PREMULTIPLY_ROUNDTRIP_VALID"})

 def test_wildlife_evidence_survives_rejected_scaled_candidate(self):
  evidence=json.loads((ROOT/"reports/rm82-wildlife-source.json").read_text());wild=evidence["wildlife"]
  self.assertEqual(evidence["status"],"SOURCE_ANALYZED");self.assertEqual(evidence["conversion_status"],"UNIMPLEMENTED")
  self.assertIn("1/4 spatial normalization rejected",evidence["superseded_reason"])
  self.assertEqual(wild["source_count"],89);self.assertEqual(wild["native_pokemon_count"],0)
  self.assertTrue(all(row["semantics"]["behavior_class"]=="stationary_spawning_nest" for row in wild["source_placements"]))
  self.assertEqual({row["semantics"]["active_spawn_cap_in_rm82"] for row in wild["source_placements"]},{8})

 def test_pmd_red_certified_destinations_are_not_outputs(self):
  for room in CANDIDATES:
   m=json.loads((VILLAGE/room/"manifest.json").read_text())
   self.assertTrue(m["outputs"]["ground"].startswith("Data/Ground/nnv_"))
  self.assertFalse(any((ROOT/"generated").rglob("d*.rsground")))

if __name__=="__main__":unittest.main(verbosity=2)
