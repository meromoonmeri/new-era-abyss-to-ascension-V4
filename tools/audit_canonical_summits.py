#!/usr/bin/env python3
"""Contrôle les sommets/fins et cinématiques canoniques des imports PMD Red."""
from __future__ import annotations
import hashlib,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
errors=[];warnings=[]
# Corpus importé depuis PMD-RED-PMDO-PORT.
cifs={p.stem.replace('.cif','') for p in (ROOT/'RESERVE/red_cinematics').glob('d*.cif.json')}
luas={p.stem for p in (ROOT/'RESERVE/red_scene_reference').glob('d*.lua')}
if len(cifs)!=45:errors.append(f'45 cinématiques D attendues, {len(cifs)} présentes')
if cifs!=luas:errors.append(f'cinématiques/références Lua désynchronisées: {sorted(cifs^luas)}')
# Tout Ground actif déclarant une provenance DxxPyy doit posséder sa CIF source.
active={}
for p in (ROOT/'Data/Ground').glob('*.rsground'):
 try:o=json.load(open(p,encoding='utf-8-sig'))['Object']
 except Exception:continue
 comment=o.get('Comment') or ''
 m=re.search(r'\b(D\d\dP\d\d)\b',comment,re.I)
 if m:
  src=m.group(1).lower();active.setdefault(src,[]).append(p.stem)
  if src not in cifs:errors.append(f'{p.name}: source {src} sans cinématique CIF')
# Contrat renforcé Sky Tower D13P03.
ground=ROOT/'Data/Ground/tour_ciel_sommet.rsground';tile=ROOT/'Content/Tile/TourCielSommet_Base.tile'
if not ground.exists() or not tile.exists():errors.append('sommet canonique Sky Tower absent')
else:
 go=json.load(open(ground,encoding='utf-8-sig'))['Object']
 if (len(go['obstacles']),len(go['obstacles'][0]))!=(69,75):errors.append('D13P03: géométrie différente de 69x75')
 ents=go['Entities'][0];marks={x['EntName']:(x['Collider']['X'],x['Collider']['Y']) for x in ents.get('Markers',[])}
 expected={'Main_Entrance_Marker':(296,296),'Boss_Marker':(272,272),'Cutscene_Marker':(272,280)}
 for k,v in expected.items():
  if marks.get(k)!=v:errors.append(f'D13P03: {k}={marks.get(k)}, attendu {v}')
 mp=json.load(open(ROOT/'Data/Map/tour_ciel_sommet.rsmap',encoding='utf-8-sig'))['Object']
 species=[]
 for t in mp.get('MapTeams',[]):
  for mon in t.get('Players',[]):species.append(mon.get('BaseForm',{}).get('Species'))
 if species!=['rayquaza']:errors.append(f'arène D13P03: équipe boss {species}, attendu [rayquaza]')
 if mp.get('Music')!='Sky Tower.ogg':errors.append(f'arène D13P03: musique {mp.get("Music")}')
 script=(ROOT/'Data/Script/halcyon/ground/tour_ciel_sommet/init.lua').read_text()
 for token in ('VFX_Rayquaza_Hyperbeam_Core','VFX_Meteor_Fragment',"FadeOut(true, 30)","FadeIn(16)"):
  if token not in script:errors.append(f'cinématique D13P03: étape/VFX absent {token}')
# Les copies arc_* sont admises seulement parce qu'elles ont un script de contexte distinct.
for src,names in active.items():
 if len(names)>1 and not all(n.startswith('arc_') or n in {'parvis_celeste','palier_celeste','tour_ciel_sommet','bois_sombres_oree','gloomy_forest_entrance'} for n in names):
  warnings.append(f'{src}: doublons actifs à arbitrer {names}')
print('AUDIT SOMMETS ET CINEMATIQUES CANONIQUES RED')
print(f'Corpus: {len(cifs)} CIF + {len(luas)} références Lua; Grounds D actifs: {active}')
for x in errors:print('ERREUR:',x)
for x in warnings:print('AVERTISSEMENT:',x)
print(f'RESULTAT: {len(errors)} erreur(s), {len(warnings)} avertissement(s)')
raise SystemExit(1 if errors else 0)
