-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/us2305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dosaidon = SkySceneKit.spawn_npc("rhyperior", 376, 168, Direction.DownLeft, "NPC_DOSAIDON")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dosaidon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dosaidon) end)
  SkySceneKit.say({english=" We're Team [CS:X]Raider[CR]!", french=" On est l'Equipe [CS:X]As[CR]!", german=" Wir sind Team [CS:X]Schatzsucher[CR]!", italian=" Noi siamo il Team [CS:X]Asso[CR]!", spanish=" ¡Somos el [CS:X]Equipo As[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dosaidon) end)
  SkySceneKit.say({english="We never fail at getting the\ntreasures we set our sights on.[K] Honored to\nmeet you!", french="Une fois que nous avons jeté\nnotre dévolu sur un trésor, jamais nous\nn'échouons![K] Honorés de vous connaître!", german="Wir bekommen immer die\nSchätze, auf die wir ein Auge geworfen\nhaben.[K] Freut uns, euch kennenzulernen.", italian="Quando mettiamo gli occhi su un\ntesoro non falliamo mai.[K] È un piacere\nconoscervi!", spanish="Siempre conseguimos los\ntesoros que nos proponemos.[K] ¡Un placer\nconoceros!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
