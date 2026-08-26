-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um2408.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_madatsubomi = SkySceneKit.spawn_npc("bellsprout", 312, 280, Direction.Up, "NPC_MADATSUBOMI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="So everything was\ntied together...", french=" Ainsi donc, tout était lié...", german="Also war alles miteinander\nverwoben...", italian=" Quindi era tutto collegato...", spanish=" Así que todo estaba relacionado."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="It was one vast conspiracy\nby [CS:N]Darkrai[CR]...[K] It's quite astounding.", french="Tout ça n'était qu'une immonde\nconspiration ourdie par ce [CS:N]Darkrai[CR]...[K]\nC'est stupéfiant.", german="Es war ein Riesenkomplott von\n[CS:N]Darkrai[CR].[K] Ziemlich erstaunlich.", italian="Era un'immensa cospirazione di\n[CS:N]Darkrai[CR]...[K]\nIncredibile...", spanish="Se trataba de una conspiración\nurdida por [CS:N]Darkrai[CR]...[K] Asombroso."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Team [CS:X]Raider[CR] is a legendary\nexploration team.", french="L'Equipe [CS:X]As[CR] est une\nvéritable légende de l'exploration.", german="Team [CS:X]Schatzsucher[CR] ist ein\nlegendäres Erkundungsteam.", italian="Il Team [CS:X]Asso[CR] è una leggendaria\nsquadra d'esplorazione.", spanish="El [CS:X]Equipo As[CR] es un equipo\nexplorador legendario."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="The team consists of three\nmembers: [CS:N]Gallade[CR], [CS:N]Roserade[CR], and [CS:N]Rhyperior[CR].", french="L'équipe est composée de trois\nmembres: [CS:N]Gallame[CR], [CS:N]Roserade[CR] et [CS:N]Rhinastoc[CR].", german="Das Team besteht aus drei\nMitgliedern: [CS:N]Galagladi[CR], [CS:N]Roserade[CR] und [CS:N]Rihornior[CR].", italian="La squadra è formata da tre\nPokémon: [CS:N]Gallade[CR], [CS:N]Roserade[CR] e [CS:N]Rhyperior[CR].", spanish="Tiene tres miembros: [CS:N]Gallade[CR],\n[CS:N]Roserade[CR] y [CS:N]Rhyperior[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="They're said to never be denied\nfrom getting the treasures they target.", french="On dit que quand ils jettent leur\ndévolu sur un trésor, ils n'échouent jamais:\nils finissent toujours par l'obtenir.", german="Man sagt, sie bekommen immer\ndie Schätze, auf die sie es abgesehen haben.", italian="Si dice che siano sempre riusciti\na ottenere i tesori su cui avevano messo gli\nocchi.", spanish="Se dice que siempre consiguen\ntodo lo que se proponen."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
