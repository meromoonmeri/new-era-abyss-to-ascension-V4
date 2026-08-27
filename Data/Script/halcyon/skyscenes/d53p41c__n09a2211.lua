-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P41C/n09a2211.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P06C) [décor sub chargé: Sub_v38p06c]
  -- back_SetGround(LEVEL_D53P41C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 15.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  SkySubScreen.Show("v38p06c", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D53P41C1_457) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" M-Master [CS:N]Dialga[CR]...", french=" M-Maître [CS:N]Dialga[CR]...", german=" M-meister [CS:N]Dialga[CR]...", italian=" M-Maestro [CS:N]Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR]...[K]I have something\nI want to ask...", french="[CS:N]Dialga[CR]...[K] J'ai quelque chose\nà vous demander...", german="[CS:N]Dialga[CR]...[K]\nIch habe eine Frage...", italian="[CS:N]Dialga[CR]...[K] Vorrei chiederti\nuna cosa...", spanish=" [CS:N]Dialga[CR]...[K] Quiero preguntarte algo..."})
  -- GAP: BGM BGM_ITS_NOT_A_MIRACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Earlier when we did not\ndisappear...", french="Tout à l'heure, si nous n'avons\npas disparu...", german="Vorhin, als wir nicht\nverschwunden sind...", italian="Prima, quando non siamo\nscomparsi...", spanish=" Antes, cuando no desaparecimos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You said it wasn't a miracle...[K]\nBut was it thanks to you?", french="... vous avez dit que ce n'était\npas un miracle...[K] Est-ce à vous que nous\nle devons?", german="Du sagtest, es sei kein Wunder\ngewesen...[K] Hast du also dafür gesorgt?", italian="Hai detto che non si è trattato\ndi un prodigio...[K] Allora è merito tuo?", spanish="Dices que no fue un milagro...[K]\n¿Pero fue gracias a ti?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 256, 240, Direction.Down, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" NO.[K] IT WAS NOT ME.", french=" NON.[K] CE N'ETAIT PAS MOI.", german=" NEIN.[K] DAS WAR NICHT ICH.", italian=" NO.[K] NON SONO STATO IO.", spanish=" NO.[K] NO FUI YO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="I DON'T HAVE THE POWER\nNECESSARY TO STOP YOU FROM\nDISAPPEARING.", french=" JE N'AI PAS CE POUVOIR.", german="MEINE MACHT GENÜGT NICHT,\nUM EUER VERSCHWINDEN ZU VERHINDERN.", italian="IO NON AVREI AVUTO POTERE\nA SUFFICIENZA PER IMPEDIRE LA VOSTRA\nSCOMPARSA.", spanish="NO TENGO EL PODER NECESARIO\nPARA EVITAR QUE DESAPAREZCAMOS."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" HOWEVER...", french=" CEPENDANT...", german=" ABER...", italian=" TUTTAVIA...", spanish=" PERO TAL VEZ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" A BEING HIGHER THAN MYSELF...", french="UN ETRE PLUS PUISSANT\nQUE MOI...", german="EIN WESEN,\nDAS ÜBER MIR STEHT...", italian=" UN ESSERE SUPERIORE A ME...", spanish=" UN SER MÁS PODEROSO..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THAT BEING'S POWER...[K]COULD\nHAVE DONE IT.", french=" ... A CE POUVOIR.", german="DIE MACHT DIESES WESENS...[K]\nSIE KÖNNTE ES GEWESEN SEIN.", italian="... CON IL SUO POTERE...[K]\nSAREBBE STATO IN GRADO DI FARCELA.", spanish=" ESE SER...[K] PODRÍA HABERLO HECHO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THIS WAS SURELY...[K]THAT\nPOWER AT WORK, I BELIEVE.", french="C'EST SUREMENT LUI...[K] QUI\nEST INTERVENU.", german="ES WAR WOHL... [K]DIESE MACHT,\nDIE GEWALTET HAT. DAS MAG SEIN.", italian="CREDO CHE...[K] SIA ACCADUTO\nPROPRIO QUESTO.", spanish="YO CREO...[K] QUE ESO ES LO QUE\nHA OCURRIDO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND SO...[K]I MUST EXPRESS\nMY GRATITUDE.", french="AINSI DONC...[K] JE DOIS VOUS\nEXPRIMER MA GRATITUDE.", german="UND DESWEGEN...[K]\nMUSS ICH EUCH DANKEN.", italian="MA ORA...[K] HO UN DEBITO\nDI RICONOSCENZA NEI VOSTRI CONFRONTI.", spanish="Y AHORA...[K] DEBO MOSTRAR\nMI GRATITUD."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="IT'S WONDERFUL THAT YOU'VE\nRETURNED THE WORLD FROM DARKNESS\nFOR ME.", french="POUR AVOIR SAUVE LE MONDE DE\nL'OMBRE ETERNELLE.", german="ES IST WUNDERBAR,\nDASS IHR FÜR MICH DIESE WELT\nVON DER DUNKELHEIT BEFREIT HABT.", italian="È FANTASTICO CHE ABBIATE\nSALVATO IL MONDO DALL'OSCURITÀ\nPER AIUTARMI.", spanish="ES MARAVILLOSO QUE HAYÁIS\nARREBATADO ESTE MUNDO DE LAS GARRAS\nDE LA OSCURIDAD."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" I'M TRULY...[K]TRULY GRATEFUL.", french="JE VOUS SUIS...[K] INFINIMENT\nRECONNAISSANT.", german="ICH BIN EUCH WIRKLICH...[K]\nWIRKLICH DANKBAR.", italian=" VI SONO...[K] DAVVERO GRATO.", spanish="ESTOY...[K] VERDADERAMENTE\nAGRADECIDO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="TO YOU...[K]AND THE ONES WHO\nSTOPPED THE PLANET'S PARALYSIS IN\nTHE PAST...", french="A VOUS...[K] ET A CEUX QUI ONT\nMIS UN TERME A LA PARALYSIE DE LA\nPLANETE DANS LE PASSE...", german="EUCH...[K] UND DENJENIGEN,\nDIE IN DER VERGANGENHEIT DIE LÄHMUNG\nDES PLANETEN AUFGEHOBEN HABEN...", italian="A VOI...[K] E A COLORO CHE HANNO\nFERMATO LA PARALISI DEL PIANETA NEL\nPASSATO...", spanish="A VOSOTROS...[K] Y A QUIENES\nDETUVIERON LA PARÁLISIS DEL PLANETA\nEN EL PASADO..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" YOUR FRIENDS...", french=" VOS ACOLYTES...", german=" EUREN FREUNDEN...", italian=" I VOSTRI AMICI...", spanish=" ¡GRACIAS DE CORAZÓN!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] Th-that's right!", french=" ...![K] C'est vrai!", german=" ...[K]D-das stimmt!", italian=" ...![K] G-Giusto!", spanish=" ¡Ah...![K] ¡Por supuesto!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We...[K]we are still here...", french=" Si nous sommes...[K] toujours là...", german="Wir...[K]\nWir sind immer noch da...", italian=" Noi...[K] siamo ancora qui...", spanish=" Si...[K] seguimos aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 48, false) end) -- waypoint caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(40), g.ViewCenter.Y+(0), 80, false) end) -- waypoint caméra
  GROUND:MoveToPosition(hero, 288, 252, false, 2)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 200, 280, Direction.UpRight, "NPC_YONOWAARU_N9")
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_diaruga, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 312, 288, Direction.UpLeft, "NPC_SEREBII")
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(50)
  -- GAP: BGM BGM_THOUGHTS_FOR_FRIENDS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [c_name:NPC_HERO_FIRST]![K] You too...", french=" [c_name:NPC_HERO_FIRST]![K] Toi aussi...", german=" [c_name:NPC_HERO_FIRST]![K] Du auch...", italian=" [c_name:NPC_HERO_FIRST]![K] Anche tu...", spanish=" ¡[c_name:NPC_HERO_FIRST]![K] Tú también..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I hope you're safe as well!?", french=" ... j'espère que tu vas bien!", german="Ich hoffe,\nauch du bist in Sicherheit?!?", italian="Spero che anche tu ce l'abbia\nfatta!", spanish=" ¡Tú también estarás bien!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you didn't disappear either...[K]\nAre you still alive?", french="Si tu n'as pas disparu toi\nnon plus...[K] Es-tu toujours en vie?", german="Bist du auch nicht\nverschwunden...[K] Bist du noch da?", italian="Se nemmeno tu hai abbandonato\nquesto mondo...[K] Allora sei ancora qui?!", spanish="Si tampoco has desaparecido...[K]\n¿estarás bien?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" And [c_name:NPC_PARTNER_FIRST]![K] You...", french=" Et [c_name:NPC_PARTNER_FIRST]![K] Tu...", german=" Und [c_name:NPC_PARTNER_FIRST]![K] Du...", italian=" E [c_name:NPC_PARTNER_FIRST]![K] Tu...", spanish=" ¡Y [c_name:NPC_PARTNER_FIRST]![K] Tú..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The fate of Pokémon in the\nfuture when you changed history...", french="Vous avez changé le destin des\nPokémon du futur en même temps que\nle cours de l'histoire...", german="Du hast das Schicksal der\nPokémon der Zukunft geformt, als du den Lauf\nder Geschichte verändert hast...", italian="Il destino dei Pokémon del\nfuturo quando hai cambiato la storia...", spanish="El destino de los Pokémon del\nfuturo cuando cambiasteis la historia..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My fate and that of\n[c_name:NPC_HERO_FIRST]...", french="Mon destin et celui de\n[c_name:NPC_HERO_FIRST]...", german="Mein Schicksal und auch das von\n[c_name:NPC_HERO_FIRST]...", italian=" Il mio e quello di [c_name:NPC_HERO_FIRST]...", spanish=" Mi destino y el de [c_name:NPC_HERO_FIRST]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I expect you'll find out later,\nbut right now you're...", french="Tu t'en rendras bientôt compte,\nmais...", german="Ich erwarte, dass du es selbst\nherausfinden wirst, aber schon jetzt...", italian="Credo che lo scoprirai più\navanti, ma ora tu...", spanish="Más adelante lo descubriréis,\npero de momento..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What are you thinking?", french="... à quoi penses-tu\nactuellement?", german=" Was denkst du jetzt?", italian=" ... a cosa stai pensando?", spanish=" ¿En qué pensáis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(16), g.ViewCenter.Y+(0), 32, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_serebii, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(20), p.Y+(0), false, 1) end
  GROUND:EntTurn(npc_npc_diaruga, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- GAP: BGM BGM_A_MESSAGE_ON_THE_WIND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_SetWaitMode(180, 90) [neutre/état moteur]
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (The wind![K] The light!)", french=" ... (Ô vent![K] Ô lumière!)", german=" ...(Wind![K] Licht! Ich bitte euch!)", italian=" ... (Vento![K] Luce!)", spanish=" Ah... (¡Sopla el viento![K] ¡Y qué luz!)"})
  -- message_KeyWait
  -- message_SetWaitMode(270, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(If you can carry my message...[K]\nPlease send it to [c_name:NPC_HERO_FIRST] and\n[c_name:NPC_PARTNER_FIRST]!)", french="(Si vous pouvez transmettre\nmon message...[K] à [c_name:NPC_HERO_FIRST] et\n[c_name:NPC_PARTNER_FIRST]!)", german="(Überbringt meine Nachricht...[K]\nBitte bringt sie zu [c_name:NPC_HERO_FIRST] und\n[c_name:NPC_PARTNER_FIRST]!)", italian="(Vi prego...[K] portate queste\nmie parole a [c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST]!)", spanish="(Si el viento puede transmitir este\nmensaje...[K] ¡ojalá llegue a [c_name:NPC_HERO_FIRST]\ny [c_name:NPC_PARTNER_FIRST]!)"})
  -- message_KeyWait
  -- message_SetWaitMode(290, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Thanks to you, the future has\nbeen freed from darkness!)", french="(Grâce à vous, le futur est\nenfin libéré de l'emprise de l'ombre éternelle!)", german="(Durch eure Bemühungen wurde\ndie Zukunft von der Dunkelheit befreit!)", italian="(Grazie a voi il mondo del futuro\nè stato liberato dall'oscurità!)", spanish="(Gracias a vuestro esfuerzo,\n¡el mundo ha quedado libre de las tinieblas!)"})
  -- message_KeyWait
  -- message_SetWaitMode(250, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(And we...and the other\nPokémon in the future...are safe!)", french="(Et tous les Pokémon du futur\nsont sains et saufs!)", german="(Und wir und die anderen\nPokémon der Zukunft... Wir sind frei!)", italian="(Noi... e tutti gli altri Pokémon\ndel futuro... siamo salvi!)", spanish="(Yo y los demás Pokémon del\nfuturo... ¡estamos a salvo!)"})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (We didn't disappear!)", french=" (Nous n'avons pas disparu!)", german=" (Wir sind nicht verschwunden!)", italian=" (Non siamo scomparsi!)", spanish=" (¡No hemos desaparecido!)"})
  -- message_KeyWait
  -- message_SetWaitMode(290, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(From now on, we're going to\ncombine our strengths and rebuild this world.)", french="(Désormais, nous allons unir\nnos forces pour reconstruire ce monde.)", german="(Wir werden unsere Kräfte\nvereinen und die Welt wiederaufbauen.)", italian="(D'ora in poi, uniremo le nostre\nforze per ricostruire questo mondo.)", spanish="(Desde ahora aunaremos esfuerzos\npara reconstruir este mundo.)"})
  -- message_KeyWait
  -- message_SetWaitMode(280, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(For [CS:N]Celebi[CR], who has supported\nme all this way...[K] After this...)", french="(Pour [CS:N]Celebi[CR], qui m'a soutenu\npendant tout ce temps...[K] Après tout...)", german="([CS:N]Celebi[CR] zu Ehren, das mich den\nganzen Weg über begleitet hat...[K] Bis hierhin...)", italian="(E anche tu [CS:N]Celebi[CR], che mi hai\naiutato...[K] sempre...)", spanish="(Por [CS:N]Celebi[CR], que me ha apoyado\ntodo este tiempo...[K] Ahora...)"})
  -- message_KeyWait
  -- message_SetWaitMode(260, 120) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Above all, we...[K]are still alive!)", french="(... ce qui compte...[K] c'est que la\nvie continue!)", german="(Wichtiger als alles andere ist...[K]\nWir sind noch da!)", italian="(Alla fine...[K] noi esistiamo\nancora!)", spanish=" (Ante todo...[K] ¡seguimos aquí!)"})
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 15)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
