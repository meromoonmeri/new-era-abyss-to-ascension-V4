#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
class Tests(unittest.TestCase):
 def test_silent_chasm_stage_is_source_bound(self):
  base=ROOT/'RESERVE/pmdred_dungeon_batches/silent_chasm';d=json.loads((base/'manifest.json').read_text());self.assertEqual(d['status'],'STAGED_SOURCE_BOUND');self.assertEqual((d['dungeon_id'],d['authority']['tileset_id'],d['authority']['music_song_index']),(4,2,113));self.assertFalse(d['gates']['promotion'])
  for r in d['staged_files']:
   p=base/r['path'];self.assertEqual((p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()),(r['bytes'],r['sha256']))
if __name__=='__main__':unittest.main()
