"""Isoler des ARBRES complets (canopée+tronc) depuis les composites Metano.
Pour chaque composante canopée, on rend la cellule + les cellules voisines
plus basses (tronc), puis chroma-key de l'herbe de base."""
import json, os, glob
import numpy as np
from PIL import Image
from scipy import ndimage

DB=json.load(open('/tmp/mt_db.json'))
W0,H0=DB['W'],DB['H']; G=DB['grid']; COLL=DB['coll']; INFO=DB['info']
S=3
OUT='CONVERSION_WS/tilesets'
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32); H,W,_=a.shape

def cell_px(cx,cy):
    # 8px cell from the render
    x0=cx*8; y0=cy*8
    return a[y0:y0+8, x0:x0+8]

def isolate_tree(o, name, pad_bottom=3, dist_thresh=30, ramp=25):
    cx,cy=o['at']; cw,ch=o['w'],o['h']
    # region: canopy bbox + extra rows at bottom for trunk, small pad all around
    x0=max(0,(cx-1)*8); y0=max(0,(cy-1)*8)
    x1=min(W-1,(cx+cw+1)*8); y1=min(H-1,(cy+ch+pad_bottom)*8)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    # grass base / pale green / sand
    bg=(G>200)&(R>185)&(B<150)&((G-B)>55) | ((R>230)&(G>205)&(B>130)&(B<205)&((G-B)>35)) | ((G>195)&(R>180)&(R<235)&(B<150))
    if bg.sum()<30:
        bg=np.zeros_like(bg); bg[:4,:4]=True;bg[:4,-4:]=True;bg[-4:,:4]=True;bg[-4:,-4:]=True
    bm=reg[bg].mean(0)
    dist=np.abs(reg-np.array(bm)).max(axis=2)
    al=np.clip((dist-dist_thresh)/float(ramp),0,1)
    al=ndimage.median_filter(al,size=3)
    fg=al>0.2
    fg=ndimage.binary_closing(fg,structure=np.ones((2,2)))
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    lab,n=ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8); alpha[~fg]=0
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    return im2

trees=json.load(open('/tmp/mt_trees.json'))
# dedupe + pick a representative subset (variety of sizes), avoid huge forest walls
seen=set(); sel=[]
for o in trees:
    k=tuple(o['at']); 
    if k in seen: continue
    seen.add(k)
    if o['n']<=80:   # single/paired trees, not forest walls
        sel.append(o)
sel=sel[:36]
print("trees to isolate:",len(sel))
for k,o in enumerate(sel):
    name=f"tree_{k:02d}_{o['w']}x{o['h']}"
    try:
        im=isolate_tree(o,name)
        print(f"  {name}: {im.size}")
    except Exception as e:
        print("  ERR",name,e)
