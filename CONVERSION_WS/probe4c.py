from PIL import Image, ImageDraw, ImageFont
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
# Many candidate buildings in render; grid them to identify the 4 targets.
# We know bluewing statue ~ (690,20)-(770,120). Scan the right/bottom for teal totem & bearhead.
cands={
 "t1_awning":(240,540,360,650),      # red/blue awning shop TL
 "t2_bluewing":(680,10,775,125),     # blue winged statue
 "t3_bearhead":(1080,1050,1240,1180),# pink/orange bear face bottom
 "t4_tealtotem":(1480,780,1600,900), # teal totem right
 "t5_tentroof":(285,470,355,555),    # alternate awning/tent
}
im=mt.copy(); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',16)
except: f=ImageFont.load_default()
col=(255,0,255)
for n,(x0,y0,x1,y1) in cands.items():
    d.rectangle([x0,y0,x1,y1],outline=col,width=3)
    d.text((x0+2,y0+2),n,fill=col,font=f,stroke_width=2,stroke_fill=(255,255,255))
# crop each and save separately for close inspection
for n,(x0,y0,x1,y1) in cands.items():
    mt.crop((x0,y0,x1,y1)).save(f'/tmp/cand_{n}.png')
im.save('CONVERSION_WS/analysis/probe4c.png'); print("saved")
