-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s03p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="We should look around\nhere first!", french="Regardons d'abord dans les\nparages!", german="Wir sollten uns erst einmal hier\numsehen!", italian="Prima diamo un'occhiata\nqui in giro!", spanish=" ¡Busquemos por aquí primero!"}) -- SwitchTalk: branche default (canon générique)
end
