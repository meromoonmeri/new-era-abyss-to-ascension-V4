-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P24A/enter13.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_tamatama = SkySceneKit.spawn_npc("exeggcute", 320, 256, Direction.Down, "NPC_TAMATAMA")
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english=" Oh, hey, you're back!", french=" Oh, hé, vous êtes de retour!", german=" Oh, hallo! Da bist du ja wieder!", italian=" Oh, ehi! Avete fatto ritorno!", spanish=" ¡Anda, pero si has vuelto!"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Looks like you've lost your heart\nto the mountain's beauty as well. Ha ha ha!", french="Nous imaginons que\nla beauté de la montagne vous\némerveille aussi. Ha ha ha!", german="Anscheinend hast auch du\ndein Herz an die Schönheit der Berge\nverloren. Hahaha!", italian="Pare che la bellezza di questa\nmontagna abbia travolto anche voi. Ah ah ah!", spanish="Parece que la belleza de la\nmontaña te ha robado el corazón a ti también.\n¡Ja, ja, ja!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english=" How was the summit?", french="Comment avez-vous\ntrouvé le sommet?", german=" Wie war der Gipfel?", italian=" Com'era la cima?", spanish=" ¿Qué tal en la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We've heard that the view up\nthere is spectacular.", french="Nous avons entendu dire\nque la vue là-haut est spectaculaire.", german="Ich habe gehört, die Aussicht\nvon dort sei spektakulär.", italian="Ci hanno detto che il panorama\nda lassù è spettacolare.", spanish="Hemos oído que las vistas\nahí arriba son espectaculares."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
