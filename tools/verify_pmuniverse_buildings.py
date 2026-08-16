#!/usr/bin/env python3
"""Verify the tracked PMUniverse native building library."""
import hashlib,json
from pathlib import Path
from verify_pmd_structure_library import png_alpha_extrema
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'docs/pmuniverse_buildings'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 j=json.loads((BASE/'manifest.json').read_text());assert j['source']['repository']=='https://github.com/PMUniverse/PMU-Client';assert j['source']['commit']=='c25c01f9879369647cd5a19731b2e4e5acd33e67';assert j['counts']=={'tile_archives_audited':11,'embedded_tile_records':52486,'qualified_buildings':100};assert len(j['buildings'])==100 and len({x['id'] for x in j['buildings']})==100
 archives=set()
 for x in j['buildings']:
  p=BASE/x['file'];assert p.is_file() and sha(p)==x['sha256'];assert (x['width'],x['height'])==(x['source_atlas_bbox'][2],x['source_atlas_bbox'][3]);assert x['native_resolution'] and x['transparent_background'];assert not x['terrain_included'] and not x['npc_included'];assert png_alpha_extrema(p)[0]==0;archives.add(x['source_archive'])
 assert archives==set(j['source']['archive_sha256'])=={'Tiles0.tile','Tiles2.tile','Tiles8.tile','Tiles9.tile'}
 for x in j['contact_sheets']:assert sha(BASE/x['file'])==x['sha256']
 print('PMUNIVERSE_BUILDINGS_PASS buildings=100 archives=4 audited_archives=11 terrain=0 npc=0')
if __name__=='__main__':main()
