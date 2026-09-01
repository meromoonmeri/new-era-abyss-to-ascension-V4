import json, os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32); H,W,_=a.shape
for f in glob.glob(f'{OUT}/sign_*.png')+glob.glob(f'{OUT}/_atlas_signs.png'):
    os.remove(f)

def isolate(o,name,pad=2,dist_thresh=34,ramp=28):
    cx,cy=o['at']; cw,ch=o['w'],o['h']
    x0=max(0,(cx-pad)*8); y0=max(0,(cy-pad)*8)
    x1=min(W-1,(cx+cw+pad)*8); y1=min(H-1,(cy+ch+pad)*8)
    reg=a[y0:y1+1,x0:x1+1].astype(np.float64)
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
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
    im2.save(f'{OUT}/{name}.png'); return im2

signs=json.load(open('/tmp/mt_signs.json'))
print("signs/totems:",len(signs))
for k,o in enumerate(signs):
    name=f"sign_{k:02d}_{o['w']}x{o['h']}"
    try:
        im=isolate(o,name); print(f"  {name}: {im.size}")
    except Exception as e:
        print("  ERR",name,e)
