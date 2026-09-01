import os, glob
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32); H,W,_=a.shape
for f in glob.glob(f'{OUT}/obj_*.png'):
    os.remove(f)

def isolate_px(x0,y0,x1,y1,name,dist_thresh=34,ramp=28,keep='largest'):
    x0=max(0,x0);y0=max(0,y0);x1=min(W-1,x1);y1=min(H-1,y1)
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
    if n>1 and keep=='largest':
        sizes=ndimage.sum(fg,lab,range(1,n+1)); fg=lab==(np.argmax(sizes)+1)
    alpha=(al*255).astype(np.uint8); alpha[~fg]=0
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),alpha]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png'); return im2

# bbox en PIXELS dans le rendu 1512x1512 (repérés visuellement)
named = {
  "obj_statue_celebi": (620,690,790,880),       # arbre Célébi (totem vert)
  "obj_totem_violet": (960,1010,1080,1150),     # totem à face violette
  "obj_totem_orange_boss": (1140,1030,1270,1180),# statue orange/boss
  "obj_sign_kecleon_enclos_n": (600,175,650,230),# panneau-enclos vertical nord
  "obj_sign_kecleon_enclos_e": (730,250,785,300),# panneau-enclos est
  "obj_sign_yellow": (378,940,428,995),         # panneau jaune indicateur
  "obj_kiosk_teal": (1080,630,1180,720),        # kiosque bleu-vert
  "obj_shop_red": (1000,470,1140,560),          # boutique rouge nord
  "obj_statue_island": (520,290,600,360),       # statue île (verte)
  "obj_totem_stone": (1150,850,1230,960),       # totem pierre (pierre tombale)
  "obj_statue_gold": (520,780,560,830),         # petite statue dorée
}
print("Named objects isolation:")
for name,(x0,y0,x1,y1) in named.items():
    try:
        im=isolate_px(x0,y0,x1,y1,name); print(f"  {name}: {im.size}")
    except Exception as e:
        print("  ERR",name,e)
