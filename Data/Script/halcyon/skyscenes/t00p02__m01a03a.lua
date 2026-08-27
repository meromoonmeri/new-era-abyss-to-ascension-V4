-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P02/m01a03a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_TEST010
    local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 352, 264, Direction.Up, "NPC_TEST010")
    GAME:WaitFrames(30)
    -- MoveSpecial(1, 30, 2) [neutre/état moteur]
    GAME:WaitFrames(30)
    GAME:WaitFrames(1) -- hold
  end)
  -- debug_Print('acting_M01A03A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Special Movement Test will be conducted.", french="A Special Movement Test will be conducted.", german="A Special Movement Test will be conducted.", italian="A Special Movement Test will be conducted.", spanish="A Special Movement Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Test is finished.", french="The Test is finished.", german="The Test is finished.", italian="The Test is finished.", spanish="The Test is finished."})
  -- message_Close
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
