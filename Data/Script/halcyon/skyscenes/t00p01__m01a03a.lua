-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a03a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_TEST005
    local npc_npc_test005 = SkySceneKit.spawn_npc("lombre", 568, 360, Direction.UpLeft, "NPC_TEST005")
    -- debug_Print('TEST005_MOVE1') [neutre/état moteur]
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(32), false, 2) end -- waypoint MovePositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(-32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
    -- debug_Print('TEST005_MOVE2') [neutre/état moteur]
    GROUND:MoveToPosition(npc_npc_test005, 520, 316, false, 2)
    -- debug_Print('TEST005_MOVE3') [neutre/état moteur]
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(32), p.Y+(0), false, 2) end -- Slide2PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(32), false, 1) end -- Slide2PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(-32), p.Y+(0), false, 2) end -- Slide2PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(-32), false, 1) end -- Slide2PositionOffset
    -- debug_Print('TEST005_MOVE4') [neutre/état moteur]
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(32), p.Y+(0), false, 2) end -- Move3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(32), false, 2) end -- Move3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(-32), p.Y+(0), false, 2) end -- Move3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(-32), false, 2) end -- Move3PositionOffset
    -- debug_Print('TEST005_MOVE5') [neutre/état moteur]
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(32), p.Y+(0), false, 2) end -- Slide3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(32), false, 2) end -- Slide3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(-32), p.Y+(0), false, 2) end -- Slide3PositionOffset
    do local p=npc_npc_test005.Position; GROUND:MoveToPosition(npc_npc_test005, p.X+(0), p.Y+(-32), false, 2) end -- Slide3PositionOffset
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_TEST009
    local npc_npc_test009 = SkySceneKit.spawn_npc("magnemite", 488, 280, Direction.Down, "NPC_TEST009")
    -- debug_Print('TEST009_MOVE1') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test009, Direction.Down) -- MoveDirection
    GROUND:EntTurn(npc_npc_test009, Direction.Right) -- MoveDirection
    GROUND:EntTurn(npc_npc_test009, Direction.Up) -- MoveDirection
    GROUND:EntTurn(npc_npc_test009, Direction.Left) -- MoveDirection
    -- debug_Print('TEST009_MOVE2') [neutre/état moteur]
    GROUND:EntTurn(npc_npc_test009, Direction.Down)
    -- MoveTurn(16, 0.5, 0) [mouvement directionnel de routine: idle figurant]
    -- MoveTurn(16, 0.5, 4) [mouvement directionnel de routine: idle figurant]
    -- MoveTurn(16, 0.5, 4) [mouvement directionnel de routine: idle figurant]
    -- MoveTurn(16, 0.5, 4) [mouvement directionnel de routine: idle figurant]
  end)
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_TEST010
    local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 552, 280, Direction.Down, "NPC_TEST010")
    -- debug_Print('TEST010_MOVE1') [neutre/état moteur]
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_test010, npc_npc_test005, 4) end)
    local npc_npc_test003 = SkySceneKit.spawn_npc("persian", 664, 272, Direction.Down, "NPC_TEST003")
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_test010, npc_npc_test003, 4) end)
    local npc_npc_test007 = SkySceneKit.spawn_npc("granbull", 464, 360, Direction.Down, "NPC_TEST007")
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_test010, npc_npc_test007, 4) end)
    GROUND:TeleportTo(npc_npc_test010, 568, 292, Direction.Down)
    -- debug_Print('TEST010_MOVE2') [neutre/état moteur]
    -- Turn2DirectionLives vers 73 [cible sans placement SSA dans la zone (spawn moteur NDS) : orientation non jouée]
    -- Turn2DirectionLives vers 71 [cible sans placement SSA dans la zone (spawn moteur NDS) : orientation non jouée]
    -- Turn2DirectionLives vers 75 [cible sans placement SSA dans la zone (spawn moteur NDS) : orientation non jouée]
  end)
  -- debug_Print('acting_M01A03A') [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be conducted.", french="An Acting Test will be conducted.", german="An Acting Test will be conducted.", italian="An Acting Test will be conducted.", spanish="An Acting Test will be conducted."})
  -- message_Close
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_Move2PositionMark(1.0, Position<'m0', 65, 39.5>, Position<'m1', 61, ) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_test007, 520, 316, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Event Test is finished.", french="The Event Test is finished.", german="The Event Test is finished.", italian="The Event Test is finished.", spanish="The Event Test is finished."})
  -- message_Close
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Suspend(-2) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
