import os, glob, json
from PIL import Image, ImageDraw, ImageFont
OUT=os.path.abspath('CONVERSION_WS/tilesets')
print("OUT =",OUT)
# 1) remove old duplicate atlases
for f in glob.glob(os.path.join(OUT,'_atlas_*.png')):
    os.remove(f)
print("tree glob:",len(glob.glob(os.path.join(OUT,'tree_*.png'))))
print("bld  glob:",len(glob.glob(os.path.join(OUT,'building_*.png'))))

def named(files):
    out=[]
    for fp in files:
        b=os.path.basename(fp)
        im=Image.open(fp).convert('RGBA')
        out.append(('.'.join(b.split('.')[:-1]),im))
    out.sort(key=lambda t:t[0])
    return out

groups=[
 ('arbres', named(glob.glob(os.path.join(OUT,'tree_*.png')))),
 ('batiments', named(glob.glob(os.path.join(OUT,'building_*.png')))),
 ('totems_statues', named(['src_statue_blue_wing.png','src_statue_smurf.png','src_statue_volt.png',
                    'src_totem_purple_face.png','src_kiosk_hat.png','obj_statue_celebi.png',
                    'obj_statue_island.png','obj_shop_red.png'])),
 ('panneaux_enseignes', named(['sign_04_4x3.png'])),
]
mg={}
for gname,imgs in groups:
    if not imgs:
        print(gname,"none"); continue
    maxw=max(i.width for _,i in imgs); maxh=max(i.height for _,i in imgs)
    cols=6; pad=10; lh=20
    rows=(len(imgs)+cols-1)//cols
    sheet=Image.new('RGB',(cols*(maxw+pad), rows*(maxh+pad+lh)),(250,250,250))
    d=ImageDraw.Draw(sheet)
    try: font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',10)
    except: font=ImageFont.load_default()
    for k,(bas,im) in enumerate(imgs):
        x=(k%cols)*(maxw+pad); y=(k//cols)*(maxh+pad+lh)
        sheet.paste(im,(x,y),im); d.text((x+1,y+maxh+1),bas,fill=(0,0,0),font=font)
    outf=os.path.join(OUT,f'atlas_{gname}.png'); sheet.save(outf)
    mg[gname]={'count':len(imgs),'atlas':f'atlas_{gname}.png','sprites':[b for b,_ in imgs]}
    print(f"{gname}: {len(imgs)} -> atlas_{gname}.png {sheet.size}")
json.dump(mg,open(os.path.join(OUT,'manifest.json'),'w'),indent=1)
print("manifest written")
