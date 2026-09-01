import os, glob
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'
files=sorted(glob.glob(f'{OUT}/building_*.png'))
files=[f for f in files if '_atlas' not in f]
print("building sprites:", len(files))
# filter by name (exclude atlas)
imgs=[]
for f in files:
    im=Image.open(f).convert('RGBA')
    imgs.append((os.path.basename(f),im))
maxw=max(i.width for _,i in imgs); maxh=max(i.height for _,i in imgs)
cols=6; rows=(len(imgs)+cols-1)//cols
pad=10
sheet=Image.new('RGB',(cols*(maxw+pad), rows*(maxh+pad+20)),(255,255,255))
d=ImageDraw.Draw(sheet)
try: font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',12)
except: font=ImageFont.load_default()
for k,(name,im) in enumerate(imgs):
    x=(k%cols)*(maxw+pad); y=(k//cols)*(maxh+pad+20)
    sheet.paste(im,(x,y),im)
    d.text((x+2,y+maxh+2),name,fill=(0,0,0),font=font)
sheet.save(f'{OUT}/_atlas_buildings.png')
print("atlas", sheet.size)
