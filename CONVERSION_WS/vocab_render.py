import json, io, glob, os
import numpy as np
from PIL import Image

v = json.load(open('/tmp/mt_vocab.json'))
objs = v['objects']
DB = json.load(open('/tmp/mt_db.json'))
INFO = DB['info']

def cell_img(h):
    return Image.open('/tmp/mt_imgs/%s.png' % h).convert('RGBA')

# Render each object onto a transparent canvas
contact = []
maxw=maxh=0
for o in objs:
    w,h,n = o['w'],o['h'],o['n']
    maxw=max(maxw,w); maxh=max(maxh,h)
print("using object count", len(objs), "max", maxw, maxh)
# Build a grid contact sheet, canvas per object with padding, labeled by index
scale=8
pad=1
cw=(maxw+2*pad)*scale; ch=(maxh+2*pad)*scale
cols=12
rows=(len(objs)+cols-1)//cols
sheet=Image.new('RGBA',(cols*cw, rows*ch),(0,0,0,0))
for idx,o in enumerate(objs):
    canvas=Image.new('RGBA',(cw,ch),(0,0,0,0))
    for dx,dy,h,cl in o['cells']:
        canvas.alpha_composite(cell_img(h), (pad*scale+dx*scale, pad*scale+dy*scale))
    x=(idx%cols)*cw; y=(idx//cols)*ch
    sheet.alpha_composite(canvas,(x,y))
sheet.convert('RGB').save('CONVERSION_WS/analysis/vocab_objects_contact.png')
print("saved sheet", sheet.size)
