"""Isoler arbres/buissons en alpha PMDO. Chroma-key ciblant l'herbe de base
(vert clair ~200,216,80) : l'arbre (vert foncé ~ (55,102,31)) reste."""
import json, os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32); H,W,_=a.shape

def isolate_cells(cx,cy,cw,ch,name,pad=3,dist_thresh=28,ramp=25,keep='largest'):
    x0=max(0,(cx-pad)*8); y0=max(0,(cy-pad)*8)
    x1=min(W-1,(cx+cw+pad)*8); y1=min(H-1,(cy+ch+pad)*8)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    # background colors: sample the ring (outside the tree cell bbox)
    # Use pixels that are light grass (high G, low B, R<230) but NOT dark green tree
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    # grass base / ground / sand
    bg=(G>200)&(R>185)&(B<150)&((G-B)>55) | ((R>230)&(G>205)&(B>130)&(B<205)&((G-B)>35)) | ((G>195)&(R>190)&(R<230)&(B<145))
    if bg.sum()<30:
        bg=np.zeros_like(bg); bg[:4,:4]=True;bg[:4,-4:]=True;bg[-4:,:4]=True;bg[-4:,-4:]=True
    bm=reg[bg].mean(0)
    dist=np.abs(reg-np.array(bm)).max(axis=2)
    al=np.clip((dist-dist_thresh)/float(ramp),0,1)
    al=ndimage.median_filter(al,size=3)
    fg=al>0.2
    fg=ndimage.binary_closing(fg,structure=np.ones((2,2)))
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    if keep=='largest':
        lab,n=ndimage.label(fg)
        if n>1:
            sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8); alpha[~fg]=0
    rgba=np.dstack([reg.astype(np.uint8),alpha])
    im=Image.fromarray(rgba,'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    return im2

trees=json.load(open('/tmp/mt_trees.json'))
# dedupe by at
seen=set(); sel=[]
for o in trees:
    k=tuple(o['at'])
    if k in seen: continue
    seen.add(k); sel.append(o)
print("trees:",len(sel))
for k,o in enumerate(sel):
    cx,cy=o['at']; cw,ch=o['w'],o['h']
    name=f"tree_{k:02d}_{cw}x{ch}"
    try:
        im=isolate_cells(cx,cy,cw,ch,name)
        print(f"  {name}: {im.size}")
    except Exception as e:
        print("  ERR", name, e)
