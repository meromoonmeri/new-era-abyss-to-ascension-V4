-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D27P11A/m24a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D27P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D27P11A, 'UM25') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 232, 408, Direction.Up, "NPC_RAPURASU")
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="Let's go when you're ready,\n[hero]!", french="On se met en route quand\ntu veux, [hero]!", german="Lass uns losgehen, wenn du\nbereit bist, [hero]!", italian="Quando tutto è pronto andiamo,\n[hero]!", spanish="¡Seguiremos cuando tú digas,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.cleanup_npcs()
end
