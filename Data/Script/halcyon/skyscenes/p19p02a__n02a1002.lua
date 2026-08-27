-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P02A/n02a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for object OBJECT_P19P02A4_459
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(3) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(7) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(3) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(7) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(3) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(7) [anim idle native]
    -- MovePositionOffset OBJECT_P19P02A4_459 [cible sans placement SSA zone: déplacement non joué]
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(1) -- hold
  end)
  -- back_SetGround(LEVEL_P19P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(7) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(15) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 112, 192, Direction.Right, "NPC_AAMARUDO")
  GROUND:MoveToPosition(npc_npc_aamarudo, 244, 188, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 244, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wow! Amazing!", french=" Ouah! Incroyable!", german=" Wow! Unglaublich!", italian=" Wow! Grandioso!", spanish=" ¡Guau! ¡Qué pasada!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Secret base! Secret base! ♪", french="Une base secrète!\nUne base secrète! ♪", german="Geheimversteck!\nGeheimversteck! ♪", italian=" Base segreta! Base segreta! ♪", spanish=" ¡Una base secreta! ¡Mola! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Not quite.[K] It's not a secret base, it's just\nmy home...", french="Pas vraiment.[K] Ce n'est pas une base\nsecrète, c'est juste là que j'habite...", german="Eigentlich nicht.[K] Kein Geheimversteck,\neinfach nur mein bescheidenes Zuhause...", italian="Non proprio.[K] Non è una base segreta,\nè solo la mia casa...", spanish="No exactamente.[K] No es ninguna base\nsecreta, solo es el sitio donde vivo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" My name is [CS:N]Armaldo[CR].", french=" Je m'appelle [CS:N]Armaldo[CR].", german=" Mein Name ist [CS:N]Armaldo[CR].", italian=" Il mio nome è [CS:N]Armaldo[CR].", spanish=" Me llamo [CS:N]Armaldo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I used to be an explorer...[K]\nBut not anymore, because of one thing...", french="J'étais explorateur\nen mon temps... [K]Mais j'ai arrêté...", german="Ich war einmal ein Erkunder...[K]\nAber das ist Vergangenheit... Wegen dieser\neinen Sache...", italian="Ero un esploratore, ma... [K]\nè successa una cosa per cui ho smesso...", spanish="Antes era explorador,[K] pero ya no,\npor algo que pasó..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I've taken a break from\nexploring...[K] And so I spend my days here.", french="J'ai laissé les explorations de\ncôté pour l'instant...[K] Alors je passe mes\njournées ici.", german="Ich habe mit dem Erkunden\nvorübergehend aufgehört...[K] Und in der\nZwischenzeit wohne ich hier.", italian="Ora ho deciso di prendermi\nuna pausa...[K] e così trascorro le mie\ngiornate in questo luogo.", spanish="Me he tomado un descanso de las\nexploraciones...[K] Y me paso los días aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So, what's exploring?", french=" Ben, c'est quoi une exploration?", german=" Sag, was ist Erkunden?", italian=" Senti, che cos'è l'esplorazione?", spanish=" ¿Y qué es explorar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Huh?[K] You don't know\nabout exploring?", french="Hein?[K] Tu ne sais pas ce que\nc'est qu'une exploration?", german="Wie bitte?[K] Du weißt nichts über\ndas Erkunden?", italian=" Eh?[K] Non sai cos'è l'esplorazione?", spanish="¿Cómo?[K] ¿Que no sabes\nlo que es explorar?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Exploring is...[K]so much fun...[K]\nIt's incredibly exciting.", french="L'exploration, c'est...[K]\npassionnant...[K] fascinant.", german="Erkunden...[K] macht Spaß...[K]\nEs ist unglaublich aufregend.", italian="L'esplorazione è...[K] divertimento\npuro...[K] Qualcosa di incredibilmente\nemozionante.", spanish="Explorar es...[K] divertidísimo...[K]\nY encima es de lo más emocionante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So much fun...[K]\nIncredibly exciting?", french="Passionnant...[K]\nFascinant?", german="Macht Spaß...[K]\nUnglaublich aufregend?", italian="Divertimento puro...[K]\nIncredibilmente emozionante?", spanish="¿Divertidísimo...[K]\ny de lo más emocionante?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" That's right.", french=" Exactement.", german=" Genau.", italian=" Esatto.", spanish=" Exacto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Distant lands, uncharted\nterritory...", french="Des contrées lointaines, des\nrégions inexplorées...", german="Ferne Länder, unerschlossene\nGebiete...", italian="Terre lontane, territori\ninesplorati...", spanish="Tierras lejanas, lugares\nnunca antes explorados..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You visit many remarkable\nplaces...[K] And solve the mysteries\nyou find there.", french="Tu visites des endroits\nmerveilleux...[K] Et tu résous les énigmes\nque tu y trouves.", german="Man bereist viele beeindruckende\nOrte[K] und enträtselt die Mysterien, die man\ndort entdeckt.", italian="Visitare luoghi meravigliosi...[K]\nE scoprire i misteri che li circondano.", spanish="Se llegan a visitar muchos\nsitios extraordinarios...[K] Y se resuelven\nlos misterios que allí encuentras."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Wirklich?", italian=" Davvero?", spanish=" ¿De verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And you get to bring back\ntreasure and fortune with you.", french="Et tu finis par ramener avec toi\nla fortune et les trésors que tu as amassés.", german="Und von jeder Erkundung bringt\nman Schätze und Erfahrung mit zurück.", italian="E puoi trovare tesori e ricchezze\nfavolose.", spanish="Y además vuelves con tesoros\ny riquezas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh?![K] That's so cool! ♪", french=" Oh?![K] C'est super! ♪", german=" Oh?!?[K] Hört sich super an! ♪", italian=" Oh?![K] È troppo forte! ♪", spanish=" ¡¿Qué?![K] ¡Cómo mola! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And...[K] You have to keep at it,\nworking hard and overcoming difficulties, until\nyou finally achieve your dreams.", french="Et...[K] tu dois t'appliquer,\ntravailler dur et venir à bout des difficultés,\navant de pouvoir enfin réaliser tes rêves.", german="Man muss dranbleiben und immer\nsein Bestes geben.[K] Schwierigkeiten lösen,\nbis man eines Tages seine Träume erfüllt.", italian="E...[K] Devi mettercela tutta,\nlavorando sodo e superando molte difficoltà,\nfino a quando riesci a realizzare i tuoi sogni.", spanish="Y...[K] Hay que ser perseverante,\ntrabajar duro y superar obstáculos hasta\nque logras alcanzar aquello con lo que sueñas."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" For example...", french=" Par exemple...", german=" Ich gebe dir ein Beispiel.", italian=" Ad esempio...", spanish=" Por ejemplo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(40), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9480) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitSe
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-44), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" For example, this secret map.", french="Regarde cette\ncarte secrète...", german=" Diese geheime Karte hier...", italian=" ... questa mappa segreta.", spanish="Un ejemplo claro sería\neste mapa secreto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-12), p.Y+(12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9481) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="[CN][CS:N]Armaldo[CR] handed [CS:Y]Igglybuff[CR]\n[CN]the secret map.", french="[CN][CS:N]Armaldo[CR] donne la carte secrète\n[CN]à [CS:Y]Toudoudou[CR].", german="[CN][CS:N]Armaldo[CR] gibt [CS:Y]Fluffeluff[CR]\n[CN]die geheime Karte.", italian="[CN][CS:N]Armaldo[CR] consegna a [CS:Y]Igglybuff[CR]\n[CN]la mappa segreta.", spanish="[CN][CS:N]Armaldo[CR] ha entregado a [CS:Y]Igglybuff[CR]\n[CN]el mapa secreto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(12), p.Y+(-12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Open it up and have a look.", french=" Ouvre-la et jettes-y un œil.", german="Falte sie auseinander und sieh\nsie dir mal an.", italian=" Aprila e dalle un'occhiata.", spanish=" Ábrelo y échale un vistazo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(25) [anim idle native]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetupOutputAttributeAndAnimation<object OBJECT_P19P02A2_386> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This seems to be a map that\nindicates the location of some treasure...[K]\nStudy it closely.", french="Ça ressemble fort à une carte\nindiquant l'emplacement d'un trésor...[K]\nRegarde-la bien.", german="Sie sieht wie eine Karte aus, auf\nder die Position eines großen Schatzes\nverzeichnet ist...[K] Aber sieh mal ganz genau hin.", italian="Questa mappa sembra indicare\nla posizione di un tesoro...[K] Osservala\nattentamente.", spanish="Parece ser un mapa que indica\ndónde se encuentra un tesoro...[K] Míralo bien."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It doesn't really make sense,\ndoes it?", french="Ça n'a ni queue ni tête,\npas vrai?", german="Diese Zeichen ergeben irgendwie\nkeinen Sinn, nicht wahr?", italian=" Non ha molto senso, vero?", spanish=" No tiene sentido, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If I don't figure out the cipher,\nthen I'll never be able to uncover the\nlocation of the treasure.", french="Si je ne déchiffre pas cette\ncarte, alors je ne pourrai jamais découvrir\noù se cache ce trésor.", german="Solange ich diesen Geheimcode\nnicht knacken kann, werde ich niemals den\ngenauen Ort des Schatzes erfahren.", italian="Se non riesco a decodificarla,\nnon riuscirò mai a scoprire dove si trova\nil tesoro.", spanish="Si no logro descifrarlo, nunca\npodré descubrir dónde se encuentra el tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But you're just a kid, you\nwouldn't know anything about this...", french="Mais tu n'es qu'un enfant,\nces choses-là te dépassent...", german="Aber du bist nur ein Kind,\ndu wirst das kaum verstehen...", italian="Ma tu sei solo un bambino,\nprobabilmente non sai nemmeno\ndi cosa sto parlando...", spanish="Pero solo eres un crío. ¿Qué\nvas a saber tú de esto?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I've been working on this one\nfor a long time, but haven't been able to\nfigure it out yet.", french="Je travaille à déchiffrer cette\ncarte depuis bien longtemps, mais impossible\nd'en percer le secret.", german="Ich habe lange Zeit daran\ngearbeitet, aber es bis heute nicht geschafft,\nden Code zu knacken.", italian="È da un sacco di tempo che\ncerco di capirci qualcosa, ma non sono\nancora riuscito a venirne a capo.", spanish="Llevo mucho trabajando en ello,\npero aún no he logrado descifrarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="However,[K] I'm not giving up!\nI can't!", french="Mais bon,[K] je garde espoir!\nJe ne baisse pas les bras!", german="Wie dem auch sei,[K] ich gebe\nnicht auf! Das kann ich nicht!", italian="Comunque,[K] non mi arrendo!\nNon posso farlo!", spanish="Pese a todo...[K] ¡No voy rendirme!\n¡No podría!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(128) [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(9482) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetPositionMark OBJECT_P19P02A2_386 [cible sans placement SSA zone: placement non joué]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(27) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I know that if I can overcome\nthis challenge, there will be a future!", french="Je sais que si je parviens à\nrelever ce défi, mon avenir est assuré!", german="Wenn ich diese Herausforderung\nbestehe, wird es eine Zukunft für mich geben!", italian="So che se riuscirò a superare\nquesta prova, tutto cambierà in meglio!", spanish="Sé que si consigo superar este\nreto, las cosas mejorarán."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9483) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That's the adventure of\nexploration...", french="C'est là tout ce qui fait le sel\nde l'exploration...", german="Das ist es, was das Erkunden\nausmacht...", italian="È questo lo spirito\ndell'esplorazione...", spanish="En eso consiste la aventura\nde explorar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Its thrill! Its essence!\nIts never-ending attraction!", french="Sa saveur! Son essence!\nSon charme inaltérable!", german="Die Spannung davor! Eine heiße\nSpur zu entdecken und zu verfolgen! Genau das\nmacht das Erkunden so verlockend!", italian="È emozione! È fascino!\nÈ uno spasso senza fine!", spanish="¡Su emoción! ¡Su esencia!\n¡Su encanto sin fin!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...Hey!", french=" ... Hé!", german=" ...Hey!", italian=" ... Ehi!", spanish=" ¡Oye!..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ha ha ha! ♪[K] Burned it,\nburned it! ♪", french="Ha ha ha! ♪[K] Brûle,\nbrûle, petite carte! ♪", german="Hahaha! ♪[K] Angekokelt,\nangekokelt! ♪", italian="Ah ah ah! ♪[K] L'ho bruciata,\nl'ho bruciata! ♪", spanish=" ¡Ji, ji! ♪[K] ¡Se quema, se quema! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="H-hey! Junior![K] What are you\ndoing?! Knock it off!", french="Hé! Oh! Petit![K] Qu'est-ce que\ntu fais?! Lâche ça!", german="H-hey! Junior![K] Was machst du\ndenn?!? Hör auf damit!", italian="E-Ehi! Piccolo![K] Che stai\nfacendo?! Piantala!", spanish="¡Eh, peque![K] ¡¿Pero qué haces?!\n¡Para ya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 260, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetupOutputAttributeAndAnimation<object OBJECT_P19P02A2_386> [prop décor NDS, rendu du ground]
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetupOutputAttributeAndAnimation<object OBJECT_P19P02A2_386> [prop décor NDS, rendu du ground]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(50)
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P19P02A2_386) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetAnimation(25) [anim idle native]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- Destroy() [neutre/état moteur]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="Hot hot hot hot hot hot hot hot!", french="Ouille ouille ouille! Chaud devant!", german="Heiß heiß heiß heiß heiß heiß heiß heiß heiß!", italian="BruciaBruciaBruciaBruciaBrucia!", spanish=" ¡Ay, quema, quema, quema!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Hot hot hot hot HOT hot hot hot hot HOT HOT\nHOT hot hot hot hot hot hot HOT HOT HOT HOT\nHOT HOT HOT hot hot HOT HOT HOT HOT!!", french="C'est CHAUD c'est chaud c'est chaud\nc'est chaud c'est CHAUD c'est chaud\nc'est chaud c'est CHAUD CHAUD CHAUD!", german="Heiß heiß heiß heiß heiß heiß heiß heiß heiß\nheiß heiß heiß heiß heiß heiß heiß heiß heiß\nheiß heiß heiß heiß heiß heiß heiß heiß heiß!", italian="BRUCIABruciaBruciaBruciaBruciaBRUCIA\nBRUCIABruciaBruciaBruciaBRUCIABrucia\nBRUCIABRUCIABRUCIABruciaBRUCIA!!!", spanish="¡¡Quema, quema, quema, quema,\nquema, quema, quema, quema, quema, quema,\nquema, quema, quema, quema, quemaaa!!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(5) [neutre/état moteur]
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetAnimation(6) [anim idle native]
  -- SetAnimation(47) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Water![K] WATER!", french=" De l'eau![K] DE L'EAU!", german=" Wasser![K] WASSER!", italian=" Acqua![K] ACQUA!", spanish=" ¡Agua![K] ¡Aguaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ![K] Oh yeah![CS:M] Water Gun[CR]!!", french=" ![K] Ah, oui! [CS:M]Pistolet à O[CR]!!", german=" ...[K]Oh, genau! [CS:M]Aquaknarre[CR]!", italian=" Oh, già![K] [CS:M]Pistolacqua[CR]!!!", spanish=" ¡Ah![K] ¡Claro! ¡[CS:M]Pistola Agua[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2)
  -- supervision_Acting(8) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8)
  -- MovePositionOffset<object OBJECT_P19P02A2_386> [prop décor NDS, géré par le rendu du ground]
  -- supervision_Acting(9) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- Slide2PositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS, géré par le rendu du ground]
  -- GAP: se_Play(9484) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(false, 15)
  -- supervision_RemoveActing(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="[CN]Ssssssssssssssssss...", french="[CN]Pshhhhhhhhhhhhhhhh...", german="[CN]Tzzzzzzzzzzzsch...", italian="[CN]Ssssssssssssssssss...", spanish="[CN]Ssssssssssssssssss..."})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(10) [neutre/état moteur]
  -- SetPositionMark OBJECT_P19P02A3_387 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(19) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Ah oh...[K] Ah oh...", french=" Holà...[K] holà-là...", german=" Oh ha...[K] Oh ha...", italian=" Ah oh...[K] Ah oh...", spanish=" No es posible...[K] No puede ser..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" My...[K] My precious secret map...", french="Ma...[K] ma précieuse\ncarte secrète...", german="Meine...[K] Meine wertvolle\ngeheime Karte...", italian="La mia...[K] La mia preziosa mappa\nsegreta...", spanish=" Mi...[K] Mi valioso mapa secreto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" It's...[K] It's charred...", french=" Elle...[K] elle est carbonisée...", german=" Völlig...[K] Völlig verkohlt...", italian=" È...[K] carbonizzata...", spanish=" Está...[K] churruscado del todo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Look! ♪", french=" Regardez! ♪", german=" Sieh mal! ♪", italian=" Guarda! ♪", spanish=" ¡Mira! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Eh?", spanish=" ¿El qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Underneath the charred parts...[K]\nYou can see something. ♪", french="Sous les parties carbonisées...[K]\nOn voit quelque chose. ♪", german="Unter den angekokelten Teilen...[K]\nDa ist noch etwas. ♪", italian="Sotto la parte bruciata...[K]\nC'è qualcosa. ♪", spanish="Bajo las zonas carbonizadas...[K]\nse ve algo. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you brush away the charred\nparts, can you see anything special?", french="Si on enlève les morceaux\ncarbonisés, vous ne voyez pas quelque chose\nde spécial?", german="Wenn du die schwarzen Teile\nwegwischst, ist da nicht etwas Besonderes?", italian="Se tolgo le parti bruciacchiate,\nriesci a vedere qualcosa di speciale?", spanish="Si retiras las partes carbonizadas,\n¿no ves algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:Y]Igglybuff[CR]\n[CN]brushed away the charred parts of the map.", french="[CN][CS:Y]Toudoudou[CR] enlève les parties\n[CN]carbonisées de la carte.", german="[CN][CS:Y]Fluffeluff[CR] wischt die\n[CN]schwarzen Teile der Karte zur Seite.", italian="[CN][CS:Y]Igglybuff[CR] toglie le parti\n[CN]bruciate della mappa.", spanish="[CN][CS:Y]Igglybuff[CR] retira\n[CN]las partes carbonizadas del mapa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P19P02A3_387) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Wh-what?", french=" Que... quoi?", german=" W-was?", italian=" C-Cosa?", spanish=" ¿Có... cómo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_RemoveActing(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetPositionMark OBJECT_P19P02A2_386 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]Right here...[K] Isn't there\nsomething written here? Right, written! ♪", french="...[K] Juste là...[K] Il n'y a pas\nquelque chose d'écrit ici? Mais oui, quelque\nchose d'écrit! ♪", german="...[K]Genau hier...[K] Steht da nicht\netwas geschrieben? Genau, geschrieben! ♪", italian="...[K] Proprio qui...[K] Non c'è scritto\nqualcosa qui? Sì, qui, qui! ♪", spanish="Aquí...[K] Justo aquí...[K] ¿No hay algo\nescrito? ¡Sí, justo aquí! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="[CS:P]Eastern[CR]...[K] [CS:P]Ca[CR]...[CS:P]ve[CR]...[K]\n[CS:P]Eastern Cave[CR]?!", french="[CS:P]Ca[CR]... [K][CS:P]verne[CR]... [CS:P]de[CR]...[K]\n[CS:P]Caverne de l'Est[CR]?!", german="[CS:P]Östliche[CR]...[K] [CS:P]Höh[CR]...[CS:P]le[CR]...[K]\n[CS:P]Östliche Höhle[CR]?!?", italian="[CS:P]Grotta[CR]...[K] [CS:P]Orien[CR]... [CS:P]tale[CR]...[K]\n[CS:P]Grotta Orientale[CR]?!", spanish="[CS:P]Cueva[CR]...[K] [CS:P]Orien[CR]... [CS:P]tal[CR]...[K]\n¡¿[CS:P]Cueva Oriental[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="R-really?![K] Is it true there's\ntreasure there?!", french="V-vraiment?![K] Il y a\nvraiment un trésor là-bas?", german="W-wirklich?!?[K] Kann es sein,\ndass dort ein Schatz versteckt ist?!?", italian="S-Sul serio?![K] C'è davvero\nun tesoro laggiù?!", spanish="¡¿En... En serio?![K] ¡¿De veras\nhay un tesoro ahí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep![K]\nI knew it! ♪[K] Ha ha ha! ♪", french="Voui![K]\nJe le savais! ♪[K] Ha ha ha! ♪", german="Ja, genau![K] Ich wusste es! ♪[K]\nHahaha! ♪", italian="Sì![K]\nLo sapevo! ♪[K] Ah ah ah! ♪", spanish=" ¡Sí![K] ¡Lo sabía! ♪[K] ¡Ja, ja, ja! ♪"})
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That is...[K] How did you know?\nHow did you figure out this map's secret?", french="Mais enfin...[K] Comment\npouvais-tu le savoir? Comment as-tu\npercé le secret de cette carte?", german="Das ist ja...[K] Aber wie kamst du...\nWie kamst du hinter das Geheimnis der Karte?", italian="Ma...[K] Come facevi a saperlo?\nCome hai fatto a capire il segreto\ndi questa mappa?", spanish="Pero...[K] ¿Cómo lo has sabido?\n¿Cómo se te ha ocurrido la forma\nde descifrar el mapa secreto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="When I looked at the map, I\nsaw it was really thick.", french="Quand j'ai regardé la carte, j'ai\nvu qu'elle était épaisse.", german="Als ich mir die Karte ansah,\nbemerkte ich, dass sie ziemlich dick war.", italian="Quando l'ho guardata, ho visto\nche era molto spessa.", spanish="Al ver el mapa me fijé en que\nera muy grueso."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So I figured that there must be\ntwo layers to it.", french="Alors je me suis dit qu'il devait\ny avoir deux couches.", german="Also dachte ich mir, dass die\nKarte wohl zwei Lagen haben muss.", italian="Così ho pensato che potessero\nesserci due strati.", spanish="Así que supuse que debía de\ntener dos capas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But I didn't think there was any\nother way to peel off the top layer.", french="Mais je n'avais pas de solution\npour détacher la première couche.", german="Aber ich sah keine Möglichkeit,\ndie obere Lage zu entfernen.", italian="Solo che non mi è venuta in\nmente nessun'altra idea per togliere\nlo strato superiore.", spanish="Pero no se me ocurría ninguna\notra forma de quitar la capa superior."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So I thought I'd burn it off! ♪", french="Alors j'ai juste décidé\nde la carboniser! ♪", german=" Also dachte ich an Kokeln! ♪", italian=" Così ho pensato di bruciarlo! ♪", spanish=" ¡Así que la quemé! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ... (Th-this kid...)", french=" ... (C-ce gamin...)", german=" ...(D-dieses Kind...)", italian=" ... (Q-Questo bambino...)", spanish=" Hum... (Qué... Qué crío...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(I've been working on that\npuzzle for so long, and he solved it,\njust like that...)", french="(Je travaille sur cette énigme\ndepuis des lustres, et lui, il arrive et la\nrésout comme si de rien n'était...)", german="(Ich habe mir so lange darüber\nden Kopf zerbrochen und dieser kleine Racker\nlöst das Rätsel einfach so.)", italian="(È da un sacco di tempo che\ncerco di risolvere questo enigma e lui ha\ntrovato la soluzione in un lampo...)", spanish="(Con la de tiempo que llevo\nintentando resolver ese acertijo, y va él y\nlo resuelve sin despeinarse...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(That is, this kid...[K]\nJust like that...)", french="(Je veux dire, ce gamin...[K]\ncomme si de rien n'était...)", german="(Also, dieses Kind...[K]\nEinfach so...)", italian="(Già, questo bambino...[K]\nincredibile...)", spanish=" (Vaya con el crío.[K] Ni se ha inmutado.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey, if you go to this\n[CS:P]Eastern Cave[CR], would you find treasure there?", french="Eh dites, si vous allez à cette\n[CS:P]Caverne de l'Est[CR], vous allez dégoter des\ntrésors là-bas?", german="Und wenn du jetzt zur\n[CS:P]Östlichen Höhle[CR] aufbrichst, wirst du dort den\nSchatz finden?", italian="Ehi, se vai in questa [CS:P]Grotta[CR]\n[CS:P]Orientale[CR], ci troverai un tesoro?", spanish="Oye, si vas a la [CS:P]Cueva Oriental[CR]\nesa, ¿habrá algún tesoro?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Please take me with you! ♪[K]\nI want to go and see! ♪", french="Amenez-moi avec vous,\ns'il vous plaît! ♪[K] Je veux y aller,\nje veux voir ça! ♪", german="Bitte nimm mich mit dir mit! ♪[K]\nIch möchte mitkommen! Mitkommen! ♪", italian="Per favore, portami con te! ♪[K]\nVoglio vederlo anch'io! ♪", spanish="¡Porfi, llévame contigo! ♪[K]\n¡Quiero verlo yo también! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="B-but I'm...[K]\nI'm a retired explorer...", french="M-mais voyons, je...[K]\nje suis un explorateur à la retraite...", german="A-aber ich...[K]\nIch bin ein Erkunder im Ruhestand...", italian="M-Ma io...[K]\nIo sono un esploratore in pensione...", spanish="Pe... pero...[K]\nSoy un explorador retirado..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I can't just jump back in...", french="Je ne peux pas me lancer\ncomme ça dans une nouvelle...", german=" Ich kann doch nicht so einfach...", italian="Non posso ricominciare\nl'attività...", spanish="No puedo volver a ejercer\ncomo si nada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh? But don't you\nlike exploring?", french="Ah? Mais vous n'aimez pas ça,\nles explorations?", german="Wieso? Magst du es etwa doch\nnicht, auf Erkundung zu gehen?", italian="Eh? Ma non hai detto che\nti piace esplorare?", spanish="¿Eh? ¿Es que no te gusta\nexplorar?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I mean... Earlier, it sounded like\nyou really enjoyed talking about it.", french="Enfin... Tout à l'heure vous aviez\nvraiment l'air enthousiaste en en parlant.", german="Weil... Vorhin klang es so, als\nob du wirklich gerne davon sprachst.", italian="Insomma... Prima sembrava che\nfossi entusiasta quando ne parlavi.", spanish="Porque... antes parecía que\nte gustaba mucho hablar del tema."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And you were working so hard\non the secret of that map...", french="Et vous avez travaillé si dur\npour percer le secret de cette carte...", german="Und du hast so viel Zeit mit\ndem Rätsel der Karte verbracht...", italian="E hai faticato così tanto per\nscoprire il segreto di quella mappa...", spanish="Y estabas trabajando sin descanso\nen descifrar el secreto de ese mapa..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you don't go, it will\nbe a waste! ♪", french="Avec tout ça, si vous n'y alliez\npas, ce serait trop bête! ♪", german="Was für eine Verschwendung,\nwenn du jetzt nicht gehst! ♪", italian="Se non ci vai, avrai sprecato\ntutto questo tempo per niente! ♪", spanish=" ¡Si no vas será un desperdicio! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetPositionMark OBJECT_P19P02A2_386 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ... (Th-that's...)", french=" ... (C'est... c'est...)", german=" ...(D-das ist...)", italian=" ... (Q-Questo...)", spanish=" Hum... (Es...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(It's true that it would be a\nwaste not to go after solving the\nmap's riddle...)", french="(C'est vrai que ce serait bête\nde ne pas y aller maintenant que l'énigme\nde la carte est résolue...)", german="(Es wäre wirklich schade, nicht\nzu gehen, jetzt, wo das Geheimnis der Karte\ngelöst wurde.)", italian="(È vero che sarebbe uno spreco\nse non cercassi il tesoro dopo aver risolto\nl'enigma della mappa...)", spanish="(Es cierto que desperdiciaría\nuna gran oportunidad ahora que ya se ha\nresuelto el acertijo del mapa...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(But I'm hesitant to\nleave here...)", french="(Mais j'hésite à quitter\ncet endroit...)", german="(Aber ich zögere, diesen Ort zu\nverlassen...)", italian="(Ma non me la sento\ndi abbandonare questo posto...)", spanish="(Pero no tengo claro si\ndebería marcharme...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(Maybe I wouldn't attract too\nmuch attention with a little trip to\n[CS:P]Eastern Cave[CR].)", french="(Peut-être qu'une petite\nexcursion à la [CS:P]Caverne de l'Est[CR] n'attirera\npas trop l'attention sur moi.)", german="(Obwohl... Eine kleine Erkundung\nder [CS:P]Östlichen Höhle[CR] sollte nicht zu viel\nAufmerksamkeit auf mich lenken.)", italian="(Però forse non attirerei troppo\nl'attenzione facendo un viaggetto fino\nalla [CS:P]Grotta Orientale[CR].)", spanish="(Quizá no llamara demasiado\nla atención con un breve viaje a la\n[CS:P]Cueva Oriental[CR].)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" (All right!)", french=" (Soit!)", german=" (Na gut!)", italian=" (E va bene!)", spanish=" (¡Ya está, decidido!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(90)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Hey, Junior.", french=" Hé, petit.", german=" Hey, Junior.", italian=" Ehi, piccolo.", spanish=" Oye, peque."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You made a good point.[K]\nWe'll go!", french="Tu m'as convaincu.[K]\nOn va y aller!", german="Du hast recht mit dem, was du\nsagst.[K] Lass uns auf Erkundung gehen!", italian="Hai ragione.[K] Ho deciso\nche andremo!", spanish=" Tienes toda la razón.[K] ¡Iremos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" R-really?", french=" V-vraiment?", german=" W-wirklich?", italian=" D-Davvero?", spanish=" ¿En... En serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Yes, really.", french=" Oui, vraiment.", german=" Ja, wirklich.", italian=" Sì, davvero.", spanish=" Sí, en serio."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="But it's a little too late to start\ntoday.[K] Your mom and dad are probably worried.", french="Mais il est un peu tard pour se\nmettre en route aujourd'hui.[K] Tes parents\ndoivent déjà s'inquiéter...", german="Aber es ist ein wenig zu spät,\num heute noch aufzubrechen.[K] Deine Eltern\nmachen sich womöglich Sorgen.", italian="Ma oggi si è fatto troppo tardi.[K]\nI tuoi genitori saranno in pensiero.", spanish="Pero hoy se nos ha hecho tarde\npara empezar.[K] Tus padres estarán preocupados."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Today, you should go on home...", french="Tu devrais rentrer à\nla maison...", german="Für heute solltest du\nnach Hause gehen.", italian="Ora è meglio che tu vada\na casa...", spanish=" Hoy deberías irte a casa..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Tomorrow, we'll head out.", french=" On partira demain.", german="Morgen machen wir uns auf\nden Weg.", italian=" Domani ci metteremo in viaggio.", spanish=" Iremos mañana."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪[K] Thank you! ♪", french=" Voui! ♪[K] Merci! ♪", german="Au ja! ♪[K]\nPrima, ich danke dir! ♪", italian=" Sì! ♪[K] Grazie! ♪", spanish=" ¡Vale! ♪[K] ¡Gracias! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="All right! Let's do our best\ntomorrow. ♪[K] Yeah! ♪", french="Très bien! On va faire de notre\nmieux demain. ♪[K] Youhou! ♪", german="Sehr schön! Lass uns morgen\nunser Bestes geben. ♪[K] Juchhu! ♪", italian="Bene! Faremo del nostro meglio\ndomani. ♪[K] Sì! ♪", spanish="¡Muy bien! Pues mañana iremos\na darlo todo. ♪[K] ¡Bieeen! ♪"})
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
