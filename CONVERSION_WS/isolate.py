"""Génère les sprites isolés (alpha) des objets de la famille Metano à
l'échelle PMDO (S=3 => 24px/cellule, aligné moteur 24px/cellule).

Sources :
  - bâtiments : /tmp/mt_buildings.json (groupes complets, collision native)
  - végétation (arbres/buissons) : /tmp/mt_vocab.json objects
  - panneaux/totems/statues : sélection manuelle de groupes

Chaque sprite : rendu des cellules composites sur fond transparent, rogné
au bbox, upscaled xS, sauvegardé en PNG RGBA + un atlas (contact sheet).
"""
import json, os
from PIL import Image
DB=json.load(open('/tmp/mt_db.json'))
INFO=DB['info']
S=3  # PMDO scale: 8px cell * 3 = 24px/cellule
def cell_img(h): return Image.open('/tmp/mt_imgs/%s.png'%h).convert('RGBA')

def render_group(group, pad=0):
    w,h=group['w'],group['h']
    canvas=Image.new('RGBA',((w+2*pad)*S*8,(h+2*pad)*S*8),(0,0,0,0))
    for dx,dy,hkey,cl in group['cells']:
        img=cell_img(hkey).resize((S*8,S*8),Image.NEAREST)
        canvas.alpha_composite(img,((pad+dx)*S*8,(pad+dy)*S*8))
    # trim to alpha bbox
    bbox=canvas.getchannel('A').getbbox()
    if bbox: canvas=canvas.crop(bbox)
    return canvas

OUT='CONVERSION_WS/tilesets'
os.makedirs(OUT,exist_ok=True)

# ---- BÂTIMENTS (from /tmp/mt_buildings.json) ----
buildings=json.load(open('/tmp/mt_buildings.json'))
# keep reasonably-sized clean buildings
sel=[i for i,b in enumerate(buildings) if b['n']>=30 and b['w']<=20 and b['h']<=20 and b['green_ratio']<0.5]
print("building sprites:", len(sel))
for idx,i in enumerate(sel):
    b=buildings[i]
    sp=render_group(b,pad=1)
    sp.save(f'{OUT}/building_{idx:02d}_w{b["w"]}x{b["h"]}.png')
    print(f"  building_{idx:02d} w={b['w']}x{b['h']} n={b['n']} sprite={sp.size}")

# contact sheet for buildings
maxw=max(render_group(buildings[i],pad=1).width for i in sel) if sel else 0
maxh=max(render_group(buildings[i],pad=1).height for i in sel) if sel else 0
cols=6; rows=(len(sel)+cols-1)//cols
sheet=Image.new('RGBA',(cols*(maxw+12), rows*(maxh+12)),(40,40,50,255))
for k,i in enumerate(sel):
    sp=render_group(buildings[i],pad=1)
    x=(k%cols)*(maxw+12); y=(k//cols)*(maxh+12)
    sheet.alpha_composite(sp,(x+6,y+6))
sheet.convert('RGB').save(f'{OUT}/_atlas_buildings.png')
print("buildings atlas", sheet.size)
