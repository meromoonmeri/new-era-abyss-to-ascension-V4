-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/us0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 240, 248, Direction.Up, "NPC_MANYUURA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 216, 216, Direction.DownRight, "NPC_AABOKKU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 256, 216, Direction.DownLeft, "NPC_DORAPION")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You're making our Team [CS:X]AWD[CR]\nlook bad!", french="A cause de vos exploits, vous\njetez le discrédit sur notre Equipe [CS:X]DDA[CR]!", german="Ihr lasst unser Team [CS:X]SPA[CR]\nschlecht aussehen!", italian="State mettendo in cattiva luce il\nTeam [CS:X]AWD[CR]!", spanish="¡El [CS:X]Equipo WAD[CR] no está a\nla altura de vuestro equipo! ¡Qué palo!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" The glory is ours next time!", french="La prochaine fois, à nous la\ngloire!", german="Nächstes Mal werden wir\ntriumphieren!", italian="La prossima volta saremo noi a\nprimeggiare!", spanish="¡Pero os superaremos la\npróxima vez!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Well if it isn't you two.[K]\nIt's been a long time.", french="C'est vous.[K] Ça faisait\nlongtemps.", german="Wenn das mal nicht ihr zwei\nseid. [K]Ist schon eine Weile her.", italian="Ma siete proprio voi due![K]\nNe è passato di tempo!", spanish="Mira a quién tenemos aquí.[K]\nHa pasado mucho tiempo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
