import json
from PIL import Image
DB=json.load(open('/tmp/mt_db.json'))
INFO=DB['info']
def cell_img(h): return Image.open('/tmp/mt_imgs/%s.png'%h).convert('RGBA')

buildings=json.load(open('/tmp/mt_buildings.json'))
# render the top ~10 clean building groups on transparent canvas, scale x3 (PMDO)
S=3
pad=1
# contact sheet
maxw=max(b['w'] for b in buildings); maxh=max(b['h'] for b in buildings)
cw=(maxw+2*pad)*S*8; ch=(maxh+2*pad)*S*8
cols=5
sel=[b for b in buildings if b['n']>=60]
rows=(len(sel)+cols-1)//cols
sheet=Image.new('RGBA',(cols*cw,rows*ch),(0,0,0,0))
for idx,b in enumerate(sel):
    canvas=Image.new('RGBA',(cw,ch),(0,0,0,0))
    for dx,dy,h,cl in b['cells']:
        img=cell_img(h)
        # upscale cell x3
        img=img.resize((S*8,S*8),Image.NEAREST)
        canvas.alpha_composite(img,(pad*S*8+dx*S*8, pad*S*8+dy*S*8))
    x=(idx%cols)*cw; y=(idx//cols)*ch
    sheet.alpha_composite(canvas,(x,y))
sheet.convert('RGB').save('CONVERSION_WS/analysis/buildings_contact.png')
print("saved buildings_contact", sheet.size, "count", len(sel), "S=",S)
# print selected indices with size
for i,b in enumerate(sel):
    print(f"  [{i}] w={b['w']} h={b['h']} n={b['n']} green={b['green_ratio']}")
