-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um2508.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 336, 240, Direction.Down, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I'm going to explore all over\nagain today!", french="Je recommence l'exploration de\nzéro, aujourd'hui!", german="Ich werde heute wieder überall\nerkunden gehen!", italian="Anche oggi andrò in giro ad\nesplorare!", spanish="¡Hoy voy a volver a explorar\ntodo de nuevo!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my! There's no telling what\ntraps are in store for you!", french="Ouh mince alors! Impossible de\nsavoir quels pièges vous attendent!\nC'est trop bizarre!", german="Oje! Es ist völlig unklar,\nwelche Fallen euch erwarten werden!", italian="Shock! Chissà quante trappole\ndovrete affrontare!", spanish="¡A saber qué trampas os\nencontraréis!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Please, please be careful!", french="Je vous en prie, je vous en\nsupplie, je vous en conjure, faites attention!", german=" Bitte, bitte seid vorsichtig!", italian=" Vi prego, fate attenzione!", spanish=" ¡Por favor, id con cuidado!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
