-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P26A/enter19.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[0] = 1 -- $BIT_FUWARANTE_LOCAL[0] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[1] = 1 -- $BIT_FUWARANTE_LOCAL[1] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[2] = 1 -- $BIT_FUWARANTE_LOCAL[2] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[3] = 1 -- $BIT_FUWARANTE_LOCAL[3] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[4] = 1 -- $BIT_FUWARANTE_LOCAL[4] = 1 (ROM)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 156 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[0] = 0 -- $BIT_FUWARANTE_LOCAL[0] = 0 (ROM)
  -- @label_4 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 18) < 0) then -- if ROM: scn($SCENARIO_MAIN) < [29, 18]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[2] = 0 -- $BIT_FUWARANTE_LOCAL[2] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[3] = 0 -- $BIT_FUWARANTE_LOCAL[3] = 0 (ROM)
  -- @label_7 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_fuwaraido = SkySceneKit.spawn_npc("drifblim", 144, 232, Direction.Down, "NPC_FUWARAIDO")
  -- Turn2DirectionLives vers ACTOR_TALK_MAIN [cible sans placement SSA dans la zone (spawn moteur NDS) : orientation non jouée]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_fuwaraido, 4) end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_fuwaraido, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="Hi!\nThis is [CS:K]Drifblim[CR]'s Gondola.\nWhere would you like to go?", french="Salut!\nBienvenue à la [CS:K]Navette Grodrive[CR].\nOù souhaitez-vous aller?", german="Hallo!\nDies ist die [CS:K]Drifzepeli-Seilbahn[CR].\nWohin möchtest du?", italian="Salve!\nQuesta è l'Agenzia Viaggi [CS:K]Drifblim[CR].\nDove vuoi andare?", spanish="¡Hola!\nEstás en la [CS:K]Góndola Drifblim[CR].\n¿Adónde quieres ir?"})
  -- @label_17 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Shaymin Village", french="Village Shaymin", german="Shaymin-Dorf", italian="Villaggio Shaymin", spanish="Aldea Shaymin"}, {english="Sky Peak 2nd Station Clearing", french="Pic Céleste, trouée du 2[F:E] Relais", german="2. Zwischenlagerlichtung", italian="Bivacco 2 Picco del Cielo", spanish="Base del Segundo Puerto"}, {english="Sky Peak 4th Station Clearing", french="Pic Céleste, trouée du 4[F:E] Relais", german="4. Zwischenlagerlichtung", italian="Bivacco 4 Picco del Cielo", spanish="Base del Cuarto Puerto"}, {english="Sky Peak 6th Station Clearing", french="Pic Céleste, trouée du 6[F:E] Relais", german="6. Zwischenlagerlichtung", italian="Bivacco 6 Picco del Cielo", spanish="Base del Sexto Puerto"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Salir"}}) -- message_SwitchMenu(0, 1, 98) ROM
  if __choice == 1 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 0 -- $EVENT_LOCAL = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" To the [CS:P]Shaymin Village[CR]?", french=" Direction le [CS:P]Village Shaymin[CR]?", german=" Nach [CS:P]Shaymin-Dorf[CR]?", italian="Vuoi andare\nal [CS:P]Villaggio Shaymin[CR]?", spanish=" ¿A [CS:P]Aldea Shaymin[CR]?"})
  -- @label_14 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 156 then
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_19 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[46] = 1 -- $SCENARIO_MAIN_BIT_FLAG[46] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Now...here we go!", french=" Attention... décollage!", german=" Nun... Auf geht's!", italian=" Ok... si parte!", spanish=" Bueno... ¡Vamos allá!"})
  -- message_Close
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 158 then
  if (SkyProg.cmp(29, 15) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 15]
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SkyProg.set(29, 15) -- $SCENARIO_MAIN = scn[29,15] (ROM)
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 160 then
  if (SkyProg.cmp(29, 19) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 19]
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SkyProg.set(29, 19) -- $SCENARIO_MAIN = scn[29,19] (ROM)
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 162 then
  if (SkyProg.cmp(29, 23) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 23]
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SkyProg.set(29, 23) -- $SCENARIO_MAIN = scn[29,23] (ROM)
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- CallCommon CORO_SORANOITADAKI_FLAGSET (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(111, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_24 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 1 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_D73P22A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 2 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_D73P24A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 3 then
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_D73P26A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  pcall(function() SOUND:FadeOutBGM(60) end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_RESULT = 3 -- $DUNGEON_RESULT = 3 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D73P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
  else
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_RECURITABLE_CAN_ADD"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD) [ProcessSpecial(PROCESS_SPECIAL_RECURITABLE_CAN_ADD): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="[CN]You have too many team members\n[CN]for [CS:N]Shaymin[CR] to join your team.", french="[CN]Votre équipe est déjà au complet,\n[CN][CS:N]Shaymin[CR] ne peut pas la rejoindre.", german="[CN]Du hast zu viele Team-Mitglieder, um\n[CN][CS:N]Shaymin[CR] in deinem Team aufzunehmen.", italian="[CN]La tua squadra ha troppi membri,\n[CN]quindi [CS:N]Shaymin[CR] non può entrare a farne parte.", spanish="[CN][CS:N]Shaymin[CR] no puede unirse a tu equipo,\n[CN]ya hay demasiados miembros."})
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english="[CN]Head to the [CS:K]Chimecho[CR] Assembly Post\n[CN]near the entrance to reduce the number of\n[CN]members in your team.", french="[CN]Allez au [CS:K]Point de Rassemblement Eoko[CR]\n[CN]près de l'entrée pour réduire le nombre\n[CN]de membres dans votre équipe.", german="[CN]Begib dich zum [CS:K]Palimpalim-Versammlungsort[CR]\n[CN]in der Nähe des Eingangs, um die\n[CN]Anzahl der Team-Mitglieder anzupassen.", italian="[CN]Vai al Raduno Squadra di [CS:K]Chimecho[CR]\n[CN]vicino all'entrata per diminuire il numero\n[CN]di membri della tua squadra.", spanish="[CN]Dirígete al punto de reunión de [CS:K]Chimecho[CR]\n[CN]que está cerca de la entrada para reducir el\n[CN]número de miembros de tu equipo."})
  -- message_Close
  -- @label_13 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  end
  elseif true then -- default
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Where would you like to go?", french=" Où souhaitez-vous aller?", german=" Wohin möchtest du?", italian=" Dove vuoi andare?", spanish=" ¿Adónde quieres ir?"})
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR] 2nd Station Clearing?", french="Direction le [CS:P]Pic Céleste[CR],\ntrouée du 2[F:E] Relais?", german="Zum [CS:P]Himmelsgipfel[CR],\n2. Zwischenlagerlichtung?", italian="Vuoi andare\nal Bivacco 2 [CS:P]Picco del Cielo[CR]?", spanish="¿A la Base del Segundo Puerto\nde la [CS:P]Cumbre del Cielo[CR]?"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR] 4th Station Clearing?", french="Direction le [CS:P]Pic Céleste[CR],\ntrouée du 4[F:E] Relais?", german="Zum [CS:P]Himmelsgipfel[CR],\n4. Zwischenlagerlichtung?", italian="Vuoi andare\nal Bivacco 4 [CS:P]Picco del Cielo[CR]?", spanish="¿A la Base del Cuarto Puerto\nde la [CS:P]Cumbre del Cielo[CR]?"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR] 6th Station Clearing?", french="Direction le [CS:P]Pic Céleste[CR],\ntrouée du 6[F:E] Relais?", german="Zum [CS:P]Himmelsgipfel[CR],\n6. Zwischenlagerlichtung?", italian="Vuoi andare\nal Bivacco 6 [CS:P]Picco del Cielo[CR]?", spanish="¿A la Base del Sexto Puerto\nde la [CS:P]Cumbre del Cielo[CR]?"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_fuwaraido) end)
  SkySceneKit.say({english=" Thank you for your patronage.", french="Merci d'avoir utilisé\nnos services.", german="Es ist mir immer ein Vergnügen,\ndich als Kunden begrüßen zu dürfen.", italian=" Grazie per averci scelto.", spanish=" Gracias por usar nuestro servicio."})
  -- message_Close
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 22) < 0) then -- elseif ROM: scn($SCENARIO_MAIN) < [29, 22]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[3] = 0 -- $BIT_FUWARANTE_LOCAL[3] = 0 (ROM)
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 158 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[1] = 0 -- $BIT_FUWARANTE_LOCAL[1] = 0 (ROM)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[2] = 0 -- $BIT_FUWARANTE_LOCAL[2] = 0 (ROM)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.BIT_FUWARANTE_LOCAL = SV.SkyVars.BIT_FUWARANTE_LOCAL or {}; SV.SkyVars.BIT_FUWARANTE_LOCAL[3] = 0 -- $BIT_FUWARANTE_LOCAL[3] = 0 (ROM)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
