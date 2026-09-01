"""Isolation d'objets depuis le rendu Metano, avec bbox en cellules*8.
Chroma-key du fond de sol, nettoyage morphologique, upscale PMDO (x3)."""
import json, os
import numpy as np
from PIL import Image
from scipy import ndimage

mt = Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a = np.asarray(mt).astype(np.int32)
H,W,_ = a.shape
S=3
OUT='CONVERSION_WS/tilesets'; os.makedirs(OUT,exist_ok=True)

def isolate(cx0,cy0,cw,ch,name,pad=2,thresh=48):
    # cell->pixel source coords (8px/cell) with padding
    x0=(cx0-2)*8; y0=(cy0-2)*8
    x1=(cx0+cw+1)*8; y1=(cy0+ch+1)*8
    x0=max(0,x0); y0=max(0,y0); x1=min(W-1,x1); y1=min(H-1,y1)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    bgmask=(G>200)&(R>190)&(B<150)|((R>235)&(G>205)&(B>130)&(B<205)&((G-B)>40))
    if bgmask.sum()<30:
        bgmask=np.zeros_like(bgmask); bgmask[:4,:4]=True;bgmask[:4,-4:]=True;bgmask[-4:,:4]=True;bgmask[-4:,-4:]=True
    bg_mean=reg[bgmask].mean(0)
    dist=np.abs(reg-np.array(bg_mean)).max(axis=2)
    fg=dist>thresh
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    lab,n=ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=np.where(fg,255,0).astype(np.uint8)
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bbox=im.getchannel('A').getbbox()
    if bbox: im=im.crop(bbox)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    print(f"  {name}: src={x1-x0+1}x{y1-y0+1} sprite={im2.size} bg={tuple(int(v) for v in bg_mean)}")

buildings=json.load(open('/tmp/mt_buildings.json'))
sel=[i for i,b in enumerate(buildings) if 30<=b['n']<=200 and b['w']<=20 and b['h']<=20 and b['green_ratio']<0.5]
print("isolating", len(sel), "buildings from render Metano...")
atlas=[]
for k,i in enumerate(sel):
    b=buildings[i]
    cx,cy=b['at']; cw,ch=b['w'],b['h']
    name=f"building_{k:02d}_{cw}x{ch}"
    isolate(cx,cy,cw,ch,name)
