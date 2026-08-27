-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a2703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_PUKURIN
    local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 256, 336, Direction.Up, "NPC_PUKURIN")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(npc_npc_pukurin, 252, 196, false, 2)
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
    SkySceneKit.lock(6) -- Lock(6) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(7) -- Lock(7) NDS
    GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
    SkySceneKit.lock(8) -- Lock(8) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    SkySceneKit.lock(9) -- Lock(9) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
    local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 216, Direction.Right, "NPC_CHAAREMU")
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
    GAME:WaitFrames(10)
    SkySceneKit.lock(10) -- Lock(10) NDS
    GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
    SkySceneKit.lock(11) -- Lock(11) NDS
    GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
    GAME:WaitFrames(50)
    GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
    GAME:WaitFrames(50)
    GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
    SkySceneKit.lock(12) -- Lock(12) NDS
    GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
    GAME:WaitFrames(90)
    -- SetAnimation(5) [anim idle native]
    -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
    GAME:WaitFrames(20)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
    GAME:WaitFrames(20)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
    pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(13) -- Lock(13) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SV.SkyScenarioSide = {main=45, sub=9} -- $SCENARIO_SIDE = scn[45,9] (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 216, Direction.Left, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I wonder if there's...[K]some kind\nof puzzle...", french="On dirait...[K] qu'il faut résoudre\nune sorte d'énigme.", german="Ich frage mich, ob dahinter...[K]\nirgendein Rätsel steckt...", italian="Mi chiedo se non ci sia...[K] un\nqualche tipo di enigma da risolvere...", spanish="Me pregunto si habrá...[K] una\nespecie de acertijo..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We probably have to solve a\npuzzle in order to move on...", french="Sans quoi nous sommes\nbloquées ici...", german="Wir müssen vielleicht ein\nRätsel lösen, um voranzukommen...", italian="Sapete... una specie di prova da\nsuperare per andare avanti...", spanish="Lo más seguro es que tengamos\nque resolver un acertijo para avanzar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, [CS:N]Gardevoir[CR].[K] Got any ideas?", french=" Dis, [CS:N]Gardevoir[CR].[K] T'as une idée?", german="Hey, [CS:N]Guardevoir[CR].[K]\nIrgendwelche Ideen?", italian="Ehi, [CS:N]Gardevoir[CR].[K] Hai in mente\nqualcosa?", spanish="Oye, [CS:N]Gardevoir[CR]...[K] ¿Se te ocurre\nalgo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" No.", french=" Non.", german=" Nein.", italian=" No.", spanish=" Pues no..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Sorry...[K] But I don't have\nthe faintest idea.", french="Désolée...[K] Mais je suis\ncomplètement larguée.", german="Entschuldigt...[K] Aber ich habe\nnicht die geringste Ahnung.", italian="Mi dispiace...[K] ma non ho nessuna\nidea.", spanish="Lo siento...[K] Pero estoy\ntotalmente en blanco."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Right here, there's two\nentrances, but other than that...[K]\nthere's nothing...", french="Il n'y a que ces deux entrées...[K]\nAucun autre chemin ne s'ouvre à nous...", german="Hier gibt es zwei Eingänge, und\nansonsten...[K] gibt es nichts...", italian="Davanti a noi ci sono due\nentrate, ma a parte questo...[K] nient'altro...", spanish="Aquí hay dos entradas, pero\naparte de eso...[K] no hay nada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] If [CS:N]Gardevoir[CR] doesn't\nknow, then there's not much chance that we'd\nfigure it out.", french="Hum...[K] Si même [CS:N]Gardevoir[CR]\ndonne sa langue au chat, on n'a aucune chance\nd'y arriver.", german="Hmm...[K] Wenn [CS:N]Guardevoir[CR] keine\nIdee hat, haben wir wohl keine große Chance,\ndie Lösung zu finden.", italian="Uhm...[K] Se nemmeno [CS:N]Gardevoir[CR]\nsa che pesci pigliare, allora non abbiamo\nmolte speranze di risolvere questo mistero.", spanish="Hum...[K] Pues si a [CS:N]Gardevoir[CR] no\nse le ocurre nada, vamos listas."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wait a sec![K] I don't want to be\nput on the same level as you, [CS:N]Medicham[CR].", french="Une seconde![K] Il y a un\nmessage caché, [CS:N]Charmina[CR]?", german="Augenblick![K] Ich möchte nicht auf\neine Stufe mit dir gestellt werden, [CS:N]Meditalis[CR].", italian="Un attimo, [CS:N]Medicham[CR]![K] Non vorrai\nfarmi credere che io sono al vostro stesso\nlivello, vero?!", spanish="¡Eh, oye![K] ¿Qué estás insinuando,\n[CS:N]Medicham[CR]?"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Eh?[K] What do you mean by that?", french="Hein?[K] Mais qu'est-ce que tu\nvas t'imaginer!", german=" Hä?[K] Was meinst du damit?", italian=" Eh?[K] Cosa intendi dire?", spanish=" ¿Eh?[K] ¿Yo? Nada, nada..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Just ask yourself--have you\nfigured anything out, [CS:Y]Lopunny[CR]?", french="Corrige-moi si je me trompe,\nmais, aux dernières nouvelles, tu n'as rien\ncompris du tout, toi non plus, [CS:Y]Lockpin[CR].", german="Dann verrate uns doch, hast du\nvielleicht etwas herausgefunden, [CS:Y]Schlapor[CR]?", italian="Dimmi un po'... Per caso hai idea\ndi come toglierci da questo pasticcio, [CS:Y]Lopunny[CR]?", spanish="Solo te pregunto... ¿Se te ocurre\nalgo, [CS:Y]Lopunny[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Well, no.[K] Actually, I don't have\na clue, either. [M:H8]", french="Euh, c'est vrai.[K] Je sèche\ntotalement. [M:H8]", german="Nun, nein.[K] Um ehrlich zu sein,\nhabe ich auch keinen Schimmer. [M:H8]", italian="Beh, no.[K] In realtà nemmeno io so\nbene cosa fare. [M:H8]", spanish="Pues no...[K] La verdad es que\nno entiendo nada. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GROUND:EntTurn(npc_npc_saanaito, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="That answers that...[K] And that\nwas pretty much what I expected to hear,\nso I'm not mad...", french="Voilà, c'est tout ce que je\nvoulais dire...[K] Désolée que tu l'aies mal pris...", german="Na gut, so viel dazu...[K] Das war\nin etwa das, was ich erwartet habe. Darum bin\nich dir nicht böse...", italian="Lo sapevo...[K] Ed è proprio quello\nche mi aspettavo di sentire, quindi non sono\narrabbiata...", spanish="Pues a eso me refería...[K]\nEra justo lo que esperaba oír, pero\nno lo digo para que te enfades..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We've been together for a while,\nhaven't we...", french="Après tout, ça fait un moment\nqu'on fait équipe, pas vrai?", german="Wir kennen uns schon eine\nWeile...", italian="Questa situazione ci sta\ninnervosendo, lo capisco...", spanish="Hemos compartido ya\nmuchas aventuras..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's just like you,\n[CS:N]Medicham[CR]! ♪[K]\nThank you! [M:H8]", french="Je te reconnais bien là,\n[CS:N]Charmina[CR]! ♪[K]\nMerci! [M:H8]", german="Ach, [CS:N]Meditalis[CR]! ♪[K]\nDanke! [M:H8]", italian="Hai proprio ragione,\n[CS:N]Medicham[CR]! ♪[K] Grazie! [M:H8]", spanish="¡¿Cómo me voy a enfadar,\n[CS:N]Medicham[CR]?! ♪[K] ¡Tienes razón! [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" You're welcome.", french=" Pas de quoi.", german=" Ist schon gut.", italian=" Di niente.", spanish=" Ya lo sabía."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="However...[K] Hmm... Honestly,\nwhat should we do...", french="Cela dit...[K] On n'est pas plus\navancées...", german="Aber...[K] Hmm... Ehrlich,\nwas sollen wir nur tun?", italian="Comunque...[K] Mmmh...\nCosa facciamo...?", spanish="Pero...[K] Hum... En fin,\nalgo tendremos que hacer..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- supervision_Acting(1) [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Heeey! Wait!", french=" Héééé! Attends!", german=" Heeey! Warte auf mich!", italian=" Ehiii! Torna qui!", spanish=" ¡Eeeh! ¡Un momento!"})
  -- message_Close
  -- GAP: se_Play(10251) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(20) [anim idle native]
  -- SlidePositionMark OBJECT_P03P02A1_128 [cible sans placement SSA zone: glissement non joué]
  GAME:WaitFrames(55)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(28), p.Y+(-4), false, 2) end
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P02A1_128) [routine d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Wh...[K] What?!", french=" Qu...[K] qu'est-ce que c'est?!", german=" W-[K]was?!?", italian=" C-[K]Cosa?!", spanish=" ¡¿Pero...[K] qué está...?!"})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitLockLives
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yay, I caught you! ♪[K] My\nPerfect Apple! ♪", french="Youpla, je t'ai eue! ♪[K]\nMa précieuse Pomme Parfaite! ♪", german="Habe ich dich! ♪[K]\nMein Perfekter Apfel! ♪", italian="Evviva, ti ho presa! ♪[K] La mia\nMela Perfetta! ♪", spanish="¡Yupi, ya eres mía! ♪[K]\n¡Mi adorada Manzana Perfecta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-you're...", french=" C'est toi...", german=" D-du bist es...", italian=" T-Tu sei...", spanish=" Pe... pero si es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]?", french=" [CS:N]Grodoudou[CR]?", german=" [CS:N]Knuddeluff[CR]?", italian=" [CS:N]Wigglytuff[CR]?", spanish=" ¡¿[CS:N]Wigglytuff[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh! It's Team [CS:X]Charm[CR]. ♪", french=" Oh! L'Equipe [CS:X]Charme[CR]. ♪", german=" Oh! Team [CS:X]Charme[CR]. ♪", italian=" Oh! Il Team [CS:X]Malia[CR]. ♪", spanish=" Anda, el [CS:X]Equipo Carisma[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay! Friendly friends!", french=" Youpla! Amies de moi!", german=" Juchhu! Liebe Freunde!", italian=" Urrà! Amicissime!", spanish="¡Chachi! ¡Los amigos\nson lo mejor! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Wh-why...", french=" Que...", german=" W-wie...", italian=" C-Come mai...", spanish=" ¿Có... cómo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Why is [CS:N]Wigglytuff[CR] here?", french=" Que fais-tu ici, [CS:N]Grodoudou[CR]?", german=" Wie kommt [CS:N]Knuddeluff[CR] hierher?", italian=" Come mai [CS:N]Wigglytuff[CR] è qui?", spanish=" ¿Qué hace aquí [CS:N]Wigglytuff[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Oh![K] Let me guess!", french=" Oh![K] Laisse-moi deviner!", german=" Oh![K] Lass mich raten!", italian=" Oh![K] Lasciami indovinare!", spanish=" ¡Claro![K] ¡Ya lo sé, ya lo sé!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You've come in search of the\ntreasure as well?!", french="Tu cherches le trésor,\ntoi aussi?!", german="Du hast dich auch auf die Suche\nnach dem Schatz gemacht?!?", italian="Anche tu sei venuto a cercare\nil tesoro, vero?!", spanish="Tú también vienes a por el\ntesoro, ¡¿he acertado?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?[K] Treasure?", french=" Un trésor?[K] Quel trésor?", german=" Was?[K] Schatz?", italian=" Uh?[K] Il tesoro?", spanish=" ¿Eh?[K] ¿Qué tesoro?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I don't know anything about that.[K]\nTreasure, I mean.", french="Jamais entendu parler.[K]\nDu trésor, je veux dire.", german="Darüber weiß ich nichts.[K]\nÜber einen Schatz, meine ich.", italian="Non ne so nulla.[K] Del tesoro,\nintendo.", spanish="No sé de qué me hablas.[K]\nNo estoy aquí por ningún tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="My Perfect Apple just up and ran\naway from me...", french="Ma Pomme Parfaite s'est\néchappée...", german="Mein Perfekter Apfel hüpfte und\nkullerte mir davon...", italian="La mia Mela Perfetta è caduta\ned è rotolata via...", spanish="Se me cayó la Manzana\nPerfecta..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I was chasing it as it rolled\naway...[K] And somehow I found myself here.", french="... alors je me suis lancé à\nsa poursuite...[K] Et je me suis retrouvé ici.", german="Ich habe ihn verfolgt, wie er so\ndavonkullerte...[K] Und bin irgendwie hier\ngelandet.", italian="Ho cominciato a correrle\ndietro...[K] e alla fine mi sono ritrovato qui.", spanish="Yo la he ido persiguiendo\nmientras rodaba...[K] y sin darme cuenta\nhe llegado aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweatdrop", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Oh...[K] I see.", french=" Oh...[K] Je vois.", german=" Oh...[K] Verstehe.", italian=" Oh...[K] capisco.", spanish=" Ah...[K] Pues vaya."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" It's fine, it's fine...", french=" Bien, bien...", german=" Alles klar, alles klar...", italian=" È tutto ok, non c'è problema...", spanish=" Ahora lo entiendo... Creo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So what are all of you\ndoing here?", french="Et vous, qu'est-ce que vous\nfaites ici?", german=" Und was macht ihr hier so?", italian=" Allora? Cosa ci fate tutte qui?", spanish=" ¿Y qué hacéis vosotras aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We can't seem to go\nany farther.", french=" On est coincées.", german="Wir kommen anscheinend gerade\nnicht mehr voran.", italian=" Non riusciamo ad andare avanti.", spanish=" No conseguimos avanzar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You see the two entrances\nover there?", french=" Tu vois ces deux entrées?", german="Siehst du die beiden\nEingänge dort?", italian=" Vedi quelle due entrate laggiù?", spanish=" ¿Ves esas dos entradas?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It doesn't matter which entrance\nwe enter...", french="Quelle que soit celle que\nnous prenons...", german=" Welchen wir auch nehmen...", italian=" Non importa quale scegliamo...", spanish=" Da igual por cuál vayamos..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="No matter what, we end up\nright back here.", french="... nous nous retrouvons toujours\nici.", german="Wir kommen auf jeden Fall\nwieder hier an.", italian="... alla fine ci ritroviamo\nsempre qui.", spanish="Hagamos lo que hagamos,\nsiempre acabamos de vuelta aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We guess there's a puzzle\nto solve...[K] Because we're all really puzzled!", french="On pense qu'il y a une énigme à\nrésoudre...[K] Le moins qu'on puisse dire,\nc'est que cet endroit est énigmatique!", german="Wir vermuten, dass wir ein\nRätsel entwirren müssen...[K] Wir sind nämlich\nschon ganz verwirrt!", italian="Probabilmente dobbiamo\nrisolvere un qualche enigma...[K]\nMa siamo tutte a corto di idee!", spanish="Suponemos que hay que resolver\nun acertijo...[K] ¡Pero no hay forma de acertar!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Can you think of something to\ntry, [CS:N]Wigglytuff[CR]?", french=" Tu as une idée, [CS:N]Grodoudou[CR]?", german="Hast du eine Idee, was wir mal\nausprobieren könnten, [CS:N]Knuddeluff[CR]?", italian="[CS:N]Wigglytuff[CR], a te viene in mente\nuna soluzione?", spanish="¿Se te ocurre algo que podamos\nprobar, [CS:N]Wigglytuff[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(12) -- Unlock(12) NDS
  GAME:WaitFrames(94)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yay! Perfect Apple,\nPerfect Apple! ♪", french="Youpla! Pomme Parfaite,\nPomme Parfaite! ♪", german="Ja! Perfekte Äpfel,\nPerfekte Äpfel! ♪", italian="Urrà! Mela Perfetta,\nMela Perfetta! ♪", spanish="¡Yupi! ¡Mi Manzana Perfecta,\nmi Manzana Perfecta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Aww...", french=" Oooh...", german=" Oooh...", italian=" Uff...", spanish=" Esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Weren't you paying attention\nto our explanation?", french="Tu n'as rien écouté de ce\nqu'on t'a expliqué?", german="Hast du uns etwa nicht\nzugehört?", italian="Hai ascoltato quello che\nti abbiamo detto?", spanish="¿Por casualidad nos estabas\nescuchando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="If you've got a plan, we'd love to\nhear it...", french="Si tu as un plan, on adorerait\nque tu nous le fasses partager...", german="Wenn du eine Idee hast, teil sie\nuns doch bitte mit...", italian="Se hai un'idea per risolvere\nquesto mistero, ci piacerebbe sentirla...", spanish="Si se te ocurre algo,\nlo escucharemos con mucho gusto..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="If you could lend us your\nwisdom, we might be able to figure this out...", french="Si tu pouvais éclairer notre\nlanterne, on aurait une chance de sortir d'ici...", german="Wenn du deine Weisheit mit uns\nteilen würdest, wären wir vielleicht in der\nLage, dieses Rätsel zu lösen...", italian="Se ci metti a disposizione\nla tua saggezza, forse potremmo trovare\nuna soluzione...", spanish="Tal vez con tu sabiduría\npodamos resolver este embrollo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I think we're going to have to\nlook for help from somewhere else... ♪", french="Il va falloir s'adresser à\nquelqu'un d'autre, je le crains... ♪", german="Na, vielleicht sollten wir auch\neinfach nur jemand anderes um Hilfe\nbitten... ♪", italian="Credo che dovremmo cercare\naiuto da qualche altra parte... ♪", spanish="Yo diría que mejor buscamos\nayuda en otro sitio... ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" You said it!", french=" Bien vu!", german=" Du sagst es!", italian=" Hai proprio ragione!", spanish=" ¡Ya te digo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" It was a mistake to ask him!", french="Je ne vois pas en quoi il\npourrait nous aider!", german="Es war ein Fehler, ihn zu\nfragen!", italian=" È stato un errore chiederglielo!", spanish="¡No teníamos ni que haberle\npreguntado!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="He's not listening to a\nword we say!", french=" Il n'écoute rien de ce qu'on dit!", german=" Er hört uns einfach nicht zu!", italian="Non ha ascoltato una parola\ndi quello che abbiamo detto!", spanish="¡Miradlo, si ni siquiera\nnos escucha!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Nope.[K] I'm listening carefully.", french="Ce n'est pas vrai.[K] Je suis\ntout ouïe.", german="Quatsch.[K]\nIch habe ganz genau zugehört.", italian="Non è vero.[K] Ho ascoltato molto\nattentamente.", spanish="Al contrario.[K] Os escucho\ncon mucha atención."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Wie bitte?", italian=" Eh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You helped me. ♪[K] So it would\nbe terribly rude for me not to pay attention.", french="Vous m'avez sauvé. ♪[K] Alors ce\nserait franchement malpoli de ma part de ne\npas vous écouter.", german="Ihr habt mir doch geholfen. ♪[K]\nDa wäre es doch schrecklich unhöflich von\nmir, nicht aufzupassen.", italian="Voi mi avete aiutato. ♪[K]\nE sarebbe terribilmente scortese da parte mia\nse non prestassi ascolto alle vostre parole.", spanish="Vosotras me ayudasteis. ♪[K]\nSería de muy mala educación no escucharos."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Thinking about it...[K] It's a pretty\ncool problem, isn't it?", french="Et franchement...[K] C'est une\nénigme du tonnerre, pas vrai?", german="Wenn man darüber nachdenkt...[K]\nIst es doch eigentlich ein herausforderndes\nRätsel, nicht wahr?", italian="Pensandoci su...[K] è un problema\nbello tosto, eh?", spanish="Si lo pensáis bien...[K] Qué gracia\nde problema, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="There's only two\nentrances here...", french=" Il n'y a que deux entrées ici...", german=" Es gibt hier nur zwei Eingänge...", italian=" Qui ci sono solo due entrate...", spanish=" Aquí solo hay dos entradas..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If you enter either one,\nswoosh--start again, start again!", french="Et l'une comme l'autre vous\nrenvoient à la case départ!\nCase départ, case départ!", german="Egal, welchen man auch nimmt,\nswuuusch! Noch mal machen! Noch mal machen!", italian="E che si scelga l'una o l'altra,\nbum... si ricomincia daccapo!", spanish="Pero elijas la que elijas, ¡zas!\n¡Hay que volver a empezar!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I give up too. ♪[K] I don't know.", french="Bon, j'abandonne. ♪[K]\nLa solution m'échappe.", german="Ich gebe auch auf. ♪[K]\nIch weiß es nicht.", italian="Ci rinuncio anch'io. ♪[K] Non ne\nho idea.", spanish="Yo también me rindo. ♪[K]\nNo tengo ni idea."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]However...", french=" ...[K] Cependant...", german=" ...[K]Allerdings...", italian=" ...[K] Però...", spanish=" Hum...[K] Sin embargo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" However?", french=" Cependant quoi?", german=" Allerdings?", italian=" Però?", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I guess, I wonder...[K]if the paths\nyou can see are the only ones. ♪", french="Je me demande...[K] s'il n'y a pas\nd'autre chemin, à part ces deux-là. ♪", german="Nun, ich frage mich,[K] ob die\nsichtbaren Durchgänge die einzigen sind. ♪", italian="Chissà, mi chiedo...[K] se le uniche\nstrade percorribili siano solo quelle che\nsi vedono. ♪", spanish="Pues me pregunto...[K] si los\ncaminos que se ven son los únicos que hay. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" The visible paths...", french=" Ces deux chemins...", german=" Die sichtbaren Durchgänge...", italian=" Se le strade che si vedono...", spanish=" Los caminos visibles..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Aren't the only ones...?", french=" ... ne seraient pas les seuls...?", german="Sie sollen nicht die einzigen\nsein?", italian=" ... siano le uniche percorribili...?", spanish=" ¿Pero no son los únicos...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Whoops![K] M-my Perfect Apple!", french=" Oups![K] Ma Pomme Parfaite!", german=" Oha![K] M-mein Perfekter Apfel!", italian=" Opsss![K] L-La mia Mela Perfetta!", spanish="¡Ahí va![K] Mi... ¡Mi Manzana\nPerfecta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(10252) — id SE NDS sans portage PMDO identifié
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- MovePositionMark OBJECT_P03P02A1_128 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P02A1_128) [routine d'objet NDS non simulée - documenté]
  -- GAP: se_Play(10253) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D56P11A3_536) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" P-Perfect Apple!", french=" Reviens, Pomme Parfaite!", german=" P-perfekter Apfel!", italian=" M-Mela Perfetta!", spanish=" ¡Mi... Manzana Perfecta!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_pukurin, 252, 168, false, 2)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Perfect Apple! Perfect Apple!!", french="Pomme Parfaite! Pomme\nParfaite!!", german="Perfekter Apfel!\nPerfekter Apfel!!!", italian=" Mela Perfetta! Mela Perfetta!!!", spanish="¡Oh, la Manzana Perfecta!\n¡¡Mi querida Manzana Perfecta!!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_pukurin, 252, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10253) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D56P11A3_537) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Where'd it go?", french=" Où est-elle passée?", german=" Wo ist er hin?", italian=" Dov'è finito?", spanish=" ¿Adónde ha ido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR] just walked through\nthe wall!", french="[CS:N]Grodoudou[CR] vient de disparaître\ndans la paroi!", german="[CS:N]Knuddeluff[CR] ist einfach durch die\nWand gelaufen!", italian="[CS:N]Wigglytuff[CR] ha attraversato\nla parete!", spanish="¡[CS:N]Wigglytuff[CR] acaba de atravesar\nla pared!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="What in the world![K] [CS:N]Wigglytuff[CR]\ndisappeared!", french="Bon sang de bonsoir![K] [CS:N]Grodoudou[CR]\na disparu!", german="Was zum Kuckuck![K] [CS:N]Knuddeluff[CR]\nist verschwunden!", italian="Ma cosa succede?![K] [CS:N]Wigglytuff[CR]\nè scomparso!", spanish="¡No es posible![K] ¡[CS:N]Wigglytuff[CR]\nha desaparecido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" But--[K]if that's the case...", french=" Mais...[K] dans ce cas...", german=" Aber...[K] wenn das so ist...", italian=" Ma...[K] se è così...", spanish=" Pero...[K] en ese caso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You know it![K] If that's the case,\nthen that wall...", french="Mais bien sûr![K] Dans ce cas, cela\nsignifie que ce mur...", german="Natürlich![K] Wenn das so ist,\nist diese Wand...", italian="Esatto![K] Se è così, allora quella\nparete...", spanish=" ¡Exacto![K] En ese caso, la pared..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="That wall might be an invisible...[K]\nhidden doorway!", french="... dissimule...[K] un passage\nsecret!", german="Diese Wand ist anscheinend...[K]\nein getarnter Durchgang!", italian="Quella parete potrebbe essere...[K]\nun passaggio segreto invisibile!", spanish="La pared debe de ser...[K]\n¡una entrada oculta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="What?! Could that be true?![K]\nIf that's true...", french="Ah oui, tu crois?![K]\nSi c'est vrai...", german="Was?!? Könnte das sein?!?[K]\nWenn das stimmt...", italian=" Come?! Davvero?![K] Ma allora...", spanish="¡¿Qué?! ¡¿Será eso cierto?![K]\nSi lo fuera..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:N]Gardevoir[CR]! [CS:Y]Lopunny[CR]![K]\nLet's find out for ourselves!", french="[CS:N]Gardevoir[CR]! [CS:Y]Lockpin[CR]![K]\nVérifions par nous-mêmes!", german="[CS:N]Guardevoir[CR]! [CS:Y]Schlapor[CR]![K]\nLasst es uns herausfinden!", italian="[CS:N]Gardevoir[CR]! [CS:Y]Lopunny[CR]![K]\nScopriamolo!", spanish="¡[CS:N]Gardevoir[CR], [CS:Y]Lopunny[CR]![K]\n¡Será mejor que lo averigüemos!"})
  -- message_Close
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
