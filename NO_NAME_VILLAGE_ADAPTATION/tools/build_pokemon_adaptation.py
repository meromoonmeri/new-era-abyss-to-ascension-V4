#!/usr/bin/env python3
"""Build source-locked seasonal PMDO Grounds and exhaustive Pokémon substitutions."""
from __future__ import annotations
import copy,gzip,hashlib,json,math,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];NV=ROOT/'NO_NAME_VILLAGE_ADAPTATION';INV=NV/'extracted/official/inventory'
SEASONS={'spring':{'fr':'printemps','tree':'apricorn_grove_green','music':'Berry Grove.ogg'},'summer':{'fr':'été','tree':'apricorn_grove_green','music':'Apple Woods.ogg'},'autumn':{'fr':'automne','tree':'no_name_village_trees_autumn','music':'Bramble Woods.ogg'},'winter':{'fr':'hiver','tree':'no_name_village_trees_winter','music':'Frosty Forest.ogg'}}
NPCS=[('Audino_Guide','audino',39,39,0),('Meganium_Herboriste','meganium',18,33,2),('Bibarel_Charpentier','bibarel',35,11,4),('Decidueye_Chasseur','decidueye',61,34,6),('Komala_Bucheron','komala',17,32,2),('Leavanny_Couturiere','leavanny',31,39,4),('Torkoal_Forgeron','torkoal',44,39,6)]
BOSS=[('objbmob0','ursaluna','Gardien de la lisière'),('objbmobsm','volcarona','Cœur de l’été'),('objbmobau','trevenant','Sire de l’automne'),('objbmobwn2','baxcalibur','Crocs de l’hiver'),('objbmobwn','froslass','Dame du blizzard'),('objbmoben','darkrai','Ombre sans nom'),('objboss','darkrai','Contrôleur de confrontation')]
def load(n):return json.load(gzip.open(INV/(n+'.json.gz'),'rt',encoding='utf-8'))
def ref(x):return ((x or {}).get('$resourceRef') or {}) if isinstance(x,dict) else {}
def empty():return {'AutoTileset':'','Associates':[],'Layers':[],'NeighborCode':-1}
def frame(sheet,x,y):return {'AutoTileset':'','Associates':[],'Layers':[{'Frames':[{'Sheet':sheet,'TexLoc':{'X':x,'Y':y}}],'FrameLength':999}],'NeighborCode':-1}
def point_hash(x,y,salt=0):return (x*73856093^y*19349663^salt*83492791)&0xffffffff
def classify(name,visible,sprite):
 n=name.lower();species=None;role='pmdo_mechanic';boss=False
 roles={'objherbalist':'meganium','objblacksmith':'torkoal','objcarpenter':'bibarel','objhunter':'decidueye','objlogger':'komala','objseamstress':'leavanny','objnpc':'audino','objnpcspawn':'audino'}
 if n in roles:species=roles[n];role='pokemon_actor'
 elif n=='objplayer':species='player_party_leader';role='pokemon_player_runtime'
 elif 'butterfly' in n:species='butterfree';role='pokemon_wildlife'
 elif 'bird' in n:species='fletchling';role='pokemon_wildlife'
 elif 'fish' in n:species='magikarp';role='pokemon_wildlife'
 for pre,sp,_ in BOSS:
  if n.startswith(pre):species=sp;role='pokemon_boss' if n==pre or (visible and sprite) else 'pokemon_move_vfx';boss=True;break
 if species is None and n.startswith('objmobau'):species=['phantump','shiftry','gourgeist','trevenant','pumpkaboo','sawsbuck'][point_hash(len(n),sum(map(ord,n)))%6];role='pokemon_enemy'
 elif species is None and n.startswith('objmobsm'):species=['scyther','heracross','lurantis','scovillain','vespiquen','pinsir'][point_hash(len(n),sum(map(ord,n)))%6];role='pokemon_enemy'
 elif species is None and n.startswith('objmobwn'):species=['sneasel','snorunt','beartic','cryogonal','delibird','glaceon'][point_hash(len(n),sum(map(ord,n)))%6];role='pokemon_enemy'
 elif species is None and re.match(r'objmob\d',n):species=['zigzagoon','poochyena','shroomish'][point_hash(len(n),sum(map(ord,n)))%3];role='pokemon_enemy'
 elif species is None and (n.startswith('objmob') or n.startswith('objbfmob')):species='kecleon';role='pokemon_enemy'
 elif species is None and any(k in n for k in ['wall','slope','col','tree','plant','grass','boulder','rock','house']):role='terrain_or_collision'
 elif species is None and any(k in n for k in ['particle','trail','shad','surf','ripple','splash','cloud','ray','leaf','snow','puddle']):role='pokemon_move_vfx'
 return role,species,boss
