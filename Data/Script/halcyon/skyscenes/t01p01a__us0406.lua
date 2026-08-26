-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0406.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 400, 184, Direction.Left, "NPC_NYOROTONO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Exploring is always fun! ♪", french="L'exploration, c'est toujours un\nvisa pour l'aventure, pas vrai, les copains? ♪", german=" Erkunden macht immer Spaß! ♪", italian="Esplorare è sempre\ndivertente! ♪", spanish=" ¡Explorar es divertidísimo! ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Go for it!", french=" Foncez!", german=" Haltet euch ran!", italian=" Forza!", spanish=" ¡Adelante con ello!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
