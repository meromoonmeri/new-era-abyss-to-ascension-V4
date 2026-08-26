-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/us3106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_tamatama = SkySceneKit.spawn_npc("exeggcute", 312, 272, Direction.Down, "NPC_TAMATAMA")
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="We're always here as support\nfor the explorers climbing to the top of\n[CS:P]Sky Peak[CR]! Yes, we are!", french="Nous sommes toujours là, oui\nnous le sommes, pour soutenir les explorateurs\nqui escaladent le [CS:P]Pic Céleste[CR] jusqu'au sommet!", german="Ich bin allzeit bereit, die\nErkunder bei der Besteigung des [CS:P]Himmelsgipfels[CR]\nzu unterstützen! Ja, das bin ich!", italian="Siamo sempre qui per aiutare\ngli esploratori che vogliono raggiungere la cima\ndel [CS:P]Picco del Cielo[CR]! Oh sì che ci siamo!", spanish="Siempre estamos aquí para\nayudar a los exploradores que ascienden\na la cima de la [CS:P]Cumbre del Cielo[CR]. ¡Sí, sí!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Congratulations on making it to\nthe summit safely!", french="Nous vous félicitons d'avoir\natteint le sommet sans trop de dégâts!", german="Herzlichen Glückwunsch zur\nerfolgreichen Besteigung des Gipfels!", italian="Congratulazioni per aver\nraggiunto la vetta!", spanish="¡Enhorabuena por llegar a salvo\na la cima!"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Your achievement made our\nsupport well worth it!", french="Votre réussite justifie\nnotre rôle d'équipe de soutien!", german="Dein Erfolg adelt unsere\nBemühungen!", italian="La vostra impresa rende onore\nai nostri sforzi!", spanish="¡Un logro así hace que haya\nvalido la pena ayudar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
