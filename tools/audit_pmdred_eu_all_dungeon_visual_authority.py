#!/usr/bin/env python3
"""Inventory canonical music selectors and dungeon-material tilesets for EU Red."""
from __future__ import annotations
import argparse, hashlib, json, re, subprocess
from pathlib import Path
from audit_pmdred_eu_rom import parse_dungeon_floor_counts
from pmdred_dungeon_ground import DungeonArchive, parse_french_dungeon_names, parse_mapparam
from render_pmdred_music import parse_ogg
ROM_SHA256="0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PRET_COMMIT="bf0092d0e34fd8e49b859a0b5f96f00740faa42d"

def enum_values(text:str)->dict[str,int]:
 body=re.search(r'enum MusicID\s*\{(.*?)\};',text,re.S).group(1)
 body=re.sub(r'//.*','',body);result={};value=0
 for raw in body.split(','):
  token=raw.strip()
  if not token:continue
  if '=' in token:
   name,rhs=map(str.strip,token.split('=',1));value=int(rhs,0)
  else:name=token
  result[name]=value;value+=1
 return result

def music_table(pret:Path)->tuple[list[str],dict[str,int]]:
 config=(pret/'src/dungeon_config.c').read_text(); block=re.search(r'const s16 gDungeonMusic\[76\]\s*=\s*\{(.*?)\};',config,re.S).group(1);block=re.sub(r'//.*','',block)
 names=[x.strip() for x in block.split(',') if x.strip()]
 values=enum_values((pret/'include/constants/bg_music.h').read_text())
 if len(names)!=76:raise ValueError(len(names))
 return names,values

def exact_music(content:Path)->dict[int,list[dict]]:
 result={}
 for p in sorted(content.glob('*.ogg')):
  try: samples,comments=parse_ogg(p)
  except Exception:continue
  if comments.get('SOURCE_ROM_SHA256')!=ROM_SHA256:continue
  try:index=int(comments['M4A_SONG_TABLE_INDEX'])
  except (KeyError,ValueError):continue
  result.setdefault(index,[]).append({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'samples':samples,'title':comments.get('TITLE'),'loop_start':comments.get('LOOPSTART'),'loop_length':comments.get('LOOPLENGTH')})
 return result

def build(rom_path:Path,pret:Path,content:Path)->dict:
 rom=rom_path.read_bytes()
 if len(rom)!=33554432 or hashlib.sha256(rom).hexdigest()!=ROM_SHA256:raise ValueError('ROM identity')
 head=subprocess.check_output(['git','-C',str(pret),'rev-parse','HEAD'],text=True).strip()
 if head!=PRET_COMMIT:raise ValueError('pret identity')
 counts=parse_dungeon_floor_counts(rom);parsed=parse_mapparam(DungeonArchive(rom),counts);names=parse_french_dungeon_names(rom);table,songs=music_table(pret);exact=exact_music(content)
 records=[]
 for did in range(64):
  rows=parsed['selectors'][did]['rows'][1:];floors=[]
  for i,row in enumerate(rows,1):
   prop=parsed['properties'][row['property_index']];selector=prop['music'];symbol=table[selector];song=songs[symbol]
   floors.append({'floor':i,'property_index':row['property_index'],'music_selector':selector,'music_symbol':symbol,'m4a_song_index':song,'tileset_id':prop['tileset'],'layout':prop['layout']})
  records.append({'dungeon_id':did,'name_fr':names[did]['primary'],'playable_floor_count':len(rows),'music_selectors':sorted({x['music_selector'] for x in floors}),'m4a_song_indices':sorted({x['m4a_song_index'] for x in floors}),'tileset_ids':sorted({x['tileset_id'] for x in floors}),'floors':floors})
 unique_songs=sorted({x for r in records for x in r['m4a_song_indices']});unique_tiles=sorted({x for r in records for x in r['tileset_ids']})
 return {'schema':'new-era.pmdred-eu-all-dungeon-visual-authority.v1','authority':{'rom_sha256':ROM_SHA256,'pret_commit':PRET_COMMIT,'pret_role':'symbol names and gDungeonMusic structure only'},'summary':{'dungeon_count':64,'floor_count':sum(r['playable_floor_count'] for r in records),'unique_music_song_indices':unique_songs,'unique_music_count':len(unique_songs),'unique_tileset_ids':unique_tiles,'unique_tileset_count':len(unique_tiles),'exact_rom_ogg_song_indices_present':sorted(set(unique_songs)&set(exact)),'exact_rom_ogg_song_indices_missing':sorted(set(unique_songs)-set(exact))},'exact_music_assets':{str(k):v for k,v in exact.items() if k in unique_songs},'dungeons':records,'validation':{'all_floor_rows_accounted':True,'all_music_selectors_resolved':True,'all_tileset_ids_recorded':True,'status':'PASS'}}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('rom',type=Path);ap.add_argument('--pret-root',type=Path,required=True);ap.add_argument('--content-music',type=Path,default=Path('Content/Music'));ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
 if a.output.exists():raise FileExistsError(a.output)
 d=build(a.rom,a.pret_root,a.content_music);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n');print('ALL_DUNGEON_VISUAL_AUTHORITY_PASS',d['summary']);return 0
if __name__=='__main__':raise SystemExit(main())
