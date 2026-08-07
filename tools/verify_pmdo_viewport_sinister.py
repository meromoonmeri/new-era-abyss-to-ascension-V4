#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'));import render_ground
out=ROOT/'docs/renders/_viewport_d04p02.png';render_ground.render('sinister_woods_clearing',0,str(out));im=Image.open(out).convert('RGBA');px=list(im.getdata());alpha=sum(a==0 for *_,a in px);black=sum(max(r,g,b)<12 for r,g,b,a in px);out.unlink(missing_ok=True);print(f'D04P02 viewport {im.width}x{im.height}: alpha={alpha}, noir={black}');raise SystemExit(1 if im.width<640 or im.height<480 or alpha or black else 0)
