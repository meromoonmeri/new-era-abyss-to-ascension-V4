-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", french="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", german="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", italian="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?", spanish="...Fnarff... Yes? I'll open up the shop-related\nmenus for you. Which one would you like?"})
  do local __choice = SkySceneKit.ask({{english="Assembly", french="Assembly", german="Assembly", italian="Assembly", spanish="Assembly"}, {english="Check Assembly", french="Vérifier le Rassemblement", german="Check Assembly", italian="Check Assembly", spanish="Comprobar Registro"}, {english="Link Moves", french="Lier les capacités", german="Link Moves", italian="Link Moves", spanish="Enlazar movimientos"}, {english="Mini Game", french="Mini Game", german="Mini Game", italian="Mini Game", spanish="Mini Game"}, {english="Sort Items", french="Trier les objets", german="Sort Items", italian="Sort Items", spanish="Ordenar objetos"}, {english="Appraisal", french="Appraisal", german="Appraisal", italian="Appraisal", spanish="Appraisal"}, {english="Add Team Members", french="Add Team Members", german="Add Team Members", italian="Add Team Members", spanish="Add Team Members"}, {english="Add Items ", french="Add Items ", german="Add Items ", italian="Add Items ", spanish="Add Items "}, {english="Add Items2", french="Ajout objets2", german="Add Items2", italian="Add Items2", spanish="Añadir objetos 2"}, {english="NPC Job", french="Mission PNJ", german="NPC Job", italian="NPC Job", spanish="Misión NPC"}, {english="Bottled Message Job", french="Mission Bouteille", german="Bottled Message Job", italian="Bottled Message Job", spanish="Misión de mensaje en un frasco"}, {english="Release Jobs", french="Missions publiées", german="Release Jobs", italian="Release Jobs", spanish="Eliminar misiones"}, {english="Cleared all Special Episodes", french="Terminé tous les Episodes Spé.", german="Cleared all Special Episodes", italian="Cleared all Special Episodes", spanish="Capítulos especiales completados"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- switch(message_Menu(MENU_TEAM_ASSEMBLY)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_RECURITABLE_CAN_ADD"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD) [ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Can add Shaymin", french="Ajout de Shaymin possible", german="Can add Shaymin", italian="Can add Shaymin", spanish="Puede añadirse a Shaymin"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Cannot add Shaymin", french="Ajout de Shaymin impossible", german="Cannot add Shaymin", italian="Cannot add Shaymin", spanish="No puede añadirse a Shaymin"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 3 then
  -- message_Close
  -- switch(message_Menu(MENU_LINK_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("s08p01a__quiz0100", "s08p01a__quiz01", hero, partner) -- supervision_ExecuteActing(LEVEL_S08P01A, 'QUIZ01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  -- switch(message_Menu(MENU_STAFF_CREDITS4)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- message_Close
  -- switch(message_Menu(MENU_APPRAISAL)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 7 then
  -- message_Close
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 14, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 16, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 5, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good morning! I am [c_name:NPC_NEW_FRIEND].", french="Good morning! I am [c_name:NPC_NEW_FRIEND].", german="Good morning! I am [c_name:NPC_NEW_FRIEND].", italian="Buongiorno! Io sono [c_name:NPC_NEW_FRIEND].", spanish="Good morning! I am [c_name:NPC_NEW_FRIEND]."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 8 then
  -- message_Close
  -- item_Set(0, 121, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 9 then
  -- message_Close
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_STORAGE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_S) [ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_STORAGE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Could not receive [s_item:0]", french="[CN]Impossible de recevoir l'objet [s_item:0]", german="[CN]Could not receive [s_item:0]", italian="[CN]Could not receive [s_item:0]", spanish="[CN]El objeto [s_item:0] no pudo recibirse."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Received [s_item:0]", french="[CN]Reçu l'objet [s_item:0]", german="[CN]Received [s_item:0]", italian="[CN]Received [s_item:0]", spanish="[CN]Objeto [s_item:0] recibido."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 10 then
  -- message_Close
  -- switch(ProcessSpecial(PROCESS_SPECIAL_INIT_RANDOM_NPC_JOBS, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Will you take the job?", french="Voulez-vous accepter la mission?", german="Will you take the job?", italian="Will you take the job?", spanish="¿Aceptas la misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Sì", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(1, 2) ROM
  if __choice == 1 then
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Added to list.", french="Ajouté à la liste", german="Added to list.", italian="Added to list.", spanish="Añadida a la lista."})
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 10 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if true then -- default
  end
  end
  -- @label_21 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 11 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if true then -- default
  end
  end
  -- @label_22 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="List is full.", french="La liste est pleine", german="List is full.", italian="List is full.", spanish="La lista está llena."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else -- default/annulation
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good-bye.", french="Good-bye.", german="Good-bye.", italian="Good-bye.", spanish="Good-bye."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Job Distribution Complete", french="Attribution des missions terminée", german="Job Distribution Complete", italian="Job Distribution Complete", spanish="Distribución de misiones completada"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 11 then
  -- message_Close
  -- switch(ProcessSpecial(PROCESS_SPECIAL_INIT_RANDOM_NPC_JOBS, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There was a Message in the Bottle.", french="[CN]La bouteille contient un message.", german="[CN]There was a Message in the Bottle.", italian="[CN]There was a Message in the Bottle.", spanish="[CN]Había un mensaje en el frasco."})
  -- message_Close
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Receive this Message?", french="[CN]Lire ce message?", german="[CN]Receive this Message?", italian="[CN]Receive this Message?", spanish="[CN]¿Quieres recibir este mensaje?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Sì", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(1, 2) ROM
  if __choice == 1 then
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Added to list.", french="[CN]Ajouté à la liste.", german="[CN]Added to list.", italian="[CN]Added to list.", spanish="[CN]Se añadió a la lista."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]List is full.", french="[CN]La liste est pleine.", german="[CN]List is full.", italian="[CN]List is full.", spanish="[CN]La lista está llena."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else -- default/annulation
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Left that spot.", french="[CN]Parti de cet endroit.", german="[CN]Left that spot.", italian="[CN]Left that spot.", spanish="[CN]Se liberó ese espacio."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The Bottle was empty.", french="[CN]La bouteille est vide.", german="[CN]The Bottle was empty.", italian="[CN]The Bottle was empty.", spanish="[CN]El frasco estaba vacío."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 12 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[9] = 1 -- $PERFORMANCE_PROGRESS_LIST[9] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 3 -- adventure_log = 3 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[17] = 1 -- $PERFORMANCE_PROGRESS_LIST[17] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[43] = 2 -- dungeon_mode(43) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[42] = 2 -- dungeon_mode(42) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[41] = 2 -- dungeon_mode(41) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[40] = 2 -- dungeon_mode(40) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[39] = 2 -- dungeon_mode(39) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[38] = 2 -- dungeon_mode(38) = DMODE_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[16] = 1 -- $PERFORMANCE_PROGRESS_LIST[16] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[25] = 1 -- $PERFORMANCE_PROGRESS_LIST[25] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[37] = 2 -- dungeon_mode(37) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[36] = 2 -- dungeon_mode(36) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 3 -- dungeon_mode(35) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 2 -- dungeon_mode(34) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[33] = 2 -- dungeon_mode(33) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[32] = 2 -- dungeon_mode(32) = DMODE_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 2 -- adventure_log = 2 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[15] = 1 -- $PERFORMANCE_PROGRESS_LIST[15] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[31] = 2 -- dungeon_mode(31) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[30] = 2 -- dungeon_mode(30) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[29] = 2 -- dungeon_mode(29) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[28] = 2 -- dungeon_mode(28) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[27] = 2 -- dungeon_mode(27) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 2 -- dungeon_mode(25) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 2 -- dungeon_mode(24) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[26] = 2 -- dungeon_mode(26) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[23] = 2 -- dungeon_mode(23) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[22] = 2 -- dungeon_mode(22) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 2 -- dungeon_mode(21) = DMODE_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[28] = 1 -- $PERFORMANCE_PROGRESS_LIST[28] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 3 -- dungeon_mode(20) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[19] = 2 -- dungeon_mode(19) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[18] = 2 -- dungeon_mode(18) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 3 -- dungeon_mode(17) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[14] = 1 -- $PERFORMANCE_PROGRESS_LIST[14] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[30] = 1 -- $PERFORMANCE_PROGRESS_LIST[30] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[16] = 2 -- dungeon_mode(16) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[15] = 2 -- dungeon_mode(15) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 2 -- dungeon_mode(14) = DMODE_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[13] = 1 -- $PERFORMANCE_PROGRESS_LIST[13] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1 -- adventure_log = 1 (journal NDS)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[13] = 2 -- dungeon_mode(13) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 3 -- dungeon_mode(12) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[11] = 2 -- dungeon_mode(11) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 3 -- dungeon_mode(10) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[9] = 2 -- dungeon_mode(9) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 3 -- dungeon_mode(8) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[31] = 1 -- $PERFORMANCE_PROGRESS_LIST[31] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 3 -- dungeon_mode(7) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[29] = 1 -- $PERFORMANCE_PROGRESS_LIST[29] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 3 -- dungeon_mode(6) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 1 -- $PERFORMANCE_PROGRESS_LIST[5] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[8] = 1 -- $PERFORMANCE_PROGRESS_LIST[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 0 -- adventure_log = 0 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[27] = 1 -- $PERFORMANCE_PROGRESS_LIST[27] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[4] = 1 -- $PERFORMANCE_PROGRESS_LIST[4] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[5] = 2 -- dungeon_mode(5) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 3 -- dungeon_mode(4) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[3] = 1 -- $PERFORMANCE_PROGRESS_LIST[3] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[12] = 1 -- $PERFORMANCE_PROGRESS_LIST[12] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 3 -- dungeon_mode(3) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[1] = 1 -- $PERFORMANCE_PROGRESS_LIST[1] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[2] = 1 -- $PERFORMANCE_PROGRESS_LIST[2] = 1 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[2] = 2 -- dungeon_mode(2) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Unlocked a dungeon.", french="[CN]Débloqué un donjon.", german="[CN]Unlocked a dungeon.", italian="[CN]Unlocked a dungeon.", spanish="[CN]Se desbloqueó un territorio."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 13 then
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1000 -- adventure_log = 1000 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1001 -- adventure_log = 1001 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1002 -- adventure_log = 1002 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1003 -- adventure_log = 1003 (journal NDS)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1004 -- adventure_log = 1004 (journal NDS)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Cleared all Special Episodes.", french="[CN]Terminé tous les Episodes Spéciaux.", german="[CN]Cleared all Special Episodes.", italian="[CN]Cleared all Special Episodes.", spanish="[CN]Capítulos especiales completados."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see.", french="I see.", german="I see.", italian="I see.", spanish="I see."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
