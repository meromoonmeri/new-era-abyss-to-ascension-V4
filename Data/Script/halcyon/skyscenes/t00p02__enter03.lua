-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P02/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An event will be activated.\nWhich one would you like?", french="An event will be activated.\nWhich one would you like?", german="An event will be activated.\nWhich one would you like?", italian="An event will be activated.\nWhich one would you like?", spanish="An event will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="ACTING_TEST", french="ACTING_TEST", german="ACTING_TEST", italian="ACTING_TEST", spanish="ACTING_TEST"}, {english="ITEM_TEST", french="ITEM_TEST", german="ITEM_TEST", italian="ITEM_TEST", spanish="ITEM_TEST"}, {english="MAP_TEST", french="MAP_TEST", german="MAP_TEST", italian="MAP_TEST", spanish="MAP_TEST"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be activated.\nWhich one would you like?", french="An Acting Test will be activated.\nWhich one would you like?", german="An Acting Test will be activated.\nWhich one would you like?", italian="An Acting Test will be activated.\nWhich one would you like?", spanish="An Acting Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="M01A01A", french="M01A01A", german="M01A01A", italian="M01A01A", spanish="M01A01A"}, {english="M01A02A", french="M01A02A", german="M01A02A", italian="M01A02A", spanish="M01A02A"}, {english="M01A03A", french="M01A03A", german="M01A03A", italian="M01A03A", spanish="M01A03A"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- debug_Print('EXECUTE_T00P02_M01A01A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p02__m01a01a00", "t00p02__m01a01a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P02, 'M01A01A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- debug_Print('EXECUTE_T00P02_M01A02A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p02__m01a02a00", "t00p02__m01a02a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P02, 'M01A02A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- debug_Print('EXECUTE_T00P02_M01A03A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p02__m01a03a00", "t00p02__m01a03a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P02, 'M01A03A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Item Usage Test will be activated.\nWhich one would you like?", french="An Item Usage Test will be activated.\nWhich one would you like?", german="An Item Usage Test will be activated.\nWhich one would you like?", italian="An Item Usage Test will be activated.\nWhich one would you like?", spanish="An Item Usage Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="CHECK_ITEM_CARRY", french="CHECK_ITEM_CARRY", german="CHECK_ITEM_CARRY", italian="CHECK_ITEM_CARRY", spanish="CHECK_ITEM_CARRY"}, {english="CHECK_ITEM_WAREHOUSE", french="CHECK_ITEM_WAREHOUSE", german="CHECK_ITEM_WAREHOUSE", italian="CHECK_ITEM_WAREHOUSE", spanish="CHECK_ITEM_WAREHOUSE"}, {english="ADD_ITEM", french="ADD_ITEM", german="ADD_ITEM", italian="ADD_ITEM", spanish="ADD_ITEM"}, {english="DEL_ITEM", french="DEL_ITEM", german="DEL_ITEM", italian="DEL_ITEM", spanish="DEL_ITEM"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You have 1 Blue Gummi.", french="[CN]You have 1 Blue Gummi.", german="[CN]You have 1 Blue Gummi.", italian="[CN]You have 1 Blue Gummi.", spanish="[CN]You have 1 Blue Gummi."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw >= 2 then
  -- @label_12 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You have 2 or more Blue Gummis.", french="[CN]You have 2 or more Blue Gummis.", german="[CN]You have 2 or more Blue Gummis.", italian="[CN]You have 2 or more Blue Gummis.", spanish="[CN]You have 2 or more Blue Gummis."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You have no Blue Gummis.", french="[CN]You have no Blue Gummis.", german="[CN]You have no Blue Gummis.", italian="[CN]You have no Blue Gummis.", spanish="[CN]You have no Blue Gummis."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 2 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_STORAGE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_STORAGE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw >= 2 then
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There are no Blue Gummis in storage.", french="[CN]There are no Blue Gummis in storage.", german="[CN]There are no Blue Gummis in storage.", italian="[CN]There are no Blue Gummis in storage.", spanish="[CN]There are no Blue Gummis in storage."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 3 then
  -- message_Close
  -- item_Set(0, 121, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_B) [ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]A Blue Gummi couldn't be obtained.", french="[CN]A Blue Gummi couldn't be obtained.", german="[CN]A Blue Gummi couldn't be obtained.", italian="[CN]A Blue Gummi couldn't be obtained.", spanish="[CN]A Blue Gummi couldn't be obtained."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Received [s_item:0].", french="[CN]Reçu l'objet [s_item:0].", german="[CN]Received [s_item:0].", italian="[CN]Received [s_item:0].", spanish="[CN]Objeto [s_item:0] recibido."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 4 then
  -- message_Close
  -- item_Set(0, 121, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_REMOVE_TABLE_ITEMS_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_TABLE_ITEMS_) [ProcessSpecial(PROCESS_SPECIAL_REMOVE_TABLE_ITEMS_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You never had a Blue Gummi to start with.", french="[CN]You never had a Blue Gummi to start with.", german="[CN]You never had a Blue Gummi to start with.", italian="[CN]You never had a Blue Gummi to start with.", spanish="[CN]You never had a Blue Gummi to start with."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You lost a Blue Gummi.", french="[CN]You lost a Blue Gummi.", german="[CN]You lost a Blue Gummi.", italian="[CN]You lost a Blue Gummi.", spanish="[CN]You lost a Blue Gummi."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else -- default/annulation
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_P14P01A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(376, 260, 1, false) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Map will be switched.", french="The Map will be switched.", german="The Map will be switched.", italian="The Map will be switched.", spanish="The Map will be switched."})
  -- message_Close
  -- back_ChangeGround(LEVEL_P14P01A2) [décor déjà chargé par EnterZone PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Map was switched.", french="The Map was switched.", german="The Map was switched.", italian="The Map was switched.", spanish="The Map was switched."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteEnter(2) [neutre/état moteur]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
