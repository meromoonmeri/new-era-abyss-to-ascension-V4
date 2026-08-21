#!/usr/bin/env python3
import json
from pathlib import Path
R=Path(__file__).resolve().parents[1]
z=json.loads((R/'Data/Zone/gloomy_forest.json').read_text(encoding='utf-8-sig'))['Object']
assert z['Name']['DefaultText']=='Sinister Woods' and z['Name']['LocalTexts']['fr']=='Forêt Sinistre'
assert [z['Segments'][i]['Floors']['nodes'][0]['Range']['Max'] for i in (0,1,3)]==[7,3,3]
assert sum(z['Segments'][i]['Floors']['nodes'][0]['Range']['Max'] for i in (0,1,3))==13
for i in (0,1,3):
 assert 'Gloomy Forest' not in json.dumps(z['Segments'][i].get('ZoneSteps',[]))
life=(R/'Data/Script/halcyon/SinisterWoodsLifecycle.lua').read_text()
for token in ('guild_preparation','exploration','checkpoint','guild_report','Dinnertime','bedtime','sleep','guild_routine'): assert token in life
zone=(R/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
for token in ('SinisterLifecycle.Checkpoint()','SinisterLifecycle.Victory()',"SinisterLifecycle.Retry('boss_defeat')",'SinisterLifecycle.ReturnToGuild(',"GROUND_IDX('guild_second_floor')",'sinister_woods_clearing','ResultType.Escaped'): assert token in zone
entrance=(R/'Data/Script/halcyon/ground/gloomy_forest_entrance/init.lua').read_text();assert 'SinisterLifecycle.StartExpedition()' in entrance
city=(R/'Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua').read_text();assert 'SinisterLifecycle.AfterTownConsequences()' in city
dining=(R/'Data/Script/halcyon/ground/guild_dining_room/init.lua').read_text();assert 'SinisterLifecycle.AfterDinner()' in dining
room=(R/'Data/Script/halcyon/ground/guild_heros_room/init.lua').read_text()
for token in ('EveningBedtalk()','SinisterLifecycle.AfterEveningTalk()','SinisterLifecycle.AfterWake()','MorningBedtalk()'):assert token in room
guild=(R/'Data/Script/halcyon/ground/guild_second_floor/init.lua').read_text();assert "guild_second_floor_ch_6'" in guild and 'guild_second_floor_ch_6.Briefing()' in guild
ctx=(R/'Data/Script/halcyon/ground/guild_second_floor/guild_second_floor_ch_6.lua').read_text();assert "name..'_Action'" in ctx and 'Forêt Sinistre' in ctx
print('CHAPTER6_SINISTER_LIFECYCLE_PASS')
