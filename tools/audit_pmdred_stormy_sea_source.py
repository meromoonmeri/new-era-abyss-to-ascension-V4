#!/usr/bin/env python3
"""Authenticate every Stormy Sea selector/property/spawn dependency against PMD Red EU."""
from pathlib import Path
import hashlib,json,sys
ROOT=Path(__file__).resolve().parents[1]; sys.path.insert(0,str(ROOT/'tools'))
from audit_pmdred_eu_rom import parse_dungeon_floor_counts
from pmdred_dungeon_ground import DungeonArchive,parse_mapparam
ROM=ROOT/'.runtime-cache/downloads/pmdred-eu.gba'; EXPECT='0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd'
b=ROM.read_bytes(); assert hashlib.sha256(b).hexdigest()==EXPECT and len(b)==33554432
p=parse_mapparam(DungeonArchive(b),parse_dungeon_floor_counts(b)); s=p['selectors'][19]
assert s['playable_floor_count']==40 and s['selector_row_count']==41
rows=s['rows'][1:]; assert [x['row_index'] for x in rows]==list(range(1,41))
props=[p['properties'][x['property_index']] for x in rows]
assert [x['floor_number'] for x in props]==list(range(1,41))
assert [x['tileset'] for x in props[:15]]==[0]*15
assert [x['tileset'] for x in props[15:39]]==[49]*24
assert props[39]['tileset']==74
assert [x['music'] for x in props[:15]]==[19]*15
assert [x['music'] for x in props[15:39]]==[8]*24
assert props[39]['music']==74
def digest(v):return hashlib.sha256(json.dumps(v,sort_keys=True,separators=(',',':')).encode()).hexdigest()
used={k:sorted(set(x[k] for x in rows)) for k in ('monster_spawn_index','trap_spawn_index')}
used['item_spawn_indices']=sorted(set(i for x in rows for i in x['item_spawn_indices']))
report={'status':'PASS','rom_sha256':EXPECT,'dungeon_id':19,'name_fr':'Mer Houleuse','playable_floors':40,'selector_rows_sha256':digest(rows),'properties_sha256':digest(props),'property_indices':[x['property_index'] for x in rows],'layouts':[x['layout'] for x in props],'tilesets':[x['tileset'] for x in props],'music_selectors':[x['music'] for x in props],'spawn_tables':used,'spawn_table_hashes':{'monster':{str(i):p['monster_spawns'][i]['raw_sha256'] for i in used['monster_spawn_index']},'trap':{str(i):p['trap_spawns'][i]['raw_sha256'] for i in used['trap_spawn_index']},'item':{str(i):p['item_spawns'][i]['raw_sha256'] for i in used['item_spawn_indices']}}}
out=ROOT/'docs/pmdred_eu/playable/stormy_sea';out.mkdir(parents=True,exist_ok=True);(out/'source_authority_2026-08-21.json').write_text(json.dumps(report,indent=2)+'\n')
print('PMDRED_STORMY_SEA_SOURCE_PASS');print(json.dumps({'floors':40,'property_span':[187,226],'monster_tables':len(used['monster_spawn_index']),'item_tables':len(used['item_spawn_indices']),'trap_tables':len(used['trap_spawn_index'])},sort_keys=True))
