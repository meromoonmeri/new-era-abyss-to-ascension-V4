from PIL import Image
import numpy as np
src = Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
a = np.asarray(src).astype(np.int32)

def key_out(bbox, name):
    x0,y0,x1,y1 = bbox
    region = a[y0:y1, x0:x1]
    R,G,B = region[:,:,0],region[:,:,1],region[:,:,2]
    # background = grass/green/yellow base OR sand. Make these transparent.
    # grass/yellow-green base
    bg = (G>170)&(B<150)&((G-B)>50)
    # sand bright
    bg |= (R>235)&(G>205)&(B>130)&(B<205)&((G-B)>40)
    # dark forest canopy (for tree clusters we WANT green; so not used here)
    bg |= (G>195)&(R>205)&(B<150)
    al = np.where(bg, 0, 255).astype(np.uint8)
    rgba = np.dstack([region.astype(np.uint8), al])
    im = Image.fromarray(rgba,'RGBA')
    im.thumbnail((300,300), Image.LANCZOS)
    im.save(f'CONVERSION_WS/analysis/keyout_{name}.png')
    # stats
    fg = (al>0).mean()
    print(f"{name}: bbox={bbox} fg_frac={fg:.2f} save={im.size}")

key_out((60,40,140,120),'tree')
key_out((100,255,150,300),'sign')
key_out((420,45,500,110),'totem')
key_out((150,300,250,380),'building')
key_out((305,660,400,775),'totem2')
