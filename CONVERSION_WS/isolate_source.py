"""Isole des objets ponctuels depuis la SOURCE du montage (chroma-key).
La source est re-encodée (bruit léger) -> seuil tolérant + ouverture."""
import os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
a=np.asarray(src).astype(np.int32); H,W,_=a.shape
for f in glob.glob(f'{OUT}/src_*.png'):
    os.remove(f)

def isolate_px(x0,y0,x1,y1,name,dist_thresh=40,ramp=30):
    x0=max(0,x0);y0=max(0,y0);x1=min(W-1,x1);y1=min(H-1,y1)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    bg=(G>200)&(R>185)&(B<150)&((G-B)>55) | ((R>230)&(G>205)&(B>130)&(B<205)&((G-B)>35)) | ((G>195)&(R>180)&(R<235)&(B<150))
    if bg.sum()<30:
        bg=np.zeros_like(bg); bg[:4,:4]=True;bg[:4,-4:]=True;bg[-4:,:4]=True;bg[-4:,-4:]=True
    bm=reg[bg].mean(0)
    dist=np.abs(reg-np.array(bm)).max(axis=2)
    al=np.clip((dist-dist_thresh)/float(ramp),0,1)
    fg=al>0.2
    # keep largest component (object)
    lab,n=ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8); alpha[~fg]=0
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png'); return im2

targets={
  "src_totem_purple_face":(585,240,700,340),
  "src_statue_blue_wing":(425,42,510,120),
  "src_statue_volt":(510,545,590,640),
  "src_kiosk_hat":(300,320,360,400),
  "src_sign_tree":(60,180,120,250),
  "src_statue_smurf":(178,268,245,350),
  "src_sign_wood":(330,470,375,510),
  "src_kecleon_sign":(100,255,150,300),
}
print("Isolation depuis la source:")
for name,(x0,y0,x1,y1) in targets.items():
    try:
        im=isolate_px(x0,y0,x1,y1,name); print(f"  {name}: {im.size}")
    except Exception as e:
        print("  ERR",name,e)
