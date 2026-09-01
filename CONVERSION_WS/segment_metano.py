from PIL import Image
import numpy as np
from scipy import ndimage

mt = Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a = np.asarray(mt).astype(np.int32)
H,W,_ = a.shape
R,G,B = a[:,:,0],a[:,:,1],a[:,:,2]

# Background: light grass / yellow-green base OR sand path
bg_grass = (G>195)&(R>205)&(B<150)
bg_yg    = (G>185)&(B<120)&(R>190)
bg_sand  = (R>235)&(G>205)&(B>130)&(B<205)&((G-B)>40)
bg = bg_grass|bg_yg|bg_sand
fg = ~bg
# clean
fg = ndimage.binary_closing(fg, structure=np.ones((3,3)))
fg = ndimage.binary_opening(fg, structure=np.ones((2,2)))
lab,n = ndimage.label(fg)
sizes = ndimage.sum(fg,lab,range(1,n+1))
print("total components:", n)
comps=[]
for i in range(1,n+1):
    if sizes[i-1] < 200: continue
    ys,xs=np.where(lab==i)
    x0,x1,y0,y1=xs.min(),xs.max(),ys.min(),ys.max()
    w,h=x1-x0+1,y1-y0+1
    area=int(sizes[i-1])
    fill=area/(w*h)
    comps.append((int(x0),int(y0),int(x1),int(y1),w,h,area,round(fill,2)))
comps.sort(key=lambda c:-c[6])
print("large components:", len(comps))
for c in comps[:35]:
    print(f"  ({c[0]},{c[1]})-({c[2]},{c[3]}) {c[4]}x{c[5]} area={c[6]} fill={c[7]}")
