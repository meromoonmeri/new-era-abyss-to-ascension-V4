-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m23a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 1 -- dungeon_mode(35) = DMODE_OPEN (ROM)
  SkyProg.set(24, 1) -- $SCENARIO_MAIN = scn[24,1] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem![K] And so, as you're all quite\nwell aware...", french="Hum![K] Ainsi donc, comme vous\nle savez tous déjà...", german="Ähem![K] Und deshalb, wie ihr euch\nalle wohl bewusst seid...", italian="Ehm![K] E così, sapete quasi tutti\nche...", spanish="¡Ejem![K]\nSupongo que todos sabéis ya que..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster has not yet returned\nfrom his errand.", french="... le Maître de la Guilde n'est\npas encore revenu.", german="Deshalb ist der Gildenmeister\nnoch nicht von seinem Gang zurück.", italian="... il Capitano non è ancora\ntornato.", spanish="El Gran Bluff todavía no\nha regresado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="However, I intend to set off for\n[CS:P]Brine Cave[CR] as scheduled.", french="Cependant, j'ai l'intention de\npartir pour la [CS:P]Caverne Saline[CR] comme prévu.", german="Trotzdem habe ich die Absicht,\nwie vorgesehen zur [CS:P]Salzwasserhöhle[CR]\naufzubrechen.", italian="Comunque, voglio che ci\nmettiamo in cammino verso la [CS:P]Grotta[CR]\n[CS:P]Salmastra[CR] come da programma.", spanish="Sin embargo, mi grupo partirá\na la [CS:P]Cueva Aguamar[CR] como estaba previsto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Where'd Guildmaster\ngo, anyway?", french="Eh dis donc, il est parti où\nle Maître de la Guilde, au fait?", german="Hey, hey! Wo wollte der\nGildenmeister überhaupt hingehen?", italian="Ehi, ehi! Ad ogni modo, dove\nsarà andato il Capitano?", spanish="¡Oye, oye! ¿Y adónde se supone\nque ha ido el Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Um...I wouldn't know that...", french=" Hmm... je n'en ai aucune idée...", german="Ähm... Woher sollte ich das\nwissen...", italian=" Uhm... Non saprei...", spanish="Hum... Eso es algo que\ndesconozco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Is it going to be OK without the\nGuildmaster?", french="Est-ce qu'on va s'en sortir\nsans lui?", german="Können wir das ohne den\nGildenmeister machen?", italian="Andrà tutto bene senza il\nCapitano?", spanish="¿No ocurrirá nada si vamos sin\nel Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No problem! There's no need for\nyour concern at all!", french="Pas de problème! Il n'y a aucune\ninquiétude à avoir!", german="Kein Problem! Es gibt überhaupt\nkeinen Grund für eure Bedenken!", italian="Nessun problema! Non c'è\nbisogno che vi preoccupiate!", spanish="¡Claro que no!\nNo tenéis que preocuparos en absoluto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster must have decided\nthat we can manage on our own without him\nfor the time being.", french="Le Maître de la Guilde a dû\npenser qu'on pouvait se débrouiller tout seuls\npour l'instant.", german="Der Gildenmeister muss\nentschieden haben, dass wir bis auf Weiteres\nauch ohne ihn auskommen.", italian="Il Capitano avrà deciso che per\nora ce la possiamo cavare senza di lui.", spanish="El Gran Bluff debe de haber\ndecidido que en esta ocasión podremos\napañárnoslas sin él."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's why he hasn't come home\nyet.", french="C'est pourquoi il n'est pas encore\nrentré.", german="Darum ist er bis jetzt nicht\nnach Hause gekommen.", italian="È per questo che non è ancora\ntornato.", spanish="Por eso todavía no habrá vuelto\na casa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Furthermore...[K]in the place of\nour absent Guildmaster...", french="De plus...[K] pendant l'absence\nde notre Maître...", german="Außerdem habt ihr...[K] in\nAbwesenheit unseres Gildenmeisters...", italian="Inoltre...[K] data l'assenza del\nCapitano...", spanish="Además...[K] En ausencia del\nGran Bluff..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You have me to lead you!", french="... vous pouvez compter sur moi\npour vous guider!", german=" Mich! Ich kann euch anführen.", italian=" ... sarò io a guidarvi!", spanish=" Me tenéis a mí para guiaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ... ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" ....................................", french=" ....................................", german=" ....................................", italian=" ....................................", spanish=" ... ... ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Uh...[K] Why isn't anyone saying\nanything?", french="Euh...[K] pourquoi ce silence\nassourdissant?", german="Öh...[K] Warum sagt denn niemand\netwas?", italian=" Uh...[K] Perché non dite nulla?", spanish="Esto...[K]\n¿Por qué nadie dice nada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It...[K]it can't be!", french="Je...[K] je n'en crois pas\nmes oreilles!", german=" Das...[K] Das kann nicht wahr sein!", italian=" Non...[K] può essere!", spanish=" No...[K] ¡No puede ser!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Do you all think that I'm not up\nto the task?", french="Vous pensez tous que je ne suis\npas à la hauteur?", german="Glaubt ihr alle, ich wäre dazu\nnicht in der Lage?", italian="Pensate che io non sia\nall'altezza del compito?", spanish="¿No creéis que yo esté a\nla altura de semejante misión?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" E-everyone! Out with it!", french=" Allez! Dites-le!", german=" L-leute! Raus mit der Sprache!", italian=" Ehi! Sputate il rospo!", spanish=" ¡Venga! ¡Decídmelo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Am I perhaps...perhaps...", french=" Peut-être me jugez-vous...", german=" Bin ich vielleicht... vielleicht...", italian=" Forse... mi ritenete...", spanish=" ¿Quizás me consideráis...?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Inadequate? Worthless to you?!", french=" Incompétent? Inutile?!", german="Unzulänglich? Oder erscheine ich\neuch gar als nutzlos?", italian="Pensate che sia inadeguato?\nNon valgo niente per voi?!", spanish="¿Un incapaz?\n¿Muy poca cosa para vosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Uh, nope.[K] I wouldn't say that,\nby golly.", french="Euh, nan.[K] C'est pas c'que\nj'dirais, pour sûr.", german="Äh, nein.[K] Das würde ich nicht\nsagen, Donnerwetter.", italian=" Oh, no.[K] Non direi, ohibò.", spanish="Esto... No, señor.[K]\nTampoco diría eso, vaya."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="When Guildmaster isn't here,\nit just feels less safe.", french="C'est juste que je me sens moins\nen sécurité en l'absence du Maître\nde la Guilde.", german="Wenn der Gildenmeister nicht\nhier ist, fühle ich mich weniger sicher.", italian="È solo che quando il Capitano\nnon c'è, ci sentiamo meno sicuri.", spanish="Lo que pasa es que cuando\nel Gran Bluff no está, es como si todo\nfuera menos seguro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! You know the\nGuildmaster! He's hard to figure out...", french="Eh dis donc, vous connaissez\nle Maître! Il est assez imprévisible...", german="Hey, hey! Ihr kennt den\nGildenmeister! Er ist schwer zu\ndurchschauen...", italian="Ehi, ehi! Conosci il Capitano!\nÈ difficile prevedere...", spanish="¡Oye, oye! ¡Ya conocéis al Gran\nBluff! Es difícil saber qué piensa..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But, hey, hey! He really comes\nthrough when things get rough!", french="Pourtant, dis donc, il est\ntoujours là quand on a besoin de lui!", german="Aber, hey, hey! Er wird sich\nschon zeigen, wenn die Dinge schwierig\nwerden!", italian="Ma, ehi, ehi! Sicuramente ci\nraggiungerà quando le cose si faranno difficili!", spanish="Pero... ¡oye, oye!\n¡Cuando hay problemas siempre cumple!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="But the Guildmaster isn't with\nus right now, so...", french="Mais pour l'instant, il n'est pas\nà nos côtés, donc...", german="Aber der Gildenmeister ist jetzt\nnicht hier, und daher...", italian="Ma ora il Capitano non è qui con\nnoi, quindi...", spanish="Pero ahora el Gran Bluff no\nestá..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We have to take charge and do\nas he wanted!", french="Il ne nous reste plus qu'à\nprendre sur nous et à respecter sa décision!", german="Daher müssen wir jetzt\nVerantwortung übernehmen und in\nseinem Sinne handeln!", italian="Dobbiamo prendere l'iniziativa\ne fare quello che ci aveva chiesto!", spanish="Así que tendremos que\napañarnos sin él tal como nos pidió."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's right.", french=" Bien dit!", german=" Das stimmt.", italian=" È vero.", spanish=" Es cierto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's right.", french=" Bien dit!", german=" Das stimmt.", italian=" È vero.", spanish=" Es cierto."})
  else
  SkySceneKit.say({english=" That's right.", french=" Bien dit!", german=" Das stimmt.", italian=" È vero.", spanish=" Es cierto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm positive we can get the job\ndone on our own!", french="Je suis sûr qu'on peut mener\nla mission à bien par nous-mêmes!", german="Ich bin zuversichtlich, dass wir\nunsere Aufgabe auch allein erledigen können!", italian="Sono convinto che possiamo\nportare a termine la missione con le nostre\nforze!", spanish="¡Estoy seguro de que podemos\ncumplir solos esta misión!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm sure that we can get the\njob done on our own!", french="Je suis sûr qu'on peut mener\nla mission à bien par nous-mêmes!", german="Ich bin zuversichtlich, dass wir\nunsere Aufgabe auch allein erledigen können!", italian="Sono convinto che possiamo\nportare a termine la missione con le nostre\nforze!", spanish="¡Estoy seguro de que podemos\ncumplir solos esta misión!"})
  else
  SkySceneKit.say({english="I'm sure that we can get the\njob done on our own!", french="Je suis sûre qu'on peut mener\nla mission à bien par nous-mêmes!", german="Ich bin zuversichtlich, dass wir\nunsere Aufgabe auch allein erledigen können!", italian="Sono convinta che possiamo\nportare a termine la missione con le nostre\nforze!", spanish="¡Estoy segura de que podemos\ncumplir esta misión por nuestra cuenta!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go for it on our own!", french=" Allons-y tout seuls!", german=" Machen wir es auf eigene Faust!", italian=" Diamo tutto quello che abbiamo!", spanish=" ¡Armémonos de valor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go for it on our own!", french=" Allons-y tout seuls!", german=" Machen wir es auf eigene Faust!", italian=" Diamo tutto quello che abbiamo!", spanish=" ¡Armémonos de valor!"})
  else
  SkySceneKit.say({english=" Let's go for it on our own!", french=" Allons-y tout seuls!", german=" Machen wir es auf eigene Faust!", italian=" Diamo tutto quello che abbiamo!", spanish=" ¡Armémonos de valor!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You're RIGHT! We can't count on\nthe Guildmaster for everything!", french="BIEN DIT! On ne peut pas\nse reposer sur le Maître tout le temps!", german="Du hast RECHT! Wir können uns\nnicht immer nur auf den Gildenmeister\nverlassen!", italian="Avete RAGIONE! Non possiamo\nsempre fare affidamento sul Capitano!", spanish="¡TIENES RAZÓN! ¡NO PODEMOS\nRECURRIR AL GRAN BLUFF PARA TODO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Oh, yes! That's the spirit!\nLet's do our best!", french="Oh, oui! Voilà un bon état\nd'esprit! Faisons de notre mieux!", german="Oh ja! Richtige Einstellung!\nGeben wir unser Bestes!", italian="Oh, sì! È questo lo spirito\ngiusto! Mettiamocela tutta!", spanish="¡Sí, así es como tenemos que\npensar! ¡Vamos a hacer lo que podamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR].", french=" [CS:N]Pijako[CR].", german=" [CS:N]Plaudagei[CR].", italian=" [CS:N]Chatot[CR].", spanish=" [CS:N]Chatot[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The Guildmaster is absent...[K]\nSo there's only one among us who can lead!", french="En l'absence du Maître...[K]\nil n'y en a qu'un parmi nous qui peut prendre\nles rênes!", german="Der Gildenmeister ist\nabwesend...[K] Es gibt nur einen unter uns,\nder anführen kann!", italian="Il Capitano non c'è...[K] Quindi c'è\nsolo un Pokémon che può guidarci!", spanish="El Gran Bluff no está...[K]\nY solo hay alguien que pueda guiarnos..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" And that's you, [CS:N]Chatot[CR].", french=" Et c'est toi, [CS:N]Pijako[CR].", german=" Und das bist du, [CS:N]Plaudagei[CR].", italian=" E quel Pokémon sei tu, [CS:N]Chatot[CR].", spanish=" Y ese eres tú, [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Huh?[K] Wh-who? Me?", french=" Hein?[K] Qui? Moi?", german=" Wie?[K] W-wer? Ich?", italian=" Eh?[K] C-Chi? Io?", spanish=" ¿Qué?[K] ¿Yo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Of course. You said so earlier.", french=" Bien sûr, tu l'as dit toi-même.", german="Selbstverständlich. Das hast du\ngerade selbst gesagt.", italian=" Certo. Hai detto così prima.", spanish="Por supuesto.\nEs lo que nos dijiste antes."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You said that we'll be fine\nbecause you're here to lead us.", french="Tu as dit que tout se passerait\nbien parce que tu es là pour nous guider.", german="Du sagtest, wir seien auf der\nsicheren Seite, weil du uns führen könntest.", italian="Hai detto che ce l'avremmo fatta\nperché eri qui a guidarci.", spanish="Dijiste que todo iría bien\nporque estabas aquí para guiarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Lead the way! Show us, [CS:N]Chatot[CR]!", french="Sois notre chef! Montre-nous\nla marche à suivre, [CS:N]Pijako[CR]!", german=" Geh voran! Führe uns, [CS:N]Plaudagei[CR]!", italian="Guidaci! Facci vedere come si\nfa, [CS:N]Chatot[CR]!", spanish="¡Así que adelante!\n¡Te seguimos, [CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="That's right! Show us, [CS:N]Chatot[CR]!\nHey, hey!", french="Oui, c'est ça! Montre-nous,\n[CS:N]Pijako[CR]! Eh dis donc!", german="Richtig so! Führe uns, [CS:N]Plaudagei[CR]!\nHey, hey!", italian="È vero! Facci vedere, [CS:N]Chatot[CR]!\nEhi, ehi!", spanish="¡Eso es! ¡Te seguimos, [CS:N]Chatot[CR]!\n¡Oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! I'm counting on you!", french=" Ouaip, j'compte sur toi!", german=" Jawollja! Ich zähle auf dich!", italian=" Sissignore! Conto su di te!", spanish=" ¡Sí, señor! ¡Cuento contigo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Umpf!", italian=" Uh!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(32) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" W-w-well...[K]e-e-everyone...", french=" B-bien...[K] tout le monde...", german=" N-n-nun...[K] L-l-leute...", italian=" B-B-Bene...[K] g-g-gente...", spanish=" Mu... muy bien...[K] To... todos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You can always count on me\nwhen th-th-things are this bad...", french="... Vous... vous pouvez toujours\ncompter sur moi quand les choses tournent\nmal...", german="Ihr könnt immer auf mich\nzählen, wenn die D-dinge so schlecht stehen...", italian="Quando le c-c-cose vanno male\npotete sempre contare su di me...", spanish="Ya sabéis... que podéis contar\nconmigo... en las buenas y en... las malas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What's the matter, [CS:N]Chatot[CR]!\nSound the call to duty already!", french="Qu'est-ce qui t'arrive, [CS:N]Pijako[CR]?!\nQu'est-ce que tu attends pour sonner\nle rassemblement?", german="Was ist los, [CS:N]Plaudagei[CR]?\nGib endlich den Startschuss!", italian="Cosa c'è, [CS:N]Chatot[CR]?!\nDai, chiama tutti al dovere!", spanish="¿Qué te pasa, [CS:N]Chatot[CR]?\n¡Mándanos ahí afuera de una vez!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I know! I know!", french=" Je sais! Je sais!", german=" Ich weiß! Ich weiß!", italian=" Sì, sì.", spanish=" ¡Ya lo sé! ¡Ya lo sé!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Commencing now...", french=" Je me lance...", german=" Ich fange jetzt an...", italian=" A cominciare da subito...", spanish=" ¡Comencemos ya!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We shall depart on a guild\nexploration of [CS:P]Brine Cave[CR]!", french="Nous allons partir explorer\nla [CS:P]Caverne Saline[CR]!", german="Wir werden zu einer Erkundung\nin die [CS:P]Salzwasserhöhle[CR] aufbrechen!", italian="Dobbiamo andare a esplorare\nla [CS:P]Grotta Salmastra[CR]!", spanish="¡Iniciaremos una expedición\ndel [CS:N]Pokégremio[CR] a la [CS:P]Cueva Aguamar[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Everyone![K] Let us excel together!", french="Tous ensemble![K]\nSurpassons-nous!", german="Leute![K] Vollbringen wir\ngemeinsam Großes!", italian="Gente![K] Diamo tutti quanti il\nmeglio!", spanish="¡Escuchadme bien![K]\n¡Debemos sobresalir todos en esta misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(26) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 0 -- $PERFORMANCE_PROGRESS_LIST[5] = 0 (ROM)
  -- worldmap_SetMode(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- worldmap_SetMark(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetMark(36) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(60)
  -- worldmap_MoveCamera(36) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetMessagePlace(36) [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
end
