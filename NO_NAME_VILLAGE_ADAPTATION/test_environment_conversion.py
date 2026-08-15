#!/usr/bin/env python3
from __future__ import annotations
import hashlib,json,struct,unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parent
CANDIDATES=("rmvillage","rm78","rm81")
SYSTEMS=("halcyon.LivingWorld","halcyon.TownLife","halcyon.TownPlace","halcyon.Seasons","halcyon.Weather","halcyon.TownNight")

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

class EnvironmentConversionTests(unittest.TestCase):
 def test_candidates_are_native_but_not_falsely_promoted(self):
  for room in CANDIDATES:
   root=ROOT/"generated"/room;m=json.loads((root/"manifest.json").read_text())
   self.assertEqual(m["status"],"GENERATED_CANDIDATE")
   self.assertEqual(m["conversion_status"],"UNIMPLEMENTED")
   self.assertEqual(m["runtime_status"],"NOT_RUN")
   self.assertFalse(m["promotion_allowed"])
   self.assertTrue(all(m["checks"].values()))
   for kind in ("ground","tile","script","source_render","candidate_render"):
    self.assertEqual(sha(root/m["outputs"][kind]),m["outputs"][kind+"_sha256"])

 def test_ground_geometry_and_native_tile_package(self):
  for room in CANDIDATES:
   root=ROOT/"generated"/room;m=json.loads((root/"manifest.json").read_text())
   g=json.loads((root/m["outputs"]["ground"]).read_text(encoding="utf-8-sig"))["Object"]
   self.assertEqual(g["TexSize"],2);self.assertEqual(g["AssetName"],"nnv_"+room)
   self.assertTrue(all(len(layer["Tiles"])==78 and all(len(col)==78 for col in layer["Tiles"]) for layer in g["Layers"]))
   self.assertEqual((len(g["obstacles"]),len(g["obstacles"][0])),(156,156))
   tile=(root/m["outputs"]["tile"]).read_bytes();size,count=struct.unpack_from("<II",tile,0)
   self.assertEqual(size,16);self.assertGreater(count,0)

 def test_existing_new_era_living_systems_are_reused(self):
  for room in CANDIDATES:
   root=ROOT/"generated"/room;m=json.loads((root/"manifest.json").read_text())
   script=(root/m["outputs"]["script"]).read_text()
   self.assertEqual(tuple(m["new_era_systems"]),SYSTEMS)
   for system in SYSTEMS:self.assertIn("require '"+system+"'",script)
  village=json.loads((ROOT/"generated/rmvillage/manifest.json").read_text())
  self.assertTrue(any("native Pokemon living cast" in blocker for blocker in village["blockers"]))

 def test_visual_differential_is_bounded_by_pmdo_premultiplication(self):
  for room in CANDIDATES:
   m=json.loads((ROOT/"generated"/room/"manifest.json").read_text());metrics=m["visual_metrics"]
   self.assertTrue(metrics["alpha_exact"]);self.assertLessEqual(metrics["max_channel_error"],1)
   self.assertIn(m["visual_status"],{"TICK0_PIXEL_EXACT","TICK0_PMDO_PREMULTIPLY_ROUNDTRIP_VALID"})

 def test_pmd_red_certified_destinations_are_not_outputs(self):
  for room in CANDIDATES:
   m=json.loads((ROOT/"generated"/room/"manifest.json").read_text())
   self.assertTrue(m["outputs"]["ground"].startswith("Data/Ground/nnv_"))
  self.assertFalse(any((ROOT/"generated").glob("*/Data/Ground/d*.rsground")))

if __name__=="__main__":unittest.main(verbosity=2)
