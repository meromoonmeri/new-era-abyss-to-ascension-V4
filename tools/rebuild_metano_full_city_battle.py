#!/usr/bin/env python3
"""Reconstruit metano_town_duel depuis 100 % du Ground, sans crop.
Fusion 3x3 des cellules Ground 8 px vers les tuiles donjon 24 px, animations incluses.
"""
from pathlib import Path
import json, sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
import make_metano_arene as conv
W=H=63
NAME='Metano_Full_Battle'

def tile(free,x,y):
 return {'Data':{'ID':'floor' if free else 'unbreakable','TileTex':{'AutoTileset':'','Associates':[],'Layers':[],'NeighborCode':-1},'StableTex':False},'Effect':{'TileLoc':{'X':x,'Y':y},'ID':'','Revealed':False,'Owner':0,'TileStates':[]}}
def nearest(walk,tx,ty):
 best=None
 for x in range(W):
  for y in range(H):
   if walk[x][y]>=5:
    d=(x-tx)**2+(y-ty)**2
    if best is None or d<best[0]:best=(d,x,y)
 return best[1],best[2]
def main():
 layers,walk,sheets=conv.build(0,0,W,H,NAME,True)
 p=ROOT/'Data/Map/metano_town_duel.rsmap';d=json.loads(p.read_text(encoding='utf-8-sig'));o=d['Object']
 o['Layers']=layers;o['Tiles']=[[tile(walk[x][y]>=5,x,y) for y in range(H)] for x in range(W)]
 # Place centrale originale vers (960,912) px = (40,38) tuiles donjon.
 entry=nearest(walk,40,43);boss=nearest(walk,40,38)
 o['EntryPoints']=[{'Loc':{'X':entry[0],'Y':entry[1]},'Dir':4},{'Loc':{'X':entry[0]+1,'Y':entry[1]},'Dir':4}]
 for team in o.get('MapTeams',[]):
  for i,mon in enumerate(team.get('Players',[])):
   x,y=nearest(walk,boss[0]+(i%3)-1,boss[1]+i//3);mon['serializationLoc']={'X':x,'Y':y}
 o['DiscoveryArray']=[[0 for _ in range(H)] for _ in range(W)]
 o['Comment']='Combat Team Dazzling/raid : copie intégrale 1512x1512 de metano_town, fusion 8→24 px sans crop; couches et animations préservées.'
 p.write_text(json.dumps(d,ensure_ascii=False,indent=1),encoding='utf-8')
 print(json.dumps({'map':'metano_town_duel','size':[W,H],'pixels':[W*24,H*24],'layers':len(layers),'sheets':len(sheets),'entry':entry,'boss':boss}))
if __name__=='__main__':main()
