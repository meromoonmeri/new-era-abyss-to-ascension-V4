from PIL import Image
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
# Located regions (source px): refine each around the structure
regions={
 "L1_awning":(130,20,260,120),    # red/blue striped awning shop (image-1)
 "L2_bluewing":(445,35,520,115),  # blue winged statue (image-2)
 "L3_bearhead":(140,420,250,540), # bear/rabbit head building (image-3)
 "L4_teal":(470,470,575,600),     # teal boss totem (image-4)
}
for n,(x0,y0,x1,y1) in regions.items():
    c=src.crop((x0,y0,x1,y1)); c=c.resize((c.width*3,c.height*3),Image.NEAREST)
    c.save(f'/tmp/{n}.png'); print(n,'->',(x0,y0,x1,y1))
