from PIL import Image
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
regions={
 "a_awning":(175,435,285,525),     # awning shop (image-1)
 "b_bluewing":(445,30,515,110),    # blue winged statue (image-2)
 "c_bearhead":(145,610,245,700),   # brown bear head (image-3)
 "d_teal":(485,555,565,645),       # teal totem (image-4)
}
for n,(x0,y0,x1,y1) in regions.items():
    c=src.crop((x0,y0,x1,y1)); c=c.resize((c.width*3,c.height*3),Image.NEAREST)
    c.save(f'/tmp/{n}.png'); print(n,c.size)
