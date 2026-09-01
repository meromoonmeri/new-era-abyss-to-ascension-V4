from PIL import Image
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# Montage source candidates corresponding to the 4 uploads (approx):
regions={
 "S1_awning":(150,430,290,540),     # shop w/ red-blue awning (image-1)
 "S2_bluewing":(430,30,520,120),    # blue winged statue (image-2)
 "S3_bearhead":(120,600,250,720),   # bear/rabbit head building (image-3)
 "S4_teal":(455,555,570,650),       # teal boss totem (image-4)
}
for n,(x0,y0,x1,y1) in regions.items():
    c=src.crop((x0,y0,x1,y1))
    c=c.resize((c.width*2,c.height*2),Image.NEAREST)
    c.save(f'/tmp/{n}.png'); print(n,c.size)
