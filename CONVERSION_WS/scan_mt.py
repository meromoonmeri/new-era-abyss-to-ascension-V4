from PIL import Image
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
W,H=mt.size
# quadrant tiles with overlap, downscale x2 for overview
for i,(x0,y0,x1,y1) in enumerate([(0,0,W//2+80,H//2+80),(W//2-80,0,W,H//2+80),(0,H//2-80,W//2+80,H),(W//2-80,H//2-80,W,H)]):
    c=mt.crop((x0,y0,x1,y1)); c.save(f'/tmp/q{i}.png'); print(i,(x0,y0,x1,y1),c.size)
