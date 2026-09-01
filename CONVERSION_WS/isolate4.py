"""Isole les 4 structures de la carte (montage source) en alpha à l'échelle PMDO (x3)."""
import os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
a=np.asarray(src).astype(np.int32); H,W,_=a.shape

def bgmask(reg):
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    # grass ~ (208,216,88), sand ~ (228,217,116) and blends; tol generous
    return (G>195)&((G-B)>45) | ((R>215)&(G>195)&(B>110)&(B<210)&((G-B)>25))

def isolate(x0,y0,x1,y1,name,dist_thresh=42,ramp=30):
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    bm=bgmask(reg)
    if bm.sum()<25:
        bm=np.zeros_like(reg[:,:,0],bool); bm[:3,:3]=bm[:3,-3:]=bm[-3:,:3]=bm[-3:,-3:]=True
    bcolor=reg[bm].mean(0)
    dist=np.abs(reg-bcolor).max(axis=2)
    al=np.clip((dist-dist_thresh)/float(ramp),0,1)
    al=ndimage.median_filter(al,size=3)
    fg=al>0.18
    fg=ndimage.binary_closing(fg,structure=np.ones((3,3)))
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    lab,n=ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1))
        fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8); alpha[~fg]=0
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png'); return im2

# Final bboxes (source px), refined with a margin
targets={
 "shop_awning_railstall":(132,26,255,120),
 "statue_bluewing_x":(430,38,515,115),
 "house_bearhead_redmat":(140,420,245,545),
 "totem_teal_boss":(470,478,575,600),
}
print("Isolation des 4 structures:")
for name,(x0,y0,x1,y1) in targets.items():
    im=isolate(x0,y0,x1,y1,name)
    print(f"  {name}: {im.size}")
