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
WILD_GROUPS=[
 ('fletchling',2,'flock','timid','Oiseaux sociaux des clairières; paire indépendante capable de fuite et regroupement.'),
 ('scatterbug',3,'colony','timid','Colonie d’insectes du sous-bois regroupée près de la végétation.'),
 ('caterpie',2,'colony','timid','Deux individus forestiers qui se nourrissent ensemble sans former un sprite composite.'),
 ('hoppip',3,'drift','social','Petit groupe végétal dispersé par le vent dans une zone ouverte.'),
 ('oddish',2,'patch','nocturnal','Groupe végétal associé aux sols humides, actif selon le contexte jour/nuit.'),
 ('deerling',1,'territory','territorial','Herbivore saisonnier solitaire occupant un territoire de clairière.'),
]
OFFSETS=((0,0),(32,0),(-32,0),(0,32),(0,-32),(32,32),(-32,32),(32,-32),(-32,-32))
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
 def entity(name,species,nickname,x,y,kind,source_anchor,rationale,group=None,behavior=None,index=None):
  px,py,offset=nearest(obstacles,x,y);e=copy.deepcopy(prototype);e.update({'EntName':name,'Direction':0,'serializationDir':0,'serializationLoc':{'X':px,'Y':py},'Collider':{'X':px,'Y':py,'Width':16,'Height':16},'AIEnabled':True,'EntEnabled':True,'triggerType':1});e['Data']['Nickname']=nickname;e['Data']['BaseForm']={'Species':species,'Form':0,'Skin':'normal','Gender':0};e['Data']['Level']=1;e['Data']['Unrecruitable']=True;e['Data']['ScriptVars']={'nnv_kind':kind,'nnv_group':group,'nnv_behavior':behavior,'nnv_member_index':index};entities.append(e);evidence.append({'entity':name,'species':species,'kind':kind,'group':group,'behavior':behavior,'member_index':index,'source_anchor':source_anchor,'requested':[x,y],'position':[px,py],'walkability_adjustment_px':offset,'rationale':rationale})
 for name,species,nick,x,y,role,why in SOCIAL:entity(name,species,nick,x,y,'social:'+role,{'type':'source_role_and_house','role':role},why)
 wild_count=0
 for group_index,(species,count,group,behavior,why) in enumerate(WILD_GROUPS):
  marker=source_spawns[group_index];anchor_x,anchor_y=marker['Collider']['X'],marker['Collider']['Y']
  for member in range(count):
   dx,dy=OFFSETS[member];name=f'NNV_Wild_{species.capitalize()}_{member+1}';entity(name,species,species.capitalize(),anchor_x+dx,anchor_y+dy,'wild:'+behavior,{'type':'source_spawn_marker','marker':marker['EntName']},why,group,behavior,member+1);wild_count+=1
 out=ROOT/'generated/rmvillage/life';out.mkdir(parents=True,exist_ok=True);patch={'schema':'new-era.nnv-rmvillage-pokemon-life-patch.v2','room':'rmvillage','base_ground_sha256':sha(base/manifest['outputs']['ground']),'entity_count':len(entities),'social_count':len(SOCIAL),'wild_count':wild_count,'wild_group_count':len(WILD_GROUPS),'entities':entities,'evidence':evidence,'dominant_selection':{'pokemon':None,'status':'NOT_APPLICABLE_FOR_RMVILLAGE','reason':'rmvillage est un hub habité sans fonction de boss source; imposer Klawf, Bombirdier, Orthworm, Dondozo/Tatsugiri ou Great Tusk/Iron Treads serait arbitraire. Les Dominants restent réservés aux rooms dont le biome et la structure de rencontre les justifient.'},'status':'LIFE_PATCH_GENERATED','runtime_status':'NOT_RUN','conversion_status':'UNIMPLEMENTED','certification_status':'NOT_CERTIFIED','promotion_allowed':False,'blockers':['entities not merged into four seasonal runtime fixtures','social routines/interactions not runtime tested','wild entities are ambient layer only; source-wide encounter system not implemented','rm82 nest ecology remains separate']}
 for key,name in (('script','NNVLife.lua'),('ground_script','init.lua')):
  path=out/name
  if not path.is_file():raise FileNotFoundError(path)
  patch[key]=name;patch[key+'_sha256']=sha(path)
 patch['semantic_sha256']=hashlib.sha256(json.dumps(patch,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();(out/'entities_patch.json').write_text(json.dumps(patch,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
 print(json.dumps({'result':'RMVILLAGE_LIFE_PATCH_PASS','entities':len(entities),'social':len(SOCIAL),'wild':wild_count,'groups':len(WILD_GROUPS),'status':patch['status']}))
if __name__=='__main__':main()
