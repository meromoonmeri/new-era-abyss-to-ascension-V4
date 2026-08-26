-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m99a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(23, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
end
