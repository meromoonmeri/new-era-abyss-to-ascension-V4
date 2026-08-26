-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m22a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allez, on va à Bourg-Trésor.", german=" Gehen wir nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."}) -- SwitchTalk: branche default (canon générique)
end