def entity_plan(objects):
 rows=[]
 for i,o in enumerate(objects):
  name=o.get('Name','');sprite=ref(o.get('Sprite')).get('name');role,species,boss=classify(name,bool(o.get('Visible')),sprite)
  rows.append({'source_object_id':i,'source_object':name,'source_sprite':sprite,'source_visible':bool(o.get('Visible')),'conversion':role,'pokemon_species':species,'boss_lineage':boss,'human_entity_remaining':False,'justification':'Rôle source conservé; représentation remplacée par un Pokémon ou par une mécanique/VFX PMDO.'})
 return {'schema':'no-name-village.pokemon-entity-plan.v1','status':'ALL_SOURCE_OBJECTS_CLASSIFIED','policy':{'all_living_entities_are_pokemon':True,'all_bosses_are_pokemon':True,'human_entity_remaining':0,'player':'Le meneur réel de l’équipe PMDO; aucun avatar humain ni MissingNo.'},'boss_roster':[{'source_prefix':a,'pokemon':b,'title_fr':c} for a,b,c in BOSS],'objects':rows}
def auto_tile(tile_id,mask,autos):
 key=f'Tilex{mask:02X}';variants=autos.get(key) or autos.get('TilexFF') or []
 return {'AutoTileset':tile_id,'Associates':[],'Layers':copy.deepcopy(variants[0]) if variants else [],'NeighborCode':256|mask}
def tree_layer(room,season):
 grid=[[empty() for _ in range(78)] for _ in range(78)];anchors=[];sheet='No_Name_Village_Standalone_Tree_'+season.capitalize()
 for g in sorted(room['GameObjects'],key=lambda q:q.get('Y',0)):
  if ref(g.get('ObjectDefinition')).get('name','') not in ('objtree','objtree0'):continue
  ax,ay=round(g['X']/64),round(g['Y']/64);anchors.append((ax,ay))
  for ix in range(5):
   for iy in range(6):
    x,y=ax-2+ix,ay-5+iy
    if 0<=x<78 and 0<=y<78:grid[x][y]=frame(sheet,ix,iy)
 return grid,set(anchors)
def relief_layer(obstacles,grass0,season):
 mask=set();houses=[(12,24,12,11),(12,45,8,10),(57,27,10,10),(31,3,8,10)]
 for x in range(78):
  for y in range(78):
   solid=sum(bool(obstacles[x*3+dx][y*3+dy]['Tags']) for dx in range(3) for dy in range(3));in_house=any(hx<=x<hx+hw and hy<=y<hy+hh for hx,hy,hw,hh in houses);path=(grass0[y][x]&0x7ffff)!=25
   if solid>=5 and not in_house and not path:mask.add((x,y))
 grid=[[empty() for _ in range(78)] for _ in range(78)];sheet='ForestCamp' if season in ('spring','summer') else ('No_Name_Village_Forest_Autumn' if season=='autumn' else 'No_Name_Village_Forest_Winter')
 for x,y in mask:grid[x][y]=frame(sheet,x%33,y%5)
 return grid,len(mask)
