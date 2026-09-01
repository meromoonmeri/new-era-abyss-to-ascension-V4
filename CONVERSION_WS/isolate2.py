"""Isolation d'objets complets depuis le rendu Metano avec chroma-key.

Méthode : pour un bbox d'objet connu, on échantillonne la couleur de
fond de sol autour de l'objet (bande extérieure), puis on rend transparent
tout pixel dont la couleur est proche du fond (seuil de distance), en
conservant l'objet. On nettoie morphologiquement.
"""
import json, os
import numpy as np
from PIL import Image
from scipy import ndimage

mt = Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a = np.asarray(mt).astype(np.int32)
H,W,_ = a.shape
S=3  # PMDO scale (24px/cellule)

OUT='CONVERSION_WS/tilesets'
os.makedirs(OUT,exist_ok=True)

def color_dist(px, c):
    return np.abs(px - np.array(c)).max(axis=2)

def isolate_bbox(x0,y0,x1,y1,name,thresh=45,pad=6):
    x0=max(0,x0-pad); y0=max(0,y0-pad); x1=min(W-1,x1+pad); y1=min(H-1,y1+pad)
    reg = a[y0:y1+1, x0:x1+1].astype(np.float64)
    # sample background: colors in a ring around bbox
    # use pixels that are grass/sand (background) inside the ring
    R,G,B = reg[:,:,0],reg[:,:,1],reg[:,:,2]
    bgmask = (G>200)&(R>190)&(B<150) | ((R>235)&(G>205)&(B>130)&(B<205)&((G-B)>40))
    # also dark forest green can be bg if the object is a tree over forest? keep.
    if bgmask.sum()<30:
        # fallback: corners
        bgmask = np.zeros_like(bgmask); bgmask[:3,:3]=True; bgmask[:3,-3:]=True; bgmask[-3:,:3]=True; bgmask[-3:,-3:]=True
    bg_colors = reg[bgmask]
    bg_mean = bg_colors.mean(0)
    dist = color_dist(reg, bg_mean)
    alpha = np.where(dist>thresh, 255, 0).astype(np.uint8)
    # remove tiny isolated fg pixels and fill holes
    fg = alpha>0
    fg = ndimage.binary_opening(fg, structure=np.ones((2,2)))
    # keep the largest component (the object)
    lab,n = ndimage.label(fg)
    if n>1:
        sizes=ndimage.sum(fg,lab,range(1,n+1))
        big=np.argmax(sizes)+1
        fg = lab==big
    alpha=np.where(fg,255,0).astype(np.uint8)
    rgba=np.dstack([reg.astype(np.uint8), alpha])
    im=Image.fromarray(rgba,'RGBA')
    bbox=im.getchannel('A').getbbox()
    if bbox: im=im.crop(bbox)
    # upscale to PMDO scale xS (nearest to preserve pixel art)
    im2=im.resize((im.width*S, im.height*S), Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    print(f"  {name}: source={x1-x0+1}x{y1-y0+1} sprite={im2.size} bg_mean={tuple(int(v) for v in bg_mean)}")
    return im2

# Recadrer des objets nommés depuis le rendu Metano (coords dans le rendu 1512x1512)
# Ces bbox viennent de l'image annotée (buildings_annotated) + repérage.
objs = {
  "building_redshop_pink": (215,255,300,360),   # pink tent building
  "building_tomato_tent": (355,245,470,360),    # tomato/aubergine tent
  "building_dome_round": (470,270,590,360),     # dome house
  "building_blue_house": (760,360,900,470),     # blue/white house (north)
  "building_straw_house": (760,140,900,250),    # straw house NE
  "building_cafe_green": (590,300,680,380),     # green roof shop
  "totem_pink_face": (700,1020,820,1120),       # pink face totem
  "building_windmill": (300,810,420,900),       # stone hut
  "building_brown_house": (200,1000,300,1080),  # brown house w/ scald
  "building_greenhouse": (280,1070,360,1120),   # plant house
}
print("Isolation depuis le rendu Metano (S=%d):"%S)
for name,(x0,y0,x1,y1) in objs.items():
    isolate_bbox(x0,y0,x1,y1,name)
