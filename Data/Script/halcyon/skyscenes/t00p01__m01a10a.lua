-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a10a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A10A') [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(60)
  local npc_npc_test009 = SkySceneKit.spawn_npc("magnemite", 480, 312, Direction.Right, "NPC_TEST009")
  -- PursueTurnLives(0, 15, ACTOR_PLAYER, 5) [neutre/état moteur]
  local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 560, 312, Direction.Left, "NPC_TEST010")
  -- PursueTurnLives2(0, 60, ACTOR_PLAYER, 6) [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(120), p.Y+(0), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(60), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-120), p.Y+(0), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-60), false, 2) end -- waypoint Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  SkySceneKit.spin(npc_npc_test009, 8, 4, 1) -- Turn3 (rotation partielle)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(80), p.Y+(80), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-80), p.Y+(-80), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(80), p.Y+(-80), false, 2) end -- waypoint Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-80), p.Y+(80), false, 2) end -- waypoint Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  SkySceneKit.spin(npc_npc_test010, 8, 4, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(60)
  SkySceneKit.spin(hero, 4, 3, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  SkySceneKit.spin(hero, 2, 4, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- debug_Print('A01') [neutre/état moteur]
  -- SetAnimation(65) [anim idle native]
  GAME:WaitFrames(60)
  -- debug_Print('A02') [neutre/état moteur]
  -- EndAnimation() [neutre/état moteur]
  -- debug_Print('A03') [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- debug_Print('A04') [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- debug_Print('A05') [neutre/état moteur]
  -- SetAnimation(65) [anim idle native]
  GAME:WaitFrames(60)
  -- debug_Print('A06') [neutre/état moteur]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  GAME:WaitFrames(60)
  -- debug_Print('A07') [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- debug_Print('A08') [neutre/état moteur]
  -- SetAnimation(65) [anim idle native]
  GAME:WaitFrames(60)
  -- debug_Print('A09') [neutre/état moteur]
  -- StopAnimation() [neutre/état moteur]
  GAME:WaitFrames(60)
  -- debug_Print('A10') [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetOutputAttribute(32) [neutre/état moteur]
  -- SetOutputAttribute(32) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- ResetOutputAttribute(32) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- SetBlink(2, 1) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- SetBlink(1, 1) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- SetBlink(1, 2) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- SetBlink(0, 0) [neutre/état moteur]
  -- ResetOutputAttribute(32) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
