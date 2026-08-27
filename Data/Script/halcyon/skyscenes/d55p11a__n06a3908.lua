-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/n06a3908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_CHARMS
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GAME:WaitFrames(6)
    local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 240, 224, Direction.Down, "NPC_CHAAREMU")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(6)
    GROUND:EntTurn(hero, Direction.Up)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(18, 21))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 312, 224, Direction.Down, "NPC_SAANAITO")
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
    GAME:WaitFrames(math.random(12, 30))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
    GAME:WaitFrames(math.random(18, 21))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
    GAME:WaitFrames(math.random(12, 30))
    pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
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
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(7) -- Lock(7) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_CHAAREMU
    -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- SetAnimation(26) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    SkySceneKit.lock(11) -- Lock(11) NDS
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
    SkySceneKit.lock(12) -- Lock(12) NDS
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
    SkySceneKit.lock(13) -- Lock(13) NDS
    do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(14), p.Y+(0), false, 2) end
    GAME:WaitFrames(20)
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(12, 30))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
    GAME:WaitFrames(math.random(18, 24))
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(12, 30))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(18, 24))
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
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
    end
    end
    -- @label_2 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(14) -- Lock(14) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_SAANAITO
    -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(15) -- Lock(15) NDS
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
    SkySceneKit.lock(16) -- Lock(16) NDS
    GAME:WaitFrames(15)
    do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-14), p.Y+(0), false, 2) end
    GAME:WaitFrames(2)
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
    GAME:WaitFrames(9)
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
    -- @label_5 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(18, 21))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(12, 27))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(18, 21))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(12, 27))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(18, 21))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(12, 27))
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(2) -- join WaitEffect
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
    -- CallCommon CORO_JUMP_HAPPY_FUNC (fermeture/attente message: géré par say())
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
    end
    end
    end
    end
    end
    end
    -- @label_4 [étiquette de flux ExplorerScript]
    pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(17) -- Lock(17) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D55P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitLockLives
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_RANDOM_DUNGEON_THEME3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 280, 296, Direction.Up, "NPC_MANYUURA")
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="By the way, we're not finished\nwith you.", french="Au fait, on n'en a pas fini\navec vous...", german="Da fällt mir gerade etwas ein:\nMit euch sind wir noch nicht fertig!", italian="Comunque abbiamo un conto\nin sospeso con voi.", spanish="Por cierto, aún no hemos\nacabado con vosotras."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="The next time we see you...[K]\nWe're not going to go easy on you...", french="A notre prochaine rencontre...[K]\non sera sans pitié...", german="Wenn wir euch das nächste Mal\nbegegnen...[K] Macht euch auf etwas gefasst!", italian="La prossima volta che\nci incontreremo...[K] non ve la caverete\ncosì facilmente...", spanish="La próxima vez que os veamos...[K]\nno vamos a ser tan blandos..."})
  -- message_Close
  GROUND:EntTurn(npc_npc_manyuura, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nLet's go!", french="[CS:N]Arbok[CR]! [CS:N]Drascore[CR]![K]\nOn y va!", german="[CS:N]Arbok[CR]! [CS:N]Piondragi[CR]![K]\nWir brechen auf!", italian="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nAndiamo!", spanish="Venga, [CS:N]Arbok[CR], [CS:N]Drapion[CR].[K]\nNos vamos."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_manyuura, 276, 500, false, 2)
  pcall(function() GAME:MoveCamera(276, 304, 60, false) end) -- performer/caméra
  GAME:WaitFrames(45)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 240, 288, Direction.Up, "NPC_AABOKKU")
  GROUND:MoveToPosition(npc_npc_aabokku, 240, 320, false, 2)
  GAME:WaitFrames(45)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 312, 280, Direction.Up, "NPC_DORAPION")
  GROUND:MoveToPosition(npc_npc_dorapion, 312, 316, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Next time, we'll beat you up!", french="La prochaine fois, on vous\nterrassssera!", german="Beim nächsssten Mal machen\nwir euch fertig! Ssss-sss...", italian="La prosssssima volta, vi\nbatteremo!", spanish="La próxima vez osss vamosss\na machacar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Remember that!", french=" Souvenez-vous-en!", german=" Denkt daran!", italian=" Ricordatevelo!", spanish=" ¡Que no se os olvide!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aabokku, 240, 496, false, 2)
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(npc_npc_dorapion, 312, 496, false, 2)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee-hee![K]\nIt's a date! [M:H8]", french="Hi hi![K] Les filles, on a\nun rancard! [M:H8]", german="Hi-hi![K]\nAbgemacht! [M:H8]", italian=" Ih ih![K] Affare fatto! [M:H8]", spanish="¡Ji, ji![K] ¡Os estaremos\nesperando sentadas! [M:H8]"})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 236, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Phew...[K] So the treasure here\nwas just the Time Gear...", french="Pfiou...[K] Alors c'était ce Rouage\ndu Temps, le trésor...", german="Puh...[K] Also war der einzige\nSchatz hier dieses Zahnrad der Zeit.", italian="Fiuuu...[K] Quindi il tesoro non era\naltro che un Ingranaggio del Tempo...", spanish="Uf...[K] Así que el tesoro era\nsolo el Engranaje del Tiempo..."})
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 280, 208, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
  SkySceneKit.unlock(15) -- Unlock(15) NDS
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Up until now we've gotten every\ntreasure we've aimed for...", french="Jusqu'à aujourd'hui, aucun trésor\nn'avait réussi à nous échapper...", german="Bis zu diesem Zeitpunkt haben\nwir jeden Schatz bekommen, auf den wir aus\nwaren...", italian="Finora abbiamo conquistato tutti\ni tesori che ci interessavano...", spanish="Hasta ahora habíamos conseguido\ntodos los tesoros que queríamos..."})
  -- message_Close
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Yeah...[K] This time we've found\nsomething even we can't take...", french="Et voilà...[K] voilà qu'on tombe\nsur un objet qu'on ne peut même pas\ns'approprier...", german="Ja...[K] Und dieses Mal haben wir\neinen Schatz gefunden, den selbst wir nicht\nmitnehmen können...", italian="Già...[K] E questa volta abbiamo\ntrovato qualcosa che non possiamo nemmeno\nprendere...", spanish="Ya...[K] Pero esta vez hemos\nhallado algo que ni nosotras podemos tener..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" No way...", french=" C'est hors de question...", german=" Auf keinen Fall...", italian=" Peccato...", spanish=" Mejor dejarlo aquí..."})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" It has to be this way.", french=" Nous ne pouvons rien faire.", german=" Das muss so sein.", italian=" È giusto così.", spanish=" Así es como debe ser."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="There are some things in this\nworld that you just can't take.", french="Certaines choses en ce monde\ndoivent rester sacrées.", german="Es gibt Dinge in dieser Welt, die\nman nicht an sich nehmen kann.", italian="Ci sono delle cose al mondo\nche non possono essere prese.", spanish="Hay ciertas cosas en esta vida\nque no nos corresponden."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Even though we can't take the\ntreasure with us, I'd call this a success.\nWouldn't you?", french="Même si on ne peut pas\nemporter ce trésor avec nous, cette aventure\nreste un succès, vous ne croyez pas?", german="Doch obwohl wir diesen Schatz\nnicht mit uns nehmen können, würde ich die\nErkundung als Erfolg bewerten. Nicht wahr?", italian="Anche se non possiamo portare\nvia questo tesoro, la nostra avventura è\nstata comunque un successo. Non credete?", spanish="Aunque no podamos llevarnos el\ntesoro, diría que la aventura ha sido un éxito,\n¿no creéis?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We even had a more than fair\nfight against the villainous Team [CS:X]AWD[CR].", french="Nous avons fait un beau combat\ncontre l'infâme Equipe [CS:X]DDA[CR].", german="Wir haben sogar einen fairen\nKampf gegen das gemeine Team [CS:X]SPA[CR] gehabt.", italian="Abbiamo anche avuto l'occasione\ndi affrontare quei tipacci del Team [CS:X]AWD[CR].", spanish="Hasta tuvimos un combate con\nel malvado [CS:X]Equipo WAD[CR]."})
  -- message_Close
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Oh! That's right!", french=" C'est bien vrai!", german=" Oh! Das stimmt!", italian=" Oh! Giusto!", spanish=" ¡Anda, pues tienes razón!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Besides, that beautiful and\nprecious Time Gear...", french="En plus, nous avons eu l'occasion\nde poser nos yeux sur un Rouage du Temps...", german="Und so ein schönes und\nwertvolles Zahnrad der Zeit...", italian="Inoltre, quel bellissimo\ne prezioso Ingranaggio del Tempo...", spanish="Y encima ese precioso y\nvaliosísimo Engranaje del Tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We saw one for the first time,\ndidn't we?!", french="... pour la toute première fois\nde notre vie, n'est-ce pas?", german="Wir alle haben es zum ersten\nMal gesehen, nicht wahr?!?", italian="Beh, per la prima volta\nne abbiamo visto uno, no?!", spanish="¡Hemos visto uno por primera\nvez! ¡Qué pasada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Oh yeah![K] That's right!", french=" Mais oui![K] Tu as raison!", german=" Oh ja![K] Das stimmt!", italian=" Oh sì![K] È vero!", spanish=" ¡Sí, sí![K] ¡Cómo mola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪ That's right! ♪", french="Exact. ♪\nÇa en valait la peine! ♪", german=" Ja. ♪ Ganz genau! ♪", italian=" Sì. ♪ Giusto! ♪", spanish=" Sí. ♪ ¡Es genial! ♪"})
  SkySceneKit.unlock(12) -- Unlock(12) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And we made it successfully\nthrough the maze that has stumped so many\nothers before us...", french="Sans compter que nous avons\ntriomphé du labyrinthe qui en a découragé\ntant d'autres avant nous...", german="Und wir haben das Labyrinth,\ndas so viele vor uns abgehalten hat,\nerfolgreich durchquert.", italian="E poi abbiamo trovato l'uscita di\nquel labirinto così complicato. Prima di noi\nnon c'era mai riuscito nessuno...", spanish="Y logramos atravesar el laberinto\ndonde tantos otros se han perdido antes\nque nosotras..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I knew it. ♪ We are...[K]the best,\naren't we? [M:H8]", french="Je le savais. ♪ Nous sommes\net nous resterons...[K] les meilleures,\npas vrai? [M:H8]", german="Ich wusste es. ♪ Wir sind...[K]\ndie Besten, nicht? [M:H8]", italian="Lo sapevo. ♪ Siamo...[K]\nle migliori, vero? [M:H8]", spanish="Lo sabía. ♪ Somos...[K]\nlas mejores, ¿a que sí? [M:H8]"})
  -- message_Close
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  SkySceneKit.unlock(13) -- Unlock(13) NDS
  SkySceneKit.unlock(16) -- Unlock(16) NDS
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Uwahahahahaha!", french=" Ha ha ha ha!", german=" Uwahahahahaha!", italian=" Uahahahahah!", spanish=" ¡Ji, ji, ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Uhuhuhuhuhuhu!", french=" Hé hé hé hé!", german=" Uhuhuhuhuhuhu!", italian=" Uhuhuhuhuhuh!", spanish=" ¡Ju, ju, ju, ju, ju!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hah-hah-hah! Hah-hah-hah!", french=" Hi hi hi hi!", german=" Hahaha! Hahaha!", italian=" Ah-ah-ah! Ah-ah-ah!", spanish=" ¡Ja, ja, ja! ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Um...[K] That's great everyone. ♪", french=" Hum...[K] Super, les filles. ♪", german="Ähem...[K] Wirklich großartig,\nalle miteinander. ♪", italian=" Uhm...[K] È fantastico, gente. ♪", spanish=" Hum...[K] Es genial. ♪"})
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(2) -- join WaitLockLives
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(12), p.Y+(0), false, 2) end
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-12), p.Y+(0), false, 2) end
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Well, I'm headed home now.", french="Bon, il est temps de rentrer\nchez moi.", german="Aber gut, ich mache mich dann\nmal auf den Weg.", italian=" Bene, ora me ne torno a casa.", spanish=" Bueno, yo me voy a casa."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(150) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Gardevoir[CR], [CS:N]Medicham[CR].", french=" [CS:N]Gardevoir[CR], [CS:N]Charmina[CR].", german=" [CS:N]Guardevoir[CR] und [CS:N]Meditalis[CR].", italian=" [CS:N]Gardevoir[CR], [CS:N]Medicham[CR].", spanish=" [CS:N]Gardevoir[CR], [CS:N]Medicham[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Got it.", french=" Bien reçu.", german=" Okay.", italian=" Ricevuto.", spanish=" Entendido."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?[K] What's with everyone?", french=" Hein?[K] Qu'y a-t-il?", german=" Bitte?[K] Was ist mit euch allen?", italian=" Uh?[K] Che vi succede?", spanish=" ¿Eh?[K] ¿Qué sucede?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR].[K] You're not half bad!", french="[CS:N]Grodoudou[CR].[K] Tu es plutôt doué,\ndans ton genre!", german="[CS:N]Knuddeluff[CR].[K] Du bist gar nicht\nso übel!", italian=" [CS:N]Wigglytuff[CR].[K] Non sei niente male!", spanish=" [CS:N]Wigglytuff[CR]...[K] ¡Molas bastante!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We've got a better opinion of\nyou now!", french="Nous avons une meilleure opinion\nde toi, à présent!", german="Du erschienst uns am Anfang\nganz schön wunderlich, aber letztendlich bist\ndu ein wirklich toller Kerl!", italian="Abbiamo un'opinione migliore\ndi te adesso!", spanish="Nuestra opinión de ti\nha mejorado lo suyo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?", french=" Pardon?", german=" Bitte was?", italian=" Uh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="You saw through [CS:N]Ditto[CR]'s\ntreasure-chest disguise...", french="Tu as reconnu [CS:N]Métamorph[CR] alors\nqu'il était déguisé en coffre au trésor...", german="Du hast den Schatztruhen-Trick\nvon [CS:N]Ditto[CR] durchschaut.", italian="Hai smascherato [CS:N]Ditto[CR] dopo\nche si era trasformato in forziere...", spanish="Descubriste el disfraz de cofre\nde [CS:N]Ditto[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" You're really cool!", french=" Tu assures un max!", german=" Das war wirklich großartig!", italian=" Sei davvero forte!", spanish=" ¡Eres sensacional!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I-is that so...?[K] I see...", french=" V-vous trouvez...?[K] Je vois...", german=" Findet ihr?[K] Nun ja...", italian=" D-Dite sul serio...?[K] Ok...", spanish=" ¿E... eso pensáis?[K] Ah, vaya..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hee-hee-hee-hee...", french=" Hé hé hé...", german=" Hi-hi-hi-hi...", italian=" Eh eh eh eh eh...", spanish=" Ji, ji, ji, ji..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So...[K] What will you do next,\n[CS:N]Wigglytuff[CR]?", french="Alors...[K] quels sont tes projets,\n[CS:N]Grodoudou[CR]?", german="Nun denn...[K] Was wirst du als\nNächstes machen, [CS:N]Knuddeluff[CR]?", italian="Allora...[K] Cosa farai adesso,\n[CS:N]Wigglytuff[CR]?", spanish="Bueno...[K] ¿Cuál será\ntu próxima aventura, [CS:N]Wigglytuff[CR]?"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?[K] Next?", french=" Hein?[K] Projets?", german=" Wie?[K] Als Nächstes?", italian=" Uh?[K] Cosa farò?", spanish=" ¿Eh?[K] ¿La próxima?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes, next. ♪", french=" Oui, tes projets. ♪", german=" Ja, hiernach. ♪", italian=" Sì. ♪", spanish=" Sí, claro. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I wonder...[K] I don't really have\nany plans...", french="Euh, je ne sais pas trop...[K] Je n'ai\naucun projet pour l'instant...", german="Ich weiß nicht...[K] Ich habe keine\nkonkreten Pläne.", italian="A dire il vero...[K] Non ho\nnessun progetto in mente...", spanish="Ahora que lo dices...[K] No tengo\nplanes, la verdad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Well, if you'd like...[K]you could\nalways come explore with us?", french="Eh bien, si tu n'as rien d'autre\nde prévu...[K] tu peux toujours nous accompagner\ndans nos explorations...", german="Nun, wenn du magst...[K] Wie wäre\nes, mit uns auf Erkundung zu kommen?", italian="Beh, se ti va...[K] potresti\nesplorare insieme a noi...", spanish="Bueno, pues si quieres...[K] puedes\nvenirte a explorar con nosotras, ¿no?"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_saanaito, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" With you?", french=" Vous accompagner?", german=" Mit euch?", italian=" Insieme a voi?", spanish=" ¿Con vosotras?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Yes, with us.[K] What do you think?", french=" Oui, pourquoi pas?[K] Qu'en dis-tu?", german=" Ja, mit uns.[K] Wie findest du das?", italian=" Sì.[K] Che ne pensi?", spanish=" Sí, eso mismo.[K] ¿Qué te parece?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hmmm...[K] What should I do...?", french=" Hum...[K] Ça mérite réflexion...", german="Hmmm...[K]\nWas soll ich nur machen?", italian=" Mmmh...[K] Non so che dire...", spanish=" Hum...[K] ¿Qué hago?..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It would be fun exploring\nwith you...", french="Ce serait amusant d'explorer\navec vous...", german="Es würde Spaß machen, mit\neuch gemeinsam zu erkunden.", italian="Mi piacerebbe esplorare\ninsieme a voi...", spanish="Sería divertido explorar\ncon vosotras..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But I've never explored with\nanyone other than my master...", french="... mais je ne suis jamais parti\nen exploration avec quelqu'un d'autre que\nmon maître...", german="Aber ich war noch nie mit\njemand anderem außer meinem Meister\nauf Erkundung...", italian="Ma l'unico con cui sia mai\nandato in esplorazione è il mio maestro...", spanish="Pero nunca he explorado con\nnadie que no fuera mi maestro..."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:Y]Lopunny[CR]. That thing...", french="[CS:Y]Lockpin[CR]. C'est le moment\nou jamais de sortir le fameux objet...", german=" [CS:Y]Schlapor[CR]. Dieses Ding...", italian=" [CS:Y]Lopunny[CR]. Quella cosa...", spanish=" [CS:Y]Lopunny[CR]. Se me ocurre..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm on it, [CS:N]Gardevoir[CR].", french="Tu lis dans mes pensées,\n[CS:N]Gardevoir[CR].", german=" Ja, genau, [CS:N]Guardevoir[CR].", italian=" Ho capito, [CS:N]Gardevoir[CR].", spanish=" Buena idea, [CS:N]Gardevoir[CR]."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey, ummm... ♪\n[CS:N]Wigglytuff[CR]. [M:H8]", french=" Ecoute... ♪ [CS:N]Grodoudou[CR]. [M:H8]", german="Hey, hmmm... ♪\n[CS:N]Knuddeluff[CR]. [M:H8]", italian=" Ehi, uhmmm... ♪ [CS:N]Wigglytuff[CR]. [M:H8]", spanish=" Oye, estooo... ♪ [CS:N]Wigglytuff[CR]. [M:H8]"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you were to come exploring\nwith us...", french="Si tu venais explorer avec\nnous...", german="Wenn du mit uns auf Erkundung\ngehen würdest...", italian="Se decidi di unirti alla nostra\nsquadra d'esplorazione...", spanish="Si te vienes a explorar\ncon nosotras..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(12), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We could give you this. Would\nyou like that? [M:H8]", french="... on pourrait te donner ça,\nen échange. Ça te plairait? [M:H8]", german="Könnten wir dir das hier\nanbieten. Wie wäre das? [M:H8]", italian="... ti daremo questa. Che ne\ndici? [M:H8]", spanish=" Te daremos esto. ¿Qué te parece? [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oooh!", french=" Oooh!", german=" Oooh!", italian=" Oooh!", spanish=" ¡Anda!"})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I-it's a...[K]Perfect Apple! ♪", french=" Une...[K] une Pomme Parfaite! ♪", german=" E-ein...[K] Perfekter Apfel! ♪", italian=" È-È una...[K] Mela Perfetta! ♪", spanish="¡E... es una...[K] Manzana\nPerfecta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But...", french=" Cependant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(9)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(9)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I haven't decided if I'm giving it\nto you yet. ♪", french="... je ne sais pas si je vais te\nla donner tout de suite. ♪", german="Ich bin mir noch nicht sicher,\nob ich ihn dir wirklich geben soll. ♪", italian="Non ho ancora deciso se te\nla darò. ♪", spanish="Aún no he decidido\nsi te la doy o no. ♪"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_SetWaitMode(180, 90) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Let's get something straight...[K]\nWe're all pretty fast moving.", french="Que les choses soient claires...[K]\nOn n'est pas du genre à traîner la patte.", german="Eine Sache noch...[K] Wie du\ngemerkt hast, sind wir alle ziemlich auf Zack.", italian="Facciamo così...[K] Noi tre siamo\ntutte molto veloci.", spanish="Vamos a dejar algo claro...[K]\nNosotras somos muy veloces."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(210, 60) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Do you think you could keep up\nwith us?", french="Es-tu capable de suivre\nle rythme?", german="Glaubst du, du kannst mit\nunserem Tempo mithalten?", italian=" Pensi di riuscire a starci dietro?", spanish="¿Crees que podrás seguirnos\nel ritmo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(120, 60) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What do you think?[K]\nHow about a race?", french="Qu'en penses-tu?[K] Et si nous\nfaisions la course?", german="Nun ja?!?[K] Wie wäre es mit\neinem Rennen?", italian="Che ne dici?[K]\nFacciamo una gara?", spanish="¿Cómo lo ves?[K]\n¿Echamos una carrera?"})
  -- message_KeyWait
  -- message_SetWaitMode(45, 45) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" 3...[K] 2...[K] 1...[K] GO!", french=" 3...[K] 2...[K] 1...[K] PARTEZ!", german=" 3...[K] 2...[K] 1...[K] LOS!", italian=" 3...[K] 2...[K] 1...[K] VIA!", spanish=" 3...[K] 2...[K] 1...[K] ¡YA!"})
  -- message_Close
  -- SetAnimation(25) [anim idle native]
  GROUND:MoveToPosition(hero, 276, 304, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(6)
  -- SetAnimation(27) [anim idle native]
  GROUND:MoveToPosition(npc_npc_chaaremu, 240, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(6)
  -- SetAnimation(28) [anim idle native]
  GROUND:MoveToPosition(npc_npc_saanaito, 312, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(6)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(25) [anim idle native]
  GROUND:MoveToPosition(hero, 276, 364, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_chaaremu, 240, 344, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_saanaito, 312, 340, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_SetWaitMode(90, 45) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay![K] GO! GO!", french=" Youpla![K] PARTEZ! PARTEZ!", german=" Juchhu![K] LOS! LOS!", italian=" Evviva![K] VIA! VIA!", spanish=" ¡Yupi![K] ¡Vamos, vamos!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_pukurin, 276, 496, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(40)
  -- message_SetWaitMode(150, 60) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]I'll go everywhere! ♪", french="[CN]Je vous suivrai n'importe où! ♪", german="[CN]Ich werde überall hingehen! ♪", italian="[CN]Vi raggiungerò! ♪", spanish="[CN]¡Iré a cualquier sitio! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]YOOM...TAH!", french="[CN]TA-DAAAAAA!", german="[CN]LUUUU... FIIII!", italian="[CN]BADABUM!", spanish="[CN]¡Genial!"})
  -- message_Close
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(20)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
