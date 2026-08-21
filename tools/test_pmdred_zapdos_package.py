#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
R=Path(__file__).resolve().parents[1]
H={'PMD Red EU - Mt Thunder.ogg':'36641c6da663d8312d6a402b4757f76e7e3152e38d976489fa9115c151d2006f','PMD Red EU - Mt Thunder Peak.ogg':'32373a97c4fc89f1ed81ab700ec86b9541c393b0e56d8f1eb86795fd5cd97071'}
for n,h in H.items(): assert hashlib.sha256((R/'Content/Music'/n).read_bytes()).hexdigest()==h
z=json.loads((R/'Data/Zone/mt_thunder.json').read_text(encoding='utf-8-sig'))['Object']
assert len(z['Segments'])==4
def vals(x,key):
 out=[]
 if isinstance(x,dict):
  if key in x:out.append(x[key])
  for v in x.values():out+=vals(v,key)
 elif isinstance(x,list):
  for v in x:out+=vals(v,key)
 return out
assert vals(z['Segments'][0],'Music')==['PMD Red EU - Mt Thunder.ogg']
assert vals(z['Segments'][2],'Music')==['PMD Red EU - Mt Thunder Peak.ogg']
assert 'mt_thunder_zapdos' in vals(z['Segments'][3],'MapID')
for d in ('d06p02','d06p03'):
 assert (R/f'Data/Ground/{d}.rsground').is_file()
 assert (R/f'Data/Script/halcyon/ground/{d}/init.lua').is_file()
a=json.loads((R/'Data/Map/mt_thunder_zapdos.rsmap').read_text())['Object']
raw=json.dumps(a).lower(); assert '"species": "zapdos"' in raw and '"tactic": "boss"' in raw
for ep in a['EntryPoints']:
 q=a['Tiles'][ep['Loc']['X']][ep['Loc']['Y']]['Data']['ID']; assert q=='floor',q
scene=(R/'Data/Script/halcyon/ground/d06p03/init.lua').read_text()
for token in ('Zapdos','EVT_Thunder','EVT_Roar','COMMON.BossTransition()',"GAME:EnterDungeon('mt_thunder',3"):
 assert token in scene,token
route=(R/'Data/Script/halcyon/zone/mt_thunder/init.lua').read_text()
assert "GAME:EnterGroundMap('d06p02'" in route and "GAME:EnterGroundMap('d06p03'" in route
print('PMDRED_ZAPDOS_PACKAGE_PASS')
