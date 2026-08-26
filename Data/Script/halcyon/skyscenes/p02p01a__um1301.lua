-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/um1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_mankii = SkySceneKit.spawn_npc("mankey", 304, 184, Direction.DownLeft, "NPC_MANKII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mankii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Oooh, yeah... Soaking in the Hot\nSpring is so relaxing...", french="Oooh, ouais... Comme c'est\nreposant de faire trempette dans la Source\nChaude...", german="Aaach, ja... In die Heiße Quelle\neinzutauchen, ist so entspannend.", italian="Oooh, sì... Fare il bagno nella\nSorgente Termale è così rilassante...", spanish="Oooh, sí... Remojarse en la\nTerma es tan relajante..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mankii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="The world's going to be ruined if\nsomething's not done, is that right?", french="Mais alors, si on ne fait rien,\nce sera la fin du monde, pas vrai?", german="Die Welt ist verloren, wenn\nnichts unternommen wird, ist das richtig?", italian="Se qualcuno non fa qualcosa il\nmondo sarà distrutto, vero?", spanish="Eso acabaría con el mundo si\nnadie lo evita, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But what can I do to stop it?\nI can only cheer you on while lolling in the\nHot Spring...", french="Qu'est-ce que j'y peux, moi?\nRien, à part vous soutenir chaleureusement\ntout en me prélassant dans la Source Chaude...", german="Aber was können wir tun, um\ndas aufzuhalten? Ich kann euch nur anfeuern,\nwährend ich mich in der Heißen Quelle räkle.", italian="Ma cosa posso fare io?\nPosso solo tifare per voi mentre mi rilasso\nin questa Sorgente Termale...", spanish="¿Pero qué puedo hacer yo? Lo\núnico que se me ocurre es enviaros todo\nmi apoyo mientras me relajo en la Terma..."})
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" But go do it![K] Save the world!", french="Mais, allez-y, vous![K]\nAllez sauver le monde!", german="Aber zieht los und tut es![K] Rettet\ndie Welt!", italian=" Forza![K] Salvate il mondo!", spanish="¡Ánimo, tenéis que hacerlo![K]\n¡A salvar el mundo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
