#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'));import render_ground
out=ROOT/'docs/renders/_verify_d04p02.png';render_ground.render('sinister_woods_clearing',0,str(out));src=Image.open(ROOT/'docs/canonical/red/final_frames/d04p02.png').convert('RGBA');full=Image.open(out).convert('RGBA');core=full.crop((80,48,80+src.width,48+src.height));bad=0;checked=0
for a,b in zip(src.getdata(),core.getdata()):
 if a[3]:
  checked+=1
  if a!=b:bad+=1
out.unlink(missing_ok=True);print(f'D04P02 cœur opaque: {bad} pixels différents sur {checked}');raise SystemExit(1 if bad else 0)
