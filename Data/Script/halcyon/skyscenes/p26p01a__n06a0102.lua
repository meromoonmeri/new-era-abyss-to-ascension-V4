-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P26P01A/n06a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for object OBJECT_P26P01A4_539
    -- SetAnimation(17) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(17) [anim idle native]
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_539 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_539 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(0, 1))
    -- SetPositionMark OBJECT_P26P01A4_539 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_539 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_0 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(7) -- Lock(7) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for object OBJECT_P26P01A4_540
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(math.random(3, 6))
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_540 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_540 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(0, 1))
    -- SetPositionMark OBJECT_P26P01A4_540 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_540 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_2 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(9) -- Lock(9) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 3 for object OBJECT_P26P01A4_541
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(10) -- Lock(10) NDS
    GAME:WaitFrames(math.random(3, 6))
    -- @label_5 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_541 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_541 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(0, 1))
    -- SetPositionMark OBJECT_P26P01A4_541 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_541 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_4 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(11) -- Lock(11) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 4 for object OBJECT_P26P01A4_542
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(12) -- Lock(12) NDS
    GAME:WaitFrames(math.random(2, 4))
    -- @label_7 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_542 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_542 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(0, 3))
    -- SetPositionMark OBJECT_P26P01A4_542 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_542 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_6 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(13) -- Lock(13) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 5 for object OBJECT_P26P01A4_543
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(14) -- Lock(14) NDS
    GAME:WaitFrames(math.random(6, 9))
    -- @label_9 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_543 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_543 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(1, 3))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_543 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_543 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(1, 3))
    -- SetPositionMark OBJECT_P26P01A4_543 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_543 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    GAME:WaitFrames(math.random(1, 3))
    -- SetPositionMark OBJECT_P26P01A4_543 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_543 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_8 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(15) -- Lock(15) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 6 for object OBJECT_P26P01A4_544
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(16) -- Lock(16) NDS
    GAME:WaitFrames(math.random(4, 8))
    -- @label_11 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(math.random(0, 1))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_544 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(18) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_544 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_10 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(17) -- Lock(17) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 7 for object OBJECT_P26P01A4_545
    -- SetAnimation(9) [anim idle native]
    SkySceneKit.lock(18) -- Lock(18) NDS
    GAME:WaitFrames(math.random(4, 6))
    -- @label_13 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(math.random(0, 1))
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- SetPositionMark OBJECT_P26P01A4_545 [cible sans placement SSA zone: placement non joué]
    -- SetAnimation(17) [anim idle native]
    -- MovePositionOffset OBJECT_P26P01A4_545 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(2) -- join WaitAnimation
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
    -- @label_12 [étiquette de flux ExplorerScript]
    SkySceneKit.lock(19) -- Lock(19) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V39P01A) [décor sub chargé: Sub_v39p01a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 12>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(9) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v39p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_RemoveActing(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]On the eastern horizon...", french="[CN]Dans une lointaine contrée orientale...", german="[CN]Am östlichen Horizont...", italian="[CN]Da qualche parte a est...", spanish="[CN]En un territorio del este..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]In a small expanse of ruins...", french="[CN]Au cœur de vestiges anciens...", german="[CN]In einer entlegenen Ruine...", italian="[CN]In una piccola distesa di rovine...", spanish="[CN]En una pequeña extensión de ruinas..."})
  -- message_Close
  -- back_SetGround(LEVEL_P26P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_goroon = SkySceneKit.spawn_npc("graveler", 208, 368, Direction.Down, "NPC_GOROON")
  GROUND:MoveToPosition(npc_npc_goroon, 204, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" .........[K]Hah hah... This is...", french=" .........[K] Ha ha... J'y suis...", german=" ..........[K]Das...", italian=" .........[K] Ah ah... Questo è...", spanish=" Huy...[K] Ja, ja... Esta debe de ser..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="This is the...deepest part of\nthe dungeon, I think...", french="J'ai atteint les tréfonds\nde ce donjon...", german="Das sieht aus wie der tiefste Teil\ndes Dungeons.", italian="Questo è... il punto più profondo\ndel dungeon, credo...", spanish="La parte más profunda\ndel territorio, según creo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_goroon, 204, 228, false, 2)
  pcall(function() GAME:MoveCamera(204, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Oooh, hey![K] There's a treasure\nchest up there!", french=" Oooh, hé![K] Un coffre au trésor!", german="Oh![K]\nDa oben ist eine Schatztruhe!", italian=" Oooh, ehi![K] C'è un forziere lassù!", spanish="¡Anda, mira![K] ¡Pero si ahí arriba\nhay un cofre!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" ...[K]D-don't tell me...", french=" ...[K] Ne me dites pas que...", german=" ...[K]S-sag bloß nicht...", italian=" ...[K] C-Che sia...", spanish=" Hum...[K] No... No me digas..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Don't tell me this is the treasure\neveryone's been blabbering about...", french="Ne me dites pas qu'il s'agit du\ntrésor dont tout le monde parle...", german="Sag bloß, das ist der\nsagenumwobene Schatz, von dem alle reden...", italian="Che sia il famoso tesoro\ndi cui parlano tutti...?", spanish="No me digas que este es\nel tesoro del que todo el mundo habla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_goroon, 204, 188, false, 2)
  pcall(function() GAME:MoveCamera(204, 188, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" It is![K] It has to be!", french=" Mais si![K] Forcément!", german=" Er ist es![K] Er muss es sein!", italian=" Ma sì![K] È sicuramente così!", spanish=" ¡Lo es![K] ¡Tiene que serlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="This is the treasure of\nthese ruins!", french="Le fameux trésor caché dans\nles profondeurs de ces ruines!", german="Dies ist der Schatz, der zu\ndiesen Ruinen gehört!", italian=" È il tesoro di queste rovine!", spanish=" ¡Es el tesoro de estas ruinas!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Ugh...[K]I've been working hard\nas an explorer for a really long time...", french="Argh...[K] Je me tue à la tâche\net multiplie les explorations depuis\nsi longtemps...", german="Uff... [K]Ich habe als Erkunder so\nlange hart geschuftet...", italian="Urgh...[K] Ho esplorato in lungo\ne in largo per tanto tempo...", spanish="Uf...[K] Llevo mucho tiempo\ntrabajando duro como explorador..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" And, finally...", french=" ... et enfin...", german=" Und endlich...", italian=" E finalmente...", spanish=" Y al fin..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Finally, I've found what I've\nsearched for...[K]an awesome treasure!", french="... j'ai trouvé ce que je\ncherchais...[K] un fabuleux trésor!", german="Endlich finde ich, wonach ich so\nlange gesucht habe![K] Einen unglaublichen Schatz!", italian="... finalmente ho trovato ciò\nche stavo cercando...[K] Un favoloso tesoro!", spanish="Por fin he encontrado lo que\nanhelaba...[K] ¡Un tesoro increíble!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Ha ha ha ho ho!", french=" Ha ha ha ho ho!", german=" Hahahahoho!", italian=" Ah ah ah oh oh oh!", spanish=" ¡Ja, ja, ja, jo, jo!"})
  GAME:WaitFrames(6)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" This totally rocks![K] I can't wait...", french=" Excellent![K] Je suis si impatient...", german="Alles klar![K]\nIch beeile mich lieber.", italian=" È fantastico![K] Non vedo l'ora di...", spanish=" ¡Qué pasada![K] No puedo esperar..."})
  -- message_Close
  do local p=npc_npc_goroon.Position; GROUND:MoveToPosition(npc_npc_goroon, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_goroon.Position; GROUND:MoveToPosition(npc_npc_goroon, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" ...Oh, darn!", french=" ... Bon sang!", german=" ...Oh nein!", italian=" ... Ah, un attimo!", spanish=" Uf... ¡Soy un insensato!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="The moment I lift up this\ntreasure...", french="Au moment où je soulèverai\nce coffre...", german="Jetzt, wo ich hier bin und den\nSchatz bergen kann...", italian="Temo che nel momento in cui\nsolleverò questo forziere...", spanish=" En cuanto levante este tesoro..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="I'm afraid the ruins will start\nto crumble...", french="J'ai bien peur que les ruines\nmenacent de s'effondrer...", german="Da mache ich mir Sorgen, dass\ndie Ruinen zusammenfallen könnten...", italian="... le rovine cominceranno\na crollare...", spanish="Me temo que las ruinas\ncomenzarán a derrumbarse..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Whew. Glad I thought of that.[K]\nI was so excited I almost got careless.", french="Pfiou, heureusement que j'y ai\npensé.[K] Un peu plus et je le déplaçais\nsans faire attention.", german="Aber gut, dass ich daran gedacht\nhabe.[K] Bei der ganzen Aufregung bin ich fast\nleichtfertig geworden.", italian="Fiuuu... Meno male che ci ho\npensato.[K] Ero talmente emozionato che per\nun attimo avevo abbassato la guardia.", spanish="Buf, por los pelos...[K]\nMe he emocionado tanto que casi me descuido."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Anyway,[K] I'll pick up\nthe treasure carefully...", french="Bon,[K] je vais prendre\nle coffre tout doucement...", german="Na gut.[K] Ich werde diesen Schatz\nbehutsam bergen.", italian="Ok,[K] ora devo sollevarlo\ncon molta attenzione...", spanish="En fin...[K] Voy a coger el tesoro\ncon mucho cuidado..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Then I'll run as fast as I\ncan out of here before it all crumbles down\non me.", french="Ensuite, je partirai à toute\nvitesse avant que l'édifice ne s'écroule\nsur moi.", german="Und dann so schnell wie möglich\nhier hinausrennen, bevor alles über meinem\nKopf einstürzt.", italian="Poi correrò via il più\nvelocemente possibile prima che\nmi crolli tutto addosso.", spanish="Y me iré pitando de aquí\nantes de que todo esto se me caiga encima."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(204, 160, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_goroon, 204, 160, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="There's no mistake...[K]\nThis treasure is...", french="Pas de doute...[K]\nCe trésor est...", german="Es gibt keinen Zweifel...[K]\nDieser Schatz gehört...", italian="È un piano infallibile...[K]\nQuesto tesoro è...", spanish="Que nadie se confunda...[K]\nEste tesoro es..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" This treasure...[K]is mine!", french=" Ce trésor est...[K] à moi!", german=" Dieser Schatz...[K] gehört mir!", italian=" Questo tesoro...[K] è mio!", spanish=" Este tesoro...[K] ¡es mío!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Wait a moment!", french=" Pas si vite!", german=" Einen Augenblick mal!", italian=" Non così in fretta!", spanish=" ¡Espera un momento!"})
  -- message_Close
  -- GAP: BGM BGM_TEAM_CHARMS_THEME_INTRO_ONLY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 4, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_goroon.Position; GROUND:MoveToPosition(npc_npc_goroon, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Wh...[K]what was that? That\nvoice?!", french="D'où vient...[K] cette voix?\nQui est là?!", german="W-[K]was war das für eine\nStimme?!?", italian="Cosa...[K] Cosa succede?\nChi ha parlato?!", spanish="¿Qué...?[K] ¿Qué ha sido eso?\n¡¿De quién es esa voz?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="This treasure has already been claimed--\nby us!", french="Tu arrives trop tard! Ce trésor\nest à nous!", german="Diesen Schatz haben wir entdeckt und\ndaher haben wir ein Anrecht darauf!", italian="Questo tesoro è già stato scoperto...\nda noi!", spanish=" Ese tesoro ya tiene dueño. ¡No lo toques!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" We're not handing it over to you!", french=" Hors de question qu'on te le laisse!", german=" Wir werden ihn dir nicht überlassen!", italian=" Non lasceremo che finisca nelle tue mani!", spanish=" ¡Y no pensamos compartirlo!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english="Wh-who's there?[K]\nWhere are you?", french=" Qui va là?[K] Montrez-vous!", german="W-wer spricht da?[K]\nWo seid ihr?", italian="C-Chi siete?[K]\nCosa volete?", spanish="¿Qui... quién anda ahí?[K]\n¿Quiénes sois?"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Show yourself!", french=" Sortez de votre cachette!", german=" Zeigt euch!", italian=" Fatevi vedere!", spanish=" ¡Mostraos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Hee hee hee![K] Show yourself, you say?", french=" Hi hi hi![K] Tu veux qu'on se montre?", german=" Hihihi![K] Zeigt euch, hast du gesagt?", italian=" Eh eh eh![K] Vuoi sapere chi siamo?", spanish=" ¡Ji, ji, ji![K] ¿Que nos mostremos, dices?"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" All right![K] We'll show ourselves!", french=" Très bien![K] Attention les yeux!", german=" Nun gut![K] Dann wollen wir uns mal zeigen!", italian=" E va bene![K] Ora vedrai!", spanish=" Muy bien.[K] ¡Eso es lo que haremos!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(45) end)
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
  GAME:WaitFrames(30)
  -- GAP: BGM 201 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(10241) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 160, 128, Direction.UpLeft, "NPC_CHAAREMU")
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(npc_npc_chaaremu, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Strength!", french=" Force!", german=" Stärke!", italian=" Forza!", spanish=" ¡Fuerza!"})
  -- message_Close
  -- GAP: se_Play(10241) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 128, Direction.UpLeft, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(npc_npc_saanaito, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Knowledge!", french=" Savoir!", german=" Wissen!", italian=" Sapienza!", spanish=" ¡Sabiduría!"})
  -- message_Close
  -- GAP: se_Play(10241) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8) -- WaitEndAnimation (join anim)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(6) [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.spin(hero, 1, 1, 1) -- Turn3 (rotation partielle)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Beauty!", french=" Beauté!", german=" Schönheit!", italian=" Bellezza!", spanish=" ¡Belleza!"})
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Here come the treasure hunters!\nHere comes Team [CS:X]Charm[CR]!", french="Faites place aux chasseuses de trésor de\nl'Equipe [CS:X]Charme[CR]!", german="Hier sind die Schatzjäger von\nTeam [CS:X]Charme[CR]!", italian="Noi siamo le cacciatrici di tesori!\nIl Team [CS:X]Malia[CR]!", spanish="¡Llegan las buscadoras de tesoros!\n¡El [CS:X]Equipo Carisma[CR]!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
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
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Wh-what's this?", french="Qu'est-ce que c'est que\nce cirque?", german=" W-was soll das?", italian=" C-Come?", spanish=" ¿Qué significa esto?"})
  -- message_Close
  -- GAP: se_Play(10244) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Waaah![K] It's suddenly...", french=" Ouaaah![K] J'y vois plus rien!", german=" Waaah![K] Es ist plötzlich...", italian=" Uaaah![K] Di colpo...", spanish=" ¡Aaaah![K] De repente..."})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" T-too dark to see!", french=" Qui... qui a éteint la lumière?!", german="Es ist z-zu dunkel! Ich sehe nix\nmehr!", italian=" È t-tutto così buio!", spanish=" ¡Es... está demasiado oscuro!"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P20P01A2_374) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Aaah![K] The treasure's gone!", french=" Aaah![K] Le trésor a disparu!", german=" Aaah![K] Der Schatz ist weg!", italian=" Aaah![K] Il tesoro è scomparso!", spanish=" ¡Noo![K] ¡El tesoro se ha esfumado!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_goroon, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Blast![K] I've been tricked!", french=" Bigre![K] Je me suis fait avoir!", german="So was![K] Man hat mich\nreingelegt!", italian=" Oh no![K] Mi hanno fregato!", spanish=" Mecachis...[K] ¡Me la han jugado!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" Th-them!!", french=" Ces filles!!", german=" S-sie waren es!!!", italian=" Q-Quelle tizie!!!", spanish=" Han... Han sido ellas..."})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, nil, 0) end) -- EFFECT_NONE
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- supervision_Acting(7) [neutre/état moteur]
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goroon, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  -- supervision_Acting(8) [neutre/état moteur]
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  GAME:WaitFrames(2) -- WaitLockObject (join objet)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.unlock(12) -- Unlock(12) NDS
  SkySceneKit.unlock(14) -- Unlock(14) NDS
  SkySceneKit.unlock(16) -- Unlock(16) NDS
  SkySceneKit.unlock(18) -- Unlock(18) NDS
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1')
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" AAAAARRRRGGGHHH!", french=" AAAAARRRRGGGHHH!", german=" AAAAARGH!", italian=" AAAAAARRRGGGHHH!", spanish=" ¡Aaaaaaay!"})
  pcall(function() UI:SetSpeaker(npc_npc_goroon) end)
  SkySceneKit.say({english=" I-it's coming down![K] Oh, no!", french=" Tout s'effondre![K] Oh, non!", german="D-die Decke![K] S-sie stürzt ein!\nOh nein!", italian=" S-Sta crollando tutto![K] Oh no!", spanish=" ¡Se viene abajo![K] ¡Socorroo!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(204, 364, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_goroon, 204, 404, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
