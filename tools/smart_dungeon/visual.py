#!/usr/bin/env python3
"""Visual-language selection and dependency-free SVG review output."""
from __future__ import annotations
import html,json,math
from collections import defaultdict
from pathlib import Path
from typing import Any
from .model import DesignBrief,FloorPlan
def select_visual_language(catalog:dict[str,Any],brief:DesignBrief,overrides:dict|None=None):
 assets=catalog.get('assets',[]);theme=set(brief.theme_tokens);clusters=defaultdict(list)
 for a in assets:clusters[a.get('cluster_id','unclustered')].append(a)
 def cluster_score(rows):
  tags={t for a in rows for t in a.get('tags',[])};token_score=len(tags&theme)*2
  name_score=sum(any(t in a['asset_id'].casefold() for t in theme) for a in rows)/max(1,len(rows));confidence=sum(a.get('confidence',0) for a in rows)/max(1,len(rows));roles={k:max((a.get('role_scores',{}).get(k,0) for a in rows),default=0) for k in ('floor','wall','decoration','focal')};coverage=sum(v>.12 for v in roles.values())
  return token_score+name_score+confidence+coverage*.35
 usable={k:v for k,v in clusters.items() if any(a.get('kind')=='ground_tile_sheet' for a in v)}
 cluster=max(usable,key=lambda k:cluster_score(usable[k])) if usable else 'unclustered';rows=usable.get(cluster,assets)
 roles={}
 for hierarchy,role in [('common','decoration'),('secondary','border'),('focal','focal'),('rare','structure')]:
  chosen=sorted(rows,key=lambda a:(a.get('role_scores',{}).get(role,0),a.get('confidence',0),a.get('detail_score',0)),reverse=True)[:8];roles[hierarchy]=[x['asset_id'] for x in chosen] or ['generic_'+hierarchy]
 bundles=[a for a in assets if a.get('kind')=='dungeon_texture_bundle']
 def bundle_score(a):
  tags=set(a.get('tags',[]));return len(tags&theme)*3+sum(t in a['asset_id'].casefold() for t in theme)+max(a.get('role_scores',{}).values(),default=0)
 bundle=max(bundles,key=bundle_score) if bundles else None
 selection={'cluster_id':cluster,'cluster_score':round(cluster_score(rows),3),'theme_tokens':sorted(theme),'roles':roles,'texture_bundle':bundle['asset_id'] if bundle else None,'texture_values':bundle['asset_id'].split(':',1)[1].split('|') if bundle else None,'asset_count':len(rows),'manual_override_applied':False}
 if overrides:
  locked=overrides.get('visual_language',{});selection.update({k:v for k,v in locked.items() if v is not None});selection['manual_override_applied']=bool(locked)
 return selection
def svg_preview(plan:FloorPlan,path:Path,cell:int=9):
 colors={'wall':'#171a20','room':'#7c8172','corridor':'#a49a7d','secret':'#4f5360'};w,h=plan.width*cell,plan.height*cell;parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">',f'<rect width="100%" height="100%" fill="#101217"/>']
 for y in range(plan.height):
  for x in range(plan.width):
   t=plan.get(x,y);parts.append(f'<rect x="{x*cell}" y="{y*cell}" width="{cell}" height="{cell}" fill="{colors.get(t,"#777")}"/>')
 for d in plan.decorations:
  color={'common':'#6b9b58','secondary':'#72a5ad','rare':'#c28bc9','focal':'#f1c75b'}.get(d['hierarchy'],'#fff');r=cell*.28;parts.append(f'<circle cx="{(d["x"]+.5)*cell}" cy="{(d["y"]+.5)*cell}" r="{r}" fill="{color}" opacity=".88"><title>{html.escape(d["asset_id"])}</title></circle>')
 for p,color,label in [(plan.entrance,'#56d3ff','Entrée'),(plan.exit,'#ffef68','Escalier')]:parts.append(f'<rect x="{p[0]*cell+1}" y="{p[1]*cell+1}" width="{cell-2}" height="{cell-2}" fill="{color}"><title>{label}</title></rect>')
 for poi in plan.points_of_interest:
  x,y=poi['position'];parts.append(f'<polygon points="{(x+.5)*cell},{y*cell} {(x+1)*cell},{(y+1)*cell} {x*cell},{(y+1)*cell}" fill="#ff685f"><title>{html.escape(poi["kind"])}</title></polygon>')
 parts.append(f'<text x="8" y="16" fill="white" font-family="sans-serif" font-size="12">Étage {plan.floor} — {html.escape(plan.archetype)} — score {plan.quality.get("score",0):.1f}</text>');parts.append('</svg>');path.parent.mkdir(parents=True,exist_ok=True);path.write_text('\n'.join(parts),encoding='utf-8')
