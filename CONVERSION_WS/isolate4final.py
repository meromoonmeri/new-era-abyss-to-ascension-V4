"""Isolation FINALE : fenetre source serree sur la structure (bbox mesuree + marge 3)
=> la deco peripherique est exclue d'office. Puis solve v5 (sol+canopee+branche morte)."""
import os
import numpy as np
from PIL import Image
from scipy import ndimage
S=3
OUT='CONVERSION_WS/tilesets'
src=Image.open('CONVERSION_WS/analysis/source.png').convert('RGB')
a=np.asarray(src).astype(np.float64)
# fenetres serrees (bbox structure + marge 3 px) => coupe la deco exterieure
targets={
 "shop_awning_railstall":(137,32,219,99),
 "statue_bluewing_x":(424,50,490,109),
 "house_bearhead_redmat":(134,425,213,498),
 "totem_teal_boss":(474,476,546,545),
}
def classify(reg,cx,cy):
    R,G,B=reg[:,:,0],reg[:,:,1],reg[:,:,2]
    H,W=R.shape
    yy,xx=np.mgrid[0:H,0:W]
    dist=np.sqrt(((xx-cx)/max(W,1))**2+((yy-cy)/max(H,1))**2)
    ground=((G>195)&((G-B)>50)&(R<235)) | ((R>205)&(G>185)&(B>100)&(B<215)&((G-B)>20)&((R-B)>30))
    canopy=(G>R+10)&(G>B+20)&(G>=80)&(G<=205)&(R<=170)&(B<=110)&(((G-R)>15)|((G-B)>35))
    twig=(R>90)&(G<150)&(R>=G-8)&(B<120)&(G>=B)&((R-G)<70)&((G-B)>10)&(dist>0.25)
    return ground,canopy,twig

for name,(x0,y0,x1,y1) in targets.items():
    reg=a[y0:y1+1,x0:x1+1].copy()
    H,W,_=reg.shape; cy,cx=H//2,W//2
    ground,canopy,twig=classify(reg,cx,cy)
    fg=~(ground|canopy|twig)
    fg=ndimage.binary_closing(fg,structure=np.ones((3,3)))
    fg=ndimage.binary_opening(fg,structure=np.ones((2,2)))
    lab,n=ndimage.label(fg)
    mid=lab[cy,cx]
    if mid==0:
        ys,xs=np.nonzero(fg)
        if len(ys)==0: mid=0
        else:
            k=np.argmin((ys-cy)**2+(xs-cx)**2); mid=lab[ys[k],xs[k]]
    keep=(lab==mid) if mid>0 else fg
    # ajouter composantes au contact (dilatation 2) pour ne pas trouer le bâtiment
    dil=ndimage.binary_dilation(keep,iterations=2)
    keep2=keep|((lab>0)&dil&(lab!=mid))
    al=(keep2*255).astype(np.uint8); al=ndimage.median_filter(al,size=3)
    im=Image.fromarray(np.dstack([reg.astype(np.uint8),al]),'RGBA')
    bb=im.getchannel('A').getbbox()
    if bb: im=im.crop(bb)
    im2=im.resize((im.width*S,im.height*S),Image.NEAREST)
    im2.save(f'{OUT}/{name}.png')
    print(name,"->",im2.size,"in src cells:",round((y1-y0)/8,1),'x',round((x1-x0)/8,1))
