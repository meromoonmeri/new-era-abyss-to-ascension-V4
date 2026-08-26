-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P25A/s31a3901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oogh...\nIt's hard to make progress...", french="Ouille...\nPas facile...", german="Uff...\nEs ist hart, vorwärts zu kommen...", italian="Orgh...\nÈ difficile fare progressi...", spanish="Uf...\nCuesta mucho avanzar..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D73P25A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P25A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
