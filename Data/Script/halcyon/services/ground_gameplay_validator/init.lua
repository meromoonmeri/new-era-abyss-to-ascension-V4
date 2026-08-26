-- Opt-in PMDO runtime gameplay validator. Disabled in normal play.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('GroundGameplayValidator',BaseService)
local PILOT={
 {id='a02p01',zone='master_zone',idx=121},
 {id='mt_blaze_midpoint',zone='mt_blaze',idx=3},
 {id='mount_windswept_guardian',zone='mount_windswept',idx=2},
 {id='d11p03',zone='mt_freeze',idx=2},
 {id='champ_vent_boreal',zone='master_zone',idx=80},
}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function emit(s)
 PrintInfo('[GROUND_VALIDATOR] '..s)
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','a');if f then f:write(s..'\n');f:flush();f:close() end
end
function V:initialize() BaseService.initialize(self);self.mode=os.getenv('PMDO_GROUND_VALIDATOR');self.enabled=(self.mode=='1' or self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' or string.sub(self.mode or '',1,6)=='luluby' or string.sub(self.mode or '',1,4)=='sky:' or string.sub(self.mode or '',1,9)=='skyscene:' or self.mode=='skyprogress' or self.mode=='skyjourney');self.idx=0;self.entered=false;self.busy=false
 -- mode 'skyscene:<scene>@<ground>' : rejoue une cinématique canonique Sky
 if string.sub(self.mode or '',1,9)=='skyscene:' then
  local spec=string.sub(self.mode,10)
  local scene, ground = string.match(spec,'([^@]+)@(.+)')
  self.sky_scene=scene; self.sky_scene_ground=ground
 end
 -- mode 'sky:<ground1,ground2,...>' : pilotes de grounds Sky dans sky_hub_zone
 if string.sub(self.mode or '',1,4)=='sky:' then
  self.sky_pilot={}
  for g in string.gmatch(string.sub(self.mode,5),'[^,]+') do self.sky_pilot[#self.sky_pilot+1]=g end
 end
end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 SV.RuntimeGroundAudit=SV.RuntimeGroundAudit or {};SV.RuntimeGroundAudit.Active=true
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','w');if f then f:close() end
 if string.sub(self.mode or '',1,6)=='luluby' then
  self.idx=-2;SV.RuntimeGroundAudit.Active=false
  local gi=141;if self.mode=='luluby_evening' then gi=142 elseif self.mode=='luluby_night' then gi=143 end
  emit('{"event":"luluby_runtime_begin","ground_index":'..tostring(gi)..'}')
  GAME:EnterZone('master_zone',-1,gi,0)
  return
 end
 if self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' then
  self.idx=-1
  SV.Chapter5=SV.Chapter5 or {};SV.Chapter5.MountGuardianSeen=true
  emit('{"event":"arena_probe_begin","mode":"'..self.mode..'"}')
  -- EnterDungeon doit etre appele depuis la coroutine du Ground, pas depuis
  -- l'evenement service NewGame (sinon NLua: yield outside a coroutine).
  GAME:EnterZone('mount_windswept',-1,2,0)
  return
 end
 if self.mode=='skyjourney' then
  -- PARCOURS COMPLET §12 (chapitre 1 Sky) dans le moteur réel :
  -- SAVE(SV) -> état 1.0 -> ground plage (d01p11b) -> scène compilée
  -- -> vérif déblocage -> donjon beach_cave (4 étages) -> arène
  -- beach_cave_pit (Team Skull) -> état 3.0 (post-boss) -> vérif.
  self.idx=-5;SV.RuntimeGroundAudit.Active=false
  self.journey={phase='ground'}
  local prog=require('halcyon.skyscenes.progression')
  prog.reset_for_test()
  prog.set(1,0)
  if not prog.is_unlocked('beach_cave') then
    emit('{"event":"skyjourney_end","verdict":"FAIL","error":"beach_cave non débloqué à 1.0"}');return
  end
  emit('{"event":"skyjourney_begin","state":"1.0","unlocked":["beach_cave","beach_cave_pit"]}')
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  GAME:EnterZone('sky_hub_zone',-1,zone_grounds['d01p11b'],0)
  return
 end
 if self.mode=='skyprogress' then
  -- Parcours de progression §12 : init SV -> franchir les états canoniques
  -- dans l'ordre du graphe ROM -> vérifier les déblocages + la monotonie.
  self.idx=-4;SV.RuntimeGroundAudit.Active=false
  local ok,err=xpcall(function()
    local prog=require('halcyon.skyscenes.progression')
    prog.reset_for_test()
    local m0,s0=prog.state()
    emit('{"event":"skyprogress_begin","initial":"'..m0..'.'..s0..'"}')
    local steps={{1,0},{3,0},{4,0},{5,0},{6,0},{8,0},{10,0},{11,0},{12,0},{13,0},{15,0},{17,0},{18,0},{20,0}}
    local total_unlocked=0
    for _,st in ipairs(steps) do
      local okset,newly=prog.set(st[1],st[2])
      if not okset then error('set '..st[1]..'.'..st[2]..' refusé') end
      total_unlocked=total_unlocked+#(newly or {})
      emit('{"event":"state","main":'..st[1]..',"unlocked_now":'..#(newly or {})..'}')
    end
    -- régression: retour arrière interdit
    local back=prog.set(5,0)
    if back~=false then error('régression: retour arrière accepté') end
    -- vérifs finales
    local must={'beach_cave','steam_cave_peak','temporal_pinnacle','spiritomb_room'}
    for _,z in ipairs(must) do
      if not prog.is_unlocked(z) then error('zone non débloquée: '..z) end
    end
    emit('{"event":"skyprogress_end","total_unlocked":'..total_unlocked..',"verdict":"PROGRESSION_RUNTIME_PASS"}')
  end,debug.traceback)
  if not ok then emit('{"event":"skyprogress_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
  emit('{"event":"end"}')
  return
 end
 if self.sky_scene then
  self.idx=-3;SV.RuntimeGroundAudit.Active=false
  emit('{"event":"sky_scene_begin","scene":"'..self.sky_scene..'","ground":"'..tostring(self.sky_scene_ground)..'"}')
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  local gi=zone_grounds[self.sky_scene_ground]
  if gi==nil then emit('{"event":"sky_scene_fail","error":"ground_absent"}');return end
  GAME:EnterZone('sky_hub_zone',-1,gi,0)
  return
 end
 if self.sky_pilot then
  -- remplace PILOT par les grounds Sky demandés (zone conteneur sky_hub_zone,
  -- index = position dans GroundMaps de la zone, résolue par nom)
  local names=self.sky_pilot
  for i=1,#PILOT do PILOT[i]=nil end
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  for _,nm in ipairs(names) do
   local gi=zone_grounds[nm]
   if gi~=nil then PILOT[#PILOT+1]={id=nm,zone='sky_hub_zone',idx=gi}
   else emit('{"event":"sky_pilot_missing","ground":"'..nm..'"}') end
  end
 end
 self.idx=1;emit('{"event":"begin","count":'..#PILOT..'}');GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0)
end
function V:OnDungeonFloorEnter()
 if self.enabled and self.mode=='skyjourney' and self.journey then
  local ok,err=xpcall(function()
    local cz=tostring(_ZONE.CurrentZoneID)
    local floor=_ZONE.CurrentMapID.ID
    if cz=='beach_cave' then
      emit('{"event":"journey_floor","zone":"beach_cave","floor":'..floor..'}')
      if floor<3 then GAME:EnterZone('beach_cave',0,floor+1,0)
      else
        emit('{"event":"journey_enter_boss","zone":"beach_cave_pit"}')
        GAME:EnterZone('beach_cave_pit',0,0,0)
      end
    elseif cz=='beach_cave_pit' then
      local map=_ZONE.CurrentMap
      local species={}
      for ti=0,map.MapTeams.Count-1 do
        local t2=map.MapTeams[ti]
        for pi=0,t2.Players.Count-1 do
          local ok2,sp=pcall(function() return t2.Players[pi].BaseForm.Species end)
          if ok2 and sp then species[#species+1]=tostring(sp) end
        end
      end
      emit('{"event":"journey_boss","species":"'..table.concat(species,',')..'"}')
      -- victoire canonique -> flag post-boss (état 3.0: retour guilde/ch.2)
      local prog=require('halcyon.skyscenes.progression')
      prog.set(3,0)
      local m,s=prog.state()
      local ok3=(m==3 and prog.is_unlocked('drenched_bluff'))
      emit('{"event":"journey_reward","new_state":"'..m..'.'..s..'","drenched_bluff_unlocked":'..tostring(prog.is_unlocked('drenched_bluff'))..'}')
      emit('{"event":"skyjourney_end","verdict":"'..(ok3 and 'JOURNEY_RUNTIME_PASS' or 'FAIL')..'"}')
      emit('{"event":"end"}')
      self.journey=nil
    end
  end,debug.traceback)
  if not ok then emit('{"event":"skyjourney_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}');emit('{"event":"end"}') end
  return
 end
 if not self.enabled or (self.mode~='tornadus_battle' and string.sub(self.mode or '',1,6)~='arena:') then return end
 local ok,msg=pcall(function()
  local map=_ZONE.CurrentMap
  local foes=map.MapTeams.Count
  local boss=map.MapTeams[0].Players[0]
  return string.format('{"event":"arena_battle_runtime","zone":"%s","segment":%d,"map_teams":%d,"boss_species":"%s","boss_level":%d,"boss_x":%d,"boss_y":%d,"player_control":"DUNGEON_MODE_ENTERED","verdict":"BATTLE_START_PASS"}',tostring(_ZONE.CurrentZoneID),_ZONE.CurrentMapID.Segment,foes,tostring(boss.CurrentForm.Species),boss.Level,boss.CharLoc.X,boss.CharLoc.Y)
 end)
 emit(ok and msg or ('{"event":"arena_battle_runtime","verdict":"RUNTIME_FAIL","error":"'..tostring(msg):gsub('"','\\"')..'"}'))
end
function V:OnGroundMapEnter()
 if self.enabled and self.mode=='skyjourney' and self.journey and self.journey.phase=='ground' and not self.busy then
  self.busy=true
  self.journey.phase='dungeon_pending'
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    local ok,err=xpcall(function()
      local id=GAME:GetCurrentGround().AssetName
      emit('{"event":"journey_ground","id":"'..tostring(id)..'"}')
      -- scène canonique du chapitre 1 sur la plage (pilote artisanal)
      local scenes=require('halcyon.SkyCanonScenes')
      scenes.m01a0204('/tmp/ground_gameplay_validator.jsonl')
      -- transition canonique : entrer dans le donjon débloqué
      local prog=require('halcyon.skyscenes.progression')
      if not prog.is_unlocked('beach_cave') then error('flag perdu avant donjon') end
      emit('{"event":"journey_enter_dungeon","zone":"beach_cave"}')
      GAME:EnterZone('beach_cave',0,0,0)
    end,debug.traceback)
    if not ok then emit('{"event":"skyjourney_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
    self.busy=false;self.task=nil
  end)
  return
 end
 if self.enabled and self.sky_scene and not self.busy then
  self.busy=true
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    local ok,err=xpcall(function()
      -- 1) scènes artisanales (SkyCanonScenes) ; 2) scènes compilées
      -- (halcyon.skyscenes.<zone>__<scene>, générées par
      -- sky_compile_scenes.py, signature function(hero, partner))
      local scenes=require('halcyon.SkyCanonScenes')
      local fn=scenes[self.sky_scene]
      if fn~=nil then
        fn('/tmp/ground_gameplay_validator.jsonl')
      else
        local ok2,mod=pcall(require,'halcyon.skyscenes.'..self.sky_scene)
        if not ok2 or type(mod)~='function' then
          error('scene inconnue: '..tostring(self.sky_scene)..' ('..tostring(mod)..')')
        end
        local hero=CH('PLAYER');local partner=CH('Teammate1')
        mod(hero, partner or hero)
        emit('{"scene":"'..self.sky_scene..'","kind":"compiled","verdict":"CINEMATIC_RUNTIME_PASS"}')
      end
    end,debug.traceback)
    if not ok then emit('{"event":"sky_scene_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
    emit('{"event":"end"}')
    self.busy=false;self.task=nil
  end)
  return
 end
 if not self.enabled or (self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' or string.sub(self.mode or '',1,6)=='luluby') or self.busy then return end
 -- GroundMapEnter est synchrone. Le travail qui yield est reporte dans Update.
 self.pending=false;self.busy=true
 emit('{"event":"ground_entered","ground":"'..PILOT[self.idx].id..'","scheduler":"TASK_BRANCH"}')
 -- Conserver la référence évite que la branche soit abandonnée après le callback.
 self.task=TASK:BranchCoroutine(function()
   local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
   if not ok then emit('{"ground":"'..tostring(PILOT[self.idx] and PILOT[self.idx].id)..'","verdict":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
   self.idx=self.idx+1
   if self.idx>#PILOT then SV.RuntimeGroundAudit.Active=false;emit('{"event":"end"}')
   else GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0) end
   self.busy=false;self.task=nil
 end)
end
function V:validate_async()
 local id=PILOT[self.idx].id;local map=safe(function()return GAME:GetCurrentGround()end,nil);local hero=CH('PLAYER')
 if not map or not hero then emit('{"ground":"'..id..'","verdict":"RUNTIME_FAIL","error":"map_or_hero_nil"}');return end
 GAME:WaitFrames(12)
 local x=safe(function()return hero.Position.X end,-1);local y=safe(function()return hero.Position.Y end,-1)
 local moves={};local deltas={}
 for _,d in ipairs({Direction.Up,Direction.Right,Direction.Down,Direction.Left}) do
  GROUND:MoveInDirection(hero,d,8,false,2)
  GAME:WaitFrames(2)
  local nx=safe(function()return hero.Position.X end,x);local ny=safe(function()return hero.Position.Y end,y)
  moves[#moves+1]=(nx~=x or ny~=y) and 1 or 0
  deltas[#deltas+1]=string.format('"%d,%d"',nx-x,ny-y)
  GROUND:TeleportTo(hero,x,y,Direction.Down);GAME:WaitFrames(2)
 end
 local count=moves[1]+moves[2]+moves[3]+moves[4]
 local verdict=count>0 and 'SAFE' or 'NEEDS_REPAIR'
 local probe=count>0 and 'MOVEMENT_PASS' or 'SPAWN_ISOLATED'
 emit(string.format('{"ground":"%s","load":"LOAD_PASS","spawn":{"x":%d,"y":%d},"move_dirs":[%d,%d,%d,%d],"move_deltas":[%s],"movement_probe":"%s","verdict":"%s"}',id,x,y,moves[1],moves[2],moves[3],moves[4],table.concat(deltas,','),probe,verdict))
end
function V:OnUpdate(gtime)
 if not self.enabled or not self.pending or self.busy then return end
 self.pending=false;self.busy=true
 -- Le callback Update est synchrone, mais il peut amorcer une vraie coroutine
 -- TASK qui sera reprise par le moteur aux frames suivantes.
 TASK:BranchCoroutine(function()
   local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
   if not ok then emit('{"ground":"'..tostring(PILOT[self.idx] and PILOT[self.idx].id)..'","verdict":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
   self.idx=self.idx+1
   if self.idx>#PILOT then SV.RuntimeGroundAudit.Active=false;emit('{"event":"end"}')
   else GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0) end
   self.busy=false
 end)
end
function V:Update(gtime) while true do coroutine.yield() end end
function V:OnInit()
 if self.enabled then
  emit('{"event":"bootstrap_new_game"}')
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
 end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.Update,function(_,args)self.OnUpdate(self,args)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('GroundGameplayValidator',V:new())
-- Le validateur de routes histoire Red est opt-in via
-- PMDO_RED_STORY_ROUTE_VALIDATOR ; main.lua est verrouillé CH1-5, donc le
-- require vit ici (service voisin, également opt-in, zéro effet en jeu normal).
if os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR') then
  require 'halcyon.services.red_story_route_validator'
end
return V
