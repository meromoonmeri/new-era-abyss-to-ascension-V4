-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_s_perappu = SkySceneKit.spawn_npc("chatot", 376, 216, Direction.Left, "NPC_S_PERAPPU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_kimawari = SkySceneKit.spawn_npc("sunflora", 328, 216, Direction.UpLeft, "NPC_S_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_heigani = SkySceneKit.spawn_npc("corphish", 296, 208, Direction.DownRight, "NPC_S_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_bippa = SkySceneKit.spawn_npc("bidoof", 392, 232, Direction.Left, "NPC_S_BIPPA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_dogoomu = SkySceneKit.spawn_npc("loudred", 400, 208, Direction.Right, "NPC_S_DOGOOMU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_dagutorio = SkySceneKit.spawn_npc("dugtrio", 448, 208, Direction.DownLeft, "NPC_S_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_diguda = SkySceneKit.spawn_npc("diglett", 424, 232, Direction.UpRight, "NPC_S_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_s_chiriin = SkySceneKit.spawn_npc("chimecho", 368, 240, Direction.Right, "NPC_S_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 272, 192, Direction.Down, "NPC_HIMEGUMA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_taneboo = SkySceneKit.spawn_npc("seedot", 312, 240, Direction.Left, "NPC_TANEBOO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 272, 224, Direction.Up, "NPC_OOSUBAME")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 344, 240, Direction.Up, "NPC_YARUKIMONO")
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Th-the world's...[K]ruin?!", french=" La fin...[K] du monde?!", german=" D-den...[K] Untergang der Welt?!?", italian=" La rovina...[K] del mondo?!", spanish="En ruinas...[K]\n¡¿Que el mundo acabaría en ruinas?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Is THAT what happens if the\nTime Gears are taken away?!", french="Alors, c'est ÇA qui va arriver\nsi les Rouages du Temps disparaissent?!", german="DAS passiert, wenn die\nZahnräder der Zeit gestohlen werden?!?", italian="Se vengono rubati gli Ingranaggi\ndel Tempo, è questo quello che succede?", spanish="¡¿Es eso lo que sucedería si\nse extrajeran todos los Engranajes del\nTiempo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The way time has been going\nout of control lately...", french="La façon dont le temps s'est mis\nà se détraquer dernièrement...", german="Dass die Zeit in letzter Zeit\naußer Kontrolle geraten ist...", italian="Il tempo, ultimamente, si\ncomporta in modo molto anomalo...", spanish="La forma en la que el tiempo\nha quedado fuera de control últimamente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That, too, is caused by the\nthefts of the Time Gears.", french="... n'est qu'un signe\navant-coureur de la catastrophe à venir.", german="Das kommt auch davon, dass die\nZahnräder der Zeit gestohlen wurden.", italian="Questo è causato dalla sparizione\ndegli Ingranaggi del Tempo.", spanish="Eso también es una consecuencia\ndel robo de los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If the Time Gears continue to be\nstolen, this world will end in ruin.", french="Si les Rouages du Temps\ncontinuent à disparaître, ce monde connaîtra\nune fin désastreuse.", german="Wenn noch mehr Zahnräder der\nZeit gestohlen werden, wird diese Welt\nuntergehen.", italian="Se gli Ingranaggi del Tempo\ncontinueranno a essere rubati, questo\nmondo andrà incontro alla rovina.", spanish="Si continúan desapareciendo,\nel mundo acabará en ruinas tarde o\ntemprano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_2 [sous-routine locale adjacente: flux naturel]
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 320, 168, Direction.DownRight, "NPC_JIBAKOIRU")
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownLeft)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 288, 176, Direction.Right, "NPC_KOIRU")
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 288, 232, Direction.Right, "NPC_POPPO")
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english=" S-so that's what would happen...", french="Heiiiiin? C'est ça qui risque\nde se produire...", german=" D-das würde also passieren...", italian=" È questo quello che ci aspetta?", spanish="Así... así que tarde o temprano\neso es lo que ocurriría..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" This is bad!", french=" Fouilla! J'aime pas ça du tout!", german=" Wie schrecklich!", italian=" È terribile!", spanish=" ¡Es horrible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(6, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" W-we've got to do something!", french="Il faut qu'on fasse quelque\nchose!", german=" W-wir müssen etwas tun!", italian="Dobbiamo assolutamente fare\nqualcosa!", spanish=" Hay... ¡hay que hacer algo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_s_heigani.Position; GROUND:MoveToPosition(npc_npc_s_heigani, p.X+(8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 224, Direction.UpRight, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! I have a question!", french=" Eh dis donc, j'ai une question!", german=" Hey, hey! Ich habe eine Frage!", italian=" Ehi, ehi! Io avrei una domanda!", spanish=" ¡Oye, oye! ¡Tengo una pregunta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  local npc_npc_s_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 176, Direction.Down, "NPC_S_YONOWAARU")
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.UpLeft)
  local npc_npc_s_pukurin = SkySceneKit.spawn_npc("wigglytuff", 352, 216, Direction.Up, "NPC_S_PUKURIN")
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru, Direction.DownRight)
  GAME:WaitFrames(4)
  local npc_npc_s_emuritto = SkySceneKit.spawn_npc("mesprit", 384, 168, Direction.DownRight, "NPC_S_EMURITTO")
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownLeft)
  local npc_npc_s_agunomu = SkySceneKit.spawn_npc("azelf", 408, 168, Direction.DownLeft, "NPC_S_AGUNOMU")
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  local npc_npc_s_yukushii = SkySceneKit.spawn_npc("uxie", 424, 176, Direction.UpLeft, "NPC_S_YUKUSHII")
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Left)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Left)
  GAME:WaitFrames(2)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 256, 216, Direction.UpRight, "NPC_RINGUMA")
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Up)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GROUND:EntTurn(npc_npc_oosubame, Direction.UpRight)
  GROUND:EntTurn(npc_npc_poppo, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="There's something that I don't\nunderstand.", french="Il y a quelque chose que\nje n'arrive pas à comprendre.", german="Es gibt etwas, das ich nicht\nverstehe.", italian="C'è una cosa che non\nriesco a capire.", spanish=" Hay una cosa que no entiendo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes? What is it?", french=" Oui? De quoi s'agit-il?", german=" So? Was denn?", italian=" Sì? Di cosa si tratta?", spanish=" ¿Sí? ¿De qué se trata?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I understand that we've got a\nbig problem on our hands...", french="J'ai bien compris qu'on avait\nun gros problème à résoudre...", german="Ich verstehe, dass wir es mit\neinem Problem zu tun haben...", italian="A quanto pare, ci troviamo nei\npasticci...", spanish="Comprendo que este problema\nes muy serio..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But what I don't understand...[K]\nWell, hey, it's about you, [CS:N]Dusknoir[CR], sir.", french="Mais ce qui me dépasse...[K]\nEh bien, c'est vous que ça concerne, messire\n[CS:N]Noctunoir[CR], dis donc!", german="Aber was ich nicht verstehe...[K]\nNun ja, hey, das hat mit dir zu tun, [CS:N]Zwirrfinst[CR].", italian="Ma la cosa che non riesco a\ncapire...[K] Beh, ehi, riguarda lei, signor\n[CS:N]Dusknoir[CR].", spanish="Pero lo que no entiendo...[K]\nOye, es tu papel, [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Why do you know so much,\n[CS:N]Dusknoir[CR], sir?", french="Comment ça se fait que vous en\nsachiez autant, messire [CS:N]Noctunoir[CR]?", german="Woher weißt du so viel,\n[CS:N]Zwirrfinst[CR]?", italian="Come fa a sapere tutte queste\ncose, signor [CS:N]Dusknoir[CR]?", spanish="¿Cómo sabes tanto de todo esto,\n[CS:N]Dusknoir[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I mean, I know that the great\n[CS:N]Dusknoir[CR] is knowledgeable and wise...", french="Voilà, dis donc, je sais bien que\nvous connaissez des tas de choses...", german="Ich meine, ich weiß, dass der\ngroße [CS:N]Zwirrfinst[CR] klug und weise ist...", italian="Voglio dire, tutti sanno che la\nconoscenza del grande [CS:N]Dusknoir[CR] è immensa...", spanish="Ya sé que tus conocimientos,\n[CS:N]Dusknoir[CR], son extensos y de todo tipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="And sure, I really respect you\nand all...", french="... et j'ai énormément de respect\npour vous et tout ça...", german="Und ja, ich respektiere dich sehr\nund so...", italian="E non voglio certo mancarle di\nrispetto...", spanish="Y tengo un gran respeto por ti,\nclaro está..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But how would you know the\nfuture, no matter how knowledgeable you are?", french="Mais, malgré votre immense\nsavoir, comment ça se fait que vous\nconnaissiez le futur, dis donc?", german="Aber wie kannst du die Zukunft\nkennen, egal wie klug du bist?", italian="Ma persino lei... come fa a\nconoscere il futuro?", spanish="Pero... ¿cómo puedes conocer\ncosas del futuro, por muy sabio que seas?"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_poppo) end)
  SkySceneKit.say({english=" That's true...", french=" C'est vrai, ça...", german=" Das stimmt...", italian=" Ha ragione...", spanish=" Es verdad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" Come to think...", french=" Réflexion faite...", german=" Jetzt, wo du es sagst...", italian=" In effetti...", spanish=" Ahora que lo pienso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ah, yes. What [CS:N]Corphish[CR] said\nmakes perfect sense.", french="Certes. [CS:N]Ecrapince[CR]\na parfaitement raison.", german="Ah, ja. Was [CS:N]Krebscorps[CR] sagt,\nergibt durchaus Sinn.", italian="Certamente. [CS:N]Corphish[CR] ha\nperfettamente ragione.", spanish="Ah, sí. Lo que dice [CS:N]Corphish[CR]\ntiene mucho sentido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Under normal circumstances,\nit's true, there is no way that I should know\nthese things.", french="Normalement, il est vrai que\nje ne devrais pas savoir tant de choses.", german="Unter normalen Umständen\nkönnte ich diese Dinge tatsächlich\nunmöglich wissen.", italian="In circostanze normali, non avrei\nalcun modo di essere a conoscenza di tutto\nquesto.", spanish="Bajo circunstancias normales,\npor supuesto que no habría forma\nde que yo pudiera saber todo eso."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" So, why do I know these things?", french="Alors, comment se fait-il que\nje les sache?", german=" Also, wieso weiß ich das alles?", italian="Come faccio a sapere queste\ncose, vi starete chiedendo?", spanish="¿Que cómo es posible que tenga\nesa información entonces?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" It's because...", french=" C'est parce que...", german=" Der Grund ist...", italian=" La ragione è questa.", spanish=" Pues porque..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I, too...[K]am a Pokémon from\nthe future.", french=" Moi aussi...[K] je viens du futur.", german="Auch ich[K] bin ein Pokémon\naus der Zukunft.", italian="Io stesso...[K] sono un Pokémon\nche viene dal futuro.", spanish="Yo también...[K] También soy un\nPokémon del futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- call @label_3 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COOOOOSA?!", spanish="[CS:N]Todos[CR]: ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] is...[K]another\nPokémon from the future?!", french="[CS:N]Noctunoir[CR] aussi...[K]\nvient du futur?!", german="[CS:N]Zwirrfinst[CR] ist[K] auch ein\nPokémon aus der Zukunft?!?", italian="Anche [CS:N]Dusknoir[CR]...[K] viene dal\nfuturo?!", spanish="[CS:N]Dusknoir[CR] es...[K] ¡¿otro Pokémon\ndel futuro?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] is...[K]another\nPokémon from the future?!", french="[CS:N]Noctunoir[CR] aussi...[K]\nvient du futur?!", german="[CS:N]Zwirrfinst[CR] ist[K] auch ein\nPokémon aus der Zukunft?!?", italian="Anche [CS:N]Dusknoir[CR]...[K] viene dal\nfuturo?!", spanish="[CS:N]Dusknoir[CR] es...[K] ¡¿otro Pokémon\ndel futuro?!"})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] is...[K]another\nPokémon from the future?!", french="[CS:N]Noctunoir[CR] aussi...[K]\nvient du futur?!", german="[CS:N]Zwirrfinst[CR] ist[K] auch ein\nPokémon aus der Zukunft?!?", italian="Anche [CS:N]Dusknoir[CR]...[K] viene dal\nfuturo?!", spanish="[CS:N]Dusknoir[CR] es...[K] ¡¿otro Pokémon\ndel futuro?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By gosh and golly!", french="Bon sang d'bonsoir, j'arrive\npas à y croire!", german=" Donnerwetter!", italian=" Ohibò! Doppio ohibò!", spanish=" ¡Huy, menudo notición!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="This is all so complicated it's\nmaking my head spin, yup yup!", french="Tout ça, c'est un d'ces sacs\nde nœuds que ça m'donne mal au crâne,\npour sûr!", german="Mir wird ganz schwindelig, so\nkompliziert ist das, jawollja!", italian="Tutto ciò è talmente complicato\nche mi gira un po' la testa, sissignore!", spanish="¡Esto es tan complicado que\nla cabeza me da vueltas! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="My objective is to capture\n[CS:N]Grovyle[CR].", french="Mon objectif est de capturer\n[CS:N]Massko[CR].", german="Mein Ziel ist es, [CS:N]Reptain[CR] zu\nfangen.", italian="La mia missione consiste nel\ncatturare [CS:N]Grovyle[CR].", spanish="Mi objetivo es capturar a\n[CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It is for that reason...[K]that I\ncame from the future.", french="C'est pour cette raison...[K]\nque je suis venu du futur.", german="Aus diesem Grund[K] bin ich aus\nder Zukunft hierhergekommen.", italian="Questa è la ragione per cui...[K]\nsono venuto qui dal futuro.", spanish="Por ese motivo...[K] vine del\nfuturo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I needed to know as much as\npossible to ensure the capture of [CS:N]Grovyle[CR].", french="Il me fallait rassembler autant\nd'informations que possible pour espérer\ncapturer [CS:N]Massko[CR].", german="Ich musste so viel wie möglich\nin Erfahrung bringen, um sicherzugehen, dass\nich [CS:N]Reptain[CR] fangen würde.", italian="Ho dovuto imparare tutto ciò che\nera necessario per catturare [CS:N]Grovyle[CR].", spanish="Necesitaba saber todo lo posible\npara garantizar la captura de [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I therefore studied everything I\ncould about this world while in the future.", french="J'ai donc préparé ma venue en\nm'instruisant un maximum au sujet\nde ce monde.", german="Deshalb habe ich mir in der\nZukunft sämtliches Wissen über diese Welt\nangeeignet.", italian="Pertanto, mentre mi trovavo\nancora nel futuro, ho studiato tutto quello che\nsono riuscito a trovare su questo mondo.", spanish="Por tanto estudié todo lo que\npude sobre el mundo de esta época antes\nde viajar hasta aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That is why I know so much\nabout this world.", french=" Voilà pourquoi j'en sais autant.", german="Darum weiß ich so viel über\ndiese Welt.", italian="Questa è la ragione per cui\nconosco così tante cose del vostro mondo.", spanish="Por eso sé tantas cosas sobre\neste mundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Why didn't you say anything\nbefore?", french="Pourquoi vous ne l'avez pas dit\navant?", german="Warum hast du uns das nicht\nfrüher gesagt?", italian=" Perché non ci ha detto niente?", spanish=" ¿Por qué no nos lo dijiste antes?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I...I'm sorry.", french=" Je... je suis confus.", german=" Es... Es tut mir leid.", italian=" Sono... desolato.", spanish=" Yo... lo siento."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I have felt terrible not saying\nanything.", french="J'ai souffert maints tourments\nà cause de cela.", german="Ich habe mich dabei schrecklich\ngefühlt.", italian="È stato terribile non potervi\ndire niente.", spanish="Me sentí fatal callando lo que\nsabía."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm sincerely sorry for not\nrevealing my identity. I am full of contrition.", french="Veuillez me pardonner pour ne\npas vous avoir révélé tout sur mon identité\nplus tôt. J'en suis fort marri.", german="Es tut mir aufrichtig leid, dass\nich meine wahre Identität verheimlicht habe.\nIch bereue es zutiefst.", italian="Sono sinceramente dispiaciuto di\nnon aver rivelato la mia identità.", spanish="Siento mucho haber ocultado\nmi verdadera identidad. Estoy arrepentido."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But...[K]what if I had been open\nabout my identity from the start?", french="Mais...[K] que se serait-il passé si\nje vous avais dit la vérité d'emblée?", german="Aber...[K] Was, wenn ich meine\nIdentität von Anfang an preisgegeben hätte?", italian="Ma...[K] cosa sarebbe successo se\navessi rivelato la mia identità sin dal\nprincipio?", spanish="Pero...[K] ¿si hubiera revelado\nmi identidad desde el principio...?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="What would have happened if I\nhad said that I was from the future?", french="Si je vous avais dit que\nje venais du futur?", german="Was wäre geschehen, wenn ich\ngesagt hätte, dass ich aus der Zukunft komme?", italian="Cosa sarebbe successo se avessi\ndetto subito che provengo dal futuro?", spanish="¿Qué creéis que habría\nocurrido al decir que venía del futuro?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Who would have taken me\nseriously?", french=" Qui m'aurait pris au sérieux?", german=" Wer hätte mir geglaubt?", italian=" Chi mi avrebbe creduto?", spanish="¿Quién me habría tomado\nen serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Hmpf...", italian=" Ehm...", spanish=" ¡Vaya!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Also, I needed to avoid alerting\n[CS:N]Grovyle[CR] to my presence.", french="D'autre part, il fallait à tout\nprix éviter que [CS:N]Massko[CR] n'ait vent\nde ma présence.", german="Außerdem musste ich\nvermeiden, dass [CS:N]Reptain[CR] auf mich aufmerksam\nwird.", italian="Inoltre, era necessario che\n[CS:N]Grovyle[CR] non sapesse della mia presenza.", spanish="Además, tenía que evitar que\n[CS:N]Grovyle[CR] supiera de mi presencia."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I decided that I should keep\nmy identity hidden while I went about with\nmy work.", french="J'ai donc décidé de rester\nincognito tout en m'attelant à la tâche.", german="Ich beschloss, meine Identität\ngeheim zu halten, solange ich meiner Arbeit\nnachging.", italian="Decisi che avrei celato la mia\nidentità per la riuscita della missione.", spanish="Por eso decidí mantener mi\nidentidad en secreto durante esta misión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It makes sense...", french=" Logique...", german=" Das ergibt Sinn...", italian=" In effetti...", spanish=" Tiene sentido..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But...[K]it is also a fact that I have\nbeen deceiving you.", french="Pourtant...[K] je dois admettre que\nje vous ai trompés.", german="Aber...[K] Es ist eine Tatsache,\ndass ich euch getäuscht habe.", italian=" Ma...[K] è vero. Vi ho ingannato.", spanish="Pero...[K] también es cierto que\nos he estado engañando."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="For keeping silent about my\nidentity...[K]I sincerely apologize.", french="En taisant ma véritable\nidentité...[K] Toutes mes excuses.", german="Dass ich meine wahre Identität\nverschwiegen habe...[K] Das tut mir aufrichtig\nleid.", italian="Vi prego di perdonarmi...[K] se\nnon vi ho rivelato la mia identità.", spanish="Pido perdón por haber guardado\nsilencio...[K] Os ruego que me disculpéis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No, no! Oh, no, no![K] Please, don't\napologize!", french="Oh, non! Mais comment donc![K]\nVous ne nous devez aucune excuse!", german="Nein, nein! Aber nein![K]\nBitte, entschuldige dich nicht!", italian="La prego![K] Non deve chiederci\nscusa!", spanish="¡No, no! ¡Oh, no, no![K]\n¡No te disculpes, por favor!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You can't blame yourself!\nYou had no choice!", french="Vous ne pouvez pas vous\nen vouloir! Vous n'aviez pas le choix!", german="Es ist nicht deine Schuld!\nDu hattest keine Wahl!", italian="Non deve farsene cruccio! Lei\nnon aveva scelta!", spanish="¡No debes sentirte mal!\n¡No podías hacer otra cosa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! I concur! [CS:N]Dusknoir[CR] has\ndone nothing wrong in my book! ZZZT!", french="ZZZT! Je confirme! A mon avis,\n[CS:N]Noctunoir[CR] n'a rien fait de mal! ZZZT!", german="ZZZT! Ich stimme zu!\n[CS:N]Zwirrfinst[CR] hat in meinen Augen nichts\nfalsch gemacht! ZZZT!", italian="ZZZT! Sono d'accordo! [CS:N]Dusknoir[CR]\nha fatto la cosa giusta! ZZZT!", spanish="¡Bzz! ¡Estoy de acuerdo! Para\nmí, ¡[CS:N]Dusknoir[CR] no ha hecho nada malo! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We should focus our\nanger on [CS:N]Grovyle[CR]. ZZZT!", french="ZZZT! Seul [CS:N]Massko[CR] doit être\nla cible de nos foudres. ZZZT!", german="ZZZT! Wir sollten unsere Wut\nfür [CS:N]Reptain[CR] aufheben. ZZZT!", italian="ZZZT! Non dimentichiamo che il\nresponsabile di tutto questo è [CS:N]Grovyle[CR]! ZZZT!", spanish="¡Bzz! [CS:N]Grovyle[CR] es quien debe ser\nel blanco de nuestra ira. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We must somehow\ncapture him! ZZZT!", french="ZZZT! Il faut le capturer,\npar tous les moyens! ZZZT!", german="ZZZT! Wir müssen es irgendwie\nschaffen, ihn zu fangen! ZZZT!", italian="ZZZT! Dobbiamo trovare il modo\ndi catturarlo! ZZZT!", spanish="¡Bzz! ¡Tenemos que capturarle!\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Yeah![K] We're in DEEP trouble if\nwe let [CS:N]Grovyle[CR] go on!", french="Ouais![K] On aura de GROS ennuis\nsi on laisse [CS:N]Massko[CR] continuer!", german="Ja![K] Wir haben ein echtes\nPROBLEM, wenn wir [CS:N]Reptain[CR] nicht bald\nschnappen!", italian="Hai ragione![K] Se [CS:N]Grovyle[CR] porta a\ntermine il suo piano, saranno guai per tutti!", spanish="¡Sí![K] Tendremos serios problemas\nsi no detenemos a [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We need to catch him before\nthe world gets ruined!", french="On doit l'arrêter avant\nqu'il n'entraîne le monde à sa perte!", german="Wir müssen ihn kriegen,\nbevor die Welt untergeht!", italian=" Dobbiamo fermarlo!", spanish="¡Hay que detenerle antes de que\nel mundo acabe en ruinas por su culpa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir! I'll be glad\nto help!", french="Messire [CS:N]Noctunoir[CR]! Je serai\nravie de vous aider!", german="[CS:N]Zwirrfinst[CR]! Ich würde gerne\nhelfen!", italian="Signor [CS:N]Dusknoir[CR]! Può contare su\ndi me.", spanish="[CS:N]Dusknoir[CR], ¡estaré encantada\nde ayudarte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "happy", 1) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 384, 176, Direction.DownLeft, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" M-me too!", french=" Moi aussi!", german=" I-ich auch!", italian=" A-Anche su di me!", spanish=" Yo... ¡yo también!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By golly, me too!", french=" Sapristi, moi itou!", german=" Ich auch, jawollja!", italian=" E su di me, ohibò!", spanish=" ¡Huy, yo también!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Count me in!", french=" Eh dis donc, j'en suis!", german=" Hey, hey! Ich bin dabei!", italian=" Ehi, ehi! Ci sono anch'io!", spanish=" ¡Oye, oye! ¡Yo me apunto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Left)
  do local p=npc_npc_s_yukushii.Position; GROUND:MoveToPosition(npc_npc_s_yukushii, p.X+(-16), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We will cooperate as well!", french="Nous aussi, nous vous\napporterons notre concours!", german="Wir werden euch auch\nunterstützen!", italian=" Anche noi vi aiuteremo!", spanish="¡Nosotros también queremos\ncolaborar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I refuse to remain a victim!", french="Je refuse de compter parmi\nles victimes de cet infâme scélérat!", german="Ich weigere mich, ein Opfer zu\nsein!", italian=" Dobbiamo assolutamente reagire!", spanish="¡Me niego a seguir siendo\nuna víctima!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We won't let him steal\nanother one!", french="On ne le laissera pas s'emparer\nd'un autre Rouage du Temps!", german="Wir werden nicht zulassen, dass\ner noch eins stiehlt!", italian="Non gli permetteremo di rubare\nun altro Ingranaggio del Tempo!", spanish="¡No dejaremos que robe ni uno\nmás!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Everyone, thank you so much.", french=" Merci à tous, merci infiniment.", german=" Ich bin euch allen sehr dankbar.", italian=" Vi ringrazio tutti di cuore.", spanish=" Muchísimas gracias a todos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="We, as Pokémon...[K]must all\nwork as one...", french="En tant que Pokémon...[K]\nnous devons tous conjuguer nos efforts...", german="Wir Pokémon...[K] Wir müssen\nzusammenhalten...", italian="Noi Pokémon...[K] dobbiamo\ncollaborare...", spanish="Todos los Pokémon...[K] debemos\ntrabajar juntos como uno solo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" to capture [CS:N]Grovyle[CR]...", french="... dans le but de capturer\n[CS:N]Massko[CR]...", german="Zusammenhalten, um so [CS:N]Reptain[CR]\nzu fangen...", italian=" ... e fermare [CS:N]Grovyle[CR].", spanish="Juntos podremos capturar a\n[CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="then put an end to [CS:N]Grovyle[CR]'s\ncalamitous plot!", french="... et de mettre un terme\nà ses funestes desseins!", german="Zusammenhalten, um dem\nkatastrophalen Plan von [CS:N]Reptain[CR] ein Ende zu\nsetzen!", italian="Non possiamo permettere che\nporti a termine il suo abominevole piano!", spanish=" ¡Y poner fin a su espantoso plan!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Quicksand Cave.ogg", true) end)
  -- call @label_4 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: YEAH!", french="[CS:N]Tous[CR]: OUAIS!", german="[CS:N]Alle[CR]: JAAA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡SÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Left)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GROUND:EntTurn(npc_npc_oosubame, Direction.Up)
  GROUND:EntTurn(npc_npc_poppo, Direction.Right)
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(28), g.ViewCenter.Y+(-28), 28, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Left)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir.", french=" Messire [CS:N]Noctunoir[CR].", german=" [CS:N]Zwirrfinst[CR].", italian=" Signor [CS:N]Dusknoir[CR].", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="In order to obtain the Time Gear\nfrom [CS:P]Shining Lake[CR]...", french="S'il veut s'emparer du Rouage\ndu Temps du [CS:P]Lac Cristal[CR]...", german="Um das Zahnrad der Zeit aus\ndem [CS:P]Kristallsee[CR] zu bekommen...", italian="Se vuole davvero ottenere\nl'Ingranaggio del Tempo che si trova\npresso il [CS:P]Lago di Cristallo[CR]...", spanish="Para conseguir el Engranaje del\nTiempo del [CS:P]Lago Cristal[CR]..."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] knows that he has to\ndefeat me.", french="[CS:N]Massko[CR] devra me vaincre,\net il le sait.", german="Dazu muss [CS:N]Reptain[CR] mich\nbesiegen, und das weiß er.", italian="Beh, [CS:N]Grovyle[CR] sa che prima deve\nsconfiggermi.", spanish="[CS:N]Grovyle[CR] sabe que tiene que\nderrotarme."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="So if he's still after my\nTime Gear...", french="Donc, s'il convoite toujours\nmon Rouage du Temps...", german="Wenn er es also noch immer auf\nmein Zahnrad der Zeit abgesehen hat...", italian=" Questo significa...", spanish="Así que si busca mi Engranaje\ndel Tiempo..."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] will come after me.", french=" [CS:N]Massko[CR] viendra à moi.", german="Dann wird [CS:N]Reptain[CR] hinter mir\nher sein.", italian="Significa che [CS:N]Grovyle[CR] verrà a\ncercarmi.", spanish=" [CS:N]Grovyle[CR] vendrá a buscarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We could turn that against\nhim.[K] [CS:N]Mesprit[CR], [CS:N]Azelf[CR], and I can go to\n[CS:P]Shining Lake[CR]...", french="Ce qui pourrait aisément\nse retourner contre lui.[K] [CS:N]Créfollet[CR], [CS:N]Créfadet[CR]\net moi pourrions aller au [CS:P]Lac Cristal[CR]...", german="Diese Situation sollten wir zu\nunseren Gunsten nutzen.[K] [CS:N]Vesprit[CR], [CS:N]Tobutz[CR] und\nich können zum [CS:P]Kristallsee[CR] gehen...", italian="Questo potrebbe essere un\nvantaggio per noi.[K] [CS:N]Mesprit[CR], [CS:N]Azelf[CR] ed io\npotremmo recarci al [CS:P]Lago di Cristallo[CR]...", spanish="Podemos volver eso en su\ncontra.[K] [CS:N]Mesprit[CR], [CS:N]Azelf[CR] y yo podemos ir\nal [CS:P]Lago Cristal[CR]..."})
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Then we can all spread rumors\nclaiming that we have gone to seal the Time\nGear so that it can never be taken.", french="Ensuite, faisons courir le bruit\nque nous allons sceller le Rouage du Temps,\npour le mettre hors d'atteinte.", german="Dann setzen alle das Gerücht in\ndie Welt, dass das Zahnrad der Zeit versiegelt\nwird, damit es nie gestohlen werden kann.", italian="E poi, dovremmo spargere la\nvoce che l'Ingranaggio del Tempo verrà messo\nin condizione di non poter più essere rubato.", spanish="Y extender luego el rumor de\nque hemos ido a sellar el Engranaje del\nTiempo para siempre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we did that, do you think it\nwould provoke [CS:N]Grovyle[CR] to strike?", french="Si nous faisions ça, pensez-vous\nque cela pousserait [CS:N]Massko[CR] à se montrer?", german="Vielleicht würde das [CS:N]Reptain[CR]\ndazu bringen, noch einen Versuch zu wagen?", italian="Questo spingerebbe [CS:N]Grovyle[CR]\na entrare in azione.", spanish="¿No creéis que esto haría\nactuar a [CS:N]Grovyle[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I see.[K] You're suggesting that\nwe bait the trap.", french="Je vois.[K] Vous suggérez\nqu'on l'appâte en espérant qu'il morde\nà l'hameçon.", german="Ich verstehe.[K] Ihr schlagt vor,\nihm eine Falle zu stellen.", italian="Ho capito.[K] Volete farlo cadere\nin trappola.", spanish="Entiendo.[K] Sugerís que le\ntendamos una trampa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yup.", french=" Ouaip.", german=" Genau.", italian=" È così.", spanish=" Así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But...[K]that would mean exposing\nyou to danger as the bait...", french="Cela dit...[K] vous prendriez\nun risque en servant d'appât...", german="Aber...[K] Das würde bedeuten,\ndass ihr euch als Köder in Gefahr bringt...", italian="Ma questo...[K] significa che voi\nfareste da esca, esponendovi al pericolo...", spanish="Pero...[K] usaros como cebo os\npondría en peligro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I'd like nothing more!", french=" Rien ne me ferait plus plaisir!", german=" Nichts täte ich lieber!", italian=" Non chiedo di meglio!", spanish=" Eso no importa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" If that means stopping [CS:N]Grovyle[CR]...", french="Si ça nous permet de capturer\n[CS:N]Massko[CR]...", german="Wenn wir [CS:N]Reptain[CR] so aufhalten\nkönnen...", italian=" Se è per fermare [CS:N]Grovyle[CR]...", spanish="Si con eso logramos detener a\n[CS:N]Grovyle[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We're ready to take that risk.", french="Nous sommes prêts à courir\nce risque.", german="Dann sind wir bereit, das Risiko\neinzugehen.", italian="Siamo pronti a correre i nostri\nrischi.", spanish="Estamos más que preparados\npara correr ese riesgo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Then...[K]I understand.", french=" Dans ce cas...[K] je comprends.", german="Wenn das so ist,[K] verstehe ich\neuch.", italian=" In questo caso...[K] d'accordo.", spanish=" De acuerdo...[K] Entiendo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-28), g.ViewCenter.Y+(28), 28, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Everyone, let me explain\nour plan!", french=" Oyez, oyez! Voici notre plan!", german="Hört alle her, ich erkläre euch\nunseren Plan!", italian=" Va bene. Ecco il nostro piano.", spanish="¡Escuchadme todos! Os explicaré\nlo que debéis hacer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_5 [sous-routine locale adjacente: flux naturel]
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Please, pay attention and do\nyour part!", french="Soyez attentifs et jouez tous\nvotre rôle!", german="Passt bitte auf und tut, was ich\neuch auftrage!", italian="Prego ognuno di prestare\nattenzione e fare la propria parte.", spanish="¡Prestad mucha atención y\ncumplid con vuestra parte del plan!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="First, I would like everyone to\nspread a rumor, far and wide!", french="D'abord, je voudrais que vous\npropagiez une rumeur un peu partout!", german="Erstens möchte ich alle bitten,\nein bestimmtes Gerücht zu verbreiten!", italian="Come prima cosa, tutti dovranno\nspargere la voce, in lungo e in largo!", spanish="Para empezar, quiero que todo\nel mundo extienda el siguiente rumor por\ndonde sea posible."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Get the word out about the\nthree Pokémon, [CS:N]Uxie[CR], [CS:N]Mesprit[CR], and [CS:N]Azelf[CR].", french="Parlez de trois Pokémon,\n[CS:N]Créhelf[CR], [CS:N]Créfollet[CR] et [CS:N]Créfadet[CR].", german="Erzählt überall von den drei\nPokémon [CS:N]Selfe[CR], [CS:N]Vesprit[CR] und [CS:N]Tobutz[CR]...", italian="Dovete far sì che si sappia in\ngiro che [CS:N]Uxie[CR], [CS:N]Mesprit[CR] e [CS:N]Azelf[CR]...", spanish="Que todos sepan la noticia sobre\n[CS:N]Uxie[CR], [CS:N]Mesprit[CR] y [CS:N]Azelf[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Spread word that the trio has\nreturned to [CS:P]Shining Lake[CR] to seal the\nTime Gear away.", french="Faites courir le bruit qu'ils sont\nretournés au [CS:P]Lac Cristal[CR] pour sceller à jamais\nle Rouage du Temps.", german="Und dass sie zum [CS:P]Kristallsee[CR]\nzurückgekehrt sind, um das Zahnrad der Zeit\nzu versiegeln.", italian="... hanno fatto ritorno al [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR] e stanno per sigillare per sempre\nl'Ingranaggio del Tempo.", spanish="Decid a todo el mundo que los\ntres han vuelto al [CS:P]Lago Cristal[CR] para sellar\nel Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Please spread the rumor as\nmuch as possible.", french=" Faites vite.", german="Bitte verbreitet dieses Gerücht\nso weit wie möglich.", italian="Vi prego di fare in modo che la\nvoce circoli il più possibile.", spanish="Propagad el rumor todo lo que\npodáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I see.[K] So you want word of this\nto reach [CS:N]Grovyle[CR]'s ears.", french="Je vois.[K] Ce que vous voulez,\nc'est que la rumeur atteigne [CS:N]Massko[CR].", german="Ich verstehe.[K] Du willst also,\ndass [CS:N]Reptain[CR] davon hört.", italian="Ma certo.[K] Lei vuole che\n[CS:N]Grovyle[CR] lo venga a sapere.", spanish="Entiendo.[K] Quieres que llegue\na oídos de [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That's correct. But [CS:N]Grovyle[CR]\nwon't be convinced by rumor alone.", french="Exact. Mais une simple rumeur\nne suffira pas à le convaincre.", german="Genau. Aber das Gerücht allein\nwird [CS:N]Reptain[CR] nicht überzeugen.", italian="Precisamente. Ma [CS:N]Grovyle[CR] non si\nlascerà convincere da semplici dicerie.", spanish="Correcto. Pero un rumor no\nbastará para convencer a [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That is why I must ask the trio\nof [CS:N]Uxie[CR], [CS:N]Mesprit[CR], and [CS:N]Azelf[CR] to do something.", french="C'est pourquoi je vais devoir\ndemander à [CS:N]Créhelf[CR], [CS:N]Créfollet[CR] et [CS:N]Créfadet[CR]\nde faire quelque chose.", german="Deshalb muss ich [CS:N]Selfe[CR], [CS:N]Vesprit[CR]\nund [CS:N]Tobutz[CR] bitten, etwas Bestimmtes zu tun.", italian="Per questo devo chiedere l'aiuto\ndi [CS:N]Uxie[CR], [CS:N]Mesprit[CR] e [CS:N]Azelf[CR].", spanish="Por eso debo pedirle a [CS:N]Uxie[CR],\n[CS:N]Mesprit[CR] y [CS:N]Azelf[CR] que hagan algo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I must ask them to actually go\nto [CS:P]Shining Lake[CR].", french="Il faut qu'ils se rendent\nvraiment au [CS:P]Lac Cristal[CR].", german="Ich muss sie bitten, wirklich\nzum [CS:P]Kristallsee[CR] zu gehen.", italian="Devo pregarli di recarsi al [CS:P]Lago[CR]\n[CS:P]di Cristallo[CR].", spanish="Debo pedirles que vayan al\n[CS:P]Lago Cristal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I get it![K] Then when [CS:N]Grovyle[CR]\nshows up to find [CS:N]Azelf[CR] and the others, that's\nwhen we jump him!", french="Mais oui, bien sûr![K] Comme ça,\nquand [CS:N]Massko[CR] ira trouver [CS:N]Créfadet[CR] et\nles autres, on sera là pour lui sauter dessus!", german="Alles klar![K] Wenn [CS:N]Reptain[CR]\ndann bei [CS:N]Tobutz[CR] und den anderen auftaucht,\nkönnen wir ihn schnappen!", italian="Ci sono![K] Quando [CS:N]Grovyle[CR] si\nfarà vedere, sarà il momento in cui\nentreremo in gioco.", spanish="¡Ya entiendo![K] Entonces, cuando\n[CS:N]Grovyle[CR] aparezca para enfrentarse a [CS:N]Azelf[CR] y\nlos demás, ¡saltaremos sobre él!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I understand![K] Then when [CS:N]Grovyle[CR]\nshows up to find [CS:N]Azelf[CR] and the others, that's\nwhen we can catch him!", french="Mais oui, bien sûr![K] Comme ça,\nquand [CS:N]Massko[CR] ira trouver [CS:N]Créfadet[CR] et\nles autres, on sera là pour lui sauter dessus!", german="Verstanden![K] Wenn [CS:N]Reptain[CR]\ndann bei [CS:N]Tobutz[CR] und den anderen auftaucht,\nkönnen wir ihn schnappen!", italian="Ho capito![K] [CS:N]Grovyle[CR] si farà\nvedere nel tentativo di fermare [CS:N]Azelf[CR] e gli\naltri. E allora lo acciufferemo!", spanish="¡Ya entiendo![K] Entonces, cuando\n[CS:N]Grovyle[CR] aparezca para enfrentarse a [CS:N]Azelf[CR] y\nlos demás, ¡saltaremos sobre él!"})
  else
  SkySceneKit.say({english="I get it![K] Then when [CS:N]Grovyle[CR]\nshows up to find [CS:N]Azelf[CR] and the others, that's\nwhen we can catch him!", french="Mais oui, bien sûr![K] Comme ça,\nquand [CS:N]Massko[CR] ira trouver [CS:N]Créfadet[CR] et\nles autres, on sera là pour lui sauter dessus!", german="Verstanden![K] Wenn [CS:N]Reptain[CR]\ndann bei [CS:N]Tobutz[CR] und den anderen auftaucht,\nkönnen wir ihn schnappen!", italian="Ho capito![K] [CS:N]Grovyle[CR] si farà\nvedere nel tentativo di fermare [CS:N]Azelf[CR] e gli\naltri. E allora lo acciufferemo!", spanish="¡Ya entiendo![K] Entonces, cuando\n[CS:N]Grovyle[CR] aparezca para enfrentarse a [CS:N]Azelf[CR] y\nlos demás, ¡saltaremos sobre él!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_2 [sous-routine locale adjacente: flux naturel]
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I get it NOW!", french=" J'ai ENFIN compris!", german=" JETZT verstehe ich!", italian=" ADESSO ho capito!", spanish=" ¡Ahora lo entiendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_kimawari, "happy", 1) end)
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! I'm all fired up\nwith excitement!", french="Ben mince alors! Je brûle\nd'impatience!", german="Auweia! Ich bin vor Spannung\nganz aus dem Häuschen!", italian=" Shock! Che emozione!", spanish=" ¡Qué superemocionante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_s_kimawari, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english=" ZZZT! Arrest! Arrest! ZZZT!", french="Zzzt! Arrestation! Arrestation!\nZzzt!", german=" Zzzt! Gefangennahme! Zzzt!", italian="Zzzt! Modalità arresto:\nOperativa! Zzzt!", spanish="¡BZZ! ¡ARRESTAR! ¡ARRESTAR!\n¡BZZ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! I'm calling it! I'm going\nto be the one to catch [CS:N]Grovyle[CR]!", french="Eh dis donc, preum's!\nC'est moi qui arrêterai [CS:N]Massko[CR]!", german="Hey, hey! Das übernehme ich!\nIch werde [CS:N]Reptain[CR] schnappen!", italian="Ehi, ehi! Mi prenoto! Voglio\nessere io quello che acciufferà [CS:N]Grovyle[CR]!", spanish="¡Oye, oye! ¡Eso ya lo diré yo!\n¡Yo seré quien atrape a [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! No, it is my duty to catch\ncriminals! ZZZT!", french="ZZZT! Non, c'est mon devoir\nd'appréhender les criminels! ZZZT!", german="ZZZT! Nein, es ist meine\nAufgabe, Verbrecher festzunehmen! ZZZT!", italian="ZZZT! NO! Arrestare i criminali\nè il MIO dovere! ZZZT!", spanish="¡BZZ! ¡NO, ES MI DEBER\nATRAPAR A LOS MALHECHORES! ¡BZZ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Move2PositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't want to miss out on\nthe glory!", french="Pas question qu'on laisse\nles autres nous doubler!", german="Ich will mir den Ruhm nicht\nentgehen lassen!", italian="Non dobbiamo farci battere dagli\naltri.", spanish="¡No pienso ser menos que\nlos demás!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't want to get outdone by\nthe others!", french="Pas question qu'on laisse\nles autres nous doubler!", german="Da möchte ich nicht hinter den\nanderen zurückstehen!", italian=" Non dobbiamo restare indietro!", spanish="¡No pienso ser menos que\nlos demás!"})
  else
  SkySceneKit.say({english="I don't want to get outdone by\nthe others!", french="Pas question qu'on laisse\nles autres nous doubler!", german="Da möchte ich nicht hinter den\nanderen zurückstehen!", italian=" Non dobbiamo restare indietro!", spanish="¡No pienso ser menos que\nlos demás!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's do our best too,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben auch wir unser Bestes,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish="¡También tendremos que\nhacer todo lo posible, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's do our best too,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben auch wir unser Bestes,\n[hero]!", italian="Dobbiamo fare del nostro meglio,\n[hero]!", spanish="¡Tendremos que esforzarnos\nal máximo, [hero]!"})
  else
  SkySceneKit.say({english="Let's do our best too,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben auch wir unser Bestes,\n[hero]!", italian="Dobbiamo fare del nostro meglio,\n[hero]!", spanish="¡Tendremos que esforzarnos\nal máximo, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm sorry.[K] I'm grateful for your\nkind offers.", french="Navré.[K] Je vous suis\nreconnaissant de vouloir me prêter main-forte.", german="Es tut mir leid.[K] Ich bin dankbar,\ndass ihr mir eure Hilfe anbietet.", italian="Mi dispiace.[K] Vi sono grato per\nil vostro impegno.", spanish="Perdonadme.[K] Agradezco\nsinceramente vuestro ofrecimiento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Move2PositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But, for the capture of [CS:N]Grovyle[CR],\nI would prefer to work alone.", french="Pourtant, je préférerais\nprocéder seul à la capture de [CS:N]Massko[CR].", german="Doch was die Gefangennahme\nvon [CS:N]Reptain[CR] angeht, würde ich lieber\nallein arbeiten.", italian="Ma per catturare [CS:N]Grovyle[CR], dovrò\nagire da solo.", spanish="Pero creo que será mejor que\nme encargue de la captura de [CS:N]Grovyle[CR] yo\nsolo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- call @label_3 [sous-routine locale adjacente: flux naturel]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "exclaim", 1) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! Wh-why?", french=" Hein?! Mais pourquoi?", german=" Ähem?!? W-warum?", italian=" Eeh?! M-Ma perché?", spanish=" ¡¿Qué?! ¿Por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! Wh-why?", french=" Hein?! Mais pourquoi?", german=" Was?!? W-warum?", italian=" Cosa?! P-Perché?", spanish=" ¡¿Qué?! ¿Por qué?"})
  else
  SkySceneKit.say({english=" Pardon?! Wh-why?", french=" Hein?! Mais pourquoi?", german=" Wie bitte?!? W-warum?", italian=" Cosa?! P-Perché?", spanish=" ¡¿Qué?! ¿Por qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_koiru, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] will be extremely wary.", french=" [CS:N]Massko[CR] sera sur ses gardes.", german="[CS:N]Reptain[CR] wird extrem vorsichtig\nsein.", italian=" [CS:N]Grovyle[CR] starà all'erta.", spanish="[CS:N]Grovyle[CR], sin duda alguna,\ndesconfiará de la situación."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Even if he were to realize that\n[CS:N]Azelf[CR] and the other two have truly gone\nto [CS:P]Shining Lake[CR]...", french="S'il s'aperçoit que [CS:N]Créfadet[CR]\net ses amis se sont bel et bien rendus\nau [CS:P]Lac Cristal[CR]...", german="Wenn er merkt, dass [CS:N]Tobutz[CR]\nund die anderen wirklich zum [CS:P]Kristallsee[CR]\ngegangen sind...", italian="Anche se dovesse scoprire che\n[CS:N]Azelf[CR] e gli altri si trovano veramente al\n[CS:P]Lago di Cristallo[CR]...", spanish="Aunque vea que [CS:N]Azelf[CR] y sus\ncompañeros realmente se han ido al\n[CS:P]Lago Cristal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="He will be cautious in the\nextreme.", french=" ... il sera extrêmement prudent.", german="Dann wird er außerordentliche\nVorsicht walten lassen.", italian=" ... sarà sul chi vive.", spanish=" Será extremadamente cauteloso."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So, if we were to lay a massive\nambush for him at [CS:P]Shining Lake[CR]...", french="Et si nous venons en force au\n[CS:P]Lac Cristal[CR] pour lui tendre une embuscade...", german="Wenn wir also einen riesigen\nHinterhalt am [CS:P]Kristallsee[CR] planen würden...", italian="È per questo che, se\ninterverremo in massa al [CS:P]Lago di Cristallo[CR]...", spanish="Si preparamos una gran\nemboscada en el [CS:P]Lago Cristal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="He will undoubtedly notice the\nunusual number of Pokémon in the area.", french="... il ne manquera pas de\nremarquer la présence d'un nombre inhabituel\nde Pokémon sur les lieux.", german="Dann würde ihm mit Sicherheit\nauffallen, dass sich in der Gegend\nungewöhnlich viele Pokémon aufhalten.", italian="... si accorgerà sicuramente\ndell'insolito numero di Pokémon che si\ntrovano in zona.", spanish="No cabe duda de que se\npercatará del gran número de Pokémon\npresentes en la zona."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm afraid [CS:N]Grovyle[CR] will not be\nlured out by [CS:N]Azelf[CR] and the others that way.", french="Si nous agissons ainsi, je crains\nque [CS:N]Massko[CR] ne morde pas à l'hameçon.", german="Ich fürchte, dass [CS:N]Reptain[CR] sich\ndann nicht von [CS:N]Tobutz[CR] und den anderen\nlocken lassen würde.", italian="Se succedesse, temo che [CS:N]Grovyle[CR]\nnon uscirebbe allo scoperto.", spanish="Y eso evitaría que [CS:N]Grovyle[CR]\nse acercase al señuelo de [CS:N]Azelf[CR] y los\ndemás."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So I must apologize...[K]and insist\nupon capturing [CS:N]Grovyle[CR] by myself.", french="C'est pourquoi, et je vous prie\nde m'en excuser...[K] j'insiste pour opérer seul\ndans cette affaire.", german="Also muss ich mich\nentschuldigen[K] und darauf bestehen, dass ich\n[CS:N]Reptain[CR] allein stelle.", italian="Dovete perdonarmi...[K] Temo\nche dovrò catturare [CS:N]Grovyle[CR] da solo.", spanish="Así que debo disculparme...[K]\ne insistir en que debo capturar a [CS:N]Grovyle[CR]\nsolo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, right.[K] That's too bad.", french=" Bon, d'accord.[K] Tant pis.", german=" Oh, er hat recht.[K] Wie schade.", italian=" Capisco.[K] Che peccato...", spanish=" Vaya.[K] Qué pena."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, I get it.[K] That's too bad.", french=" Bon, d'accord.[K] Tant pis.", german=" Oh, verstehe.[K] Wie schade.", italian=" Capisco.[K] Che peccato...", spanish=" Ya veo.[K] Qué pena."})
  else
  SkySceneKit.say({english=" Oh, I see.[K] That's too bad.", french=" Bon, d'accord.[K] Tant pis.", german=" Oh, verstehe.[K] Wie schade.", italian=" Capisco.[K] Che peccato...", spanish=" Ya veo.[K] Qué pena."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I'm terribly sorry, [partner].", french="Je suis terriblement désolé,\n[partner].", german="Es tut mir sehr leid,\n[partner].", italian="Sono davvero spiacente,\n[partner].", spanish="Lo siento muchísimo,\n[partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="This time I hope to capture\n[CS:N]Grovyle[CR] without any mistakes.", french="Cette fois-ci, j'ai bon espoir de\nréussir à capturer [CS:N]Massko[CR].", german="Diesmal will ich sichergehen,\ndass ich [CS:N]Reptain[CR] fange.", italian="Questa volta non commetterò\nerrori e catturerò [CS:N]Grovyle[CR] una volta per tutte.", spanish="Esta vez intento capturar a\n[CS:N]Grovyle[CR] sin cometer ningún error."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please forgive my selfishness.", french="Je te prie de pardonner mon\nindividualisme.", german=" Bitte verzeiht meinen Egoismus.", italian="Spero comprenderete le mie\nragioni.", spanish="Espero que perdonéis mi\negoísmo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(0), p.Y+(-16), false, 1) end
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Down)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Down)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  GROUND:EntTurn(npc_npc_taneboo, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.UpRight)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's how it stands, guild\nmembers.", french="La question est réglée, vous\nautres.", german=" So sieht es aus, Gildenmitglieder.", italian="Membri della Gilda! Il dado è\ntratto!", spanish=" Ya habéis oído lo que pasa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Up to now...", french=" Jusqu'à maintenant...", german=" Bis jetzt...", italian=" Fino a questo momento...", spanish=" Hasta ahora..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We were capturing [CS:N]Grovyle[CR]![K]\nYoom...taah!", french="... nous allions capturer [CS:N]Massko[CR]![K]\nTa... daaa!", german="Bis jetzt waren wir auf der\nJagd nach [CS:N]Reptain[CR]![K] Luuu... fiii!", italian="... eravamo tutti concentrati\nsulla cattura di [CS:N]Grovyle[CR]![K] Badabuuum!", spanish="Estábamos intentando capturar\na [CS:N]Grovyle[CR].[K] ¡Todo el [CS:N]Pokégremio[CR]!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" At least, that was the plan.", french=" Ou du moins, c'était le plan.", german=" Das war jedenfalls der Plan.", italian=" Ma il piano è cambiato.", spanish=" Al menos ese era el plan."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This time, stay out of it.[K]\nWe'll provide support only as needed!", french="Cette fois-ci, on reste en dehors\nde tout ça.[K] On apportera notre soutien\nsi besoin est!", german="Haltet euch diesmal raus.[K]\nWir bieten unsere Hilfe nur an, wenn sie\ngebraucht wird!", italian="Questa volta, non dobbiamo\nimpicciarci.[K] Daremo il nostro aiuto solo se\nnecessario!", spanish="Esta vez no intervengáis.[K]\n¡Ofreceremos apoyo solo si es necesario!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Well, hey, hey...", french=" Bon, dis donc...", german=" Tja, hey, hey...", italian=" Beh... ehi, ehi...", spanish=" Bueno, oye, oye..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" If that's what it takes...", french=" Si c'est nécessaire...", german=" Meinetwegen...", italian=" Se è davvero necessario...", spanish=" Si no se puede hacer otra cosa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We have no choice...?", french=" Nous n'avons pas le choix...?", german=" Wir haben keine Wahl?", italian=" Non abbiamo scelta...", spanish=" ¿No tenemos elección...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Is that an acceptable plan?[K]\nGuildmaster?", french="Ce plan vous convient-il?[K]\nMaître?", german="Ist dieser Plan akzeptabel?[K]\nGildenmeister?", italian="Concorda con questo piano?[K]\nCapitano?", spanish="¿Aceptamos entonces ese plan?[K]\n¿Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 312, 184, Direction.DownRight, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yup, yup! ♪", french=" Ouais, ouais! ♪", german=" Ja, ja! ♪", italian=" Oh sì! Ullalà! ♪", spanish=" ¡Sí, sí, sí! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Thank you for confirming that.\n(Whew! He stayed awake! Thank goodness!)", french="Merci de me le confirmer.\n(Ouf! Cette fois, il ne s'est pas endormi!)", german="Danke für die Bestätigung.\n(Puh! Er ist noch wach!)", italian="La ringrazio per la sua\napprovazione. (Fiuuu! È riuscito a rimanere\nsveglio!)", spanish="Gracias por la confirmación.\n(¡Menos mal! ¡Esta vez no se ha dormido!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Thank you for hearing me out,\neveryone.", french=" Merci de votre attention.", german="Danke, dass ihr mir alle\nzugehört habt.", italian=" Grazie della vostra attenzione.", spanish="Gracias a todos por vuestra\natención."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I realize I am asking a huge\nfavor. But please do your part in our plan.", french="Je me rends compte que je vous\ndemande une énorme faveur. Mais remplissez\ntout de même votre rôle dans ce plan.", german="Ich weiß, dass ich euch um\neinen großen Gefallen bitte. Erledigt bitte\neuren Teil des Plans.", italian="So di chiedere tanto, ma vi\nprego di fare la vostra parte.", spanish="Me doy cuenta de que os estoy\npidiendo un gran sacrificio, pero espero\nque podáis cumplir vuestra parte del plan."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Let's capture [CS:N]Grovyle[CR] using\nwhatever means necessary!", french="Capturons [CS:N]Massko[CR], coûte\nque coûte!", german="Lasst uns [CS:N]Reptain[CR] fangen, koste\nes, was es wolle!", italian="... facciamo tutto quello che è\nin nostro potere per catturare [CS:N]Grovyle[CR]!", spanish="¡Hay que hacer todo lo necesario\npara capturar a [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_4 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: YEAH!", french="[CS:N]Tous[CR]: OUAIS!", german="[CS:N]Alle[CR]: JAAA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡SÍ!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]And thus...", french="[CN]Ainsi donc...", german="[CN]Und so", italian="[CN]E così...", spanish="[CN]Y así..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN][CS:N]Dusknoir[CR] and the trio of\n[CN][CS:N]Uxie[CR], [CS:N]Mesprit[CR], and [CS:N]Azelf[CR]...", french="[CN][CS:N]Noctunoir[CR], [CS:N]Créhelf[CR], [CS:N]Créfollet[CR]\n[CN]et [CS:N]Créfadet[CR]...", german="[CN]macht sich [CS:N]Zwirrfinst[CR] mit [CS:N]Selfe[CR],\n[CN][CS:N]Vesprit[CR] und [CS:N]Tobutz[CR]...", italian="[CN][CS:N]Dusknoir[CR], accompagnato da\n[CN][CS:N]Uxie[CR], [CS:N]Mesprit[CR] e [CS:N]Azelf[CR]...", spanish="[CN][CS:N]Dusknoir[CR] y el trío formado por\n[CN][CS:N]Uxie[CR], [CS:N]Mesprit[CR] y [CS:N]Azelf[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]set off for [CS:P]Crystal Cave[CR].", french="[CN]... se mirent en route pour la [CS:P]Caverne Cristal[CR].", german="[CN]auf den Weg zur [CS:P]Kristallhöhle[CR].", italian="[CN]... si dirige verso la [CS:P]Grotta di Cristallo[CR].", spanish="[CN]Partieron hacia la [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]In the meantime, the other\n[CN]Pokémon busied themselves...", french="[CN]Pendant ce temps, les autres\n[CN]Pokémon travaillèrent...", german="[CN]In der Zwischenzeit\n[CN]sind die anderen Pokémon damit beschäftigt,", italian="[CN]Nel frattempo, gli altri\n[CN]Pokémon si danno da fare...", spanish="[CN]Mientras tanto, los demás Pokémon\n[CN]se mantuvieron ocupados..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]spreading rumors that\n[CN][CS:N]Azelf[CR] and the others were\n[CN]about to seal the Time Gear away.", french="[CN]... à propager la rumeur selon laquelle\n[CN][CS:N]Créfadet[CR] et les autres s'apprêtaient\n[CN]à sceller à jamais le Rouage du Temps.", german="[CN]das Gerücht zu verbreiten,\n[CN]dass [CS:N]Tobutz[CR] und die anderen\n[CN]das Zahnrad der Zeit versiegeln wollen.", italian="[CN]Spargono la voce che\n[CN][CS:N]Azelf[CR] e gli altri renderanno per sempre\n[CN]inaccessibile l'Ingranaggio del Tempo.", spanish="[CN]Extendiendo el rumor de que\n[CN][CS:N]Azelf[CR] y los otros dos Pokémon\n[CN]iban a sellar el Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]As for those Pokémon from\n[CN][CS:N]Wigglytuff[CR]'s Guild...", french="[CN]Quant aux membres de la Guilde\n[CN]de [CS:N]Grodoudou[CR]...", german="[CN]Was die Pokémon\n[CN]der [CS:N]Knuddeluff-Gilde[CR] angeht...", italian="[CN]Nel frattempo,\n[CN]i Pokémon della Gilda di [CS:N]Wigglytuff[CR]...", spanish="[CN]En cuanto a los miembros del\n[CN][CS:N]Pokégremio de Exploradores[CR]..."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_taneboo, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Left)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Up)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Up)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GROUND:EntTurn(npc_npc_poppo, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_oosubame, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_4 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "happy", 1) end)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_5 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_2 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Left)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GROUND:EntTurn(npc_npc_oosubame, Direction.Up)
  GROUND:EntTurn(npc_npc_poppo, Direction.Right)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_emuritto, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yukushii, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_agunomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
