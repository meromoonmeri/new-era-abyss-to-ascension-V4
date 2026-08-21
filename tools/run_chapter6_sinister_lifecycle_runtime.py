#!/usr/bin/env python3
"""Execute the chapter-6 lifecycle Lua module and record both victory/abandon routes."""
from pathlib import Path
import json
from lupa import LuaRuntime
R=Path(__file__).resolve().parents[1]
code=(R/'Data/Script/halcyon/SinisterWoodsLifecycle.lua').read_text()
def run(route):
 lua=LuaRuntime(unpack_returned_tuples=True)
 lua.execute('SV={Chapter6={},TemporaryFlags={},ChapterProgression={Chapter=6}}')
 mod=lua.execute(code)
 phases=[]
 def call(name,*args):
  mod[name](*args); phases.append(mod['Phase']())
 call('Prepare'); call('StartExpedition'); call('Checkpoint')
 if route=='victory':
  call('Victory'); call('AfterTownConsequences'); call('AfterDinner'); call('AfterEveningTalk'); call('AfterWake')
  expected=['guild_preparation','exploration','checkpoint','town_consequences','guild_report','bedtime','sleep','guild_routine']
 else:
  call('ReturnToGuild','abandon'); call('AfterDinner'); call('AfterEveningTalk'); call('AfterWake')
  expected=['guild_preparation','exploration','checkpoint','guild_report','bedtime','sleep','guild_routine']
 assert phases==expected,(route,phases)
 flags=lua.eval('SV.TemporaryFlags')
 assert flags['MissionCompleted'] is True and flags['Dinnertime'] is True
 state=lua.eval('SV.Chapter6.SinisterLifecycle')
 return {'route':route,'phases':phases,'attempt':state['Attempt'],'day':state['Day'],'last_outcome':state['LastOutcome'],'flags':{'MissionCompleted':flags['MissionCompleted'],'Dinnertime':flags['Dinnertime'],'Bedtime':flags['Bedtime'],'MorningWakeup':flags['MorningWakeup']}}
report={'status':'PASS','runtime':'Lua 5.4 via lupa','scope':'chapter-6 lifecycle state machine; not PMDO rendering','routes':[run('victory'),run('abandon')]}
out=R/'docs/pmdred_eu/playable/sinister_woods/chapter6_lifecycle_runtime_2026-08-21.json';out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(report,indent=2)+'\n')
print('CHAPTER6_SINISTER_LIFECYCLE_RUNTIME_PASS')
print(json.dumps(report,sort_keys=True))
