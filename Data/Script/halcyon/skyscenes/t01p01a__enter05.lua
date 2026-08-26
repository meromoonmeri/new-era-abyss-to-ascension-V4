-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yomawaru = SkySceneKit.spawn_npc("duskull", 520, 168, Direction.Down, "NPC_YOMAWARU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[118] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[118]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_DUSKULL_BANK)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[118] = 1 -- $SCENARIO_TALK_BIT_FLAG[118] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Thank you so much,\n[hero] and [partner]!", french="Merci mille fois,\n[hero] et [partner]!", german="Vielen Dank, [hero] und\n[partner]!", italian="Grazie molte, [hero] e\n[partner]!", spanish="¡Muchísimas gracias,\n[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="This gives me the peace of mind\nto run the bank properly!", french="Ainsi, je peux gérer la\nbanque l'âme en paix!", german="Das gibt mir den Seelenfrieden,\nden ich benötige, um die Bank ordentlich zu\nführen!", italian="Ora che il mondo è salvo, ho la\npace mentale necessaria per occuparmi\nadeguatamente della banca.", spanish="Me habéis tranquilizado lo\nsuficiente como para llevar este\nbanco como debe ser."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[117] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[117]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[117] = 1 -- $SCENARIO_TALK_BIT_FLAG[117] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Best of luck! Do take care!", french="Bonne chance! Prenez soin de\nvous!", german=" Viel Glück! Gebt auf euch acht!", italian=" Auguri! Fate attenzione!", spanish=" ¡Buena suerte! ¡Cuidaos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
