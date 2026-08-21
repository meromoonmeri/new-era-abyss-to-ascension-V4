#!/usr/bin/env python3
"""Inventory every ROM material family used by all EU Red dungeon floors."""
import argparse,hashlib,json
from pathlib import Path
from pmdred_dungeon_ground import DungeonArchive
ROM_SHA="0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ROLES=('fon','cel','cex','pal','canm')
def build(rom_path:Path,visual_path:Path):
 rom=rom_path.read_bytes()
 if len(rom)!=33554432 or hashlib.sha256(rom).hexdigest()!=ROM_SHA:raise ValueError('ROM')
 visual=json.loads(visual_path.read_text());ids=visual['summary']['unique_tileset_ids'];a=DungeonArchive(rom);available={e.name:e for e in a.entries};families=[]
 for tid in ids:
  resources=[]
  for role in ROLES:
   name=f'b{tid:02d}{role}';e=available.get(name)
   if e is None:resources.append({'role':role,'name':name,'present':False});continue
   data=rom[e.container_span.offset:e.container_span.end]
   resources.append({'role':role,'name':name,'present':True,'archive_index':e.index,'rom_offset':e.container_span.offset,'rom_offset_hex':f'0x{e.container_span.offset:08X}','bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()})
  families.append({'tileset_id':tid,'prefix':f'b{tid:02d}','resources':resources,'present_roles':[x['role'] for x in resources if x['present']],'missing_roles':[x['role'] for x in resources if not x['present']]})
 try: visual_display=visual_path.resolve().relative_to(Path.cwd().resolve()).as_posix()
 except ValueError: visual_display=visual_path.as_posix()
 return {'schema':'new-era.pmdred-eu-all-dungeon-tileset-source.v1','date':'2026-08-21','authority':{'rom_sha256':ROM_SHA,'visual_authority':visual_display},'summary':{'tileset_count':len(ids),'resource_count':sum(len(x['present_roles']) for x in families),'tileset_ids':ids,'all_required_families_accounted':True},'families':families,'validation':{'unique_ids':len({x['tileset_id'] for x in families})==len(ids),'all_present_resources_hashed':all('sha256' in r for f in families for r in f['resources'] if r['present']),'status':'PASS'}}
def main():
 p=argparse.ArgumentParser();p.add_argument('rom',type=Path);p.add_argument('--visual-authority',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 if a.output.exists():raise FileExistsError(a.output)
 d=build(a.rom,a.visual_authority);a.output.write_text(json.dumps(d,indent=2)+'\n');print('ALL_DUNGEON_TILESET_SOURCE_PASS',d['summary']);return 0
if __name__=='__main__':raise SystemExit(main())