def collision_grid(room,objects,sprites):
 W=H=234;blocked=[[False for _ in range(H)] for _ in range(W)];colliders={'objbwall','objcolwall','objbslope','objtreecol','objcolslope','objbcwall','objbcslope','objcol'};used=0
 for g in room['GameObjects']:
  oid=ref(g.get('ObjectDefinition')).get('index')
  if oid is None or objects[oid]['Name'] not in colliders:continue
  sid=ref(objects[oid].get('Sprite')).get('index')
  if sid is None:continue
  s=sprites[sid];masks=s.get('CollisionMasks') or [];raw=None;mw=s.get('Width',0);mh=s.get('Height',0)
  if masks:
   bi=masks[0].get('Data',{}).get('$binary',{});bp=NV/'extracted/official'/bi.get('path','');raw=bp.read_bytes() if bp.is_file() else None;mw=masks[0].get('Width',mw);mh=masks[0].get('Height',mh)
  sx,sy=float(g.get('ScaleX',1)),float(g.get('ScaleY',1));ang=math.radians(float(g.get('Rotation',0)));ca,sa=math.cos(-ang),math.sin(-ang);ox,oy=s.get('OriginX',0),s.get('OriginY',0);radius=max(mw*abs(sx),mh*abs(sy));minx=max(0,int((g['X']-radius)*.375/8)-1);maxx=min(W-1,int((g['X']+radius)*.375/8)+1);miny=max(0,int((g['Y']-radius)*.375/8)-1);maxy=min(H-1,int((g['Y']+radius)*.375/8)+1);stride=(mw+7)//8
  for tx in range(minx,maxx+1):
   for ty in range(miny,maxy+1):
    wx=(tx*8+4)/.375-g['X'];wy=(ty*8+4)/.375-g['Y'];rx=ca*wx-sa*wy;ry=sa*wx+ca*wy
    if sx==0 or sy==0:continue
    lx=int(rx/sx+ox);ly=int(ry/sy+oy)
    if 0<=lx<mw and 0<=ly<mh and (raw is None or raw[ly*stride+lx//8]&(1<<(7-lx%8))):blocked[tx][ty]=True
  used+=1
 proto={'Bounds':{'X':0,'Y':0,'Width':8,'Height':8},'Tags':0};out=[]
 for x in range(W):
  col=[]
  for y in range(H):q=copy.deepcopy(proto);q['Bounds']['X']=x*8;q['Bounds']['Y']=y*8;q['Tags']=1 if blocked[x][y] else 0;col.append(q)
  out.append(col)
 return out,used
def make_actor_px(proto,name,species,x,y,d):
 q=copy.deepcopy(proto);q['EntName']=name;q['Direction']=d;q['serializationLoc']={'X':x,'Y':y};q['serializationHeight']=0;q['serializationDir']=d;q['Collider']={'X':x,'Y':y,'Width':16,'Height':16};q['Data']['BaseForm']={'Species':species,'Form':0,'Skin':'normal','Gender':0};q['Data']['Level']=30;q['Data']['BaseIntrinsics']=[''];q['Data']['Nickname']='';return q
def nearest_clear_actor(obstacles,px,py,reserved):
 tx,ty=round(px/8),round(py/8);choices=[]
 for x in range(len(obstacles)-1):
  for y in range(len(obstacles[0])-1):
   if (x,y) in reserved:continue
   if all(obstacles[ix][iy]['Tags']==0 for ix in (x,x+1) for iy in (y,y+1)):choices.append(((x-tx)**2+(y-ty)**2,x,y))
 if not choices:raise ValueError('No clear Pokémon actor position')
 _,x,y=min(choices);reserved.add((x,y));return x*8,y*8
def make_trigger(proto,name,x,y,w=24,h=16,passable=False):
 q=copy.deepcopy(proto);q['EntName']=name;q['triggerType']=2;q['Passable']=passable;q['ObjectAnim']['AnimIndex']='';q['Collider']={'X':round(x),'Y':round(y),'Width':w,'Height':h};q['DrawOffset']={'X':0,'Y':0};return q
def build_maps(room,objects,sprites):
 template=json.load(open(ROOT/'Data/Ground/bourg_comptoir.rsground',encoding='utf-8-sig'));actor_proto=template['Object']['Entities'][0]['MapChars'][0];touch_proto=next(x for x in template['Object']['Entities'][0]['GroundObjects'] if x.get('triggerType')==2);marker_proto=template['Object']['Entities'][0]['Markers'][0];obstacles,colliders=collision_grid(room,objects,sprites)
 for sx,sy in ((940,3296),(1096,1952),(3912,2080),(2200,608)):
  cx,cy=round(sx*.375/8),round(sy*.375/8)
  for x in range(max(0,cx-1),min(len(obstacles),cx+3)):
   for y in range(max(0,cy-2),min(len(obstacles[0]),cy+11)):obstacles[x][y]['Tags']=0
 blocked=sum(bool(q['Tags']) for col in obstacles for q in col);grass0=next(l for l in room['Layers'] if l['LayerName']=='grass0')['Data']['TileData'];reports=[]
 for si,(season,cfg) in enumerate(SEASONS.items()):
  doc=copy.deepcopy(template);o=doc['Object'];o['TexSize']=3;o['AssetName']='no_name_village_'+season;o['Name']={'DefaultText':'Village sans Nom — '+cfg['fr'].capitalize(),'LocalTexts':{'fr':'Village sans Nom — '+cfg['fr'].capitalize()}};o['Comment']='Adaptation PMDO structurée depuis rmvillage (78×78 tuiles source), bâtiments PMD et entités exclusivement Pokémon.';o['Music']=cfg['music'];o['obstacles']=copy.deepcopy(obstacles);o['Decorations']=[]
  base=[[empty() for _ in range(78)] for _ in range(78)];grass_samples=[(8,8),(10,9),(12,10),(14,11),(15,13)];path_samples=[(11,5),(11,7),(12,9),(10,11),(11,14)];snow_samples=[(12,15),(14,17),(9,20),(18,21),(11,23)]
  for x in range(78):
   for y in range(78):
    path=(grass0[y][x]&0x7ffff)!=25;h=point_hash(x,y,si)
    if season=='winter':px,py=snow_samples[h%len(snow_samples)];base[x][y]=frame('SnowCamp',px,py)
    elif path:px,py=path_samples[h%len(path_samples)];base[x][y]=frame('Apple Woods Entrance Layer 1',px,py)
    else:px,py=grass_samples[h%len(grass_samples)];base[x][y]=frame('ForestCamp',px,py)
  relief,relief_cells=relief_layer(obstacles,grass0,season);trees,_=tree_layer(room,season);build=[[empty() for _ in range(78)] for _ in range(78)];placements=[((8,16,6,8),(13,46)),((14,0,10,8),(13,25)),((22,16,8,8),(58,28)),((8,16,6,8),(32,4))];building_sheet='No_Name_Village_Buildings' if season in ('spring','summer') else ('No_Name_Village_Buildings_Autumn' if season=='autumn' else 'No_Name_Village_Buildings_Winter')
  for (sx,sy,w,h),(dx,dy) in placements:
   for ix in range(w):
    for iy in range(h):
     if 0<=dx+ix<78 and 0<=dy+iy<78:build[dx+ix][dy+iy]=frame(building_sheet,sx+ix,sy+iy)
  o['Layers']=[{'Name':'Sol et terrain PMD','Layer':0,'Visible':True,'Tiles':base},{'Name':'Relief et lisières PMD','Layer':0,'Visible':True,'Tiles':relief},{'Name':'Végétation saisonnière PMD','Layer':0,'Visible':True,'Tiles':trees},{'Name':'Bâtiments Pokémon','Layer':0,'Visible':True,'Tiles':build}]
  e=o['Entities'][0];e['Name']='Entités Pokémon';reserved=set();actors=[]
  for name,species,x,y,d in NPCS:
   px,py=nearest_clear_actor(obstacles,x*24,y*24,reserved);actors.append(make_actor_px(actor_proto,name,species,px,py,d))
  e['MapChars']=actors;e['Spawners']=copy.deepcopy(template['Object']['Entities'][0]['Spawners']);e['GroundObjects']=[make_trigger(touch_proto,'Maison_Joueur_Entree',940*.375,3296*.375,24,16,True),make_trigger(touch_proto,'Maison_Bucheron_Entree',1096*.375,1952*.375,24,16,True),make_trigger(touch_proto,'Maison_Chasseur_Entree',3912*.375,2080*.375,24,16,True),make_trigger(touch_proto,'Maison_Charpentier_Entree',2200*.375,608*.375,24,16,True),make_trigger(touch_proto,'Sortie_Nord',0,0,1872,8),make_trigger(touch_proto,'Sortie_Sud',0,1864,1872,8),make_trigger(touch_proto,'Sortie_Ouest',0,0,8,1872),make_trigger(touch_proto,'Sortie_Est',1864,0,8,1872)];e['Markers']=[]
  for name,x,y,d in [('Main_Entrance_Marker',2208*.375,4928*.375,4),('Spawn_Nord',2912*.375,64*.375,4),('Spawn_Ouest',992*.375,3520*.375,6),('Spawn_Centre_Ouest',1152*.375,2176*.375,6),('Spawn_Nord_Centre',2272*.375,832*.375,4),('Spawn_Est',3968*.375,2304*.375,2),('Retour_Maison_Joueur',1000*.375,3480*.375,4),('Retour_Maison_Chasseur',3968*.375,2272*.375,4),('Retour_Maison_Bucheron',1152*.375,2144*.375,4),('Retour_Maison_Charpentier',2256*.375,800*.375,4)]:q=copy.deepcopy(marker_proto);q['EntName']=name;q['Direction']=d;q['Collider']={'X':round(x),'Y':round(y),'Width':16,'Height':16};e['Markers'].append(q)
  out=ROOT/'Data/Ground'/('no_name_village_'+season+'.rsground');out.write_text('\ufeff'+json.dumps(doc,ensure_ascii=False,indent=1),encoding='utf8');reports.append({'season':season,'path':str(out.relative_to(ROOT)),'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'dimensions_tiles':[78,78],'dimensions_px':[1872,1872],'obstacle_grid':[234,234],'blocked_cells':blocked,'source_colliders':colliders,'pokemon_actors':len(e['MapChars']),'pokemon_actor_positions_px':{a['EntName']:[a['serializationLoc']['X'],a['serializationLoc']['Y']] for a in e['MapChars']},'human_actors':0,'relief_cells':relief_cells,'layers':len(o['Layers'])})
 return reports
def main():
 objects,sprites,rooms=load('GameObjects'),load('Sprites'),load('Rooms');room=next(r for r in rooms if r.get('Name')=='rmvillage');plan=entity_plan(objects);placements=[]
 for source_room in rooms:
  for inst in source_room.get('GameObjects',[]):
   name=ref(inst.get('ObjectDefinition')).get('name','')
   for prefix,species,title in BOSS:
    if name.startswith(prefix):placements.append({'source_room':source_room.get('Name'),'source_object':name,'source_instance_id':inst.get('InstanceID'),'source_position_px':[inst.get('X'),inst.get('Y')],'pokemon_species':species,'title_fr':title,'status':'POKEMON_BOSS_PLACEMENT_SOURCE_LOCKED'});break
 plan['source_boss_placements']=placements;plan['source_boss_placement_count']=len(placements);(NV/'reports/pokemon-entity-plan.json').write_text(json.dumps(plan,ensure_ascii=False,indent=2)+'\n');maps=build_maps(room,objects,sprites);report={'schema':'no-name-village.pmdo-candidate.v2','status':'STRUCTURED_PMDO_CANDIDATES_BUILT','source_room':{'name':'rmvillage','dimensions_px':[4992,4992],'logical_tiles':[78,78]},'scale':{'source_tile_px':64,'pmdo_tile_px':24,'ratio':0.375,'proportions_preserved':True},'graphics':{'source':'PMDO/PMD packages only','source_sheets':['ForestCamp','Apple Woods Entrance Layer 1','SnowCamp','No_Name_Village_Buildings_{Season}','No_Name_Village_Standalone_Tree_{Season}','No_Name_Village_Forest_{Season}'],'screenshot_as_map_data':False},'maps':maps,'entities':{'plan':'reports/pokemon-entity-plan.json','all_living_entities_pokemon':True,'bosses_pokemon':True},'integration':'CANDIDATE_NOT_ADDED_TO_PROTECTED_MASTER_ZONE'};(NV/'reports/pmdo-candidate.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps({'maps':len(maps),'objects_classified':len(plan['objects']),'boss_placements':len(placements),'status':report['status']}))
if __name__=='__main__':main()
