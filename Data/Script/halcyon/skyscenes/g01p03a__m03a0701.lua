-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english="Hmmm... This is really tough...\nLet's call it off for today.", french="Ah... Ce n'est vraiment pas\nfacile. Restons-en là pour aujourd'hui.", german="Hmm... Das ist wirklich\nschwierig. Machen wir für heute Pause.", italian="Mmm... È difficile.\nPer oggi basta così.", spanish="Vaya... Esto no es fácil.\nDejémoslo por hoy."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
