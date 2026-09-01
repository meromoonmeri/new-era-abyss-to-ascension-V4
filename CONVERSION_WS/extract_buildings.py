import json
DB=json.load(open('/tmp/mt_db.json'))
W0,H0=DB['W'],DB['H']
G=DB['grid']; COLLG=DB['coll']; INFO=DB['info']
def green(h):
    a=INFO[h]['avg']; return a[1]>=a[0] and a[1]>=a[2]
seen=[[False]*H0 for _ in range(W0)]
buildings=[]
for x0 in range(W0):
    for y0 in range(H0):
        if seen[x0][y0] or COLLG[x0][y0]==0: continue
        stack=[(x0,y0)]; seen[x0][y0]=True; comp=[]
        while stack:
            cx,cy=stack.pop(); comp.append((cx,cy))
            for dx,dy in ((-1,0),(1,0),(0,-1),(0,1)):
                nx,ny=cx+dx,cy+dy
                if 0<=nx<W0 and 0<=ny<H0 and not seen[nx][ny] and COLLG[nx][ny]!=0:
                    seen[nx][ny]=True; stack.append((nx,ny))
        if len(comp)<30: continue
        grn=sum(1 for cx,cy in comp if green(G[cx][cy]))
        if grn/len(comp)>=0.5: continue
        xs=[c[0] for c in comp]; ys=[c[1] for c in comp]
        bx0,by0=min(xs),min(ys); w=max(xs)-bx0+1; h=max(ys)-by0+1
        buildings.append({'w':w,'h':h,'n':len(comp),'green_ratio':round(grn/len(comp),2),'at':[bx0,by0],
            'cells':[[cx-bx0,cy-by0,G[cx][cy],COLLG[cx][cy]] for cx,cy in comp]})
json.dump(buildings, open('/tmp/mt_buildings.json','w'))
print("buildings extracted:", len(buildings))
