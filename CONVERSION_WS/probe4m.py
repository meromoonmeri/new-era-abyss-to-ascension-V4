from PIL import Image, ImageDraw, ImageFont
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
# candidate regions in the 1512 render (3x source). Guess from montage positions *~1.4 for this render's framing.
cands={
 "m1_awning_shop":(260,640,390,760),    # red/blue awning shop
 "m2_bluewing_statue":(690,60,780,150), # blue winged statue top
 "m3_bearhead_house":(1500,880,1700,1050), # bear/rabbit head house bottom-right
 "m4_teal_totem":(1420,780,1600,900),   # teal boss totem right side
}
im=mt.copy(); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',18)
except: f=ImageFont.load_default()
for n,(x0,y0,x1,y1) in cands.items():
    d.rectangle([x0,y0,x1,y1],outline=(255,0,255),width=3)
    d.text((x0+2,y0+2),n,fill=(255,0,255),font=f,stroke_width=2,stroke_fill=(255,255,255))
im.save('CONVERSION_WS/analysis/probe4m.png'); print("saved",mt.size)
