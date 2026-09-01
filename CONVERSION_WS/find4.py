from PIL import Image
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# Generous windows in the SOURCE montage around discovered/expected targets
regions={
 "W1_bearhead":(140,400,270,540),   # bear/rabbit head bldg
 "W2_awning":(230,330,380,470),     # red/blue awning shop
 "W3_teal":(430,540,600,690),       # teal totem
 "W4_bluewing":(430,20,540,140),    # blue winged statue
}
for n,(x0,y0,x1,y1) in regions.items():
    c=src.crop((x0,y0,x1,y1)); c=c.resize((c.width*2,c.height*2),Image.NEAREST)
    c.save(f'/tmp/{n}.png'); print(n,c.size)
