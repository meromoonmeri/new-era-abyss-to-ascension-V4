-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/us0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 392, 296, Direction.Right, "NPC_POPPO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="We're out of your league![K]\nYou KO'd [CS:N]Darkrai[CR]!", french="Vous avez vaincu [CS:N]Darkrai[CR]![K]\nWaouh, nous sommes très loin d'avoir votre\nniveau...", german="Wir spielen nicht in eurer Liga![K]\nIhr habt [CS:N]Darkrai[CR] bezwungen!", italian="Siete una squadra eccezionale![K]\nAvete sconfitto [CS:N]Darkrai[CR]!", spanish="¡Menudo nivel![K] ¡Habéis derrotado\na [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_poppo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english="What?! Team [CS:X]Charm[CR]\ncame here?!", french="Quoi?! L'Equipe [CS:X]Charme[CR]\nétait ici?!", german="Was? Team [CS:X]Charme[CR] ist\nhierhergekommen?!?", italian="Cosa?! Il Team [CS:X]Malia[CR] è venuto\nqui?!", spanish="¡¿Qué?! ¡¿El [CS:X]Equipo Carisma[CR] ha\nestado aquí?!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
