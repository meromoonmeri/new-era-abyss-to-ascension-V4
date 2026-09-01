import os, glob
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'
files=sorted(glob.glob(f'{OUT}/sign_*.png'))
imgs=[(os.path.basename(f), Image.open(f).convert('RGBA')) for f in files]
print("signs:", len(imgs))
if not imgs: raise SystemExit
maxw=max(i.width for _,i in imgs); maxh=max(i.height for _,i in imgs)
cols=5; pad=8; lh=18
rows=(len(imgs)+cols-1)//cols
sheet=Image.new('RGB',(cols*(maxw+pad), rows*(maxh+pad+lh)),(255,255,255))
d=ImageDraw.Draw(sheet)
try: font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',10)
except: font=ImageFont.load_default()
for k,(name,im) in enumerate(imgs):
    x=(k%cols)*(maxw+pad); y=(k//cols)*(maxh+pad+lh)
    sheet.paste(im,(x,y),im); d.text((x+1,y+maxh+1),name,fill=(0,0,0),font=font)
sheet.save(f'{OUT}/_atlas_signs.png'); print("atlas",sheet.size)
