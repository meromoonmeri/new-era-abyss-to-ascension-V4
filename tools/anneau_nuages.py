import numpy as np, math, random
from PIL import Image
W,H=1152,1344; CX,CY=580,668
CIEL=np.array([247,247,255]); PAL=[np.array(c) for c in [(215,231,247),(191,211,239),(167,191,231)]]
N_SEC=8; SECT=2*math.pi/N_SEC
random.seed(4)
BOUF=[(random.uniform(330,880),random.uniform(0,SECT),random.uniform(38,104),random.randrange(3)) for _ in range(26)]
Y,X=np.mgrid[0:H,0:W]
R=np.hypot((X-CX).astype(float),(Y-CY).astype(float)); TH=np.arctan2((Y-CY).astype(float),(X-CX).astype(float))
def frame(rot):
    out=np.zeros((H,W,3),int); out[:]=CIEL
    t=np.mod(TH-rot,SECT); px=R*np.cos(t); py=R*np.sin(t)
    for (r0,a0,s0,ci) in BOUF:
        s=s0*(0.75+r0/900)
        for (ox,oy,f) in ((0,0,1.0),(-s*0.52,s*0.16,0.72),(s*0.55,s*0.12,0.66)):
            rr=s*f/2
            lx=r0*math.cos(a0)+ox; ly=r0*math.sin(a0)+oy
            lr=math.hypot(lx,ly); la=math.atan2(ly,lx)
            out[((px-lr*math.cos(la))**2+(py-lr*math.sin(la))**2)<rr*rr]=PAL[ci]
    return out
