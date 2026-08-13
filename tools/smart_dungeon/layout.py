#!/usr/bin/env python3
"""Hierarchical architecture planning, candidate search and localized repair."""
from __future__ import annotations
import copy,hashlib,math,random
from collections import defaultdict,deque
from .model import DesignBrief,FloorPlan,Room
from .quality import evaluate
def stable_seed(*parts):return int.from_bytes(hashlib.sha256('|'.join(map(str,parts)).encode()).digest()[:8],'little')&0x7fffffff
def _phase(i,n):
 p=i/max(1,n-1)
 return 'introduction' if p<.18 else 'development' if p<.48 else 'escalation' if p<.78 else 'climax' if p<.96 else 'finale'
def schedule(brief:DesignBrief):
 n=brief.floors;special={}
 if brief.boss:special[n]='boss'
 mini=[]
 for k in range(brief.mini_bosses):
  target=round(n*(k+1)/(brief.mini_bosses+1));target=max(3,min(n-2,target+(1 if k%2 else -1)));mini.append(target);special[target]='mini_boss'
 # Relays follow intensity peaks and avoid mechanical fixed intervals.
 candidates=[]
 if brief.relays:
  anchors=[.22,.48,.73,.88]
  for k in range(brief.relays):
   target=round(n*anchors[k%len(anchors)])+(k//len(anchors));
   while target in special and target<n-1:target+=1
   candidates.append(max(2,min(n-1,target)));special[candidates[-1]]='relay'
 if brief.boss and 'preboss_calm' in brief.constraints and n-1 not in special:special[n-1]='calm'
 return special,mini,candidates
def progression(brief):
 special,_,_=schedule(brief);rows=[]
 for f in range(1,brief.floors+1):
  p=(f-1)/max(1,brief.floors-1);complexity=.25+.58*p;density=brief.decoration_bias*(.72+.38*p);danger=brief.danger_bias*(.7+.5*p);phase=_phase(f-1,brief.floors);sp=special.get(f)
  if sp=='relay' or sp=='calm':complexity*=.65;density*=.72;danger*=.45
  elif sp=='mini_boss':complexity=.72;density=.4;danger=min(1,danger+.22)
  elif sp=='boss':complexity=.8;density=.32;danger=1
  archetype='arena' if sp in ('boss','mini_boss') else 'refuge' if sp in ('relay','calm') else 'open' if p<.25 and brief.topology_start=='open' else 'labyrinth' if p>.55 and brief.topology_end=='labyrinth' else ['loops','irregular','central','branching'][f%4]
  rows.append({'floor':f,'phase':phase,'special':sp,'archetype':archetype,'complexity':round(complexity,3),'decoration_density':round(min(1,density),3),'danger':round(min(1,danger),3),'mood':brief.mood_start if p<.35 else brief.mood_end if p>.7 else 'transition'})
 return rows
def _overlap(a,b,pad=2):return not(a[0]+a[2]+pad<=b[0] or b[0]+b[2]+pad<=a[0] or a[1]+a[3]+pad<=b[1] or b[1]+b[3]+pad<=a[1])
def _shape(kind,w,h,rng):
 cells=[[1]*w for _ in range(h)]
 if kind=='irregular' and w>5 and h>5:
  for _ in range(max(1,(w+h)//5)):
   corner=rng.randrange(4);cw=rng.randint(1,max(1,w//3));ch=rng.randint(1,max(1,h//3))
   xs=range(cw) if corner%2==0 else range(w-cw,w);ys=range(ch) if corner<2 else range(h-ch,h)
   for y in ys:
    for x in xs:cells[y][x]=0
 elif kind=='round':
  cx,cy=(w-1)/2,(h-1)/2
  for y in range(h):
   for x in range(w):cells[y][x]=int(((x-cx)/(w/2))**2+((y-cy)/(h/2))**2<=1.05)
 elif kind=='cross' and w>6 and h>6:
  for y in range(h):
   for x in range(w):cells[y][x]=int(abs(x-w//2)<=max(1,w//4) or abs(y-h//2)<=max(1,h//4))
 return cells
def _carve_room(plan,room):
 for ry,row in enumerate(room.cells):
  for rx,v in enumerate(row):
   if v and 0<room.x+rx<plan.width-1 and 0<room.y+ry<plan.height-1:plan.set(room.x+rx,room.y+ry,'room')
def _center(r):return [r.x+r.width//2,r.y+r.height//2]
def _corridor(plan,a,b,rng):
 ax,ay=a;bx,by=b;points=[(ax,ay)];horizontal_first=rng.random()<.5
 if horizontal_first:
  bendx=max(1,min(plan.width-2,round((ax+bx)/2)+rng.randint(-3,3)));points += [(bendx,ay),(bendx,by),(bx,by)]
 else:
  bendy=max(1,min(plan.height-2,round((ay+by)/2)+rng.randint(-3,3)));points += [(ax,bendy),(bx,bendy),(bx,by)]
 for (x1,y1),(x2,y2) in zip(points,points[1:]):
  x,y=x1,y1;dx=1 if x2>x else -1 if x2<x else 0;dy=1 if y2>y else -1 if y2<y else 0
  while (x,y)!=(x2,y2):
   if plan.get(x,y)=='wall':plan.set(x,y,'corridor')
   x+=dx;y+=dy
  if plan.get(x,y)=='wall':plan.set(x,y,'corridor')
def _graph(rooms,rng,loop_factor):
 centers={r.room_id:_center(r) for r in rooms};pairs=[]
 for i,a in enumerate(rooms):
  for b in rooms[i+1:]:pairs.append((math.dist(centers[a.room_id],centers[b.room_id]),a.room_id,b.room_id))
 parent={r.room_id:r.room_id for r in rooms}
 def find(x):
  while parent[x]!=x:parent[x]=parent[parent[x]];x=parent[x]
  return x
 edges=[]
 for _,a,b in sorted(pairs):
  ra,rb=find(a),find(b)
  if ra!=rb:parent[ra]=rb;edges.append([a,b])
 extra=max(0,round(len(rooms)*loop_factor));remaining=[list(x[1:]) for x in sorted(pairs) if list(x[1:]) not in edges and list(reversed(x[1:])) not in edges];rng.shuffle(remaining);edges+=remaining[:extra];return edges
def _decorate(plan,rng,assets,density):
 walk=[(x,y) for y in range(1,plan.height-1) for x in range(1,plan.width-1) if plan.get(x,y) in ('room','corridor')];critical={tuple(plan.entrance),tuple(plan.exit)};roles=assets or {'common':['generic_common'],'secondary':['generic_secondary'],'focal':['generic_focal'],'rare':['generic_rare']};target=round(len(walk)*(.025+.075*density));placed=[]
 def near_wall(p):return sum(plan.get(nx,ny)=='wall' for nx,ny in ((p[0]+1,p[1]),(p[0]-1,p[1]),(p[0],p[1]+1),(p[0],p[1]-1)))
 candidates=[p for p in walk if p not in critical and all(abs(p[0]-q[0])+abs(p[1]-q[1])>2 for q in critical)];rng.shuffle(candidates)
 focal_count=1 if plan.special in ('boss','mini_boss') or plan.archetype=='central' else 0
 for i,p in enumerate(candidates):
  if len(placed)>=target:break
  if any(abs(p[0]-d['x'])+abs(p[1]-d['y'])<2 for d in placed):continue
  wall=near_wall(p);hierarchy='focal' if focal_count and not any(d['hierarchy']=='focal' for d in placed) and wall==0 else 'rare' if rng.random()<.04 else 'secondary' if rng.random()<.25 else 'common'
  if hierarchy in ('common','secondary') and wall==0 and rng.random()<.65:continue
  pool=roles.get(hierarchy) or roles.get('common') or ['generic'];placed.append({'x':p[0],'y':p[1],'asset_id':pool[len(placed)%len(pool)],'hierarchy':hierarchy,'blocking':False,'placement_rule':'focal_open_space' if hierarchy=='focal' else 'near_wall_or_corner' if wall else 'open_accent'})
 plan.decorations=placed
def make_candidate(brief,row,seed,asset_roles,locked=None):
 rng=random.Random(seed);special=row['special'];arche=row['archetype'];width=54+rng.randrange(-5,8);height=40+rng.randrange(-4,7)
 if arche=='open':width+=8;height+=5
 if arche=='arena':width=48;height=38
 tiles=['wall']*(width*height);plan=FloorPlan(row['floor'],seed,width,height,arche,row['phase'],special,brief.theme_tokens[(row['floor']-1)%len(brief.theme_tokens)] if brief.theme_tokens else 'principal',[],[],tiles,[2,height//2],[width-3,height//2]);count=7+round(row['complexity']*8)
 if arche=='arena':count=5
 if arche=='refuge':count=6
 rects=[];room_kinds=['rect','irregular','round','cross']
 for i in range(count):
  if arche=='arena' and i==0:w,h=22,18;kind='round'
  elif arche=='central' and i==0:w,h=18,14;kind='irregular'
  else:
   scale=1.35 if rng.random()<.22 else .72 if rng.random()<.25 else 1;w=max(5,round(rng.randint(6,12)*scale));h=max(5,round(rng.randint(5,10)*scale));kind=rng.choice(room_kinds if row['complexity']>.45 else room_kinds[:2])
  placed=None
  for _ in range(100):
   x=rng.randint(2,max(2,width-w-3));y=rng.randint(2,max(2,height-h-3));r=(x,y,w,h)
   if not any(_overlap(r,q,1) for q in rects):placed=r;break
  if not placed:continue
  x,y,w,h=placed;rects.append(placed);plan.rooms.append(Room(len(plan.rooms),kind,x,y,w,h,_shape(kind,w,h,rng),1.0 if i==0 and arche in ('arena','central') else .3,False,['landmark'] if i==0 and arche in ('arena','central') else []))
 if len(plan.rooms)<4:return make_candidate(brief,row,seed+991,asset_roles,locked)
 for r in plan.rooms:_carve_room(plan,r)
 loop_factor=.06 if arche=='linear' else .35 if arche in ('loops','open') else .18;plan.edges=_graph(plan.rooms,rng,loop_factor)
 by={r.room_id:r for r in plan.rooms}
 for a,b in plan.edges:_corridor(plan,_center(by[a]),_center(by[b]),rng)
 centers=[_center(r) for r in plan.rooms];plan.entrance=min(centers,key=lambda p:p[0]);dist=lambda p:abs(p[0]-plan.entrance[0])+abs(p[1]-plan.entrance[1]);plan.exit=max(centers,key=dist)
 if special:plan.points_of_interest.append({'kind':special,'position':_center(plan.rooms[0]),'importance':1.0,'locked':False})
 if 'central_landmark' in brief.constraints and not plan.points_of_interest:plan.points_of_interest.append({'kind':'landmark','position':_center(max(plan.rooms,key=lambda r:r.width*r.height)),'importance':.85,'locked':False})
 _decorate(plan,rng,asset_roles,row['decoration_density']);return plan
def _connect_components(plan,rng):
 walk={(x,y) for y in range(plan.height) for x in range(plan.width) if plan.get(x,y)!='wall'};components=[]
 while walk:
  start=next(iter(walk));seen={start};q=deque([start])
  while q:
   x,y=q.popleft()
   for p in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
    if p in walk and p not in seen:seen.add(p);q.append(p)
  components.append(seen);walk-=seen
 if len(components)>1:
  a=min(components[0],key=lambda p:math.dist(p,next(iter(components[1]))));b=min(components[1],key=lambda p:math.dist(p,a));_corridor(plan,a,b,rng)
def repair(plan,report,rng):
 for violation in sorted(report['violations'],key=lambda x:x['severity'],reverse=True):
  action=violation['repair'];detail={}
  if action=='connect_components':_connect_components(plan,rng)
  elif action=='add_loop' and len(plan.rooms)>3:
   existing={tuple(sorted(x)) for x in plan.edges};pairs=[(math.dist(_center(a),_center(b)),a,b) for a in plan.rooms for b in plan.rooms if a.room_id<b.room_id and (a.room_id,b.room_id) not in existing]
   if pairs:
    _,a,b=min(pairs);plan.edges.append([a.room_id,b.room_id]);_corridor(plan,_center(a),_center(b),rng);detail={'rooms':[a.room_id,b.room_id]}
  elif action in ('break_corridor','asymmetric_alcove'):
   candidates=[(x,y) for y in range(3,plan.height-4) for x in range(3,plan.width-4) if plan.get(x,y)=='corridor'];
   if candidates:
    x,y=rng.choice(candidates);side=rng.choice((-1,1));x0=x+1 if side>0 else x-3;x1=x+4 if side>0 else x
    for yy in range(max(1,y-2),min(plan.height-1,y+3)):
     for xx in range(max(1,x0),min(plan.width-1,x1)):plan.set(xx,yy,'room')
    detail={'origin':[x,y]}
  elif action=='reshape_room' and plan.rooms:
   r=rng.choice([x for x in plan.rooms if not x.locked]);
   for y in range(max(1,r.y-1),min(plan.height-1,r.y+r.height+1)):
    for x in range(max(1,r.x-1),min(plan.width-1,r.x+r.width+1)):
     if rng.random()<.6:plan.set(x,y,'room')
   detail={'room':r.room_id}
  elif action=='redistribute_decor':rng.shuffle(plan.decorations);plan.decorations=plan.decorations[::2]
  elif action=='clear_critical':
   critical={tuple(plan.entrance),tuple(plan.exit)}|{tuple(x['position']) for x in plan.points_of_interest};plan.decorations=[x for x in plan.decorations if (x['x'],x['y']) not in critical]
  plan.repair_log.append({'violation':violation['code'],'action':action,'localized':True,**detail})
 return plan
def select_best(brief,row,base_seed,asset_roles,variants=6,repairs=8,locks=None):
 results=[]
 for v in range(variants):
  seed=stable_seed(base_seed,row['floor'],v);plan=make_candidate(brief,row,seed,asset_roles,locks);report=evaluate(plan)
  for _ in range(repairs):
   if report['accepted']:break
   plan=repair(plan,report,random.Random(stable_seed(seed,'repair',len(plan.repair_log))));report=evaluate(plan)
  plan.quality=report;results.append(plan)
 return max(results,key=lambda x:x.quality['score']),[{'seed':x.seed,'score':x.quality['score'],'accepted':x.quality['accepted'],'violations':[v['code'] for v in x.quality['violations']]} for x in results]
