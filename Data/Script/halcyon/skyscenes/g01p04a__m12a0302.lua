-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m12a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" Let's head back to [CS:P]Amp Plains[CR]!", french=" En route pour les [CS:P]Plaines Elek[CR]!", german="Machen wir uns auf den Weg zur\n[CS:P]Ampere-Ebene[CR]!", italian=" Torniamo alle [CS:P]Pianure Saetta[CR]!", spanish=" ¡Vamos a la [CS:P]Pradera Destello[CR]!"}) -- SwitchTalk: branche default (canon générique)
end
