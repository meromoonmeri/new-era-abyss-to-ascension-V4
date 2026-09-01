from PIL import Image
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
W,H=src.size  # 1083x876
# 6 tiles with overlap
tiles={
 "t0":(0,0,380,300), "t1":(340,0,720,300), "t2":(680,0,1083,300),
 "t3":(0,270,380,610), "t4":(340,270,720,610), "t5":(680,270,1083,610),
 "t6":(0,580,380,876), "t7":(340,580,720,876), "t8":(680,580,1083,876),
}
for n,(x0,y0,x1,y1) in tiles.items():
    c=src.crop((x0,y0,x1,y1)); c=c.resize((int(c.width*1.6),int(c.height*1.6)),Image.NEAREST)
    c.save(f'/tmp/{n}.png')
print("tiled")
