#!/usr/bin/env python3
from PIL import Image
import json,io,struct,copy,math
from pathlib import Path
R=Path(__file__).resolve().parents[1];SRC=Path('/home/user/uploads/image.png');ASSET='terapagos_crystal_sanctuary';SHEET='TerapagosCrystalSanctuary_Base'
im=Image.open(SRC).convert('RGBA');W0,H0=im.size;W=(W0+7)//8;H=(H0+7)//8
pad=Image.new('RGBA',(W*8,H*8),(0,0,0,0));pad.alpha_composite(im,(0,0))
# unique source tiles
idx={};pngs=[];positions=[]
for y in range(H):
 row=[]
 for x in range(W):
  t=pad.crop((x*8,y*8,x*8+8,y*8+8));k=t.tobytes()
  if k not in idx:
   idx[k]=len(pngs);b=io.BytesIO();t.save(b,'PNG',optimize=True);pngs.append(b.getvalue())
  row.append(idx[k])
 positions.append(row)
pwidth=max(W,int(len(pngs)**.5)+1);entries=[]
for y in range(H):
 for x in range(W):
  n=positions[y][x];entries.append((x|(y<<32),pngs[n]))
entries.sort();head=8+16*len(entries);offsets={};pos=head
for _,p in entries:
 if p not in offsets:offsets[p]=pos;pos+=8+len(p)
out=bytearray(struct.pack('<II',8,len(entries)))
for k,p in entries:out+=struct.pack('<QQ',k,offsets[p])
for p,off in sorted(offsets.items(),key=lambda q:q[1]):out+=struct.pack('<Q',len(p))+p
(R/f'Content/Tile/{SHEET}.tile').write_bytes(out)
# ground from proven schema
t= json.load(open(R/'Data/Ground/cloven_ruins_entrance.rsground',encoding='utf-8-sig'));o=t['Object'];o['Name']={'DefaultText':'Terapagos Crystal Sanctuary','LocalTexts':{'fr':'Sanctuaire Cristallin de Terapagos'}};o['Released']=True;o['Comment']='Custom user-authored sanctuary image imported without resampling; padded 2px right/bottom to 8px grid. Explicit authored collision geometry.';o['AssetName']=ASSET;o['Music']='Crystal Cave.ogg';o['Decorations']=[]
cell=lambda x,y:{'AutoTileset':'','Associates':[],'Layers':[{'Frames':[{'Sheet':SHEET,'TexLoc':{'X':x,'Y':y}}],'FrameLength':60}],'NeighborCode':-1}
o['Layers']=[{'Name':'Canonical Custom Artwork','Layer':0,'Visible':True,'Tiles':[[cell(x,y) for y in range(H)] for x in range(W)]}]
def walk(px,py):
 # central dais + entrance staircase/corridor; all other crystals/void solid
 arena=((px-323)/230)**2+((py-320)/155)**2<=1
 corridor=270<=px<=398 and 345<=py<=557
 return arena or corridor
o['obstacles']=[[{'Bounds':{'X':x*8,'Y':y*8,'Width':8,'Height':8},'Tags':0 if walk(x*8+4,y*8+4) else 1} for y in range(H)] for x in range(W)]
layer={'Name':'Staging','Visible':True,'MapChars':[],'GroundObjects':[],'Spawners':[],'Markers':[]}
def marker(n,x,y,d=4):return {'EntName':n,'Direction':d,'EntEnabled':True,'EntOrder':0,'InteractOrder':0,'triggerType':0,'Collider':{'X':x,'Y':y,'Width':16,'Height':16}}
layer['Markers']=[marker('Main_Entrance_Marker',292,520,4),marker('Partner_Entrance_Marker',358,520,4),marker('Hero_Final_Marker',299,389,4),marker('Partner_Final_Marker',352,389,4),marker('Terapagos_Marker',325,302,0),marker('Camera_Marker',325,342,0)]
# ally spawners copied exactly from valid schema
sp=json.load(open(R/'Data/Ground/a02p01.rsground',encoding='utf-8-sig'))['Object']['Entities'][0]['Spawners'][0]
for i,(x,y) in enumerate([(358,520),(374,536),(276,536)],1):
 s=copy.deepcopy(sp);s['NPCName']='Teammate'+str(i);s['EntName']='TEAMMATE_'+str(i);s['Collider']={'X':x,'Y':y,'Width':16,'Height':16};layer['Spawners'].append(s)
o['Entities']=[layer];o['ViewCenter']={'X':325,'Y':342};o['ViewOffset']={'X':0,'Y':0};o['ActiveChar']=''
json.dump(t,open(R/f'Data/Ground/{ASSET}.rsground','w'),ensure_ascii=False,indent=2);open(R/f'Data/Ground/{ASSET}.rsground','a').write('\n')
print(ASSET,W,H,len(pngs))
