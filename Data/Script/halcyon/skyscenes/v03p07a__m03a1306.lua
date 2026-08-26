-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P07A/m03a1306.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(156, 140, 1, false) end)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Or at a lake in an underground\ncavern...", french="... ou au milieu d'un lac\ndans une grotte souterraine...", german="Oder bei einem See in einer\nunterirdischen Höhle...", italian="... o in un lago di una caverna\nsotterranea...", spanish="O en el lago de una caverna\nsubterránea..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
end
