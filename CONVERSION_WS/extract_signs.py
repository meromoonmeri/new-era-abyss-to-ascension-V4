"""Totems / statues / panneaux / enseignes : composantes non-fond, non-vertes,
bloquées, de taille petite à moyenne, isolées sur l'herbe. Ce sont les
objets « décoratifs ponctuels » du ground Metano."""
import json
DB=json.load(open('/tmp/mt_db.json'))
W0,H0=DB['W'],DB['H']; G=DB['grid']; COLL=DB['coll']; INFO=DB['info']
CLS={k:v['cls'] for k,v in INFO.items()}
def green(h):
    a=INFO[h]['avg']; return a[1]>=a[0] and a[1]>=a[2]
NEI8=[(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)]
seen=[[False]*W0 for _ in range(H0)]
objs=[]
for x in range(W0):
    for y in range(H0):
        if seen[y][x] or CLS[G[x][y]] in ('G','P','W'): continue
        stack=[(x,y)]; seen[y][x]=True; comp=[]
        while stack:
            cx,cy=stack.pop(); comp.append((cx,cy))
            for dx,dy in NEI8:
                nx,ny=cx+dx,cy+dy
                if 0<=nx<W0 and 0<=ny<H0 and not seen[ny][nx] and CLS[G[nx][ny]] not in ('G','P','W'):
                    seen[ny][nx]=True; stack.append((nx,ny))
        xs=[c[0] for c in comp]; ys=[c[1] for c in comp]
        x0,y0=min(xs),min(ys); w=max(xs)-x0+1; h=max(ys)-y0+1
        grn=sum(1 for cx,cy in comp if green(G[cx][cy]))
        blocked=sum(1 for cx,cy in comp if COLL[cx][cy]!=0)
        # decorative object: not green, blocked, small
        objs.append({'w':w,'h':h,'n':len(comp),'blocked':blocked,
            'green':round(grn/len(comp),2),'at':[x0,y0],
            'cells':[[cx-x0,cy-y0,G[cx][cy],COLL[cx][cy]] for cx,cy in comp]})
# signs/totems: green_ratio low, blocked, n between 4 and 60, small bbox
deco=[o for o in objs if o['green']<0.3 and o['blocked']>=2 and 4<=o['n']<=60 and o['w']<=12 and o['h']<=12]
print("deco objs:",len(objs)," signs/totems:",len(deco))
for o in sorted(deco,key=lambda o:-o['n'])[:40]:
    print(f"  at={o['at']} {o['w']}x{o['h']} n={o['n']} blk={o['blocked']} green={o['green']}")
json.dump(deco, open('/tmp/mt_signs.json','w'))
