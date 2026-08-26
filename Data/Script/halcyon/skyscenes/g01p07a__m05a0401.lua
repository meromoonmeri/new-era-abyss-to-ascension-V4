-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m05a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkySceneKit.say({english="Hmmm... This is really hard...\nLet's call it off for today.", french="Hum... C'est vraiment difficile...\nÇa suffit pour aujourd'hui.", german="Hmm... Das ist ganz schön\nschwierig. Lassen wir es für heute.", italian="Mmm... È un'impresa non da\npoco...[K] Per oggi può bastare così.", spanish="Vaya... Está resultando muy\ndifícil... Vamos a dejarlo por hoy."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
