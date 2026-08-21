#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'RESERVE/pmdred_dungeon_batches'
EARLY={'tiny_woods':(0,125),'thunderwave_cave':(1,14),'mt_steel':(2,120),'silent_chasm':(4,113),'mt_thunder':(5,111),'mt_thunder_peak':(6,126),'great_canyon':(7,20),'lapis_cave':(8,102),'mt_blaze':(9,25),'frosty_forest':(11,104),'mt_freeze':(13,115),'magma_cavern':(15,108),'sky_tower':(17,22),'stormy_sea':(19,21)}
class Tests(unittest.TestCase):
 def test_visual_batches_are_hash_bound_and_non_promoting(self):
  manifests=sorted(BASE.glob('*/manifest.json'));self.assertEqual(len(manifests),41)
  for path in manifests:
   base=path.parent;d=json.loads(path.read_text());self.assertTrue(d['status'].startswith('STAGED_SOURCE_BOUND'));self.assertFalse(d['gates']['promotion']);files=d['canonical_tilesets'].get('files',d['canonical_tilesets'].get('procedural_files'));self.assertGreater(len(files),0)
   for r in files:
    p=base/r['path'];self.assertEqual((p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()),(r['bytes'],r['sha256']))
 def test_early_music_bindings(self):
  for slug,(did,song) in EARLY.items():
   d=json.loads((BASE/slug/'manifest.json').read_text());self.assertEqual(d['dungeon_id'],did);actual=d['canonical_music'].get('song_index',d['canonical_music'].get('song_indices'));self.assertIn(song,actual if isinstance(actual,list) else [actual])
if __name__=='__main__':unittest.main()
