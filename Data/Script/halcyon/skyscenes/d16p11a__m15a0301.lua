-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P11A/m15a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D16P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GROUND:MoveToPosition(hero, 316, 140, false, 2)
  GROUND:MoveToPosition(partner, 284, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Let's try our best, [hero]!", french="Surpassons-nous,\n[hero]!", german="Strengen wir uns an,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Debemos esforzarnos mucho,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(partner, 284, 76, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 76, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(24, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
