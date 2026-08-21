#!/usr/bin/env python3
"""Render inspectable startup/first-published contact sheets for a material candidate."""
import argparse,json,math
from pathlib import Path
from PIL import Image
from validate_sinister_woods_b41_material import read_tile,get_frame

def compose(layers,images,sheet,index):
 out=Image.new('RGBA',(24,24),(0,0,0,0))
 for layer in layers:
  frame=min(index,len(layer['Frames'])-1);out.alpha_composite(get_frame(layer,images,sheet,frame))
 return out

def main():
 p=argparse.ArgumentParser();p.add_argument('candidate',type=Path);p.add_argument('output',type=Path);a=p.parse_args();m=json.loads((a.candidate/'manifest.json').read_text());ns=m['namespace'];sheet=ns['sheet'];images=read_tile(a.candidate/f'Content/Tile/{sheet}.tile');a.output.mkdir(parents=True,exist_ok=False);records=[]
 for category,filename in ns['autotile_files'].items():
  data=json.loads((a.candidate/'Data/AutoTile'/filename).read_text())['Object']['Tiles'];keys=[k for k in data if k.startswith('Tilex')]
  for phase,index in [('startup',0),('first_published',1)]:
   cols=8;rows=math.ceil(len(keys)/cols);canvas=Image.new('RGBA',(cols*72,rows*24),(0,0,0,0))
   for pos,key in enumerate(keys):
    for vi,layers in enumerate(data[key]):canvas.alpha_composite(compose(layers,images,sheet,index),((pos%cols)*72+vi*24,(pos//cols)*24))
   out=a.output/f'{category}_{phase}.png';canvas.save(out);records.append({'category':category,'phase':phase,'path':out.name,'width':canvas.width,'height':canvas.height})
 (a.output/'manifest.json').write_text(json.dumps({'schema':'pmdred-material-contact-sheet-v1','candidate':str(a.candidate),'sheet':sheet,'renders':records},indent=2)+'\n');print(a.output)
if __name__=='__main__':main()
