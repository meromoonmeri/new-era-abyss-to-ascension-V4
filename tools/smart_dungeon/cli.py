#!/usr/bin/env python3
"""Command-line interface for Smart Dungeon Designer."""
from __future__ import annotations
import argparse,json,sys
from pathlib import Path
from .assets import analyze_library
from .project import generate_project,read,regenerate,validate_project,write
from .runtime import validate_runtime_index
def parser():
 p=argparse.ArgumentParser(prog='smart-dungeon',description='Level designer procédural intelligent PMDO/RogueElements');p.add_argument('--repo',type=Path,default=Path.cwd());sub=p.add_subparsers(dest='command',required=True)
 a=sub.add_parser('analyze-assets',help='Analyse sémantiquement la bibliothèque disponible');a.add_argument('--output',type=Path,required=True);a.add_argument('--overrides',type=Path);a.add_argument('--max-sheets',type=int,default=0);a.add_argument('--max-grounds',type=int,default=96);a.add_argument('--samples',type=int,default=24)
 c=sub.add_parser('create',help='Crée un donjon complet depuis une intention naturelle');c.add_argument('--project',type=Path,required=True);c.add_argument('--name',required=True);c.add_argument('--intent',required=True);c.add_argument('--floors',type=int);c.add_argument('--difficulty');c.add_argument('--boss',action=argparse.BooleanOptionalAction,default=None);c.add_argument('--mini-bosses',type=int);c.add_argument('--relays',type=int);c.add_argument('--seed',type=int);c.add_argument('--reference-zone');c.add_argument('--variants',type=int,default=6);c.add_argument('--max-assets',type=int,default=0)
 r=sub.add_parser('regenerate',help='Régénère tout ou seulement une partie');r.add_argument('--project',type=Path,required=True);r.add_argument('--scope',default='all',help='all, floor:N, room:N:M ou decor:N');r.add_argument('--seed',type=int);r.add_argument('--force-unlock',action='store_true');r.add_argument('--variants',type=int,default=6)
 v=sub.add_parser('validate',help='Réévalue la qualité et le ZoneData');v.add_argument('--project',type=Path,required=True);v.add_argument('--output',type=Path)
 rv=sub.add_parser('runtime-index',help='Valide le ZoneData dans PMDO 0.8.12 exact');rv.add_argument('--project',type=Path,required=True)
 l=sub.add_parser('lock',help='Verrouille/déverrouille un étage ou une salle');l.add_argument('--project',type=Path,required=True);l.add_argument('--floor',type=int,required=True);l.add_argument('--room',type=int);l.add_argument('--unlock',action='store_true')
 o=sub.add_parser('override-asset',help='Corrige une classification apprise');o.add_argument('--project',type=Path,required=True);o.add_argument('--asset',required=True);o.add_argument('--role',choices=['floor','wall','border','structure','decoration','hazard','water','transition','focal']);o.add_argument('--tags',nargs='*');o.add_argument('--rarity',type=float)
 e=sub.add_parser('explain-assets',help='Affiche pourquoi les assets ont été classés');e.add_argument('--project',type=Path,required=True);e.add_argument('--query',default='');e.add_argument('--limit',type=int,default=20)
 return p
def main(argv=None):
 p=parser();a=p.parse_args(argv);repo=a.repo.resolve()
 if a.command=='analyze-assets':result=analyze_library(repo,a.output,a.overrides,a.max_sheets,a.max_grounds,a.samples);summary={k:result[k] for k in ('result','asset_count','ground_sheet_count','dungeon_texture_bundle_count','cluster_count')}
 elif a.command=='create':
  result=generate_project(repo,a.project,a.name,a.intent,a.floors,a.difficulty,a.boss,a.mini_bosses,a.relays,a.seed,a.reference_zone,a.variants,a.max_assets);summary={'result':'SMART_DUNGEON_GENERATION_PASS','project':str(a.project),'seed':result.brief.seed,'floors':len(result.floors),'mean_score':result.quality_summary['mean_score'],'zone':result.compiler['zone_file']}
 elif a.command=='regenerate':
  result=regenerate(repo,a.project,a.scope,a.seed,a.force_unlock,a.variants);summary={'result':'SMART_DUNGEON_REGENERATION_PASS','scope':a.scope,'seed':result.brief.seed,'mean_score':result.quality_summary['mean_score']}
 elif a.command=='validate':
  summary=validate_project(a.project);write(a.output or a.project/'validation_report.json',summary)
 elif a.command=='runtime-index':summary=validate_runtime_index(repo,a.project)
 elif a.command=='lock':
  path=a.project/'locks.json';data=read(path,{'floors':{},'regions':[]});f=data.setdefault('floors',{}).setdefault(str(a.floor),{});f['locked']=not a.unlock
  if a.room is not None:f.setdefault('rooms',{})[str(a.room)]={'locked':not a.unlock}
  write(path,data);summary={'result':'LOCK_UPDATED','floor':a.floor,'room':a.room,'locked':not a.unlock}
 elif a.command=='override-asset':
  path=a.project/'asset_overrides.json';data=read(path,{'assets':{},'visual_language':{}});row=data.setdefault('assets',{}).setdefault(a.asset,{})
  if a.role:row['role']=a.role
  if a.tags is not None:row['tags']=a.tags
  if a.rarity is not None:row['rarity']=max(0,min(1,a.rarity))
  write(path,data);summary={'result':'ASSET_OVERRIDE_UPDATED','asset':a.asset,'override':row}
 else:
  data=read(a.project/'asset_catalog.json',{'assets':[]});q=a.query.casefold();rows=[x for x in data['assets'] if q in x['asset_id'].casefold()][:a.limit];summary={'result':'ASSET_EXPLANATION','assets':[{'asset_id':x['asset_id'],'kind':x['kind'],'roles':sorted(x['role_scores'].items(),key=lambda z:z[1],reverse=True)[:3],'tags':x['tags'],'rarity':x['rarity'],'cluster':x['cluster_id'],'confidence':x['confidence'],'compatible':x['compatible'][:5]} for x in rows]}
 print(json.dumps(summary,ensure_ascii=False,indent=2));return 0 if not str(summary.get('result','')).endswith('FAIL') else 1
if __name__=='__main__':raise SystemExit(main())
