-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P20P01A/n03a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_PUPURIN
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 184, 212, false, 2)
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
    pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GROUND:MoveToPosition(hero, 184, 148, false, 2)
    GROUND:EntTurn(hero, Direction.UpRight)
    -- SetAnimation(4) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(9) -- Lock(9) NDS
    pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 184, 188, false, 2)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(4) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    GAME:WaitFrames(math.random(30, 60))
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(math.random(5, 15))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(20), p.Y+(20), false, 2) end
    SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-20), false, 2) end
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(4) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    GAME:WaitFrames(math.random(30, 60))
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(math.random(5, 15))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-20), p.Y+(20), false, 2) end
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
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
    end
    end
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    GAME:WaitFrames(6)
    -- SetAnimation(2) [anim idle native]
    local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 224, 328, Direction.Up, "NPC_AAMARUDO")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
    SkySceneKit.lock(11) -- Lock(11) NDS
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
    SkySceneKit.lock(12) -- Lock(12) NDS
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 184, 188, false, 2)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(4) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    GAME:WaitFrames(math.random(30, 60))
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(math.random(5, 15))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(20), p.Y+(20), false, 2) end
    SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-20), false, 2) end
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    -- SetAnimation(4) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    GAME:WaitFrames(math.random(30, 60))
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(math.random(5, 15))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-20), p.Y+(20), false, 2) end
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
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
    end
    end
    end
    end
    -- @label_2 [étiquette de flux ExplorerScript]
    GAME:WaitFrames(6)
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(13) -- Lock(13) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P20P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh! [K]There's a treasure chest\nover there!", french=" Oh! [K]Il y a un coffre là-bas!", german="Oh! [K]Da drüben ist eine\nSchatztruhe!", italian=" Oh![K] C'è un forziere laggiù!", spanish=" ¡Anda![K] ¡Si aquí hay un cofre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(204, 168, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 156, false, 2)
  GAME:WaitFrames(10)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey, open it and see! ♪[K]\nHurry, hurry! ♪", french="Ouvrez-le et regardez! ♪[K]\nVite, allez, vite! ♪", german="Komm schon, ich bin gespannt!\nMach sie auf! ♪[K] Schnell, schnell! ♪", italian="Ehi, aprilo e vediamo cosa\nc'è dentro! ♪[K] Presto, presto! ♪", spanish="¡Va, ábrelo a ver qué hay! ♪[K]\n¡Corre, corre! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:N]Armaldo[CR]\n[CN]opens the treasure chest.", french="[CN][CS:N]Armaldo[CR]\n[CN]ouvre le coffre.", german="[CN][CS:N]Armaldo[CR]\n[CN]öffnet die Schatztruhe.", italian="[CN][CS:N]Armaldo[CR]\n[CN]apre il forziere.", spanish="[CN][CS:N]Armaldo[CR]\n[CN]abre el cofre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9731) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P20P01A2_374) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][CS:Z]Defend Globe[CR].", french="[CN]A l'intérieur se trouve la\n[CN][CS:Z]Défensphère[CR].", german="[CN]Darin ist ein\n[CN][CS:Z]Abwehrglobus[CR].", italian="[CN]Al suo interno c'è\n[CN]un [CS:Z]Globodifesa[CR].", spanish="[CN]Dentro había un\n[CN][CS:Z]Globodefensa[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Th-this...[K]is...!", french=" C'est...[K] c'est...!", german=" D-das...[K] ist...", italian=" Q-Questo...[K] è...!", spanish=" Es... esto...[K] Esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wow! ♪[K] So cool! ♪", french=" Ouah! ♪[K] C'est joli! ♪", german=" Wow! ♪[K] Wie cool! ♪", italian=" Wow! ♪[K] Fortissimo! ♪", spanish=" ¡Guau! ♪[K] ¡Mola mucho! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What is this?", french=" C'est quoi?", german=" Was ist das?", italian=" Che cos'è?", spanish=" ¿Qué es?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" This is a [CS:Z]Defend Globe[CR].", french=" Il s'agit d'une [CS:Z]Défensphère[CR].", german=" Dies ist ein [CS:Z]Abwehrglobus[CR].", italian=" Questo è un [CS:Z]Globodifesa[CR].", spanish=" Es un [CS:Z]Globodefensa[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A [CS:Z]Defend Globe[CR]? (Yay! Yay! ♪)", french="Une [CS:Z]Défensphère[CR]?\n(Youpla! Yahou! ♪)", german="Ein [CS:Z]Abwehrglobus[CR]?\n(Juchhu! Juchhu! ♪)", italian="Un [CS:Z]Globodifesa[CR]?\n(Urrà! Urrà! ♪)", spanish=" ¿Un [CS:Z]Globodefensa[CR]? (¡Bieeen! ♪)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(204, 192, 60, false) end) -- performer/caméra
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Sí..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's very valuable...[K] It's a very\nhard to find item...", french="C'est un objet très précieux...[K]\nIl est très difficile de mettre\nla main dessus...", german="Er ist sehr wertvoll...[K] Ein Item,\ndas man nur selten findet.", italian="È molto prezioso...[K] Si tratta\ndi uno strumento davvero difficile\nda trovare...", spanish="Es muy valioso...[K] Es un objeto\nmuy difícil de encontrar..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's an Exclusive Item for\nBug-type Pokémon.", french="C'est un Objet Exclusif destiné\naux Pokémon de type Insecte.", german="Es ist ein Exklusives Item für\nKäfer-Pokémon.", italian="È uno Strumento Esclusivo\nper i Pokémon di tipo Coleottero.", spanish="Es un objeto exclusivo de los\nPokémon de tipo Bicho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...Hey!", french=" ... Hé!", german=" ...Hey!", italian=" ... Ehi!", spanish=" ¡Oye!..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Aren't you listening to what\nI'm saying?!", french="Tu écoutes ce que je\nte raconte?!", german="Hast du bei dem, was ich\ngerade gesagt habe, gar nicht zugehört?!?", italian=" Mi stai ascoltando o no?!", spanish=" ¡No me estás haciendo ni caso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's all right. ♪ I heard you. ♪", french=" Voui, voui. ♪ J'écoute. ♪", german="Doch, doch. ♪\nNatürlich habe ich das. ♪", italian=" Ma sì. ♪ Ti ho sentito. ♪", spanish=" Sí, sí. ♪ Te he oído. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't really understand...[K]\nBut it's really cool! ♪", french="Je ne suis pas sûr de\ncomprendre...[K] mais c'est vraiment chouette! ♪", german="Ich verstehe zwar nicht alles...[K]\nAber es ist wirklich cool! ♪", italian="Non ci capisco molto...[K]\nMa è troppo bello! ♪", spanish="No entiendo muy bien qué es...[K]\n¡Pero mola un montón! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We did it! ♪[K] Ah ha ha ha! ♪", french=" On a réussi! ♪[K] Ah ha ha ha! ♪", german="Wir haben es geschafft! ♪[K]\nHahahaha! ♪", italian="Ce l'abbiamo fatta! ♪[K]\nAh ah ah! ♪", spanish="¡Lo hemos conseguido! ♪[K]\n¡Ja, ja, ja, ja! ♪"})
  -- message_KeyWait
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ah ha ha ha ha ha ha ha ha ha ha\nha ha ha ha ha ha ha ha ha ha ha ha ha ha ha\nha ha ha ha ha ha ha ha ha ha ha ha ha ha! ♪", french="Ah ha ha ha ha ha ha ha ha ha ha\nha ha ha ha ha ha ha ha ha ha ha ha ha ha ha\nha ha ha ha ha ha ha ha ha ha ha ha ha ha! ♪", german="Ahahahahahahahahahahahahahaha\nahahahahahahahahahahahahahahahahahahahahaha\nahahahahahahahahahahahahahahahahahahaha! ♪", italian="Ah ah ah ah ah ah ah ah ah ah ah\nah ah ah ah ah ah ah ah ah ah ah ah ah ah ah\nah ah ah ah ah ah ah ah ah ah ah ah ah ah! ♪", spanish="¡Ja, ja, ja, ja, ja, ja, ja, ja, ja,\nja, ja, ja, ja, ja, ja, ja, ja, ja, ja, ja, ja,\nja, ja, ja, ja, ja, ja, ja, ja, ja, ja, ja, ja! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  GAME:WaitFrames(1)
  SkySceneKit.unlock(12) -- Unlock(12) NDS
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="... (Wh-what is this...?[K]\nHe's so happy...)", french="... (Qu'est-ce... que...?[K]\nIl est heureux comme tout...)", german="...(W-was denn nun...[K]\nEr ist so fröhlich...)", italian="... (M-Ma che succede...?[K]\nÈ così felice...)", spanish="¿Eh?... (¿Qué le pasa...?[K]\nEstá pletórico...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(He doesn't even know the\nvalue of this item, but he's just so\nridiculously happy...)", french="(Il ne connaît même pas la\nvaleur de cet objet, et pourtant\nil saute de joie...)", german="(Er kennt nicht einmal den Wert\ndieses Items und trotzdem ist er einfach so\nunglaublich fröhlich...)", italian="(Non conosce nemmeno il valore\ndi questo strumento, eppure non sta nella pelle\ndalla felicità...)", spanish="(No tiene ni idea de lo que\nrepresenta el objeto, pero está contento\nhasta rayar el absurdo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We did it, we did it! ♪[K]\nYay, yay! ♪", french="On a réussi, on a réussi! ♪[K]\nYoupla, youhou! ♪", german="Wir haben es geschafft, wir\nhaben es geschafft! ♪[K] Juchhu, juchhu! ♪", italian="Ce l'abbiamo fatta, ce l'abbiamo\nfatta! ♪[K] Evviva, urrà! ♪", spanish="¡Lo hemos conseguido, sí! ♪[K]\n¡Yupi, yupiii! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="... (Hmm...[K] He showed a\npowerful intuition in getting that\ndoor open earlier...)", french="... (Mmh...[K] Il a fait preuve d'une\nintuition hors du commun en ouvrant cette\nporte tout à l'heure...)", german="...(Hmm...[K] Vorhin beim Öffnen\nder Tür hat er eine bemerkenswerte Intuition\nan den Tag gelegt...)", italian="... (Uhm...[K] Ha dimostrato\ndi avere grande intuito quando prima\nha aperto la porta in quel modo...)", spanish="Hum... (Lo cierto...[K] es que ha\nmostrado una gran intuición al conseguir abrir\nesa puerta...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" (This kid is...)", french=" (Ce gamin est...)", german=" (Dieses Kind ist...)", italian=" (Questo bambino è...)", spanish=" (Este crío es...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay, yay! ♪[K] Ah ha ha ha ha! ♪", french="Youpla, youhou! ♪[K]\nAh ha ha ha ha! ♪", german=" Juchhu, juchhu! ♪[K] Ahahaha! ♪", italian=" Urrà, evviva! ♪[K] Ah ah ah! ♪", spanish=" ¡Yupi, yupi! ♪[K] ¡Ja, ja, ja, ja! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="...[K] (This kid...[K] I don't really\nget his personality...)", french="...[K] (Ce gamin...[K] Il est difficile\nà cerner...)", german="...[K](Dieses Kind...[K] Ich werde aus\nseinem Charakter nicht wirklich schlau.)", italian="...[K] (Questo bambino...[K] non\nriesco proprio a capirlo...)", spanish="Hum...[K] (Este chaval...[K] No entiendo\nmuy bien sus reacciones...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(He radiates an unknown,\nunfathomable quality...)", french="(Un talent insoupçonné,\ninsaisissable réside en lui...)", german="(Eine unbekannte, nicht fassbare\nEigenschaft geht von ihm aus.)", italian="(Emana un potere sconosciuto\ne incomprensibile...)", spanish="(Irradia una cualidad desconocida\ne inconmensurable...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(I'm guessing...[K]this kid has\nan amazing natural talent or something...)", french="(Je pense que...[K] ce gamin a un\ndon inné...)", german="(Sieht so aus, als ob diesem\nBengel ein unglaubliches Naturtalent oder\netwas Vergleichbares innewohnt.)", italian="(Credo...[K] che abbia un talento\nnaturale mai visto o qualcosa del genere...)", spanish="(Me da la impresión...[K] de que\neste crío tiene un talento innato...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(For explorers...[K]this is an\nunbelievable advantage...)", french="(Pour un explorateur...[K] c'est un\natout indéniable...)", german="(Für Erkunder[K] stellt so etwas\neinen unbeschreiblichen Vorteil dar.)", italian="(Per un esploratore...[K] si tratta\ndi un vantaggio fondamentale...)", spanish="(Para los exploradores...[K] algo\nasí representa una ventaja increíble...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey, exploring is so\nmuch fun! ♪", french="Hé, les explorations,\nc'est super chouette! ♪", german="Hey, Erkunden macht enorm\nviel Spaß! ♪", italian="Ehi, l'esplorazione è davvero\nuno spasso! ♪", spanish=" ¡Oye, explorar es divertidísimo! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I had no idea! ♪", french=" Je ne m'attendais pas à ça! ♪", german=" Das hätte ich nicht gedacht! ♪", italian=" Non lo sapevo! ♪", spanish=" ¡No tenía ni idea! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] Oh yeah!", french=" ...![K] Ouaip!", german=" ...[K]Oh, genau!", italian=" ...![K] Oh sì!", spanish=" ¡Yupi!...[K] ¡Bieeen!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 204, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master!", french=" Maître!", german=" Meister!", italian=" Maestro!", spanish=" ¡Eres el mejor maestro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ?[K] M-master?[K] Me?!", french=" ?[K] M-maître?[K] Moi?!", german=" M-[K]meister?[K] Ich?!?", italian=" ?[K] M-Maestro?[K] Io?!", spanish=" ¿Eh?[K] ¿Ma... maestro?[K] ¡¿Yo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep, that's right.[K] The\nexploration master.", french="Voui, tout juste.[K] Le maître\ndes explorations.", german="Ja, genau.[K]\nDer Erkundungsmeister.", italian="Esatto.[K] Il maestro\ndell'esplorazione.", spanish="Sí, sí, eso es.[K] El maestro\nexplorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Master, I have a request![K]\nPlease...[K] Please take me on as your apprentice!", french="Maître, j'ai une faveur à vous\ndemander![K] S'il vous plaît...[K] Prenez-moi comme\napprenti, s'il vous plaît!", german="Meister, ich habe eine Bitte![K]\nBitte...[K] Bitte lass mich dein Lehrling sein!", italian="Maestro, ho una richiesta![K]\nPer favore...[K] Fammi diventare il tuo\napprendista!", spanish="Maestro, quiero pedirte algo.[K]\nPorfi...[K] ¡Acéptame como aprendiz tuyo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" M-my...[K]apprentice?!", french=" C-comme...[K] apprenti?!", german=" M-mein...[K] Lehrling?!?", italian=" Il m-mio...[K] apprendista?!", spanish=" ¡¿Como...[K] mi aprendiz?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="N-no! I'll pass.[K] I don't really see\nmyself taking care of someone else\nas an apprentice.", french="N-non! Très peu pour moi.[K] Je ne\nme vois vraiment pas en train de m'occuper\nd'un apprenti.", german="N-nein, ich passe![K] Ich kann mich\nnicht um einen Lehrling kümmern.", italian="N-Non ci penso nemmeno![K] Non so\nassolutamente nulla su come ci si prende cura\ndi un apprendista.", spanish="¡No, no! No puedo.[K] No me acabo\nde ver teniendo a mi cargo a alguien\ncomo aprendiz."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" And besides, I quit exploring!", french="Et en plus, j'ai laissé tomber\nles explorations depuis belle lurette!", german="Und noch dazu habe ich mit dem\nErkunden aufgehört!", italian="E poi io ho abbandonato\nle esplorazioni!", spanish=" Y, además, yo dejé de explorar."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's too late for me to do\nanything like that!", french="C'est trop tard, je ne peux plus\nm'occuper de ce genre de choses!", german="Für so etwas ist es bei mir\neinfach zu spät!", italian="Ormai è troppo tardi per me,\nnon posso occuparmi di una cosa simile!", spanish="Ya es tarde para que yo haga\nalgo así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] Today you came out on\nthis exploration, didn't you?", french="Mais...[K] vous êtes bien parti en\nexploration aujourd'hui, pas vrai?", german="Aber[K] heute bist du doch mit\nauf diese Erkundung gekommen, nicht wahr?", italian="Però...[K] Oggi hai partecipato\na questa esplorazione, no?", spanish="Pero...[K] si hoy has venido\nde exploración, ¿es que eso no cuenta?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" You did, didn't you? Master...", french="C'est vrai, hein, pas vrai?\nMaître...", german="Bist du doch, oder nicht?\nMeister...", italian=" È così, no? Vero, maestro?", spanish=" Sí que cuenta, ¿a que sí, maestro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Err...", french=" C'est-à-dire que...", german=" Äh...", italian=" Ehmmm...!", spanish=" Pues..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This is the first time I've had\nso much fun. It's like I've changed somehow.", french="Je m'étais jamais autant amusé.\nC'est un peu comme si quelque chose avait\nchangé en moi.", german="Zum ersten Mal hatte ich so viel\nSpaß. Es fühlte sich an, als hätte ich mich\nirgendwie verändert.", italian="È la prima volta che mi diverto\ncosì tanto. È come se per me fosse cambiato\nqualcosa.", spanish="Nunca me lo había pasado tan\nbien. Me siento diferente y todo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I want to keep exploring! ♪[K]\n...That is...I'd like to keep exploring.", french="Je veux continuer\nà explorer! ♪[K] Enfin... j'aimerais bien...", german="Ich möchte weiter erkunden! ♪[K]\n...Ja, wirklich... Ich möchte von Herzen gerne\nweiter auf Erkundung gehen.", italian="Voglio continuare a\nesplorare! ♪[K] Cioè... vorrei continuare\na esplorare.", spanish="¡Quiero seguir explorando! ♪[K]\nEso es, me gustaría seguir explorando..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Please![K] Take me on as your\napprentice, Master!", french="S'il vous plaît![K] Prenez-moi\ncomme apprenti, Maître!", german="Bitte![K] Lass mich dein Lehrling\nsein, Meister!", italian="Ti prego![K] Fammi diventare\nil tuo apprendista, maestro!", spanish="¡Porfi![K] ¡Acéptame como\naprendiz, maestro!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master! Please!", french=" Maître! S'il vous plaît!", german=" Meister! Bitte!", italian=" Maestro! Per favore!", spanish=" ¡Porfi, maestro, porfi!"})
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Umm... (Wow, he's even kneeling\non the floor. He's sure intent\non this request...)", french="Mmh... (Ouah, il s'est même mis\nà genoux. C'est dire s'il y tient...)", german="Puuuuuh... (Wow, er kniet sogar\nauf dem Boden. Er meint seine Bitte wohl\nwirklich ernst...)", italian="Urgh... (Wow, si è addirittura\nmesso in ginocchio. Lo vuole davvero\ncon tutto se stesso...)", spanish="Hum... (Vaya, si se ha puesto\nde rodillas y todo. Se toma muy en serio\nsu petición.)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(However, he's so round...\nIt's hard to tell if he's really kneeling\non the floor or not...)", french="(D'un autre côté, avec son corps\ntout rond... difficile de voir s'il est\nvraiment agenouillé...)", german="(Na ja, obwohl... So rund, wie\nder ist, kann ich eigentlich nicht sagen, ob er\nnun wirklich kniet oder nicht...)", italian="(Beh, visto com'è rotondo...\nè difficile dire se sia veramente in\nginocchio oppure no...)", spanish="(Pero es tan redondito...\nque cuesta saber si está de rodillas o no...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" (Wh-what should I do?)", french=" (Que... que faire?)", german=" (W-was soll ich nur machen?)", italian=" (C-Che faccio?)", spanish=" (¿Qué debería hacer?)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(It would be extremely risky if\nI were to start exploring as part of a\nteam again...)", french="(Ce serait extrêmement risqué\npour moi de reformer une équipe et de\nrepartir en exploration...)", german="(Es wäre sehr riskant für\nmich, wieder als Teil eines Erkundungsteams\nloszulegen...)", italian="(Sarebbe estremamente\nrischioso se dovessi far parte di nuovo\ndi una squadra d'esplorazione...)", spanish="(Sería muy arriesgado que\nvolviera a explorar como parte de un equipo...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(But this kid has so much\npotential, it's amazing.)", french="(Mais ce gamin a un tel\npotentiel, c'est fou.)", german="(Aber dieser Kleine hat so viel\nPotenzial, es ist unglaublich.)", italian="(Ma questo bambino ha un\nenorme potenziale, mai visto prima d'ora.)", spanish="(Pero este crío tiene tanto\npotencial... Es increíble.)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(I'd love to see just how far\nthis kid could go as an explorer...)", french="(J'aimerais beaucoup voir\njusqu'à quel niveau il peut aller comme\nexplorateur...)", german="(Mich würde interessieren, wie\nweit er als Erkunder kommen könnte...)", italian="(Mi piacerebbe molto vedere fin\ndove può arrivare come esploratore...)", spanish="(Me encantaría saber hasta\ndónde puede llegar como explorador...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(Being together is a little\nannoying...[K] But I have another\nfeeling as well...)", french="(Ça m'ennuie un peu de faire\néquipe avec lui...[K] Mais ce n'est pas tout...)", german="(Zusammen zu erkunden könnte\nauf Dauer etwas anstrengend werden...[K]\nAber eben auch sehr interessant...)", italian="(Certo, a volte è un po'\nfastidioso...[K] però ha anche tante\nqualità...)", spanish="(Es un poco molesto tener que\nir con alguien...[K] Pero también despierta\nen mí otra sensación...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(It's really caught my attention...[K]\nI think I could start exploring again, as long as\nit was with him.)", french="(Ça m'a vraiment frappé...[K]\nJe pense que je pourrais me remettre à\nexplorer, du moment que c'est avec lui.)", german="(Es reizt mich wirklich...[K] Ich\ndenke, ich könnte noch einmal mit dem\nErkunden anfangen. Solange es mit ihm ist...)", italian="(Mi incuriosisce molto...[K] Quasi\nquasi potrei ricominciare a esplorare, finché\nsi tratta di lui.)", spanish="(Es muy curioso, pero...[K] creo que\npodría volver a explorar, siempre y cuando\nfuera con él.)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" (All right.)", french=" (Soit.)", german=" (Na gut.)", italian=" (E va bene.)", spanish=" (Muy bien...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_aamarudo, 204, 164, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I've got it.[K] You can be\nmy apprentice.", french="J'ai pris ma décision.[K]\nTu peux devenir mon apprenti.", german="Gut, ich habe mich entschieden.[K]\nDu darfst mein Lehrling sein.", italian="D'accordo.[K] Puoi diventare\nil mio apprendista.", spanish="Ya está, decidido.[K] Te acepto\ncomo aprendiz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" R-really?!", french=" V-vraiment?!", german=" W-wirklich?!?", italian=" S-Sul serio?!", spanish=" ¡¿En... En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" But...[K] My training is very strict!", french="Mais...[K] mon entraînement\nest très strict!", german="Aber...[K]\nMein Training hat es in sich!", italian="Ma...[K] i miei allenamenti sono\nmolto duri!", spanish="Pero...[K] mi entrenamiento es\nmuy estricto, ¡te lo aviso!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If you won't go along with me,\nthen we're through!", french="Si tu ne parviens pas à te faire\nà mes méthodes, alors on arrête aussitôt!", german="Sobald du schwächelst, sind wir\ndurch damit!", italian="Se non ascolterai quello che\nti dirò, allora non se ne farà più niente!", spanish=" Si no lo aceptas, se acabó."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay! I did it! Thank you! ♪", french=" Youpla! J'ai réussi! Merci! ♪", german="Juchhu! Geschafft!\nVielen Dank! ♪", italian=" Urrà! Ce l'ho fatta! Grazie! ♪", spanish="¡Yupi! ¡Lo he conseguido!\n¡Gracias! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay, yay, yay! ♪", french=" Youhou, youpla, youhou! ♪", german=" Juchhu, juchhu, juchhu! ♪", italian=" Evviva, evviva, evviva! ♪", spanish=" ¡Bien, bien, bieeen! ♪"})
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Right)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpRight)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Right)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownLeft)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Up)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And so...", french="[CN]Et c'est ainsi...", german="[CN]Und so geschah es...", italian="[CN]Quindi...", spanish="[CN]Y así fue como..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Master recognized me\n[CN]as his apprentice...", french="[CN]... que le Maître m'a reconnu\n[CN]comme son apprenti...", german="[CN]Mein Meister akzeptierte\n[CN]mich als seinen Lehrling...", italian="[CN]Il maestro mi ha preso\n[CN]come suo apprendista...", spanish="[CN]Mi maestro me aceptó\n[CN]como aprendiz..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And he returned to being an explorer...", french="[CN]Et qu'il est redevenu explorateur...", german="[CN]Während er wieder zu einem\n[CN]Erkunder wurde.", italian="[CN]E ha ricominciato a fare l'esploratore...", spanish="[CN]Y volvió a ser un explorador..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And so Master and I...[K]\n[CN]went out on explorations together.", french="[CN]Donc, le Maître et moi-même...[K]\n[CN]nous sommes partis ensemble en exploration.", german="[CN]Mein Meister und ich...[K] Wir\n[CN]erkundeten eine ganze Zeit lang zusammen.", italian="[CN]Così io e il mio maestro...[K]\n[CN]siamo andati a esplorare insieme.", spanish="[CN]Y así el maestro y yo...[K]\n[CN]empezamos a explorar juntos."})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpRight)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Right)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Left)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(4), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ah ha ha ha ha ha ha! ♪", french=" Ah ha ha ha ha ha ha! ♪", german=" Ahahahahahaha! ♪", italian=" Ah ah ah ah ah ah ah! ♪", spanish=" ¡Ja, ja, ja, ja, ja, ja, ja! ♪"})
  SkySceneKit.spin(hero, 2, 3, 1) -- Turn3 (rotation partielle)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm looking forward to you\ntaking care of me. ♪[K] Master. ♪", french="Je suis si content que vous\nsoyez d'accord pour vous occuper\nde moi. ♪[K] Maître. ♪", german="Ich freue mich darauf, dir zur\nSeite zu stehen. ♪[K] Meister. ♪", italian="Ora ho un maestro! ♪[K]\nNon vedo l'ora di imparare tutto quello\nche sa sull'esplorazione. ♪", spanish="Tengo muchas ganas de aprender\ncosas de ti... ♪[K] maestro. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Taking care of you...[K] Hey, wait!", french="Pour m'occuper de toi...[K]\nHé, minute!", german=" Mir zur Seite...[K] Augenblick!", italian="Tutto quello che so\nsull'esplorazione...[K] Ehi, aspetta!", spanish=" Aprender de mí...[K] ¡Eh, espera!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The way you're acting, I don't\nknow if we'll be doing anything together...", french="Je n'ai rien promis!\nSi ton comportement ne me convient pas...", german="Wenn du dich so aufführst,\nweiß ich nicht, ob das so eine gute Idee ist...", italian="Se ti comporti così, non so\nquanto potremo andare d'accordo...", spanish="Para empezar, si sigues actuando\nasí no sé si vamos a llegar muy lejos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  SkySceneKit.spin(hero, 2, 2, 1) -- Turn3 (rotation partielle)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't be so strict,\nMaster. ♪[K] Ah ha ha ha ha ha! ♪", french="Vous êtes trop dur avec moi,\nMaître. ♪[K] Ah ha ha ha ha ha! ♪", german="Sei doch nicht so streng,\nMeister. ♪[K] Ahahahahaha! ♪", italian="Non essere così rigido,\nmaestro. ♪[K] Ah ah ah ah ah ah ah! ♪", spanish="No me seas hueso, maestro. ♪[K]\n¡Ja, ja, ja, ja, ja, ja! ♪"})
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="How are we going to be an\nexploration team if you start off acting\nlike that? Hey!", french="Comment veux-tu qu'on devienne\nune équipe d'exploration si tu réagis comme\nça? Hé!", german="Wenn du dich so aufführst, wie\nsollen wir dann als Erkundungsteam\nfunktionieren? Hey!", italian="Come possiamo diventare una\nvera squadra d'esplorazione se continui a\ncomportarti così? Ehi!", spanish="¿Cómo vamos a ser un equipo\nexplorador si te portas así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ah ha ha! I'm so happy! ♪[K]\nAh ha ha ha ha ha ha ha! ♪", french="Ah ha ha! Je suis fou de joie! ♪[K]\nAh ha ha ha ha ha ha ha! ♪", german="Ahaha! Ich bin ja so froh! ♪[K]\nAhahahahahahaha! ♪", italian="Ah ah ah! Sono così felice! ♪[K]\nAh ah ah ah ah ah ah! ♪", spanish="¡Ja, ja, ja! ¡Qué alegría! ♪[K]\n¡Ja, ja, ja, ja, ja, ja, ja! ♪"})
  SkySceneKit.spin(hero, 2, 3, 1) -- Turn3 (rotation partielle)
  -- message_Close
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
