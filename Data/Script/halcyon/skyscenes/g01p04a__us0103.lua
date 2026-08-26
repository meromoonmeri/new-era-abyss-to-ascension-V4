-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/us0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Hé, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish="¡Hombre, [hero] y\n[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm happy to see you! Are you\nvisiting us?", french="Content de vous revoir!\nVous venez nous rendre visite?", german="Ich freue mich, euch zu sehen!\nBesucht ihr uns?", italian="Sono contento di vedervi! Siete\nqui in visita?", spanish="¡Me alegro de veros! ¿Venís\nde visita?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="By the way...[K] Have you seen my\ndad anywhere?", french="Au fait...[K] Vous n'auriez pas vu\nmon père?", german="Übrigens...[K] Habt ihr meinen\nVater gesehen?", italian="A proposito...[K] Avete visto mio\npadre da qualche parte?", spanish="Por cierto...[K] ¿Habéis visto\na mi padre por ahí?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I haven't seen him for a while.\nI'm beginning to get worried...", french="Ça fait un moment que je ne l'ai\npas vu. Ça commence à m'inquiéter...", german="Ich habe ihn eine Weile nicht\ngesehen. So langsam fange ich an, mir Sorgen\nzu machen...", italian="Non lo vedo da un po'. Comincio\na essere preoccupato...", spanish="Hace tiempo que no le veo. Estoy\nempezando a preocuparme..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm glad to see your team back\nsafely, [hero]!", french="Je suis heureux que tu sois\nde retour indemne, [hero]!", german="Es freut mich, euer Team\nunversehrt zurück zu sehen, [hero]!", italian="Sono contento di vedervi di\nnuovo qui, [hero]!", spanish="¡Me alegro de verte de vuelta\npor aquí, [hero]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
