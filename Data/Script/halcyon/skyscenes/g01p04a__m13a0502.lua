-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m13a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="Let's go to the [CS:P]Northern Desert[CR]\nand find that Time Gear.", french="Allons dans le [CS:P]Désert du Nord[CR]\npour trouver ce Rouage du Temps!", german="Gehen wir zur [CS:P]Nordwüste[CR]\nund finden das Zahnrad der Zeit!", italian="Andiamo al [CS:P]Deserto del Nord[CR] e\ntroviamo quell'Ingranaggio del Tempo!", spanish="Vamos al [CS:P]Desierto Norte[CR]\na encontrar ese Engranaje del Tiempo."}) -- SwitchTalk: branche default (canon générique)
end
