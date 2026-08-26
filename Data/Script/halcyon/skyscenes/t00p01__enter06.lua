-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which function will you access?", french="Which function will you access?", german="Which function will you access?", italian="A che funzione vuoi accedere?", spanish="Which function will you access?"})
end
