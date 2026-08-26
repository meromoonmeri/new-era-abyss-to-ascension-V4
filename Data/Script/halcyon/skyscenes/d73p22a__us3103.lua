-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/us3103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 264, 216, Direction.UpRight, "NPC_GOORIKII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" Until we meet again!", french=" A la revoyure!", german=" Bis zum nächsten Mal!", italian=" A presto!", spanish=" ¡Hasta la próxima!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="I like to spend my days off by\nclimbing to the summit and greeting the\nmorning sun.", french="J'aime passer mes jours\nde congé à escalader la montagne jusqu'au\nsommet pour saluer le soleil levant.", german="Ich mag es, während meiner\nfreien Tage den Gipfel zu erklimmen, um die\nMorgensonne zu grüßen.", italian="Mi piace trascorrere il mio\ntempo libero scalando la montagna e\nammirare l'alba da lassù.", spanish="Me gusta pasar mi tiempo libre\nsubiendo hasta la cima para dar los buenos días\nal sol matutino."})
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="It's a bit challenging, but that's\nwhy it can be so wonderful.", french="C'est un peu éprouvant, mais\nla récompense est à la hauteur du défi.", german="Es ist ein wenig fordernd, aber\ndas ist auch ein Grund dafür, warum es so\nwundervoll sein kann.", italian="È piuttosto impegnativo, ma è\nper questo che è così bello.", spanish="Es todo un reto, pero\neso lo convierte en algo maravilloso."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
