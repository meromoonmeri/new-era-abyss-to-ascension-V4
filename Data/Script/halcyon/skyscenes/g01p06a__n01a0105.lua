-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06A/n01a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_EATING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Crunch munch! Chomp chomp!", french=" Cronch miam! Cronch slurp!", german=" Stopf-schling! Schmatz!", italian=" Gnam-gnam! Crunch-crunch!", spanish=" ¡Ñam, ñam! ¡Glup, glup!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I wonder what this is![K]\nIt's so yummy! Chomp chomp!", french="J'me demande c'que c'est![K]\nC'est bien fameux! Cronch miam!", german="Was ist das bloß?!?[K]\nSooo lecker!!! Schmatz! Schmatz!", italian="Chissà che cos'è![K]\nÈ deliziosa! Gnam-gnam!", spanish="¡No sé qué será esto![K]\n¡Pero está de rechupete! ¡Ñam, ñam!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 360, 240, Direction.Left, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 248, 236, false, 2)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end) -- message_SetActor(ACTOR_NPC_PERAPPU)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Oh? [CS:Y]Bidoof[CR]?[K]\nWhat are you doing here?", french="Oh? [CS:Y]Keunotor[CR]?[K]\nQu'est-ce que tu fais là?", german="Häh? [CS:Y]Bidiza[CR]?[K] Was machst du\ndenn hier?", italian="Oh? [CS:Y]Bidoof[CR]?[K]\nChe stai facendo qui?", spanish=" Anda, [CS:Y]Bidoof[CR].[K] ¿Qué haces aquí?"})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?", french=" Hé?", german=" Hmmm?", italian=" Uh?", spanish=" ¿Eh?"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 208, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh...[K] That!?", french=" Mais c'est...[K] Oh!", german=" Oh...[K] Das?!?", italian=" Oh...[K] Quella!?", spanish=" Espera...[K] ¿¡Qué es eso!?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is...[K]\nThe Guildmaster's important...", french=" C'est...[K] la précieuse...", german="Das ist...[K] Der für den\nGildenmeister so wichtige...", italian="Quella è...[K]\nLa preziosissima...", spanish="No será...[K] esa fruta que\nel Gran Bluff adora..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" P-Perfect Apple!?", french="... P-Pomme Parfaite\nde notre Maître!?", german=" P-perfekte Apfel?!?", italian=" ... Mela Perfetta del Capitano?!", spanish=" ¿¡Una... Manzana Perfecta!?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh? Perfect Apple? Golly, is\nthat what this thing here's called?", french="Hé? Pomme Parfaite, que tu\ndis? Pardi, c'est comme ça qu'on appelle ça?", german="Echt? Perfekter Apfel?\nDonnerwetter, so nennt man das also?", italian="Uh? Mela Perfetta? Ohibò,\nè così che si chiama questa cosa?", spanish="¿Eh? ¿Manzana Perfecta?\nCaramba, ¿así es como se llama?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's so tasty and impressive.\nYup yup.", french="J'trouve ça épatant et\nvachement bon, pardi!", german="So eindrucksvoll und lecker!\nJawollja.", italian="È così profumata e gustosa.\nGià già.", spanish="Pues está de vicio.\nPara chuparse los dedos... ¡Sí, señor!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- bgm2_PlayFadeIn(BGM_EATING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- SetAnimation(42) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Crunch munch! Chomp chomp![K]\nBurp...", french="Cronch miam! Cronch slurp![K]\nBurp!", german=" Stopf-schling! Schmatz![K] Rülps...", italian="Gnam-gnam! Crunch-crunch![K]\nBurp...", spanish="¡Ñam, ñam! ¡Glup, glup![K]\nAh, qué rica estaba..."})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_Close
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Thanks for the grub!", french=" Je m'suis régalé!", german=" Endlich was im Magen!", italian=" Grazie, era tutto buonissimo!", spanish=" ¡Gracias por el tentempié!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="W-wait...[K]did you seriously eat\nall of them?", french="A-attends...[K]\nTu... tu ne les as tout de même pas\ntoutes mangées?", german="W-warte...[K] Hast du wirklich\ngerade alle aufgegessen?", italian="A-Aspetta...[K] Vuoi dirmi che\nle hai mangiate tutte?", spanish="E... espera...[K] ¿En serio\nte las has comido todas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yup yup!", french=" Ben... si!", german=" Jawollja!", italian=" Già, già!", spanish=" ¡Sí, señor!"})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh! Sorry![K]\nDid you want one too, [CS:N]Chatot[CR]?", french="Oh! J'suis confus![K]\nToi aussi, t'en voulais, [CS:N]Pijako[CR]?", german="Oh! Entschuldige![K] Wolltest du\nauch einen, [CS:N]Plaudagei[CR]?", italian="Oh! Scusami! [K]\nNe volevi una anche tu, [CS:N]Chatot[CR]?", spanish="¡Huy, perdón![K] ¿Tú también querías\nuna, [CS:N]Chatot[CR]?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you would have told me,\nI would have left you one...", french="Si j'avais su, j't'en aurais\nlaissé une...", german="Wenn du etwas gesagt hättest,\nhätte ich dir einen übriggelassen...", italian="Se me l'avessi detto, te ne avrei\ntenuta una da parte...", spanish="Jo, si me lo llegas a decir antes,\nte habría dejado una..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  -- SetAnimation(33) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What...[K]what did you do...", french=" Qu'est-ce...[K] qu'est-ce que...", german=" Was...[K] Was hast du getan...", italian=" Cosa...[K] Cosa hai fatto...", spanish=" Qué...[K] ¿Qué es lo que has hecho?..."})
  -- message_KeyWait
  -- SetAnimation(20) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" WHAT DID YOU DO?!", french=" QU'EST-CE QUE TU AS FAIT?!", german=" WAS HAST DU GETAN?!?", italian=" COSA HAI FATTO?!", spanish=" ¡¿Pero qué has hecho?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Eeeeeeeek!?", french=" Aaaarrrrgh!", german=" Ieeeeeeek?!?", italian=" Aaaaaaaah!!!", spanish=" ¡Aaaaaaaaay!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Uh-oh! Was it...[K]\nGolly, did I do something wrong...", french="Oh-oh! C'était...[K]\nSapristi, j'ai fait un truc qui fallait pas...?", german="Uh-oh! Was ist denn nur...[K]\nDonnerwetter, hab ich etwas falsch gemacht?", italian="Uh oh! Ma...[K]\nOhibò, ho fatto qualcosa di male...?", spanish="Caramba... ¿Qué pasa...?[K]\nSerá que he hecho algo malo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" More than wrong!!", french=" Ah, ça tu peux le dire!", german=" Mehr als nur falsch!!!", italian=" Peggio!!!", spanish=" ¡\\\"Malo\\\" se queda corto!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If his favorite Perfect Apples\nare all gone...", french="S'il apprend que toutes ses\nPommes Parfaites ont disparu...", german="Wenn seine Perfekten Äpfel\nalle weg sind...", italian="Se ti sei sbafato tutte\nle sue Mele Perfette...", spanish="Si no queda ninguna de sus\nManzanas Perfectas..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster...[K]\nThe Guildmaster!!", french="Le Maître va...[K]\nLe Maître!!", german="Dann wird der Gildenmeister...[K]\nDer Gildenmeister!!!", italian="Il Capitano...[K]\nIl Capitano!!!", spanish=" El Gran Bluff...[K] ¡El Gran Bluff!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K]Oh no...[K]\nOOOOOOH NOOOOOOO!!", french="...[K] Oh non...[K]\nOOOOOOH NOOOOOOON!!", german="...[K]Oh nein...[K]\nOOOOOOH NEIIIIIIN!!!", italian="...[K] Oh no...[K]\nOOOOOOH NOOOOOO!!!", spanish=" No...[K] Oh, no...[K] ¡No quiero ni pensarlooo!"})
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-64), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(64), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It will be horrific!", french=" Ça va être affreux!", german=" Wie entsetzlich!", italian=" Sarà terribile!", spanish=" ¡Va a ser espeluznante!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As punishment, you'll go without\ndinner![K] Got it?!", french="Comme punition, tu seras privé\nde dîner![K] Compris?!", german="Als Bestrafung gibt es für dich\nheute kein Essen![K] Verstanden?!?", italian="Per punizione, salterai la cena![K]\nHai capito?!", spanish="Como castigo, te quedas sin\ncenar.[K] ¡¿Lo has entendido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" B-but!", french=" M-mais!", german=" A-aber!", italian=" M-Ma...", spanish=" Pe... pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] Golly, I didn't mean it...", french="Snif...[K] Pour sûr, j'pensais\npas à mal...", german="Schnüff...[K] Menschenskind,\nich hab's doch nicht so gemeint...", italian=" Sniff...[K] Ohibò, non volevo...", spanish="Buaa...[K] Vaya, pero si ha sido\nsin querer..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Sniff...[K]\n[CN]My hunger just gets me into trouble...", french="[CN]Snif...[K] C'était encore la faute de mon\n[CN]estomac, il en fait qu'à sa tête...", german="[CN]Schnüff...[K] Mein Appetit bringt mich\n[CN]immer wieder in Schwierigkeiten...", italian="[CN]Sniff...[K] Per colpa del mio stomaco\n[CN]finisco sempre nei guai...", spanish="[CN]Jo...[K]\n[CN]Mi apetito siempre me mete en líos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And I couldn't eat my favorite meal\n[CN]of the day...", french="[CN]Résultat, j'ai pu dire adieu au plat du jour,\n[CN]mon préféré par-d'ssus l'marché...", german="[CN]Und jetzt konnte ich nicht mal\n[CN]meine Lieblingsmahlzeit essen...", italian="[CN]E così non ho potuto nemmeno\n[CN]mangiare il mio piatto preferito...", spanish="[CN]Y no pude degustar mi\n[CN]comida preferida del día..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Sniff...", french="[CN]Snif...", german="[CN]Schnief...", italian="[CN]Sniff...", spanish="[CN]Buaa..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Golly, I thought I was doing my best...", french="[CN]Pardi, dès qu'je pense faire tout bon...", german="[CN]Donnerwetter, ich wollte doch\n[CN]immer mein Bestes geben...", italian="[CN]Ohibò, cerco sempre di dare il meglio...", spanish="[CN]Caramba, yo que creía\n[CN]que lo estaba haciendo bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But I always mess things up,\n[CN]every time...", french="[CN]... Paf! J'fais une nouvelle bourde,\n[CN]ça rate jamais...", german="[CN]Aber ich vermassele es immer...\n[CN]Jedes Mal...", italian="[CN]Ma non faccio che rovinare tutto,\n[CN]ogni volta...", spanish="[CN]Pero siempre la fastidio,\n[CN]sin excepción..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I guess I just don't have what it\n[CN]takes to be an explorer...", french="[CN]Faut croire qu'j'ai pas la trempe\n[CN]d'un explorateur...", german="[CN]Anscheinend fehlt mir einfach etwas,\n[CN]um ein richtiger Erkunder zu sein...", italian="[CN]Forse non ho le capacità\n[CN]per diventare un esploratore...", spanish="[CN]Supongo que no tengo lo que hay que tener\n[CN]para ser explorador..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I'll never be the best explorer...\n[CN]I just can't do it...", french="[CN]Je s'rai jamais le meilleur explorateur\n[CN]au monde... J'peux pas...", german="[CN]Ich werde nie der beste Erkunder sein...\n[CN]Ich schaffe es einfach nicht...", italian="[CN]Non diventerò mai il migliore esploratore\n[CN]del mondo. Non ho la stoffa...", spanish="[CN]Nunca voy a ser el mejor explorador.\n[CN]Es demasiado difícil..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I was really beginning to think that...", french="[CN]Du moins, c'est vraiment ce que\n[CN]je commençais à me dire...", german="[CN]Ich fing wirklich an, so zu denken...", italian="[CN]Avevo davvero cominciato a pensarlo...", spanish="[CN]Estaba empezando a darme por vencido..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But...then...", french="[CN]Puis... un jour...", german="[CN]Aber... dann...", italian="[CN]Quando...", spanish="[CN]Pero... justo entonces..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]...That...\n[CN]...That happened...", french="[CN]... l'impossible...\n[CN]s'est produit...", german="[CN]...Dann passierte...\n[CN]...Dann passierte Folgendes...", italian="[CN]... è successa...\n[CN]... una cosa...", spanish="[CN]Sucedió aquello..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
