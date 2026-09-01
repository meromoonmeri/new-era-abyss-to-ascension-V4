"""Connectivity walkability test on the composed ground collision grid.
Free cell = coll==0. Ensures entrance spawn connects to a meaningful region."""
import json
from collections import deque
c=json.load(open('/tmp/mapa_composed.json'))
W,H=c['W'],c['H']; grid=c['c']
# spawn south marker
sx,sy=39,H-6
# find nearest free cell to spawn
def free(x,y): return 0<=x<W and 0<=y<H and grid[x][y]==0
if not free(sx,sy):
    # search nearby
    found=None
    for r in range(1,10):
        for dx in range(-r,r+1):
            for dy in range(-r,r+1):
                if free(sx+dx,sy+dy): found=(sx+dx,sy+dy);break
            if found:break
        if found:break
    sx,sy=found
# BFS
seen=set([(sx,sy)]); dq=deque([(sx,sy)])
while dq:
    x,y=dq.popleft()
    for dx,dy in ((1,0),(-1,0),(0,1),(0,-1)):
        nx,ny=x+dx,y+dy
        if free(nx,ny) and (nx,ny) not in seen:
            seen.add((nx,ny)); dq.append((nx,ny))
total_free=sum(1 for x in range(W) for y in range(H) if grid[x][y]==0)
print(f"free cells: {total_free}/{W*H} = {100*total_free/(W*H):.1f}%")
print(f"reachable from spawn: {len(seen)} = {100*len(seen)/max(total_free,1):.1f}% of free cells")
print(f"entry spawn connect: {'PASS' if len(seen)/max(total_free,1)>0.5 else 'FAIL'}")
