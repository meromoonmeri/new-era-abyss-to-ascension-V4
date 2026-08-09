#!/usr/bin/env python3
import json,re,sys
from pathlib import Path
R=Path(__file__).resolve().parents[1]; problems=[]; ok=[]
def load(p):return json.load(open(R/p,encoding='utf-8-sig'))['Object']
z=load('Data/Zone/cloven_ruins.json');
if len(z.get('Segments',[]))!=8:problems.append(f'segments {len(z.get("Segments",[]))} != 8')
def nf(s):
 t=s.get('$type','');return len(s.get('Floors',[])) if 'LayeredSegment' in t else sum(n['Range']['Max']-n['Range']['Min'] for n in s.get('Floors',{}).get('nodes',[]))
expected=[3,1,3,1,4,1,5,1];actual=[nf(s) for s in z['Segments']]
if actual!=expected:problems.append(f'floor topology {actual} != {expected}')
else:ok.append('8 structures / 19 explorable units (15 mazes + 4 chambers)')
chambers=['cloven_ruin_regice_chamber_sky','cloven_ruin_regirock_chamber_sky','cloven_ruin_registeel_chamber_sky','cloven_ruin_regigigas_chamber_sky']
for g in chambers:
 p=R/f'Data/Ground/{g}.rsground'
 if not p.exists():problems.append(f'missing Ground {g}')
 else:
  o=json.load(open(p,encoding='utf-8-sig'))['Object'];
  if not o.get('Layers') or not o.get('obstacles'):problems.append(f'empty Ground {g}')
for m in ['cloven_ruins_regice','cloven_ruins_regirock','cloven_ruins_registeel','sanctuaire_titans']:
 p=R/f'Data/Map/{m}.rsmap'
 if not p.exists():problems.append(f'missing fixed map {m}')
 else:
  o=json.load(open(p,encoding='utf-8-sig'))['Object'];
  if not isinstance(o.get('ID'),int):problems.append(f'{m}: Map.ID not integer')
text=(R/'Data/Script/halcyon/zone/cloven_ruins/init.lua').read_text()
for g in chambers:
 if g not in text:problems.append(f'zone flow does not reference {g}')
rz=(R/'Data/Script/halcyon/RuinesZarbi.lua').read_text()
for word in ['GLACE','ROCHE','ACIER']:
 if word not in rz:problems.append(f'missing puzzle word {word}')
if not re.search(r'(?:DROP_CHANCE|CHANCE_PIERRE)\s*=\s*(?:33|0\.33)',rz):problems.append('Unown stone 33% drop not explicit')
for f in ['RuinesArenes.lua','RuinesTitan.lua','RuinesRenforts.lua','RuinesZarbi.lua','ClovenCanonicalChamber.lua']:
 if not (R/'Data/Script/halcyon'/f).exists():problems.append('missing script '+f)
# strict NDS scene evidence; absence stays FAIL, never inferred
for scene in ['s04p1601','s04p1701','s04p1801','s04p1901','s04p1902','s04p2001']:
 hits=list((R/'docs').rglob('*'+scene+'*'))
 if not hits and scene not in ''.join(p.read_text(errors='ignore') for p in (R/'Data/Script/halcyon').rglob('*.lua')):problems.append('missing explicit scene mapping '+scene)
report={'canonical_source':'PMD Explorers of Sky — Aegis Cave','pmdo_identity':'cloven_ruins / Cloven Ruin','expected_floor_topology':expected,'actual_floor_topology':actual,'passed':ok,'problems':problems,'runtime':'REQUIRES_RUNTIME','status':'FAIL' if problems else 'PARTIAL_STATIC_PASS'}
out=R/'docs/audit_global/CLOVEN_RUIN_AEGIS_CAVE_STRICT.json';out.parent.mkdir(parents=True,exist_ok=True);json.dump(report,open(out,'w'),indent=2)
print(json.dumps(report,indent=2));sys.exit(1 if problems else 0)
