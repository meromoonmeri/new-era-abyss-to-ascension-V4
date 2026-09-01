from PIL import Image, ImageDraw, ImageFont
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# Annotate suspected totems/statues/signs in the montage source
cands={
 "src_totem_purple_face":(600,240,700,350),   # purple-faced totem (left of statue)
 "src_statue_blue_wing":(430,40,510,120),     # blue winged statue
 "src_statue_volt":(510,540,590,640),         # volt orb statue
 "src_kiosk_hat":(300,320,360,400),           # hat kiosk
 "src_sign_tree":(60,180,120,250),            # tree-branch sign
 "src_statue_smurf":(180,270,240,350),        # blue statue
 "src_sign_wood":(330,470,375,510),           # wooden sign
}
im=src.copy(); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',13)
except: f=ImageFont.load_default()
for n,(x0,y0,x1,y1) in cands.items():
    d.rectangle([x0,y0,x1,y1],outline=(255,0,255),width=2)
    d.text((x0+1,y0+1),n,fill=(255,0,255),font=f,stroke_width=2,stroke_fill=(255,255,255))
im.save('CONVERSION_WS/analysis/probe_source_objs.png')
print("saved")
