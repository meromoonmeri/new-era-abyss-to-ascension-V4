-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V05P01A/m20a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TIME_GEAR_REMIX non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(180)
  GAME:FadeOut(false, 30)
end
