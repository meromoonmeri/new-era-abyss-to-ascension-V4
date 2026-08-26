-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um2507.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bakuuda = SkySceneKit.spawn_npc("camerupt", 296, 256, Direction.DownRight, "NPC_BAKUUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english=" Thank you, Team [team:]!", french="Merci à vous, l'Equipe\n[team:]!", german=" Danke, Team [team:]!", italian=" Grazie, Team [team:]!", spanish=" ¡Gracias, [CS:X]Equipo[CR] [team:]!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bakuuda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="There are exploration teams\neven more famous than Team [CS:X]Charm[CR].", french="Il existe des équipes\nd'exploration plus célèbres encore que\nl'Equipe [CS:X]Charme[CR].", german="Es gibt Erkundungsteams, die\nnoch berühmter sind als Team [CS:X]Charme[CR].", italian="Ci sono anche squadre\nd'esplorazione più famose del Team [CS:X]Malia[CR].", spanish="Hay equipos de exploración más\nfamosos incluso que el [CS:X]Equipo Carisma[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="The most famous would have to\nbe Team [CS:X]Raider[CR].", french="L'Equipe [CS:X]As[CR] est sans\ndoute la plus célèbre de toutes.", german="Das berühmteste ist wohl\nTeam [CS:X]Schatzsucher[CR].", italian="La squadra più famosa dovrebbe\nessere il Team [CS:X]Asso[CR].", spanish="El equipo más famoso debe de\nser el [CS:X]Equipo As[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
