#!/usr/bin/env python3
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
required={'d09p03':('Moltres','TeleportTo','WaitShowTitle'),'d10p03':('Articuno','TeleportTo','WaitShowTitle'),'d11p03':('Ninetales','TeleportTo','NinetalesTestimony')}
errors=[]
for sid,tokens in required.items():
 p=ROOT/f'Data/Script/halcyon/arc_fugitif/scene/{sid}.lua';s=p.read_text()
 for t in tokens:
  if t not in s:errors.append(f'{sid}: token narratif absent {t}')
 if 'SCENE_'+sid.upper() in s:errors.append(f'{sid}: ancien déversement de clés non adapté encore présent')
 if 'GAME:CutsceneMode(true)' not in s or 'GAME:CutsceneMode(false)' not in s:errors.append(f'{sid}: mode cinématique non équilibré')
print('AUDIT CINEMATIQUES RED ENRICHIES')
print(f'{len(required)} scènes; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
