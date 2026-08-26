-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m14a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english="This won't be easy. Let's call it\na day.", french="C'est plus dur que je pensais.\nÇa suffit pour aujourd'hui.", german="Das wird nicht leicht werden.\nLassen wir es für heute gut sein.", italian="È più difficile del previsto. Per\noggi direi che può bastare.", spanish="Esto no será fácil.\nVamos a dejarlo por hoy."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
