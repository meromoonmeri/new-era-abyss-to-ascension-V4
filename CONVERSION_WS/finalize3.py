import os, glob, json
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'

# 1) Remove old duplicate atlases
for f in glob.glob(f'{OUT}/_atlas_*.png'):
    os.remove(f)
# 2) Remove tiny bad fragments
for f in ['obj_statue_gold.png','src_sign_tree.png','src_sign_wood.png','src_kecleon_sign.png']:
    p=f'{OUT}/{f}'
    if os.path.exists(p): os.remove(p)

groups={
 'arbres': sorted(glob.glob(f'{OUT}/tree_*.png')),
 'batiments': sorted(glob.glob(f'{OUT}/building_*.png')),
 'totems_statues': ['src_statue_blue_wing.png','src_statue_smurf.png','src_statue_volt.png',
                    'src_totem_purple_face.png','src_kiosk_hat.png','obj_statue_celebi.png',
                    'obj_statue_island.png','obj_shop_red.png'],
 'panneaux_enseignes': ['sign_04_4x3.png'],
}
mg={}
for gname,files in groups.items():
    imgs=[]
    for fp in files:
        p=f'{OUT}/{fp}'
        if not os.path.exists(p): continue
        imgs.append(('.'.join(os.path.basename(p).split('.')[:-1]), Image.open(p).convert('RGBA')))
    imgs.sort(key=lambda t:t[0])
    if not imgs: print(gname,"none"); continue
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
    outf=f'{OUT}/atlas_{gname}.png'; sheet.save(outf)
    mg[gname]={'count':len(imgs),'atlas':os.path.basename(outf),'sprites':[b for b,_ in imgs]}
    print(f"{gname}: {len(imgs)} -> {os.path.basename(outf)} {sheet.size}")

json.dump(mg,open(f'{OUT}/manifest.json','w'),indent=1)
print("manifest written")
