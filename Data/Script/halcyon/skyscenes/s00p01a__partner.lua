-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S00P01A/partner.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('PARTNER_MESSAGE_TYPE1') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 27 or __sw == 30 or __sw == 35 or __sw == 48 or __sw == 56 or __sw == 60 or __sw == 68 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(26, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [26, 5]
  SkySceneKit.say({english="We're so close...[K] There isn't any\nway we can give up now, [hero]!", french="Nous sommes si près du but...[K]\nHors de question qu'on abandonne,\n[hero]!", german="Wir sind so dicht dran...[K] Wir\nkönnen jetzt auf gar keinen Fall aufgeben,\n[hero]!", italian="Ormai ci siamo...[K] Non possiamo\nfermarci proprio adesso, [hero]!", spanish="Estamos tan cerca...[K] No podemos\npensar en rendirnos ahora, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- @label_17 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(26, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [26, 4]
  SkySceneKit.say({english="The planet's paralysis could take\nplace in our world...", french="... alors la Paralysie de la\nPlanète pourrait affecter notre monde...", german="Es könnte zur Lähmung des\nPlaneten in unserer Welt kommen...", italian="... la paralisi dell'intero pianeta\nsarebbe inevitabile...", spanish=" Podría paralizarse el planeta..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="There's no time to\nwaste, [hero]!", french="Il n'y a pas une minute à perdre,\n[hero]!", german="Es gibt keine Zeit zu\nverschwenden, [hero]!", italian="Non c'è tempo da perdere,\n[hero]!", spanish="¡No hay tiempo que perder,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4]
  SkySceneKit.say({english=" We can't give up, [hero]!", french=" Courage, [hero]!", german="Wir dürfen nicht aufgeben,\n[hero]!", italian="Non possiamo mollare adesso,\n[hero]!", spanish="¡Sigamos avanzando,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 3]
  SkySceneKit.say({english=" We can do this, [hero]!", french=" Tiens bon, [hero]!", german="Wir können es schaffen,\n[hero]!", italian=" Possiamo farcela, [hero]!", spanish=" ¡Lo lograremos, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 2]
  SkySceneKit.say({english="Let's get through this place and\nfind the Rainbow Stoneship!", french="Sortons d'ici et frayons-nous\nun chemin jusqu'au Vaisseau Arc-en-Ciel!", german="Lasst uns diesen Ort durchqueren\nund das Regenbogen-Steinschiff finden!", italian="Attraversiamo questo posto\ne troviamo il Vascello Arcobaleno!", spanish="¡Crucemos este lugar y\nbusquemos la Barca Arcoiris!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 2]
  SkySceneKit.say({english="I'm really worried about [CS:N]Chatot[CR].\nLet's get moving!", french="Je m'inquiète au sujet de [CS:N]Pijako[CR].\nEn route!", german="Ich bin wirklich besorgt um\n[CS:N]Plaudagei[CR]. Lass uns aufbrechen!", italian="Sono davvero in ansia per\n[CS:N]Chatot[CR]. Muoviamoci!", spanish="Me preocupa mucho [CS:N]Chatot[CR].\n¡Deberíamos ponernos en marcha!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1]
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(19, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [19, 3]
  SkySceneKit.say({english=" Let's keep at it, [hero]!", french="Nous devons continuer,\n[hero]!", german="Wir müssen am Ball bleiben,\n[hero]!", italian="Continuiamo così,\n[hero]!", spanish="¡No nos detengamos,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(19, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [19, 2]
  SkySceneKit.say({english="We can't have far to go.[K]\nLet's keep going, [hero]!", french="Ça ne doit plus être très loin.[K]\nMaintenons le cap, [hero]!", german="Bestimmt sind wir schon ganz\ndicht dran![K] Lass uns weitergehen,\n[hero]!", italian="Non può più essere tanto\nlontano.[K] Coraggio, [hero]!", spanish="No nos puede quedar demasiado.[K]\n¡Continuemos, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 2]
  SkySceneKit.say({english=" Let's keep it up, [hero]!", french="Continuons comme ça,\n[hero]!", german=" Weiter so, [hero]!", italian=" Continuiamo così, [hero]!", spanish=" ¡Continuemos, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1]
  SkySceneKit.say({english=" Let's go for it, [hero]!", french=" Allons-y, [hero]!", german=" Vorwärts, [hero]!", italian=" Forza, [hero]!", spanish=" ¡Venga, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 3]
  SkySceneKit.say({english="We're almost there. There's no\ngiving up now!", french="Nous touchons au but.\nFinissons-en une bonne fois pour toutes!", german="Wir sind fast da. Es gibt kein\nAufgeben!", italian="Ci siamo quasi. Non molliamo\nproprio adesso!", spanish="Ya casi hemos llegado.\n¡Ahora ya no podemos volver atrás!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2]
  SkySceneKit.say({english=" Let's go carefully, [hero].", french="Avançons avec prudence,\n[hero].", german=" Vorsichtig, [hero].", italian="Ci vuole prudenza,\n[hero].", spanish="Hay que ir con\npies de plomo, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(11, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [11, 4]
  SkySceneKit.say({english="We're getting close.[K]\nLet's keep going!", french="Nous approchons du but.[K]\nCourage!", german=" Wir kommen näher.[K] Weiter!", italian="Ci siamo quasi...[K]\nAvanti così!", spanish="Nos estamos acercando.[K]\n¡Sigamos!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(11, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [11, 3]
  SkySceneKit.say({english="Not much farther to go...[K]\nWe have to hold on!", french="Ce n'est plus très loin...[K]\nAllez, il faut qu'on s'accroche!", german="Es ist nicht mehr weit...[K]\nJetzt bloß nicht aufgeben!", italian="Non manca molto...[K]\nNon molliamo!", spanish="Ya no queda mucho...[K]\n¡Tenemos que resistir!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- @label_1 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[1] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[1]
  if (SkyProg.cmp(24, 0) >= 0) or (SkyProg.cmp(23, 0) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(22, 1) >= 0) or (SkyProg.cmp(17, 4) >= 0) or (SkyProg.cmp(17, 2) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 0) >= 0) or (SkyProg.cmp(12, 2) >= 0) or (SkyProg.cmp(12, 0) >= 0) or (SkyProg.cmp(9, 0) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 0) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 0) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 0) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(5, 0) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [24, 0] || scn($SCENARIO_MAIN) >= [23
  -- @label_45 [étiquette de flux ExplorerScript]
  SkySceneKit.say({english="Ooogh...[K]\nGood morning, [hero]...", french="Arf...[K]\n'jour, [hero]...", german="Urks...[K]\nGuten Morgen, [hero]...", italian="Oooh...[K]\nBuongiorno, [hero]...", spanish="Uuuf...[K]\nBuenos días, [hero]..."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(3, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [3, 3]
  SkySceneKit.say({english="Ooogh...[K]\nMy ears are still ringing...", french="Argh...[K] Mes oreilles\nen bourdonnent encore...", german="Ooooh...[K]\nMeine Ohren klingeln immer noch...", italian="Ohi...[K] Le orecchie mi fanno\nancora male...", spanish="¡Vaya! Todavía me zumban los\noídos..."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- @label_19 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(26, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [26, 0]
  SkySceneKit.say({english="When we're ready, we can\ngo to the [CS:P]Hidden Land[CR]!", french="Préparons-nous vite et partons\npour les [CS:P]Terres Illusoires[CR]!", german="Wenn wir fertig sind, können\nwir in das [CS:P]Verborgene Land[CR] aufbrechen!", italian="Finiti i preparativi, possiamo\nandare alla [CS:P]Terra Nascosta[CR]!", spanish="En cuanto esté todo listo, nos\nvamos a la [CS:P]Tierra Oculta[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 1]
  SkySceneKit.say({english="[CS:N]Lapras[CR] is down at the beach.\nHe's waiting to take us to the [CS:P]Hidden Land[CR].", french="[CS:N]Lokhlass[CR] nous attend pour nous\nemmener jusqu'aux [CS:P]Terres Illusoires[CR].", german="[CS:N]Lapras[CR] wartet darauf, uns in\ndas [CS:P]Verborgene Land[CR] zu bringen.", italian="[CS:N]Lapras[CR] ci sta aspettando.\nCi porterà alla [CS:P]Terra Nascosta[CR].", spanish="[CS:N]Lapras[CR] está en la playa,\nesperando para llevarnos a la [CS:P]Tierra Oculta[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3]
  SkySceneKit.say({english="We may even get lucky and run\ninto [CS:N]Grovyle[CR] there.", french="Peut-être que nous y croiserons\n[CS:N]Massko[CR].", german="Wenn wir Glück haben, könnten\nwir dort sogar auf [CS:N]Reptain[CR] treffen.", italian="Potremmo aver fortuna e\nincontrare [CS:N]Grovyle[CR].", spanish="Puede que tengamos suerte y nos\nencontremos con [CS:N]Grovyle[CR] allí."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 2]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 323 or __sw == 324 or __sw == 325 then
  if ((SV.SkyTalkBitFlags or {})[121] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[121]
  SkySceneKit.say({english="Let's go by Sharpedo Bluff,\n[hero]!", french="Passons par la Falaise Sharpedo,\n[hero]!", german="Lass uns an der Tohaido-Klippe\nvorbeischauen, [hero]!", italian="Ok, dirigiamoci al Promontorio\nSharpedo, [hero]!", spanish="Deberíamos pasarnos por el\nRisco Sharpedo, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SkySceneKit.say({english="Let's get ready for tomorrow's\nouting here, [hero].", french="Préparons-nous pour l'expédition\nde demain, [hero].", german="Bereiten wir uns hier für den\nmorgigen Ausflug vor, [hero].", italian="Qui possiamo trovare le cose\nche ci serviranno domani, [hero].", spanish="Aquí podemos prepararnos para\nla excursión de mañana, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  SkySceneKit.say({english=" Off to Treasure Town!", french=" Regagnons Bourg-Trésor.", german=" Auf nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" ¡En marcha, a Aldea Tesoro!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(23, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1]
  SkySceneKit.say({english=" Off to Treasure Town.", french=" Rendons-nous à Bourg-Trésor.", german=" Auf nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3]
  SkySceneKit.say({english=" Let's go![K] To the Hot Spring!", french=" C'est parti![K] A la Source Chaude!", german="Auf geht's![K] Die Heiße Quelle\nwartet!", italian="Andiamo![K] Alla Sorgente\nTermale!", spanish=" ¡Vamos![K] ¡A la Terma!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 2]
  SkySceneKit.say({english=" Let's go![K] To the Hot Spring!", french=" C'est parti![K] A la Source Chaude!", german="Auf geht's![K] Die Heiße Quelle\nwartet!", italian=" Forza![K] Alla Sorgente Termale!", spanish=" ¡Vamos allá![K] Vamos a la Terma."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 1] || scn($SCENARIO_MAIN) >= [20
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(18, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [18, 2]
  -- supervision_ExecuteCommon(CORO_EVENT_M17_03_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(18, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [18, 1]
  SkySceneKit.say({english=" I think we're locked in...[K] Ugh...", french="Aïe...[K] Impossible\nde s'échapper...", german="Ich glaube, wir sind\neingesperrt...[K] Umpf...", italian="Oh oh... è chiuso...[K]\nChe facciamo ora?", spanish="Creo que no podemos salir...[K]\nUf..."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3]
  SkySceneKit.say({english="What's happening at [CS:P]Shining Lake[CR]\nis fascinating, but we can't just go there.", french="Ce qui se passe au [CS:P]Lac Cristal[CR]\nm'intrigue beaucoup, mais nous n'avons pas\nle droit d'y aller.", german="Die Geschehnisse am\n[CS:P]Kristallsee[CR] sind wirklich interessant, aber wir\ndürfen dort niemanden behelligen.", italian="Cosa starà succedendo al\n[CS:P]Lago di Cristallo[CR]? Purtroppo non ci possiamo\nandare...", spanish="Por muy interesante que sea\nlo que está pasando en el [CS:P]Lago Cristal[CR], no\npodemos entrometernos."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We should do the jobs on the\nJob Bulletin Board and the Outlaw Notice\nBoard as usual.", french="Occupons-nous des missions du\nTableau des Missions et des Avis de Recherche,\ncomme d'habitude.", german="Wir sollten wie üblich die Jobs\nauf dem Job-Infobrett und dem\nGanoven-Infobrett erledigen.", italian="Come sempre, ci aspettano le\nmissioni affisse alle due Bacheche!", spanish="Sigamos con las misiones del\nTablón de Anuncios y el Tablón \"Se Busca\",\ncomo siempre."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  SkySceneKit.say({english="We'll have to carry on like we\nusually do.", french="Il va falloir qu'on s'en tienne\nà la routine habituelle.", german="Wir müssen so weitermachen\nwie gewöhnlich.", italian="È meglio se continuiamo come\nal solito.", spanish="Será mejor seguir con nuestra\nrutina habitual."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="Let's put in another good day,\n[hero]!", french="Une nouvelle journée de travail\nnous attend, [hero]!", german="Auf einen weiteren guten Tag,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Venga, [hero], hay que\nponerse a hacer cosas!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2]
  SkySceneKit.say({english="Let's keep at it and get to\n[CS:P]Crystal Crossing[CR]!", french="Poursuivons notre route jusqu'au\n[CS:P]Croisement Cristal[CR]!", german="Bleiben wir dran. Lass uns zur\n[CS:P]Kristallstraße[CR] gehen!", italian="Continuiamo così e arriviamo al\n[CS:P]Bivio di Cristallo[CR]!", spanish="¡No nos entretengamos,\nvamos a la [CS:P]Vía Cristalina[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 1]
  SkySceneKit.say({english="Let's go, [hero]![K]\nWe're off to [CS:P]Crystal Cave[CR]!", french="Allez, [hero]![K]\nPartons pour la [CS:P]Caverne Cristal[CR]!", german="Auf geht's, [hero]![K]\nZur [CS:P]Kristallhöhle[CR]!", italian="Andiamo, [hero]![K]\nDestinazione: [CS:P]Grotta di Cristallo[CR]!", spanish="¡Vamos, [hero]![K]\n¡A la [CS:P]Cueva Cristal[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 4]
  SkySceneKit.say({english=" Off to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Ab zur [CS:P]Kristallhöhle[CR]!", italian=" Andiamo alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1]
  SkySceneKit.say({english="OK, [hero].[K] We should\nexplore [CS:P]Quicksand Cave[CR].", french="Allez, [hero].[K] Et si\nnous allions explorer la [CS:P]Grotte Sables\nMouvants[CR]?", german="Okay, [hero].[K] Wir sollten\ndie [CS:P]Treibsandhöhle[CR] erkunden.", italian="Ok, [hero].[K] Dovremmo\nesplorare la [CS:P]Grotta delle Sabbie Mobili[CR].", spanish="Bueno, [hero].[K] Deberíamos\nexplorar la [CS:P]Cueva Arenas[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 5]
  SkySceneKit.say({english=" Back to [CS:P]Quicksand Desert[CR]!", french="Retournons dans le [CS:P]Désert\nSables Mouvants[CR]!", german=" Zurück in die [CS:P]Mahlsandwüste[CR]!", italian="Torniamo nel [CS:P]Deserto delle[CR]\n[CS:P]Sabbie Mobili[CR]!", spanish="¡Vamos de nuevo a las\n[CS:P]Arenas Movedizas[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4]
  SkySceneKit.say({english=" Let's work at it, [hero]!", french=" Au travail, [hero]!", german="Lass uns daran arbeiten,\n[hero]!", italian="Dobbiamo impegnarci,\n[hero]!", spanish=" ¡Vamos allá, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 2]
  SkySceneKit.say({english="Let's go, [hero]![K]\nOff to the [CS:P]Northern Desert[CR]!", french="Allons-y, [hero]![K]\nEn route pour le [CS:P]Désert du Nord[CR]!", german="Auf geht's, [hero]![K]\nNächstes Ziel: [CS:P]Nordwüste[CR]!", italian="Andiamo, [hero]![K]\nVerso il [CS:P]Deserto del Nord[CR]!", spanish="¡Venga, [hero]![K]\nVamos al [CS:P]Desierto Norte[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1]
  SkySceneKit.say({english="When we're ready, let's go back\nto the guild.", french="Finissons nos préparatifs\net retournons à la Guilde.", german="Lass uns zur Gilde\nzurückgehen, sobald wir fertig sind.", italian="Quando abbiamo finito, torniamo\nalla Gilda.", spanish="Regresemos al [CS:N]Pokégremio[CR]\ncuando lo tengamos todo listo."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2]
  SkySceneKit.say({english=" Let's go to [CS:P]Amp Plains[CR]!", french=" Allons aux [CS:P]Plaines Elek[CR]!", german=" Auf in die [CS:P]Ampere-Ebene[CR]!", italian=" Andiamo alle [CS:P]Pianure Saetta[CR]!", spanish=" ¡Vamos a la [CS:P]Pradera Destello[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 1]
  SkySceneKit.say({english="Hurry, [hero]! We have\nto go!", french="Vite, [hero]!\nIl faut y aller!", german="Beeil dich, [hero]! Wir\nmüssen los!", italian="Presto, [hero]! Dobbiamo\nandare!", spanish="¡Deprisa, [hero]!\n¡Debemos irnos!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4]
  SkySceneKit.say({english="[CS:N]Chatot[CR] was disappointed...[K]\nIt's just too bad, though.", french="[CS:N]Pijako[CR] était déçu...[K]\nmais nous ne pouvons rien y faire,\nde toute façon.", german="[CS:N]Plaudagei[CR] war enttäuscht...[K]\nDas ist wirklich schade.", italian="[CS:N]Chatot[CR] era deluso...[K]\nÈ stata solo sfortuna!", spanish="[CS:N]Chatot[CR] estaba decepcionado...[K]\nLa verdad es que es una lástima."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We should deal with jobs from\nthe Job Bulletin Board and Outlaw Notice Board\nfor now.", french="Pour l'instant, nous devrions\nnous occuper des missions du Tableau des\nMissions et des Avis de Recherche.", german="Wir sollten uns fürs Erste mit\nweiteren Jobs vom Job-Infobrett und vom\nGanoven-Infobrett befassen.", italian="Diamo un'occhiata alle missioni\naffisse alle due Bacheche.", spanish="Por el momento deberíamos\nocuparnos de las misiones del Tablón de\nAnuncios y del Tablón \"Se Busca\"."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 3]
  SkySceneKit.say({english="Let's go to [CS:K]Kecleon[CR] Market,\n[hero].", french="Allons au [CS:K]Marché Kecleon[CR],\n[hero].", german="Auf zum [CS:K]Kecleon-Markt[CR],\n[hero].", italian="Andiamo al [CS:K]Kecleon[CR] Market,\n[hero].", spanish="Vayamos al [CS:K]Bazar Kecleon[CR],\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  SkySceneKit.say({english="Let's do more jobs from the\nJob Bulletin Board and Outlaw Notice Board.", french="Allons accomplir d'autres\nmissions du Tableau des Missions et des\nAvis de Recherche.", german="Lass uns weitere Jobs vom\nJob-Infobrett und vom Ganoven-Infobrett\nerledigen.", italian="La Bacheca delle missioni e la\nBacheca dei ricercati ci aspettano!", spanish="Hagamos más misiones del\nTablón de Anuncios y del Tablón \"Se Busca\"."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  SkySceneKit.say({english="We'd better get equipped for an\nextended expedition!", french="Nous ferions mieux de bien nous\npréparer, le voyage va être long!", german="Wir rüsten uns besser für eine\nlängere Expedition aus!", italian="Faremmo meglio a equipaggiarci\nper una lunga spedizione!", spanish="Será mejor que nos preparemos\npara una expedición prolongada."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" We have to report to [CS:N]Chatot[CR].", french="... nous devrons aller voir\n[CS:N]Pijako[CR].", german="Dann müssen wir uns bei\n[CS:N]Plaudagei[CR] melden.", italian=" Dobbiamo andare da [CS:N]Chatot[CR].", spanish="Debemos presentarnos\nante [CS:N]Chatot[CR]."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" Let's work hard, [hero]!", french="Donnons le maximum,\n[hero]!", german="Strengen wir uns besonders\nan, [hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish=" ¡A trabajar duro, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  SkySceneKit.say({english="Let's keep working so we'll get\npicked for the expedition!", french="Continuons à travailler dur!\nComme ça, on nous choisira pour\nl'expédition!", german="Wir müssen uns weiter\nanstrengen, damit wir für die\nExpedition ausgewählt werden!", italian="Continuiamo a fare del nostro\nmeglio, così ci sceglieranno per la spedizione!", spanish="¡Sigamos trabajando a tope\npara poder participar en la expedición!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2]
  SkySceneKit.say({english="Let's go to [CS:P]Apple Woods[CR],\n[hero]!", french="Allons au [CS:P]Bois aux Pommes[CR],\n[hero]!", german="Auf in den [CS:P]Apfelwald[CR],\n[hero]!", italian="Andiamo al [CS:P]Giardino dei Meli[CR],\n[hero]!", spanish="Vamos al [CS:P]Manzanar[CR],\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 1]
  SkySceneKit.say({english="Let's go to [CS:P]Apple Woods[CR],\n[hero]!", french="Allons au [CS:P]Bois aux Pommes[CR],\n[hero]!", german="Auf in den [CS:P]Apfelwald[CR],\n[hero]!", italian="Andiamo al [CS:P]Giardino dei Meli[CR],\n[hero]!", spanish="¡Vamos al [CS:P]Manzanar[CR],\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  SkySceneKit.say({english=" But we'd better be careful.", french=" Restons sur nos gardes!", german="Aber wir sollten besser\nvorsichtig sein.", italian=" ... ma è meglio stare all'erta.", spanish=" Debemos tener cuidado."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" Let's look good, [hero]!", french="Allez, essayons de faire bonne\nimpression, [hero]!", german="Lass uns unser Bestes geben,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish="Tenemos que estar impecables,\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- @label_89 [étiquette de flux ExplorerScript]
  SkySceneKit.say({english=" Let's look good, [hero]!", french="Allez, essayons de faire bonne\nimpression, [hero]!", german="Lass uns unser Bestes geben,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish=" ¡A darlo todo, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1]
  SkySceneKit.say({english="Let's work hard so they pick us\nfor the expedition, [hero]!", french="Travaillons dur, [hero],\ncomme ça ils nous choisiront pour partir\nen expédition!", german="Strengen wir uns besonders an,\ndamit wir für die Expedition ausgewählt\nwerden, [hero]!", italian="Dobbiamo impegnarci, così\nci sceglieranno per la spedizione, [hero]!", spanish="Vamos a esforzarnos para que\nnos elijan para la expedición, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 5]
  SkySceneKit.say({english="Let's go, [hero]![K]\nTo [CS:P]Waterfall Cave[CR]!", french="Allons-y, [hero]![K]\nA la [CS:P]Grotte Cascade[CR]!", german="Auf geht's, [hero]![K]\nZur [CS:P]Wasserfallhöhle[CR]!", italian="Andiamo, [hero]![K]\nAlla [CS:P]Grotta della Cascata[CR]!", spanish="Vamos, [hero].[K]\n¡A la [CS:P]Cueva Cascada[CR]!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 1]
  SkySceneKit.say({english="Let's go, [hero]![K] To the\nwaterfall!", french="Allons-y, [hero]![K]\nA la cascade!", german="Auf geht's, [hero]![K] Zum\nWasserfall!", italian="Andiamo, [hero]![K] Verso\nla cascata!", spanish="¡Vamos, [hero]![K]\n¡A la cascada!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_89 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5]
  SkySceneKit.say({english=" Let's hurry to [CS:P]Mt. Bristle[CR]!", french="Dépêchons-nous d'aller\nau [CS:P]Mt Hérissé[CR]!", german=" Auf zum [CS:P]Stachelberg[CR]!", italian=" Corriamo al [CS:P]Monte Crespo[CR]!", spanish=" ¡Al [CS:P]Monte Árido[CR], deprisa!"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3]
  SkySceneKit.say({english="[CS:N]Bidoof[CR] should be waiting for us\non the guild's upper underground floor.", french="[CS:N]Keunotor[CR] a dit qu'il nous\nattendrait au premier sous-sol de la Guilde.", german="[CS:N]Bidiza[CR] müsste in der Unteren\nGildenebene 1 auf uns warten.", italian="[CS:N]Bidoof[CR] ha detto che avrebbe\naspettato al Piano inferiore della Gilda 1.", spanish="[CS:N]Bidoof[CR] estará esperándonos en\nla planta -1 del [CS:N]Pokégremio de Exploradores[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2]
  SkySceneKit.say({english="[hero].[K]\nWhere shall we go next?", french="[hero].[K]\nOù on va maintenant?", german="[hero].[K]\nWohin sollen wir jetzt gehen?", italian="[hero].[K]\nE adesso dove andiamo?", spanish="[hero].[K]\n¿Adónde deberíamos ir ahora?"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 1]
  SkySceneKit.say({english="Let's hurry over to [CS:K]Kecleon[CR]\nMarket, [hero].", french="Dépêchons-nous d'aller au\n[CS:K]Marché Kecleon[CR], [hero].", german="Lass uns schnell zum\n[CS:K]Kecleon-Markt[CR] laufen, [hero].", italian="Andiamo subito al [CS:K]Kecleon[CR]\nMarket, [hero].", spanish="Vamos corriendo al\n[CS:K]Bazar Kecleon[CR], [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0]
  SkySceneKit.say({english=" What shall we do today?", french=" Alors, on fait quoi aujourd'hui?", german=" Was sollen wir heute machen?", italian=" Allora, che facciamo oggi?", spanish=" ¿Qué vamos a hacer hoy?"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [3, 1]
  SkySceneKit.say({english="What...[K]\nWhat should we do?", french=" Que...[K] que devrions-nous faire?", german="Was...[K]\nWas sollen wir tun?", italian="Cosa...[K]\nCosa dobbiamo fare?", spanish="¿Qué?[K]\n¿Qué deberíamos hacer?"}) -- SwitchTalk: branche default (canon générique)
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
end
