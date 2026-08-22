#!/usr/bin/env python3
"""Audit the complete reachable final-Ground → Dazzling-battle contract."""
from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
zone=json.loads((ROOT/'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))['Object']
grounds=set(zone['GroundMaps'])
required={'gloomy_forest_entrance','gloomy_forest_midpoint','gloomy_forest_miniboss','sinister_woods_clearing'}
scene=(ROOT/'Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua').read_text()
clearing=(ROOT/'Data/Script/halcyon/ground/sinister_woods_clearing/init.lua').read_text()
final=json.dumps(zone['Segments'][4])
for ground in required:
 p=ROOT/'Data/Ground'/f'{ground}.rsground'
 assert p.is_file(),p
 data=json.loads(p.read_text(encoding='utf-8-sig'))['Object']
 marks={m.get('EntName') for e in data.get('Entities',[]) for m in e.get('Markers',[])}
 assert 'Main_Entrance_Marker' in marks,(ground,marks)
assert required <= grounds,(required-grounds)
assert 'Kangaskhan_Rock' not in (ROOT/'Data/Ground/gloomy_forest_entrance.rsground').read_text(encoding='utf-8-sig')
assert 'DazzlingClearingCutscene()' in clearing
assert "GAME:ContinueDungeon('gloomy_forest', 4, 0, 0" in scene
assert 'COMMON.BossTransition()' in scene
assert 'sinister_woods_dazzling' in final
arena=json.loads((ROOT/'Data/Map/sinister_woods_dazzling.rsmap').read_text(encoding='utf-8-sig'))['Object']
assert [p['BaseForm']['Species'] for t in arena['MapTeams'] for p in t['Players']]==['tsareena','lopunny','mismagius']
print('SINISTER_WOODS_FINAL_ROUTE_AUDIT_PASS',json.dumps({'grounds':sorted(required),'final_ground':'sinister_woods_clearing','battle_map':'sinister_woods_dazzling','battle_team':['Adagio','Aria','Sonata']}))
