"""Rassemble tout dans une structure d'atlas cohérente + README."""
import os, glob, json
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'

# Remove the misfired totem/kiosk/sign2 (bad crops from isolate_zone/isolate_named)
for bad in ['totem_violet.png','totem_orange_boss.png','totem_stone.png','kiosk_teal.png',
            'sign_yellow.png','sign2_*.png','obj_kiosk_teal.png','obj_totem_violet.png',
            'obj_totem_orange_boss.png','obj_totem_stone.png','obj_sign_kecleon_enclos_e.png',
            'obj_sign_kecleon_enclos_n.png','obj_sign_yellow.png']:
    for f in glob.glob(f'{OUT}/{bad}'):
        os.remove(f)

groups={
 'arbres': sorted(glob.glob(f'{OUT}/tree_*.png')),
 'batiments': sorted(glob.glob(f'{OUT}/building_*.png')),
 'totems_statues': sorted(glob.glob(f'{OUT}/src_*.png'))+sorted(glob.glob(f'{OUT}/obj_statue_*.png'))+sorted(glob.glob(f'{OUT}/obj_shop_red.png')),
 'panneaux_enseignes': sorted(glob.glob(f'{OUT}/sign_04_4x3.png')),
}
metalist={}
sheet_imgs={}
for gname,files in groups.items():
    imgs=[]
    for fp in files:
        bas=os.path.basename(fp)
        if bas.startswith('_atlas') or bas in ('sign_04_4x3.png',):
            # keep for panel group
            pass
        im=Image.open(fp).convert('RGBA')
        imgs.append((bas,im))
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
    outf=f'{OUT}/atlas_{gname}.png'
    sheet.save(outf)
    metalist[gname]={'count':len(imgs),'atlas':os.path.basename(outf),
                     'sprites':[b for b,_ in imgs]}
    print(f"{gname}: {len(imgs)} sprites -> atlas_{gname}.png {sheet.size}")
json.dump(metalist, open(f'{OUT}/manifest.json','w'), indent=1)
print("manifest written")
