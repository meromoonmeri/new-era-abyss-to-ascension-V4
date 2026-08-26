-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="The [CS:K]Kecleon[CR] Market isn't over\nthis way.", french="Ce n'est pas le bon chemin pour\naller au [CS:K]Marché Kecleon[CR].", german="Der [CS:K]Kecleon-Markt[CR] liegt nicht in\ndieser Richtung.", italian="Il [CS:K]Kecleon[CR] Market non è da\nquesta parte.", spanish="El [CS:K]Bazar Kecleon[CR] no está por\nahí."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Let's go, [hero]!", french=" C'est parti, [hero]!", german=" Lass uns gehen, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"}) -- SwitchTalk: branche default (canon générique)
end
