#!/usr/bin/env python3
import hashlib,json,struct
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'RESERVE/pmdred_dungeon_batches'
EARLY={'tiny_woods':(0,125),'thunderwave_cave':(1,14),'mt_steel':(2,120),'silent_chasm':(4,113),'mt_thunder':(5,111),'mt_thunder_peak':(6,126),'great_canyon':(7,20),'lapis_cave':(8,102),'mt_blaze':(9,25),'frosty_forest':(11,104),'mt_freeze':(13,115),'magma_cavern':(15,108),'sky_tower':(17,22),'stormy_sea':(19,21)}
class Tests(unittest.TestCase):
 def test_visual_batches_are_hash_bound_and_non_promoting(self):
  manifests=sorted(BASE.glob('*/manifest.json'));self.assertEqual(len(manifests),45)
  for path in manifests:
   base=path.parent;d=json.loads(path.read_text());self.assertTrue(d['status'].startswith('STAGED_'));self.assertFalse(d['gates']['promotion']);files=d['canonical_tilesets'].get('files',d['canonical_tilesets'].get('procedural_files'));self.assertGreater(len(files),0)
   for r in files:
    p=base/r['path'];self.assertEqual((p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()),(r['bytes'],r['sha256']))
 def test_oddity_b50_pixel_startup_runtime(self):
  base=BASE/'oddity_cave';d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_ROM_RECONSTRUCTED_PIXEL_STARTUP_RUNTIME_PASS');self.assertEqual(d['gates']['pixel_differential'],'PASS');self.assertEqual(d['gates']['startup_phase_adapter'],'PASS');self.assertEqual(d['gates']['runtime'],'PASS_MATERIAL_FIXTURE')
  run=base/d['canonical_tilesets']['runtime_evidence'];report=json.loads(run.read_text());self.assertEqual(report['status'],'PASS_PIXEL_STARTUP_RUNTIME');self.assertTrue(all(report['assertions'].values()))
  for line in (run.parent/'HASHES.sha256').read_text().splitlines():
   expected,name=line.split('  ',1);self.assertEqual(hashlib.sha256((run.parent/name).read_bytes()).hexdigest(),expected)
 def test_unown_b07_pixel_startup_runtime(self):
  base=BASE/'unown_relic';d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_ROM_RECONSTRUCTED_PIXEL_STARTUP_RUNTIME_PASS');self.assertEqual(d['gates']['pixel_differential'],'PASS');self.assertEqual(d['gates']['startup_phase_adapter'],'PASS');self.assertEqual(d['gates']['runtime'],'PASS_MATERIAL_FIXTURE')
  report=json.loads((base/d['canonical_tilesets']['runtime_evidence']).read_text());self.assertEqual(report['status'],'PASS_PIXEL_STARTUP_RUNTIME');self.assertTrue(all(report['assertions'].values()))
 def test_material_contact_sheets_are_inspectable(self):
  for family in ('b06','b07','b38','b50','b59'):
   base=ROOT/f'docs/pmdred_eu/renders/material_{family}';manifest=json.loads((base/'manifest.json').read_text());self.assertEqual(len(manifest['renders']),6)
   for record in manifest['renders']:
    raw=(base/record['path']).read_bytes();self.assertEqual(raw[:8],b'\x89PNG\r\n\x1a\n');width,height=struct.unpack('>II',raw[16:24]);self.assertEqual((width,height),(record['width'],record['height']));self.assertEqual((width,height),(576,144))
 def test_remains_b06_b38_pixel_startup_runtime(self):
  base=BASE/'remains_island';d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_ROM_RECONSTRUCTED_PIXEL_STARTUP_RUNTIME_PASS')
  for material in d['canonical_tilesets']['materials'].values():
   report=json.loads((base/material['runtime']).read_text());self.assertEqual(report['status'],'PASS_PIXEL_STARTUP_RUNTIME');self.assertTrue(all(report['assertions'].values()))
 def test_fiery_b59_pixel_startup_runtime(self):
  base=BASE/'fiery_field';d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_ROM_RECONSTRUCTED_PIXEL_STARTUP_RUNTIME_PASS');report=json.loads((base/d['canonical_tilesets']['runtime_evidence']).read_text());self.assertEqual(report['status'],'PASS_PIXEL_STARTUP_RUNTIME');self.assertTrue(all(report['assertions'].values()))
 def test_early_music_bindings(self):
  for slug,(did,song) in EARLY.items():
   d=json.loads((BASE/slug/'manifest.json').read_text());self.assertEqual(d['dungeon_id'],did);actual=d['canonical_music'].get('song_index',d['canonical_music'].get('song_indices'));self.assertIn(song,actual if isinstance(actual,list) else [actual])
if __name__=='__main__':unittest.main()
