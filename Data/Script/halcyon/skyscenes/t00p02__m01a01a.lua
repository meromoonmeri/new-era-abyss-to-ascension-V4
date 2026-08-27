-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P02/m01a01a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_TEST010
    local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 352, 264, Direction.Up, "NPC_TEST010")
    -- debug_Print('TEST010_MOVE1') [neutre/état moteur]
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, "happy", 1) end)
    GAME:WaitFrames(60)
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_test010, Direction.Down) -- MoveDirection
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, "exclaim", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_test010, Direction.Right) -- MoveDirection
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, "sweating", 1) end)
    GAME:WaitFrames(60)
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_test010, Direction.Up) -- MoveDirection
    -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_test010, Direction.Left) -- MoveDirection
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, "happy", 1) end)
    GAME:WaitFrames(60)
    pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(1) -- hold
  end)
  -- debug_Print('acting_M01A01A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be conducted.", french="An Acting Test will be conducted.", german="An Acting Test will be conducted.", italian="An Acting Test will be conducted.", spanish="An Acting Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Event Test is finished.", french="The Event Test is finished.", german="The Event Test is finished.", italian="The Event Test is finished.", spanish="The Event Test is finished."})
  -- message_Close
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
