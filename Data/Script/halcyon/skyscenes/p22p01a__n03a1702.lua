-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P22P01A/n03a1702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=11} -- $SCENARIO_SIDE = scn[42,11] (ROM)
  -- back_SetGround(LEVEL_P22P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 188, 140, false, 2)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 224, 288, Direction.Up, "NPC_AAMARUDO")
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Uwaaaahhh. ♪", french=" Ouaaaaaaah. ♪", german=" Uwaaaah. ♪", italian=" Uaaaaaahhh. ♪", spanish=" ¡Anda! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, Master.[K] This is outside. ♪", french="Hé, Maître.[K]\nOn est à l'extérieur. ♪", german="Hey, Meister.[K]\nWir sind draußen. ♪", italian="Ehi, maestro.[K]\nSiamo all'esterno. ♪", spanish=" Eh, maestro.[K] Estamos fuera. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It looks like once you leave the\nravine, it connects to this place.", french="On dirait que le ravin mène à\ncet endroit.", german="Anscheinend gelangt man an\ndiesen Ort, wenn man die Schlucht verlässt.", italian="A quanto pare la gola è collegata\na questo posto.", spanish="Parece que en cuanto se sale\ndel risco se llega a este lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Among the rocks and stones...[K]\nI can see some crumbled pillars and what\nlooks like a stone wall.", french="Au milieu des pierres et des\nrochers...[K] je vois des piliers écroulés\net un mur, on dirait.", german="Bei den Felsen und Steinen...[K]\nIch erkenne da verwitterte Säulen und etwas,\ndas wie eine steinerne Mauer aussieht.", italian="In mezzo a tutte queste rocce...[K]\nscorgo delle colonne crollate e quello che\nsembra un muro di pietra.", spanish="Entre las rocas y las piedras...[K]\nveo unas columnas derruidas y lo que parece\nser un muro de piedra."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Don't tell me that this is...", french=" Ne me dis pas que c'est...", german=" Sag bloß... Kann das wirklich...", italian=" Non è possibile! Che questa sia...", spanish=" No me digas que esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh! Master!", french=" Oh! Maître!", german=" Oh! Meister!", italian=" Oh! Maestro!", spanish=" ¡Eh, maestro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Look over there!", french=" Regardez par là-bas!", german=" Schau! Dort drüben!", italian=" Guarda laggiù!", spanish=" ¡Mira eso!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V33P01A) [décor sub chargé: Sub_v33p01a]
  -- camera2_SetPositionMark(Position<'m2', 16, 23.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(1)
  -- camera2_MovePositionMark(0.5, Position<'m3', 16, 14.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- GAP: se_Play(9736) — id SE NDS sans portage PMDO identifié
  SkySubScreen.Show("v33p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(4) -- WaitMoveCamera2 (join caméra sub NDS: canal unique PMDO documenté)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I can see some kind of ruins off\nin the distance...", french=" J'aperçois des ruines au loin...", german="Ich kann dort in der Ferne\nschemenhaft Ruinen erkennen...", italian="Mi pare di vedere delle rovine\nin lontananza...", spanish="Veo una especie de ruinas allá,\na lo lejos..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I knew it. This is...[K]an ancient\ncity that's been buried by time, I believe.", french="Je le savais. C'est sûrement...[K]\nune cité antique ensevelie par les siècles.", german="Ich wusste es![K] Das hier ist\neine uralte Stadt, die von der Zeit begraben\nwurde. Oder so ähnlich.", italian="Lo sapevo. Questa è...[K] un'antica\ncittà dimenticata... penso.", spanish="Lo sabía. Esto es...[K] una antigua\nciudad enterrada en el tiempo, según creo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, Master!", french=" Hé, Maître!", german=" Hey, Meister!", italian=" Ehi, maestro!", spanish=" ¡Oye, maestro!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I bet there's a bunch of treasure\nover there. ♪", french="Je parie qu'il y a un tas de\ntrésors par là-bas. ♪", german="Ich wette, dort drüben gibt es\neine Menge Schätze. ♪", italian="Scommetto che ci sono un sacco\ndi tesori laggiù. ♪", spanish="Seguro que por ahí hay\nun montón de tesoros. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hurry, let's go! ♪\nSo excited! ♪", french="Vite, allons-y! ♪\nC'est génial! ♪", german="Schnell, wir müssen dorthin! ♪\nIch bin so aufgeregt! ♪", italian="Forza, andiamo! ♪\nSono così emozionato! ♪", spanish="¡Venga, deprisa! ♪\n¡Jo, qué nervios! ♪"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Oh.", french=" Oh.", german=" Oh.", italian=" Oh.", spanish="Hasta yo, con toda mi experiencia,\nestoy ligeramente inquieto..."})
  -- message_Close
  GROUND:MoveToPosition(hero, 188, 132, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Wait!", french=" On ne bouge plus!", german=" Wartet!", italian=" Fermi!", spanish=" ¡Alto ahí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() GAME:MoveCamera(204, 204, 60, false) end) -- performer/caméra
  local npc_npc_nidokingu = SkySceneKit.spawn_npc("nidoking", 208, 256, Direction.Up, "NPC_NIDOKINGU")
  GROUND:MoveToPosition(npc_npc_nidokingu, 204, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" I've finally found you,[K] [CS:N]Armaldo[CR]!", french="J'ai fini par te retrouver,\n[K][CS:N]Armaldo[CR]!", german="Habe ich dich endlich gefunden,[K]\n[CS:N]Armaldo[CR]!", italian="Finalmente ti ho trovato,[K]\n[CS:N]Armaldo[CR]!", spanish=" ¡Por fin te encuentro...[K] [CS:N]Armaldo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="My name is [CS:N]Nidoking[CR]![K]\nI'm an explorer!", french="Mon nom est [CS:N]Nidoking[CR]![K]\nJe suis explorateur!", german="Ich bin [CS:N]Nidoking[CR]![K]\nIch bin ein Erkunder!", italian="Mi chiamo [CS:N]Nidoking[CR]![K]\nSono un esploratore!", spanish=" Me llamo [CS:N]Nidoking[CR].[K] Soy un explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What...[K] What did you say?", french=" Que...[K] que dis-tu?", german="Was...[K]\nWas hast du gerade gesagt?", italian=" Cosa...[K] Cosa hai detto?", spanish=" Qué...[K] ¿Qué has dicho?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 176, 328, Direction.Up, "NPC_PUKURIN_PAPA")
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 172, 208, false, 2)
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 160, 328, Direction.Up, "NPC_PUKURIN_MAMA")
  GROUND:MoveToPosition(npc_npc_pukurin_mama, 156, 208, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 240, 328, Direction.Up, "NPC_JIBAKOIRU")
  GROUND:MoveToPosition(npc_npc_jibakoiru, 236, 200, false, 2)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 224, 344, Direction.Up, "NPC_KOIRU")
  GROUND:MoveToPosition(npc_npc_koiru, 220, 216, false, 2)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 256, 344, Direction.Up, "NPC_KOIRU2")
  GROUND:MoveToPosition(npc_npc_koiru2, 252, 216, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 136, 344, Direction.Up, "NPC_UPAA")
  GROUND:MoveToPosition(npc_npc_upaa, 132, 216, false, 2)
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 160, 344, Direction.Up, "NPC_MUCHUURU")
  GROUND:MoveToPosition(npc_npc_muchuuru, 156, 224, false, 2)
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 184, 352, Direction.Up, "NPC_SUBOMII")
  GROUND:MoveToPosition(npc_npc_subomii, 180, 224, false, 2)
  GAME:WaitFrames(5)
  local npc_npc_jupetta = SkySceneKit.spawn_npc("banette", 248, 360, Direction.Up, "NPC_JUPETTA")
  GROUND:MoveToPosition(npc_npc_jupetta, 244, 232, false, 2)
  local npc_npc_sukorupi = SkySceneKit.spawn_npc("skorupi", 272, 360, Direction.Up, "NPC_SUKORUPI")
  GROUND:MoveToPosition(npc_npc_sukorupi, 268, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh![K] [CS:N]Papa[CR]! [CS:N]Mama[CR]!", french=" Oh![K] [CS:N]Papa[CR]! [CS:N]Maman[CR]!", german=" Oh![K] [CS:N]Papa[CR]! [CS:N]Mama[CR]!", italian=" Oh![K] [CS:N]Papà[CR]! [CS:N]Mamma[CR]!", spanish=" ¡Anda![K] ¡[CS:N]Papá[CR]! ¡[CS:N]Mamá[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" And everyone!", french=" Et tous les copains de moi!", german=" Und alle anderen!", italian=" E tutti voi!", spanish=" ¡Si estáis todos aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" A-are you all right, [CS:Y]Igglybuff[CR]?!", french=" T-tout va bien, [CS:Y]Toudoudou[CR]?!", german=" G-geht es dir gut, [CS:Y]Fluffeluff[CR]?!?", italian=" S-Stai bene, [CS:Y]Igglybuff[CR]?!", spanish=" ¡¿Es... estás bien, [CS:Y]Igglybuff[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" You're not hurt?!", french=" Tu n'es pas blessé?!", german=" Bist du unverletzt?!?", italian=" Sei ferito?!", spanish=" ¡¿No estás herido, hijito?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm fine, [CS:N]Mama[CR]. Why?", french=" Ça va, [CS:N]Maman[CR]. Mais pourquoi?", german="Mir geht es gut, [CS:N]Mama[CR].\nWieso fragst du?", italian=" Sto bene, [CS:N]mamma[CR]. Perché?", spanish="Estoy perfectamente, [CS:N]mamá[CR].\n¿Por qué lo preguntas?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Friends, friends...[K]\nWhat's with everyone?", french="Mes copains, mes copains...[K]\nComment vous allez?", german="Freunde, Freunde...[K]\nWas habt ihr denn alle?", italian="Amici, amici...[K]\nChe ci fate tutti qui?", spanish="No os entiendo...[K]\n¿Qué os pasa a todos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR]! Listen carefully!", french=" [CS:Y]Toudoudou[CR]! Ecoute bien!", german=" [CS:Y]Fluffeluff[CR]! Hör gut zu!", italian=" [CS:Y]Igglybuff[CR]! Ascolta attentamente!", spanish=" ¡Escucha bien, [CS:Y]Igglybuff[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Over there...[K] The Pokémon next\nto you, [CS:Y]Igglybuff[CR], is...", french="Ce Pokémon, là...[K] à côté de toi,\n[CS:Y]Toudoudou[CR], c'est...", german="Da, das...[K] das Pokémon neben\ndir, [CS:Y]Fluffeluff[CR], ist...", italian="Quel...[K] Pokémon vicino a te,\n[CS:Y]Igglybuff[CR], è...", spanish="Ese de ahí...[K] [CS:Y]Igglybuff[CR], el\nPokémon que tienes al lado es..."})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" An outlaw!", french=" ... un hors-la-loi!", german=" Das ist ein Ganove!", italian=" Un ricercato!", spanish=" ¡Un malhechor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What?[K] An outlaw?", french=" Quoi?[K] Un hors-la-loi?", german=" Was?[K] Ein Ganove?", italian=" Cosa?[K] Un ricercato?", spanish=" ¿Qué?[K] ¿Estáis de broma?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english="A bad guy! That's what that\nPokémon is!", french=" Un méchant! C'est ça qu'il est!", german="Ein Bösewicht! Das ist es,\nwas dieses Pokémon ist!", italian="Un tipaccio! Ecco cos'è quel\nPokémon!", spanish="¡Uno de los malos! ¡Eso es\nese Pokémon!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master is...[K]a bad guy...?", french=" Le Maître est...[K] un méchant...?", german="Meister soll ein...[K]\nBösewicht sein?", italian=" Il maestro è...[K] un tipaccio...?", spanish=" ¿Que el maestro es...[K] malo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" That's right.", french=" C'est exact.", german=" Ganz genau.", italian=" Esatto.", spanish=" Eso es."})
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="This guy--[K][CS:N]Armaldo[CR]--is a\nPokémon we've been chasing for a while.", french="Cet individu, [K][CS:N]Armaldo[CR],\nest un Pokémon que nous recherchons\ndepuis longtemps.", german="Dieser... [CS:N]Armaldo[CR] ist ein\nPokémon, dem wir schon eine ganze Weile auf\nden Fersen sind.", italian="Questo tizio, [K][CS:N]Armaldo[CR], è un\nPokémon a cui stiamo dando la caccia\nda tempo.", spanish="Este tipo...[K] [CS:N]Armaldo[CR] es un Pokémon\nal que llevamos tiempo intentando dar caza."})
  -- bgm2_PlayFadeIn(BGM_ON_THE_CEILING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="In order to catch [CS:N]Armaldo[CR],\nI came here.", french="C'est pour attraper [CS:N]Armaldo[CR]\nque je suis venu ici.", german="Um diesen [CS:N]Armaldo[CR] endlich\nzu stellen, bin ich hierhergekommen.", italian="Per acciuffarlo, sono venuto\nfin qui.", spanish="Vine hasta aquí para capturar a\n[CS:N]Armaldo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! [CS:N]Nidoking[CR] is telling the\ntruth. ZZZT!", french=" ZZZT! [CS:N]Nidoking[CR] dit vrai. ZZZT!", german="ZZZT! [CS:N]Nidoking[CR] sagt die\nWahrheit. ZZZT!", italian="ZZZT! [CS:N]Nidoking[CR] sta dicendo\nla verità. ZZZT!", spanish="¡Bzz! [CS:N]Nidoking[CR] está\nen lo cierto. ¡Bzz!"})
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! [CS:N]Armaldo[CR] is a\n\"B\" rank outlaw...", french="ZZZT! [CS:N]Armaldo[CR] est un\nhors-la-loi classé \"B\"... ZZZT!", german="ZZZT! [CS:N]Armaldo[CR] ist ein\nGanove der Kategorie [F:S2]B[F:E2]...", italian="ZZZT! [CS:N]Armaldo[CR] è un ricercato\ndi rango \"B\"...", spanish="¡Bzz! [CS:N]Armaldo[CR] es un malhechor\nde rango \"B\". ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="We've been searching\nthe entire region for him. ZZZT!", french="ZZZT! Nous avons ratissé toute\nla région pour le retrouver. ZZZT!", german="Wir haben bereits die ganze\nRegion nach ihm abgesucht. ZZZT!", italian="Gli stavamo dando la caccia in\ntutta la regione. ZZZT!", spanish="¡Bzz! Lo hemos estado buscando\npor toda la región. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! As soon as we heard\nfrom [CS:N]Nidoking[CR], we came running. ZZZT!", french="ZZZT! Dès que [CS:N]Nidoking[CR]\nnous a signalé sa présence,\nnous avons accouru. ZZZT!", german="ZZZT! Nachdem wir von [CS:N]Nidoking[CR]\nseinen Aufenthaltsort erfahren haben, sind\nwir hierhergeeilt. ZZZT!", italian="ZZZT! Non appena [CS:N]Nidoking[CR] ci ha\navvertiti, ci siamo precipitati qui. ZZZT!", spanish="¡Bzz! En cuanto lo oímos de boca\nde [CS:N]Nidoking[CR], vinimos corriendo. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Th-that...", french=" ...[K] Mais c'est...", german=" ...[K]D-das...", italian=" ...[K] Q-Questa...", spanish=" No es...[K] No es... posible..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" So.[K] Let the kid go, [CS:N]Armaldo[CR].", french="Très bien.[K] Laisse partir\nle gamin, [CS:N]Armaldo[CR].", german="Also gut.[K] Lass den Kleinen\nlaufen, [CS:N]Armaldo[CR].", italian="Ok.[K] Lascia andare il bambino,\n[CS:N]Armaldo[CR].", spanish=" Bueno.[K] Suelta al chiquillo, [CS:N]Armaldo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 160, false, 1)
  GAME:WaitFrames(7)
  GROUND:EntTurn(hero, Direction.DownRight)
  -- GAP: BGM BGM_IT_CANT_BE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...It's a lie...", french=" ... Vous mentez...", german=" ...Das ist eine Lüge...", italian=" ... È una bugia...", spanish=" Es... Es mentira..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It can't be true...", french=" Ce n'est pas possible...", german=" Es kann nicht wahr sein...", italian=" Non può essere vero...", spanish=" No puede ser cierto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_nidokingu, 188, 164, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_jibakoiru, 220, 184, false, 1)
  GROUND:MoveToPosition(npc_npc_koiru, 204, 192, false, 1)
  GROUND:MoveToPosition(npc_npc_koiru2, 236, 192, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" Kid.[K] It's all right.", french=" Petit,[K] ça va aller.", german="Keine Angst, Kleiner.[K]\nAlles wird gut.", italian=" Bimbo.[K] È tutto a posto.", spanish=" Tranquilo.[K] Todo irá bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english="To drag a kid into this...[K] You're\nthe lowest.", french="Entraîner un gamin dans cette\nhistoire...[K] C'est plus bas que tout.", german="Ein Kind hier mit\nhineinzuziehen...[K] Du bist wirklich abscheulich.", italian="Coinvolgere addirittura\nun bambino...[K] Sei davvero un criminale.", spanish="Mira que liar a un crío...[K] No se\npuede caer más bajo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(8), p.Y+(0), false, 1) end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-no![K] I asked him!", french=" N-non![K] C'est moi qui voulais!", german="N-nein![K]\nIch habe ihn darum gebeten!", italian="N-No![K] Sono stato io\na chiederglielo!", spanish=" ¡No, no![K] ¡Yo se lo pedí!"})
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And...[K] Master isn't a\nbad Pokémon!", french="Et...[K] le Maître, c'est pas un\nméchant Pokémon!", german="Und...[K] Meister ist\nkein böses Pokémon!", italian="E...[K] il mio maestro non è\nun Pokémon cattivo!", spanish="Y...[K] ¡El maestro no es ningún\nPokémon malo!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! All right, let's finish\nthis! ZZZT!", french="ZZZT! Très bien,\nfinissons-en! ZZZT!", german="ZZZT! Gut, bringen wir es\nzu Ende! ZZZT!", italian="ZZZT! Ok, facciamola\nfinita! ZZZT!", spanish="¡Bzz! Bueno, acabemos\ncon esto. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" S-stop...", french=" A-arrêtez...", german=" S-stopp...", italian=" F-Fermi...", spanish=" Pa... parad..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Please...[K] Listen to me...", french=" S'il vous plaît...[K] Ecoutez-moi...", german=" Bitte...[K] Hört mich an...", italian=" Vi prego...[K] Ascoltatemi...", spanish=" Por favor...[K] Escuchadme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_nidokingu, 220, 152, false, 1)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GROUND:MoveToPosition(npc_npc_koiru, 204, 172, false, 1)
  GROUND:MoveToPosition(npc_npc_koiru2, 236, 172, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" Hurry up! Move it!", french=" Dépêche-toi! Avance!", german=" Mach schon! Beweg dich!", italian=" Dai! Muoviti!", spanish=" ¡Deprisa! ¡Llevémonoslo de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(0), p.Y+(24), false, 1) end
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(24), false, 1) end
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(24), false, 1) end
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(0), p.Y+(24), false, 1) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(0), p.Y+(24), false, 1) end
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- SetAnimation(9) [anim idle native]
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...OOOOOooooooooo...\nOOOOoooooooooooOOOOOoooooooo...", french="... OOOOOooooooooo...\nOOOOoooooooooooOOOOOoooooooo...", german="...OOOOOooooooooo...\nOOOOoooooooooooOOOOOoooooooo...", italian="...OOOOOooooooooo...\nOOOOoooooooooooOOOOOoooooooo...", spanish=" Buuaaa... Buuuuuaaaa..."})
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Right)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Right)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  pcall(function() SOUND:FadeOutBGM(90) end)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(30)
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_nidokingu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukorupi, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(25)
  -- message_CloseEnforce
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english=" Whoa.[K] What...[K] What is this?!", french="Ouah.[K] Qu'est-ce...[K] qu'est-ce que\nc'est que ça?!", german=" Boah![K] Was...[K] Was ist das?!?", italian=" Uoah![K] Che...[K] Che succede?!", spanish=" Eh.[K] Qué...[K] ¡¿Qué pasa?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yoo...[K] Yooo...", french=" Taa...[K] Taaa...", german=" Luu...[K] Luuu...", italian=" Bada...[K] Baaada...", spanish=" Buaa...[K] Buaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nidokingu) end)
  SkySceneKit.say({english=" Th-the ground...[K] Is it shaking?", french=" L-le sol...[K] Il tremble ou je rêve?", german=" D-der Erdboden...[K] Er wackelt?", italian=" La terra...[K] sta tremando?", spanish=" El... El suelo...[K] ¿Está temblando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(30)
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_koiru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_koiru2, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Left)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_subomii, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GAME:MoveCamera(248, 132, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru2, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Up)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.UpRight)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GAME:MoveCamera(188, 148, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharSetEmote(npc_npc_nidokingu, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(24), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Left)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" WAWAWAWAWAH!", french=" Houlà houlà houlà!", german=" WAWAWAWAWAH!", italian=" UAUAUAUAUAH!", spanish=" ¡Ay, ay, ay, ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" YOOOOOOOOOOOOOOOOOMMM...", french=" TAAAAAAAAAAAAAAAAAAAAAA...", german=" LUUUUUUUUUUUUUUUUUUUUUU...", italian=" BAAAAAAAAADAAAAAAAAAAAA...", spanish=" Buaaaaaaaaaaaaaa..."})
  -- message_Close
  SkySubScreen.Hide(2) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 2)
  pcall(function() SOUND:FadeOutBGM(15) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]WAIT!![K]\n[CN]STOP IT! JUNIOR!!", french="[CN]ATTENDS!![K]\n[CN]ARRETE ÇA! PETIT!!", german="[CN]HALT!!![K]\n[CN]AUFHÖREN! JUNIOR!!!", italian="[CN]FERMO!!![K]\n[CN]SMETTILA, PICCOLO!!!", spanish="[CN]¡¡Espera!![K]\n[CN]¡¡Para, peque, no sigas!!"})
  -- message_Close
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(1)
  SkySubScreen.Show("v33p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Huh?", french=" ... Hein?", german=" ...Was?", italian=" ... Eh?", spanish=" ¿Eh...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru2, Direction.UpLeft)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_aamarudo, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nidokingu, npc_npc_aamarudo, 4) end)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_muchuuru, npc_npc_aamarudo, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_subomii, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jupetta, npc_npc_aamarudo, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukorupi, npc_npc_aamarudo, 4) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I'm asking you![K] Stop, please!", french="Je te le demande![K]\nArrête, s'il te plaît!", german=" Ich bitte dich![K] Hör bitte auf!", italian="Ascoltami![K] Non farlo,\nper favore!", spanish=" ¡Te lo pido por favor![K] ¡No sigas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-Master...", french=" M-Maître...", german=" M-meister...", italian=" M-Maestro...", spanish=" Ma... maestro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If you blast [CS:N]Nidoking[CR] and\n[CS:N]Magnezone[CR]...", french="Si tu attaques [CS:N]Nidoking[CR] et\n[CS:N]Magnézone[CR]...", german="Wenn du [CS:N]Nidoking[CR] und\n[CS:N]Magnezone[CR] Schaden zufügst...", italian="Se facessi del male a [CS:N]Nidoking[CR]\ne a [CS:N]Magnezone[CR]...", spanish=" Si atacas a [CS:N]Nidoking[CR] y [CS:N]Magnezone[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You'll become a bad guy too, and\nthen what will you do?!", french="... tu passeras du mauvais côté,\ncomme moi, et que feras-tu alors?!", german="Dann wirst du auch zu einem\nGanoven. Und was wirst du dann machen?!?", italian="... diventeresti un tipaccio\ncome me! È questo che vuoi?!", spanish="Tú también serás uno de\nlos malos, ¡¿y qué harás entonces?!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" So please stop now!", french="C'est pour ça que je te demande\nd'arrêter!", german=" Also hör bitte auf damit!", italian=" Ti prego, smettila subito!", spanish="¡Así que detente antes de que\nsea demasiado tarde!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But--[K]Master isn't a\nbad Pokémon!", french="Mais...[K] vous n'êtes pas\nun méchant!", german="Aber...[K]\nMeister ist kein böses Pokémon!", italian="Ma...[K] maestro, tu non sei\nun Pokémon cattivo!", spanish="Pero...[K] ¡el maestro no es\nningún Pokémon malo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've been with you this long, I\nknow that!", french="Depuis le temps que je suis\navec vous, je le sais, ça!", german="Ich kenne ihn mittlerweile so\ngut, dass ich das weiß!", italian="Lo so, ti sono rimasto vicino\na lungo!", spanish="¡Después de tanto tiempo juntos\nestoy seguro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, npc_npc_jibakoiru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Officer [CS:N]Magnezone[CR].", french=" Shérif [CS:N]Magnézone[CR].", german=" Oberwachtmeister [CS:N]Magnezone[CR]...", italian=" Commissario [CS:N]Magnezone[CR].", spanish=" Agente [CS:N]Magnezone[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Yes? ZZZT!", french=" ZZZT! Oui? ZZZT!", german=" ZZZT! Ja? ZZZT!", italian=" ZZZT! Sì? ZZZT!", spanish=" ¡Bzz! ¿Sí? ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Could you give me a minute?", french=" M'accorderiez-vous une minute?", german=" Auf ein Wort...", italian="Potrebbe concedermi un minuto\ndi tempo?", spanish=" ¿Me dejas un minuto?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" It's all right.[K] I won't try to run.", french="Ne vous en faites pas.[K]\nJe ne chercherai pas à m'enfuir.", german="Ich werde nicht versuchen zu\nfliehen.[K] Das verspreche ich!", italian=" Non si preoccupi.[K] Non scapperò.", spanish=" No intentaré huir.[K] De verdad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! ...[K]Understood. ZZZT!", french=" ZZZT! ...[K] Entendu. ZZZT!", german=" ZZZT! ...[K]Verstanden. ZZZT!", italian=" ZZZT! ...[K] Va bene. ZZZT!", spanish=" ¡Bzz![K] De acuerdo. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(-12), p.Y+(0), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(12), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-32), 64, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_aamarudo, 208, 148, false, 1)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_koiru, Direction.Up)
  GROUND:EntTurn(npc_npc_koiru2, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_DEFEND_GLOBE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I'm sorry, Junior.", french=" Je suis désolé, petit.", german=" Es tut mir leid, Junior.", italian=" Mi dispiace, piccolo.", spanish=" Lo siento, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Just like [CS:N]Nidoking[CR] said...[K]\nI'm an outlaw.", french="Comme [CS:N]Nidoking[CR] l'a expliqué...[K]\nje suis un hors-la-loi.", german="Es ist genau, wie [CS:N]Nidoking[CR]\ngesagt hat...[K] Ich bin ein Ganove...", italian="È proprio come ha detto\n[CS:N]Nidoking[CR]...[K] Io sono un ricercato.", spanish="Como ha dicho [CS:N]Nidoking[CR]...[K]\nSoy un malhechor."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I'm a bad guy.", french=" Un méchant.", german=" Ich bin ein Bösewicht...", italian=" Sono un tipaccio.", spanish=" Soy uno de los malos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That...[K] That's not true!", french=" C'est...[K] c'est faux!", german=" Das...[K] Das ist nicht wahr!", italian=" No...[K] Non è vero!", spanish=" Eso...[K] ¡Eso no es verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Listen, Junior.", french=" Ecoute, petit.", german=" Hör mir zu, Junior.", italian=" Ascoltami, piccolo.", spanish=" Escúchame, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I am an outlaw and they were\nsearching the entire region for me.", french="Je suis un hors-la-loi,\nj'étais recherché dans toute la région.", german="Ich bin ein Ganove. Deswegen\nhaben sie die ganze Region nach mir abgesucht.", italian="Sono un ricercato a cui davano\nla caccia in tutta la regione.", spanish="Soy un malhechor y me estaban\nbuscando por toda la región."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="To avoid getting caught...[K] I've\njust been running, running, running.", french="Alors, pour éviter de me faire\nattraper...[K] j'ai fui loin, très loin, le\nplus loin possible.", german="Um meiner Festnahme zu\nentgehen,[K] bin ich gelaufen, gelaufen, gelaufen.", italian="Per non essere arrestato...[K]\nsono scappato, senza mai fermarmi.", spanish="Para evitar que me atraparan...[K]\nno he hecho otra cosa que huir y huir."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And I took a break in\n[CS:P]Murky Forest[CR].", french="Et j'ai décidé de m'établir dans\nla [CS:P]Forêt Glauque[CR].", german="Und dann habe ich mich im\n[CS:P]Trübwald[CR] ausgeruht.", italian="Finché sono arrivato nella\n[CS:P]Foresta Tenebrosa[CR].", spanish="Y me tomé un respiro en el\n[CS:P]Bosque Oscuro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I started that rumor about\n[CS:P]Murky Forest[CR].", french="J'ai ensuite lancé une rumeur\nau sujet de la [CS:P]Forêt Glauque[CR].", german="Ich habe mir das Gerücht über\nden [CS:P]Trübwald[CR] ausgedacht.", italian="Allora ho cominciato a spargere\nin giro quelle voci.", spanish="Yo inicié ese rumor sobre el\n[CS:P]Bosque Oscuro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The rumor that a monster lurked\ndeep in the darkness.", french="La rumeur selon laquelle un\nmonstre vivrait caché dans les profondeurs\nténébreuses de la forêt.", german="Das Gerücht, demzufolge tief im\nDunkeln ein fürchterliches Monster hausen soll.", italian="Che nel cuore della foresta\nsi nascondeva un mostro.", spanish="Sobre un monstruo que merodeaba\nen lo más profundo del bosque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Because of that, nobody came\nout there...[K] So I thought I wouldn't get caught.", french="Grâce à ce stratagème,\npersonne n'est venu me déranger...[K]\nJe pensais pouvoir échapper à la justice.", german="So hatte ich im Wald meine\nRuhe...[K] Und hoffte, nie erwischt zu werden.", italian="In questo modo, nessuno ha più\nosato avvicinarsi...[K] e io pensavo di essere\nfinalmente al sicuro.", spanish="Gracias a eso nadie iba por allí...[K]\nAsí que pensé que no me iban a capturar nunca."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That's how I took shelter in\n[CS:P]Murky Forest[CR].", french="C'est comme ça que je me suis\ninstallé dans la [CS:P]Forêt Glauque[CR].", german="Und mit der Zeit habe ich mich\nim [CS:P]Trübwald[CR] eingerichtet.", italian="Ecco perché vivevo nella\n[CS:P]Foresta Tenebrosa[CR].", spanish="Así es como me acabé refugiando\nen el [CS:P]Bosque Oscuro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I meant to tell you the truth\nmuch sooner...", french="J'avais l'intention de tout te\nraconter depuis longtemps...", german="Ich wollte dir eigentlich bereits\nfrüher die Wahrheit sagen...", italian="Avrei voluto dirti la verità\nmolto prima...", spanish="Pensaba contarte la verdad\nhace mucho..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But I just couldn't bring\nmyself to...[K] I'm sorry.", french="Mais je n'ai pas réussi à\nm'y résoudre...[K] J'en suis navré.", german="Nur habe ich es nicht\nfertiggebracht...[K] Das tut mir leid.", italian="Ma non trovavo il coraggio\ndi farlo...[K] Mi dispiace.", spanish="Pero nunca reuní el valor\nsuficiente...[K] Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-Master...", french=" M-Maître...", german=" M-meister...", italian=" M-Maestro...", spanish=" Ma... maestro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Anyway.[K] I am a bad guy.", french="Ecoute.[K] Je suis un\nhors-la-loi.", german="Wie dem auch sei.[K]\nIch bin ein Bösewicht.", italian=" Comunque...[K] Io sono un tipaccio.", spanish=" En fin.[K] Soy un tipo malo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" But...[K] You're different.", french=" Mais...[K] toi, tu es différent.", german=" Aber...[K] Du bist anders.", italian=" Ma tu...[K] tu sei diverso.", spanish=" Pero...[K] tú eres diferente."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" So you...[K] You can't be with me.", french="Alors tu...[K] tu ne peux pas\nrester avec moi.", german="Deswegen...[K] kannst du nicht\nbei mir bleiben.", italian="Quindi...[K] non possiamo più\nessere una squadra.", spanish="Así que...[K] no podemos seguir\nexplorando juntos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But--", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Haven't we had so much fun\ntogether?!", french="On s'est bien amusés tous\nles deux, pas vrai?!", german="Hatten wir nicht jede Menge\nSpaß miteinander?!?", italian="Non ci siamo divertiti tanto\ninsieme?!", spanish="¡¿Acaso no nos lo hemos pasado\ngenial juntos?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I thought you were going to\nteach me even more as we kept on exploring!", french="Vous avez encore tellement de\nchoses à m'apprendre sur les explorations!", german="Ich wollte noch viel mehr von\ndir über das Erkunden lernen!", italian="Credevo che avremmo continuato\na esplorare e che tu mi avresti insegnato\ntante altre cose!", spanish="¡Pensaba que ibas a enseñarme\naún más cosas mientras seguíamos explorando!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If Master disappears...[K] I'll...[K]\nWhat will I do...", french="Sans Maître...[K] je...[K]\nQu'est-ce que je vais devenir...", german="Wenn der Meister nun\nverschwindet...[K] Was soll...[K] Was soll ich dann\nmachen...", italian="Se tu dovessi andartene,\nmaestro...[K] che...[K] che ne sarà di me...?", spanish="Si el maestro se va...[K] yo...[K]\n¿Qué va a ser de mí?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Junior.[K] Did you enjoy exploring?", french="Petit.[K] Toutes ces explorations\nt'ont plu?", german="Junior.[K]\nHat dir das Erkunden Spaß gemacht?", italian="Piccolo.[K] Ti è piaciuto esplorare\ntutti questi posti?", spanish="Eh, peque.[K] ¿Te lo has pasado\nbien explorando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah...", french=" Oh voui...", german=" Ja, sehr...", italian=" Certo...", spanish=" Sí..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="So...[K] Become an amazing\nexplorer someday, for me.", french="Dans ce cas...[K] deviens un grand\nexplorateur un jour, fais-le pour moi.", german="Dann...[K] werde mir zu Ehren ein\ngroßer Erkunder.", italian="Allora...[K] promettimi che un\ngiorno diventerai un grande esploratore.\nFallo per me.", spanish="Pues...[K] Tienes que llegar a ser\nun explorador increíble, hazlo por mí."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Don't be a blockhead like me.", french="Ne sois pas stupide comme\nje l'ai été.", german=" Sei nicht so dumm wie ich.", italian=" Non diventare come me.", spanish=" No seas un zoquete como yo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" You've got a gift for exploring.", french=" Tu as un don pour l'exploration.", german="Du besitzt ein Naturtalent\nfür Erkundungen.", italian="Tu hai un talento naturale\nper l'esplorazione.", spanish=" Tienes un don para explorar."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="So you should...[K]do your best to\nbe an amazing explorer, for me.", french="Alors tu devrais...[K] faire tout ce\nque tu peux pour devenir un grand explorateur.\nFais-le pour moi.", german="Daher solltest du[K] dein Bestes\ngeben, um ein unglaublicher Erkunder zu\nwerden. Tu es für mich.", italian="Quindi devi...[K] mettercela tutta\nper diventare un fantastico esploratore.\nÈ l'unica cosa che ti chiedo...", spanish="Así que deberías hacer todo lo\nposible por ser un explorador sensacional...[K]\nHazlo por mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-Master...", french=" M-Maître...", german=" M-meister...", italian=" M-Maestro...", spanish=" Ma... maestro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(-12), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! It's about time. ZZZT!", french=" ZZZT! Il est l'heure. ZZZT!", german=" ZZZT! Es ist an der Zeit. ZZZT!", italian=" ZZZT! Il tempo è scaduto. ZZZT!", spanish=" ¡Bzz! Se acabó el tiempo. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(32), 64, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_aamarudo, 208, 172, false, 1)
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(8), false, 1) end
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" D-don't go!", french=" N-ne partez pas!", german=" G-geh nicht!", italian=" N-Non andartene!", spanish=" No... ¡No te vayas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Junior.", french=" Petit.", german=" Junior.", italian=" Piccolo.", spanish=" Eh, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I really enjoyed exploring with\nyou these past few days.", french="J'ai vraiment aimé passer tout\nce temps à explorer le monde à tes côtés.", german="Ich habe es wirklich genossen,\nmit dir während der ganzen Zeit auf\nErkundungen zu gehen.", italian="In questo periodo che abbiamo\ntrascorso insieme a esplorare mi sono\ndivertito molto.", spanish="Me lo he pasado genial explorando\ncontigo este tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I knew there was a danger of\nbeing caught like this...", french="Je savais pertinemment que je\ncourais le risque d'être attrapé...", german="Es war mir klar, dass die\nGefahr besteht, auf diese Art gefasst zu\nwerden...", italian="Sapevo che correvo il rischio\ndi essere catturato...", spanish="Sabía que corría el peligro\nde que me capturaran así..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But...[K] Despite that risk, we\nwent on explorations...", french="Mais...[K] malgré tout,\nj'ai poursuivi les explorations...", german="Aber trotz des Risikos[K]\nbin ich mit dir auf Erkundungen gegangen...", italian="Ma...[K] nonostante questo, sono\nandato avanti...", spanish="Pero...[K] a pesar de eso,\nnos fuimos de exploración..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And when you were with me,\nI had a lot of fun.", french="Et avec toi à mes côtés, je me\nsuis vraiment amusé.", german="Und solange du bei mir warst,\nhatte ich eine Menge Spaß.", italian="E la tua compagnia mi ha\nregalato grande gioia.", spanish="Y cuando estabas conmigo\nme divertía muchísimo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This was the first time I ever\nreally enjoyed exploring.", french="C'était la première fois de ma\nvie que j'éprouvais autant de plaisir\nà explorer.", german="Dies war das erste Mal, dass\nich es wirklich genossen habe, zu erkunden.", italian="Non mi ero mai divertito così\ntanto durante le mie esplorazioni.", spanish="Ha sido la primera vez que\ndisfrutaba de verdad explorando."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And you are the one who has\nshown me how fun it can be.", french="Et c'est toi qui m'as montré\nà quel point cela pouvait être amusant.", german="Und du hast mir gezeigt,\nwie viel Spaß man dabei haben kann.", italian="Ed è solo merito tuo se ho\npotuto vivere tutto questo.", spanish="Y tú me has enseñado lo divertido\nque puede llegar a ser."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Thank you very much.", french=" Merci pour tout.", german=" Dafür möchte ich dir danken.", italian=" Grazie mille.", spanish=" Muchas gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oooooohhhh...[K] Master...", french=" Ooooooh...[K] Maître...", german=" Ooooooh...[K] Meister...", italian=" Oooooohhh...[K] Maestro...", spanish=" Buuuaaa...[K] Maestro..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't...[K] I don't want you to go...", french="Je...[K] je ne veux pas que\nvous vous en alliez...", german="Aber...[K] Aber ich möchte nicht,\ndass du gehst...", italian="Non...[K] Non voglio che tu\nte ne vada...", spanish=" No...[K] No quiero que te vayas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Junior. Try to understand.", french=" Petit. Sois raisonnable.", german=" Junior. Versuche, zu verstehen.", italian=" Piccolo. Cerca di capire.", spanish=" Intenta comprenderlo, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I have to answer for the things\nI've done.", french=" Je dois répondre de mes actes.", german="Ich muss für die Dinge\ngeradestehen, die ich getan habe.", italian="Devo pagare per gli errori che\nho commesso.", spanish="Tengo que responder ante\nla justicia por todo lo que he hecho."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But when I've finished...[K] Then, if\nI still feel the same...", french="Mais quand je serai de nouveau\nlibre...[K] si l'envie me reprend...", german="Aber wenn ich meine Strafe\nverbüßt habe...[K] und ich immer noch so fühle...", italian="Ma quando sarà tutto finito...[K]\nse me la sentirò ancora...", spanish="Pero cuando haya pagado\nmi deuda...[K] Entonces, si sigo pensando\nlo mismo..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I'll become an explorer.", french="... alors, je redeviendrai\nexplorateur.", german=" Dann werde ich erneut erkunden.", italian=" ... diventerò un esploratore.", spanish=" Me convertiré en un explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I don't know when that will be...[K]\nBut when that day comes...", french="Je ne sais pas dans combien\nde temps...[K] Mais quand ce jour viendra...", german="Ich weiß nicht wann...[K]\nAber wenn dieser Tag kommt...", italian="Non so quanto ci vorrà...[K]\nma quando arriverà quel giorno...", spanish="No sé cuándo sucederá...[K]\nPero cuando llegue ese día..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="When that day comes...[K] I'd like\nto go exploring with you again.", french="Quand ce jour viendra...[K]\nj'aimerais repartir explorer le monde avec toi.", german="Wenn dieser Tag kommt,[K]\nwürde ich liebend gerne wieder mit dir auf\nErkundung gehen.", italian="Quando arriverà quel giorno...[K]\nmi piacerebbe partecipare a un'altra\nesplorazione insieme a te.", spanish="Cuando ese día llegue...[K] me\ngustaría volver a explorar contigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's...[K] It's a promise!", french=" C'est...[K] c'est d'accord!", german=" A-[K]abgemacht!", italian=" V-Va bene...[K] Promesso!", spanish=" Vale...[K] ¡Prometido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Sorry to have kept you waiting.", french="Désolé de vous avoir\nfait attendre.", german="Ich entschuldige mich für die\nVerzögerung.", italian=" Mi scusi se l'ho fatta aspettare.", spanish=" Siento haberos hecho esperar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_nidokingu, 228, 156, false, 2)
  GROUND:MoveToPosition(npc_npc_jibakoiru, 208, 192, false, 1)
  GROUND:MoveToPosition(npc_npc_koiru, 188, 172, false, 1)
  GROUND:MoveToPosition(npc_npc_koiru2, 228, 172, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Down)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(0), p.Y+(64), false, 1) end
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(64), false, 1) end
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(64), false, 1) end
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(0), p.Y+(64), false, 1) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(0), p.Y+(64), false, 1) end
  GAME:WaitFrames(45)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(32), 108, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin_papa.Position; GROUND:MoveToPosition(npc_npc_pukurin_papa, p.X+(-8), p.Y+(8), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin_mama.Position; GROUND:MoveToPosition(npc_npc_pukurin_mama, p.X+(-8), p.Y+(8), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_upaa.Position; GROUND:MoveToPosition(npc_npc_upaa, p.X+(-8), p.Y+(8), false, 1) end -- Slide2PositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_muchuuru.Position; GROUND:MoveToPosition(npc_npc_muchuuru, p.X+(-16), p.Y+(16), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_subomii.Position; GROUND:MoveToPosition(npc_npc_subomii, p.X+(-16), p.Y+(16), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Left)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.Left)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukorupi.Position; GROUND:MoveToPosition(npc_npc_sukorupi, p.X+(8), p.Y+(8), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_jupetta.Position; GROUND:MoveToPosition(npc_npc_jupetta, p.X+(16), p.Y+(16), false, 1) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 208, 168, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master![K] Master!", french=" Maître![K] Maître!", german=" Meister![K] Meister!", italian=" Maestro![K] Maestro!", spanish=" ¡Maestro![K] ¡Maestro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Up)
  GROUND:EntTurn(npc_npc_koiru, Direction.Up)
  GROUND:EntTurn(npc_npc_koiru2, Direction.Up)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Up)
  GROUND:EntTurn(npc_npc_subomii, Direction.UpRight)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Take this!", french=" Prends ça!", german=" Nimm das hier!", italian=" Prendi questo!", spanish=" Toma esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- GAP: se_Play(9737) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- MovePositionOffset<object OBJECT_P22P01A1_392> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P22P01A1_392) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(32) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Be seeing you.", french=" On se reverra.", german=" Wir sehen uns.", italian=" A presto.", spanish=" Hasta la vista."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_nidokingu, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru2, Direction.Down)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.DownRight)
  GROUND:EntTurn(npc_npc_upaa, Direction.Right)
  GROUND:EntTurn(npc_npc_subomii, Direction.Right)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Right)
  GAME:WaitFrames(30)
  do local p=npc_npc_nidokingu.Position; GROUND:MoveToPosition(npc_npc_nidokingu, p.X+(0), p.Y+(180), false, 1) end
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(180), false, 1) end
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(180), false, 1) end
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(0), p.Y+(180), false, 1) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(0), p.Y+(180), false, 1) end
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_upaa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_subomii, Direction.Down)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Down)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.DownLeft)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(12), false, 1) end
  GAME:WaitFrames(50)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" MASTER!", french=" MAITRE!", german=" MEISTER!", italian=" MAESTRO!", spanish=" ¡Maestro!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  -- SetAnimation(30) [anim idle native]
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" WAAAAAAAAAaaaaaaaaaaahhhhh!", french=" OUIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIN!", german=" WAAAAAAAAAaaaaaaaaaaah!", italian=" UAAAAAAAAAaaaaaaaaaaaahhh!", spanish=" ¡Buaaaaaaaaaaa!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_upaa, Direction.UpRight)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_jupetta, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 220, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_pukurin_mama, 196, 204, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_subomii, 196, 220, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_muchuuru, 172, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_upaa, 164, 196, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_jupetta, 228, 220, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_sukorupi, 244, 204, false, 2)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpRight)
  GROUND:EntTurn(npc_npc_subomii, Direction.Up)
  GROUND:EntTurn(npc_npc_muchuuru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_jupetta, Direction.Up)
  GROUND:EntTurn(npc_npc_sukorupi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]The last thing Master gave me...", french="[CN]La dernière chose que le Maître m'a donnée...", german="[CN]Das Letzte, was mir mein Meister gab...", italian="[CN]L'ultima cosa che ho ricevuto\n[CN]dal mio maestro...", spanish="[CN]Lo último que me dio el maestro..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Was the thing we found on the first\n[CN]exploration Master and I went on...", french="[CN]... c'est l'objet que nous avions trouvé\n[CN]lors de notre première exploration...", german="[CN]Es war das Ding, das wir auf unserer ersten\n[CN]gemeinsamen Erkundung gefunden hatten.", italian="[CN]È stata quello che abbiamo trovato durante\n[CN]la nostra prima esplorazione insieme...", spanish="[CN]Fue lo que hallamos en la primera exploración\n[CN]que emprendimos juntos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]A [CS:Z]Defend Globe[CR].", french="[CN]Une [CS:Z]Défensphère[CR].", german="[CN]Jener [CS:Z]Abwehrglobus[CR]...", italian="[CN]Un [CS:Z]Globodifesa[CR].", spanish="[CN]Un [CS:Z]Globodefensa[CR]."})
  -- message_Close
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(210) end)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
