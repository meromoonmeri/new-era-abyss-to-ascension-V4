from PIL import Image
import numpy as np
mt=Image.open('CONVERSION_WS/analysis/ref/metano_town.png').convert('RGB')
a=np.asarray(mt).astype(np.int32)
# probe several candidate centers by sampling around expected totem locations
# The totem violet: from the view it's near the right cluster around x=1000-1100, y=1000-1160
# Let's print a coarse "non-bg" map of the right-bottom quadrant to find the totems
R,G,B=a[:,:,0],a[:,:,1],a[:,:,2]
bg=(G>200)&(R>185)&(B<150)&((G-B)>55) | ((R>230)&(G>205)&(B>130)&(B<205)&((G-B)>35)) | ((G>195)&(R>180)&(R<235)&(B<150))
fg=~bg
# right-middle zone x 900-1290 y 950-1220
sub=fg[950:1220, 900:1300]
# downsample to 20px blocks
cs=16
for by in range(0,sub.shape[0],cs):
    row=''
    for bx in range(0,sub.shape[1],cs):
        mean=sub[by:by+cs,bx:bx+cs].mean()
        row += '#' if mean>0.3 else ('+' if mean>0.12 else '.')
    print(f"y={950+by:4d} {row}")
