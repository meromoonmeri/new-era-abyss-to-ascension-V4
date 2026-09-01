import os
from PIL import Image, ImageDraw, ImageFont
OUT='CONVERSION_WS/tilesets'
names=["shop_awning_railstall","statue_bluewing_x","house_bearhead_redmat","totem_teal_boss"]
imgs=[(n,Image.open(f'{OUT}/{n}.png').convert('RGBA')) for n in names]
maxw=max(i.width for _,i in imgs); maxh=max(i.height for _,i in imgs)
cols=4; pad=12; lh=20
sheet=Image.new('RGB',(cols*(maxw+pad), (maxh+pad+lh)),(250,250,250))
d=ImageDraw.Draw(sheet)
try: font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',11)
except: font=ImageFont.load_default()
for k,(n,im) in enumerate(imgs):
    x=k*(maxw+pad)
    sheet.paste(im,(x,0),im); d.text((x+1,maxh+1),n,fill=(0,0,0),font=font)
sheet.save(f'{OUT}/_atlas_structures4.png'); print("atlas",sheet.size, "| sprite sizes:", [(n,f'{i.width}x{i.height}') for n,i in imgs])
