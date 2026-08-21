#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'RESERVE/pmdred_dungeon_batches'
EXPECTED={'tiny_woods':(0,125),'thunderwave_cave':(1,14),'mt_steel':(2,120),'silent_chasm':(4,113),'mt_thunder':(5,111),'mt_thunder_peak':(6,126),'great_canyon':(7,20),'lapis_cave':(8,102),'mt_blaze':(9,25),'frosty_forest':(11,104),'mt_freeze':(13,115),'magma_cavern':(15,108),'sky_tower':(17,22),'stormy_sea':(19,21)}
class Tests(unittest.TestCase):
 def test_early_visual_batches_are_hash_bound_and_non_promoting(self):
  self.assertEqual({p.parent.name for p in BASE.glob('*/manifest.json')},set(EXPECTED))
  for slug,(did,song) in EXPECTED.items():
   base=BASE/slug;d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_SOURCE_BOUND');self.assertEqual((d['dungeon_id'],d['canonical_music']['song_index']),(did,song));self.assertFalse(d['gates']['promotion']);self.assertGreater(len(d['canonical_tilesets']['files']),0)
   for r in d['canonical_tilesets']['files']:
    p=base/r['path'];self.assertEqual((p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()),(r['bytes'],r['sha256']))
if __name__=='__main__':unittest.main()
