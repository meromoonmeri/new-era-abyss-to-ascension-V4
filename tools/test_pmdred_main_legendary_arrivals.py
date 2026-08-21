#!/usr/bin/env python3
"""Static wiring/integrity gate for Moltres, Articuno and Groudon arrivals."""
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
PACKAGES={
 'moltres': dict(zone='mt_blaze',ground='d09p03',scene='d09p03',map='mt_blaze_summit',music=('Mt Blaze','Mt Blaze Peak')),
 'articuno': dict(zone='frosty_forest',ground='d10p03',scene='d10p03',map='frosty_forest_summit',music=('Frosty Forest','Frosty Grotto')),
 'groudon': dict(zone='magma_cavern',ground='fosse_ardente',scene='d12p04',map='magma_cavern_pit',music=('Magma Cavern','Magma Cavern Pit')),
}
HASHES={
 'Mt Blaze':'b8594fa492867589bb4d653ba7ed7159d6ce9aeb27809211dc7f4eaa9c9b5d50',
 'Mt Blaze Peak':'fb403d9842672884babc160108b0233020db4b7aff1b0ca08aa38de8ff7ffd67',
 'Frosty Forest':'46b7a44e8f0a56293d7bc211358f52d2c8d41e9ac4de358b1d8dd908b65b71f1',
 'Frosty Grotto':'a795447feb35ec2ea4e8b199be4e07e805953f9bbf5e309d0df97ceec8dfe50f',
 'Magma Cavern':'81843207b828329e168638383759c5661279a394fe1c802edefc89f4c8be9886',
 'Magma Cavern Pit':'099b4138feafabafab1ff1438592aa5ea0f53140e8e5fd199d04d96267b925c9',
}
def music(o):
 out=[]
 if isinstance(o,dict):
  if 'Music' in o: out.append(o['Music'])
  for v in o.values(): out += music(v)
 elif isinstance(o,list):
  for v in o: out += music(v)
 return out
for boss,p in PACKAGES.items():
 zone=json.loads((ROOT/f"Data/Zone/{p['zone']}.json").read_text(encoding='utf-8-sig'))['Object']
 assert len(zone['Segments'])==3
 lower_music=music(zone['Segments'][0]); upper_music=music(zone['Segments'][1])
 assert lower_music and all(x==f"PMD Red EU - {p['music'][0]}.ogg" for x in lower_music)
 assert upper_music and all(x==f"PMD Red EU - {p['music'][1]}.ogg" for x in upper_music)
 ground=(ROOT/f"Data/Script/halcyon/ground/{p['ground']}/init.lua").read_text()
 assert f"halcyon.arc_fugitif.scene.{p['scene']}" in ground
 assert 'scene.Cutscene' in ground
 assert f"GAME:EnterDungeon('{p['zone']}',2,0,0" in ground.replace(' ','')
 scene=(ROOT/f"Data/Script/halcyon/arc_fugitif/scene/{p['scene']}.lua").read_text()
 assert f"C.Play('{p['scene']}')" in scene
 arena=(ROOT/f"Data/Map/{p['map']}.rsmap").read_text(encoding='utf-8-sig').lower()
 assert f'"species": "{boss}"' in arena and '"tactic": "boss"' in arena
 route=(ROOT/f"Data/Script/halcyon/zone/{p['zone']}/init.lua").read_text()
 assert f"GAME:EnterGroundMap('{p['ground']}'" in route
 for name in p['music']:
  q=ROOT/f'Content/Music/PMD Red EU - {name}.ogg'
  assert hashlib.sha256(q.read_bytes()).hexdigest()==HASHES[name]
cin=(ROOT/'Data/Script/halcyon/FugitiveCinematics.lua').read_text()
for boss,p in PACKAGES.items():
 assert boss.capitalize() in cin
 assert 'COMMON.BossTransition()' in cin
print('PMDRED_MAIN_LEGENDARY_ARRIVALS_PASS')
print(json.dumps({k:{'zone':v['zone'],'ground':v['ground'],'scene':v['scene'],'arena':v['map']} for k,v in PACKAGES.items()},sort_keys=True))
