#!/usr/bin/env python3
"""Build source-sized Pokémon-compatible interiors deterministically."""
import copy,gzip,hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];INV=ROOT/'NO_NAME_VILLAGE_ADAPTATION/extracted/official/inventory/Rooms.json.gz'
SPECS={'no_name_player_house':('metano_normal_home','playerhouse','Maison commune','Audino'),'no_name_logger_house':('metano_grass_home','loggerhouse','Atelier du bûcheron','Komala'),'no_name_hunter_house':('metano_rock_home','hunterhouse','Refuge du chasseur','Decidueye'),'no_name_carpenter_house':('metano_electric_home','carpenterhouse','Atelier du charpentier','Bibarel')}
def empty():return {'AutoTileset':'','Associates':[],'Layers':[],'NeighborCode':-1}
def main():
 rooms=json.load(gzip.open(INV,'rt',encoding='utf8'));by={r['Name']:r for r in rooms};rows=[]
 for asset,(pmd,source,title,pokemon) in SPECS.items():
  src=by[source];doc=json.load(open(ROOT/'Data/Ground'/f'{pmd}.rsground',encoding='utf-8-sig'));o=doc['Object'];old_w=len(o['Layers'][0]['Tiles']);old_h=len(o['Layers'][0]['Tiles'][0]);target_w=round(src['Width']*.375/8);target_h=round(src['Height']*.375/8);transit=next(g for g in src['GameObjects'] if ((g.get('ObjectDefinition')or{}).get('$resourceRef')or{}).get('name')=='objtransit');tx=round(transit['X']*.375);ty=round(transit['Y']*.375);ent=o['Entities'][0];exit_obj=next(x for x in ent['GroundObjects'] if x.get('triggerType')==2);old_c=exit_obj['Collider'];dx=round((tx-(old_c['X']+old_c['Width']/2))/8);dy=round((ty-old_c['Y'])/8)
  for layer in o['Layers']:
   old=layer['Tiles'];grid=[[empty() for _ in range(target_h)] for _ in range(target_w)]
   for x in range(old_w):
    for y in range(old_h):
     if 0<=x+dx<target_w and 0<=y+dy<target_h:grid[x+dx][y+dy]=old[x][y]
   layer['Tiles']=grid
  old_obs=o['obstacles'];proto=copy.deepcopy(old_obs[0][0]);obs=[]
  for x in range(target_w):
   col=[]
   for y in range(target_h):q=copy.deepcopy(proto);q['Bounds']={'X':x*8,'Y':y*8,'Width':8,'Height':8};q['Tags']=1;col.append(q)
   obs.append(col)
  for x in range(len(old_obs)):
   for y in range(len(old_obs[0])):
    if 0<=x+dx<target_w and 0<=y+dy<target_h:q=copy.deepcopy(old_obs[x][y]);q['Bounds']['X']+=dx*8;q['Bounds']['Y']+=dy*8;obs[x+dx][y+dy]=q
  o['obstacles']=obs;o['AssetName']=asset;o['Name']={'DefaultText':title,'LocalTexts':{'fr':title}};o['Comment']=f'Intérieur Pokémon {source} : limites source {src["Width"]}×{src["Height"]} px normalisées à 720×480 px; porte source conservée; mobilier PMD de {pmd}.';o['Music']='On the Beach at Dusk.ogg';o['Decorations']=[];ent['Name']='Entités Pokémon';ent['MapChars']=[];ent['Spawners']=[];exit_obj['EntName']='Village_Exit';exit_obj['Collider']['X']=tx-exit_obj['Collider']['Width']//2;exit_obj['Collider']['Y']=ty;marker=copy.deepcopy(ent['Markers'][0]);marker['EntName']='Main_Entrance_Marker';marker['Collider']={'X':tx-8,'Y':ty-24,'Width':16,'Height':16};ent['Markers']=[marker]
  out=ROOT/'Data/Ground'/f'{asset}.rsground';out.write_text('\ufeff'+json.dumps(doc,ensure_ascii=False,indent=1),encoding='utf8');rows.append({'asset':asset,'source_room':source,'source_dimensions_px':[src['Width'],src['Height']],'pmdo_dimensions_px':[target_w*8,target_h*8],'pmdo_obstacle_grid':[target_w,target_h],'source_transit_px':[transit['X'],transit['Y']],'pmdo_transit_px':[tx,ty],'pmd_furniture_source':pmd,'resident_pokemon':pokemon,'human_beds':0,'human_entities':0,'sha256':hashlib.sha256(out.read_bytes()).hexdigest()})
 report={'schema':'no-name-village.interiors.v2','status':'SOURCE_BOUNDS_AND_TRANSITS_POKEMON_INTERIORS_BUILT','scale':.375,'policy':{'source_room_bounds_preserved':True,'source_transit_positions_preserved':True,'human_beds_removed':True,'human_entities_removed':True,'pokemon_compatible_furniture':True},'interiors':rows};(ROOT/'NO_NAME_VILLAGE_ADAPTATION/reports/interior-adaptation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps({'status':report['status'],'interiors':len(rows)}))
if __name__=='__main__':main()
