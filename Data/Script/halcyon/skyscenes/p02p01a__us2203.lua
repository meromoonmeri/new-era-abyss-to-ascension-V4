-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/us2203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_okorizaru = SkySceneKit.spawn_npc("primeape", 208, 232, Direction.UpRight, "NPC_OKORIZARU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okorizaru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english=" We owe a lot to you.", french=" Nous vous devons beaucoup.", german=" Wir schulden euch wirklich viel.", italian=" Vi dobbiamo molto.", spanish=" Os debemos un montón."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="I can relax like this because it's\npeaceful.[K] Thanks to you!", french="Si je peux me détendre comme\nça, c'est parce que la paix est revenue, grâce\nà vous.[K] Merci!", german="Ich kann mich nur so entspannen,\nweil es so friedlich ist.[K] Dafür danke ich euch!", italian="Mi posso rilassare così perché\nè tornata la pace.[K] Grazie a voi!", spanish="Me puedo relajar así gracias a\nlo que habéis hecho.[K] ¡Muchas gracias!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okorizaru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="It turns out we weren't being\nhelpful in any way...", french="Finalement, on n'a pas été d'un\ngrand secours...", german="Es stellte sich heraus, dass wir\nin keinster Art und Weise hilfreich waren.", italian="Non potevamo renderci utili\nin nessun modo...", spanish="Al final, no estábamos haciendo\nnada útil..."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="So we came back to the\nHot Spring.", french="... alors on est revenus à la\nSource Chaude.", german="Also sind wir zurück zur\nHeißen Quelle gekommen.", italian="Così siamo tornati alla Sorgente\nTermale.", spanish=" Así que volvimos a la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="I feel guilty for being relaxed\nas I say this, but...[K]we're counting on you!", french="Je culpabilise un peu de vous\ndire ça alors que je suis en train de me\nprélasser, mais...[K] on compte sur vous!", german="Ich fühle mich schuldig, weil ich\nmich zum Zeitpunkt dieses Ausspruchs so\nentspannt fühle, aber...[K] Wir zählen auf euch!", italian="Mi sento un po' in colpa a\nstarmene qui a rilassarmi, ma...[K]\ncontiamo su di voi!", spanish="Me siento culpable por deciros\nesto estando aquí tan relajado, pero...[K]\n¡contamos con que os encarguéis de todo!"})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="Stop the planet's paralysis or\nsomething! You can do it!", french="Empêchez la Paralysie de la\nPlanète! Faites quelque chose! Vous pouvez\ny arriver!", german="Haltet die Lähmung des Planeten\nauf! ...Oder so! ...Ihr könnt das schaffen!", italian="Scongiurate la paralisi del\npianeta! Ce la potete fare!", spanish="¡Detened la parálisis del planeta,\nhaced algo! ¡Podéis hacerlo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
