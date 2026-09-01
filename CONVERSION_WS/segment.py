from PIL import Image
import numpy as np
from scipy import ndimage

src = Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
a = np.asarray(src).astype(np.int32)
H,W,_ = a.shape

# Background keying model:
#  - grass base (bright green/yellow), light green  ~ (226,232,106)
#  - sand path ~ (255,223,159)
#  - forest canopy dark green ~ (55,102,31)/(50,87,31)
# Foreground objects (building, statue, totem, sign) are non-background.
#
# We build bg = grass OR sand OR shadow-no? Let's define bg mask by hue.
def is_bg(px):
    R,G,B=px
    # sand/path
    if R>235 and G>205 and 130<B<200 and (G-B)>40: return True
    # light grass / ground
    if G>195 and R>205 and B<150: return True
    # bright yellow-green ground
    if G>185 and B<120 and R>190: return True
    # dark forest canopy (this is background clutter; but trees are objects too)
    return False

# Non-bg mask
Rb,Gb,Bb = a[:,:,0],a[:,:,1],a[:,:,2]
sand = (Rb>235)&(Gb>205)&(Bb>130)&(Bb<200)&((Gb-Bb)>40)
grass= (Gb>195)&(Rb>205)&(Bb<150)
yg   = (Gb>185)&(Bb<120)&(Rb>190)
bg = sand|grass|yg
fg = ~bg
# remove tiny specks
fg2 = ndimage.binary_opening(fg, structure=np.ones((3,3)))
lab,n = ndimage.label(fg2)
sizes = ndimage.sum(fg2,lab,range(1,n+1))
objects = []
for i in range(1,n+1):
    if sizes[i-1] < 300: continue
    ys,xs = np.where(lab==i)
    x0,x1,y0,y1 = xs.min(),xs.max(),ys.min(),ys.max()
    objects.append((int(x0),int(y0),int(x1),int(y1),int(sizes[i-1])))
objects.sort(key=lambda o:-o[4])
print("large foreground objects (bbox, area):", len(objects))
for o in objects[:40]:
    print(f"  bbox=({o[0]},{o[1]})-({o[2]},{o[3]}) size={o[2]-o[0]+1}x{o[3]-o[1]+1} area={o[4]}")
