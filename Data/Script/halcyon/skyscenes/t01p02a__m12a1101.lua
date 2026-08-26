-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m12a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 368, 200, Direction.Down, "NPC_RURIRI")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Oh, wow! We got our [CS:Z]Water\nFloat[CR] back!", french="Waouh! On a récupéré notre\n[CS:Z]Hydroflotteur[CR]!", german="Oh, wow! Wir haben unseren\n[CS:Z]Schwimmreif[CR] wieder!", italian=" Oh, wow! È l'[CS:Z]Acquaboa[CR]!", spanish="¡Qué chachi! ¡Hemos recuperado\nnuestro [CS:Z]Flotarill[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 368, 216, Direction.Up, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, hero, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yay! Thank you! Really!", french=" Youpi! Merci de tout cœur!", german=" Jaaa! Danke! Wirklich!", italian="Evviva! Grazie mille! È\nfantastico!", spanish="¡Genial!\n¡Muchas gracias! ¡De verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You saved [CS:N]Azurill[CR] way back\nwhen, and now this!", french="Vous avez déjà sauvé [CS:N]Azurill[CR]\net maintenant ça!", german="Ihr habt damals [CS:N]Azurill[CR] gerettet,\nund jetzt das!", italian="L'altra volta avete salvato\n[CS:N]Azurill[CR], e adesso questo!", spanish="Primero salvasteis a [CS:N]Azurill[CR],\n¡y ahora esto!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I don't know how we could ever\nthank you!", french="On ne pourra jamais assez vous\nremercier!", german="Ich weiß nicht, wie wir euch\njemals danken können!", italian="Non potremo mai ringraziarvi\nabbastanza!", spanish=" ¡No sé cómo agradecéroslo!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" But, really...[K]thank you!", french=" Vraiment...[K] merci!", german=" Aber, wirklich...[K] Danke!", italian=" Di cuore...[K] ancora grazie!", spanish=" De verdad...[K] ¡Muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="If [CS:N]Dusknoir[CR] hadn't been there,\nwe wouldn't be here now!", french="Sans son aide, nous ne serions\npas là à l'heure qu'il est!", german="Wäre [CS:N]Zwirrfinst[CR] nicht\ndagewesen, wären wir jetzt nicht hier!", italian="Se non fosse stato per il signor\n[CS:N]Dusknoir[CR], forse non saremmo qui a parlare con\nvoi, ora.", spanish="Si [CS:N]Dusknoir[CR] no nos hubiera\nayudado, ahora no estaríamos aquí."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_mariru, 364, 240, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_ruriri, 364, 220, false, 2)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 328, 248, Direction.UpRight, "NPC_YONOWAARU")
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GROUND:EntTurn(npc_npc_mariru, Direction.Left)
  GROUND:EntTurn(npc_npc_ruriri, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Thank you very much!", french=" Merci beaucoup!", german=" Vielen, vielen Dank!", italian=" Grazie infinite!", spanish=" ¡Muchísimas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Thank you, [CS:N]Dusknoir[CR], sir!", french=" Merci, messire [CS:N]Noctunoir[CR]!", german=" Danke, [CS:N]Zwirrfinst[CR]!", italian=" Grazie, signor [CS:N]Dusknoir[CR]!", spanish=" ¡Gracias, señor [CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="No trouble at all. I'm very happy\nfor you.", french="Je vous en prie, je me réjouis\nde vous voir si heureux.", german="Nicht der Rede wert. Ich freue\nmich sehr für euch.", italian="Non è nulla, ragazzi. Sono\ncontento per voi.", spanish="No hay de qué. Me alegro por\nvosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's wonderful that your\n[CS:Z]Water Float[CR] has come back to you.", french="C'est merveilleux que vous ayez\nrécupéré votre [CS:Z]Hydroflotteur[CR].", german="Es ist wunderbar, dass ihr euren\n[CS:Z]Schwimmreif[CR] wiederhabt.", italian="Mi compiaccio del fatto che siate\ntornati in possesso dell'[CS:Z]Acquaboa[CR].", spanish="Es estupendo que hayáis\nrecuperado vuestro [CS:Z]Flotarill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I must say! It is so like the\ngreat [CS:N]Dusknoir[CR] to be so modest!", french="Il faut avouer qu'une telle\nmodestie n'est pas étonnante de la part\ndu grand [CS:N]Noctunoir[CR]!", german="Ich muss schon sagen, es sieht\ndem großen [CS:N]Zwirrfinst[CR] sehr ähnlich,\nso bescheiden zu sein!", italian="Lo sapevo! Ero sicuro che il\ngrande [CS:N]Dusknoir[CR] non era uno che si dava delle\narie!", spanish="¡Vaya! ¡Qué modesto es el gran\n[CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="And I must say that Team\n[team:] has also been superb!", french="Et j'ajoute que l'Equipe\n[team:] a été formidable, elle aussi!", german="Und ich muss sagen, dass auch\nTeam [team:] großartig war!", italian="E lasciatemi aggiungere una\ncosa! Il Team [team:] è stato fantastico!", spanish="¡Y debo decir que el [CS:X]Equipo[CR]\n[team:] también ha estado soberbio!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="After all, the team has again\ncompleted a difficult job!", french="Une fois de plus, cette équipe\na accompli une mission des plus ardues!", german="Das Team hat schließlich einen\nschwierigen Job gemeistert!", italian="Hanno completato la loro\nmissione in modo eccezionale!", spanish="Después de todo, ¡ha llevado\na cabo una misión muy difícil!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="When rescuing [CS:N]Azurill[CR], you were\nso fast at pinpointing the child's whereabouts!", french="Quand vous avez secouru [CS:N]Azurill[CR],\nvous l'avez localisé à une vitesse\nphénoménale!", german="Als ihr [CS:N]Azurill[CR] gerettet habt,\nhabt ihr so schnell herausgefunden, wo der\nKleine ist!", italian="Quando avete salvato [CS:N]Azurill[CR],\navete scoperto subito dove si trovava il\npiccolo!", spanish="En el rescate de [CS:N]Azurill[CR], fueron\nmuy rápidos a la hora de localizarlo."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="And so fast at reaching our\nyoung friend too!", french="Et vous l'avez rejoint tout aussi\nrapidement!", german="Und wie schnell ihr ihn gerettet\nhabt!", italian=" E l'avete anche raggiunto subito!", spanish="¡Y llegaron hasta nuestro\namiguito muy pronto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kakureon1, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_kakureon1, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_kakureon1, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_kakureon1, 4) end)
  SkySceneKit.say({english="It would be great...if it truly\nhappened the way [CS:N]Kecleon[CR] said...", french="Ce serait génial si... ça s'était\nvraiment passé comme tu l'as dit, [CS:N]Kecleon[CR]...", german="Es wäre toll, wenn es sich\nwirklich so zugetragen hätte, wie du gesagt\nhast, [CS:N]Kecleon[CR]...", italian="Sarebbe bello se fosse andata\ncome dice [CS:N]Kecleon[CR]...", spanish="Sería genial que hubiera sucedido\ntal y como lo ha contado [CS:N]Kecleon[CR]..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="We didn't pin down [CS:N]Azurill[CR]'s\nlocation before we rescued him.", french="On n'a pas vraiment localisé\n[CS:N]Azurill[CR] avant d'aller le secourir.", german="Wir haben nicht wirklich\nherausgefunden, wo [CS:N]Azurill[CR] sich befindet.", italian="A dire il vero abbiamo scoperto\ndove si trovava [CS:N]Azurill[CR] in una maniera un po'\nstrana.", spanish="No tuvimos que buscar mucho\nel lugar en el que estaba [CS:N]Azurill[CR] para ir\na rescatarlo."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="My partner here just happened\nto see it in a dream.", french="En fait, mon acolyte l'a\nsimplement vu en rêve.", german="Mein Partner hat es zufällig in\neinem Traum gesehen.", italian="In realtà, il luogo l'ha visto in un\nsogno.", spanish="Mi acompañante lo vio en\nun sueño."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Excuse me?[K] A dream, you say?", french="Excusez-moi?[K] En rêve,\ndites-vous?", german="Wie bitte?[K] In einem Traum,\nsagst du?", italian=" Chiedo scusa...[K] In sogno, dici?", spanish=" ¿Cómo dices?[K] ¿En un sueño?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" By dream, what do you mean?", french=" Qu'entendez-vous par \\\"rêve\\\"?", german=" Was meinst du mit Traum?", italian=" Puoi spiegarti meglio?", spanish="¿Qué quieres decir con eso\nde un sueño?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="And then my partner sees or\nhears events that happened in the past! Or just\nabout to happen in the future!", french="Et alors ça lui fait voir ou\nentendre des choses qui se sont déjà produites.\nOu qui se produiront dans le futur!", german="Und dann sieht oder hört mein\nPartner Ereignisse aus der Vergangenheit!\nOder aus der Zukunft!", italian="E quando succede è in grado di\nvedere nel passato o nel futuro!", spanish="¡Y entonces puede ver cosas\nque han sucedido en el pasado, o que\nestán a punto de suceder!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" What?![K] Well, that's...[K]that's...", french="Comment?![K] Eh bien il s'agit...[K]\nil s'agit...", german=" Was?!?[K] Nun, das ist...[K] Das ist...", italian="Cosa?![K] Ma allora...[K]\nsi tratta certamente...", spanish=" ¡¿Qué?![K] Pero eso es...[K] Es..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" The Dimensional Scream!", french=" ... du Cri Dimensionnel!", german=" Der Dimensionale Schrei!", italian=" ... dello Squarcio Dimensionale!", spanish=" ¡La Percepción de Cronos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 340, 216, false, 2)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  SkySceneKit.say({english=" In that case...", french=" Dans ce cas...", german=" Wenn das so ist...", italian=" Oh! A proposito!", spanish=" Entonces..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  SkySceneKit.say({english="Should we ask if [CS:N]Dusknoir[CR]\nknows even more?!", french="Dis, on devrait peut-être\ndemander au grand [CS:N]Noctunoir[CR] de nous en dire\nplus?!", german="Sollten wir den großen\n[CS:N]Zwirrfinst[CR] fragen, ob er noch mehr weiß?!?", italian="Perché non chiediamo al signor\n[CS:N]Dusknoir[CR] se sa qualcos'altro?", spanish="Tendríamos que preguntarle a\n[CS:N]Dusknoir[CR]. Igual sabe algo más, ¿no?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Ask about what...?)", french="(Lui demander quoi...?)", german="(Nach was sollten wir fragen?)", italian="(Aspetta! Chiedere cosa...?)", spanish="(¿Preguntarle qué...?)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(About my own forgotten past!)", french="(Des précisions sur mon passé!)", german="(Nach meiner vergessenen Vergangenheit!)", italian="(Forse sa qualcosa del mio passato!)", spanish="(¡Preguntarle por mi extraña amnesia!)"}) -- SwitchMonologue: branche default
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  SkySceneKit.say({english="It's OK to ask, right,\n[hero]?", french="On peut lui demander, pas vrai,\n[hero]?", german="Es ist doch okay, zu fragen,\n[hero]?", italian="Tentar non nuoce, giusto\n[hero]?", spanish="No te importa que se lo\npregunte, ¿verdad, [hero]?"}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, we were\nwondering if we could get your advice about\nsomething.", french="Messire [CS:N]Noctunoir[CR], il y a\nquelque chose qu'on voudrait vous demander.", german="[CS:N]Zwirrfinst[CR], wir würden\ngerne deinen Ratschlag zu einer Sache hören.", italian="Signor [CS:N]Dusknoir[CR], abbiamo bisogno\ndel suo aiuto!", spanish="[CS:N]Dusknoir[CR], hay algo sobre lo que\nnos gustaría pedirte consejo."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
