"""Isolation finale : sprites alpha PMDO (scale x3) des objets Metano.
Familles : arbres, panneaux, totems/statues, bâtiments. Depuis le rendu
Metano net, chroma-key du fond de sol + marge d'alpha par distance
(anti-liseré), nettoyage morphologique, rognage, upscale PMDO.
"""
import json, os, glob
import numpy as np
from PIL import Image
from scipy import ndimage

mt = Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a = np.asarray(mt).astype(np.int32)
H,W,_ = a.shape
S=3
OUT='CONVERSION_WS/tilesets'
os.makedirs(OUT,exist_ok=True)
# clean old sprites
for f in glob.glob(f'{OUT}/building_*.png')+glob.glob(f'{OUT}/atlas_*.png'):
    os.remove(f)

buildings=json.load(open('/tmp/mt_buildings.json'))

def isolate_cells(cx,cy,cw,ch,name,pad=2,thresh=40,margin=0.55):
    x0=max(0,(cx-pad)*8); y0=max(0,(cy-pad)*8)
    x1=min(W-1,(cx+cw+pad)*8); y1=min(H-1,(cy+ch+pad)*8)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    bg=(G>195)&(R>185)&(B<155)|((R>235)&(G>205)&(B>130)&(B<205)&((G-B)>40))|((G>185)&(B<120)&(R>190))
    if bg.sum()<30:
        bg=np.zeros_like(bg);bg[:4,:4]=True;bg[:4,-4:]=True;bg[-4:,:4]=True;bg[-4:,-4:]=True
    bm=reg[bg].mean(0)
    dist=np.abs(reg-np.array(bm)).max(axis=2)
    # soft alpha ramp: 0 below thresh, ramps to 1 over ~20 units
    al=np.clip((dist-thresh)/20.0,0,1)
    al=ndimage.median_filter(al,size=3)
    fg=al>0.15
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    # keep largest connected object
    lab,n=ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8)
    alpha[~fg]=0
    rgba=np.dstack([reg.astype(np.uint8),alpha])
    im=Image.fromarray(rgba,'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    return im2, (x1-x0+1)*(y1-y0+1)

# --- BÂTIMENTS (depuis mt_buildings) ---
sel=[i for i,b in enumerate(buildings) if 30<=b['n']<=200 and b['w']<=20 and b['h']<=20 and b['green_ratio']<0.5]
print("buildings:",len(sel))
for k,i in enumerate(sel):
    b=buildings[i]; cx,cy=b['at']; cw,ch=b['w'],b['h']
    name=f"building_{k:02d}_{cw}x{ch}"
    im,src=isolate_cells(cx,cy,cw,ch,name)
    print(f"  {name}: {im.size}")
