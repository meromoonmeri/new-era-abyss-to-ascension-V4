#!/usr/bin/env python3
import json,re
from pathlib import Path
R=Path(__file__).resolve().parents[1]
S=Path(__import__('os').environ.get('PMD_RED_SOURCE','/home/user/pmd-red'))/'data/dungeon/SinisterWoods/pokemon_found.json'
src=json.loads(S.read_text())['tables']; raw=[]
exc={'MR_MIME':'mr_mime','FARFETCHD':'farfetchd','NIDORAN_F':'nidoran_f','NIDORAN_M':'nidoran_m'}
for t in src:
 q=[]
 for p in t['pokemon']:
  k=p['species'].replace('MONSTER_','')
  if p['probability']>0 and k not in ('KECLEON','DECOY'):q.append((exc.get(k,k.lower()),p['level'],p['probability']))
 raw.append(q)
raw=raw[:8]+[raw[7]]+raw[8:]
z=json.loads((R/'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))['Object']
def actual(seg,count):
 st=next(x for x in z['Segments'][seg]['ZoneSteps'] if 'TeamSpawnZoneStep' in x['$type']);out=[]
 for f in range(count):
  q=[]
  for x in st['Spawns']:
   if x['Range']=={'Min':f,'Max':f+1}:
    m=x['Spawn']['Spawn'];q.append((m['BaseForm']['Species'],m['Level']['Min'],x['Rate']))
  out.append(q)
 return out
act=actual(0,15)+actual(1,5)+actual(3,3); expected=[raw[i%13] for i in range(23)]
s=json.dumps(z);checks={'23_floor_spawn_tables':len(act)==23,'species_level_probability_exact':act==expected,'no_relic_forest_dependency':'relic_forest' not in s,'no_generic_forest_1':'forest_1_' not in s,'canonical_gba_music':False}
print(json.dumps({'source':'pret/pmd-red data/dungeon/SinisterWoods','gba_tables':13,'pmdo_floors':23,'checks':checks,'graphics_status':'REQUIRES_GBA_TILESET_CONVERSION','runtime':'NOT_TESTED'},indent=2));raise SystemExit(0 if all(checks.values()) else 1)
