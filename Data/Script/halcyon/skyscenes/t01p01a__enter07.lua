-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[109] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[109]
  -- @label_105 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rakkii = SkySceneKit.spawn_npc("chansey", 272, 360, Direction.Down, "NPC_RAKKII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  -- switch(message_Menu(MENU_DAY_CARE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_104 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[109] = 1 -- $SCENARIO_TALK_BIT_FLAG[109] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english=" Thank you!", french=" Merci!", german=" Danke!", italian=" Grazie!", spanish=" ¡Gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="The way I can be standing here,\njust as always... I owe that to you!", french="Si je suis ici, comme je le fais\ntoujours... C'est à vous que je le dois!", german="Der Umstand, dass ich hier wie\ngewohnt stehen kann... Das verdanke ich euch!", italian="Starò qui come sempre e\npotrete contare su di me...\nVe lo devo!", spanish="Poder estar aquí tan tranquila,\ncomo siempre... ¡es algo que os debo!"})
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english=" Honestly, thank you! ♪", french=" Merci de tout cœur! ♪", german=" Meinen ehrlichen Dank! ♪", italian=" Grazie di tutto cuore! ♪", spanish=" ¡Gracias de todo corazón! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  if ((SV.SkyTalkBitFlags or {})[108] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[108]
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[108] = 1 -- $SCENARIO_TALK_BIT_FLAG[108] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rakkii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rakkii) end)
  SkySceneKit.say({english="The two of you can do this!\nI know it! It just takes effort!", french="Vous pouvez y arriver!\nJe le sais! Encore un petit effort!", german="Ihr zwei könnt das schaffen!\nIch weiß es! Es bedarf nur einiger\nAnstrengung!", italian="Voi due ce la potete fare!\nLo so! Dovete impegnarvi al massimo!", spanish="¡Sé que podéis hacerlo! ¡Solo\ntenéis que esforzaros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_105 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
