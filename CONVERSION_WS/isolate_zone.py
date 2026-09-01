"""Isole des objets ponctuels dans une zone par composante connexe, en
choisissant la composante dont le centre est le plus proche d'un point cible."""
import os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32); H,W,_=a.shape
for f in glob.glob(f'{OUT}/totem_*.png')+glob.glob(f'{OUT}/sign2_*.png'):
    os.remove(f)

def bgmask(reg):
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    return (G>200)&(R>185)&(B<150)&((G-B)>55) | ((R>230)&(G>205)&(B>130)&(B<205)&((G-B)>35)) | ((G>195)&(R>180)&(R<235)&(B<150))

def isolate_zone(x0,y0,x1,y1,cx,cy,name,dist_thresh=34,ramp=28):
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    bm=reg[bgmask(reg)].mean(0) if bgmask(reg).sum()>30 else reg.mean(0)
    dist=np.abs(reg-np.array(bm)).max(axis=2)
    al=np.clip((dist-dist_thresh)/float(ramp),0,1)
    al=ndimage.median_filter(al,size=3)
    fg=al>0.2
    fg=ndimage.binary_closing(fg,structure=np.ones((2,2)))
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    # pick component nearest to (cx,cy) in zone-local coords
    lab,n=ndimage.label(fg)
    if n<1: 
        print("  no comp",name); return None
    centers=ndimage.center_of_mass(fg,lab,range(1,n+1))
    lx,ly=cx-x0,cy-y0
    best=min(range(n), key=lambda i:(centers[i][1]-lx)**2+(centers[i][0]-ly)**2)
    comp=lab==best+1
    alpha=(al*255).astype(np.uint8); alpha[~comp]=0
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png'); print(f"  {name}: {im2.size} (comp {best+1}/{n})")
    return im2

# zones cibles (px) + centre approximatif de l'objet
targets=[
  ("totem_violet", 980,1000,1120,1160, 1040,1090),
  ("totem_orange_boss", 1120,1040,1270,1200, 1180,1110),
  ("totem_stone", 1150,830,1240,950, 1190,890),
  ("kiosk_teal", 1080,610,1200,730, 1130,670),
  ("sign_yellow", 380,940,430,995, 405,965),
]
print("Isolation ciblée par composante:")
for name,x0,y0,x1,y1,cx,cy in targets:
    try:
        isolate_zone(x0,y0,x1,y1,cx,cy,name)
    except Exception as e:
        print("  ERR",name,e)
