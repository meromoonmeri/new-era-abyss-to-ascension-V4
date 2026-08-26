-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 384, 232, Direction.UpLeft, "NPC_BANEBUU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Your team has done it,\n[hero]! You're beyond belief!", french="Vous avez réussi,\n[hero]! Vous êtes incroyables!", german="Euer Team hat es geschafft,\n[hero]! Ihr seid einfach unglaublich!", italian="La tua squadra ce l'ha fatta,\n[hero]! Siete incredibili!", spanish="¡Tu equipo lo ha logrado,\n[hero]! ¡Sois increíbles!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci mille fois!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Everything was [CS:N]Darkrai[CR]'s doing!", french="Tout est de la faute de cet\nimmonde [CS:N]Darkrai[CR]!", german="Das war alles das Werk von\n[CS:N]Darkrai[CR]!", italian=" È tutta opera di [CS:N]Darkrai[CR]!", spanish=" ¡Todo ha sido obra de [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I, for one, am amazed!", french="En ce qui me concerne,\nje suis abasourdi!", german=" Ich für meinen Teil bin erstaunt!", italian=" Sono sbalordito!", spanish=" ¡Estoy sorprendido!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
