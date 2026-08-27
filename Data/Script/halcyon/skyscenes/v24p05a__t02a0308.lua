-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P05A/t02a0308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_DEMO_HERO
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(2048) [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(50)
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(30)
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(80)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_DEMO_PARTNER
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(4) [neutre/état moteur]
    -- SetOutputAttribute(2048) [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(50)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(30)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(80)
    -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_JUPUTORU
    local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 192, 128, Direction.UpLeft, "NPC_JUPUTORU")
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(2048) [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(50)
    do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(30)
    do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-1), false, 2) end -- Slide2PositionOffset
    GAME:WaitFrames(80)
    -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end)
  SkySceneKit.run_routine(function() -- def 4 for object OBJECT_V24P01A3_307
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(2048) [neutre/état moteur]
    GAME:WaitFrames(50)
    -- Slide2PositionOffset OBJECT_V24P01A3_307 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(30)
    -- Slide2PositionOffset OBJECT_V24P01A3_307 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(80)
    -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end)
  SkySceneKit.run_routine(function() -- def 5 for object OBJECT_V24P05A1_319
    -- SetOutputAttribute(8) [neutre/état moteur]
    -- SetOutputAttribute(2) [neutre/état moteur]
    -- SetOutputAttribute(2048) [neutre/état moteur]
    GAME:WaitFrames(50)
    -- Slide2PositionOffset OBJECT_V24P05A1_319 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(30)
    -- Slide2PositionOffset OBJECT_V24P05A1_319 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(80)
    -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end)
  -- back_SetGround(LEVEL_V24P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  GAME:FadeIn(5)
  pcall(function() GAME:MoveCamera(468, 264, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(780, 264, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(156, 696, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(468, 696, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(780, 696, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(156, 1128, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(468, 1128, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() GAME:MoveCamera(780, 1128, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(2)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-300), 6397, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(86)
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
