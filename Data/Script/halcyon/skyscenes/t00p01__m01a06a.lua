-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a06a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_TEST009
    local npc_npc_test009 = SkySceneKit.spawn_npc("magnemite", 480, 312, Direction.Right, "NPC_TEST009")
    -- debug_Print('CHR0_1') [neutre/état moteur]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- WaitLockSupervision(3) [neutre/état moteur]
    -- debug_Print('CHR0_2') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test009, Direction.Right) -- MoveDirection
    SkySceneKit.unlock(6) -- Unlock(6) NDS
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- debug_Print('CHR0_3') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test009, Direction.Right) -- MoveDirection
    SkySceneKit.unlock(6) -- Unlock(6) NDS
    -- debug_Print('CHR0_4') [neutre/état moteur]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_TEST010
    local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 560, 312, Direction.Left, "NPC_TEST010")
    -- debug_Print('CHR1_1') [neutre/état moteur]
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- debug_Print('CHR1_2') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test010, Direction.Left) -- MoveDirection
    SkySceneKit.unlock(5) -- Unlock(5) NDS
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- debug_Print('CHR1_3') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test010, Direction.Left) -- MoveDirection
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    -- debug_Print('CHR1_4') [neutre/état moteur]
    GAME:WaitFrames(1) -- hold
  end)
  -- debug_Print('acting_M01A06A') [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  -- debug_Print('SUP1') [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  -- debug_Print('SUP2') [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  -- debug_Print('SUP3') [neutre/état moteur]
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  -- debug_Print('SUP4') [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_test009, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_test010, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(20)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:CharSetEmote(npc_npc_test009, "angry", 1) end)
  GAME:WaitFrames(120)
  pcall(function() GROUND:CharSetEmote(npc_npc_test009, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_test010, nil, 0) end) -- EFFECT_NONE
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
