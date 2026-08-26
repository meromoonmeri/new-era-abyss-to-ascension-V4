-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m12a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english="Hmm... This won't be easy...[K]\nLet's call it a day.", french="C'est plus dur que je croyais...[K]\nArrêtons là pour aujourd'hui.", german="Hmm, das wird nicht leicht\nwerden.[K] Machen wir für heute Schluss.", italian="È più difficile di quel che\npensassi...[K] Per oggi è meglio lasciar perdere.", spanish="Esto no va a ser fácil...[K]\nMejor dejémoslo por hoy."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
