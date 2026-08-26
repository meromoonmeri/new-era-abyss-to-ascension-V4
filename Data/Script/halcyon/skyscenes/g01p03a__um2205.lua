-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um2205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_namakero = SkySceneKit.spawn_npc("slakoth", 280, 224, Direction.UpLeft, "NPC_NAMAKERO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Exploring is far too much\neffort...[K] Maybe we'll go to the Hot Spring...", french="L'exploration, ça nous épuise...[K]\nEt si on allait à la Source Chaude?", german="Erkunden erfordert viel zu viel\nAnstrengung.[K] Vielleicht werden wir zur\nHeißen Quelle gehen.", italian="Anche esplorare è troppo\nfaticoso...[K] Al massimo potremmo andare alla\nSorgente Termale...", spanish="Explorar supondría demasiado\nesfuerzo...[K] Quizás vayamos a la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="But going to the Hot Spring from\nhere takes too much effort...", french="Ah ouais, mais il faudrait faire\nla route jusqu'à la Source Chaude... Nan,\nça aussi, ce serait trop épuisant...", german="Aber von hier zur Heißen Quelle\nzu gehen, erfordert zu viel Anstrengung.", italian="Ma andare da qui fino alla\nSorgente Termale è troppo faticoso...", spanish="Aunque ir a la Terma desde aquí\ntambién puede resultar agotador..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_namakero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english=" What's a Recycle Shop?", french=" C'est quoi une Bourse d'Echange?", german="Was ist ein\nWiederverwertungsladen?", italian=" Che cos'è un Centro Riciclo?", spanish=" ¿Qué es el [CS:K]Reciclaje Explorador[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_namakero) end)
  SkySceneKit.say({english="Learning things takes too\nmuch effort...", french="Apprendre de nouveaux trucs,\nc'est trop fatigant...", german="Neues zu lernen ist wirklich\nsehr anstrengend...", italian=" Imparare è troppo faticoso...", spanish="Aprender cosas me cansa\nlo indecible..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
