-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 456, 152, Direction.Down, "NPC_SOONANSU")
  -- SetAnimation(2) [anim idle native]
  -- debug_Print('LABAL_TOP') [neutre/état moteur]
  -- switch(message_Menu(MENU_RECYCLE_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_93 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_RECYCLE_SHOP2"] or 0) -- switch(message_Menu(MENU_RECYCLE_SHOP2)) [message_Menu(MENU_RECYCLE_SHOP2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- debug_Print('LABAL_SET02') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 6 -- $EVENT_LOCAL = 6 (ROM)
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('LABAL_SET03') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 7 -- $EVENT_LOCAL = 7 (ROM)
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('LABAL_SET04') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 8 -- $EVENT_LOCAL = 8 (ROM)
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- debug_Print('LABAL_SELECT') [neutre/état moteur]
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 432, 152, Direction.Down, "NPC_SOONANO")
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="It's so exciting! You never know\nwhat you might find!\nEnter the Big Treasure [CS:I]Prize Ticket[CR] drawing?", french="C'est si excitant! On ne sait\njamais sur quoi on va tomber!\nParticiper à la loterie Méga Magot?", german="Das ist so aufregend! Du weißt\nnie, was du kriegst! Hast du Interesse an der\n[CS:I]Preisticket[CR]-Aktion für den Großen Schatz?", italian="È emozionante! Non si sa mai\ncosa può uscire! Vuoi partecipare all'estrazione\ndei [CS:I]Buoni Premio[CR] del Gran Tesoro?", spanish="¡Qué emocionante! Nunca se sabe\nlo que podrías encontrar...\n¿Deseas participar en el sorteo \"Gran Tesoro\"?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_93 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- debug_Print('LABAL_SET01') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 5 -- $EVENT_LOCAL = 5 (ROM)
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="OK, please select a color card.\nRed, Blue, or Yellow?", french="Très bien, choisissez une\ncouleur: rouge, bleu ou jaune?", german="Okay, wähle bitte eine Farbe.\nRot, Blau oder Gelb?", italian="Bene, scegli una carta colorata.\nRossa, blu o gialla?", spanish="Bien, ahora elige una tarjeta.\n¿Roja, azul o amarilla?"})
  do local __choice = SkySceneKit.ask({{english="Red", french="Rouge", german="Rot", italian="Rossa", spanish="Roja"}, {english="Blue", french="Bleu", german="Blau", italian="Blu", spanish="Azul"}, {english="Yellow", french="Jaune", german="Gelb", italian="Gialla", spanish="Amarilla"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" OK, Blue then.", french=" Bleu? O.K.!", german=" Gut, Blau isses.", italian=" Ok, blu allora.", spanish=" Bien, la azul."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" Right! Blue!", french=" Banco! Bleu!", german=" Blau! Genau!", italian=" Giusto! Blu!", spanish=" ¡Eso! ¡La azul!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_49 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" OK, Yellow then.", french=" Jaune? O.K.!", german=" Gut, Gelb isses.", italian=" Ok, gialla allora.", spanish=" Bien, la amarilla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" Right! Yellow!", french=" Banco! Jaune!", german=" Gelb! Genau!", italian=" Giusto! Gialla!", spanish=" ¡Eso! ¡La amarilla!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_49 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" OK, Red then.", french=" Rouge? O.K.!", german=" Gut, Rot isses.", italian=" Ok, rossa allora.", spanish=" Bien, la roja."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" Right! Red!", french=" Banco! Rouge!", german=" Rot! Genau!", italian=" Giusto! Rossa!", spanish=" ¡Eso! ¡La roja!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_49 [étiquette de flux ExplorerScript]
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_50 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- @switch44_1155 [étiquette de flux ExplorerScript]
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw <= 50 then
  -- jump @label_51 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 90 then
  -- jump @label_52 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 95 then
  -- jump @label_53 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_54 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- @switch44_1156 [étiquette de flux ExplorerScript]
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw <= 40 then
  -- jump @label_51 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 80 then
  -- jump @label_52 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 90 then
  -- jump @label_53 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_54 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 4 then
  -- @switch44_1157 [étiquette de flux ExplorerScript]
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw <= 30 then
  -- jump @label_51 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 75 then
  -- jump @label_52 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 85 then
  -- jump @label_53 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_54 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 5 then
  -- jump @switch44_1154 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch44_1155 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch44_1156 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 8 then
  -- jump @switch44_1157 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch44_1154 [étiquette de flux ExplorerScript]
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw <= 50 then
  -- @label_51 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.LOTTERY_RESULT = 0 -- $LOTTERY_RESULT = 0 (ROM)
  -- @label_59 [étiquette de flux ExplorerScript]
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonansu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_soonano, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Is it a win? Is it not?", french=" Alors? C'est perdu?", german=" Isses Gewinn? Isses keiner?", italian=" Avrai vinto? Oppure no?", spanish=" ¿Hay premio? ¿O no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).LOTTERY_RESULT or 0) -- switch($LOTTERY_RESULT) [GameVar LOTTERY_RESULT (SV.SkyVars)]
  if __sw == 0 then
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ganz genau!", italian=" Giusto!", spanish=" ¡Eso, eso!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Is that so? That's not too bad.", french="Ah, vraiment?\nCe n'est pas bien grave.", german="So isses?\nGar nicht mal so schlecht.", italian=" Davvero? Non è tanto male.", spanish=" ¿De verdad? No está mal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_soonano, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Well, here's your\nconsolation prize.", french="Tenez, voici un lot\nde consolation.", german=" Nun gut, ein Trostpreis isses.", italian="Beh, eccoti il premio\ndi consolazione.", spanish="Bueno, aquí tienes un\npremio de consolación."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- @switch51_1160 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 7) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_66 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @switch51_1161 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 10) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_66 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @switch51_1162 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 13) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_66 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- jump @switch51_1159 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch51_1160 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch51_1161 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 8 then
  -- jump @switch51_1162 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch51_1159 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 4) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- @label_66 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN][hero] received the\n[CN][s_item:0]!", french="[CN][hero] reçoit\n[CN]l'objet [s_item:0]!", german="[CN][hero] erhält\n[CN]das Item [s_item:0]!", italian="[CN][hero] ha ricevuto lo strumento\n[CN][s_item:0]!", spanish="[CN]¡[hero] ha obtenido\n[CN][s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_67 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- @label_89 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 5 or __sw == 6 or __sw == 7 or __sw == 8 then
  -- jump @label_93 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Draw another [CS:I]Prize Ticket[CR]?", french=" Utiliser un autre [CS:I]Ticket Magot[CR]?", german=" Noch ein [CS:I]Preisticket[CR] einlösen?", italian="Vuoi estrarre un altro\n[CS:I]Buono Premio[CR]?", spanish=" ¿Deseas participar con otro [CS:I]boleto[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Come back anytime!", french=" Revenez quand vous voulez!", german=" Mach bald mal wieder mit!", italian=" Tornate presto!", spanish=" ¡Vuelve cuando quieras!"})
  -- message_Close
  -- jump @label_93 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_7 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="You can draw once for\neach Ticket!", french="Chaque ticket vous donne droit\nà un tirage!", german="Für jedes Ticket\ngibt es einen Preis!", italian="Ogni Buono vale solo per\nun'estrazione!", spanish="Puedes participar una vez\ncon cada [CS:I]boleto[CR]."})
  -- message_KeyWait
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- @label_23 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_34 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Draw a [CS:I]Prize Ticket[CR]?", french=" Utiliser un [CS:I]Ticket Magot[CR]?", german=" Ein [CS:I]Preisticket[CR] einlösen?", italian=" Vuoi estrarre un [CS:I]Buono Premio[CR]?", spanish="¿Quieres participar con\nun [CS:I]Boleto[CR]?"})
  -- @label_39 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- debug_Print('LABEL_LOTTERY_DEL_TYPE02') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 170, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('LABEL_LOTTERY_DEL_TYPE03') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 171, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('LABEL_LOTTERY_DEL_TYPE04') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 172, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('LABEL_LOTTERY_DEL_TYPE01') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 169, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Select the Ticket you'd like\nto use.", french=" Choisissez le ticket à utiliser.", german="Wähle bitte ein Ticket aus,\ndas du verwenden möchtest.", italian="Seleziona il Buono\nche vuoi utilizzare.", spanish="Vuelve a elegir el [CS:I]boleto[CR]\nque quieres usar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- @label_36 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Draw a [CS:I]Silver Ticket[CR]?", french=" Utiliser un [CS:I]Ticket Argent[CR]?", german=" Ein [CS:I]Silberticket[CR] einlösen?", italian=" Vuoi estrarre un [CS:I]Buono Rubino[CR]?", spanish="¿Quieres participar con\nun [CS:I]Boleto Plata[CR]?"})
  -- jump @label_39 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- @label_37 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Draw a [CS:I]Gold Ticket[CR]?", french=" Utiliser un [CS:I]Ticket Or[CR]?", german=" Ein [CS:I]Goldticket[CR] einlösen?", italian=" Vuoi estrarre un [CS:I]Buono Oro[CR]?", spanish="¿Quieres participar con\nun [CS:I]Boleto Oro[CR]?"})
  -- jump @label_39 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- @label_38 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Draw a [CS:I]Prism Ticket[CR]?", french=" Utiliser un [CS:I]Ticket Irisé[CR]?", german=" Ein [CS:I]Prismaticket[CR] einlösen?", italian=" Vuoi estrarre un [CS:I]Buono Iride[CR]?", spanish="¿Quieres participar con\nun [CS:I]Boleto Prisma[CR]?"})
  -- jump @label_39 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- @label_35 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" You want to cancel?", french=" Vous voulez annuler?", german=" Du möchtest abbrechen?", italian=" Vuoi annullare?", spanish=" ¿No quieres continuar?"})
  -- message_KeyWait
  -- jump @label_93 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_26 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_25 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_21 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_18 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_29 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_31 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_30 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_28 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_33 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_32 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_15 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prism Ticket", french="Ticket Irisé", german="Prismaticket", italian="Buono Iride", spanish="Bol. Prisma"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  -- @label_24 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Gold Ticket", french="Ticket Or", german="Goldticket", italian="Buono Oro", spanish="Boleto Oro"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_22 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Silver Ticket", french="Ticket Argent", german="Silberticket", italian="Buono Rubino", spanish="Boleto Plata"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_19 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Select which Ticket to use.", french=" Choisissez le ticket à utiliser.", german="Wähle aus, welches Ticket\ndu verwenden möchtest.", italian=" Seleziona il Buono da utilizzare.", spanish=" Elige el [CS:I]boleto[CR] que quieras usar."})
  do local __choice = SkySceneKit.ask({{english="Prize Ticket", french="Ticket Magot", german="Preisticket", italian="Buono Premio", spanish="Boleto"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_30 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_31 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_29 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_32 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="I'm sorry to say that if you don't\nhave any [CS:I]Prize Tickets[CR], you can't participate in\nthe drawing...", french="Je suis désolé, mais il vous\nfaut un [CS:I]Ticket Magot[CR] pour participer\nà cette loterie...", german="Es tut mir leid, aber ohne\n[CS:I]Preisticket[CR] kannst du an der Preisvergabe\nunglücklicherweise nicht teilnehmen...", italian="Mi spiace, ma se non possiedi\nun [CS:I]Buono Premio[CR], non puoi partecipare\nall'estrazione...", spanish="Siento decirte que, si no cuentas\ncon ningún [CS:I]boleto[CR], no puedes participar\nen el sorteo..."})
  -- message_Close
  -- jump @label_93 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Huh? Your Bag's full?", french=" Hein? Votre Sac est plein?", german=" Was? Dein Beutel ist voll?", italian=" Eh? Hai la Sacca piena?", spanish="¿Cómo? ¿Que tienes\nla Bolsa llena?"})
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="OK, I'll just send this to your\nstorage, then.", french="O.K., dans ce cas, je l'envoie\ndirectement dans votre réserve.", german="Okay, dann werde ich es\nfür dich einlagern.", italian="Va bene, allora te lo spedirò\nal deposito.", spanish="Bueno, no pasa nada... Habrá\nque almacenarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]The [s_item:0] was\n[CN]sent to storage.", french="[CN]L'objet [s_item:0] a été\n[CN]envoyé à la réserve.", german="[CN][s_item:0] wurde\n[CN]für dich gelagert.", italian="[CN]Lo strumento [s_item:0]\n[CN]è stato inviato al deposito.", spanish="[CN]El objeto [s_item:0]\n[CN]ha sido almacenado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_STORAGE, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_89 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- @label_61 [étiquette de flux ExplorerScript]
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" So is it a win or not?", french=" C'est gagné, c'est ça?", german=" Isses Gewinn? Isses keiner?", italian=" Allora? Avrai vinto oppure no?", spanish=" Entonces... ¿ha ganado o no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).LOTTERY_RESULT or 0) -- switch($LOTTERY_RESULT) [GameVar LOTTERY_RESULT (SV.SkyVars)]
  if __sw == 1 then
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Genau!", italian=" Giusto!", spanish=" ¡Eso, eso!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Wow! That's wonderful!", french=" Waouh! Mais c'est extra!", german=" Wow! Wunderbar isses!", italian=" Wow! È fantastico!", spanish=" ¡Caray! ¡Eso está muy bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_soonano, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="That's so great!\nWhy not take your prize?", french="C'est génial!\nVoici votre lot.", german="Großartig!\nEin schöner Preis isses!", italian="Incredibile!\nEcco qua il tuo premio!", spanish="¡Es genial!\nQuieres tu premio, ¿no es así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- @switch53_1165 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 8) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_74 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @switch53_1166 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 11) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_74 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @switch53_1167 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 14) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_74 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- jump @switch53_1164 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch53_1165 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch53_1166 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 8 then
  -- jump @switch53_1167 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch53_1164 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 5) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- @label_74 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN][hero] received the\n[CN][s_item:0]!", french="[CN][hero] reçoit\n[CN]l'objet [s_item:0]!", german="[CN][hero] erhält\n[CN]das Item [s_item:0]!", italian="[CN][hero] ha ricevuto lo strumento\n[CN][s_item:0]!", spanish="[CN]¡[hero] ha obtenido\n[CN]el objeto [s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_67 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_69 [étiquette de flux ExplorerScript]
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Huh...wait. Don't tell me...[K]\nIs it a big win...?", french="Heu... attends...\nNe me dis pas que...[K]\nC'est le gros lot...?", german="Halt... Sag nichts...[K]\nGroß abgeräumt? Isses so?", italian="Uh... aspetta. Non dirmelo...[K]\nÈ una grossa vincita...?", spanish="Eh... espera. No me digas que...[K]\n¿es un premio gordo?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 356, 204, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 344, 188, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 352, 168, false, 2) end end
  do local __slot = SkySceneKit.team_member(4); if __slot then GROUND:MoveToPosition(__slot, 376, 212, false, 2) end end
  GROUND:MoveToPosition(hero, 428, 180, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 428, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __sw = ((SV.SkyVars or {}).LOTTERY_RESULT or 0) -- switch($LOTTERY_RESULT) [GameVar LOTTERY_RESULT (SV.SkyVars)]
  if __sw == 2 then
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonansu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=".........[K]\nDon't tell me... [K]It's a loss, right?", french="..........[K]\nNon, ne me dis pas que...[K]\nC'est perdu, c'est ça?", german="..........[K]\nSag nichts...[K] Kein Gewinn?", italian="..........[K]\nNon dirmelo...[K] Ha perso, vero?", spanish="...[K]\nNo me lo digas...[K] Ha perdido, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ganz genau!", italian=" Giusto!", spanish=" ¡Eso, eso!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_MISSION_FAILURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Hey...\nWhy not calm down...?", french="Hé...\nOn se calme...", german="Okay...\nWir sollten uns etwas beruhigen...", italian="Ehi...\nDatti una calmata...", spanish="Oye...\n¿Por qué no te calmas?"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 264, 284, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 224, 260, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 264, 232, false, 2) end end
  do local __slot = SkySceneKit.team_member(4); if __slot then GROUND:MoveToPosition(__slot, 300, 260, false, 2) end end
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_soonano, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Sorry to have gotten your hopes\nup.[K] Why not take this consolation prize?", french="Désolé de vous avoir donné de\nfaux espoirs.[K] Veuillez accepter ce lot\nde consolation.", german="Entschuldige bitte, wenn deine\nHoffnungen enttäuscht wurden.[K]\nWie wäre es mit diesem Trostpreis?", italian="Mi dispiace di averti dato delle\nfalse speranze.[K] Perché non prendi questo\npremio di consolazione?", spanish="Siento haberte fastidiado la\nilusión.[K] ¿Quieres un premio de consolación?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- @switch55_1170 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 7) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_81 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @switch55_1171 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 10) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_81 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @switch55_1172 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 13) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_81 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- jump @switch55_1169 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch55_1170 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch55_1171 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 8 then
  -- jump @switch55_1172 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch55_1169 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 4) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- @label_81 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN][hero] received the\n[CN][s_item:0]!", french="[CN][hero] reçoit\n[CN]l'objet [s_item:0]!", german="[CN][hero] erhält\n[CN]das Item [s_item:0]!", italian="[CN][hero] ha ricevuto lo strumento\n[CN][s_item:0]!", spanish="[CN]¡[hero] ha recibido\n[CN]el objeto [s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.DownRight) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(4); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- jump @label_67 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_76 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ganz genau!", italian=" Giusto!", spanish=" ¡Eso, eso!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GROUND:EntTurn(npc_npc_soonano, Direction.Left)
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 256, 152, Direction.Down, "NPC_PATCHIIRU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_soonansu, Direction.Left)
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(11274) — id SE NDS sans portage PMDO identifié
  -- EndAnimation() [neutre/état moteur]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(-16), p.Y+(180), false, 2) end -- Move2PositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(-32), p.Y+(180), false, 2) end -- Move2PositionOffset
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(180), false, 2) end -- Move2PositionOffset
  do local p=SkySceneKit.team_member(4).Position; GROUND:MoveToPosition(SkySceneKit.team_member(4), p.X+(0), p.Y+(180), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P01P04A1_398) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(348, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(348, 196, 60, false) end) -- performer/caméra
  local npc_npc_runpappa = SkySceneKit.spawn_npc("ludicolo", 352, 136, Direction.Down, "NPC_RUNPAPPA")
  GROUND:MoveToPosition(npc_npc_runpappa, 348, 200, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(6)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.DownRight)
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_kireihana = SkySceneKit.spawn_npc("bellossom", 336, 128, Direction.Down, "NPC_KIREIHANA")
  GROUND:MoveToPosition(npc_npc_kireihana, 332, 172, false, 2)
  local npc_npc_kireihana4 = SkySceneKit.spawn_npc("bellossom", 368, 128, Direction.Down, "NPC_KIREIHANA4")
  GROUND:MoveToPosition(npc_npc_kireihana4, 364, 172, false, 2)
  GAME:WaitFrames(15)
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_kireihana2 = SkySceneKit.spawn_npc("bellossom", 336, 128, Direction.Down, "NPC_KIREIHANA2")
  GROUND:MoveToPosition(npc_npc_kireihana2, 332, 148, false, 2)
  local npc_npc_kireihana3 = SkySceneKit.spawn_npc("bellossom", 368, 128, Direction.Down, "NPC_KIREIHANA3")
  GROUND:MoveToPosition(npc_npc_kireihana3, 364, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kireihana, Direction.Down)
  -- se_FadeOut(6420, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_kireihana4, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(npc_npc_runpappa, 2, 2, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  -- GAP: se_Play(11275) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_runpappa) end)
  SkySceneKit.say({english=" Oh, yeaaaaah!", french=" Yeaaah! Musique!!", german=" Waaa-huuu!", italian=" E vaiiiiii!", spanish=" ¡Síiiiiii!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(348, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_kireihana, 316, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_kireihana4, 380, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_kireihana2, 332, 164, false, 2)
  GROUND:MoveToPosition(npc_npc_kireihana3, 364, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_LUDICOLO_DANCE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(44) [anim idle native]
  -- SetAnimation(20) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(44) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kireihana.Position; GROUND:MoveToPosition(npc_npc_kireihana, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana4.Position; GROUND:MoveToPosition(npc_npc_kireihana4, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana2.Position; GROUND:MoveToPosition(npc_npc_kireihana2, p.X+(-22), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kireihana3.Position; GROUND:MoveToPosition(npc_npc_kireihana3, p.X+(22), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(40)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(26) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(90)
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_soonano, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_soonano, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_soonano, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(60)
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_5 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_6 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_7 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- se_FadeOut(7944, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="I must congratulate you.[K]\nWhy not? Here is your big-win prize!", french="Toutes mes félicitations.[K]\nO.K.! Voici le gros lot!", german="Ich muss dir gratulieren.[K]\nSo isses! Hier dein Preis fürs große\nAbräumen!", italian="Congratulazioni![K]\nHai vinto uno splendido premio!", spanish="Enhorabuena.[K]\n¡Aquí tienes tu premio gordo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  -- @switch56_1174 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 9) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_86 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @switch56_1175 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 12) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_86 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- @switch56_1176 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 15) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- jump @label_86 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- jump @switch56_1173 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch56_1174 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch56_1175 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 8 then
  -- jump @switch56_1176 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch56_1173 [étiquette de flux ExplorerScript]
  -- item_SetTableData(0, 6) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- @label_86 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN][hero] received the\n[CN][s_item:0]!", french="[CN][hero] reçoit\n[CN]l'objet [s_item:0]!", german="[CN][hero] erhält\n[CN]das Item [s_item:0]!", italian="[CN][hero] ha ricevuto lo strumento\n[CN][s_item:0]!", spanish="[CN]¡[hero] ha obtenido\n[CN]el objeto [s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_67 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  elseif __sw <= 80 then
  -- @label_52 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.LOTTERY_RESULT = 1 -- $LOTTERY_RESULT = 1 (ROM)
  -- jump @label_59 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw <= 95 then
  -- @label_53 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.LOTTERY_RESULT = 2 -- $LOTTERY_RESULT = 2 (ROM)
  -- jump @label_59 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_54 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.LOTTERY_RESULT = 3 -- $LOTTERY_RESULT = 3 (ROM)
  -- switch(ProcessSpecial(59, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_59 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  else
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[M:D2]What will you do?", french="[M:D2]What will you do?", german="[M:D2]What will you do?", italian="[M:D2]Cosa vuoi fare?", spanish="[M:D2]What will you do?"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Leave it to chance", french="[M:D2]Leave it to chance", german="[M:D2]Leave it to chance", italian="[M:D2]Leave it to chance", spanish="[M:D2]Leave it to chance"}, {english="[M:D2]Lose", french="[M:D2]Lose", german="[M:D2]Lose", italian="[M:D2]Lose", spanish="[M:D2]Lose"}, {english="[M:D2]Win", french="[M:D2]Win", german="[M:D2]Win", italian="[M:D2]Win", spanish="[M:D2]Win"}, {english="[M:D2]Look like a big win, but lose", french="[M:D2]Look like a big win, but lose", german="[M:D2]Look like a big win, but lose", italian="[M:D2]Look like a big win, but lose", spanish="[M:D2]Look like a big win, but lose"}, {english="[M:D2]Win big", french="[M:D2]Win big", german="[M:D2]Win big", italian="[M:D2]Win big", spanish="[M:D2]Win big"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_51 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_52 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_53 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- jump @label_54 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_50 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
