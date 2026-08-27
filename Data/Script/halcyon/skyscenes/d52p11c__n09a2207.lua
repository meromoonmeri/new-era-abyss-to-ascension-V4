-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P11C/n09a2207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_MIKARUGE
    local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 176, 256, Direction.Down, "NPC_MIKARUGE")
    -- SetAnimation(2) [anim idle native]
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(math.random(15, 30))
    do local p=npc_npc_mikaruge.Position; GROUND:MoveToPosition(npc_npc_mikaruge, p.X+(24), p.Y+(0), false, 1) end
    GAME:WaitFrames(math.random(15, 30))
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(math.random(15, 30))
    do local p=npc_npc_mikaruge.Position; GROUND:MoveToPosition(npc_npc_mikaruge, p.X+(-24), p.Y+(0), false, 1) end
    GAME:WaitFrames(math.random(15, 30))
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_YUKIWARASHI
    local npc_npc_yukiwarashi = SkySceneKit.spawn_npc("snorunt", 312, 272, Direction.Down, "NPC_YUKIWARASHI")
    -- SetAnimation(2) [anim idle native]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(math.random(5, 10))
    do local p=npc_npc_yukiwarashi.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi, p.X+(24), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
    do local p=npc_npc_yukiwarashi.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi, p.X+(-24), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
    GAME:WaitFrames(math.random(5, 10))
    GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Down)
    pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "happy", 1) end)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(math.random(30, 40))
    pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(math.random(5, 10))
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  -- GAP: BGM BGM_A_NEW_WORLD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D52P11C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
