#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
import unittest
from render_pmdred_music import parse_ogg
ROOT=Path(__file__).resolve().parents[1];REPORT=ROOT/'docs/pmdred_eu/playable/ALL_DUNGEON_MUSIC_BUNDLE_2026-08-21.json'
class Tests(unittest.TestCase):
 def test_all_looping_dungeon_music_is_rom_exact(self):
  d=json.loads(REPORT.read_text());self.assertEqual(d['status'],'PASS_ALL_IMPORTABLE_DUNGEON_MUSIC_EXACT');self.assertEqual(d['missing_song_indices'],[]);self.assertEqual(len(d['records']),23)
  for r in d['records']:
   p=ROOT/r['path'];self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(),r['sha256']);samples,c=parse_ogg(p);self.assertEqual(samples,r['samples']);self.assertEqual(int(c['M4A_SONG_TABLE_INDEX']),r['song_index']);self.assertEqual(c['SOURCE_ROM_SHA256'],d['authority']['rom_sha256'])
 def test_nonloop_source_is_not_silently_fabricated(self):
  d=json.loads(REPORT.read_text());x=d['excluded'][0];self.assertEqual((x['song_index'],x['only_consumer_dungeon_id']),(26,50));self.assertEqual(x['classification'],'EXCLUDED_SYSTEM_DUNGEON')
if __name__=='__main__':unittest.main()
