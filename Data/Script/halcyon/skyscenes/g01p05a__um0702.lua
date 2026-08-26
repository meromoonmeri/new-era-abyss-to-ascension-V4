-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/um0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" You two are fantastic!", french="Vous deux alors, vous êtes\nfantastiques!", german=" Ihr zwei seid fantastisch!", italian=" Siete grandi!", spanish=" ¡Sois un equipo fantástico!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You saved the world not just\nonce, but twice! ♪", french="Vous n'avez pas sauvé le monde\nune, mais deux fois! ♪", german="Ihr habt die Welt nicht nur\neinmal, sondern zweimal gerettet! ♪", italian="Avete salvato il mondo non una\nsola volta, ma due! ♪", spanish="¡No solo habéis salvado el\nmundo una vez, sino dos! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think you're going to become an\neven more incredible exploration team!", french="Je crois bien que vous allez\ndevenir une équipe d'exploration encore\nplus impressionnante!", german="Ich bin der Ansicht, dass ihr ein\nnoch unglaublicheres Erkundungsteam werdet!", italian="Penso che diventerete una\nsquadra d'esplorazione fuori dal comune!", spanish="¡A este paso vais a convertiros\nen un equipo aún más extraordinario!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Equal to even the legendary\nTeam [CS:X]Raider[CR]! ♪", french="Peut-être même jusqu'à égaler\nla fameuse Equipe [CS:X]As[CR]! ♪", german="Sogar dem legendären Team\n[CS:X]Schatzsucher[CR] ebenbürtig! ♪", italian="Allo stesso livello del\nleggendario Team [CS:X]Asso[CR]! ♪", spanish="¡Quizás incluso podáis igualar al\nlegendario [CS:X]Equipo As[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Keep up your exploring! ♪", french=" Continuez à explorer! ♪", german=" Setzt eure Erkundungen fort! ♪", italian=" Continuate a esplorare! ♪", spanish=" ¡Seguid explorando! ♪"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You two can do it. You've shown\nme you can! ♪", french="Vous pouvez y arriver, vous\ndeux. Vous me l'avez déjà prouvé moult\nfois! ♪", german="Ihr zwei könnt es schaffen. Ihr\nhabt mir gezeigt, dass ihr es könnt! ♪", italian="Voi due ce la potete fare!\nSappiamo di cosa siete capaci! ♪", spanish="Podéis encargaros de ello. Ya\nme lo habéis probado muchas veces. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's all up to you to defeat that\n[CS:N]Darkrai[CR]! ♪", french="Il n'y a que vous qui puissiez\nvaincre ce [CS:N]Darkrai[CR]! ♪", german="Es ist an euch, [CS:N]Darkrai[CR]\nzu besiegen! ♪", italian="Solo voi potete battere\n[CS:N]Darkrai[CR]! ♪", spanish="¡Ahora os toca derrotar a ese\n[CS:N]Darkrai[CR]! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
