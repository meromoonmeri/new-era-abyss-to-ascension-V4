#!/usr/bin/env python3
"""Register deterministic No Name Village packages in PMDO's binary tile index."""
import struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
NAMES=['No_Name_Village_Buildings','No_Name_Village_Buildings_Autumn','No_Name_Village_Buildings_Winter','No_Name_Village_Standalone_Tree_Spring','No_Name_Village_Standalone_Tree_Summer','No_Name_Village_Standalone_Tree_Autumn','No_Name_Village_Standalone_Tree_Winter','No_Name_Village_Flora_Spring','No_Name_Village_Flora_Summer','No_Name_Village_Flora_Autumn','No_Name_Village_Flora_Winter','No_Name_Village_Forest_Autumn','No_Name_Village_Forest_Winter']
def r7(d,o):
 v=s=0
 while True:
  b=d[o];o+=1;v|=(b&127)<<s
  if b<128:return v,o
  s+=7
def w7(v):
 out=bytearray()
 while v>=128:out.append((v&127)|128);v>>=7
 out.append(v);return out
def read(p):
 d=p.read_bytes();count=struct.unpack_from('<i',d)[0];o=4;nodes={}
 for _ in range(count):
  n,o=r7(d,o);name=d[o:o+n].decode();o+=n;c=struct.unpack_from('<i',d,o+4)[0];end=o+8+c*16;nodes[name]=d[o:end];o=end
 if o!=len(d):raise ValueError('trailing PMDO tile-index bytes')
 return nodes
def main():
 index=ROOT/'Content/Tile/index.idx';nodes=read(index)
 for name in NAMES:
  b=(ROOT/'Content/Tile'/f'{name}.tile').read_bytes();count=struct.unpack_from('<i',b,4)[0];node=b[:8+count*16]
  for i in range(count):
   off=struct.unpack_from('<Q',node,16+i*16)[0]
   if not 8+count*16<=off<=len(b)-8:raise ValueError(f'{name}: invalid payload offset {off}')
  nodes[name]=node
 out=bytearray(struct.pack('<i',len(nodes)))
 for name,node in nodes.items():e=name.encode();out+=w7(len(e))+e+node
 index.write_bytes(out);print(f'PMDO_TILE_INDEX_PASS entries={len(nodes)} generated={len(NAMES)}')
if __name__=='__main__':main()
