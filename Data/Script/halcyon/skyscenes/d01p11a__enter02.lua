-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/enter02.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N01_08) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_8 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if (SkyProg.cmp(23, 2) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [23, 2]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We shouldn't go exploring now.\nWe have to get ready for tomorrow.", french="On ne devrait pas partir\nen exploration maintenant. On doit se préparer\npour demain.", german="Wir sollten jetzt nicht auf\nErkundung gehen. Wir müssen uns für morgen\nbereit machen.", italian="Non dovremmo andare a\nesplorare ora. Dobbiamo prepararci per\ndomani.", spanish="Será mejor que no vayamos hoy\na explorar. Tenemos que prepararnos para\nmañana."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We shouldn't go exploring now.\nWe have to get ready for tomorrow.", french="On ne devrait pas partir\nen exploration maintenant. On doit se préparer\npour demain.", german="Wir sollten jetzt nicht auf\nErkundung gehen. Wir müssen uns für morgen\nbereit machen.", italian="Non dovremmo andare a\nesplorare ora. Dobbiamo prepararci per\ndomani.", spanish="Igual es mejor que hoy no\nexploremos. Tenemos que prepararnos para\nmañana."})
  else
  SkySceneKit.say({english="We shouldn't go exploring now.\nWe have to get ready for tomorrow.", french="On ne devrait pas partir\nen exploration maintenant. On doit se préparer\npour demain.", german="Wir sollten jetzt nicht auf\nErkundung gehen. Wir müssen uns für morgen\nbereit machen.", italian="Non dovremmo andare a\nesplorare ora. Dobbiamo prepararci per\ndomani.", spanish="Nos tenemos que preparar para\nmañana, así que será mejor que hoy no\nexploremos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allons à Bourg-Trésor.", german=" Auf nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish="Venga, andando para\nAldea Tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to go to Treasure\nTown.", french=" Allons à Bourg-Trésor.", german="Wir müssen uns nach\nSchatzstadt begeben.", italian=" Dobbiamo andare a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  else
  SkySceneKit.say({english="We have to go to Treasure\nTown.", french=" Allons à Bourg-Trésor.", german="Wir müssen uns nach\nSchatzstadt begeben.", italian=" Dobbiamo andare a Borgo Tesoro.", spanish=" Vayamos a Aldea Tesoro."})
  end
  -- message_Close
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [14, 1]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, we can't, [hero].", french="Non, on ne peut pas,\n[hero].", german="Nein, hier können wir jetzt nicht\nlang, [hero].", italian=" No, non possiamo, [hero].", spanish=" No, [hero], no podemos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, we can't, [hero].", french="Non, on ne peut pas,\n[hero].", german="Nein, hier können wir jetzt nicht\nlang, [hero].", italian=" No, non possiamo, [hero].", spanish=" No, [hero], no podemos."})
  else
  SkySceneKit.say({english=" No, we can't, [hero].", french="Non, on ne peut pas,\n[hero].", german="Nein, hier können wir jetzt nicht\nlang, [hero].", italian=" No, non possiamo, [hero].", spanish=" No, [hero], no podemos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to get ready for\ncapturing [CS:N]Grovyle[CR], right?", french="On doit se préparer à la capture\nde [CS:N]Massko[CR], pas vrai?", german="Wir müssen uns für die\nErgreifung von [CS:N]Reptain[CR] fertig machen.", italian="Dobbiamo prepararci per\ncatturare [CS:N]Grovyle[CR], no?", spanish="Nos tenemos que preparar para\natrapar a [CS:N]Grovyle[CR], ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're supposed to get ready for\ncapturing [CS:N]Grovyle[CR] first, right?", french="On doit se préparer à la capture\nde [CS:N]Massko[CR], pas vrai?", german="Wir sollten uns für die\nErgreifung von [CS:N]Reptain[CR] fertig machen.", italian="Prima dovremmo prepararci\nper catturare [CS:N]Grovyle[CR], no?", spanish="¿No se supone que tenemos que\nprepararnos para atrapar a [CS:N]Grovyle[CR] primero?"})
  else
  SkySceneKit.say({english="Aren't we supposed to get ready\nfor capturing [CS:N]Grovyle[CR] first?", french="On doit se préparer à la capture\nde [CS:N]Massko[CR], pas vrai?", german="Sollten wir uns nicht für\ndie Ergreifung von [CS:N]Reptain[CR] fertig machen?", italian="Prima non dovremmo prepararci\nper catturare [CS:N]Grovyle[CR]?", spanish="¿Acaso no tenemos primero que\nprepararnos para capturar a [CS:N]Grovyle[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get back to the guild as\nsoon as we're ready.", french="Retournons à la Guilde dès que\nnous serons prêts.", german="Gehen wir zur Gilde zurück,\nsobald wir bereit sind.", italian="Torniamo alla Gilda non appena\nè tutto pronto!", spanish="Venga, andando para el\n[CS:N]Pokégremio[CR] en cuanto esté todo listo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go back to the guild as\nsoon as we're ready.", french="Retournons à la Guilde dès que\nnous serons prêts.", german="Lass uns zur Gilde zurückgehen,\nsobald wir bereit sind.", italian="Torniamo alla Gilda non appena\nè tutto pronto!", spanish="Vayamos al [CS:N]Pokégremio[CR]\nen cuanto esté todo listo."})
  else
  SkySceneKit.say({english="We'll go back to the guild as\nsoon as we're ready.", french="Retournons à la Guilde dès que\nnotre équipe sera prête.", german="Wir werden zur Gilde\nzurückgehen, sobald wir bereit sind.", italian="Torniamo alla Gilda non appena\nè tutto pronto!", spanish="Volveremos al [CS:N]Pokégremio[CR]\nen cuanto esté todo listo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [9, 1]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we dawdle now, they'll go\nwithout us on the expedition!", french="Si on traîne maintenant,\nl'expédition risque de partir sans nous!", german="Wenn wir jetzt trödeln, gehen\nsie noch ohne uns auf die Expedition!", italian="Se perdiamo tempo adesso,\npartiranno per la spedizione senza di noi!", spanish="Venga, no te entretengas,\n¡que se irán a la expedición sin nosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we dawdle now, they'll leave\nus behind on the expedition!", french="Si on traîne maintenant,\nl'expédition risque de partir sans nous!", german="Wenn wir jetzt trödeln, lassen\nsie uns noch zurück!", italian="Se perdiamo tempo adesso,\nnon ci aspetteranno per la spedizione!", spanish="¡Si perdemos el tiempo, se irán\nsin nosotros a la expedición!"})
  else
  SkySceneKit.say({english="If we're late now, they'll leave\nus behind on the expedition!", french="Si on traîne maintenant,\nl'expédition risque de partir sans nous!", german="Wenn wir zu spät dran sind,\nlassen sie uns noch zurück!", italian="Se perdiamo tempo adesso,\nnon ci aspetteranno per la spedizione!", spanish="¡Como nos retrasemos se irán\nde expedición sin nosotros!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we're ready to leave on\nthe expedition, we have to go back to\nthe guild.", french="Quand on sera prêts pour\nl'expédition, il faudra qu'on retourne\nà la Guilde.", german="Wenn wir bereit sind, zu der\nExpedition aufzubrechen, müssen wir uns\nzurück zur Gilde begeben.", italian="Quando è tutto pronto per la\npartenza, dobbiamo tornare alla Gilda.", spanish="Cuando lo tengamos todo listo\npara ir a la expedición, hay que volver\nal [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we're ready for the\nexpedition, we have to go back to the guild.", french="Quand on sera prêts pour\nl'expédition, il faudra qu'on retourne\nà la Guilde.", german="Wenn wir bereit sind für die\nExpedition, müssen wir uns zurück zur Gilde\nbegeben.", italian="Quando è tutto pronto per la\npartenza, dobbiamo tornare alla Gilda.", spanish="Cuando lo tengamos todo listo\npara ir a la expedición, hay que volver\nal [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="When we're ready for the\nexpedition, we have to go back to the guild.", french="Retournons à la Guilde une fois\nnos préparatifs pour l'expédition terminés.", german="Wenn wir bereit sind für die\nExpedition, müssen wir uns zurück zur Gilde\nbegeben.", italian="Quando è tutto pronto per la\npartenza, dobbiamo tornare alla Gilda.", spanish="Cuando lo tengamos todo listo\npara ir a la expedición, hay que volver\nal [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to let [CS:N]Chatot[CR] know\nwe're ready!", french="Il faut avertir [CS:N]Pijako[CR]\nqu'on est prêts!", german="Wir müssen [CS:N]Plaudagei[CR] mitteilen,\ndass wir bereit sind!", italian="Dobbiamo dire a [CS:N]Chatot[CR] che\nè tutto pronto.", spanish="¡Hay que decirle a [CS:N]Chatot[CR]\nque lo tenemos todo listo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to report in to [CS:N]Chatot[CR]!", french="Il faut avertir [CS:N]Pijako[CR]\nqu'on est prêts!", german="Wir müssen [CS:N]Plaudagei[CR]\ninformieren, dass wir bereit sind!", italian="Dobbiamo dire a [CS:N]Chatot[CR] che\nè tutto pronto.", spanish="¡Hay que decirle a [CS:N]Chatot[CR]\nque lo tenemos todo listo!"})
  else
  SkySceneKit.say({english="We have to let [CS:N]Chatot[CR] know\nwe're ready!", french="Il faut avertir [CS:N]Pijako[CR]\nque notre équipe est parée!", german="Wir müssen [CS:N]Plaudagei[CR] mitteilen,\ndass wir bereit sind!", italian="Dobbiamo dire a [CS:N]Chatot[CR] che\nè tutto pronto.", spanish="¡Hay que decirle a [CS:N]Chatot[CR]\nque lo tenemos todo listo!"})
  end
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) < 0) then -- elseif ROM: scn($SCENARIO_MAIN) < [4, 5]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't have the time to\nwander off.", french=" On n'a pas le temps de traîner.", german="Wir haben keine Zeit zum\nHerumschweifen.", italian=" Non c'è tempo di gironzolare.", spanish=" No hay tiempo que perder."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is no time to be dawdling.", french=" On n'a pas le temps de traîner.", german="Das ist nicht die richtige Zeit\nzum Bummeln.", italian=" Non c'è tempo da perdere.", spanish=" No hay tiempo que perder."})
  else
  SkySceneKit.say({english=" We can't take any detours.", french=" On n'a pas le temps de traîner.", german="Wir können uns keine Umwege\nerlauben.", italian=" Dobbiamo fare in fretta.", spanish=" Mejor no perdamos el tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to do the guild's\nwork now.", french="On doit accomplir la mission\npour la Guilde.", german="Wir müssen jetzt die\nGildenarbeit erledigen.", italian="Ora dobbiamo dedicarci al lavoro\ndella Gilda.", spanish="Tenemos que hacer la misión del\n[CS:N]Pokégremio[CR] ahora."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to do the guild's\nwork now.", french="On doit accomplir la mission\npour la Guilde.", german="Wir müssen jetzt die\nGildenarbeit erledigen.", italian="Ora dobbiamo dedicarci al lavoro\ndella Gilda.", spanish="Tenemos que hacer la misión del\n[CS:N]Pokégremio[CR] ahora."})
  else
  SkySceneKit.say({english="We have the guild's work to\ndo now.", french="On doit accomplir la mission\npour la Guilde.", german="Die Gildenarbeit muss jetzt\nerledigt werden.", italian="Ora dobbiamo dedicarci al lavoro\ndella Gilda.", spanish="Tenemos que hacer la misión del\n[CS:N]Pokégremio[CR] ahora."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Bidoof[CR]'s waiting at the guild.\nLet's move it!", french="[CS:N]Keunotor[CR] nous attend à la Guilde.\nAllons-y!", german="[CS:N]Bidiza[CR] wartet in der Gilde.\nKomm schon, gehen wir!", italian="[CS:N]Bidoof[CR] sta aspettando alla Gilda.\nMuoviamoci!", spanish="¡Venga, a moverse, que [CS:N]Bidoof[CR]\nnos espera en el [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Bidoof[CR]'s waiting at the guild.\nLet's get going!", french="[CS:N]Keunotor[CR] nous attend à la Guilde.\nAllons-y!", german="[CS:N]Bidiza[CR] wartet in der Gilde.\nAuf geht's!", italian="[CS:N]Bidoof[CR] sta aspettando alla Gilda.\nAndiamo!", spanish="[CS:N]Bidoof[CR] nos espera en el\n[CS:N]Pokégremio[CR]. ¡Vámonos!"})
  else
  SkySceneKit.say({english="[CS:N]Bidoof[CR]'s waiting at the guild.\nWe have to hurry!", french="[CS:N]Keunotor[CR] nous attend à la Guilde.\nAllons-y!", german="[CS:N]Bidiza[CR] wartet in der Gilde.\nWir müssen uns beeilen!", italian="[CS:N]Bidoof[CR] sta aspettando alla Gilda.\nFacciamo in fretta!", spanish="[CS:N]Bidoof[CR] nos espera en el\n[CS:N]Pokégremio[CR]. ¡Démonos prisa!"})
  end
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Would you like to go to the [CS:P]Beach Cave[CR]?", french="[CN]Voulez-vous aller à la [CS:P]Grotte Littorale[CR]?", german="[CN]Möchtet ihr die [CS:P]Strandhöhle[CR] betreten?", italian="[CN]Vuoi andare alla [CS:P]Grotta Marina[CR]?", spanish="[CN]¿Quieres ir a la [CS:P]Cueva Bajamar[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_Close
  GAME:WaitFrames(10)
  do local __sw = 0 -- switch(main_EnterAdventure(1, 30)) [main_EnterAdventure(1, 30): bascule d'écran aventure moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 1 then
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Caution!", french="[CN]Attention!", german="[CN]Achtung!", italian="[CN]Attenzione!", spanish="[CN]¡Atención!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]This rescue cannot be undertaken unless\n[CN]the team includes certain Pokémon.", french="[CN]Pour entreprendre ce sauvetage,\n[CN]l'équipe doit impérativement comprendre\n[CN]certains Pokémon.", german="[CN]Diese Rettung kann nur unternommen werden,\n[CN]wenn bestimmte Pokémon im Team sind.", italian="[CN]Non puoi affrontare questa missione di Pronto\n[CN]Intervento se la squadra non include\n[CN]determinati Pokémon.", spanish="[CN]Solo podrás llevar a cabo esta misión\n[CN]si te acompaña un Pokémon determinado."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Please put together your team\n[CN]with the Pokémon specified by\n[CN]the job, or \"Suspend\" the job.", french="[CN]Veuillez former une équipe incluant\n[CN]les Pokémon spécifiés dans l'offre\n[CN]de mission ou \"Suspendre\" la mission.", german="[CN]Bitte stellt euer Team aus den vom Job\n[CN]vorgeschriebenen Pokémon zusammen,\n[CN]oder wählt SPÄTER zum Aufschieben des Jobs.", italian="[CN]Metti in squadra i Pokémon specificati\n[CN]nella missione, oppure usa il\n[CN]comando \"Sospendi\".", spanish="[CN]Incluye el Pokémon especificado\n[CN]en tu equipo o bien opta por\n[CN]suspender la misión."})
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Caution!", french="[CN]Attention!", german="[CN]Achtung!", italian="[CN]Attenzione!", spanish="[CN]¡Atención!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]This rescue cannot be undertaken unless\n[CN]the team includes certain Pokémon.", french="[CN]Pour entreprendre ce sauvetage,\n[CN]l'équipe doit impérativement comprendre\n[CN]certains Pokémon.", german="[CN]Diese Rettung kann nur unternommen werden,\n[CN]wenn bestimmte Pokémon im Team sind.", italian="[CN]Non puoi affrontare questa missione di Pronto\n[CN]Intervento se la squadra non include\n[CN]determinati Pokémon.", spanish="[CN]Solo podrás llevar a cabo esta misión\n[CN]si te acompaña un Pokémon determinado."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Please put together your team\n[CN]with the Pokémon specified by\n[CN]the job, or \"Suspend\" the job.", french="[CN]Veuillez former une équipe incluant\n[CN]les Pokémon spécifiés dans l'offre\n[CN]de mission ou \"Suspendre\" la mission.", german="[CN]Bitte stellt euer Team aus den vom Job\n[CN]vorgeschriebenen Pokémon zusammen,\n[CN]oder wählt SPÄTER zum Aufschieben des Jobs.", italian="[CN]Metti in squadra i Pokémon specificati\n[CN]nella missione, oppure \"Sospendi\"\n[CN]la missione.", spanish="[CN]Incluye el Pokémon especificado\n[CN]en tu equipo o bien opta por\n[CN]suspender la misión."})
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __choice == 2 then
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
end
