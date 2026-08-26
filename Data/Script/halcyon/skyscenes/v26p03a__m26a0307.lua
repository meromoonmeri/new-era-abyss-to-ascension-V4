-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P03A/m26a0307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_RESTORED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V26P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" It survived!", french=" Elle a résisté!", german=" Er hat es überstanden!", italian=" Ha resistito!", spanish=" ¡Sigue aquí!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(true, 20) -- WhiteOut
  GAME:WaitFrames(30)
end
