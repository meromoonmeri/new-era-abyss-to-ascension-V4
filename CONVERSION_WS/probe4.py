from PIL import Image, ImageDraw, ImageFont
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# candidate regions for the 4 uploaded objects (approximate, source is 1:1 8px cells)
cands={
 "a_awning_shop":(175,435,280,520),     # red/blue striped awning shop/camp
 "b_bluewing_statue":(445,35,520,115),  # blue winged statue top
 "c_bearhead_house":(140,610,240,700),  # bear/rabbit head building
 "d_teal_totem":(485,555,565,645),      # teal boss totem
}
im=src.copy(); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',13)
except: f=ImageFont.load_default()
for n,(x0,y0,x1,y1) in cands.items():
    d.rectangle([x0,y0,x1,y1],outline=(255,0,255),width=2)
    d.text((x0+1,y0+1),n,fill=(255,0,255),font=f,stroke_width=2,stroke_fill=(255,255,255))
im.save('CONVERSION_WS/analysis/probe4.png'); print("saved", src.size)
