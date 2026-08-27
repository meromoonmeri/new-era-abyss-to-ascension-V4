-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m02a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 256, 216, Direction.Down, "NPC_BANEBUU")
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Th-thank you!", french=" M-merci!", german=" D-danke!", italian=" G-Grazie!", spanish=" ¡Gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="That pearl must be propped on\nmy head, you see. I missed it so much!", french="Cette perle doit reposer sur\nma tête, comme ça. Elle m'a tellement manqué!", german="Diese Perle muss auf meinem\nKopf liegen, seht ihr? Sie hat mir so gefehlt!", italian="La perla deve stare sulla mia\ntesta, capite? Mi è mancata così tanto!", spanish="Necesito llevar esa perla en\nla cabeza. ¡La echaba tanto de menos...!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I just couldn't settle down\nwithout it up there!", french="C'est simple, je n'arrive pas\nà me calmer quand elle n'est pas là!", german="Ich konnte mich einfach nicht\nberuhigen, solange sie nicht da oben war!", italian="Non riuscivo a stare tranquillo\nsenza!", spanish="¡No podría vivir tranquilo\nsin ella!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="So I was just boinging and\nsproinging everywhere!", french="Je passais mon temps à bondir\net rebondir dans tous les sens!", german="Ich sprang und federte nur so\ndurch die Gegend!", italian="Quindi saltavo da una parte\nall'altra!", spanish="¡Por eso estaba que rebotaba,\nliteralmente!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="That's why I'm covered in dings\nand bumps.", french="C'est pour ça que je suis\nrecouvert de bosses et de bleus.", german="Darum habe ich jetzt überall\nblaue Flecken.", italian="È per questo che sono coperto\ndi bernoccoli.", spanish="Por eso estoy cubierto de\nchichones y moratones."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="But thanks to you, that long\nnightmare is over!", french="Merci beaucoup, ce cauchemar\nest enfin terminé!", german="Aber dank euch ist dieser\nAlbtraum nun vorbei!", italian="Ma grazie a voi l'incubo è\nfinito!", spanish="¡Pero gracias a vuestro equipo\nla pesadilla ha terminado!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" You have my sincere thanks!", french=" Je vous remercie sincèrement!", german=" Ich bin euch aufrichtig dankbar!", italian=" Vi sono molto grato!", spanish="¡Contáis con mi más sincero\nagradecimiento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_banebuu.Position; GROUND:MoveToPosition(npc_npc_banebuu, p.X+(16), p.Y+(16), false, 2) end
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_banebuu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded with\n[CN]a [CS:I]Protein[CR]!", french="[CN]En récompense, l'équipe de\n[CN][hero] reçoit une [CS:I]Protéine[CR]!", german="[CN]Das Team von [hero] erhält\n[CN]ein [CS:I]Protein[CR] zur Belohnung!", italian="[CN]La squadra di [hero] riceve come\n[CN]ricompensa una [CS:I]Proteina[CR]!", spanish="[CN]¡El equipo de [hero] fue recompensado\n[CN]con una [CS:I]Proteína[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="[CN]You also received a [CS:I]Calcium[CR]!", french="[CN]Vous recevez aussi un [CS:I]Calcium[CR]!", german="[CN]Außerdem erhältst du ein [CS:I]Kalzium[CR]!", italian="[CN]Ricevi anche del [CS:I]Calcio[CR]!", spanish="[CN]¡También recibisteis un [CS:I]Calcio[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="[CN]You also received an [CS:I]Iron[CR]!", french="[CN]Vous recevez aussi un [CS:I]Fer[CR]!", german="[CN]Außerdem erhältst du ein [CS:I]Eisen[CR]!", italian="[CN]Ricevi anche del [CS:I]Ferro[CR]!", spanish="[CN]¡También recibisteis un [CS:I]Hierro[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="[CN]You were also given\n[CN][CS:G]2[MP]000[CR][M:S0]! Incredible!", french="[CN]Vous recevez aussi [CS:G]2 000[CR][M:S0]! Incroyable!", german="[CN]Du erhältst außerdem\n[CN][CS:G]2.000[CR][M:S0]! Unglaublich!", italian="[CN]Ricevi anche\n[CN][CS:G]2[MP]000[CR][M:S0]! Incredibile!", spanish="[CN]También habéis obtenido\n[CN][CS:G]2000[CR][M:S0]. ¡Increíble!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] All this\nmoney's for us?", french="Oh, waouh! [CS:G]2 000[CR][M:S0]?![K] Tout cet\nargent est pour nous?", german="Hey, wow! [CS:G]2.000[CR][M:S0]?!?[K]\nDas ganze Geld ist für uns?", italian="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] Tutti per\nnoi?", spanish="¡Caray! ¡¿[CS:G]2000[CR][M:S0]?![K] ¿Y todo\neste dinero es nuestro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] All this\nmoney is for us?", french="Oh, waouh! [CS:G]2 000[CR][M:S0]?![K] Tout cet\nargent est pour nous?", german="Hey, wow! [CS:G]2.000[CR][M:S0]?!?[K]\nDas ganze Geld ist für uns?", italian="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] Tutti per\nnoi?", spanish="¡Caramba! ¡¿[CS:G]2000[CR][M:S0]?![K] ¿Y todo\neste dinero es nuestro?"})
  else
  SkySceneKit.say({english="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] We can\nhave all this money?", french="Oh, waouh! [CS:G]2 000[CR][M:S0]?![K] Tout cet\nargent est pour nous?", german="Hey, wow! [CS:G]2.000[CR][M:S0]?!?[K]\nDas ganze Geld ist für uns?", italian="Oh, wow! [CS:G]2[MP]000[CR][M:S0]?![K] Tutti per\nnoi?", spanish="¡Caray! ¡¿[CS:G]2000[CR][M:S0]?![K] ¿Podemos\nquedarnos todo este dinero?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Of course! Of course! That's\nnothing compared to my pearl's value!", french="Bien sûr! Bien sûr! C'est\nbien peu de chose comparé à la valeur\nde ma perle!", german="Natürlich, natürlich! Es ist\nwertlos für mich, verglichen mit meiner\nPerle!", italian="Certo! Certo! Non è niente\nrispetto al valore della mia perla!", spanish="¡Claro que sí! ¡Eso no es nada\nen comparación con lo que vale mi perla!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Farewell!", french=" Adieu!", german=" Lebt wohl!", italian=" Arrivederci!", spanish=" ¡Hasta la vista!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_banebuu.Position; GROUND:MoveToPosition(npc_npc_banebuu, p.X+(40), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_banebuu, 332, 204, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 224, 208, Direction.DownRight, "NPC_PERAPPU")
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_banebuu, 332, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_banebuu.Position; GROUND:MoveToPosition(npc_npc_banebuu, p.X+(0), p.Y+(-64), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're rich, [hero]!\nJust like that, we're rich!", french="Nous sommes riches,\n[hero]! D'un seul coup, nous\nvoilà riches!", german="Wir sind reich, [hero]!\nGanz einfach so! Reich!", italian="Siamo ricchi, [hero]!\nSiamo ricchi sfondati!", spanish="¡Somos ricos, [hero]!\n¡Así por las buenas, somos ricos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're rich, [hero]!\nWe got rich just like that!", french="Nous sommes riches,\n[hero]! D'un seul coup, nous\nvoilà riches!", german="Wir sind reich, [hero]!\nGanz einfach so! Reich!", italian="Siamo ricchi, [hero]!\nSiamo ricchi!", spanish="¡Somos ricos, [hero]!\n¡Solo por hacer eso, somos ricos!"})
  else
  SkySceneKit.say({english="We're rich, [hero]! All of\na sudden, we're rich!", french="Nous sommes riches,\n[hero]! D'un seul coup, nous\nvoilà riches!", german="Wir sind reich, [hero]!\nGanz einfach so! Reich!", italian="Quanti soldi, [hero]! Sono\ndavvero tanti!", spanish="¡No me lo puedo creer!\n[hero], ¿habías visto antes tanto\ndinero junto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well done, team! ♪", french=" Bravo, vous deux! ♪", german=" Gut gemacht, Team! ♪", italian=" Ben fatto, squadra! ♪", spanish=" ¡Buen trabajo, equipo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GROUND:MoveToPosition(npc_npc_perappu, 268, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now hand that money over, if\nyou please!", french="Veuillez me remettre cet argent,\nà présent!", german="Nun überreicht mir das Geld,\nwenn ich bitten darf!", italian="Adesso, se non vi spiace,\nconsegnate i soldi!", spanish="¡Ahora dadme el dinero,\nsi no os importa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Häh?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Häh?!?", italian=" Eh?!", spanish=" ¿Perdón?"})
  else
  SkySceneKit.say({english=" Excuse me?!", french=" Hein?!", german=" Wie bitte?!?", italian=" Cosa?!", spanish=" ¿Cómo dices?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Most of the money from jobs\ngoes to the Guildmaster, you see! ♪", french="Voyez-vous, la plus grande\npartie de l'argent gagné grâce aux missions\nrevient au Maître de la Guilde! ♪", german="Der Großteil des Geldes, das\ndurch Jobs verdient wird, geht an den\nGildenmeister! ♪", italian="La maggior parte dei proventi\ndelle missioni va al Capitano! ♪", spanish="Casi todo el dinero de estas\nmisiones va a parar al Gran Bluff. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And your team's share of the\nmoney comes out to this much...! ♪", french="Et voici la part qui vous revient\nsur cette somme...! ♪", german="Und der Anteil eures Teams an\ndem Geld beläuft sich auf... ♪", italian="E la quota che tocca\nalla vostra squadra ammonta a...! ♪", spanish=" Vuestro porcentaje es este... ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8713) — id SE NDS sans portage PMDO identifié
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CARRY_GOLD = ((SV.SkyVars.CARRY_GOLD) or 0) + 200 -- $CARRY_GOLD += 200 (ROM)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] We keep only [CS:G]200[CR][M:S0]?", french="Hein?![K] Nous gardons seulement\n[CS:G]200[CR][M:S0]?", german=" Häh?!?[K] Wir kriegen nur [CS:G]200[CR][M:S0]?", italian=" Eh?![K] A noi vanno solo [CS:G]200[CR][M:S0]?", spanish="¡¿Qué?![K] ¿Solo podemos\nquedarnos [CS:G]200[CR][M:S0]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?![K] We keep only [CS:G]200[CR][M:S0]?", french="Hein?![K] Nous gardons seulement\n[CS:G]200[CR][M:S0]?", german=" Häh?!?[K] Wir kriegen nur [CS:G]200[CR][M:S0]?", italian=" Eh?![K] Ci spettano solo [CS:G]200[CR][M:S0]?", spanish="¡¿Qué?![K] ¿Solo podemos\nquedarnos [CS:G]200[CR][M:S0]?"})
  else
  SkySceneKit.say({english=" Huh?![K] We keep only [CS:G]200[CR][M:S0]?", french="Hein?![K] Nous gardons seulement\n[CS:G]200[CR][M:S0]?", german=" Häh?!?[K] Wir kriegen nur [CS:G]200[CR][M:S0]?", italian=" Eh?![K] Per noi solo [CS:G]200[CR][M:S0]?", spanish="¡¿Qué?![K] ¿Solo podemos\nquedarnos [CS:G]200[CR][M:S0]?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's terrible!", french=" Ce n'est pas juste!", german=" Das ist ja schrecklich!", italian=" È ingiusto!", spanish=" ¡Menudo timo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's awful!", french=" Ce n'est pas juste!", german=" Wie gemein!", italian=" Che ingiustizia!", spanish=" ¡Pero bueno!"})
  else
  SkySceneKit.say({english=" That's not fair!", french=" Ce n'est pas juste!", german=" Das ist nicht fair!", italian=" Non è giusto!", spanish=" ¡No es justo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well that's the guild's rule.[K]\nYou simply have to accept it! ♪", french="C'est la règle de la Guilde.[K]\nVous devez l'accepter! ♪", german="Nun, es ist die Regel der\nGilde.[K] Ihr müsst euch damit abfinden! ♪", italian="Beh, è la regola della Gilda.[K]\nDovete accettarla! ♪", spanish="Esas son las reglas del [CS:N]Pokégremio[CR].[K]\nNo os queda más remedio que acatarlas. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmph...", french=" Hum...", german=" Hmpf...", italian=" Hmph...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmph...", french=" Hum...", german=" Hmpf...", italian=" Hmph...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmph...", french=" Hum...", german=" Hmpf...", italian=" Hmph...", spanish=" Hum..."})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  else
  -- item_Set(0, 102, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- item_Set(0, 101, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- item_Set(0, 100, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
