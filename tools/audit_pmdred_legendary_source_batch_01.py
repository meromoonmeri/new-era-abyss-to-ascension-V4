#!/usr/bin/env python3
"""Gate five legendary dungeon floor authorities already extracted from PMD Red EU."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
ROM_HASH='0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd'
TARGETS={'entei':(34,'Terres de Feu','fiery_field','d16p01'),'suicune':(35,'Terres Blizzard','northwind_field','d18p01'),'raikou':(37,'Terres de Foudre','lightning_field','d17p01'),'lugia':(20,"Fosse d'Argent",'silver_trench','d15p01'),'ho_oh':(60,'Pic Inaccessible','mt_faraway','d19p01')}
def digest(v):return hashlib.sha256(json.dumps(v,sort_keys=True,separators=(',',':')).encode()).hexdigest()
a=json.loads((ROOT/'docs/pmdred_eu/playable/ALL_DUNGEON_VISUAL_AUTHORITY_2026-08-21.json').read_text())
assert a['authority']['rom_sha256']==ROM_HASH and a['validation']['status']=='PASS'
by_id={x['dungeon_id']:x for x in a['dungeons']}; reports=[]
for boss,(did,name,zone,ground) in TARGETS.items():
 d=by_id[did];assert d['name_fr']==name and len(d['floors'])==d['playable_floor_count']
 assert [x['floor'] for x in d['floors']]==list(range(1,d['playable_floor_count']+1))
 reports.append({'boss':boss,'dungeon_id':did,'name_fr':name,'zone':zone,'ground':ground,'playable_floors':d['playable_floor_count'],'floor_authority_sha256':digest(d['floors']),'property_indices':[x['property_index'] for x in d['floors']],'layouts':[x['layout'] for x in d['floors']],'tilesets':[x['tileset_id'] for x in d['floors']],'music_selectors':[x['music_selector'] for x in d['floors']],'m4a_song_indices':[x['m4a_song_index'] for x in d['floors']]})
out={'status':'PASS','scope':'five legendary floor visual/music authorities derived from the exhaustive ROM-authenticated corpus; no runtime claim','rom_sha256':ROM_HASH,'source':'ALL_DUNGEON_VISUAL_AUTHORITY_2026-08-21.json','packages':reports,'summary':{'bosses':len(reports),'floors':sum(x['playable_floors'] for x in reports),'unique_properties':len(set(i for x in reports for i in x['property_indices'])),'unique_tilesets':len(set(i for x in reports for i in x['tilesets'])),'unique_music_indices':len(set(i for x in reports for i in x['m4a_song_indices']))}}
p=ROOT/'docs/pmdred_eu/playable/LEGENDARY_SOURCE_BATCH_01_2026-08-21.json';p.write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n')
print('PMDRED_LEGENDARY_SOURCE_BATCH_01_PASS');print(json.dumps(out['summary'],sort_keys=True))
