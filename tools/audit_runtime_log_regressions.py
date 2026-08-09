#!/usr/bin/env python3
import json,glob,os,sys
from pathlib import Path
R=Path(__file__).resolve().parents[1];fails=[]
# invalid generic stairs
for p in (R/'Data/Zone').glob('*.json'):
 s=p.read_text(encoding='utf-8-sig')
 if 'FloorStairsStep' in s and 'RogueElements.TeamSpawner' in s:fails.append(f'{p}: unresolved FloorStairsStep TeamSpawner')
# mapped map discovery grids
for p in (R/'Data/Map').glob('*.rsmap'):
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object'];w=len(o['Tiles']);h=len(o['Tiles'][0]);a=o.get('DiscoveryArray',[])
 except:continue
 if len(a)!=w or any(len(c)!=h for c in a):fails.append(f'{p}: DiscoveryArray mismatch')
# required Sky Tower relay spawners
p=R/'Data/Ground/palier_celeste.rsground';o=json.load(open(p,encoding='utf-8-sig'))['Object'];sp={x['EntName'] for l in o['Entities'] for x in l.get('Spawners',[])}
for n in ['TEAMMATE_1','TEAMMATE_2','TEAMMATE_3']:
 if n not in sp:fails.append(f'palier_celeste missing {n}')
# canonical base autotiles known from PMDO 0.8.12 DumpAsset
bad=['chasm_cave_floor','dark_hill_floor','dusk_forest_floor','sealed_ruin_pit_floor']
for p in (R/'Data/Zone').glob('*.json'):
 s=p.read_text(encoding='utf-8-sig')
 for x in bad:
  if f'"{x}"' in s:fails.append(f'{p}: unresolved tileset {x}')
print('runtime regression failures:',len(fails));print('\n'.join(fails));sys.exit(1 if fails else 0)
