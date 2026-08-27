-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P42A/n01a3101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- debug_Print('BIPPANONEGAIGOTO') [neutre/état moteur]
  -- back_SetGround(LEVEL_D42P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_jiraachi = SkySceneKit.spawn_npc("jirachi", 256, 192, Direction.Down, "NPC_JIRAACHI")
  -- SetAnimation(43) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Waaah!", french=" Ouaah!", german=" Donnerwetter!", italian=" Uaaah!", spanish=" ¡Aaaaah!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-what's...[K]going on?!", french=" Que... qu'est-ce qui...[K] s'passe?!", german=" W-was...[K] ist los?!?", italian=" C-Cosa...[K] succede?!", spanish=" Pero...[K] ¡¿qué está pasando?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9225) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(9226) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(90) end)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Waaaaaah!", french=" Ouaaaaaah!", german=" Donnerwetter!", italian=" Uaaaaaah!", spanish=" ¡Aaaaaah!"})
  GAME:WaitFrames(60)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:FadeIn(0)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- GAP: se_Play(9227) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Hah![K] All right, I'm fully awake!", french=" Ha![K] Enfin, je suis réveillé!", german=" Oha![K] Jetzt bin ich aufgewacht!", italian="Ah![K] Bene, ora sono\ncompletamente sveglio!", spanish=" ¡Ah![K] ¡Bueno, ya estoy despierto!"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" So, so awake! Ahhh!", french=" Bel et bien réveillé! Aaah!", german="Streck... Und reck...\nSo wach! Aaah!", italian=" Sveglio e pimpante! Aaah!", spanish=" Sí, sí, despejado del todo. ¡Aaah!"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="My name is [CS:N]Jirachi[CR].[K]\nUm...[K] Who are you?", french="Je m'appelle [CS:N]Jirachi[CR].[K]\nMmh... [K]Et toi, qui es-tu?", german="Mein Name ist [CS:N]Jirachi[CR].[K]\nÖhm...[K] Und wer bist du?", italian="Il mio nome è [CS:N]Jirachi[CR].[K]\nUhm...[K] Tu chi sei?", spanish="Me llamo [CS:N]Jirachi[CR].[K]\nHum...[K] ¿Quién eres tú?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm [CS:Y]Bidoof[CR].[K] (Golly, how many\ntimes do I need to tell him?)", french="J'suis [CS:Y]Keunotor[CR].[K]\n(Sapristi, faut lui répéter combien de fois?)", german="Ich bin [CS:Y]Bidiza[CR].[K] (Donnerwetter,\nwie oft soll ich ihm das denn noch sagen?)", italian="Mi chiamo [CS:Y]Bidoof[CR].[K]\n(Ohibò, quante volte ancora dovrò\nripeterglielo perché se lo ricordi...?)", spanish="Soy [CS:Y]Bidoof[CR].[K] (No sé yo, su problemilla\nde memoria empieza a escamarme.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Your name is [CS:Y]Bidoof[CR].", french=" Ton nom est [CS:Y]Keunotor[CR].", german=" Dein Name ist [CS:Y]Bidiza[CR].", italian=" Il tuo nome è [CS:Y]Bidoof[CR].", spanish=" Te llamas [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="So, [CS:Y]Bidoof[CR].[K]\nYou better listen well.", french="Soit, [CS:Y]Keunotor[CR].[K]\nOuvre bien grand tes oreilles.", german="Nun gut, [CS:Y]Bidiza[CR].[K]\nHör mir genau zu.", italian="Ok, [CS:Y]Bidoof[CR].[K]\nApri bene le orecchie.", spanish="Bueno, [CS:Y]Bidoof[CR].[K] Será mejor que\nme escuches atentamente."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="I grant wishes for those who\nmanage to wake me up.", french="J'accorde un vœu à quiconque\nest capable de me réveiller.", german="Ich erfülle jenen einen Wunsch,\ndie es schaffen, mich aufzuwecken.", italian="Io esaudisco i desideri di chi\nriesce a risvegliarmi.", spanish="Concedo deseos a quienes logran\ndespertarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Waah! All of a sudden!", french="Ouaah! Tu m'prends\nde court, là!", german=" Waaaah! So plötzlich!", italian=" Uaaah! Ci siamo!", spanish=" ¡Aah! De repente..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I'm not ready for this yet...!", french="J-je suis pas encore prêt\npour ça...!", german="I-ich fühl mich gerade gar nicht\nmehr bereit dafür...", italian=" M-Ma non sono ancora pronto...!", spanish=" Siento que aún no estoy listo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Ahem...[K] All right, I'll listen.", french=" Hum...[K] Très bien, je t'écoute.", german=" Ähem...[K] Nun gut, ich höre.", italian=" Ehm...[K] D'accordo, ti ascolto.", spanish=" Ejem...[K] De acuerdo, te escucho."})
  -- message_KeyWait
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" What is your wish, [CS:Y]Bidoof[CR]?", french=" Quel est ton vœu, [CS:Y]Keunotor[CR]?", german=" Wie lautet dein Wunsch, [CS:Y]Bidiza[CR]?", italian=" Che cosa desideri, [CS:Y]Bidoof[CR]?", spanish=" ¿Cuál es tu deseo, [CS:Y]Bidoof[CR]?"})
  -- @label_9 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-my wish...", french=" M-mon vœu...", german=" M-mein Wunsch...", italian=" I-Il mio desiderio...", spanish=" Mi... Mi deseo..."})
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_BIPPA)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My wish is...[K] Ummmm...[K]\nUuuuummmm...", french="Mon vœu c'est...[K] Heuuuu...[K]\nMmmmmh...", german="Mein Wunsch lautet...[K] Hmmmm...[K]\nIch möchte...", italian="Il mio desiderio è...[K] Mmm...[K]\nMmmmmmh...", spanish="Mi deseo es...[K] Huuum...[K]\nHuuuuum..."})
  do local __choice = SkySceneKit.ask({{english="To become rich!", french="Devenir riche!", german="reich sein!", italian="Diventare ricco!", spanish="¡Ser rico!"}, {english="To be the strongest Pokémon!", french="Etre le plus fort des Pokémon!", german="das stärkste Pokémon sein!", italian="Diventare il Pokémon più forte!", spanish="¡Ser el Pokémon más fuerte!"}, {english="To be the best explorer!", french="Etre le plus grand explorateur!", german="der beste Erkunder sein!", italian="Diventare il miglior esploratore!", spanish="¡Ser el mejor explorador!"}, {english="To eat lots of yummy food!", french="Manger plein de bonnes choses!", german="ein Festmahl verspeisen!", italian="Mangiare del cibo delizioso!", spanish="¡Tener mucha comida deliciosa!"}, {english="To sleep well...", french="Dormir comme un bébé la nuit...", german="gut schlafen...", italian="Dormire bene...", spanish="Dormir bien..."}, {english="To get lots of items!", french="Recevoir des tas d'objets!", german="eine Menge Items erhalten!", italian="Ottenere tantissimi strumenti!", spanish="¡Obtener montones de objetos!"}, {english="To rule the world!", french="Devenir le maître du monde!", german="die Welt regieren!", italian="Dominare il mondo!", spanish="¡Dominar el mundo!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To be the strongest Pokémon!\n[CN]Is this truly what you want?", french="[CN]Etre le plus fort des Pokémon!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Das stärkste Pokémon sein!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Diventare il Pokémon più forte!\n[CN]È questo ciò che desideri?", spanish="[CN]Ser el Pokémon más fuerte.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To be the best explorer!\n[CN]Is this truly what you want?", french="[CN]Etre le plus grand explorateur!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Der beste Erkunder sein!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Diventare il miglior esploratore!\n[CN]È questo ciò che desideri?", spanish="[CN]Ser el mejor explorador.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To eat lots of yummy food!\n[CN]Is this truly what you want?", french="[CN]Manger plein de bonnes choses!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Ein Festmahl verspeisen!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Mangiare del cibo delizioso!\n[CN]È questo ciò che desideri?", spanish="[CN]Tener mucha comida deliciosa.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 5 -- $EVENT_LOCAL = 5 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To sleep well!\n[CN]Is this truly what you want?", french="[CN]Dormir comme un bébé la nuit!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Gut schlafen!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Dormire bene!\n[CN]È questo ciò che desideri?", spanish="[CN]Dormir bien.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 6 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 6 -- $EVENT_LOCAL = 6 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To get lots of items!\n[CN]Is this truly what you want?", french="[CN]Recevoir des tas d'objets!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Eine Menge Items erhalten!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Ottenere tantissimi strumenti!\n[CN]È questo ciò che desideri?", spanish="[CN]Obtener montones de objetos.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 7 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 7 -- $EVENT_LOCAL = 7 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To rule the world!\n[CN]Is this truly what you want?", french="[CN]Devenir le maître du monde!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Die Welt regieren!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Dominare il mondo!\n[CN]È questo ciò che desideri?", spanish="[CN]Dominar el mundo.\n[CN]¿Es lo que quieres de verdad?"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To become rich!\n[CN]Is this truly what you want?", french="[CN]Devenir riche!\n[CN]Est-ce vraiment là ce que tu désires?", german="[CN]Reich sein!\n[CN]Ist das wirklich, was du willst?", italian="[CN]Diventare ricco!\n[CN]È questo ciò che desideri?", spanish="[CN]Ser rico.\n[CN]¿Es lo que quieres de verdad?"})
  -- @label_7 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Are you absolutely sure this is what you want?", french="[CN]Tu es vraiment sûr que c'est ce que tu veux?", german="[CN]Bist du dir absolut sicher, dass du das willst?", italian="[CN]Sei davvero sicuro che sia questo\n[CN]il tuo desiderio?", spanish="[CN]¿Seguro que eso es lo que quieres?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  end
  end
  end
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 2 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To be the strongest Pokémon...!)", french=".........\n(Etre le plus fort des Pokémon...!)", german="..........\n(Das stärkste Pokémon sein...)", italian="..........\n(Diventare il Pokémon più forte...!)", spanish=" (Ser el Pokémon más fuerte...)"})
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (That's right.)", french=" ... (Tout juste.)", german=" ...(Ganz genau.)", italian=" ... (Sì.)", spanish=" Hum... (Eso es.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (My dream...[K] It was...)", french=" (Mon rêve...[K] c'était...)", german=" (Mein Traum...[K] Das war doch...)", italian=" (Il mio sogno...[K] era...)", spanish=" (Mi sueño...[K] era...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(To become the best explorer\never, yup yup.)", french="(De devenir le plus grand\nexplorateur d'tous les temps, pardi.)", german="(Ich will der beste Erkunder\nüberhaupt werden, jawollja.)", italian="(... diventare il miglior\nesploratore che sia mai esistito, già, già.)", spanish="(Convertirme en el mejor\nexplorador que haya existido, sí, señor.)"})
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To eat lots of yummy food...!)", french=".........\n(Manger plein de bonnes choses...!)", german="..........\n(Ein Festmahl verspeisen...)", italian=".........\n(Mangiare del cibo delizioso...!)", spanish=" (Tener mucha comida deliciosa...)"})
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To sleep well...)", french=".........\n(Dormir comme un bébé la nuit...)", german="..........\n(Gut schlafen...)", italian="..........\n(Dormire bene...)", spanish=" (Dormir bien...)"})
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To get lots of items...!)", french=".........\n(Recevoir des tas d'objets...!)", german="..........\n(Eine Menge Items erhalten...)", italian="..........\n(Ottenere tantissimi strumenti...!)", spanish=" (Obtener montones de objetos...)"})
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To rule the world...!)", french=".........\n(Devenir le maître du monde...!)", german="..........\n(Die Welt regieren...)", italian="..........\n(Dominare il mondo...!)", spanish=" (Dominar el mundo...)"})
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=".........\n(To become rich...!)", french=".........\n(Devenir riche...!)", german="..........\n(Reich sein...)", italian="..........\n(Diventare ricco...!)", spanish=" (Ser rico...)"})
  -- @label_18 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Th-that's[K] a really nice wish\nand all...)", french="(C'est...[K] un chouette vœu\net tout...)", german="(D-das ist[K] ein wirklich schöner\nWunsch...)", italian="(È-È...[K] sicuramente un gran\nbel desiderio, non c'è che dire...)", spanish="(La verdad es que...[K] es un deseo\nmuy chulo y tal...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (But...)", french=" (Mais...)", german=" (Aber...)", italian=" (Ma...)", spanish=" (Pero...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (But my dream...)", french=" (Mais mon rêve à moi...)", german=" (Aber mein Traum...)", italian=" (Ma il mio sogno...)", spanish=" (Pero mi sueño...)"})
  -- @label_19 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jiraachi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Huh?[K] Something wrong?", french=" Hein?[K] Un problème?", german=" Wie bitte?[K] Stimmt etwas nicht?", italian=" Uh?[K] Va tutto bene?", spanish=" ¿Eh?[K] ¿Ocurre algo?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" What's your wish, [CS:Y]Bidoof[CR]?", french=" Quel est ton vœu, [CS:Y]Keunotor[CR]?", german=" Wie lautet dein Wunsch, [CS:Y]Bidiza[CR]?", italian=" Qual è il tuo desiderio, [CS:Y]Bidoof[CR]?", spanish=" ¿Cuál es tu deseo, [CS:Y]Bidoof[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jiraachi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Something wrong?[K] You don't\nhave a wish?", french="Il y a un problème?[K] Tu ne veux\npas formuler de vœu?", german="Stimmt etwas nicht?[K] Hast du\nkeinen Wunsch?", italian="C'è qualcosa che non va?[K]\nNon hai nessun desiderio?", spanish="¿Sucede algo?[K] ¿No tienes\nningún deseo que pedirme?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-my[K] dream...", french=" M-mon[K] rêve...", german=" M-mein[K] Traum...", italian=" I-Il mio[K] sogno...", spanish=" Mi... Mi[K] sueño..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Is to become the best explorer\never, yup yup.", french="... c'est de devenir le plus grand\nexplorateur d'tous les temps, pardi.", german="Mein Traum ist es, der beste\nErkunder überhaupt zu werden, jawollja.", italian="... è diventare il miglior\nesploratore che sia mai esistito, già, già.", spanish="Es convertirme en el mejor\nexplorador que haya existido, sí, señor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="The best explorer?[K] Got it.[K]\nThat's pretty easy! ♪", french="Le plus grand explorateur?[K] Soit.[K]\nRien de plus simple! ♪", german="Der beste Erkunder?[K] Ach so.[K]\nDas ist doch ziemlich einfach! ♪", italian="Il miglior esploratore?[K] Va bene.[K]\nNon c'è nessun problema! ♪", spanish="¿El mejor explorador?[K] Entendido.[K]\n¡Qué fácil! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" OK, here we go! ♪", french=" D'accord, c'est parti! ♪", german=" Okay, also los! ♪", italian=" Ok, cominciamo! ♪", spanish=" Bueno, ¡pues allá vamos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Uwaaaah![K] W-wait[K]\na moment, please!", french="Ho-holà![K] A-attends[K]\nune seconde, s'il te plaît!", german="Uaaarrr![K] W-warte![K]\n...Einen Augenblick, bitte!", italian="Uaaah![K] A-Aspetta![K]\nDammi un momento, per favore!", spanish="¡Aaaah![K] Es... espera...[K]\n¡Un momento, por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Huh?[K] What is it?", french=" Hein?[K] Qu'y a-t-il?", german=" Bitte?[K] Was ist los?", italian=" Uh?[K] Che succede?", spanish=" ¿Eh?[K] ¿Qué ocurre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Golly, well, my dream is to\nbecome the best explorer ever, that's true...", french="Sapristi, ben, mon rêve, c'est de\ndevenir le meilleur explorateur d'tous les\ntemps, c'est vrai...", german="Donnerwetter, ja, mein Traum\nist es, der beste Erkunder überhaupt zu\nwerden, das stimmt schon...", italian="Ohibò... Beh, il mio sogno\nè diventare il miglior esploratore\nche ci sia, lo ammetto...", spanish="Caramba, es cierto que mi sueño\nes ser el mejor explorador del mundo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="At first I thought I'd come down\nhere and ask you for that, yup yup.", french="Au début, j'pensais venir ici\npour te d'mander ça, ouaip.", german="Ich dachte eigentlich, ich komme\nhier zu dir und frage dich danach, jawollja.", italian="All'inizio pensavo di venire a\nchiederti di esaudire il mio desiderio,\ngià, già.", spanish="Y tenía claro que quería venir\na pedírtelo, sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" B-but[K] I'm giving up on that plan.", french=" M-mais...[K] j'ai changé d'avis.", german="A-aber[K] ich habe mich\numentschieden.", italian=" M-Ma...[K] ora ci rinuncio.", spanish=" Pe... pero...[K] he cambiado de idea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jiraachi, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Truly?[K] Why?", french=" Vraiment?[K] Pour quelle raison?", german=" Im Ernst?[K] Warum?", italian=" Davvero?[K] E perché?", spanish=" ¿De verdad?[K] ¿Por qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Because...", french=" Pasque...", german=" Weil...", italian=" Perché...", spanish=" Porque..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Because I've come to see it's not\nsomething you can wish for, by golly.", french="Pasque j'ai compris qu'c'est\npas un truc qu'il suffit de souhaiter\ncomme ça, ma foi.", german="Weil ich gelernt habe, dass man\nsich so etwas nicht einfach wünschen kann,\nzum Donnerwetter!", italian="Perché ho capito che non\nè possibile chiedere a qualcun altro\ndi far avverare i tuoi sogni, ohibò.", spanish="Porque me he dado cuenta de que\nno es algo que se pueda cumplir por las buenas."})
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You've got to work hard...[K] Once\nyou've really done your best...put in the effort,\nthen you can feel like a worthy explorer.", french="Y faut travailler dur...[K] Quand on\na vraiment fait d'son mieux... transpiré\ncomme y faut, alors on peut être fier.", german="Dafür muss man hart arbeiten...[K]\nUnd wenn man alles gegeben und Herzblut\nreingesteckt hat, ist man ein wahrer Erkunder.", italian="Bisogna lavorare sodo...[K] E quando\nhai fatto del tuo meglio e dato il massimo,\nallora puoi dire di essere un vero esploratore.", spanish="Hay que trabajar duro...[K] Cuando\nlo haya dado todo... sentiré que soy\nun buen explorador."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You gotta have lots of\nexperiences...[K]lots of feelings and memories...", french="Ça d'mande un paquet\nd'expérience...[K] des impressions, des souv'nirs...", german="Aber man muss Erfahrung\nsammeln...[K] Gefühle und Erinnerungen...", italian="Devi fare tanta esperienza...[K]\nGioire dei tuoi successi, ma anche fare\ni conti con le sconfitte...", spanish="Hay que pasar por muchas\nexperiencias...[K] Y por todos los sentimientos\ny recuerdos que estas nos dejan..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Those are the ways you learn,\ngrow, and get better, little by little. Yup yup.", french="C'est comme ça qu'on apprend,\nqu'on grandit et qu'on d'vient meilleur. Ouaip.", german="Genau so lernt man. Mit den\nAufgaben wachsen, Stück für Stück. Jawollja.", italian="Solo in questo modo si può\nimparare, crescere e migliorarsi poco\na poco. Già, già.", spanish="Así es como se aprende, se crece\ny se mejora... Poco a poco. Sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yes sirree, I got a lot clearer on\nall this stuff during this adventure.", french="Oui, m'sieur, toute cette\naventure m'a permis d'apprendre\nun tas d'choses.", german="Jawoll, das ist mir alles\nwährend dieser Erkundung hier klar geworden.", italian="Sissignore, questa avventura\nmi ha fatto capire ciò che è davvero\nimportante.", spanish="Pues sí, me he ido dando cuenta\nde todo esto a lo largo de mi aventura."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So my wish to be the best\nexplorer ever...", french="Du coup, mon rêve de devenir\nle meilleur explorateur d'tous les temps...", german="Der beste Erkunder aller Zeiten\nzu werden...", italian="Quindi il mio desiderio di\ndiventare il miglior esploratore che\nsia mai esistito...", spanish="Así que mi deseo de ser\nel mejor explorador que haya existido..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Jirachi[CR]...[K] I'm not asking you for\nthat anymore.", french="[CS:N]Jirachi[CR]...[K] C'est plus ça que\nj'veux te demander.", german="Dieser Wunsch[K] kann nicht einfach\nvon dir erfüllt werden, [CS:N]Jirachi[CR].", italian="... puoi dimenticarlo, [CS:N]Jirachi[CR]...[K]\nNon te lo chiederò più.", spanish=" [CS:N]Jirachi[CR]...[K] Ya no voy a pedírtelo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" ...[K]I see...", french=" ...[K] Je vois...", german=" ...[K]Verstehe...", italian=" ...[K] Capisco...", spanish=" Hum...[K] Entiendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Well spoken. So you don't have\nany wishes?", french="Bien parlé. Alors tu n'as pas\nd'autre vœu à formuler?", german=" Wahre Worte.", italian="È un modo di parlare molto\nsaggio.", spanish="Bien dicho. Entonces, ¿no tienes\nningún otro deseo?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="What you've just said...[K] It shows\nsomething about you. Not everyone can resist\nbeing greedy.", french="Ce que tu viens de dire...[K]\nÇa en dit long sur toi. Il n'est pas donné à\ntout le monde de résister à la cupidité.", german="Was du gerade gesagt hast,[K]\nsagt auch etwas über deinen Charakter aus.\nNicht jeder kann der Verlockung widerstehen.", italian="Le tue parole...[K] sono lo specchio\ndel tuo buon cuore. Troppo spesso la gente\nè preda dell'avidità.", spanish="Lo que acabas de contarme...[K]\ndice mucho de ti. No todo el mundo puede\nresistirse a ser avaricioso."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="You're a good Pokémon, [CS:Y]Bidoof[CR].[K]\nI've come to like you.", french="Tu es un bon Pokémon, [CS:Y]Keunotor[CR].[K]\nJe t'apprécie beaucoup.", german="Du bist ein gutes Pokémon,\n[CS:Y]Bidiza[CR].[K] Ich fange an, dich zu mögen.", italian="Sei un bravo Pokémon, [CS:Y]Bidoof[CR].[K]\nSono fiero di te.", spanish="Eres un buen Pokémon, [CS:Y]Bidoof[CR].[K]\nLa verdad es que me caes bien."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="So, if you don't have a wish\nright now...", french="Donc, si tu n'as pas d'autre\nvœu à formuler...", german="Also, wenn du zurzeit keinen\nweiteren Wunsch hast...", italian="Quindi, se non hai desideri\nda esprimere...", spanish="Bueno, si no tienes ningún deseo\nque pedirme ahora..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh![K] ...W-wait[K] just a moment,\nplease! Yup yup!", french="Holà![K] ... Mi-minute.[K]\nUn p'tit instant, s'il te plaît, pardi!", german="Oh![K] ...W-warte![K] Einen\nAugenblick, bitte! Jawollja!", italian="Oh![K] A-Aspetta...[K] Solo un attimo\nper favore! Già, già!", spanish="¡Oye![K] Es... espera...[K] un momento,\npor favor. ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" What is it?", french=" Qu'y a-t-il?", german=" Ja, bitte?", italian=" Cosa c'è?", spanish=" ¿Qué ocurre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You just said a nice thing about\nme not being greedy, [CS:N]Jirachi[CR]...[K]\nSo maybe I shouldn't ask...", french="Tu viens de dire un truc sympa\nsur l'fait que j'étais pas cupide, [CS:N]Jirachi[CR]...[K]\nAlors p'tête qu'y faudrait pas que j'demande...", german="Du hast gerade so nett\nausgedrückt, wie bescheiden ich sei, [CS:N]Jirachi[CR]...[K]\nDaher sollte ich vielleicht nicht fragen...", italian="Hai appena detto che non sono\navido e questo è molto bello da parte tua,\n[CS:N]Jirachi[CR]...[K] Quindi forse non dovrei chiedertelo...", spanish="Acabas de decir que no soy\navaricioso y que eso es bueno, [CS:N]Jirachi[CR]...[K]\nAsí que igual hago mal en pedírtelo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" It's all right.[K] Go ahead.", french=" Aucun souci.[K] Je t'écoute.", german=" Das ist schon okay.[K] Fahre fort.", italian=" Non ti preoccupare.[K] Dimmi pure.", spanish=" Tranquilo.[K] Continúa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If...[K]you'll still grant me\na wish...", french="Si...[K] t'es encore d'accord pour\nm'exaucer un vœu...", german="Wenn...[K] du mir immer noch\neinen Wunsch erfüllen könntest...", italian="Se...[K] potessi ancora esaudire\nun mio desiderio...", spanish="Si...[K] todavía puedes concederme\nun deseo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I...I wish...", french=" Je... je souhaite...", german=" D-dann wünsche ich mir...", italian=" V-Vorrei...", spanish=" De... deseo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I wish...[K] I wish for a buddy who\nI could teach stuff to.", french="Je souhaite...[K] qu'il y ait de\nnouvelles recrues à qui j'pourrais enseigner\ndes trucs à mon tour...", german="Ich hätte...[K] Ich hätte so gerne\neinen Freund, dem ich Dinge beibringen kann.", italian="Vorrei...[K] dei compagni a cui\ninsegnare qualcosa sulle esplorazioni.", spanish="Me gustaría...[K] tener algún compi\nal que pudiera enseñarle cosillas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="A buddy?[K] You're training\nat the guild, aren't you, [CS:Y]Bidoof[CR]?", french="De nouvelles recrues?[K] Tu\nt'entraînes à la Guilde, [CS:Y]Keunotor[CR], n'est-ce pas?", german="Einen Freund?[K] Du trainierst doch\nin der Gilde, nicht wahr, [CS:Y]Bidiza[CR]?", italian="Dei compagni?[K] Tu sei\nun apprendista della Gilda, non è vero,\n[CS:Y]Bidoof[CR]?", spanish="¿Un compañero?[K] Te entrenas en\nel [CS:N]Pokégremio[CR], ¿no, [CS:Y]Bidoof[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="So...you want a buddy, [CS:Y]Bidoof[CR]?\nSomeone you can show around and give a\nhelping hand to?", french="Donc... tu souhaites l'arrivée de\nnouvelles recrues, [CS:Y]Keunotor[CR], pour pouvoir\nleur faire découvrir la Guilde et les soutenir?", german="Also... Du möchtest einen\nFreund, [CS:Y]Bidiza[CR]? Einen, dem du alles zeigen\nkannst, den du unterstützt und anweist?", italian="Quindi... vorresti avere qualcuno\ncon cui andare in giro e a cui offrire il\ntuo aiuto? È così, [CS:Y]Bidoof[CR]?", spanish="Así que... ¿quieres algún\ncompañero, [CS:Y]Bidoof[CR]? ¿Alguien al que echar\nuna mano y enseñar dónde está todo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's right.[K]\nDuring this adventure, I...", french="C'est ça.[K]\nPendant cette aventure, j'ai...", german="Ganz genau.[K]\nDas wurde mir auf diesem Abenteuer klar...", italian="Esatto.[K]\nDurante questa avventura, io...", spanish="Exacto.[K]\nDurante esta aventura..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Golly, thanks to the Guildmaster\nand everyone in the guild caring about me...[K]\nI feel so incredibly happy. Yup!", french="Sapristi, grâce aux attentions\ndu Maître et des aut' à mon égard...[K]\nje m'sens vachement heureux. Ouaip ouaip!", german="Donnerwetter. Dass alle meine\nFreunde aus der Gilde sich so gekümmert\nhaben,[K] macht mich überglücklich. Jawollja!", italian="Ohibò, grazie al Capitano e ai\nmiei amici della Gilda che si preoccupano\nsempre di me...[K] mi sento così felice. Già!", spanish="Caramba, saber que el Gran\nBluff y todos los del [CS:N]Pokégremio[CR] se preocupan\npor mí...[K] me ha hecho muy feliz."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] I don't want to get\nused to it and start acting spoiled or anything.", french="Mais...[K] j'veux pas m'habituer à\ndépendre des autres et commencer\nà jouer les enfants gâtés...", german="Aber...[K] Ich möchte mich nicht\ndaran gewöhnen und verwöhnt erscheinen.", italian="Ma...[K] non voglio finire\nper approfittarmi della loro bontà.", spanish="Pero...[K] No quiero acostumbrarme\ny portarme como un mimado ni nada de eso."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That's why...", french=" C'est pour ça...", german=" Deswegen...", italian=" Ecco perché...", spanish=" Por eso..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's the reason I'd like a pal\nor two.", french="C'est pour ça qu'j'aimerais\nm'occuper d'un novice ou deux.", german="Deswegen hätte ich gerne selbst\neinen oder zwei Freunde.", italian="... vorrei tanto avere\nun compagno o due.", spanish="Esa es la razón de que quiera\nun compi... o dos."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I had a buddy...[K] A pal\nI could share what I learned with, I'd...", french="Aider de nouveaux camarades...[K]\nLeur apprendre c'que j'sais...", german="Wenn ich einen Partner hätte...[K]\nEinen Freund, mit dem ich alles teilen könnte,\nwas ich gelernt habe, dann...", italian="Se avessi qualcuno...[K] con cui\ncondividere le mie conoscenze...", spanish="Si lo tuviera...[K] Alguien con quien\ncompartir todo lo que he aprendido..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Get better and better as I\npush forward, know what I mean?", french="Ça m'permettrait de m'améliorer\nen même temps...", german="Dann würde ich besser und\nbesser werden, da es mich anspornen würde.\nVerstehst du?", italian="... anch'io potrei migliorare\nsempre di più. Capisci ciò che intendo?", spanish="Seguro que mejoraría con cada\npaso que diera. No sé si me explico."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" ...[K]Yes.[K] Got it.", french=" ...[K] Oui.[K] Je comprends.", german=" ...[K]Ja.[K] Ich verstehe.", italian=" ...[K] Sì.[K] Ti capisco.", spanish=" Hum...[K] Sí.[K] Lo entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Your wish, [CS:Y]Bidoof[CR]...[K]\nI will make it come true.", french="Ton souhait, [CS:Y]Keunotor[CR]...[K]\nje vais le réaliser.", german="Deinen Wunsch, [CS:Y]Bidiza[CR]...[K]\nIch werde ihn erfüllen.", italian="Se questo è il tuo desiderio,\n[CS:Y]Bidoof[CR]...[K] io lo esaudirò.", spanish="Lo que me pides, [CS:Y]Bidoof[CR]...[K]\nHaré que se convierta en realidad."})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" R-really?!", french=" V-vraiment?!", german=" W-wirklich?!?", italian=" S-Sul serio?!", spanish=" ¡¿En... En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Yep. ♪[K] Maybe it won't\nbe soon...", french="Oui. ♪[K] Ce ne sera\npeut-être pas pour demain...", german="Ja. ♪[K] Vielleicht nicht\nallzu bald...", italian=" Certo. ♪[K] Magari non subito...", spanish=" Sí. ♪[K] No sé si será dentro de poco..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="But sooner or later, you'll see\nsome new faces at the guild.", french="Mais dans un avenir proche,\ntu verras arriver de nouvelles recrues\nà la Guilde.", german="Aber früher oder später wirst\ndu in der Gilde neue Gesichter sehen.", italian="... ma prima o poi vedrai delle\nfacce nuove alla Gilda.", spanish="Pero tarde o temprano verás\ncaras nuevas en el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="You should look forward\nto it. ♪", french="Guette attentivement\nce moment. ♪", german=" Freu dich darauf. ♪", italian=" Devi solo pazientare un po'. ♪", spanish="Así que ya tienes\nuna nueva ilusión. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Thank you...[K][CS:N]Jirachi[CR]...", french=" Merci...[K] [CS:N]Jirachi[CR]...", german=" Vielen Dank,[K] [CS:N]Jirachi[CR]...", italian=" Grazie...[K] [CS:N]Jirachi[CR]...", spanish=" Gracias...[K] [CS:N]Jirachi[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Thank you so much...[K]\nSniff...", french="Merci du fond du cœur...[K]\nSnif...", german="Ich danke dir so sehr...[K]\nSchnüff...", italian=" Grazie mille...[K] Sniff...", spanish="Muchísimas gracias...[K]\nSnif..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(240) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  end
  end
  SkySceneKit.cleanup_npcs()
end
