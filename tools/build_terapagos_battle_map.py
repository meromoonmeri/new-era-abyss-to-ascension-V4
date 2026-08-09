#!/usr/bin/env python3
from PIL import Image
from pathlib import Path
import json,struct,io,copy
R=Path(__file__).resolve().parents[1];SRC=Path('/home/user/uploads/image.png');SHEET='TerapagosCrystalSanctuaryBattle_Base';MAP=R/'Data/Map/crystal_sanctuary_boss.rsmap'
im=Image.open(SRC).convert('RGBA');W=(im.width+23)//24;H=(im.height+23)//24;pad=Image.new('RGBA',(W*24,H*24),(0,0,0,255));pad.alpha_composite(im)
# tile file, one key per map cell with deduplicated PNG payloads
entries=[]
for y in range(H):
 for x in range(W):
  t=pad.crop((x*24,y*24,x*24+24,y*24+24));b=io.BytesIO();t.save(b,'PNG',optimize=True);entries.append((x|(y<<32),b.getvalue()))
head=8+16*len(entries);offs={};pos=head
for _,p in entries:
 if p not in offs:offs[p]=pos;pos+=8+len(p)
out=bytearray(struct.pack('<II',24,len(entries)))
for k,p in entries:out+=struct.pack('<QQ',k,offs[p])
for p,o in sorted(offs.items(),key=lambda q:q[1]):out+=struct.pack('<Q',len(p))+p
(R/f'Content/Tile/{SHEET}.tile').write_bytes(out)
# mapped battle floor
d=json.load(open(MAP,encoding='utf-8-sig'));o=d['Object'];old=o['Tiles'];floor=next(t for c in old for t in c if t['Data']['ID']=='floor');wall=next(t for c in old for t in c if t['Data']['ID']!='floor')
def walk(px,py):return ((px-323)/230)**2+((py-320)/155)**2<=1 or (270<=px<=398 and 345<=py<=575)
def vis(x,y):return {'AutoTileset':'','Associates':[],'Layers':[{'Frames':[{'Sheet':SHEET,'TexLoc':{'X':x,'Y':y}}],'FrameLength':60}],'NeighborCode':-1}
o['Layers']=[{'Name':'Terapagos Sanctuary Artwork','Layer':0,'Visible':True,'Tiles':[[vis(x,y) for y in range(H)] for x in range(W)]}]
o['Tiles']=[]
for x in range(W):
 col=[]
 for y in range(H):
  t=copy.deepcopy(floor if walk(x*24+12,y*24+12) else wall);t['Effect']['TileLoc']={'X':x,'Y':y};col.append(t)
 o['Tiles'].append(col)
o['DiscoveryArray']=[[0 for y in range(H)] for x in range(W)];o['EntryPoints']=[{'Loc':{'X':12,'Y':22},'Dir':4},{'Loc':{'X':15,'Y':22},'Dir':4}];o['ViewCenter']={'X':13*24+12,'Y':14*24+12};o['Music']='Crystal Cave.ogg';o['Comment']='User-authored Terapagos sanctuary used identically for Ground cinematic and mapped boss battle; 24px native dungeon grid, no resampling.'
for team in o['MapTeams']:
 for m in team['Players']:m['serializationLoc']={'X':13,'Y':12};m['serializationDir']=0
# safe relative party formation
a=o['MapEffect'].get('OnMapStarts',[])
for ev in a:
 if 'BattlePositionEvent' in ev['Value'].get('$type',''):
  ev['Value']['StartLocs']=[{'Loc':{'X':0,'Y':0},'Dir':4},{'Loc':{'X':-1,'Y':1},'Dir':4},{'Loc':{'X':1,'Y':1},'Dir':4},{'Loc':{'X':0,'Y':2},'Dir':4}];ev['Value']['Positions']=None
json.dump(d,open(MAP,'w'),ensure_ascii=False,indent=2);open(MAP,'a').write('\n');print(W,H,len(entries),len(offs))
