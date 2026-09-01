from PIL import Image
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
# Tight candidate crops to match the 4 uploads. Coordinates in 1512 render.
regions={
 "R1_awning":(250,560,400,700),     # awning shop (red/blue striped roof)
 "R2_bluewing":(690,20,780,130),    # blue winged statue
 "R3_bearhead":(1080,1030,1260,1200), # bear/rabbit head building
 "R4_teal":(1480,780,1620,910),     # teal totem right edge
}
from PIL import ImageEnhance
for n,(x0,y0,x1,y1) in regions.items():
    c=mt.crop((x0,y0,x1,y1))
    c=c.resize((c.width*2,c.height*2),Image.NEAREST)
    c.save(f'/tmp/{n}.png')
    print(n,c.size)
