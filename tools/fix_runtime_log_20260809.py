#!/usr/bin/env python3
import json,glob,copy
from pathlib import Path
R=Path(__file__).resolve().parents[1]
def load(p):return json.load(open(p,encoding='utf-8-sig'))
def dump(p,d):json.dump(d,open(p,'w'),ensure_ascii=False,indent=2);open(p,'a').write('\n')
# Canonical PMDO base tileset IDs, split by original visual phases.
splits={'chasm_cave':('chasm_cave_1','chasm_cave_2',4),'dark_hill':('dark_hill_1','dark_hill_2',8),'dusk_forest':('dusk_forest_1','dusk_forest_2',4),'sealed_ruin_pit':('deep_sealed_ruin','deep_sealed_ruin',999)}
for name,(a,b,cut) in splits.items():
 p=R/f'Data/Zone/{name}.json';d=load(p);floors=d['Object']['Segments'][0]['Floors']
 for i,f in enumerate(floors):
  base=a if i<cut else b
  for st in f.get('GenSteps',[]):
   v=st['Value']
   if 'MapTextureStep' in v.get('$type',''):v['GroundTileset']=base+'_floor';v['BlockTileset']=base+'_wall';v['WaterTileset']=base+'_secondary'
   if 'ConnectGridBranchStep' in v.get('$type','') and 'GenericHalls' not in v:
    # Reuse the floor's authoritative hall generator.
    gp=next((x['Value'] for x in f['GenSteps'] if 'GridPathBranch' in x['Value'].get('$type','')),None)
    hall=copy.deepcopy(gp['GenericHalls']['$values'][0]['Spawn'])
    v['GenericHalls']={'$type':'RogueElements.PresetPicker`1[[RogueElements.PermissiveRoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements','ToSpawn':hall}
    v['HallComponents']=[{'$type':'PMDC.LevelGen.ConnectivityRoom, PMDC','Connection':1}]
 dump(p,d)
# Spiritomb is a fixed room, not a malformed 22x17 grid of cells.
p=R/'Data/Zone/spiritomb_room.json';d=load(p);seg=d['Object']['Segments'][0];seg['Floors']=[{'$type':'RogueEssence.LevelGen.LoadGen, RogueEssence','GenSteps':[{'Key':{'str':[-1]},'Value':{'$type':'RogueEssence.LevelGen.MappedRoomStep`1[[RogueEssence.LevelGen.MapLoadContext, RogueEssence]], RogueEssence','MapID':'spiritomb_arena'}}],'Comment':'Canonical fixed Spiritomb room'}];dump(p,d)
# Every mapped map discovery grid must equal the actual collision Tiles grid.
for p in (R/'Data/Map').glob('*.rsmap'):
 try:d=load(p);o=d['Object'];w=len(o.get('Tiles',[]));h=len(o['Tiles'][0]) if w else 0;a=o.get('DiscoveryArray',[])
 except:continue
 if len(a)!=w or any(len(c)!=h for c in a):o['DiscoveryArray']=[[0 for _ in range(h)] for _ in range(w)];dump(p,d)
print('runtime log corrections applied')
