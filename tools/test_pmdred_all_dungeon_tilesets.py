#!/usr/bin/env python3
import json,os
from pathlib import Path
import unittest
import audit_pmdred_eu_all_dungeon_tilesets as audit
ROOT=Path(__file__).resolve().parents[1];REPORT=ROOT/'docs/pmdred_eu/playable/ALL_DUNGEON_TILESET_SOURCE_2026-08-21.json';VISUAL=ROOT/'docs/pmdred_eu/playable/ALL_DUNGEON_VISUAL_AUTHORITY_2026-08-21.json';ROM=Path(os.environ.get('PMDRED_EU_ROM',ROOT/'.runtime-cache/downloads/pmdred-eu.gba'))
class Tests(unittest.TestCase):
 def test_inventory(self):
  d=json.loads(REPORT.read_text());self.assertEqual(d['validation']['status'],'PASS');self.assertEqual((d['summary']['tileset_count'],d['summary']['resource_count']),(74,337));self.assertEqual(len(d['families']),74)
 def test_known_split_materials(self):
  f={x['tileset_id']:x for x in json.loads(REPORT.read_text())['families']};self.assertEqual(f[41]['present_roles'],['fon','cel','cex','pal','canm']);self.assertEqual(f[65]['missing_roles'],['cex']);self.assertEqual(f[26]['present_roles'],['pal','canm'])
 @unittest.skipUnless(ROM.is_file(),'ROM unavailable')
 def test_reproduction(self):self.assertEqual(audit.build(ROM,VISUAL),json.loads(REPORT.read_text()))
if __name__=='__main__':unittest.main()
