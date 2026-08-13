#!/usr/bin/env python3
"""Multi-objective quality analysis and local repair guidance."""
from __future__ import annotations
from collections import Counter,deque
from statistics import mean,pstdev
from .model import FloorPlan
def _neighbors(x,y,w,h):
 for nx,ny in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
  if 0<=nx<w and 0<=ny<h:yield nx,ny
def _walkable(plan):return {(x,y) for y in range(plan.height) for x in range(plan.width) if plan.get(x,y)!='wall'}
def _bfs(plan,start):
 dist={start:0};q=deque([start])
 while q:
  x,y=q.popleft()
  for p in _neighbors(x,y,plan.width,plan.height):
   if p not in dist and plan.get(*p)!='wall':dist[p]=dist[(x,y)]+1;q.append(p)
 return dist
def _longest_straight(plan):
 best=0
 for y in range(plan.height):
  run=0
  for x in range(plan.width):
   run=run+1 if plan.get(x,y)=='corridor' else 0;best=max(best,run)
 for x in range(plan.width):
  run=0
  for y in range(plan.height):
   run=run+1 if plan.get(x,y)=='corridor' else 0;best=max(best,run)
 return best
def evaluate(plan:FloorPlan,visual_compatibility:float=1.0):
 walk=_walkable(plan);dist=_bfs(plan,tuple(plan.entrance));accessible=len(dist)/max(1,len(walk));exit_distance=dist.get(tuple(plan.exit),0);room_sizes=[sum(sum(r) for r in room.cells) for room in plan.rooms];variety=min(1,(len(set(room_sizes))/max(3,len(room_sizes)))*2+(pstdev(room_sizes)/max(1,mean(room_sizes)) if len(room_sizes)>1 else 0)*.35);edges=len(plan.edges);loops=max(0,edges-len(plan.rooms)+1);loop_score=min(1,loops/max(1,len(plan.rooms)//4));straight=_longest_straight(plan);corridor_score=max(0,1-straight/max(12,plan.width*.45));sym_diff=0
 for y in range(plan.height):
  for x in range(plan.width//2):sym_diff+=plan.get(x,y)!=plan.get(plan.width-1-x,y)
 asymmetry=min(1,sym_diff/max(1,plan.height*plan.width//2));deco=len(plan.decorations);quadrants=Counter((d['x']>=plan.width/2,d['y']>=plan.height/2) for d in plan.decorations);concentration=0 if not deco else max(quadrants.values(),default=0)/deco;deco_balance=max(0,1-(concentration-.25)/.75);critical_clear=all(not(d['x']==p[0] and d['y']==p[1] and d.get('blocking')) for d in plan.decorations for p in (plan.entrance,plan.exit));poi_clear=all(plan.get(*p['position'])!='wall' for p in plan.points_of_interest);density=len(walk)/(plan.width*plan.height);density_target=.28 if plan.archetype=='labyrinth' else .42 if plan.archetype=='open' else .34;density_score=max(0,1-abs(density-density_target)/.35);path_score=min(1,exit_distance/max(1,(plan.width+plan.height)*.55));readability=(accessible*.45+corridor_score*.25+density_score*.2+(1 if critical_clear and poi_clear else 0)*.1);spatial=variety*.28+loop_score*.22+asymmetry*.15+path_score*.2+density_score*.15;aesthetic=deco_balance*.35+visual_compatibility*.4+max(0,1-abs(len(plan.decorations)/max(1,len(walk))-.06)/.12)*.25;score=100*(readability*.38+spatial*.37+aesthetic*.25);violations=[]
 if accessible<1:violations.append({'code':'DISCONNECTED','severity':1-accessible,'repair':'connect_components'})
 if straight>max(14,int(plan.width*.34)):violations.append({'code':'LONG_CORRIDOR','severity':straight/plan.width,'repair':'break_corridor'})
 if variety<.42:violations.append({'code':'LOW_ROOM_VARIETY','severity':1-variety,'repair':'reshape_room'})
 if loop_score<.35 and plan.archetype not in ('linear','arena'):violations.append({'code':'TOO_LINEAR','severity':1-loop_score,'repair':'add_loop'})
 if asymmetry<.18 and plan.special not in ('boss',):violations.append({'code':'ACCIDENTAL_SYMMETRY','severity':1-asymmetry,'repair':'asymmetric_alcove'})
 if concentration>.62 and deco>5:violations.append({'code':'DECOR_CONCENTRATION','severity':concentration,'repair':'redistribute_decor'})
 if not critical_clear or not poi_clear:violations.append({'code':'BLOCKED_CRITICAL_POINT','severity':1,'repair':'clear_critical'})
 metrics={'accessibility':accessible,'exit_distance':exit_distance,'room_variety':variety,'loop_score':loop_score,'longest_straight_corridor':straight,'asymmetry':asymmetry,'walkable_density':density,'decoration_balance':deco_balance,'readability':readability,'spatial_quality':spatial,'aesthetic_quality':aesthetic,'visual_compatibility':visual_compatibility,'score':score}
 return {'accepted':score>=72 and not any(x['code'] in ('DISCONNECTED','BLOCKED_CRITICAL_POINT') for x in violations),'score':round(score,3),'metrics':{k:round(v,4) if isinstance(v,float) else v for k,v in metrics.items()},'violations':violations}
