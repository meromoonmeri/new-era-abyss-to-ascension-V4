-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P03A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perippaa1 = SkySceneKit.spawn_npc("pelipper", 240, 120, Direction.Down, "NPC_PERIPPAA1")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perippaa1, 4) end)
  if ((SV.SkyTalkBitFlags or {})[120] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[120]
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Hello! Which dungeon would you\nlike to explore?", french="Salut! Quel donjon voulez-vous\nexplorer?", german="Hallo! Welchen Dungeon\nmöchtest du erkunden?", italian="Ciao! Quale dungeon vuoi\nesplorare?", spanish="¡Hola! ¿Qué territorio queréis\nexplorar?"})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  do local __sw = 0 -- switch(main_EnterAdventure(-1, 30)) [main_EnterAdventure(-1, 30): bascule d'écran aventure moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 0 then
  -- @switch0_129 [étiquette de flux ExplorerScript]
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Very good! I'll show you to the\ndungeon right away!", french="Très bien! Je vous y conduis\nde ce pas!", german="Sehr gut! Ich werde dir sofort\nden Weg zum Dungeon weisen!", italian="Molto bene!\nAlla volta del dungeon, allora!", spanish="¡Muy bien! ¡Os llevaré ahora\nmismo!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[40] = 1 -- $SCENARIO_MAIN_BIT_FLAG[40] = 1 (ROM)
  -- switch(main_EnterAdventure(251, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __sw == 1 then
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="I see...[K] If you would like to go\non an exploration, please do tell me.", french="Je vois...[K] Si vous voulez partir\nen exploration, faites-le-moi savoir.", german="Verstehe.[K] Wenn du dich auf eine\nErkundung begeben möchtest, lass es mich bitte\nwissen.", italian="Capisco...[K] Se un'altra volta ti\nva di esplorare, fammelo sapere.", spanish="Ya veo...[K] Si queréis salir de\nexploración, hacédmelo saber."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 20 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="For going to the [CS:P]Hidden Land[CR],\n[hero] will be made the team leader.\nIs that OK?", french="Quand vous irez dans les\n[CS:P]Terres Illusoires[CR], ce sera [hero] le\nmeneur. Ça vous convient?", german="Für die Reise in das\n[CS:P]Verborgene Land[CR] wird [hero] zum\nAnführer des Teams ernannt. Ist das okay?", italian="Per andare alla [CS:P]Terra Nascosta[CR],\n[hero] sarà il leader, va bene?", spanish="Para ir a la [CS:P]Tierra Oculta[CR],\n[hero] deberá liderar el grupo.\n¿Os parece bien?"})
  -- @label_23 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 2 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_22 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="For going to the [CS:P]Hidden Land[CR],\nyour team must consist of only [hero]\nand [partner]. Is that OK?", french="Pour aller dans les [CS:P]Terres\nIllusoires[CR], votre équipe ne doit comprendre que\n[hero] et [partner]. C'est d'accord?", german="Auf der Reise in das\n[CS:P]Verborgene Land[CR] darf euer Team nur aus\n[hero] und [partner] bestehen. Okay?", italian="Per andare alla [CS:P]Terra Nascosta[CR],\nla squadra sarà composta solo da\n[hero] e [partner], va bene?", spanish="Para ir a la [CS:P]Tierra Oculta[CR], el\nequipo solo estará formado por [hero]\ny [partner]. ¿Estáis de acuerdo?"})
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __sw == 21 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="For going to [CS:P]Temporal Tower[CR],\n[hero] will be made the team leader.\nIs that OK?", french="Pour aller à la [CS:P]Tour du Temps[CR],\nce sera [hero] le meneur.\nC'est d'accord?", german="Für die Reise zum [CS:P]Zeitturm[CR] wird\n[hero] zum Anführer des Teams\nernannt. Ist das okay?", italian="Per andare alla [CS:P]Torre del Tempo[CR],\n[hero] sarà il leader, va bene?", spanish="Para ir a la [CS:P]Torre del Tiempo[CR],\n[hero] deberá liderar el grupo.\n¿Os parece bien?"})
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_25 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="For going to [CS:P]Temporal Tower[CR],\nyour team must consist of only [hero]\nand [partner]. Is that OK?", french="Pour aller à la [CS:P]Tour du Temps[CR],\nvotre équipe ne doit comprendre que\n[hero] et [partner]. C'est d'accord?", german="Auf der Reise zum [CS:P]Zeitturm[CR] darf\neuer Team nur aus [hero] und\n[partner] bestehen. Ist das okay?", italian="Per andare alla [CS:P]Torre del Tempo[CR],\nla squadra sarà composta solo da\n[hero] e [partner], Ok?", spanish="A la [CS:P]Torre del Tiempo[CR], solo\npueden ir [hero] y [partner].\n¿Estáis de acuerdo?"})
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __sw == 22 then
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_20 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Hmm...[K] You may not go to this\ndungeon.", french="Hmmm...[K] Vous ne pouvez pas\nvous rendre dans ce donjon.", german="Nanu?[K] Du kannst diesen Dungeon\nnicht betreten.", italian="Eh, no...[K] Non puoi andare in\nquesto dungeon.", spanish="Hum...[K] No podéis ir a este\nterritorio."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="[CS:W]Dungeon Settings Error 4\nThis dungeon is inaccessible while you are\nawaiting rescue.[CR]", french="[CS:W]Paramètres donjon - erreur 4\nCe donjon est inaccessible tant que vous\nattendez les secours.[CR]", german="[CS:W]Dungeon-Einstellungsfehler 4\nDieser Dungeon ist nicht betretbar, während du\nauf Rettung wartest.[CR]", italian="[CS:W]Errore Settaggio Dungeon 4.\nQuesto Dungeon è inaccessibile mentre\nstai aspettando un soccorso.[CR]", spanish="[CS:W]Error 4 de configuración de territorio\nNo puedes acceder a este territorio\nmientras esperas que te rescaten.[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  elseif __sw == 23 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There is a restriction placed on\n[CS:P]Zero Isle North[CR].", french="L'[CS:P]Ile Zéro Nord[CR] est soumise à\nrestrictions.", german="Auf der [CS:P]Null-Insel Nord[CR] gibt es\neine Einschränkung.", italian="Sull'[CS:P]Isola Zero Nord[CR] c'è una\nlimitazione.", spanish="Hay una restricción sobre la\n[CS:P]Isla Cero Norte[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="In [CS:P]Zero Isle North[CR], you will not\nearn Experience Points from the Pokémon you\ndefeat. Is that OK?", french="Sur l'[CS:P]Ile Zéro Nord[CR], vous ne\ngagnerez pas de points Exp. en battant vos\nennemis. C'est d'accord?", german="Auf der [CS:P]Null-Insel Nord[CR]\nbekommst du keine Erfahrungspunkte durch das\nBesiegen von Pokémon. Ist das okay?", italian="Sull'[CS:P]Isola Zero Nord[CR], non\nsi ottengono Punti Esperienza dai Pokémon che\nmandate KO. Va bene?", spanish="En la [CS:P]Isla Cero Norte[CR] no se\nobtienen Puntos de Experiencia al derrotar\nPokémon. ¿Os parece bien?"})
  -- @label_26 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 24 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Zero Isle East[CR].", french="En allant sur l'[CS:P]Ile Zéro Est[CR],\nvous devez vous soumettre à certaines\nrestrictions.", german="Das Betreten der [CS:P]Null-Insel Ost[CR]\nbringt verschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsull'[CS:P]Isola Zero Est[CR].", spanish="Hay ciertas restricciones para\nir a la [CS:P]Isla Cero Este[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Items in your Treasure Bag\nfrom the 17th slot and beyond will be lost.[K]\nAnd all team members will be put at Level 1.", french="Vous ne pouvez conserver que\nles 16 premiers objets de votre Sac à Trésor.\nLe niveau des membres de l'équipe tombe à 1.", german="Items in deinem Schatzbeutel\ngehen vom 17. Platz abwärts verloren.[K] Deine\nTeam-Mitglieder werden auf Level 1 gesetzt.", italian="Gli strumenti nella Sacca dei\ntesori dal 17° in poi andranno persi.[K]\nE tutti i membri della squadra saranno al L. 1.", spanish="Solo se pueden llevar los 17\nprimeros objetos de la Bolsa.[K] Y todos los\nmiembros del equipo volverán al Nivel 1."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Oh, about the level reduction to\nLevel 1... It's only temporary.", french="Ah, au fait... la baisse de niveau\nn'est que temporaire.", german="Oh, was die Levelreduzierung\nauf Level 1 anbelangt... Das ist nur\nvorübergehend.", italian="Ah, la riduzione al L. 1 è\nsoltanto temporanea!", spanish="Ah, pero no hay que preocuparse\npor esa reducción de nivel... solo es temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="When you exit the dungeon, all\nteam members will be returned to their\noriginal levels. No need for worry!", french="Au sortir du donjon, les\nmembres de l'équipe retrouveront leur niveau\nde départ! Pas d'inquiétude à avoir!", german="Wenn du den Dungeon verlässt,\nwerden deine Team-Mitglieder auf ihre\nUrsprungslevel zurückgesetzt, keine Sorge!", italian="Uscendo dal dungeon, tutti i\nmembri della squadra torneranno al livello che\navevano raggiunto. Non ti preoccupare!", spanish="Cuando salgáis del territorio,\ntodos los miembros del equipo recuperarán\nsu nivel original. ¡Tampoco es para tanto!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nRettung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 25 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Zero Isle West[CR].", french="En allant sur l'[CS:P]Ile Zéro Ouest[CR],\nvous devez vous soumettre à certaines\nrestrictions.", german="Das Betreten der\n[CS:P]Null-Insel West[CR] bringt verschiedene\nEinschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsull'[CS:P]Isola Zero Ovest[CR].", spanish="Hay ciertas restricciones para\nir a la [CS:P]Isla Cero Oeste[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="All items in your Treasure Bag\nwill be lost.[K] All team members will also be\ndropped to Level 1.", french="Tous les objets de votre Sac à\nTrésor seront perdus.[K] Et le niveau des\nmembres de l'équipe tombera à 1.", german="Du verlierst alle Items in deinem\nSchatzbeutel.[K] Deine Team-Mitglieder werden\nferner auf Level 1 zurückgesetzt.", italian="Perderete tutti gli strumenti che\navete nella Sacca dei tesori.[K] In più, i membri\ndella squadra torneranno al L. 1.", spanish="Todos los objetos de la Bolsa\nse perderán.[K] Y todos los miembros del\nequipo pasarán a tener Nivel 1."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Oh, about the level reduction to\nLevel 1... It's only temporary.", french="Ah, au fait... la baisse de niveau\nn'est que temporaire.", german="Oh, was die Levelreduzierung\nauf Level 1 anbelangt... Das ist nur\nvorübergehend.", italian="Ah, la riduzione al L. 1 è\nsoltanto temporanea!", spanish="Ah, pero no hay que preocuparse\npor esa reducción de nivel... solo es temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="When you exit the dungeon, all\nteam members will be returned to their\noriginal levels. No need for worry!", french="Au sortir du donjon, les\nmembres de l'équipe retrouveront leur niveau\nde départ! Pas d'inquiétude à avoir!", german="Wenn du den Dungeon verlässt,\nwerden deine Team-Mitglieder auf ihre\nUrsprungslevel zurückgesetzt, keine Sorge!", italian="Uscendo dal dungeon, tutti i\nmembri della squadra torneranno al livello che\navevano raggiunto. Non ti preoccupare!", spanish="Cuando salgáis del territorio,\ntodos los miembros del equipo recuperarán\nsu nivel original. ¡Tampoco es para tanto!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarci per affrontare\nuna missione di Pronto Intervento?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 26 then
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Zero Isle South[CR].", french="En allant sur l'[CS:P]Ile Zéro Sud[CR],\nvous devez vous soumettre à certaines\nrestrictions.", german="Das Betreten der\n[CS:P]Null-Insel Süd[CR] bringt verschiedene\nEinschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsull'[CS:P]Isola Zero Sud[CR].", spanish="Hay ciertas restricciones para\nir a la [CS:P]Isla Cero Sur[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="All your money and the items in\nyour Treasure Bag will be lost.", french="Tout votre argent et tous les\nobjets de votre Sac à Trésor seront perdus.", german="All dein Geld sowie all deine\nItems in deinem Schatzbeutel gehen verloren.", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori andranno persi.", spanish="Se perderá todo el dinero y\ntodos los objetos que llevéis en la Bolsa."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the leader may enter the\ndungeon. Furthermore, the leader's level will\nbe dropped to Level 1. Is that OK?", french="Seul le meneur pourra entrer\ndans le donjon, et son niveau tombera à 1.", german="Nur der Anführer kann den\nDungeon betreten. Des Weiteren wird sein\nLevel auf Level 1 zurückgesetzt.", italian="Solo il leader può entrare\nnel dungeon. Inoltre, tornerà al L. 1.", spanish="Solo el líder del equipo puede\nentrar en el territorio, y su nivel bajará a\nNivel 1."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Oh, about the level reduction to\nLevel 1... It's only temporary.", french="Ah, au fait... la baisse de niveau\nn'est que temporaire.", german="Oh, was die Levelreduzierung\nauf Level 1 anbelangt... Das ist nur\nvorübergehend.", italian="Ah, però la riduzione al L. 1 è\nsoltanto temporanea!", spanish="Ah, pero no hay que preocuparse\npor esa reducción de nivel... solo es temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="When you exit the dungeon, your\nlevel will be returned to the original level.\nNo need for worry!", french="Au sortir du donjon, vous\nretrouverez votre niveau de départ.\nPas d'inquiétude à avoir!", german="Wenn du den Dungeon verlässt,\nwird dein Level auf seinen ursprünglichen\nWert zurückgesetzt, keine Sorge!", italian="Quando uscirai dal dungeon,\nritornerai al livello che avevi raggiunto in\nprecedenza. Non ti preoccupare!", spanish="Al salir del territorio, recobrará\nsu nivel original. ¡No hay de qué preocuparse!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 27 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Zero Isle Center[CR].", french="L'[CS:P]Ile Zéro Centre[CR] est soumise\nà restrictions.", german="Das Betreten des\n[CS:P]Null-Insel-Zentrums[CR] bringt\nverschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsull'[CS:P]Isola Zero Centro[CR].", spanish="Hay algunas restricciones cuando\nse va al [CS:P]Corazón de la Isla Cero[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Items from the 17th slot and\nbeyond in your Treasure Bag will be lost.", french="Vous ne pourrez conserver que\nles 16 premiers objets de votre Sac à Trésor.", german="Items im Schatzbeutel gehen ab\nPlatz 17 verloren.", italian="Gli strumenti nella Sacca dei\ntesori dal 17° in poi andranno persi.", spanish="Solo se pueden llevar los 17\nprimeros objetos de la Bolsa."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="You don't earn Experience Points\nfrom the Pokémon you defeat.", french="Vous ne gagnez pas de Points\nd'Expérience après avoir vaincu un Pokémon.", german="Für das Besiegen von Pokémon\nbekommst du keine Erfahrungspunkte.", italian="Non si ottengono Punti\nEsperienza dai Pokémon che mandate KO.", spanish="No se consiguen Puntos de\nExperiencia derrotando a Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="And any hidden traps will\nremain invisible even if you try to detect\nthem by using a regular attack.", french="Les pièges cachés resteront\ninvisibles même si vous essayez de les\ndétecter avec une attaque ordinaire.", german="Versteckte Fallen bleiben\nunsichtbar, selbst wenn man versucht, sie\ndurch einen regulären Angriff aufzuspüren.", italian="Tutte le trappole nascoste\nindividuate con un attacco normale\nrimarranno invisibili.", spanish="Las trampas que detectes\nsi usas un ataque convencional\nseguirán siendo invisibles."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 28 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Destiny Tower[CR].", french="La [CS:P]Tour du Destin[CR] est soumise à\nrestrictions.", german="Das Betreten des\n[CS:P]Verhängnisturms[CR] bringt\nverschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsulla [CS:P]Torre Destino[CR].", spanish="Hay algunas restricciones para\nir a la [CS:P]Torre Destino[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="All your money and the items in\nyour Treasure Bag will be lost.", french="Tout votre argent et tous les\nobjets de votre Sac à Trésor seront perdus.", german="All dein Geld sowie all deine\nItems in deinem Schatzbeutel gehen verloren.", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori andranno persi.", spanish="Se perderá todo el dinero y\ntodos los objetos que llevéis en la Bolsa."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the leader may enter the\ndungeon...[K]and the leader's level will\nbe dropped to Level 1.", french="Seul le meneur pourra entrer\ndans le donjon...[K] et son niveau tombera à 1.", german="Nur der Anführer kann den\nDungeon betreten...[K] Und sein Level wird\nauf Level 1 zurückgesetzt.", italian="Solo il leader può entrare\nnel dungeon...[K] Inoltre, tornerà al L. 1.", spanish="En el territorio solo podrá\nentrar el líder...[K] y su nivel caerá\nhasta el Nivel 1."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Oh, about the level reduction to\nLevel 1... It's only temporary.", french="Ah, au fait... la baisse de niveau\nn'est que temporaire.", german="Oh, was die Levelreduzierung\nauf Level 1 anbelangt... Das ist nur\nvorübergehend.", italian="Ah, la riduzione al L. 1 è\nsoltanto temporanea!", spanish="Ah, pero no hay que preocuparse\npor esa reducción de nivel... solo es temporal."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="When you exit the dungeon, all\nteam members will be returned to their\noriginal levels. No need for worry!", french="Au sortir du donjon, vous\nretrouverez votre niveau de départ!\nPas d'inquiétude à avoir!", german="Wenn du den Dungeon verlässt,\nwirst du auf deinen Ursprungslevel\nzurückgesetzt, keine Sorge!", italian="Uscendo dal dungeon, tornerai\nal livello che avevi raggiunto. Non ti\npreoccupare!", spanish="Cuando salgas del territorio,\nrecuperarás tu nivel original.\n¡Al final no es para tanto!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="What else...[K] Your IQ\nSkills cannot be used...", french="Quoi d'autre...[K] Vos aptitudes Q.I.\nsont inutilisables...", german="Und noch etwas...[K] Deine\nIQ-Fähigkeiten kannst du nicht verwenden...", italian="Che altro...[K] Non è possibile\nutilizzare le Abilità QI...", spanish="¿Qué más?...[K] ¡Ah, no podrás\nusar tus habilidades CI!"})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="And any hidden traps will\nremain invisible even if you try to detect\nthem by using a regular attack.", french="Les pièges cachés resteront\ninvisibles même si vous essayez de les\ndétecter avec une attaque ordinaire.", german="Versteckte Fallen bleiben\nunsichtbar, selbst wenn man versucht, sie\ndurch einen regulären Angriff aufzuspüren.", italian="Tutte le trappole nascoste\nindividuate con un attacco normale\nrimarranno invisibili.", spanish="Las trampas que detectes\nsi usas un ataque convencional\nseguirán siendo invisibles."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen\nfür diesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 29 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Oblivion Forest[CR].", french="La [CS:P]Forêt de l'Oubli[CR] est soumise à\nrestrictions.", german="Das Betreten des\n[CS:P]Vergessenswaldes[CR] bringt\nverschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nnella [CS:P]Foresta Oblio[CR].", spanish="Hay ciertas restricciones para\nir al [CS:P]Bosque Olvido[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Money and items from the\n9th slot and beyond in your Treasure Bag\nwill be lost...", french="Vous ne pourrez conserver que\nles 8 premiers objets de votre Sac à Trésor\net vous perdrez tout votre argent...", german="Geld sowie Items in deinem\nSchatzbeutel gehen ab Platz 9 verloren...", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori dal 9° in poi andranno\npersi...", spanish="Solo podrás llevar los primeros\n9 objetos de la Bolsa; el dinero\ntambién se perderá..."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the first two members are\nallowed to go, so team members from the\nthird slot on can't come along.", french="Seuls les deux premiers\nmembres de l'équipe sont autorisés à entrer,\nl'entrée est interdite au-delà de trois.", german="Und nur die ersten beiden deiner\nTeam-Mitglieder dürfen den Dungeon betreten.", italian="Oltre al leader, possono\npartecipare alla spedizione solo i primi\ndue membri della squadra.", spanish="El tercer miembro del equipo\nno podrá unirse, ya que solo se permite\nla entrada a los dos primeros."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 30 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to the [CS:P]Treacherous Waters[CR].", french="La [CS:P]Mer Perfide[CR] est soumise à\nrestrictions.", german="Das Betreten der\n[CS:P]Trügerischen Gewässer[CR] bringt\nEinschränkungen mit sich.", italian="Ci sono alcune limitazioni\nnelle [CS:P]Acque Traditrici[CR].", spanish="Hay algunas restricciones para\nir a las [CS:P]Aguas Peligrosas[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Money and items from the\n9th slot and beyond in your Treasure Bag\nwill be lost...", french="Vous ne pourrez conserver que\nles 8 premiers objets de votre Sac à Trésor\net vous perdrez tout votre argent...", german="Geld sowie Items in deinem\nSchatzbeutel gehen ab Platz 9 verloren...", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori dal 9° in poi andranno\npersi...", spanish="Solo podrás llevar los primeros\n9 objetos de la Bolsa; el dinero\ntambién se perderá..."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the first two members are\nallowed to go, so team members from the\nthird slot on can't come along.", french="Seuls les deux premiers\nmembres de l'équipe sont autorisés à entrer,\nl'entrée est interdite au-delà de trois.", german="Und nur die ersten beiden deiner\nTeam-Mitglieder dürfen den Dungeon betreten.", italian="Oltre al leader, possono\npartecipare alla spedizione solo i primi\ndue membri della squadra.", spanish="El tercer miembro del equipo\nno podrá unirse, ya que solo se permite\nla entrada a los dos primeros."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 31 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to the [CS:P]Southeastern Islands[CR].", french="Les [CS:P]Iles du Sud-Est[CR] sont\nsoumises à restrictions.", german="Das Betreten der\n[CS:P]Südöstlichen Inseln[CR] bringt\nverschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nsulle [CS:P]Isole Sudorientali[CR].", spanish="Hay algunas restricciones para\nir al [CS:P]Archipiélago Sureste[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Money and items from the\n9th slot and beyond in your Treasure Bag\nwill be lost...", french="Vous ne pourrez conserver que\nles 8 premiers objets de votre Sac à Trésor\net vous perdrez tout votre argent...", german="Geld sowie Items in deinem\nSchatzbeutel gehen ab Platz 9 verloren...", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori dal 9° in poi andranno\npersi...", spanish="Solo podrás llevar los primeros\n9 objetos de la Bolsa; el dinero\ntambién se perderá..."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the leader may enter\nthe dungeon.", french="Seul le meneur peut entrer\ndans le donjon.", german="Und nur der Anführer kann den\nDungeon betreten.", italian="Solo il leader può entrare\nnel dungeon.", spanish="Solo el líder del equipo podrá\nentrar en el territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 32 then
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="There are certain restrictions\non going to [CS:P]Inferno Cave[CR].", french="La [CS:P]Caverne Brasier[CR] est soumise\nà restrictions.", german="Das Betreten der\n[CS:P]Infernohöhle[CR] bringt\nverschiedene Einschränkungen mit sich.", italian="Ci sono alcune limitazioni\nnella [CS:P]Grotta Infuocata[CR].", spanish="Hay algunas restricciones para\nentrar en la [CS:P]Cueva Flama[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Money and items from the\n9th slot and beyond in your Treasure Bag\nwill be lost...", french="Vous ne pourrez conserver que\nles 8 premiers objets de votre Sac à Trésor\net vous perdrez tout votre argent...", german="Geld sowie Items in deinem\nSchatzbeutel gehen ab Platz 9 verloren...", italian="Tutti i soldi e gli strumenti\nnella Sacca dei tesori dal 9° in poi andranno\npersi...", spanish="Solo podrás llevar los primeros\n9 objetos de la Bolsa; el dinero\ntambién se perderá..."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Only the leader may enter\nthe dungeon.", french="Seul le meneur peut entrer\ndans le donjon.", german="Und nur der Anführer kann den\nDungeon betreten.", italian="Solo il leader può entrare\nnel dungeon.", spanish="Solo el líder del equipo podrá\nentrar en el territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Those are the restrictions for\nthis dungeon.[K] Would you like to go there for\nan exploration?", french="Voilà pour les restrictions\nrelatives à ce donjon.[K] Vous voulez partir\nl'explorer?", german="Das sind die Einschränkungen für\ndiesen Dungeon.[K] Möchtest du dich für eine\nErkundung dorthin begeben?", italian="Queste sono le limitazioni per\nil dungeon...[K] Vuoi andarlo ad\nesplorare?", spanish="Esas son las restricciones del\nterritorio.[K] ¿Queréis explorarlo?"})
  -- jump @label_26 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 33 then
  -- jump @switch0_129 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 18 then
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="[CS:W]Dungeon Settings Error 1\nRestrictions have been applied to dungeons\nother than Zero Isle.[CR]", french="[CS:W]Paramètres donjon - erreur 1\nDes restrictions ont été appliquées à tous\nles donjons, sauf à l'Ile Zéro.[CR]", german="[CS:W]Dungeon-Einstellungsfehler 1\nAllen Dungeons mit Ausnahme der Null-Insel\nwurden Einschränkungen auferlegt.[CR]", italian="[CS:W]Impostazioni Dungeon Errore 1\nLe limitazioni sono state applicate ai dungeon\ndiversi dall'Isola Zero.[CR]", spanish="[CS:W]Error 1 de configuración de territorio\nHay más restricciones en otros territorios\nademás de en la Isla Cero.[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  elseif __sw == 19 then
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="[CS:W]Dungeon Settings Error 2\nRestrictions have been applied to dungeons\nother than Zero Isle.[CR]", french="[CS:W]Paramètres donjon - erreur 2\nDes restrictions ont été appliquées à tous\nles donjons, sauf à l'Ile Zéro.[CR]", german="[CS:W]Dungeon-Einstellungsfehler 2\nAllen Dungeons mit Ausnahme der Null-Insel\nwurden Einschränkungen auferlegt.[CR]", italian="[CS:W]Impostazioni Dungeon Errore 2\nLe limitazioni sono state applicate ai dungeon\ndiversi dall'Isola Zero.[CR]", spanish="[CS:W]Error 2 de configuración de territorio\nHay más restricciones en otros territorios\nademás de en la Isla Cero.[CR]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[120] = 1 -- $SCENARIO_TALK_BIT_FLAG[120] = 1 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[40] = 1 -- $SCENARIO_MAIN_BIT_FLAG[40] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Greetings![K] Welcome to [CS:P]Pelipper\nIsland[CR].", french="Bonjour![K] Bienvenue sur l'[CS:P]Ile\nBekipan[CR].", german="Grüße![K] Willkommen auf der\n[CS:P]Pelipper-Insel[CR].", italian="Saluti![K] Benvenuti\nsull'[CS:P]Isola Pelipper[CR].", spanish="¡Saludos![K] Os doy la bienvenida\na la [CS:P]Isla Pelipper[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="This is where you can spend\ntime until you have been rescued.", french="Vous avez l'autorisation de\nrester ici en attendant votre sauvetage.", german="Hier kannst du deine Zeit\nverbringen, bis du gerettet wirst.", italian="La squadra può rimanere qui\nfintanto che qualcuno non viene in suo\nsoccorso.", spanish="Aquí es donde podéis pasar el\ntiempo hasta que os rescaten."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="You may go explore dungeons\nthat you have visited before.", french="Vous avez aussi la possibilité\nde partir explorer les donjons que vous avez\ndéjà visités.", german="Du kannst Dungeons erkunden, die\ndu bereits zuvor besucht hast.", italian="È possibile anche visitare\nqualche dungeon già esplorato in precedenza.", spanish="Podéis explorar territorios que\nya hayáis visitado."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="It's an ideal way to spend some\ntime while you wait for rescue.", french="C'est une manière idéale de\nfaire passer le temps en attendant les secours.", german="Es ist eine ideale Möglichkeit,\ndeine Zeit zu nutzen, während du auf Rettung\nwartest.", italian="È un buon metodo per passare\nil tempo finché qualcuno non viene in\nsoccorso della squadra.", spanish="Es una forma ideal de pasar el\ntiempo mientras esperáis."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="However, if your team were to\nbe defeated here, you may not send out for\na rescue.", french="Cependant, si votre équipe était\nvaincue ici, il vous serait impossible d'appeler\nles secours.", german="Allerdings kannst du keine\nRettung anfordern, sollte dein Team hier\nbesiegt werden.", italian="Comunque, se la squadra\nviene sconfitta in questo dungeon, non può\ninviare una richiesta di soccorso.", spanish="Eso sí, si os derrotan esta vez,\nno podréis solicitar un rescate."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="And when you exit the dungeon\nand return here to the island, your level and\nmoves will be set back to what they were.", french="Quand vous sortez du donjon\npour revenir sur cette île, votre niveau et vos\ncapacités sont ramenés à la normale.", german="Und wenn du den Dungeon\nverlässt und hierher zurückkehrst, werden\ndein Level und deine Attacken zurückgesetzt.", italian="E ritornando qui sull'isola,\nil livello e le mosse di tutti i membri saranno\ndi nuovo quelli che avevano prima di partire.", spanish="Al salir del territorio y volver\na esta isla, se deshará cualquier posible\ncambio de nivel o movimientos."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="You also can't recruit new\nmembers to your team.", french="Le recrutement de nouveaux\ncoéquipiers est également interdit.", german="Ferner kannst du keine\nneuen Team-Mitglieder rekrutieren.", italian="E non è neppure possibile\nreclutare nuovi membri per la squadra.", spanish="Tampoco podréis reclutar a\nnuevos miembros para el equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="What can you do? Well, you get\nto keep all the money and items you find!", french="Qu'est-ce que vous avez le droit\nde faire? Eh bien, vous conservez tout l'argent\net tous les objets que vous trouvez!", german="Was du tun darfst? Nun,\nerbeutetes Geld und gefundene Items darfst du\nbehalten!", italian="Cosa vi rimane allora? Beh,\nrimangono tutti i soldi e tutti gli strumenti\ntrovati!", spanish="¿Que para qué ir entonces?\nBueno, podréis quedaros el dinero y los\nobjetos que encontréis por allí."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="But the items and money must\nbe put in storage here before you leave if\nyou want to take them out in Treasure Town.", french="Vous devez d'abord stocker les\nobjets et déposer l'argent avant de pouvoir\nles récupérer à Bourg-Trésor.", german="Aber Items und Geld müssen\nzum Mitnehmen nach Schatzstadt vor dem\nAufbruch hier im Speicher abgelegt werden.", italian="Ma per ritrovarli a Borgo\nTesoro, bisogna metterli in deposito qui\nprima di andarsene.", spanish="Aunque tendréis que almacenar\ntodos los objetos y el dinero antes de salir\nsi queréis contar con ellos en Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_perippaa1) end)
  SkySceneKit.say({english="Now which dungeon would you\nlike to explore?", french="Alors, quel donjon voulez-vous\nexplorer?", german="So, welchen Dungeon möchtest\ndu denn erkunden?", italian=" Quale dungeon vuoi esplorare?", spanish="Bueno, ¿qué territorio queréis\nir a explorar?"})
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
