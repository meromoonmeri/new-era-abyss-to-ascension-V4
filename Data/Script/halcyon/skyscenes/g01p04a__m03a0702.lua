-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m03a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" Hurry! Off to [CS:P]Mt. Bristle[CR]!", french=" Vite! Au [CS:P]Mt Hérissé[CR]!", german=" Beeilung! Auf zum [CS:P]Stachelberg[CR]!", italian="Veloce! Dobbiamo raggiungere il\n[CS:P]Monte Crespo[CR]!", spanish=" ¡Vamos al [CS:P]Monte Árido[CR]!"}) -- SwitchTalk: branche default (canon générique)
end
