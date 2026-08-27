-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V16P02A/m16a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V16P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 216, 8, Direction.Down, "NPC_YONOWAARU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 216, 8, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(11) [anim idle native]
  -- MoveSpecial(2, 0, 0) [neutre/état moteur]
  -- MoveSpecial(3, 0, 0) [neutre/état moteur]
  -- MoveSpecial(4, 0, 0) [neutre/état moteur]
  -- GAP: se_Play(7184) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(120)
  -- message_CloseEnforce
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 0 -- $PERFORMANCE_PROGRESS_LIST[5] = 0 (ROM)
  SkyProg.set(18, 0) -- $SCENARIO_MAIN = scn[18,0] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 4 -- $SCENARIO_BALANCE_FLAG = 4 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
