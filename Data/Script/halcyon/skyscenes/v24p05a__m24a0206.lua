-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P05A/m24a0206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
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
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_ATTENDANT1
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
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V24P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
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
  GAME:WaitFrames(60)
  -- message_SetWaitMode(80, 30) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Lapras[CR]...!", french=" [CS:N]Lokhlass[CR]...!", german=" [CS:N]Lapras[CR]!", italian=" [CS:N]Lapras[CR]...!", spanish=" ¡[CS:N]Lapras[CR]!"})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is that it?!", french=" C'est ça?!", german=" Ist es das?", italian=" È questa?!", spanish=" ¡¿Es aquello de allí?!"})
  -- message_KeyWait
  -- message_SetWaitMode(120, 30) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is that the [CS:P]Hidden Land[CR]?!", french=" C'est ça, les [CS:P]Terres Illusoires[CR]?!", german=" Ist dies das [CS:P]Verborgene Land[CR]?", italian=" È questa la [CS:P]Terra Nascosta[CR]?!", spanish=" ¿Es eso la [CS:P]Tierra Oculta[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_RAPURASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yes! That's the [CS:P]Hidden Land[CR]!", french="Oui! Ce sont les\n[CS:P]Terres Illusoires[CR]!", german=" Ja! Das ist das [CS:P]Verborgene Land[CR]!", italian=" Sì! Questa è la [CS:P]Terra Nascosta[CR]!", spanish=" ¡Sí! ¡Es la [CS:P]Tierra Oculta[CR]!"})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_RAPURASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We're going in!", french=" Allez, on entre!", german=" Wir begeben uns hinein!", italian=" Stiamo entrando!", spanish=" ¡Vamos a entrar!"})
  -- message_Close
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
