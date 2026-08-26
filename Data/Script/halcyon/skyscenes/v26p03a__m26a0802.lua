-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P03A/m26a0802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_RESTORED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V26P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(210)
  GAME:FadeOut(false, 60)
end
