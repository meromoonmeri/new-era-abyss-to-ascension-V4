-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um2406.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_poniita = SkySceneKit.spawn_npc("ponyta", 328, 256, Direction.DownLeft, "NPC_PONIITA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Another great accomplishment\nfor Team [team:]!", french="Un exploit supplémentaire à\nl'actif de l'Equipe [team:]!", german="Eine weitere tolle\nErrungenschaft für Team [team:]!", italian="Un altro grande risultato per il\nTeam [team:]!", spanish="¡Otro gran logro del [CS:X]Equipo[CR]\n[team:]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poniita, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="Team [CS:X]Raider[CR] is another team\nthat would be fantastic to meet.", french="Ce serait tout aussi fantastique\nde rencontrer l'Equipe [CS:X]As[CR].", german="Team [CS:X]Schatzsucher[CR] ist auch ein\nTeam, das wir unheimlich gerne einmal\nkennenlernen würden.", italian="Sarebbe fantastico anche\nincontrare il Team [CS:X]Asso[CR].", spanish="También sería genial conocer al\n[CS:X]Equipo As[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_poniita) end)
  SkySceneKit.say({english="They must be incredibly cool\nin person...", french="C'est sûrement l'équipe la plus\nclasse du monde...", german="So von Angesicht zu Angesicht\nmüssen die ziemlich cool sein.", italian=" Devono essere fantastici...", spanish="Seguro que son Pokémon\nincreíbles..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
