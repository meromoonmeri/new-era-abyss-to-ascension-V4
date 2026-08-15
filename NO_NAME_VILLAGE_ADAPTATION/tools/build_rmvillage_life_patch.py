#!/usr/bin/env python3
"""Build native Pokemon social/wildlife entities over pixel-perfect rmvillage."""
from __future__ import annotations
import copy,hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parent
SOCIAL=[
 ('NNV_Carpenter','timburr','Charpentier',2200,672,'carpenter','Construction et entretien des maisons; type et anatomie adaptés au travail manuel.'),
 ('NNV_Logger','bidoof','Bûcheron',1096,2016,'logger','Pokémon forestier associé au bois et aux ouvrages naturels.'),
 ('NNV_Hunter','decidueye','Éclaireur',3912,2144,'hunter','Archer forestier silencieux, correspondant au rôle de pisteur source.'),
 ('NNV_Herbalist','roselia','Herboriste',3848,2144,'herbalist','Spécialiste native des plantes médicinales.'),
 ('NNV_Seamstress','leavanny','Couturière',1152,2016,'seamstress','Pokémon couturier utilisant feuilles et fils végétaux.'),
]
WILD=[
 ('NNV_Wild_Fletchling','fletchling','Oiseau des clairières'),('NNV_Wild_Scatterbug','scatterbug','Insecte du sous-bois'),
 ('NNV_Wild_Caterpie','caterpie','Insecte forestier'),('NNV_Wild_Hoppip','hoppip','Dispersion végétale'),
 ('NNV_Wild_Oddish','oddish','Herbe nocturne et humide'),('NNV_Wild_Deerling','deerling','Herbivore saisonnier'),
]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def nearest(obstacles,x,y):
 def free(px,py):
  cx,cy=px//8,py//8
  return 1<=cx<len(obstacles)-1 and 1<=cy<len(obstacles[0])-1 and all(obstacles[ix][iy]['Tags']==0 for ix in range(cx-1,cx+2) for iy in range(cy-1,cy+2))
 x=(x//8)*8;y=(y//8)*8
 if free(x,y):return x,y,0
 for radius in range(8,257,8):
  for dx,dy in ((0,radius),(radius,0),(0,-radius),(-radius,0),(radius,radius),(-radius,radius),(radius,-radius),(-radius,-radius)):
   if free(x+dx,y+dy):return x+dx,y+dy,radius
 raise ValueError(f'no walkable position near {x},{y}')
def main():
 base=ROOT/'generated/rmvillage/summer';manifest=json.loads((base/'manifest.json').read_text());ground=json.loads((base/manifest['outputs']['ground']).read_text(encoding='utf-8-sig'))['Object'];obstacles=ground['obstacles']
 prototype_ground=json.loads((REPO/'Data/Ground/altere_pond.rsground').read_text(encoding='utf-8-sig'))['Object'];prototype=next(c for layer in prototype_ground['Entities'] for c in layer['MapChars'])
 source_spawns=sorted((m for layer in ground['Entities'] for m in layer['Markers'] if m['EntName'].startswith('SourceSpawn_')),key=lambda m:m['EntName']);assert len(source_spawns)==6
 entities=[];evidence=[]
 def entity(name,species,nickname,x,y,kind,source_anchor,rationale):
  px,py,offset=nearest(obstacles,x,y);e=copy.deepcopy(prototype);e.update({'EntName':name,'Direction':0,'serializationDir':0,'serializationLoc':{'X':px,'Y':py},'Collider':{'X':px,'Y':py,'Width':16,'Height':16},'AIEnabled':True,'EntEnabled':True,'triggerType':1});e['Data']['Nickname']=nickname;e['Data']['BaseForm']={'Species':species,'Form':0,'Skin':'normal','Gender':0};e['Data']['Level']=1;e['Data']['Unrecruitable']=True;e['Data']['ScriptVars']={'nnv_kind':kind};entities.append(e);evidence.append({'entity':name,'species':species,'kind':kind,'source_anchor':source_anchor,'requested':[x,y],'position':[px,py],'walkability_adjustment_px':offset,'rationale':rationale})
 for name,species,nick,x,y,role,why in SOCIAL:entity(name,species,nick,x,y,'social:'+role,{'type':'source_role_and_house','role':role},why)
 for (name,species,why),marker in zip(WILD,source_spawns,strict=True):
  x,y=marker['Collider']['X'],marker['Collider']['Y'];entity(name,species,species.capitalize(),x,y,'wild:ambient',{'type':'source_spawn_marker','marker':marker['EntName']},why)
 out=ROOT/'generated/rmvillage/life';out.mkdir(parents=True,exist_ok=True);patch={'schema':'new-era.nnv-rmvillage-pokemon-life-patch.v1','room':'rmvillage','base_ground_sha256':sha(base/manifest['outputs']['ground']),'entity_count':len(entities),'social_count':len(SOCIAL),'wild_count':len(WILD),'entities':entities,'evidence':evidence,'status':'LIFE_PATCH_GENERATED','runtime_status':'NOT_RUN','conversion_status':'UNIMPLEMENTED','certification_status':'NOT_CERTIFIED','promotion_allowed':False,'blockers':['entities not merged into four seasonal runtime fixtures','social routines/interactions not runtime tested','wild entities are ambient layer only; source-wide encounter system not implemented','rm82 nest ecology remains separate']};patch['semantic_sha256']=hashlib.sha256(json.dumps(patch,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();(out/'entities_patch.json').write_text(json.dumps(patch,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
 print(json.dumps({'result':'RMVILLAGE_LIFE_PATCH_PASS','entities':len(entities),'social':len(SOCIAL),'wild':len(WILD),'status':patch['status']}))
if __name__=='__main__':main()
