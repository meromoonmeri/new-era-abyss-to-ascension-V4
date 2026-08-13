#!/usr/bin/env python3
"""Asset discovery, visual semantics inference and compatibility clustering."""
from __future__ import annotations
import hashlib,json,math,re,struct,sys,tempfile
from collections import Counter,defaultdict
from pathlib import Path
from statistics import mean
from typing import Any
TOOLS=Path(__file__).resolve().parents[2]/"external/BIBLIOTHEQUE_WORKSPACE/tools"
if str(TOOLS) not in sys.path:sys.path.insert(0,str(TOOLS))
from png_rgba import load_png
from .model import AssetProfile
ROLE_WORDS={
 "floor":{"floor","ground","sol","path","road","grass","sand","snow","carpet","plank","tile"},
 "wall":{"wall","mur","cliff","rock","block","pillar","fence","barrier","hedge"},
 "border":{"edge","border","rim","shore","coast","corner","front","ledge"},
 "structure":{"house","door","gate","bridge","stairs","tower","altar","ruin","temple"},
 "decoration":{"deco","flower","plant","bush","mushroom","web","banner","statue","torch"},
 "hazard":{"lava","poison","spike","trap","fire","abyss","void","toxic"},
 "water":{"water","river","sea","ocean","lake","pond","rain","ice"},
 "transition":{"transition","fade","portal","wormhole","entrance","exit"},
 "focal":{"boss","legend","altar","crystal","throne","monument","giant","guardian"}}
STOP={"base","layer","tileset","tile","town","map","the","and","front","back","new"}
def tokens(text:str)->set[str]:return {x for x in re.findall(r"[a-z0-9]+",text.casefold()) if len(x)>1 and x not in STOP}
def _tile_entries(path:Path):
 data=path.read_bytes();
 if len(data)<8:return 0,[]
 size,count=struct.unpack_from('<II',data,0);rows=[]
 if 8+count*16>len(data):return size,[]
 for i in range(count):
  key,off=struct.unpack_from('<QQ',data,8+i*16)
  if off+8>len(data):continue
  length=struct.unpack_from('<Q',data,off)[0]
  if off+8+length<=len(data):rows.append((key,data[off+8:off+8+length]))
 return size,rows
