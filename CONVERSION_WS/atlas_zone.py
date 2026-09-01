import os, glob
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'
files=sorted(glob.glob(f'{OUT}/totem_*.png')+glob.glob(f'{OUT}/sign2_*.png')+glob.glob(f'{OUT}/kiosk_*.png'))
imgs=[(os.path.basename(f), Image.open(f).convert('RGBA')) for f in files]
if not imgs: print("none"); raise SystemExit
maxw=max(i.width for _,i in imgs); maxh=max(i.height for _,i in imgs)
cols=4; pad=10; lh=20
rows=(len(imgs)+cols-1)//cols
sheet=Image.new('RGB',(cols*(maxw+pad), rows*(maxh+pad+lh)),(255,255,255))
d=ImageDraw.Draw(sheet)
try: font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',11)
except: font=ImageFont.load_default()
for k,(name,im) in enumerate(imgs):
    x=(k%cols)*(maxw+pad); y=(k//cols)*(maxh+pad+lh)
    sheet.paste(im,(x,y),im); d.text((x+1,y+maxh+1),name,fill=(0,0,0),font=font)
sheet.save(f'{OUT}/_atlas_zone.png'); print("atlas",sheet.size)
