-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us2014.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pochiena_b = SkySceneKit.spawn_npc("poochyena", 384, 240, Direction.DownLeft, "NPC_POCHIENA_B")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 368, 264, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Why'd you bring in a known\noutlaw like [CS:N]Drowzee[CR]?", french="Mais pourquoi vous avez amené\nun criminel notoire comme [CS:N]Soporifik[CR] dans\nl'enceinte de la Guilde?", german="Warum einen bekannten Ganoven\nwie [CS:N]Traumato[CR] miteinbeziehen?", italian="Perché hai fatto entrare un noto\ncriminale come [CS:N]Drowzee[CR]?", spanish="¿Para qué traer a un delincuente\ncomo [CS:N]Drowzee[CR]?"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_b, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="[CS:N]Drowzee[CR]?[K] ...Oh, right.\nThat petty crook.", french="[CS:N]Soporifik[CR]?[K] ... Ah, oui.\nCe bandit à la petite semaine.", german="[CS:N]Traumato[CR]?[K] ...Oh, richtig. Dieser\nkleine Gauner.", italian="[CS:N]Drowzee[CR]?[K] Ah, giusto. Quel\ncriminale da strapazzo.", spanish=" ¿[CS:N]Drowzee[CR]?[K] Ah, sí. Ese granuja."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
