-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/m00p0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P03A) [neutre/état moteur]
  if (SkyProg.cmp(29, 5) < 0) then -- if ROM: scn($SCENARIO_MAIN) < [29, 5]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_1 [étiquette de flux ExplorerScript]
  -- message_Close
  do local __sw = ((SV.SkyVars or {}).GROUND_START_MODE or 0) -- switch($GROUND_START_MODE) [GameVar GROUND_START_MODE]
  if __sw == 9 or __sw == 10 or __sw == 11 then
  do local __sw = ((SV.SkyVars or {}).DUNGEON_ENTER_INDEX or 0) -- switch($DUNGEON_ENTER_INDEX) [GameVar DUNGEON_ENTER_INDEX (SV.SkyVars)]
  if __sw == 191 or __sw == 192 or __sw == 193 then
  -- @label_8 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_garagara = SkySceneKit.spawn_npc("marowak", 256, 208, Direction.Down, "NPC_GARAGARA")
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Ack![K] Couldn't get through...", french=" Argh![K] Vous n'avez pas réussi...", german=" Ach![K] Das war wohl nichts...", italian=" Ah![K] Non ce l'avete fatta...", spanish="¡Vaya![K] No habéis podido llegar\nhasta el final..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Well, didn't I say?[K] You can only\nblame yourself for going to a place that awful.", french="Je vous l'avais bien dit![K]\nC'est un endroit horrible, vous ne pouvez vous\nen prendre qu'à vous.", german="Tja, was habe ich gesagt?[K] An\neinen so entsetzlichen Ort hättet ihr gar nicht\nerst gehen sollen.", italian="Beh, cosa vi avevo detto?[K] La\ncolpa è solo vostra. Vi avevo detto che quel\nposto è davvero tremendo.", spanish="¿Qué os había dicho?[K] Os lo\nhabéis buscado por ir a un lugar tan espantoso."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You should learn from that and\nnever go back there!", french="Vous devriez en tirer des leçons\net ne plus jamais y retourner!", german="Lernt daraus und geht nie wieder\ndorthin!", italian="Dovreste imparare la lezione e\nnon tornarci mai più!", spanish="¡Espero que aprendáis la lección\ny no volváis a pisar ese lugar!"})
  -- message_Close
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  elseif true then -- default
  -- @label_5 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Ack![K] You couldn't get through...", french=" Argh![K] Vous n'avez pas réussi...", german=" Ach![K] Das war wohl nichts...", italian=" Ah![K] Non ce l'avete fatta...", spanish="¡Vaya![K] No habéis podido llegar\nhasta el final..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="But one must try and try again\nin the face of failure...", french="Mais quand on échoue, il faut\nessayer et réessayer...", german="Aber wer scheitert, muss es\nwieder versuchen. Und wieder...", italian="Ma bisogna provare e riprovare\nprima di riuscire in qualcosa...", spanish="Pero no hay que rendirse ante\nel fracaso. Hay que intentarlo una y otra vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" That's how everyone grows up!", french=" C'est comme ça qu'on s'améliore!", german=" Nur so kann man wachsen!", italian=" È così che si cresce!", spanish=" ¡Así es como se madura!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I'll try harder![K] I expect you to\ndo the same.[K] We'll all try harder!", french="Je redoublerai d'efforts![K] Et\nj'attends de vous la même chose.[K] Nous devons\ntous redoubler d'efforts!", german="Ich arbeite an mir![K] Dasselbe\nerwarte ich von euch.[K] Jeder muss an sich\narbeiten!", italian="Mi impegnerò di più![K]\nMi aspetto che lo facciate anche voi.[K]\nCi impegneremo tutti di più!", spanish="¡Yo pienso esforzarme más![K]\nEspero que me imitéis.[K]\n¡Todos debemos esforzarnos más!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).DUNGEON_ENTER_INDEX or 0) -- switch($DUNGEON_ENTER_INDEX) [GameVar DUNGEON_ENTER_INDEX (SV.SkyVars)]
  if __sw == 191 or __sw == 192 or __sw == 193 then
  if ((SV.SkyScenarioBitFlags or {})[28] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[28]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Oh my![K] It's you again!", french=" Oh![K] Vous revoilà!", german="Ach![K] Da seid ihr ja\nwieder!", italian=" Oh guarda![K] Siete voi!", spanish=" ¡Vaya![K] ¡Aquí estáis de nuevo!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You've made it through that\nterrible place again!", french="Vous avez réussi à sortir\nde cet endroit horrible!", german="Ihr habt es durch diesen\nentsetzlichen Ort geschafft!", italian="Avete superato quel posto\nspaventoso!", spanish="¡Habéis atravesado ese terrible\nlugar!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Frankly, what you've managed to\ndo defies belief.[K] You're something else.", french="Ce que vous avez fait défie\nl'imagination.[K] Vous êtes extraordinaires.", german="Was ihr geleistet habt, ist\nwahrhaftig kaum zu glauben.[K] Ihr spottet jedem\nVergleich!", italian="Francamente, quello che avete\nfatto è incredibile.[K] Siete inimitabili.", spanish="Francamente, lo que habéis hecho\nes increíble.[K] Sois de lo que no hay."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You're so exceptional that I...[K]\nI am inspired to be braver in all things![K]\nIt's all thanks to you!", french="Vous êtes si admirables que...[K]\nvous m'inspirez! J'ai plus de courage dans\ntout ce que je fais![K] Tout ça grâce à vous!", german="Eure außerordentliche\nTapferkeit ist so...[K] so inspirierend und\nmutspendend für mich![K] Ich danke euch!", italian="Siete così eccezionali che...[K]\nanch'io mi sento più coraggioso![K]\nEd è tutto grazie a voi!", spanish="Sois tan excepcionales que yo...[K]\n¡Yo me siento inspirado a ser más valiente\nen mi vida![K] ¡Sois un ejemplo a seguir!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I'll try harder![K] I expect you to\ndo the same.[K] We'll all try harder!", french="Je redoublerai d'efforts![K] Et\nj'attends de vous la même chose.[K] Nous devons\ntous redoubler d'efforts!", german="Ich arbeite an mir![K] Dasselbe\nerwarte ich von euch.[K] Jeder muss an sich\narbeiten!", italian="Mi impegnerò di più![K]\nMi aspetto che lo facciate anche voi.[K]\nCi impegneremo tutti di più!", spanish="¡Me voy a esforzar más![K]\nY espero que hagáis lo mismo.[K]\n¡Todos nos vamos a esforzar más!"})
  -- message_Close
  else
  do local __sw = ((SV.SkyVars or {}).DUNGEON_ENTER_INDEX or 0) -- switch($DUNGEON_ENTER_INDEX) [GameVar DUNGEON_ENTER_INDEX (SV.SkyVars)]
  if true then -- default
  end
  end
  -- @label_23 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[25] = 0 -- $SCENARIO_MAIN_BIT_FLAG[25] = 0 (ROM)
  -- @label_24 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[25] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[25]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_7 [étiquette de flux ExplorerScript]
  -- message_Close
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[28] = 1 -- $SCENARIO_MAIN_BIT_FLAG[28] = 1 (ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Oh my![K] It's you!", french=" Oh![K] C'est vous!", german="Ach![K] Da seid ihr ja\nwieder!", italian=" Oh guarda![K] Siete voi!", spanish=" ¡Vaya![K] ¡Habéis vuelto!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Finally...[K] Finally...[K] You finally\nconquered that awful place!", french="Enfin...[K] enfin...[K] vous avez enfin\nconquis cet horrible endroit!", german="Endlich![K] Oh, endlich![K] Endlich habt\nihr diesen schrecklichen Ort bezwungen!", italian="Finalmente...[K] Finalmente...[K]\nAvete finalmente finito di esplorare quel\nposto terrificante!", spanish="Finalmente...[K] Al fin...[K] ¡Al fin\nhabéis conquistado ese espantoso lugar!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="It's incredible![K] It's incredibly\nincredible!", french="C'est incroyable![K] C'est\nincroyablement incroyable!", german="Es ist unfassbar![K] Es ist\nso unglaublich unfassbar!", italian="È incredibile![K] È incredibilmente\nincredibile!", spanish="¡Es increíble![K]\n¡Es increíblemente increíble!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Sniffle...[K] I'm getting all\nemotional over this...", french=" Snif...[K] Je suis très ému...", german="Schnief...[K] Das geht mir wirklich\nnahe...", italian=" Sniff...[K] Mi sto commuovendo...", spanish="Snif...[K] Me estoy poniendo\nsentimental con esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You've managed to inspire\nsomeone like me...[K] Thank you so very much...", french="Vous m'avez redonné la foi...[K]\nJe vous en suis tellement reconnaissant...", german="Ihr habt es geschafft, jemandem\nwie mir neue Inspiration zu schenken...[K] Vielen,\nvielen Dank...", italian="Siete una fonte d'ispirazione per\nme.[K] Vi sono davvero grato...", spanish="Habéis conseguido inspirar a\nalguien como yo...[K] ¡Os estoy tan agradecido!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="And this is my thanks...[K] It's my\nshow of gratitude!", french="Voici pour vous remercier...[K]\nC'est ma façon de vous montrer ma gratitude!", german="Zum Dank gebe ich euch das...[K]\nNehmt es als Zeichen meiner Dankbarkeit!", italian="Ed ecco il mio ringraziamento.[K]\nÈ la dimostrazione di quanto vi sono grato!", spanish="Y esta es mi forma de daros\nlas gracias.[K] Aquí tenéis una muestra\nde mi gratitud."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="It's my grandpa's treasure![K]\nTreat it with care!", french="C'est le trésor de mon cher\ngrand-père![K] Prenez-en grand soin!", german="Es ist der Schatz meines Opas![K]\nBehandelt ihn mit Sorgfalt!", italian="È il tesoro di mio nonno![K]\nAbbiatene cura!", spanish="Este es el tesoro de mi abuelo.[K]\n¡Tratadlo con cuidado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CN] Fantastic! [hero] obtained a\n[CN][CS:I]Brown Bow[CR]!", french="[CN]Fantastique! [hero] obtient\n[CN]un [CS:I]Ruban Brun[CR]!", german="[CN] Fantastisch! [hero] erhält ein\n[CN][CS:I]Braunband[CR]!", italian="[CN]Fantastico! [hero] ottiene\n[CN]un [CS:I]Fioccobruno[CR]!", spanish="[CN]¡Fantástico! ¡[hero] obtuvo un\n[CN][CS:I]Lazo Marrón[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 429, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="If he were around to hear that\nan exploration team conquered that\nawful place...", french="S'il était là avec nous et qu'il\napprenait qu'une équipe d'exploration est\nparvenue à conquérir cet horrible endroit...", german="Wenn er hören würde, dass ein\nErkundungsteam diesen schrecklichen Ort\nbezwungen hat...", italian="Se fosse stato qui a sentire che\nuna squadra d'esplorazione ha attraversato\nquel posto tremendo...", spanish="¡Ojalá estuviera aquí para ver\nque un equipo explorador ha conquistado\nese espantoso lugar!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Grandpa would have been\noverjoyed, that's for certain!", french="Grand-père serait fou de joie,\nc'est certain!", german="Opa wäre außer sich vor\nFreude, so viel ist sicher!", italian="... il nonno avrebbe fatto i salti\ndi gioia, poco ma sicuro!", spanish="¡Estoy seguro de que a mi abuelo\nle habría encantado!"})
  -- message_Close
  end
  end
  elseif true then -- default
  if ((SV.SkyScenarioBitFlags or {})[24] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[24]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Oh![K] You've completed it!", french=" Oh![K] Vous l'avez terminé!", german=" Oh![K] Ihr habt es geschafft!", italian=" Oh![K] Ce l'avete fatta!", spanish="¡Estupendo![K]\n¡Habéis superado el dojo!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" That's good work, you two!", french=" Bon travail, vous deux!", german=" Das war gute Arbeit, ihr beide!", italian=" Ottimo lavoro!", spanish=" ¡Buen trabajo!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="But don't get too comfortable!\nTrain more! Become more powerful!", french="Mais ne vous endormez pas sur\nvos lauriers! Continuez à vous entraîner!\nEt devenez plus puissants!", german="Aber ruht euch nicht auf euren\nLorbeeren aus! Trainiert mehr! Werdet noch\nstärker!", italian="Ma non dovete adagiarvi sugli\nallori! Allenatevi di più! Diventate più forti!", spanish="¡Pero no os durmáis en los\nlaureles! ¡Entrenad más! ¡Sed más fuertes!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I'll try harder![K] I expect you to\ndo the same.[K] We'll all try harder!", french="Je redoublerai d'efforts![K] Et\nj'attends de vous la même chose.[K] Nous devons\ntous redoubler d'efforts!", german="Ich arbeite an mir![K] Dasselbe\nerwarte ich von euch.[K] Jeder muss an sich\narbeiten!", italian="Mi impegnerò di più![K]\nMi aspetto che lo facciate anche voi.[K]\nCi impegneremo tutti di più!", spanish="¡Yo me voy a esforzar más![K]\nY espero que hagáis lo mismo.[K]\n¡Todos nos esforzaremos más!"})
  -- message_Close
  else
  do local __sw = ((SV.SkyVars or {}).DUNGEON_ENTER_INDEX or 0) -- switch($DUNGEON_ENTER_INDEX) [GameVar DUNGEON_ENTER_INDEX (SV.SkyVars)]
  if __sw == 180 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[14] = 0 -- $SCENARIO_MAIN_BIT_FLAG[14] = 0 (ROM)
  -- @label_22 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[14] == 1) or ((SV.SkyScenarioBitFlags or {})[15] == 1) or ((SV.SkyScenarioBitFlags or {})[16] == 1) or ((SV.SkyScenarioBitFlags or {})[17] == 1) or ((SV.SkyScenarioBitFlags or {})[18] == 1) or ((SV.SkyScenarioBitFlags or {})[19] == 1) or ((SV.SkyScenarioBitFlags or {})[20] == 1) or ((SV.SkyScenarioBitFlags or {})[21] == 1) or ((SV.SkyScenarioBitFlags or {})[22] == 1) or ((SV.SkyScenarioBitFlags or {})[23] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[14] || $SCENARIO_MAIN_BIT_FLAG[15] |
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_4 [étiquette de flux ExplorerScript]
  -- message_Close
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[24] = 1 -- $SCENARIO_MAIN_BIT_FLAG[24] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[11] = 1 -- $PERFORMANCE_PROGRESS_LIST[11] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 7 -- adventure_log = 7 (journal NDS)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Oh![K] You've completed it, then!", french=" Oh![K] Vous avez réussi!", german=" Oh![K] Ihr habt es also geschafft!", italian=" Oh![K] Allora l'avete completato!", spanish="¡Estupendo![K]\n¡Habéis vencido una vez más!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Not just that...", french=" Et ce n'est pas tout...", german=" Und nicht nur das!", italian=" Non solo...", spanish=" Y no solo eso..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You've cleared all the training\nmazes![K] I'm blazed and amazed!", french="Vous avez terminé tous les\ndédales d'entraînement![K] Je suis vraiment\nimpressionné!", german="Ihr habt alle Trainings-Dojos\ngemeistert![K] Ich bin schwer beeindruckt!", italian="Avete superato tutti i labirinti\nd'allenamento![K] Non credo ai miei occhi!", spanish="¡Habéis superado todos los\ndojos de entrenamiento![K] ¡Me habéis\ndejado de una pieza!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Wow...[K] You've stomped all over\nmy dojo!", french="Waouh...[K] Vous avez traversé\nl'ensemble de mon dojo!", german="Wow...[K] Ihr habt das ganze Dojo\nleer gefegt!", italian="Wow...[K] Avete oltrepassato\nogni ostacolo del dojo!", spanish="Vaya...[K] ¡Prácticamente\nhabéis arrasado con mi dojo!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="For such a thorough stomping,\nyou deserve a trophy of sorts...[K] Take the\ndojo's sign...[K] No, that wouldn't do.", french="En récompense d'un tel exploit,\nvous méritez un trophée digne de vous...[K]\nVoici l'insigne du dojo...[K] Non, ça ne va pas.", german="Für so gründliche Arbeit solltet\nihr eine Art Trophäe bekommen.[K] Nehmt das\nZeichen des Dojos![K] Oder nein, das reicht nicht!", italian="Per un successo del genere, vi\nmeritate un trofeo adeguato...[K] Prendete\nl'insegna del dojo...[K] No, ma che dico!?", spanish="Semejante esfuerzo merece\nalgún trofeo.[K] Lo tradicional sería ofreceros el\nemblema de mi dojo...[K] Pero no es buena idea."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="To begin with, the dojo doesn't\nhave a sign. Instead, I'll give you this!", french="Déjà, le dojo n'a même pas\nd'insigne! Alors laissez-moi vous remettre\nceci!", german="Zumal das Dojo gar kein Zeichen\nhat. Ich gebe euch stattdessen das hier!", italian="Il dojo non ce l'ha nemmeno,\nl'insegna... vi darò questo!", spanish="Sobre todo porque mi dojo\nni siquiera tiene emblema. No... ¡Creo que\nserá mejor que os ofrezca esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CN] Excellent! [hero] obtained a\n[CN][CS:I]Joy Seed[CR]!", french="[CN]Excellent! [hero] obtient\n[CN]une [CS:I]Allégraine[CR]!", german="[CN] Ausgezeichnet! [hero] erhält einen\n[CN][CS:I]Lv.+ Samen[CR]!", italian="[CN]Eccellente! [hero] ottiene un\n[CN][CS:I]Gaudioseme[CR]!", spanish="[CN]¡Excelente! ¡[hero] obtuvo una\n[CN][CS:I]Sem. Júbilo[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 89, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="That's my personal treasure![K]\nYou're more than welcome to it!", french="C'est mon trésor personnel![K]\nJe vous en prie, acceptez-le, c'est un immense\nhonneur pour moi!", german="Das ist mein Schatz![K]\nIch überlasse ihn euch gerne!", italian="È il mio tesoro personale![K]\nVe lo do volentieri!", spanish="¡Ese es mi tesoro![K]\n¡Creo que os lo merecéis!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="But don't let this be the end!\nYou'll keep training here, won't you?", french="J'espère que ce n'est pas\nterminé! Vous allez continuer à vous\nentraîner ici, pas vrai?", german="Ich hoffe doch, dies ist kein\nLebewohl! Ihr werdet hier weiterhin\ntrainieren, nicht wahr?", italian="Ma non dovete smettere!\nContinuerete ad allenarvi qui, vero?", spanish="¡Pero esto no tiene por qué\nacabar aquí! Seguiréis entrenando en\nmi dojo, ¿verdad?"})
  -- message_Close
  end
  elseif __sw == 181 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[15] = 0 -- $SCENARIO_MAIN_BIT_FLAG[15] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 182 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[16] = 0 -- $SCENARIO_MAIN_BIT_FLAG[16] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 183 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[17] = 0 -- $SCENARIO_MAIN_BIT_FLAG[17] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 184 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[18] = 0 -- $SCENARIO_MAIN_BIT_FLAG[18] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 185 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[19] = 0 -- $SCENARIO_MAIN_BIT_FLAG[19] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 186 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[20] = 0 -- $SCENARIO_MAIN_BIT_FLAG[20] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 187 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[21] = 0 -- $SCENARIO_MAIN_BIT_FLAG[21] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 188 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[22] = 0 -- $SCENARIO_MAIN_BIT_FLAG[22] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 189 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[23] = 0 -- $SCENARIO_MAIN_BIT_FLAG[23] = 0 (ROM)
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  else
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[M:D2][CS:C]Debug: What would\nyou like to do?[CR]", french="[M:D2][CS:C]Debug: What would\nyou like to do?[CR]", german="[M:D2][CS:C]Debug: What would\nyou like to do?[CR]", italian="[M:D2][CS:C]Debug: What would\nyou like to do?[CR]", spanish="[M:D2][CS:C]Debug: What would\nyou like to do?[CR]"})
  do local __choice = SkySceneKit.ask({{english="Trust your own luck.", french="Trust your own luck.", german="Trust your own luck.", italian="Trust your own luck.", spanish="¡Veamos si la suerte me acompaña!"}, {english="Cheat.", french="Cheat.", german="Cheat.", italian="Cheat.", spanish="¡Prefiero hacer trampas!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[M:D2][CS:C]Debug: What's your\nchoice?[CR]", french="[M:D2][CS:C]Debug: What's your\nchoice?[CR]", german="[M:D2][CS:C]Debug: What's your\nchoice?[CR]", italian="[M:D2][CS:C]Debug: What's your\nchoice?[CR]", spanish="[M:D2][CS:C]Debug: What's your\nchoice?[CR]"})
  do local __choice = SkySceneKit.ask({{english="Success.", french="Success.", german="Success.", italian="Success.", spanish="Éxito"}, {english="All success.", french="All success.", german="All success.", italian="All success.", spanish="Éxito en todo"}, {english="Failure.", french="Failure.", german="Failure.", italian="Failure.", spanish="Fracaso"}, {english="Success on legend.", french="Success on legend.", german="Success on legend.", italian="Success on legend.", spanish="Éxito en leyenda"}, {english="Success on all legends.", french="Success on all legends.", german="Success on all legends.", italian="Success on all legends.", spanish="Éxito en todas las leyendas"}, {english="Failure on legend.", french="Failure on legend.", german="Failure on legend.", italian="Failure on legend.", spanish="Fracaso en leyenda"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 6 then
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  else
  -- back_ChangeGround(LEVEL_T01P03A2) [décor déjà chargé par EnterZone PMDO]
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
