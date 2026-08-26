-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[83] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[83]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[83] = 1 -- $SCENARIO_TALK_BIT_FLAG[83] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Ah, yes, I've heard!", french=" Ah oui! J'ai appris la nouvelle!", german=" Ah, ja. Ich habe es gehört!", italian=" Ah, sì, ho sentito!", spanish=" Ah, sí, ¡ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" You've defeated [CS:N]Darkrai[CR]?!", french=" Vous avez vaincu [CS:N]Darkrai[CR]?!", german=" Ihr habt [CS:N]Darkrai[CR] besiegt?!?", italian=" Avete sconfitto [CS:N]Darkrai[CR]?!", spanish=" ¡Han derrotado a [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="That's the [hero] and\n[partner] I revere! So fantastic!", french="Voilà les incomparables\n[hero] et [partner]! Formidable!", german="Das sind [hero] und\n[partner]. Ich bewundere euch! Einfach\nfantastisch!", italian="[hero] e [partner],\nvi adoro! Siete grandi!", spanish="¡Mi admiración por ustedes,\n[hero] y [partner], no tiene límites!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[82] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[82]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[82] = 1 -- $SCENARIO_TALK_BIT_FLAG[82] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I will wish for your success,\n[hero] and [partner]!", french="Je souhaite de tout cœur que\nvous réussissiez, [hero] et\n[partner]!", german="Ich drücke euch die Daumen\nfür ein erfolgreiches Gelingen, [hero]\nund [partner]!", italian="Vi auguro ogni bene,\n[hero] e [partner]!", spanish="¡Les deseo éxito, [hero] y\n[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