def _image_metrics(payloads:list[bytes],temp:Path):
 colors=Counter();alpha=edges=samples=sym=sym_total=0;lumas=[];sats=[]
 for raw in payloads:
  h=hashlib.sha256(raw).hexdigest();p=temp/f"{h}.png"
  if not p.exists():p.write_bytes(raw)
  try:im=load_png(p)
  except Exception:continue
  step=max(1,min(im.width,im.height)//8)
  for y in range(0,im.height,step):
   for x in range(0,im.width,step):
    i=(y*im.width+x)*4;r,g,b,a=im.pixels[i:i+4];samples+=1;alpha+=a>24
    if a>24:
     qr,qg,qb=r//24*24,g//24*24,b//24*24;colors[(qr,qg,qb)]+=1
     mx,mn=max(r,g,b),min(r,g,b);lumas.append((r*299+g*587+b*114)/255000);sats.append(0 if mx==0 else (mx-mn)/mx)
    if x+step<im.width:
     j=(y*im.width+min(im.width-1,x+step))*4;edges+=sum(abs(im.pixels[i+c]-im.pixels[j+c]) for c in range(3))>90
    j=(y*im.width+(im.width-1-x))*4;sym_total+=1;sym+=sum(abs(im.pixels[i+c]-im.pixels[j+c]) for c in range(4))<80
 if not samples:return [0,0,0],0,0,0,0,0
 dominant=list(colors.most_common(1)[0][0] if colors else (0,0,0));detail=min(1,len(colors)/48+(edges/samples)*.7)
 return dominant,mean(lumas) if lumas else 0,mean(sats) if sats else 0,alpha/samples,min(1,edges/samples*2),detail,sym/max(1,sym_total)
def _role_scores(name:str,alpha:float,edge:float,detail:float,usage:float|None):
 ts=tokens(name);scores={k:.05 for k in ROLE_WORDS}
 for role,words in ROLE_WORDS.items():scores[role]+=min(.75,.24*len(ts&words))
 scores['floor']+=max(0,.25-detail*.2)+(0 if usage is None else (1-usage)*.35)
 scores['wall']+=edge*.25+(0 if usage is None else usage*.5)
 scores['decoration']+=(1-alpha)*.35+detail*.22;scores['focal']+=detail*.3+max(0,.2-alpha*.1)
 scores['border']+=edge*.18+(1-alpha)*.15
 total=sum(scores.values());return {k:round(v/total,4) for k,v in scores.items()}
def _usage_by_sheet(grounds:list[Path],limit:int):
 hits=defaultdict(lambda:[0,0])
 for path in sorted(grounds,key=lambda p:p.stat().st_size)[:limit]:
  try:o=json.loads(path.read_text(encoding='utf-8-sig'))['Object'];obs=o.get('obstacles',[]);tex=max(1,int(o.get('TexSize',1)))
  except Exception:continue
  for layer in o.get('Layers',[]):
   cols=layer.get('Tiles',[])
   for x,col in enumerate(cols):
    for y,cell in enumerate(col):
     blocked=False
     for ox in range(x*tex,min(len(obs),(x+1)*tex)):
      if any(obs[ox][oy].get('Tags',0)!=0 for oy in range(y*tex,min(len(obs[ox]),(y+1)*tex))):blocked=True
     sheets={f.get('Sheet','') for tl in cell.get('Layers',[]) for f in tl.get('Frames',[]) if f.get('Sheet')}
     for s in sheets:hits[s][0]+=1;hits[s][1]+=blocked
 return {k:v[1]/v[0] for k,v in hits.items() if v[0]}
def _overrides(path:Path|None):
 if not path or not path.exists():return {}
 d=json.loads(path.read_text());return d.get('assets',d)
def _vector(a:AssetProfile):return [a.dominant_rgb[0]/255,a.dominant_rgb[1]/255,a.dominant_rgb[2]/255,a.mean_luma,a.mean_saturation,a.alpha_coverage,a.edge_density,a.detail_score]
def _distance(a:AssetProfile,b:AssetProfile):
 va,vb=_vector(a),_vector(b);visual=math.sqrt(sum((x-y)**2 for x,y in zip(va,vb))/len(va));ta,tb=tokens(a.asset_id),tokens(b.asset_id);lex=1-len(ta&tb)/max(1,len(ta|tb));size=0 if a.tile_size==b.tile_size or not a.tile_size or not b.tile_size else 1
 return .58*visual+.30*lex+.12*size
def analyze_library(repo:Path,output:Path,overrides:Path|None=None,max_sheets:int=0,max_grounds:int=96,samples_per_sheet:int=24):
 repo=repo.resolve();tile_paths=sorted((repo/'Content/Tile').glob('*.tile'));tile_paths=tile_paths[:max_sheets or None];usage=_usage_by_sheet(list((repo/'Data/Ground').glob('*.rsground')),max_grounds);profiles=[];manual=_overrides(overrides)
 with tempfile.TemporaryDirectory() as td:
  temp=Path(td)
  for path in tile_paths:
   size,entries=_tile_entries(path);stride=max(1,len(entries)//max(1,samples_per_sheet));raw=[x[1] for x in entries[::stride][:samples_per_sheet]];dom,lum,sat,alpha,edge,detail,sym=_image_metrics(raw,temp);blocked=usage.get(path.stem);roles=_role_scores(path.stem,alpha,edge,detail,blocked);tags=sorted({r for r,w in ROLE_WORDS.items() if tokens(path.stem)&w});rarity=max(0.05,min(.98,.25+detail*.45+(1-alpha)*.2));p=AssetProfile(path.stem,path.relative_to(repo).as_posix(),'ground_tile_sheet',size,len(raw),dom,lum,sat,alpha,edge,detail,sym,blocked,roles,tags,rarity,confidence=min(.98,.35+len(tags)*.12+len(raw)/100));ov=manual.get(path.stem)
   if ov:
    if 'role' in ov:p.role_scores={k:(1.0 if k==ov['role'] else 0.0) for k in ROLE_WORDS}
    p.tags=sorted(set(p.tags+ov.get('tags',[])));p.rarity=float(ov.get('rarity',p.rarity));p.overridden=True
   profiles.append(p)
 # Native dungeon texture bundles are first-class visual vocabulary.
 bundles={}
 def walk(v):
  if isinstance(v,dict):
   if 'GroundTileset' in v and 'BlockTileset' in v:
    key='|'.join(str(v.get(x,'')) for x in ('GroundTileset','BlockTileset','WaterTileset'));bundles[key]=[v.get('GroundTileset',''),v.get('BlockTileset',''),v.get('WaterTileset','')]
   for q in v.values():walk(q)
  elif isinstance(v,list):
   for q in v:walk(q)
 for path in (repo/'Data/Zone').glob('*.json'):
  try:walk(json.loads(path.read_text(encoding='utf-8-sig')))
  except:pass
 for key,vals in sorted(bundles.items()):
  aid='dungeon_texture:'+key;ts=tokens(key);roles={k:.02 for k in ROLE_WORDS};roles['floor']=roles['wall']=.42;tags=sorted({r for r,w in ROLE_WORDS.items() if ts&w});profiles.append(AssetProfile(aid,'Data/Zone/*.json','dungeon_texture_bundle',24,3,[96,96,96],.45,.25,1,.45,.4,.5,None,roles,tags,.35,confidence=.92))
 # Compatibility graph and conservative visual clusters.
 for p in profiles:
  candidates=sorted(((_distance(p,q),q.asset_id) for q in profiles if q is not p and q.kind==p.kind),key=lambda x:x[0])[:12];p.compatible=[{'asset_id':x,'score':round(max(0,1-d),4)} for d,x in candidates if d<.72]
 unseen=set(x.asset_id for x in profiles);cluster=0
 while unseen:
  root=min(unseen);front=[root];members=[];unseen.remove(root)
  while front:
   cur=front.pop();members.append(cur);p=next(x for x in profiles if x.asset_id==cur)
   for q in p.compatible[:5]:
    if q['score']>=.62 and q['asset_id'] in unseen:unseen.remove(q['asset_id']);front.append(q['asset_id'])
  cid=f'visual_cluster_{cluster:03d}';cluster+=1
  for x in profiles:
   if x.asset_id in members:x.cluster_id=cid
 override_ref=None
 if overrides:
  try:override_ref=overrides.resolve().relative_to(output.parent.resolve()).as_posix()
  except ValueError:override_ref=str(overrides)
 payload={'schema_version':'1.0.0','result':'ASSET_SEMANTIC_ANALYSIS_PASS','asset_count':len(profiles),'ground_sheet_count':sum(x.kind=='ground_tile_sheet' for x in profiles),'dungeon_texture_bundle_count':sum(x.kind=='dungeon_texture_bundle' for x in profiles),'cluster_count':cluster,'override_file':override_ref,'assets':[x.to_dict() for x in profiles]};output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(payload,ensure_ascii=False,indent=2));return payload
