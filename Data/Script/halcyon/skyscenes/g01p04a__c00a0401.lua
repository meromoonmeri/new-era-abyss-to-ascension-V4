-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/c00a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 25 or __sw == 26 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SkySceneKit.say({english="Hmm... This is kind of hard.[K]\nLet's go back for now.", french="Ce n'est vraiment pas facile...[K]\nTant pis, on réessaiera une autre fois.", german="Hmm, das ist ziemlich\nschwierig.[K] Gehen wir fürs Erste zurück.", italian="Mmm... È molto difficile.[K]\nPer ora torniamo indietro.", spanish="Hum... Es bastante duro.[K]\n¿Por qué no volvemos?"}) -- SwitchTalk: branche default (canon générique)
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  elseif true then -- default
  SkySceneKit.say({english="It's harder than I thought...[K]\nLet's go home for the day.", french="C'est plus dur que je croyais...[K]\nOn retentera notre chance une autre fois.", german="Es ist schwieriger, als ich\nangenommen hatte.[K] Gehen wir für heute nach\nHause.", italian="È più difficile di quel che\npensavo...[K] Basta così, per oggi.", spanish="Ha sido más difícil de lo que\ncreía...[K] Más vale que descansemos por hoy."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