def special_rooms_svg(plans:list[FloorPlan],path:Path):
 selected=[p for p in plans if p.special in ('relay','mini_boss','boss')]
 panel_w,panel_h,cols=390,350,3;rows=math.ceil(len(selected)/cols);parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{panel_w*cols}" height="{panel_h*rows+54}" viewBox="0 0 {panel_w*cols} {panel_h*rows+54}"><rect width="100%" height="100%" fill="#11141a"/>',f'<text x="18" y="28" fill="#f3f0df" font-family="sans-serif" font-weight="bold" font-size="19">Salles spéciales — architecture réellement sélectionnée</text>',f'<text x="18" y="47" fill="#a9b4c4" font-family="sans-serif" font-size="12">Vert = refuge/relais · rouge = combat · jaune = point focal · bleu = entrée · ivoire = escalier</text>']
 labels={'relay':'Relais / refuge','mini_boss':'Arène de mini-boss','boss':'Arène finale'}
 for i,p in enumerate(selected):
  ox=(i%cols)*panel_w;oy=54+(i//cols)*panel_h;focus=p.rooms[0];x0=max(0,focus.x-5);y0=max(0,focus.y-5);x1=min(p.width,focus.x+focus.width+5);y1=min(p.height,focus.y+focus.height+5);scale=min((panel_w-28)/(x1-x0),(panel_h-70)/(y1-y0));accent={'relay':'#62c98a','mini_boss':'#e67a64','boss':'#ff4f4f'}[p.special];parts.append(f'<rect x="{ox+5}" y="{oy+5}" width="{panel_w-10}" height="{panel_h-10}" rx="8" fill="#191d25" stroke="{accent}" stroke-width="2"/>');parts.append(f'<text x="{ox+15}" y="{oy+27}" fill="{accent}" font-family="sans-serif" font-weight="bold" font-size="15">Étage {p.floor} — {labels[p.special]}</text>');parts.append(f'<text x="{ox+15}" y="{oy+44}" fill="#b9c0ca" font-family="sans-serif" font-size="11">{focus.kind}, {focus.width}×{focus.height} · score {p.quality.get("score",0):.1f}</text>')
  bx=ox+14;by=oy+55
  for y in range(y0,y1):
   for x in range(x0,x1):
    tile=p.get(x,y);color={'wall':'#252a34','room':'#7d826f','corridor':'#b2a27c','secret':'#575d70'}.get(tile,'#555');parts.append(f'<rect x="{bx+(x-x0)*scale:.2f}" y="{by+(y-y0)*scale:.2f}" width="{scale+.15:.2f}" height="{scale+.15:.2f}" fill="{color}"/>')
  for d in p.decorations:
   if x0<=d['x']<x1 and y0<=d['y']<y1:
    color={'common':'#6ca45d','secondary':'#72acb8','rare':'#c38bcc','focal':'#f4ce63'}.get(d['hierarchy'],'#fff');parts.append(f'<circle cx="{bx+(d["x"]-x0+.5)*scale:.2f}" cy="{by+(d["y"]-y0+.5)*scale:.2f}" r="{max(1.5,scale*.22):.2f}" fill="{color}"><title>{html.escape(d["asset_id"])}</title></circle>')
  for loc,color,label in [(p.entrance,'#45bde8','Entrée'),(p.exit,'#fff0a0','Escalier')]:
   if x0<=loc[0]<x1 and y0<=loc[1]<y1:parts.append(f'<rect x="{bx+(loc[0]-x0+.15)*scale:.2f}" y="{by+(loc[1]-y0+.15)*scale:.2f}" width="{scale*.7:.2f}" height="{scale*.7:.2f}" fill="{color}"><title>{label}</title></rect>')
  for poi in p.points_of_interest:
   x,y=poi['position']
   if x0<=x<x1 and y0<=y<y1:parts.append(f'<circle cx="{bx+(x-x0+.5)*scale:.2f}" cy="{by+(y-y0+.5)*scale:.2f}" r="{max(4,scale*.42):.2f}" fill="none" stroke="{accent}" stroke-width="3"><title>{html.escape(poi["kind"])}</title></circle>')
 parts.append('</svg>');path.parent.mkdir(parents=True,exist_ok=True);path.write_text('\n'.join(parts),encoding='utf-8')
def contact_svg(plans:list[FloorPlan],path:Path):
 thumbw,thumbh=240,190;cols=4;rows=math.ceil(len(plans)/cols);parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{cols*thumbw}" height="{rows*thumbh}" viewBox="0 0 {cols*thumbw} {rows*thumbh}"><rect width="100%" height="100%" fill="#11141a"/>']
 for i,p in enumerate(plans):
  ox=(i%cols)*thumbw;oy=(i//cols)*thumbh;scale=min((thumbw-12)/p.width,(thumbh-28)/p.height)
  for y in range(p.height):
   for x in range(p.width):
    if p.get(x,y)!='wall':parts.append(f'<rect x="{ox+6+x*scale:.2f}" y="{oy+22+y*scale:.2f}" width="{scale+0.2:.2f}" height="{scale+0.2:.2f}" fill="{"#a99d7f" if p.get(x,y)=="corridor" else "#788171"}"/>')
  parts.append(f'<text x="{ox+6}" y="{oy+15}" fill="white" font-family="sans-serif" font-size="11">{p.floor:02d} {html.escape(p.archetype)} · {p.quality.get("score",0):.1f}</text>')
 parts.append('</svg>');path.parent.mkdir(parents=True,exist_ok=True);path.write_text('\n'.join(parts),encoding='utf-8')
