"""Arbres/buissons : composantes de CELLULES-CANOPÉE vert foncé, bloquées.
Une canopée d'arbre = cellule dont l'équivalent 8px est majoritairement
vert FONCÉ (G>R, G>B, B<60, G<180) — pas l'herbe claire ni le sable."""
import json
import numpy as np
DB=json.load(open('/tmp/mt_db.json'))
W0,H0=DB['W'],DB['H']; G=DB['grid']; COLL=DB['coll']; INFO=DB['info']

def is_canopy(h):
    a=INFO[h]['avg']; R,G,B=a
    # dark tree canopy: green dominant, blue very low, not the pale grass base
    if not (G>R and G>B): return False
    if B>70: return False
    if G<70 or G>180: return False
    if R>130: return False
    return True
def is_short(h):
    return INFO[h]['cls'] in ('G','P','W')

NEI8=[(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)]
seen=[[False]*W0 for _ in range(H0)]
objs=[]
for x in range(W0):
    for y in range(H0):
        if seen[y][x] or not is_canopy(G[x][y]): continue
        stack=[(x,y)]; seen[y][x]=True; comp=[]
        while stack:
            cx,cy=stack.pop(); comp.append((cx,cy))
            for dx,dy in NEI8:
                nx,ny=cx+dx,cy+dy
                if 0<=nx<W0 and 0<=ny<H0 and not seen[ny][nx] and is_canopy(G[nx][ny]):
                    seen[ny][nx]=True; stack.append((nx,ny))
        xs=[c[0] for c in comp]; ys=[c[1] for c in comp]
        x0,y0=min(xs),min(ys); w=max(xs)-x0+1; h=max(ys)-y0+1
        blocked=sum(1 for cx,cy in comp if COLL[cx][cy]!=0)
        can=sum(1 for cx,cy in comp if is_canopy(G[cx][cy]))
        objs.append({'w':w,'h':h,'n':len(comp),'blocked':blocked,'canopy':round(can/len(comp),2),
            'at':[x0,y0],'cells':[[cx-x0,cy-y0,G[cx][cy],COLL[cx][cy]] for cx,cy in comp]})
trees=[o for o in objs if o['n']>=4 and o['canopy']>=0.6 and o['blocked']>=1]
print("canopy objs:",len(objs)," trees:",len(trees))
for o in sorted(trees,key=lambda o:-o['n'])[:28]:
    print(f"  at={o['at']} {o['w']}x{o['h']} n={o['n']} blk={o['blocked']} canopy={o['canopy']}")
json.dump(trees, open('/tmp/mt_trees.json','w'))
