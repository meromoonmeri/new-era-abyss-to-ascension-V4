from PIL import Image, ImageDraw, ImageFont
src = Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# Annotate candidate named-object bboxes on the town fragment
cands = {
  "tree_cluster": (60,40,140,120),
  "sign_star": (100,255,150,300),   # kecleon star sign
  "totem_blue_statue": (420,45,500,110),  # blue winged statue
  "building_redshop": (150,300,250,380), # red door shop
  "building_dome": (180,300,260,375),
  "totem_stone": (305,660,400,775),  # stone stack totem bottom
  "building_kiosk": (220,340,300,420),
  "sign_wood": (330,470,375,510),
}
im=src.copy(); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',14)
except: f=ImageFont.load_default()
for n,(x0,y0,x1,y1) in cands.items():
    d.rectangle([x0,y0,x1,y1],outline=(255,0,255),width=2)
    d.text((x0+2,y0+2),n,fill=(255,0,255),font=f,stroke_width=2,stroke_fill=(255,255,255))
im.save('CONVERSION_WS/analysis/probe_objects.png')
print("saved", im.size)
