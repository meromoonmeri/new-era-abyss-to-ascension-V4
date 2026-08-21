#!/usr/bin/env python3
import json,os
from pathlib import Path
import unittest
import audit_pmdred_eu_all_dungeon_visual_authority as audit
ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'docs/pmdred_eu/playable/ALL_DUNGEON_VISUAL_AUTHORITY_2026-08-21.json'
ROM=Path(os.environ.get('PMDRED_EU_ROM',ROOT/'.runtime-cache/downloads/pmdred-eu.gba'))
PRET=Path(os.environ.get('PMDRED_PRET_ROOT',ROOT/'.runtime-cache/pmd-red-reference'))
def load():return json.loads(REPORT.read_text())
class Tests(unittest.TestCase):
 def test_scope(self):
  d=load();s=d['summary'];self.assertEqual(d['validation']['status'],'PASS');self.assertEqual((s['dungeon_count'],s['floor_count']),(64,1767));self.assertEqual(s['unique_music_count'],24);self.assertEqual(s['unique_tileset_count'],74)
 def test_known_early_authorities(self):
  r=load()['dungeons'];self.assertEqual((r[0]['m4a_song_indices'],r[0]['tileset_ids']),([125],[14]));self.assertEqual((r[1]['m4a_song_indices'],r[1]['tileset_ids']),([14],[50]));self.assertEqual((r[2]['m4a_song_indices'],r[2]['tileset_ids']),([114,120],[39,40,64]));self.assertEqual((r[3]['m4a_song_indices'],r[3]['tileset_ids']),([15,114],[41,65]))
 @unittest.skipUnless(ROM.is_file() and PRET.is_dir(),'authorities unavailable')
 def test_reproduction(self):self.assertEqual(audit.build(ROM,PRET,ROOT/'Content/Music'),load())
if __name__=='__main__':unittest.main()
