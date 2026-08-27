-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/n06a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_RANDOM_DUNGEON_THEME3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D55P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_metamon_otachi = SkySceneKit.spawn_npc("sentret", 312, 192, Direction.Up, "NPC_METAMON_OTACHI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 312, 352, Direction.Up, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 240, 360, Direction.Up, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nokotchi = SkySceneKit.spawn_npc("dunsparce", 216, 224, Direction.UpRight, "NPC_NOKOTCHI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_buubaan = SkySceneKit.spawn_npc("magmortar", 280, 216, Direction.Up, "NPC_BUUBAAN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_nokutasu = SkySceneKit.spawn_npc("cacturne", 336, 216, Direction.UpLeft, "NPC_NOKUTASU")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_saanaito, 312, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 240, 252, false, 2)
  GROUND:MoveToPosition(hero, 276, 252, false, 2)
  pcall(function() GAME:MoveCamera(276, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Aah![K] Is everyone over there\nan explorer?!", french="Aah![K] Ce sont tous des\nexplorateurs, vous croyez?!", german=" Oha![K] Sind das alles Erkunder?!?", italian="Aaah![K] Sono tutti esploratori\nquesti?!", spanish="¡Anda![K] ¡¿Todos esos\nson exploradores?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Probably.", french=" Probablement.", german=" Vielleicht.", italian=" Probabilmente.", spanish=" Probablemente."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Everyone's gathered, aiming for\nthe treasure at the depths of the quarry.", french="Evidemment, ils ont tous\nrappliqué ici à la recherche du trésor.", german="Die haben sich alle getroffen,\num den Schatz aus dem Steinbruch zu heben.", italian="Si saranno riuniti qui\nper cercare il tesoro nascosto\nnelle profondità della cava.", spanish="Por lo visto todo el mundo\ntiene en mente el tesoro."})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_nokotchi, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokotchi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english="Wow! ♪[K]\nPretty ladies! [M:H8]", french=" Waouh! ♪[K] Quels canons! [M:H8]", german="Wow! ♪[K] Was für reizende\nDamen! [M:H8]", italian=" Wow! ♪[K] Ehi, bellezze! [M:H8]", spanish=" ¡Guau! ♪[K] ¡Qué bellezones! [M:H8]"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_buubaan, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_herugaa = SkySceneKit.spawn_npc("houndoom", 240, 184, Direction.Up, "NPC_HERUGAA")
  GROUND:EntTurn(npc_npc_herugaa, Direction.Down)
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_nokutasu, Direction.DownLeft)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_metamon_otachi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="Oh...[K] Are you ladies an\nexploration team too?", french="Oh...[K] Mesdames, vous faites\npartie d'une équipe d'exploration, vous aussi?", german="Oh...[K] Seid ihr Damen auch ein\nErkundungsteam?", italian="Oh...[K] Anche voi siete\nuna squadra d'esplorazione?", spanish="Anda...[K] ¿Vosotras también\nformáis un equipo explorador, chicas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herugaa) end)
  SkySceneKit.say({english="You look way...too delicate to\nbe an exploration team.", french="Vous semblez bien trop...\ndélicates pour ça.", german="Ihr seht viel zu... zart aus, um\nein wahres Erkundungsteam zu sein.", italian="Mi sembrate un po' troppo...\ndelicate per fare le esploratrici.", spanish="Parecéis demasiado... finas\npara una tarea tan tosca."})
  pcall(function() UI:SetSpeaker(npc_npc_herugaa) end)
  SkySceneKit.say({english="This is too difficult for\nyou girls.[K] You should give up.", french="Les filles ne sont pas de taille.[K]\nVous feriez mieux de laisser tomber.", german="Das ist doch zu schwierig für\nMädchen.[K] Ihr solltet besser aufgeben.", italian="Non è roba per voi, ragazze.[K]\nFareste meglio a tornarvene a casa.", spanish="Esto es demasiado difícil para\nvosotras.[K] Sería mejor que os olvidarais."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee-hee![K] Thanks for\nthe advice...[K] But...", french="Hi hi![K] Merci pour le conseil...[K]\nMais...", german="Hihi![K] Danke für den Rat...[K]\nDu meinst es sicherlich gut...", italian=" Ih ih![K] Grazie del consiglio...[K] Ma...", spanish="¡Ji, ji![K] Pues gracias por\nel consejo...[K] Pero..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's not good to judge others by\ntheir appearance. [M:H8]", french="... les apparences sont\ntrompeuses. [M:H8]", german="Aber es ist unfein, nach dem\nÄußeren zu urteilen. [M:H8]", italian="Non lo sai che non bisogna\nmai giudicare qualcuno dalle apparenze? [M:H8]", spanish="No hay que juzgar a nadie por\nlas apariencias. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" S-so[K] cool...", french=" La...[K] classe...", german=" W-wie...[K] schlagfertig...", italian=" S-Sì...[K] Hai proprio ragione...", spanish=" Ay...[K] Me he enamorado..."})
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english="Ummm...\nWhoa... [M:H8]", french=" Hum... Waouh... [M:H8]", german="Ooooh...\nWow... [M:H8]", italian=" Mmmh... Wow... [M:H8]", spanish=" Esto... Uuuf... [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By the way...[K] What's the\nstatus...of the treasure?", french="Au fait...[K] Des nouvelles du...\ntrésor?", german="Apropos...[K] Wie sieht es denn nun\nmit diesem... Schatz aus?", italian="A proposito...[K] A che punto\nsiamo... con il tesoro?", spanish="Por cierto...[K] ¿Qué se sabe...\ndel tesoro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english=" Oh.[K] No one's found it yet.", french="Oh.[K] Personne n'a encore réussi à\nle localiser.", german="Oh.[K]\nDen hat bisher niemand gefunden.", italian="Oh.[K] Non l'ha ancora trovato\nnessuno.", spanish="Pues...[K] Nadie lo ha\nencontrado aún."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herugaa) end)
  SkySceneKit.say({english="Unfortunately, nothing's been\nfound. Nothing at all.", french="On en est toujours à la\ncase départ.", german="Leider wurde noch nichts\nentdeckt. Noch absolut gar nichts.", italian="Purtroppo non ve n'è traccia.\nNeanche la più piccola.", spanish="Por desgracia no hay ni rastro.\nNada de nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="It's said that in this quarry\nis a really complex labyrinth...", french="On raconte qu'il y a un labyrinthe\ntrès complexe dans cette carrière...", german="Der Steinbruch soll aus einem\nkomplexen Labyrinth bestehen.", italian="Si dice che in questa cava ci sia\nun labirinto molto intricato...", spanish="Se dice que en este territorio\nhay un laberinto muy enrevesado..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" It's really easy to get lost in it.", french="C'est très difficile de\ns'y retrouver.", german="Und es soll wirklich einfach\nsein, sich darin zu verlaufen.", italian=" È molto facile perdersi.", spanish=" Es de lo más fácil perderse."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="Even so, you should be able to\nget at least halfway through.", french="Vous devriez quand même\npouvoir arriver à mi-chemin.", german="Aber trotzdem sollte es möglich\nsein, es wenigstens zur Hälfte zu schaffen.", italian="In ogni caso dovrebbe essere\npossibile arrivare almeno fino a metà strada.", spanish="Aun así, por lo visto es posible\nrecorrer al menos la mitad."})
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="But after the waypoint,\nit's really difficult...", french="Mais après le passage\nintermédiaire, c'est une autre paire\nde manches...", german="Aber nach dem Wegpunkt wird\nes wirklich schwierig...", italian=" Ma dopo, tutto si complica...", spanish="Pero a partir de cierto punto,\nla cosa se complica..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Difficult?", french=" Comment cela?", german=" Schwierig?", italian=" Si complica?", spanish=" ¿En qué sentido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herugaa) end)
  SkySceneKit.say({english="Yeah...[K] Even if you try to move\nforward, you always end up right back where\nyou started.", french="Eh bien...[K] c'est une sorte de\nboucle. Vous avez beau avancer, vous\nretombez toujours au point de départ.", german="Genau...[K] Selbst wenn man sich\nstrikt vorwärts bewegt, landet man immer\nwieder dort, wo man gestartet ist.", italian="Sì...[K] Se si cerca di proseguire,\npoi ci si trova di nuovo al punto di partenza.", spanish="Pues...[K] Por más que intentes\navanzar, siempre acabas justo en\nel punto de partida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="...No matter how many times\nyou try.", french="Vous aurez beau essayer des\nmilliards de fois...", german="...Ganz egal, wie häufig man es\nauch versucht.", italian="Ci abbiamo provato e riprovato,\nnon siamo riusciti ad andare avanti.", spanish=" Da igual las veces que lo intentes."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="And so, almost everyone's been\ncoming back here to discuss it...", french="Alors on s'est tous retrouvés\nici pour en discuter...", german="Und deswegen ist so gut wie\njeder hierher zurückgekommen, um sich\ndarüber mit den anderen auszutauschen.", italian="E così siamo tornati qui\nper discutere sul da farsi...", spanish="Por eso casi todo el mundo\nha vuelto aquí para hablar del tema..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="There's got to be some kind of\npuzzle to it somehow... I think.", french="Il y a forcément une solution à\ncette énigme... un casse-tête à résoudre.", german="Dahinter versteckt sich\nanscheinend eine Art Rätsel...\nDas ist meine Meinung dazu.", italian="Dev'esserci una specie di enigma\nda risolvere... Almeno credo.", spanish="Tiene que haber algún tipo de\nacertijo... Al menos eso pienso yo."})
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="If you don't figure out the\npuzzle, you'll never find the treasure.", french="Impossible de trouver le trésor\nsans d'abord percer ce mystère.", german="Und solange dieses Rätsel nicht\ngelöst wird, bleibt der Schatz unauffindbar.", italian="Se non troviamo la soluzione\na questo mistero, non recupereremo mai\nil tesoro.", spanish="Y, si no lo resuelves,\nes imposible encontrar el tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Bellossom[CR] was saying the same\nthing earlier...", french="C'est ce que nous a dit [CS:N]Joliflor[CR]\ntout à l'heure...", german="[CS:N]Blubella[CR] hat vorhin etwas ganz\nÄhnliches gesagt...", italian="[CS:N]Bellossom[CR] ci ha detto\nla stessa cosa prima...", spanish="[CS:N]Bellossom[CR] nos dijo lo mismo\nantes..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It seems like this treasure is a\nreally difficult one to find...", french="Décidément, il semblerait que ce\ntrésor soit vraiment bien caché...", german="Dass dieser Schatz unmöglich\nzu finden sei...", italian="A quanto pare questo tesoro\nè molto difficile da trovare...", spanish="Parece que este tesoro\nes muy difícil de encontrar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Seems that way...[K] But if it's\nthat kind of treasure...", french="En effet...[K] Mais ce genre\nde trésor...", german="Sieht fast so aus...[K] Aber wenn\nes so eine Art Schatz ist...", italian="Sembra di sì...[K] Ma se si tratta\ndi un tesoro del genere...", spanish="Eso parece...[K] Pero si realmente\nes un tesoro así..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There's value in finding it.", french="... est encore plus gratifiant\nquand on le trouve.", german="Dann wird es sich erst recht\nlohnen, ihn ausfindig zu machen!", italian="... allora vale la pena darsi\nda fare così tanto per trovarlo.", spanish=" Tiene más valor encontrarlo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We're Team [CS:X]Charm[CR]...[K] Nothing's\nimpossible! [M:H8]", french="Nous sommes l'Equipe [CS:X]Charme[CR]...[K]\nRien ne peut nous arrêter! [M:H8]", german="Wir sind Team [CS:X]Charme[CR]...[K] Uns\nhält nichts auf! [M:H8]", italian="Siamo il Team [CS:X]Malia[CR]...[K]\nNiente è impossibile per noi! [M:H8]", spanish="Somos el [CS:X]Equipo Carisma[CR]...[K] ¡Nada\nes imposible! [M:H8]"})
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokotchi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" S-so[K] cool...", french=" La...[K] classe...", german=" W-wie...[K] locker...", italian=" W-Wow...[K] Fantastiche...", spanish=" Ay...[K] Me vuelve loco..."})
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english="Ummm...\nWhoa... [M:H8]", french=" Hum... Waouh... [M:H8]", german="Oooh...\nWow... [M:H8]", italian=" Mmmh... Wow... [M:H8]", spanish=" Uf... Qué chica... [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" Hey![K] You...over there!", french=" Hé![K] Vous, là-bas!", german=" Hey![K] Ihr da drüben!", italian=" Ehi![K] Dico a voi, laggiù!", spanish=" ¡Eh![K] ¡Eh, vosotros!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_nokotchi, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_nokutasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokutasu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_herugaa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" You! Give up now![K] This treasure's ours!", french="Oui, vous! Laissez tomber![K]\nLe trésor est à nous!", german=" Ihr! Gebt es auf![K] Der Schatz gehört uns!", italian=" Lasciate perdere![K] Quel tesoro è nostro!", spanish="¡Será mejor que os rindáis ya![K]\n¡Ese tesoro es nuestro!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 284, 60, false) end) -- performer/caméra
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 280, 416, Direction.Up, "NPC_MANYUURA")
  GROUND:MoveToPosition(npc_npc_manyuura, 276, 304, false, 2)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 312, 376, Direction.Up, "NPC_DORAPION")
  GROUND:MoveToPosition(npc_npc_dorapion, 312, 300, false, 2)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 240, 392, Direction.Up, "NPC_AABOKKU")
  GROUND:MoveToPosition(npc_npc_aabokku, 240, 304, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="This treasure is going to be found\nby none other than the band of\nthieves, Team [CS:X]AWD[CR]!", french="Seule l'Equipe [CS:X]DDA[CR], l'illustre\nbande de voleurs, est capable de\ns'emparer du trésor!", german="Der Schatz wird von der Diebesbande\nTeam [CS:X]SPA[CR] gefunden werden. Nur damit das\nklar ist!", italian="Nessun altro potrà metterci le mani sopra!\nSaremo noi a trovarlo... la banda di ladri\ndel Team [CS:X]AWD[CR]!", spanish="El tesoro lo va a encontrar nada más\ny nada menos que una banda de ladrones,\n¡el [CS:X]Equipo WAD[CR]!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokutasu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_herugaa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english=" Team [CS:X]AW[CR]...[K]Team [CS:X]AWD[CR]?!", french=" L'Equipe [CS:X]DD[CR]...[K] L'Equipe [CS:X]DDA[CR]?!", german=" Team [CS:X]SPA[CR]... [K]Team [CS:X]SPA[CR]?!?", italian=" Il Team [CS:X]AW[CR]...[K] Team [CS:X]AWD[CR]?!", spanish=" El [CS:X]Equipo WA[CR]...[K] ¡¿El [CS:X]Equipo WAD[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokotchi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english="That band of thieves with the\nbad reputation, Team [CS:X]AWD[CR], is here?", french="Cette bande de voleurs à la\nréputation exécrable? L'Equipe [CS:X]DDA[CR] est là?", german="Die Diebesbande Team [CS:X]SPA[CR]...\nDie mit dem unsagbar schlechten Ruf? Die sind\nhier?", italian="Il Team [CS:X]AWD[CR]? Quella banda\ndi ladri dalla pessima reputazione è qui?", spanish="¿Esa banda de ladrones de\npésima reputación, el [CS:X]Equipo WAD[CR], está aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Got it?[K] You!", french=" Pigé?[K] Vous!", german=" Verstanden?[K] Ihr seid gemeint!", italian=" Avete capito?[K] Dico a voi!", spanish=" ¿Lo pilláis?[K] ¡Más os vale!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="If you don't want to get hurt...[K]I suggest\nyou get out of here as fast as you can!", french="Si vous ne voulez pas être blessés...[K]\nje vous suggère de déguerpir au pas\nde charge!", german="Damit niemand euch wehtut,[K] gebe ich euch\nden Rat, besser schnell zu verschwinden!\nHaben wir uns verstanden?", italian="Se non volete vedervela brutta...[K]\nvi suggerisco di scappare a gambe levate!", spanish="Si no queréis resultar heridos...[K] ¡os\nrecomiendo que os larguéis pitando!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Hey...[K] What's with them?", french=" Hé...[K] Qu'est-ce qui leur prend?", german=" Hey...[K] Was ist denn mit denen?", italian=" Ehi...[K] Ma chi sono quelli?", spanish=" Eh...[K] ¿Pero de qué van?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herugaa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herugaa) end)
  SkySceneKit.say({english="Y-you![K] You don't know about\nTeam [CS:X]AWD[CR]?", french="Quoi?![K] Vous n'avez jamais\nentendu parler de l'Equipe [CS:X]DDA[CR]?", german="I-ihr![K] Habt ihr noch nicht von\nTeam [CS:X]SPA[CR] gehört?", italian="V-Voi![K] Non conoscete\nil Team [CS:X]AWD[CR]?", spanish="Pero...[K] ¿Es que no conocéis al\n[CS:X]Equipo WAD[CR]?"})
  -- message_Close
  GROUND:EntTurn(npc_npc_nokutasu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="Team [CS:X]AWD[CR] is a band of thieves\nwhose wickedness knows no bounds.", french="L'Equipe [CS:X]DDA[CR] est une bande\nde voleurs à la cruauté sans bornes.", german="Team [CS:X]SPA[CR] ist eine Diebesbande,\nderen Boshaftigkeit keine Grenzen kennt.", italian="Il Team [CS:X]AWD[CR] è una banda\ndi ladri temuta da tutti per la sua\nmalvagità senza pari.", spanish="El [CS:X]Equipo WAD[CR] es una banda de\nladrones cuya maldad no conoce límites."})
  -- message_Close
  GROUND:EntTurn(npc_npc_nokutasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(276, 324, 60, false) end) -- performer/caméra
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end) -- message_SetActor(ACTOR_NPC_NOKUTASU)
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="I'm pretty sure that's [CS:N]Drapion[CR]\nover there.", french="Je pense que c'est [CS:N]Drascore[CR],\nlà-bas.", german="Ich bin mir ziemlich sicher, dass\ndas dort [CS:N]Piondragi[CR] ist.", italian="Sono quasi sicuro che quello\nlaggiù sia [CS:N]Drapion[CR].", spanish="Juraría que ese de ahí es\n[CS:N]Drapion[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="He can beat down any opponent\nwith the claws on both of his arms and his\nlong fangs.", french="Il peut écraser n'importe quel\nadversaire avec ses griffes acérées et\nses crocs redoutables.", german="Er macht Gegner mit seinen\ngroßen Scheren und langen Reißzähnen fertig.", italian="Può sconfiggere qualsiasi\navversario usando i suoi artigli e le\nlunghe zanne.", spanish="Vence a sus oponentes\nsin inmutarse con sus afiladas garras\ny sus largos colmillos."})
  -- message_Close
  pcall(function() GAME:MoveCamera(240, 324, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end) -- message_SetActor(ACTOR_NPC_NOKUTASU)
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="That's [CS:N]Arbok[CR].[K]\nHe's incredibly vindictive.", french="Quant à lui, c'est [CS:N]Arbok[CR].[K]\nIl est terriblement agressif.", german="Das ist [CS:N]Arbok[CR].[K]\nEr ist extrem rachsüchtig.", italian="Quello è [CS:N]Arbok[CR].[K]\nÈ estremamente vendicativo.", spanish="Y aquel es [CS:N]Arbok[CR].[K]\nEs de lo más vengativo."})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 324, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end) -- message_SetActor(ACTOR_NPC_NOKUTASU)
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="There, in the center, is the\nboss, [CS:N]Weavile[CR].", french="Et au centre, c'est [CS:N]Dimoret[CR],\nla patronne.", german="Und das dort in der Mitte ist\nihre Anführerin, [CS:N]Snibunna[CR].", italian="E quella al centro è il loro capo,\n[CS:N]Weavile[CR].", spanish="Y la que está en medio es\nla jefa, [CS:N]Weavile[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english=" Rumor says she's really strong...", french="On raconte qu'elle est dotée\nd'une force colossale...", german="Gerüchten zufolge ist sie\nwirklich stark...", italian=" Gira voce che sia fortissima...", spanish=" Se rumorea que es muy fuerte..."})
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english="It's said that she pursues her\ngoal by any means, fair or foul.", french="... et qu'elle ne lâche jamais\nprise.", german="Man sagt, dass ihr jedes Mittel\nrecht ist, um ihre Ziele zu erreichen. Egal, wie\nniederträchtig es auch sein mag.", italian="... e che per ottenere quello\nche vuole ricorra a qualsiasi mezzo,\nanche il più sleale.", spanish="Se dice que persigue su objetivo\nhasta el final, contra viento y marea."})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="Team [CS:X]AWD[CR] is known everywhere\nfor its terrible behavior.", french="L'Equipe [CS:X]DDA[CR] est célèbre un peu\npartout pour son comportement détestable.", german="Die Mitglieder von Team [CS:X]SPA[CR]\nsind überall berühmt-berüchtigt für ihr\nschreckliches, unfaires Verhalten.", italian="Il Team [CS:X]AWD[CR] è conosciuto\novunque per il suo terribile comportamento.", spanish="El [CS:X]Equipo WAD[CR] es famoso\npor su horrible comportamiento."})
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="It's said that each and every\nPokémon that has run into them in a dungeon...", french="A ce qu'on dit, tous les Pokémon\nqui ont eu le malheur de les croiser au détour\nd'un donjon...", german="Alle Pokémon, die ihnen je in\neinem Dungeon begegnet sind...", italian="A quanto si dice, tutti i Pokémon\nche si sono imbattuti in loro dentro qualche\ndungeon...", spanish="Se dice que todos los Pokémon\nque se los han encontrado en un territorio..."})
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english="They've all come away from that\nencounter stripped of all their possessions.", french=" ... y ont laissé tous leurs biens.", german="Man sagt, dass all jene die\nHeimreise ohne jegliches Gepäck antreten\ndurften. Komplett ausgeraubt!", italian="... ne sono usciti senza neanche\npiù uno strumento in tasca.", spanish="Han salido de ese encuentro\ncon los bolsillos vacíos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(45) end)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Hey! You guys![K] Weren't you\nlistening?!", french="Hé! Les gars![K] Vous êtes\nsourds ou quoi?", german="Hey! Ihr da![K]\nHabt ihr gar nicht zugehört?!?", italian=" Ehi voi![K] Avete capito o no?", spanish="¡Eh, vosotros![K] ¡¿Es que no\nlo habéis oído?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokutasu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_herugaa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Didn't my lady [CS:N]Weavile[CR] tell you\nto hit the road?!", french="Dame [CS:N]Dimoret[CR] vous a dit de\ndéguerpir ou je me trompe?!", german="Hat Lady [CS:N]Snibunna[CR] euch nicht\ngerade befohlen, die Biege zu machen?!?", italian="Se non sbaglio, lady [CS:N]Weavile[CR]\nvi ha detto di sparire!", spanish="¡La bella [CS:N]Weavile[CR] os acaba de\ndecir que os piréis!"})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="If you don't scram, it's gonna be\npretty painful for you!", french="Si vous traînez dans le coin,\nvous allez le regretter!", german="Wenn ihr nicht gleich verduftet,\nwird es schmerzhaft für euch enden!", italian="Andatevene di corsa o passerete\ndei brutti guai!", spanish="¡Si no os largáis ya, os va\na doler mucho, estáis avisados!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Sss-sssss. Better lissssten up!", french=" Ssssssss. Partez tousssss!", german="Sss-sssss. Bessser, ihr hört\nauf unsss!", italian="Sss-sssss. Faressste meglio\nad asssssscoltarci!", spanish="Sssí. Ssserá mejor que\nessscuchéissss."})
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="I've been getting resssstlesssss\n'cause it's been too long ssssince I've had the\nchance to beat sssssomeone down!", french="Ça fait sssi longtemps que je\nn'ai écrasé persssonne!", german="Ich bin ganz ruhelosss, weil ich\nssseit sssso langer Zeit schon keinen mehr\ngebissssssen habe! Sssss-sssss!", italian="Sssono piuttosssto nervoso\nperché è passsato troppo tempo dall'ultima\nvolta che ho ssssssconfitto qualcuno!", spanish="¡No me busssquéisss lasss\ncosssquillasss, hace demasssiado que no le doy\nuna buena tunda a alguien!"})
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="Sssssso.[K] The firsssst one to get\nssssstepped on...[K] Who'ssssss it going to be?", french="Voyons.[K] Par qui vais-je\ncommenssser...[K] Qui ssssera mon\nsssouffre-douleur?", german="Sssagt mal.[K] Wer will zuerssst\ngebisssssen werden...[K] Wer wird esss sssein?", italian="Allora.[K] Chi vuole essssssere\nil primo a...[K] ssssssubire la mia ira?", spanish="Veamossss...[K] El primero en\nrecibir...[K] Venga, ¿quién va a ssser?"})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokotchi, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_metamon_otachi, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_herugaa, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokutasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" Ummm...", french=" Hum...", german=" Öhmmm...", italian=" Mmmh...", spanish=" Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english=" Ummmmmmm...", french=" Huuum...", german=" Öhmmmmmmm...", italian=" Mmmmmmh...", spanish=" Pueees..."})
  -- message_Close
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" E-everyone...[K] What's wrong?", french=" Hé, vous tous...[K] Qu'y a-t-il?", german=" Hey, ihr...[K] Was ist denn los?", italian=" E-Ehi voi...[K] Cosa vi prende?", spanish=" Eh... Pero...[K] ¿Qué os pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nokutasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokutasu) end)
  SkySceneKit.say({english=" I-I...[K]I give up...", french=" Je...[K] j'abandonne...", german=" I-ich...[K] Ich gebe auf...", italian=" I-Io...[K] rinuncio...", spanish=" Yo...[K] no quiero problemas..."})
  -- message_Close
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_nokutasu.Position; GROUND:MoveToPosition(npc_npc_nokutasu, p.X+(0), p.Y+(24), false, 2) end -- waypoint Move2PositionOffset
  do local p=npc_npc_nokutasu.Position; GROUND:MoveToPosition(npc_npc_nokutasu, p.X+(16), p.Y+(40), false, 2) end -- waypoint Move2PositionOffset
  do local p=npc_npc_nokutasu.Position; GROUND:MoveToPosition(npc_npc_nokutasu, p.X+(0), p.Y+(200), false, 2) end -- waypoint Move2PositionOffset
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_manyuura, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nokotchi) end)
  SkySceneKit.say({english=" M-me too!", french=" M-moi aussi!", german=" I-ich auch!", italian=" A-Anch'io!", spanish=" ¡Ni... Ni yo!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GROUND:EntTurn(npc_npc_manyuura, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_buubaan) end)
  SkySceneKit.say({english=" M-me t-too!", french=" M-moi aussi, moi aussi!", german=" I-ich a-auch!", italian=" P-Pure io!", spanish=" ¡Lo... Lo mismo digo!"})
  -- message_Close
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_nokotchi.Position; GROUND:MoveToPosition(npc_npc_nokotchi, p.X+(0), p.Y+(200), false, 2) end
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_metamon_otachi.Position; GROUND:MoveToPosition(npc_npc_metamon_otachi, p.X+(32), p.Y+(32), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_metamon_otachi.Position; GROUND:MoveToPosition(npc_npc_metamon_otachi, p.X+(0), p.Y+(240), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Down)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Down)
  GROUND:EntTurn(npc_npc_manyuura, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(68), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_buubaan.Position; GROUND:MoveToPosition(npc_npc_buubaan, p.X+(0), p.Y+(240), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_herugaa.Position; GROUND:MoveToPosition(npc_npc_herugaa, p.X+(-36), p.Y+(32), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_herugaa.Position; GROUND:MoveToPosition(npc_npc_herugaa, p.X+(0), p.Y+(240), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(276, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Bah![K] Cowards!", french=" Bah![K] Bande de lâches!", german=" Bah![K] Feiglinge!", italian=" Bah![K] Che codardi!", spanish=" ¡Bah![K] ¡Qué cobardicas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Ssssay, [CS:N]Drapion[CR]!", french=" T'as vu, [CS:N]Drassscore[CR]?", german=" Sssag mal, [CS:N]Piondragi[CR]...", italian=" Guarda, [CS:N]Drapion[CR]!", spanish=" ¡Eh, [CS:N]Drapion[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dorapion, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_manyuura, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="Are those cute girlssss\nssssstill here?", french="Elles sssont toujours là,\nles mignonnes!", german="Sssind diessse sssüßen Mädchen\nimmer noch hier? Sssss-sss?", italian="Quelle ragazze cosssì carine\nssssssono ancora qui...", spanish="Esssasss chicasss tan monasss\nsssiguen aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_manyuura, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Yeah! Yeah, they are!", french=" Ouais, on dirait bien!", german=" Ja! Ja, das sind sie!", italian=" Sì! Sì, è vero!", spanish=" Sí, aquí siguen."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Shocker![K] These girls seem\nto have some spine!", french="Bigre![K] Elles ont un sacré\ncourage, on dirait!", german="Sieh mal einer an![K] Die scheinen\nja wirklich Rückgrat zu haben!", italian="Però![K] Queste ragazzine hanno\ndel fegato, non c'è che dire!", spanish="¡Increíble![K] Parece que esas\nchicas tienen agallas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Aren't you ssssscared of ussss?", french="Alors, on vous donne pas\nla frousssse?", german=" Ssseid ihr nicht ängssstlich?", italian=" Non avete paura di noi?", spanish=" ¿No osss damosss miedo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Oh! I ssssee!", french=" Oh! J'ai tout sssaisi!", german=" Oh! Verssstehe!", italian=" Oh! Capisssco!", spanish=" ¡Ah, ya lo capto!"})
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="You admire ussss and want\nto become friendssss?", french="Vous êtes en exssstase devant\nnous et vous voulez devenir nos groupies?", german="Ihr verehrt unsss und wollt\nunsssere Freunde sssein?", italian="Ci ammirate e volete ssstringere\namicizia con noi...", spanish="¿Nosss admiráisss y queréisss\nssser amigasss nuessstrasss?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="GAHAHAHAHAHAHAHAHAHAHAHA![K]\nThat's it! That's it!", french="GAHAHAHAHAHAHAHAHAHAHAHA![K]\nEn plein dans le mille!", german="GAHAHAHAHAHAHAHAHAHAHAHA![K]\nGenau! Das wird es sein!", italian="UAHAHAHAHAHAHAHAHAHAHAHA![K]\nÈ così! È così!", spanish="¡Jua, ja, ja, ja, ja, ja, ja![K]\n¡Claro, tiene que ser eso!"})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="If that's how it is, it's\nreal simple!", french=" Dans ce cas, rien de plus simple!", german="Wenn das wahr ist, umso\nbesser!", italian=" Adesso si spiega tutto!", spanish="Mira que era fácil y\nno se me ha ocurrido a mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="You girls are cute, so...[K]\nI guess we'll let you be friends with us.", french="Vous êtes plutôt mignonnes,\nalors...[K] on va vous laisser nous admirer.", german="Ihr Mädels seid süß, daher...[K]\nIch denke, wir lassen es zu, dass ihr mit uns\nbefreundet seid.", italian="Visto che siete così carine...[K]\nCredo proprio che potremo diventare amici.", spanish="Sois muy monas, así que...[K]\nVa, os dejamos ser amigas nuestras."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Humph![K] Just who do you think\nyou are?", french="Pfff![K] Pour qui vous\nprenez-vous?", german=" Humpf![K] Was bildet ihr euch ein?", italian="Umpf![K] Ma chi vi credete\ndi essere?", spanish=" ¡Ja![K] ¿Pero qué os habéis creído?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Wha...?", french=" Quoi...?", german=" Waaa...", italian=" Cos...?", spanish=" ¿Cómo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Become friends with Pokémon\nwho have terrible reputations, such as\nyourselves...", french="Admirer des Pokémon à la\nréputation exécrable tels que vous...", german="Sich mit Pokémon anzufreunden,\ndenen ein derart schlechter Ruf wie euch\nvorauseilt...", italian="Diventare amiche di un gruppo\ndi Pokémon con una reputazione terribile\ncome la vostra...", spanish="Nosotras, amigas de unos\nPokémon así, con una reputación horrible..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Why would we want to do a\nthing like that?", french=" Vous nous avez bien regardées?", german="Warum sollten wir so was tun?\nDas ist nicht unser Stil.", italian="Perché mai vorremmo fare\nuna cosa simile?", spanish="¿Para qué íbamos a querer\ntener amigos así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Wh-whaaaat?!", french=" Quoi?!", german=" W-waaasss?!?", italian=" C-Cooosaaa?!", spanish=" Có... ¡¿cómoooo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We don't think you're scary\nor anything...", french="Vous ne nous faites même\npas peur...", german="Wir finden euch nicht\nfurchterregend oder so...", italian=" Non ci fate per niente paura...", spanish=" No nos dais miedo ni nada..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And we definitely don't\nadmire you.", french="... et nous n'avons aucune\nadmiration pour vous.", german="Und euch bewundern? Das würde\nuns im Traum nicht einfallen.", italian="E di sicuro non proviamo\nnessuna ammirazione per voi.", spanish="Y desde luego no os admiramos\nni un pelín."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "angry", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Y...[K]YOU!!", french=" V...[K] VOUS!!", german=" Ihr...[K] IHR!!!", italian=" V...[K] VOI!!!", spanish=" No...[K] ¡¡No es posible!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="We were sssso nice to you,\nand now it ssseemsss to have gone to\nyour headssss!", french="Sssilence insssolentes! On est\nsssympas avec vous et voilà comment\nvous nous remerciez!", german="Wir waren ssso nett zu euch,\nund dasss ssscheint euch wohl zu Kopf\ngessstiegen zu sssein!", italian="Sssiamo ssstati cosssì gentili\ne voi ve ne sssiete approfittate!", spanish="Con lo amablesss que hemosss\nsssido... Por lo visssto ssse osss ha sssubido\na la cabeza."})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-16), false, 2) end
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 4, false) end) -- MovePositionOffset performer/caméra
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  -- SetAnimation(14) [anim idle native]
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(40), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(40), false, 2) end -- SlidePositionOffset
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Guwaaa!", french=" Gwaaah!", german=" Guwaaa!", italian=" Guaaah!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Guooh!", french=" Gwooh!", german=" Guooh!", italian=" Guoooh!", spanish=" ¡Uoooh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Huh?![K] You're weaker than\nI thought!", french="Hein?![K] Je vous croyais plus\nforts que ça!", german="Ha![K] Ihr seid ja noch\nschwächer als erwartet!", italian="Eh?![K] Siete più deboli di quanto\ncredessi!", spanish="¡¿Eso es todo?![K] ¡Pensaba que\nseríais más fuertes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" H-huh...[K]whaaaat!?", french=" H-hein...[K] quoi!?", german=" K-keuch...[K] Waaaaas?!?", italian=" U-Uh...[K] Cooosaaa!?", spanish=" Qué...[K] ¡¿Quéeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="Blasssst![K] [CS:N]Drapion[CR]! Let'ssss take\ncare of thissss for real!", french="Bon sssang![K] [CS:N]Drassscore[CR]!\nIl ssserait temps de les faire taire!", german="Ssso wasss![K] [CS:N]Piondragi[CR]!\nLassssss unsss dasss sssofort richtigssstellen!", italian="Insssomma![K] [CS:N]Drapion[CR]! Sssmettila\ndi giocare e impegnati sssul sssssserio!", spanish="¡Córcholisss![K] ¡[CS:N]Drapion[CR], esssto\nno puede quedar asssí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(15) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Wait!", french=" Attendez!", german=" Wartet!", italian=" Basta!", spanish=" ¡Un momento!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Hold it, you!", french=" Arrêtez!", german=" Wartet, ihr zwei!", italian=" Fermi, voi!", spanish=" ¡Esperad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aabokku, Direction.Right)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" B-bosssssss...", french=" P-patronne...", german=" J-ja, Herrin...", italian=" C-Capo...", spanish=" Je... jefa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" My lady [CS:N]Weavile[CR]...", french=" Dame [CS:N]Dimoret[CR]...", german=" Aber Herrin [CS:N]Snibunna[CR]...", italian=" Lady [CS:N]Weavile[CR]...", spanish=" Señorita [CS:N]Weavile[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 135, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(0), p.Y+(-32), false, 1) end -- waypoint MovePositionOffset
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(20), p.Y+(-20), false, 1) end -- waypoint MovePositionOffset
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(0), p.Y+(-32), false, 1) end -- waypoint MovePositionOffset
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You...[K] You've made an enemy of\nTeam [CS:X]AWD[CR]...", french="Vous...[K] L'Equipe [CS:X]DDA[CR] est\ndésormais votre ennemie...", german="Ihr...[K] Ihr habt euch gerade einen\nFeind gemacht, und der heißt Team [CS:X]SPA[CR]...", italian="Voi...[K] avete osato sfidare\nil Team [CS:X]AWD[CR]...", spanish="Os...[K] Os habéis granjeado un\nenemigo, el [CS:X]Equipo WAD[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="And...[K] You won't regret it,\nwill you?", french="C'est votre dernière chance...[K]\nde vous rattraper!", german="Und...[K] Ihr werdet es noch nicht\neinmal bereuen, richtig?", italian=" E...[K] ve ne pentirete, capito?", spanish=" Y...[K] no os arrepentís, ¿me equivoco?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hee-hee![K] Not at all!", french=" Hi hi![K] Tu rigoles!", german=" Hihi![K] Absolut nicht!", italian=" Ih ih![K] Non credo proprio!", spanish=" ¡Ji, ji![K] ¡Para nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Those words...[K]\nWe won't forget them.", french="Nous n'oublierons jamais...[K]\nces mots.", german="Diese Worte...[K] Wir werden sie\nnicht vergessen.", italian="Questo affronto...[K]\nNon lo dimenticherò!", spanish=" Esas palabras...[K] No las olvidéis."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nLet's go!", french="[CS:N]Arbok[CR]! [CS:N]Drascore[CR]![K]\nEn route!", german="[CS:N]Arbok[CR]! [CS:N]Piondragi[CR]![K]\nWir gehen!", italian="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nAndiamo!", spanish="¡[CS:N]Arbok[CR], [CS:N]Drapion[CR]![K]\n¡Vámonos de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-32), 32, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(-24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-56), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(36), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-48), false, 2) end -- waypoint MovePositionOffset
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dorapion, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(0), p.Y+(-120), false, 1) end
  GAME:WaitFrames(30)
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-32), false, 1) end
  GAME:WaitFrames(5)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(-36), p.Y+(-40), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aabokku, Direction.Down)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" You! Remember thisssss!", french="Ça ne se passssera pas comme\nssssa!", german=" Ihr! Vergesssssst dasss nicht!", italian=" Ehi, voi! Non sssssscordate!", spanish=" ¡Que no ssse osss olvide!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-100), false, 2) end
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="The next time we meet,\nwe'll finish this!", french="La prochaine fois, on vous fait\nvotre affaire!", german="Beim nächsten Treffen machen\nwir mit euch kurzen Prozess!", italian="La prossima volta che ci\nincontriamo, sarà la vostra fine!", spanish="¡La próxima vez acabaremos\nlo que hemos empezado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-100), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Humph![K] You think you can just\nwalk away like that!?", french="Pfff![K] Parce que vous vous\nimaginez qu'on va vous laisser partir si\nfacilement!?", german="Humpf![K] Ihr denkt, ihr könnt\neuch hier so einfach aus dem Staub machen?!?", italian="Umpf![K] Pensate di potervene\nandare via così?!", spanish="¡Pero bueno![K] ¡¿Pensáis que os\npodéis ir así, por las buenas?! ¡Qué descaro!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We've always gotten\nevery treasure so far, so we won't\nmiss it this time!", french="Jamais un trésor ne nous a\néchappé et celui-ci ne fera pas exception!", german="Wir haben bisher jeden Schatz\nfür uns beanspruchen können und das wird\ndieses Mal genauso sein!", italian="Finora non ci è mai sfuggito\nun tesoro e non succederà nemmeno\nquesta volta!", spanish="Hasta ahora siempre hemos\nconseguido todos los tesoros que queríamos,\ny esta vez no va a ser diferente."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We won't lose!", french="La défaite ne fait pas partie\nde notre vocabulaire!", german=" Wir werden nicht scheitern!", italian=" Non perderemo!", spanish=" ¡No vamos a perder!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" [CS:Y]Lopunny[CR]! [CS:N]Gardevoir[CR]! Let's hurry!", french=" [CS:Y]Lockpin[CR]! [CS:N]Gardevoir[CR]! Pressons!", german="[CS:Y]Schlapor[CR]! [CS:N]Guardevoir[CR]!\nWir müssen uns beeilen!", italian=" [CS:Y]Lopunny[CR]! [CS:N]Gardevoir[CR]! Muoviamoci!", spanish=" ¡[CS:Y]Lopunny[CR], [CS:N]Gardevoir[CR]! ¡Deprisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:TeleportTo(npc_npc_metamon_otachi, 276, 364, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end) -- message_SetActor(ACTOR_NPC_METAMON_OTACHI)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Excuse me...", french=" Excusez-moi...", german=" Entschuldigt...", italian=" Scusate...", spanish=" Esto... Disculpadme..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(276, 292, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_metamon_otachi, 276, 300, false, 2)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-you're...", french=" T-tu...", german=" D-du bist...", italian=" T-Tu sei...", spanish=" E... eres..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Earlier...", french=" Tout à l'heure...", german=" Zuvor...", italian=" Prima...", spanish=" Antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" You...[K] Didn't you run away?", french=" Tu...[K] ne t'es pas enfui?", german="Bist...[K] Bist du nicht\nweggelaufen?", italian=" Tu...[K] non eri scappato?", spanish=" No...[K] ¿No has huido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_metamon_otachi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Y-yes, that's right...", french=" Pas vraiment...", german=" D-doch, das stimmt...", italian=" S-Sì, infatti...", spanish=" Pues... Sí, sí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_metamon_otachi, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_metamon_otachi, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_metamon_otachi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="I should have said this sooner.[K]\nMy name is [CS:N]Sentret[CR]...", french="J'aurais dû vous dire ça plus\ntôt.[K] Mon nom est [CS:N]Fouinette[CR]...", german="Ich hätte mich vorstellen sollen.[K]\nMein Name ist [CS:N]Wiesor[CR].", italian="Scusate, non mi sono ancora\npresentato.[K] Mi chiamo [CS:N]Sentret[CR]...", spanish="Huy, si no me he presentado.[K]\nMe llamo [CS:N]Sentret[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="Truth is, I was watching you\nand Team [CS:X]AWD[CR] from the shadows over there...", french="En vérité, je m'étais caché pour\nvous observer, vous et l'Equipe [CS:X]DDA[CR]...", german="Ich habe euren Streit mit Team\n[CS:X]SPA[CR] aus dem Schatten beobachtet...", italian="A dirla tutta, stavo osservando\nvoi e il Team [CS:X]AWD[CR] nascosto nell'ombra...", spanish="Lo cierto es que os he estado\nobservando a vosotras y al [CS:X]Equipo WAD[CR]\ndesde allí detrás..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="That argument going back\nand forth...", french="Une joute oratoire que je ne suis\npas près d'oublier...", german="Wie ihr ihnen so mutig\nwidersprochen habt...", italian=" Il vostro botta e risposta...", spanish="Ha sido un momento\nmuy emocionante..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="I've never seen anyone stand up\nto Team [CS:X]AWD[CR] like that without flinching...[K]\nIt was amazing...", french="Je n'avais jamais vu personne\ntenir tête à l'Equipe [CS:X]DDA[CR] de cette façon...[K]\nJe n'en reviens pas...", german="Das war das erste Mal, dass ich\nsah, wie sich jemand Team [CS:X]SPA[CR] in den Weg\nstellt, ohne zu zögern...[K] Sehr beeindruckend...", italian="Non ho mai visto nessuno tenere\ntesta al Team [CS:X]AWD[CR] senza batter ciglio\nin quel modo...[K] È stato incredibile...", spanish="Nunca había visto a nadie\nplantarle cara al [CS:X]Equipo WAD[CR] sin inmutarse...[K]\nHa sido increíble..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="After watching you...[K]\nI feel like I can trust you, so...", french="Maintenant que j'ai vu ça...[K]\nje sais que vous êtes dignes de confiance...", german="Nachdem ich euch gesehen habe...[K]\nIch bin sicher, dass ich euch vertrauen kann...", italian="Dopo avervi visto...[K] Sento\ndi potermi fidare di voi, quindi...", spanish="Después de ver algo así...[K]\nCreo que puedo confiar en vosotras, así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" I have a request.", french="Aussi, j'aimerais vous demander\nquelque chose.", german=" Ich habe eine Bitte an euch.", italian=" ... avrei una richiesta da fare.", spanish=" Tengo algo que pediros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A request?", french=" Quoi donc?", german=" Eine Bitte?", italian=" Una richiesta?", spanish=" ¿De qué se trata?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Yes.[K] Team [CS:X]AWD[CR]...", french=" L'Equipe [CS:X]DDA[CR]...", german=" Ja.[K] Team [CS:X]SPA[CR]...", italian=" Sì.[K] Il Team [CS:X]AWD[CR]...", spanish=" Pues...[K] El [CS:X]Equipo WAD[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Team [CS:X]AWD[CR] needs to be punished.", french="L'Equipe [CS:X]DDA[CR] mérite\nune bonne correction.", german="Team [CS:X]SPA[CR] hat eine Lektion\nverdient.", italian="Il Team [CS:X]AWD[CR] deve essere\npunito.", spanish=" El [CS:X]Equipo WAD[CR] merece un castigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Why Team [CS:X]AWD[CR]?", french=" Pourquoi?", german=" Warum Team [CS:X]SPA[CR]?", italian=" E perché mai?", spanish="¿Qué problema tienes tú con el\n[CS:X]Equipo WAD[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="The truth is...[K]I used to be in an\nexploration team with some friends a\nwhile ago...", french="Pour tout vous dire...[K] Autrefois,\nnous avions formé une équipe d'exploration\navec des amis à moi...", german="Nun, ich...[K] Ich war vor einiger\nZeit mit Freunden in einem Erkundungsteam...", italian="Beh, ecco...[K] Tempo fa, avevo\ncreato una squadra d'esplorazione insieme\nad alcuni amici...", spanish="La verdad es que...[K] hace tiempo\nformaba parte de un equipo explorador\ncon unos amigos..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="My friends...[K]were attacked by\nTeam [CS:X]AWD[CR] during an adventure...", french="Seulement voilà...[K] pendant une\nde nos aventures, l'Equipe [CS:X]DDA[CR] s'en est pris\nà mes amis...", german="Und meine Freunde...[K] Sie wurden\nwährend eines Abenteuers von Team [CS:X]SPA[CR]\naus dem Hinterhalt angegriffen.", italian="Poi, durante un'avventura,\nil Team [CS:X]AWD[CR]...[K] ci ha attaccati...", spanish="Y mis amigos...[K] sufrieron un\nataque por parte del [CS:X]Equipo WAD[CR] durante\nuna de sus aventuras..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" They were hurt very badly...", french=" Ils ont été gravement blessés...", german=" Sie wurden ernsthaft verletzt.", italian="I miei amici hanno subito\ngravi ferite...", spanish=" Quedaron muy malheridos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Wh-whaaat?!", french=" Pardon?!", german=" W-waaaas?!?", italian=" C-Cooosaaa?!", spanish=" ¡¿Quéee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="And since then, my friends...[K]\nHave been too scared to go out\nexploring again...", french="Et depuis ce jour-là, ils...[K]\nils ont peur de retourner en exploration...", german="Und meine Freunde sind seither[K]\nzu verängstigt, um wieder auf Erkundung zu\ngehen...", italian="E da allora...[K] hanno troppa\npaura e non vogliono più sentir parlare\ndi esplorazioni...", spanish="Desde entonces, mis amigos...[K]\ntienen tanto miedo que no han vuelto a salir\nde exploración..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="They spend their days\nshaking in fear...", french="Ils passent leur vie\nà trembler...", german="Sie verbringen ihre Tage vor\nAngst zitternd im Dunkeln...", italian="Trascorrono le loro giornate\ntremando di paura...", spanish="Se pasan los días temblando\nde miedo..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="And so...[K]going out exploring\nwith me...", french="Et bien sûr...[K] ils refusent\ncatégoriquement...", german="Es ist schrecklich...[K] Ich kann\ndas gar nicht mitansehen...", italian="E così...[K] non hanno più\nintenzione...", spanish=" Así que...[K] mis amigos..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english="Is completely out of the question\nfor them...", french="... de m'accompagner en\nexploration...", german="In diesem Zustand können sie\nmich nicht auf einer Erkundung begleiten...", italian="... di venire ad esplorare\ncon me...", spanish=" Ya no quieren salir a explorar nunca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" That's terrible!", french=" Quelle horreur!", german=" Schrecklich, sage ich!", italian=" Ma è terribile!", spanish=" ¡Qué espanto!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You know, they're real\nscoundrels, just like the rumors say!", french="Alors la rumeur dit vrai!\nCe ne sont que des vils bandits!", german="Wisst ihr, das sind wirkliche\nÜbeltäter! Die Gerüchte über sie sind wahr!", italian="Sono delle vere canaglie, proprio\ncome si dice in giro!", spanish="¡Son unos auténticos bribones,\ntal y como habíamos oído!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To do something so terrible that\nyour friends don't want to explore anymore...", french="Traumatiser tes amis au point\nqu'ils ne veuillent plus explorer...", german="Etwas so Schreckliches zu tun,\ndass deine Freunde nicht mehr auf Erkundung\ngehen wollen...", italian="Comportarsi in maniera così\nterribile da spingere i tuoi amici\nad abbandonare l'esplorazione...", spanish="Deben de serlo, para haber hecho\nalgo tan horrible a tus amigos que no quieren\nvolver a explorar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="As explorers...[K]we just can't\nforgive those bullies!", french="En tant qu'exploratrices...[K]\nnous ne pouvons pas laisser ces brutes s'en\ntirer comme ça!", german="Als Erkunder...[K] Da können wir\ndiesen Halunken so etwas nicht verzeihen!", italian="In quanto esploratrici...[K] non\npossiamo perdonare quei prepotenti!", spanish="Como exploradoras que somos...[K]\n¡digo que esos matones lo van a pagar caro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" We understand, [CS:N]Sentret[CR].", french=" Nous compatissons, [CS:N]Fouinette[CR].", german=" Gut. Verstanden, [CS:N]Wiesor[CR].", italian=" Ti capiamo, [CS:N]Sentret[CR].", spanish=" Te entendemos, [CS:N]Sentret[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="If we run into Team [CS:X]AWD[CR] again,\nwe'll definitely punish them.", french="Si jamais nous croisons l'Equipe\n[CS:X]DDA[CR], nous leur donnerons une bonne leçon.", german="Wenn wir Team [CS:X]SPA[CR] noch einmal\nüber den Weg laufen, werden wir ihnen mit\nSicherheit eine Lektion erteilen.", italian="Se ci imbatteremo di nuovo\nnel Team [CS:X]AWD[CR], gli daremo sicuramente\nuna bella lezione.", spanish="Si nos volvemos a encontrar con\nel [CS:X]Equipo WAD[CR], ten por seguro que recibirá\nsu merecido."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" In honor of your friends...", french=" Pour venger tes amis...", german=" Im Namen deiner Freunde...", italian=" Lo faremo per i tuoi amici...", spanish=" Así vengaremos a tus amigos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_metamon_otachi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Th-thank you so much!", french=" Merci de tout cœur!", german=" D-danke vielmals!", italian=" G-Grazie mille!", spanish=" ¡Mu... muchísimas gracias!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="All right! We should get ready\nand get moving![K] Into the quarry!", french="Bien! Préparons-nous et\nallons-y![K] A la carrière!", german="Na gut! Jetzt sollten wir uns\naber aufmachen![K] Auf in den Steinbruch!", italian="Bene! Ora prepariamoci\ne andiamo![K] La cava ci aspetta!", spanish="Bueno, deberíamos prepararnos y\nponernos en marcha.[K] ¡Vamos allá!"})
  -- message_Close
  pcall(function() SOUND:PlayBGM("Boulder Quarry.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
