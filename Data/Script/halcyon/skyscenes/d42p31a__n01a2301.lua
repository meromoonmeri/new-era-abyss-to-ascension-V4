-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P31A/n01a2301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=40, sub=7} -- $SCENARIO_SIDE = scn[40,7] (ROM)
  -- back_SetGround(LEVEL_D42P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 224, 264, Direction.Up, "NPC_GURAIGAA")
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" St...", french=" Trop...", german=" St...", italian=" Che...", spanish=" Ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 288, 264, Direction.Up, "NPC_TATSUBEI")
  pcall(function() GROUND:CharSetEmote(npc_npc_tatsubei, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Strong...", french=" ... forts...", german=" Stark...", italian=" Forza...", spanish=" Qué fuertes son..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 256, 256, Direction.Up, "NPC_YUKIKABURI")
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Eeee...[K] Eeeeeeeeek!", french=" Aaaa...[K] Aaaaarrrrgh!", german=" Urks...[K] Uaarrrkkss!", italian=" Iii...[K] Iiiiiiiiiiiih!", spanish=" Aaaa...[K] ¡Aaaaaay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(7)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 256, 216, Direction.Down, "NPC_HEIGANI")
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(28), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Maybe you should stop your\nwrongdoing! Hey, hey!", french="Pince alors! Il serait peut-être\ntemps d'arrêter vos méfaits!", german="Denkt mal drüber nach, eure\nUntaten sein zu lassen! Hey, hey!", italian="Avete chiuso con le vostre\nmalefatte! Ehi, ehi!", spanish="¡Ya va siendo hora de que\ndejéis de hacer maldades!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 192, 184, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Are you all right, [CS:Y]Bidoof[CR]?", french=" Tout va bien, [CS:Y]Keunotor[CR]?", german=" Geht es dir gut, [CS:Y]Bidiza[CR]?", italian=" Stai bene, [CS:Y]Bidoof[CR]?", spanish=" ¿Estás bien, [CS:Y]Bidoof[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-16), 32, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 256, 176, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 296, 184, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 224, 184, Direction.Down, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 160, 232, Direction.DownRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 336, 200, Direction.DownLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, hero, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 304, 224, Direction.Down, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 344, 232, Direction.DownLeft, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] Thanks, everyone.", french=" Snif...[K] Merci, les gars.", german=" Schnüff...[K] Danke, euch allen.", italian=" Sniff...[K] Vi ringrazio gente.", spanish=" Jo...[K] Gracias a todos."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It was because you all came to\nhelp that I'm all right...", french="C'est grâce à vot' coup d'main\nque j'me porte bien...", german="Nur weil ihr mir geholfen habt,\nbin ich noch wohlauf...", italian="È stato solo grazie al vostro\nintervento se non mi sono fatto nulla...", spanish="Si estoy bien es gracias a que\nhabéis venido a ayudarme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] What are you all\ndoing here?", french="Mais...[K] qu'est-ce qu'vous faites\ntous ici?", german="Aber...[K] Was macht ihr alle\nüberhaupt hier?", italian=" Ma...[K] cosa ci fate tutti qui?", spanish="Pero...[K] ¿qué estáis haciendo\ntodos aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR] told us about\nyou acting strangely.", french="[CS:N]Pijako[CR] nous a raconté que tu\nte comportais trop bizarrement ces\nderniers temps.", german="[CS:N]Plaudagei[CR] hat uns erzählt, wie\neigenartig du dich verhalten hast.", italian="[CS:N]Chatot[CR] ci ha raccontato che\nti stavi comportando in maniera strana.", spanish="[CS:N]Chatot[CR] nos dijo que estabas\nactuando de una forma como muy rara."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR] did?", french=" [CS:N]Pi-Pijako[CR] a dit ça?", german=" [CS:N]Pl-Plaudagei[CR] hat...", italian=" [CS:N]Ch-Chatot[CR]?", spanish=" ¿Eso os dijo [CS:N]Chatot[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 252, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You were acting really strange...", french="Ton comportement était\nvraiment étrange...", german="Du hast dich wirklich sehr\neigenartig benommen.", italian="Beh, ti stavi comportando\nin maniera davvero strana...", spanish=" Estabas rarísimo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Daydreaming...", french=" La tête dans les étoiles...", german="Vollkommen abwesend gemurmelt\nund eigenartig gegrinst...", italian=" Avevi la testa tra le nuvole...", spanish=" Soñabas despierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And then suddenly you wanted to\ntake the day off.", french="Et puis cette soudaine envie de\nprendre quelques jours de congé...", german="Und dann hast du plötzlich ein\nbisschen freie Zeit beantragt.", italian="Poi improvvisamente mi hai\ndetto che avevi bisogno di una vacanza.", spanish="Y de repente te dio por pedir\nvacaciones."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So I talked to the Guildmaster...", french=" Alors j'en ai parlé au Maître...", german="Also hab ich mit dem\nGildenmeister gesprochen.", italian=" Così ho parlato con il Capitano...", spanish=" Así que hablé con el Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And secretly followed you to see\nwhat you were up to.", french="... et je t'ai suivi discrètement\npour voir où tu allais.", german="Und bin dir zudem heimlich\ngefolgt, um zu sehen, was du vorhast.", italian="E ho cominciato a seguirti di\nnascosto per scoprire cosa avevi in mente.", spanish="Y te seguí a escondidas para\nenterarme de qué estabas tramando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-is that so...?", french=" C'est... c'est vrai...?", german=" W-wirklich?", italian=" D-Davvero...?", spanish=" ¿De... De verdad...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I...[K]I will say this one thing...", french=" Je...[K] Laisse-moi t'expliquer...", german=" Ich...[K] Ich sage dir eins...", italian=" Ma...[K] sappi solo una cosa...", spanish=" Solo...[K] Solo voy a decir esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It wasn't because I was worried\nabout you...[K] No, I didn't think I'd tag\nalong because I was worried at all!", french="Ce n'est pas que je\nm'inquiétais...[K] Non, ce n'est pas du tout ça!", german="Das habe ich nicht gemacht, weil\nich dir nichts zugetraut habe...[K] Nein, vielmehr\nhabe ich mich grundsätzlich gesorgt.", italian="Non l'ho fatto perché ero\npreoccupato per te...[K] Non ti ho pedinato\nper questo, assolutamente no!", spanish="No ha sido porque estuviera\npreocupado por ti...[K] ¡No, ni se me pasó por\nla cabeza seguirte porque me preocuparas!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You were acting really strange...", french="Tu te comportais vraiment\nbizarrement...", german="Du hast dich wirklich sehr\neigenartig benommen.", italian="Ti comportavi in maniera\nmolto strana...", spanish=" Estabas rarísimo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I thought maybe you were\ndeserting the guild...[K]so I had to see\nfor myself. That's it!", french="Je me suis dit que tu cherchais\npeut-être à déserter la Guilde...[K] Alors j'ai\ndécidé d'en avoir le cœur net. Voilà tout!", german="Ich musste die Möglichkeit in\nBetracht ziehen, dass du der Gilde den Rücken\nkehrst...[K] Das wollte ich selbst überprüfen.", italian="Pensavo che magari volessi\nabbandonare la Gilda...[K] quindi dovevo\nesserne sicuro. Tutto qua!", spanish="Pensaba que quizá quisieras dejar\nel [CS:N]Pokégremio[CR]...[K] Así que tenía que ver\nqué pasaba con mis propios ojos. ¡Eso es todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Don't misunderstand!", french=" Ne va pas te faire des idées!", german=" Versteh das bitte nicht falsch!", italian=" Non fraintendetemi!", spanish=" ¡No me interpretes mal!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh! Well put!", french=" Mwé hé hé! Bien parlé!", german=" Mehehe! Gut ausgedrückt!", italian=" Eh eh eh! Come no?", spanish=" ¡Je, je, je! ¡Bien explicado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WELL said! TRULY!", french=" ÇA c'est BIEN parlé! VRAIMENT!", german=" SEHR gut formuliert! EHRLICH!", italian=" GIÀ! Come NO?!", spanish=" ¡Bien dicho! ¡De verdad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR], when you told everyone\nabout [CS:Y]Bidoof[CR]...", french="Pourtant [CS:N]Pijako[CR], quand tu nous\nas parlé de [CS:Y]Keunotor[CR]...", german="[CS:N]Plaudagei[CR], als du uns\nallen von [CS:Y]Bidiza[CR] erzählt hast...", italian="[CS:N]Chatot[CR], quando ci hai parlato\ndi [CS:Y]Bidoof[CR]...", spanish="[CS:N]Chatot[CR], cuando le contaste a todo\nel mundo lo de [CS:Y]Bidoof[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You really were worried\nabout him. Hey, hey!", french="... tu avais l'air vraiment\ninquiet, dis donc!", german="Du hast dir wirklich Sorgen\ngemacht. Hey, hey!", italian="Eri davvero molto preoccupato\nper lui. Ehi, ehi!", spanish=" Se te notaba muy preocupado por él."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" B-be[K] quiet!!", french=" M-mais...[K] de quoi je me mêle!!", german=" Psst!!![K] Still!!!", italian=" Z...[K] Zitti!!", spanish=" Pero...[K] ¡qué exagerado!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As for everyone coming along...[K]\nAt first, it was going to be myself and the\nGuildmaster coming to your rescue, [CS:Y]Bidoof[CR]...", french="Quant à la raison de notre\nprésence à tous...[K] Je devais juste venir\navec le Maître pour te sauver, [CS:Y]Keunotor[CR].", german="Und warum wir alle hier sind...[K]\nZuerst wollten nur der Gildenmeister und ich\ndir folgen, um dich zu beschützen, [CS:Y]Bidiza[CR].", italian="E per quanto riguarda gli altri...[K]\nAll'inizio dovevamo venire a salvarti\nsolo io e il Capitano, [CS:Y]Bidoof[CR]...", spanish="Respecto a lo de venir todos...[K]\nEn un principio solo íbamos a venir a\nrescatarte el Gran Bluff y yo, [CS:Y]Bidoof[CR]..."})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But in the end, everyone wanted\nto come along! HUMPH!", french="Mais à la fin, tout le monde a\neu envie de venir! HUMPH!", german="Aber zum Schluss wollten alle\nmitkommen! HUMPF!", italian="Ma poi si sono voluti aggregare\ntutti quanti! BAH!", spanish="Pero al final quisieron venir\ntodos. ¡Todos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Because...", french=" Parce que...", german="Der Grund DAFÜR ist ganz\neinfach.", italian=" Perché...", spanish=" Porque..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Once we heard you were acting\nstrange, [CS:Y]Bidoof[CR]...", french="... quand on a entendu que tu\navais un drôle de comportement, [CS:Y]Keunotor[CR]...", german="Als wir hörten, dass du dich\nsonderbar verhältst, [CS:Y]Bidiza[CR]...", italian="... quando abbiamo sentito che ti\nstavi comportando in maniera strana, [CS:Y]Bidoof[CR]...", spanish="Cuando nos enteramos de que\nte comportabas de un modo extraño, [CS:Y]Bidoof[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We couldn't ignore it.", french="... on ne pouvait pas rester\nlà sans rien faire.", german="Wir konnten das nicht\neinfach ignorieren!", italian="... non potevamo fare finta\ndi niente.", spanish="Era algo que no podíamos\npasar por alto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-8), p.Y+(8), false, 1) end
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We've always been strict\nteachers in your training...", french="En tant que professeurs,\nnous avons toujours été très stricts avec toi...", german="Wir haben dein Training stets\nstreng gestaltet...", italian="Siamo sempre stati severi\ncon te durante gli allenamenti...", spanish="Siempre hemos sido maestros\nestrictos en cuanto a tu entrenamiento..."})
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But...[K] Of course we still care\nabout you, [CS:Y]Bidoof[CR].", french="Mais...[K] ça ne veut pas dire qu'on\nne se fait pas de souci pour toi, [CS:Y]Keunotor[CR].", german="Aber...[K] natürlich sorgen wir\nuns sehr um dich, [CS:Y]Bidiza[CR].", italian="Ma...[K] lo abbiamo fatto per\nil tuo bene, [CS:Y]Bidoof[CR].", spanish="Pero...[K] no hay ni que decir que\nnos importas mucho, [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So...[K][CS:Y]Bidoof[CR], we're just\nglad you're safe! ♪", french="Bref... [K][CS:Y]Keunotor[CR], nous sommes\nsoulagés de voir que tu es sain et sauf! ♪", german="Deswegen,[K] [CS:Y]Bidiza[CR], sind wir\nso froh, dass du in Sicherheit bist! ♪", italian="Quindi...[K] [CS:Y]Bidoof[CR], siamo felici\nche tu sia sano e salvo! ♪", spanish="Así que...[K] ¡Es un alivio ver que\nestás a salvo, [CS:Y]Bidoof[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...", french=" Snif...", german=" Schnüff...", italian=" Sniff...", spanish=" Ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Everyone...", french=" Les gars...", german=" Ihr alle...", italian=" Gente...", spanish=" Escuchadme todos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm sure happy...[K] You all did this\njust for me...[K] Sniff...", french="J'suis ému...[K] qu'vous ayez fait\ntout ça pour moi...[K] Snif...", german="Ich bin wirklich froh.[K] Ihr habt\ndas alles nur für mich getan...[K] Schnüff...", italian="Sono davvero felice...[K]\nAvete fatto tutto questo per me...[K] Sniff...", spanish="Qué felicidad...[K] Habéis hecho\ntodo esto por mí...[K] Buaa..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] Here I've gone and caused\nyou all trouble again...", french="Mais...[K] en venant ici, j'vous ai\nencore causé que des soucis...", german="Aber...[K] Jetzt habe ich euch allen\nmal wieder Umstände bereitet...", italian="Però...[K] venendo qui vi ho causato\naltri problemi...", spanish="Y encima...[K] Yo voy y os causo\nproblemas, como siempre..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I just can't seem to do anything\nright, yup yup...", french="Je fais rien qu'des balourdises,\nsapristi...", german="Ich kann wohl einfach nichts\nrichtig machen, jawollja...", italian="Pare proprio che non riesca\na combinarne una giusta, già, già...", spanish="Si es que nunca hago nada\na derechas, no, señor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" What?[K] That's not true...", french=" Quoi?[K] Mais pas du tout...", german=" Was?[K] Das stimmt aber nicht...", italian=" Cosa?[K] Non è affatto vero...", spanish=" ¿Cómo?[K] No es cierto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Nobody could take on an entire\nband of thieves by themselves, hey, hey.", french="Personne n'aurait pu se défaire\nseul de toute une bande de voleurs, pince alors!", german="Keiner hätte es allein mit einer\nRäuberbande aufnehmen können, hey, hey.", italian="Nessuno riuscirebbe a tenere\ntesta a un'intera banda di ladri, ehi, ehi.", spanish="Nadie podría vencer a toda una\nbanda de ladrones sin ayuda, oye."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You've GOTTEN much STRONGER.", french=" TU es DEVENU bien plus FORT.", german="Du BIST viel STÄRKER\ngeworden.", italian=" Sei DIVENTATO molto più FORTE.", spanish=" Te has fortalecido mucho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You're worried about failing...[K]\nBut...", french="C'est la perspective de l'échec\nqui te préoccupe...[K] Mais...", german="Du machst dir Sorgen, zu\nscheitern...[K] Aber...", italian="Ti preoccupi sempre\ndi commettere qualche errore...[K] ma...", spanish="Te preocupa fracasar...[K]\nSin embargo..."})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's how everyone\nbecomes stronger.", french="... c'est comme ça qu'on devient\nplus fort.", german="Genau auf diese Art gewinnst du\nan Stärke.", italian="... è così che si diventa\npiù forti.", spanish="Así es como todos nos hacemos\nmás fuertes."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's how the best explorers\nget to be that way.", french="C'est ainsi que les meilleurs\nexplorateurs sont devenus ce qu'ils sont.", german="Das macht die besten Erkunder\nerst zu dem, was sie sind.", italian="A tutti i migliori esploratori\nè capitato di fare degli sbagli.", spanish="Esa es la manera de llegar a ser\nun gran explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So failure is nothing to be\nembarrassed about.", french="Alors il ne faut pas faire toute\nune montagne d'un échec.", german="Deswegen sollte einem das\neigene Scheitern nicht peinlich sein.", italian="Non bisogna vergognarsi\ndi questo.", spanish="Por lo tanto, no debes\navergonzarte de tus fracasos."})
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
  SkySceneKit.say({english="Sniff...[K] Guildmaster...[K]\nEveryone...", french="Snif...[K] Maître...[K]\nLes gars...", german="Schnüff...[K] Gildenmeister...[K]\nAlle miteinander...", italian="Sniff...[K] Capitano...[K]\nGente...", spanish="Snif...[K] Gran Bluff...[K]\nSois todos estupendos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Thank you...[K] Thank you\nso much. Truly.", french="Merci...[K] merci mille fois.\nDu fond du cœur.", german="Ich danke euch...[K] Ich danke euch\nvon ganzem Herzen. Wahrhaft.", italian="Grazie...[K] Grazie davvero.\nDi cuore.", spanish="Gracias...[K] Muchísimas\ngracias. De corazón."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm sorry for troubling you...", french="J'suis confus d'vous avoir\ncausé des problèmes...", german="Es tut mir leid, dass ich euch\nauf Trab gehalten habe...", italian="Mi spiace di avervi fatto\npreoccupare...", spanish="Siento haberos causado\ntantas molestias."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="From now on, I won't be afraid\nof failure...[K] I'll be patient...", french="A partir d'maintenant, j'aurai\nplus peur de l'échec...[K] J'serai patient...", german="Von nun an werde ich keine\nAngst mehr vor dem Scheitern haben...[K]\nIch werde mich gedulden...", italian="D'ora in poi non avrò più paura\ndi commettere degli errori...[K] Sarò paziente...", spanish="A partir de ahora no le tendré\nmiedo al fracaso...[K] Tendré paciencia..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" And do my best...", french=" Et je ferai d'mon mieux...", german=" Und mein Bestes geben...", italian=" E farò del mio meglio...", spanish=" Y lo haré lo mejor que pueda..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yeah! ♪", french=" Oui! ♪", german=" Genau! ♪", italian=" Sì! ♪", spanish=" ¡Así se habla! ♪"})
  -- message_Close
  GAME:WaitFrames(40)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="That band of thieves were\npretty second-rate, weren't they?! Meh-heh!", french="Cette bande de voleurs, c'était\nune bande de rigolos, pas vrai?! Mwé hé hé!", german="Diese Räuberbande war aber\necht ein bisschen schwach, oder?!? Mehehe!", italian="Quella banda di ladri era\nproprio da due soldi, vero?! Eh eh!", spanish="Esa panda de ladrones era\nbastante cutrilla, ¿no? ¡Je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_heigani, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey! That's right!", french=" Saperlipopince! C'est bien vrai!", german=" Hey! Das stimmt!", italian=" Ehi! Puoi dirlo forte!", spanish=" ¡Ya te digo, oye!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But never mind that... So this is\n[CS:P]Star Cave[CR]?", french="Mais n'y pensons plus...\nAlors, voici la fameuse [CS:P]Caverne Etoile[CR]?", german="Aber das ist jetzt nicht so\nwichtig... Das hier ist also die [CS:P]Sternenhöhle[CR]?", italian="Ma nel darsela a gambe\nsono stati davvero bravi! Ehi, ehi!", spanish="Pero eso ya da igual... ¿Así que\nesta es la [CS:P]Cueva Estrella[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="They shouldn't have just\ngiven up and gone home! Hey, hey!", french="Ces vauriens ont eu tort de\npartir aussi vite, dis donc!", german="Dass sie einfach so aufgeben\nund nach Hause laufen! Hey, hey!", italian="Ma lasciamo perdere...\nAllora sarebbe questa la famosa\n[CS:P]Caverna Stellata[CR]?", spanish="¡Es increíble que se hayan\nrendido y se hayan marchado! ¡Qué locura!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh?[K] But there's nothing\nhere, right?", french="Hein?[K] Mais y'a rien ici,\npas vrai?", german="Was?[K] Aber hier ist doch nichts\nmehr, oder?", italian="Credo di sì...[K] Ma mi sembra che\nqui non ci sia niente.", spanish=" ¿Eh?[K] Pero si aquí no hay nada, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The cave just comes to a dead\nend right here...", french="La caverne s'termine\nen cul-de-sac...", german="Alles, was es hier gibt, ist\ndiese Sackgasse...", italian="La caverna finisce in questo\nvicolo cieco...", spanish="La cueva se acaba aquí y no\nhay por dónde avanzar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Jirachi[CR]'s not here, right?", french="[CS:N]Jirachi[CR] n'habite pas ici,\npas vrai?", german=" Kein [CS:N]Jirachi[CR], oder?", italian=" [CS:N]Jirachi[CR] non è qui, vero?", spanish=" [CS:N]Jirachi[CR] no está aquí, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Hey, [CS:Y]Bidoof[CR].", french=" Hé, [CS:Y]Keunotor[CR].", german=" Hey, [CS:Y]Bidiza[CR].", italian=" Ehi, [CS:Y]Bidoof[CR].", spanish=" Oye, [CS:Y]Bidoof[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  GROUND:MoveToPosition(npc_npc_pukurin, 252, 156, false, 2)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Did you FORGET?[K] We're an\nEXPLORATION team.", french="TU as OUBLIE?[K] Nous sommes une\néquipe d'EXPLORATION.", german="SCHON vergessen?[K] Wir SIND\nein ERKUNDUNGSTEAM.", italian="Lo hai DIMENTICATO?[K] Noi siamo\nuna squadra d'ESPLORAZIONE.", spanish="¿Es que lo has olvidado?[K] Somos\nun equipo de exploración."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Don't make fun of the\nGuildmaster's guild! ♪", french="C'est bien vrai! Nous ne sommes\npas du genre à nous laisser abattre! ♪", german="Richtig! Und wir sollten uns\nnicht so einfach geschlagen geben! ♪", italian="Mai sottovalutare\nla Gilda del Capitano! ♪", spanish="¡No te tomes a broma la labor\ndel [CS:N]Pokégremio de Exploradores[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GAME:MoveCamera(252, 208, 60, false) end) -- performer/caméra
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-24), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GAME:WaitFrames(30)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(-16), p.Y+(-16), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-8), p.Y+(-8), false, 2) end
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(16), p.Y+(-16), false, 2) end
  GAME:WaitFrames(4)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GAME:WaitFrames(30)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Hmmm...[K] Probably...[K]\nRight around here. ♪", french="Mmh...[K] Peut-être...[K]\nQuelque part par ici. ♪", german="Hmmm...[K] Vielleicht...[K]\nUngefähr hier. ♪", italian="Mmh...[K] Probabilmente...[K]\nÈ proprio qui. ♪", spanish="Hum...[K] Seguramente...[K]\nPor aquí. ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oooooo...", french=" Oooooo...", german=" Oooooo...", italian=" Oooooo...", spanish=" Ooh..."})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" OOOOOOOooooooooo...", french=" OOOOOOOooooooooo...", german=" OOOOOOOooooooooo...", italian=" OOOOOOOooooooooo...", spanish=" Uuuoooooh..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('1', '2', '2', '0')
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOOOOOOOOM...TAAAAAAAAAH!", french=" TAAAAAA-DAAAAAAAAAAAAAAA!", german=" LUUUUUUUUU... FIIIIIIIIIII!", italian=" BAAAAAADAAABUUUUUUM!", spanish=" ¡Vaaaaaa... mooooos!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(120)
  -- GAP: se_Play(7941) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() GAME:MoveCamera(764, 196, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 740, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_dogoomu, 796, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_chiriin, 708, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_heigani, 764, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_kimawari, 812, 188, Direction.Down)
  GROUND:TeleportTo(npc_npc_diguda, 836, 184, Direction.Down)
  GROUND:TeleportTo(npc_npc_dagutorio, 684, 196, Direction.Down)
  GROUND:TeleportTo(npc_npc_guregguru, 708, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 764, 188, Direction.Down)
  GROUND:TeleportTo(npc_npc_pukurin, 764, 148, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Waaah![K] Th-the wall collapsed...[K]\nThere's a huge opening there!", french="Waouh![K] Le...\nle mur s'est écroulé...[K] Y'a un trou\nbéant maintenant!", german="Donnerwetter![K]\nD-die Wand ist eingestürzt...[K]\nJetzt ist dort eine große Öffnung!", italian="Uaaah![K] I-Il muro è crollato...[K]\nÈ c'è un'enorme apertura dietro!", spanish="¡Aaah![K] El... El muro se ha\nderrumbado...[K] ¡Hay una abertura!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-there's...[K]more to this cave?", french="Ce... C'est donc pas encore...[K]\nle fond d'la caverne?", german="A-also...[K] geht die Höhle noch\nweiter?", italian=" L-La caverna...[K] prosegue?", spanish=" ¿Esta cueva...[K] continúa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All RIGHT! Let's GO!", french=" PARFAIT! En AVANT!", german=" Alle ZUSAMMEN! LOS geht's!", italian=" BENE! ANDIAMO!", spanish=" ¡Bueno, pues vamos allá!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I bet that the rare Pokémon\n[CS:N]Jirachi[CR] is there!", french="Je présume que le Pokémon\nmythique [CS:N]Jirachi[CR] habite derrière ce mur!", german="Ich wette, dass das seltene\nPokémon [CS:N]Jirachi[CR] dort auf uns wartet!", italian="Scommetto che il Pokémon raro\n[CS:N]Jirachi[CR] si trova lì dentro!", spanish="¡Seguro que ese Pokémon tan\nraro, [CS:N]Jirachi[CR], está allí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="We should all think about what\nwe're going to ask for! Hey, hey!", french="On devrait commencer à\nréfléchir à notre vœu, dis donc!", german="Denken wir schon mal darüber\nnach, was wir uns wünschen wollen! Hey, hey!", italian="Dovremmo pensare a cosa\nchiedergli! Ehi, ehi!", spanish="¡Oye, oye! ¡Deberíamos ir\npensando qué le vamos a pedir!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! I'm so excited!!", french=" J'hallucine! C'est trop excitant!!", german=" Auweia! Ich bin so aufgeregt!!!", italian=" Shock! Sono così emozionata!!!", spanish="¡Qué fuerte!\n¡Estoy supernerviosa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Everyone...[K] Wait a moment.", french=" Holà, tout le monde...[K] Attendez.", german="Alle miteinander...[K]\nWartet einen Augenblick.", italian=" Gente...[K] Aspettate un attimo.", spanish=" Un momento...[K] Esperad todos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's too bad...[K] But not everyone\ncan go ahead.", french="C'est dommage...[K] mais on ne peut\npas tous entrer là-dedans.", german="Zu schade...[K] Aber wir können\nnicht alle weitergehen.", italian="Lo so che non vi piacerà...[K]\nMa non potete proseguire.", spanish="Es una lástima...[K] pero\nno podemos continuar todos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAAAAT?!", french="[CS:N]Tous[CR]: QUOIIII?!", german="[CS:N]Alle[CR]: Waaaaas?!?", italian="[CS:N]Tutti[CR]: COOOSAAA?!", spanish="[CS:N]Todos[CR]: ¡¿Quéeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Wh-why NOT? Guildmaster?!", french=" Pou-pourquoi PAS? Maître?!", german="W-warum NICHT?\nGildenmeister?!?", italian=" P-Perché NO, Capitano?!", spanish=" ¡¿Por qué no, Gran Bluff?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="This exploration...[K] This is\n[CS:Y]Bidoof[CR]'s exploration.", french="Cette exploration...[K]\nC'est celle de [CS:Y]Keunotor[CR].", german="Diese Erkundung...[K] Es ist und\nbleibt die Erkundung von [CS:Y]Bidiza[CR].", italian="Questa esplorazione...[K]\nÈ l'esplorazione di [CS:Y]Bidoof[CR].", spanish="Esta exploración...[K] le pertenece\na [CS:Y]Bidoof[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whaaat?![K] Mine?! By golly!!", french=" Quoiiii?![K] La mienne?! Sapristi!!", german="Waaaas?!?[K] Meine?!?\nOh, Donnerwetter!!!", italian=" Cooosa?![K] La mia?! Ohibò!!!", spanish="¡¿Cómoo?![K] ¡¿De verdad?!\n¡¡Caramba!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep. ♪ [CS:Y]Bidoof[CR]'s. ♪", french="Eh oui. ♪ L'exploration\nde [CS:Y]Keunotor[CR]. ♪", german="Ja, genau. ♪\nDie von [CS:Y]Bidiza[CR]. ♪", italian=" Già. ♪ Di [CS:Y]Bidoof[CR]. ♪", spanish=" Sí. ♪ Es de [CS:Y]Bidoof[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You're the one who's got this\nmap, [CS:Y]Bidoof[CR]...[K] And you're the one who's\nadventured all the way here.", french="C'est toi qui possèdes la\ncarte, [CS:Y]Keunotor[CR]...[K] Et c'est toi qui\nt'es aventuré jusqu'ici.", german="Du hast die Karte erhalten,\n[CS:Y]Bidiza[CR].[K] Und du bist derjenige, der bereits\nden ganzen Weg bis hierher gekommen ist.", italian="Tu hai trovato questa mappa,\n[CS:Y]Bidoof[CR]...[K] E sei tu che ti sei avventurato\nfin qui.", spanish="Tú te hiciste con el mapa,\n[CS:Y]Bidoof[CR]...[K] Y tú te aventuraste hasta aquí,\npese a los riesgos que comportaba."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's why...[K]\nYou should go ahead alone, [CS:Y]Bidoof[CR].", french="C'est pourquoi...[K]\ntu devrais poursuivre seul, [CS:Y]Keunotor[CR].", german="Deswegen...[K] solltest du allein\nweitergehen, [CS:Y]Bidiza[CR].", italian="Ecco perché...[K]\nDovresti andare avanti da solo, [CS:Y]Bidoof[CR].", spanish="Por eso...[K]\nDeberías continuar solo, [CS:Y]Bidoof[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Yeah...[K] When you say it\nlike that...", french="Eh dis donc...[K]\nVu sous cet angle...", german=" Oh ja...[K] Wenn du es so sagst...", italian="Ok...[K] Se la metti in questo\nmodo...", spanish=" Pues sí...[K] Dicho así, es verdad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" That's the way it should be...", french=" Oui, ça semble juste...", german=" So soll es sein...", italian=" È giusto così...", spanish=" Así debería ser..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_pukurin, 740, 172, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_perappu, 788, 172, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, hero, 4) end)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We can only help you this far.[K]\nThe rest is up to you, [CS:Y]Bidoof[CR].", french="On ne peut plus t'aider à partir\nd'ici.[K] C'est à toi qu'il appartient d'accomplir\nle reste du chemin, [CS:Y]Keunotor[CR].", german="Wir können dich nur bis zu\ndiesem Punkt unterstützen.[K] Der Rest der\nHöhle gehört dir, [CS:Y]Bidiza[CR].", italian="Noi possiamo aiutarti solo fino\na qui.[K] Il resto dipende da te, [CS:Y]Bidoof[CR].", spanish="Aquí acaba nuestra ayuda.[K]\nEl resto depende de ti, [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Use your own strength...[K] And\ndo your best to have a successful exploration!", french="Utilise ta force...[K] et donne tout\nce que tu as pour faire de ton exploration\nun succès.", german="Nutze deine Stärken...[K] Und\nstreng dich an, damit diese Erkundung\nerfolgreich wird!", italian="Credi in te stesso e nella tua\nforza...[K] e fai del tuo meglio per portare\na termine questa esplorazione!", spanish="Usa tu fuerza...[K] ¡Y explora\ndándolo todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] Guildmaster...[K] Thank you\nso much, yup yup...", french="Snif...[K] Maître...[K]\nMerci beaucoup. Ouaip ouaip...", german="Schnüff...[K] Gildenmeister...[K]\nDanke vielmals, jawollja...", italian="Sniff...[K] Capitano...[K] Grazie mille,\ngià, già...", spanish="Snif...[K] Gran Bluff...[K] Muchísimas\ngracias, sí, señor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [CS:Y]Bidoof[CR]! Do your best!", french=" [CS:Y]Keunotor[CR]! Fais de ton mieux!", german=" [CS:Y]Bidiza[CR]! Gib dein Bestes!", italian=" [CS:Y]Bidoof[CR]! Dacci dentro!", spanish=" ¡A por todas, [CS:Y]Bidoof[CR]!"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Be sure to tell us all about your\nexploration later!", french="Tu n'oublieras pas de nous\nraconter ton exploration, surtout!", german="Aber bitte erzähl uns danach\nalles über deine Erkundung!", italian="Dopo devi raccontarci tutto\nquello che hai fatto!", spanish="¡Espero que luego nos cuentes\ncómo te ha ido la exploración!"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_diguda, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Do your best! Meh-heh-heh!", french=" Fais de ton mieux! Mwé hé hé!", german=" Gib dein Bestes! Mehehe!", italian=" Fai del tuo meglio! Eh eh eh!", spanish=" ¡A por todas! ¡Je, je, je!"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_guregguru, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff... Everyone...[K]\nThank you all so much...", french="Snif... Les gars...[K]\nMerci pour tout...", german="Schnief... Ihr alle...[K]\nIch danke euch so sehr...", italian="Sniff... Gente...[K]\nGrazie di cuore...", spanish="Ay... Muchas gracias...[K]\nMuchísimas gracias a todos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OK, then...[K] I'm off, yup yup!", french="Trêve de parlotte...[K]\nJe file, pardi!", german="Okay, dann mal los.[K]\nIch bin weg, jawollja!", italian=" Ok, allora...[K] io vado, già, già!", spanish=" Bueno...[K] ¡Me voy, sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'll do my best exploring!\nYup yup!", french="Je vais donner tout ce que j'ai\npour cette exploration! Ouaip ouaip!", german="Ich gebe mir Mühe mit der\nErkundung! Jawollja!", italian="Darò il massimo in questa\nesplorazione! Già, già!", spanish="¡Exploraré lo mejor que pueda!\n¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Hey! Do your best!\n(I really wanted to go...)", french="Hé! Fais de ton mieux!\n(Nous avions vraiment envie d'y aller,\nnous aussi...)", german="Hey! Alles Gute!\n(Ich wäre so gerne dabei...)", italian="Ehi! Dacci dentro!\n(Quanto vorremmo andare anche noi...)", spanish="¡Eh, ve a por todas!\n(Mira que teníamos ganas de ir...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" You can do it, [CS:Y]Bidoof[CR]!", french=" Tu peux y arriver, [CS:Y]Keunotor[CR]!", german=" Das schaffst du schon, [CS:Y]Bidiza[CR]!", italian=" Puoi farcela, [CS:Y]Bidoof[CR]!", spanish=" ¡Tú puedes, [CS:Y]Bidoof[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Do your best!", french=" Fais de ton mieux!", german=" Gib dein Bestes!", italian=" Fai del tuo meglio!", spanish=" ¡A por todas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(120)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" ...[K]There he goes, hey hey...", french="...[K] Et voilà, il est parti,\ndis donc...", german=" ...[K]Da geht er, hey, hey...", italian=" ...[K] Buona fortuna, ehi, ehi...", spanish=" Bueno...[K] Pues allá va, oye..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Anyway, Guildmaster...[K] You were\ncool today, as always...[K] Yay!", french="En tout cas, Maître...[K]\nVous avez été très sympa aujourd'hui,\ncomme toujours...[K] Ouais!", german="Übrigens, Gildenmeister...[K] Du\nwarst heute wieder sehr cool... Wie immer...[K]\nJuchhu!", italian="Comunque Capitano...[K] Sei stato\nfantastico, come sempre...[K] Eh sì!", spanish="En fin, Gran Bluff...[K] Hoy has\nestado genial, como siempre...[K] ¡Yupi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" You think so?", french=" Tu le penses?", german=" Findest du?", italian=" Lo pensi davvero?", spanish=" ¿Tú crees?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="YEAH.[K] Handing OVER the\nEXPLORATION to [CS:Y]Bidoof[CR] was a very GENEROUS\ngesture, I THINK.", french="OUAIS.[K] Confier l'EXPLORATION à\n[CS:Y]Keunotor[CR] était très GENEREUX de votre PART,\nJ'ESTIME personnellement.", german="GENAU.[K] Die ERKUNDUNG [CS:Y]Bidiza[CR]\nzu ÜBERLASSEN, war eine SEHR großzügige\nGESTE, finde ich.", italian="CERTO.[K] Cedere l'onore\ndell'ESPLORAZIONE a [CS:Y]Bidoof[CR] è stato\nun gesto davvero GENEROSO, credo.", spanish="Sí.[K] Dejar la exploración en\nmanos de [CS:Y]Bidoof[CR] ha sido un gesto\nmuy generoso, en mi opinión."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="BECAUSE [CS:N]Jirachi[CR] WILL grant\nWISHES, you know?", french="PARCE QUE [CS:N]Jirachi[CR] accorde\nVRAIMENT un VŒU, vous savez?", german="GERADE weil [CS:N]Jirachi[CR] WÜNSCHE\nerfüllt, NICHT wahr?", italian="PERCHÉ [CS:N]Jirachi[CR] esaudisce\nDESIDERI, no?", spanish="Por eso de que [CS:N]Jirachi[CR]\nconcede deseos, ya sabes."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="SO...[K] You COULD have made a\nWISH...[K] For all the PERFECT APPLES you\nCAN eat! HA HA HA!", french="DONC...[K] Vous AURIEZ pu faire le\nVŒU...[K] d'avoir une réserve INEPUISABLE de\nPOMMES PARFAITES! HA HA HA!", german="Dabei...[K] HÄTTEST du dir...[K]\nso viele PERFEKTE ÄPFEL wünschen KÖNNEN,\nwie du ESSEN kannst! HA HA HA!", italian="QUINDI...[K] Avresti POTUTO\nesprimerne uno...[K] Magari avere tutte\nle MELE PERFETTE che VUOI! AH AH AH!", spanish="Porque...[K] podrías haberle pedido\nun deseo...[K] ¡Todas las Manzanas Perfectas que\npuedas comerte! ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Anda..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Of course the Guildmaster is\njust wonderful!", french="Mais oui, le Maître est\ntrop épatant!", german="Selbstverständlich! Der\nGildenmeister ist so edel und bescheiden!", italian="Non è una novità che il Capitano\nsia meraviglioso!", spanish="¡Es que desde luego el Gran\nBluff es lo mejorcito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="His personality and presence...[K]\nHe has such a commanding aura...", french="Cette personnalité, cette\nprésence...[K] Il a la stature d'un grand chef...", german="Persönlichkeit und Präsenz...[K]\nEine unwiderstehliche Ausstrahlung\nnatürlicher Autorität...", italian="La sua personalità e presenza...[K]\nGli conferiscono un'aura di rispetto...", spanish="Su personalidad y su presencia...[K]\nimponen tanto respeto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="We're all proud to say that\nwe're apprentices in the guild! Hey, hey!", french="Nous sommes tous fiers de\npouvoir dire que nous faisons partie de\nvotre Guilde, dis donc!", german="Wir können alle froh sein,\nLehrlinge in seiner Gilde sein zu dürfen!\nHey, hey!", italian="Siamo tutti fieri di poter dire\nche facciamo parte della sua Gilda! Ehi, ehi!", spanish="¡Todos estamos orgullosos de\nser aprendices del [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I also joined the guild because\nI admired you, Guildmaster!", french="Moi aussi, si j'ai rejoint la\nGuilde, c'est parce que je vous admire, Maître!", german="Auch ich kam wegen meiner\nBegeisterung für den Gildenmeister zur Gilde!", italian="Anch'io sono entrato nella Gilda\nperché ti ammiravo tantissimo, Capitano!", spanish="Yo también me uní al\n[CS:N]Pokégremio[CR] porque te admiro, Gran Bluff."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone...[K] Our wonderful\nGuildmaster's best pupil is...", french="Mes amis...[K] Le meilleur élève de\nnotre vénéré Maître, c'est...", german="Alle mal herhören...[K] Der beste\nSchüler des wunderbaren Gildenmeisters...", italian="Gente...[K] L'apprendista migliore\ndel nostro fantastico Capitano è...", spanish="Escuchadme...[K] El mejor discípulo\nde nuestro maravilloso Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...Me! And don't you\nforget it! ♪", french="... moi! N'allez pas\noublier ça! ♪", german="...Das bin ich! Nur damit ihr\ndas nicht vergesst! ♪", italian="... il sottoscritto! E cercate\ndi non dimenticarvelo! ♪", spanish=" ¡Soy yo! ¡Que no se os olvide! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]All right, I'm going.", french=" ...[K] Très bien, j'y vais.", german=" ...[K]Ich gehe jetzt.", italian=" ...[K] Ok, vado anch'io.", spanish="Bueno...[K] Vosotros id saliendo, que\nyo tengo que mirar una cosilla por ahí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Hey!", french=" Hé!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="EVERYONE! Stop the\nGUILDMASTER!", french=" Les GARS! Arrêtez le MAITRE!", german="ALLE! Den GILDENMEISTER\naufhalten!", italian=" GENTE! Fermiamo il CAPITANO!", spanish=" ¡Eh, detened al Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-64), false, 2) end -- waypoint MovePositionOffset
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-32), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(4)
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(24), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(32), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(56), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(26), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(0), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-8), p.Y+(-8), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-16), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-24), p.Y+(-24), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(-32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(-32), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(16), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(32), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(10)
  -- se_FadeOut(6916, 5) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(5)
  -- GAP: se_Play(9223) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster! You can't do that!", french="Maître! Vous ne pouvez pas\nfaire ça!", german=" Gildenmeister! Das geht nicht!", italian=" Capitano! Non può farlo!", spanish=" ¡No lo hagas, Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! The Guildmaster\nhas started to struggle!", french="Ben mince alors! Le Maître veut\nvraiment y aller!", german="Auweia! Der Gildenmeister\nwehrt sich!", italian="Shock! Come facciamo\na fermare il Capitano?!", spanish="¡Pero qué fuerte! ¡El Gran Bluff\nse está resistiendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WOOOOAAAAHHH! He's so\nSTRONG! OW OW OW OW...", french="WOOOOUUUAAAAHHH!\nIl est trop FORT! OUILLE OUILLE OUILLE...", german="WOOOOAAAAH! Er ist so\nSTARK! AU AU AU AU...", italian="UOOOAAAAAAH! È così FORTE!\nAHI AHI AHI...", spanish="¡Buuuuf! ¡Qué fuerza tiene!\nAy, ay, ay, ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Everyone, we have to stop him,\nno matter what!", french="Allons, les amis, il faut l'arrêter\ncoûte que coûte!", german="Wir müssen ihn aufhalten, alle\nmiteinander, was auch passiert!", italian="Gente, dobbiamo fermarlo\na tutti i costi!", spanish="¡Tenemos que detenerlo cueste\nlo que cueste!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Anyway, the Guildmaster...[K]\nHe's so cool and mischievous...[K] Yay!", french="Ah, le Maître...[K]\nToujours sympa et tout et tout...[K] Tu parles!", german="Aber der Gildenmeister...[K]\nEr ist so cool... So abgeklärt...[K] Spitze...", italian="Ah, il nostro Capitano...[K]\nSembra tanto calmo, ma poi...[K] Uff!", spanish="En fin, que el Gran Bluff...[K]\nmola mucho y es muy travieso...[K] ¡Yupi!"})
  -- message_Close
  GAME:WaitFrames(60)
  -- se_FadeOut(9223, 180) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(150)
  -- main_EnterDungeon(126, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
