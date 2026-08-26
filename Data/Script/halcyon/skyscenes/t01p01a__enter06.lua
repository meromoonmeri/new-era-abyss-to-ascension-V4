-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_erekiburu = SkySceneKit.spawn_npc("electivire", 184, 168, Direction.Down, "NPC_EREKIBURU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[59] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[59]
  -- @label_116 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_LINK_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[59] = 1 -- $SCENARIO_TALK_BIT_FLAG[59] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english=" All right! You two are heroes!", french="Super! Vous êtes de véritables\nhéros!", german="In Ordnung! Ihr zwei seid\nHelden!", italian=" Wow, siete due Pokémon eroici!", spanish="La verdad es que siempre nos\nayudáis cuando hace falta."})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="It'll get peaceful in Treasure\nTown too. Thanks for that!", french="Grâce à vous, la paix va\nrevenir à Bourg-Trésor aussi! Merci!", german="Auch in Schatzstadt wird es\nfriedlich werden. Dafür danke ich euch!", italian="Tornerà la pace anche a Borgo\nTesoro. Grazie!", spanish="Por fin podremos respirar\ntranquilos en Aldea Tesoro. Os lo\nagradezco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erekiburu, 4) end)
  if ((SV.SkyTalkBitFlags or {})[58] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[58]
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[58] = 1 -- $SCENARIO_TALK_BIT_FLAG[58] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english="You throw everything you have\ninto this, you two!", french="Donnez tout ce que vous avez,\nvous deux!", german="Legt alles in diese Sache, was\nihr habt, ihr zwei!", italian=" Mettetecela tutta, voi due!", spanish=" ¡Empleaos a fondo con esto!"})
  pcall(function() UI:SetSpeaker(npc_npc_erekiburu) end)
  SkySceneKit.say({english=" You set that [CS:N]Darkrai[CR] straight!", french="Donnez une bonne leçon à ce\n[CS:N]Darkrai[CR]!", german="Rückt diesem [CS:N]Darkrai[CR] den Kopf\nzurecht!", italian=" Fategliela vedere a quel [CS:N]Darkrai[CR]!", spanish="¡Tenéis que darle una lección\na ese [CS:N]Darkrai[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_116 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
