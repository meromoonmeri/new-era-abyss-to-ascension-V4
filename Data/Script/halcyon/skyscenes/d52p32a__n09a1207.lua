-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P32A/n09a1207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_YONOWAARU_N9
    local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 288, Direction.UpRight, "NPC_YONOWAARU_N9")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SetAnimation(3) [anim idle native]
    do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
    do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(1) -- hold
  end)
  -- GAP: BGM BGM_PROUD_ACCOMPLISHMENT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D52P32A) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(5) [neutre/état moteur]
  -- supervision_Acting(11) [neutre/état moteur]
  -- supervision_Acting(8) [neutre/état moteur]
  -- supervision_Acting(9) [neutre/état moteur]
  -- supervision_Acting(12) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 256, 144, Direction.Down, "NPC_SEREBII")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(30)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 200, 296, Direction.UpRight, "NPC_YAMIRAMI4")
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 312, 296, Direction.UpLeft, "NPC_YAMIRAMI6")
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="... (Even if I disappear...[K] My\nspirit is alive!)", french="(Même si je disparais...[K]\nMa mémoire reste vivante!)", german="...(Auch wenn ich verschwinde...[K]\nMeine Taten würden für sich sprechen...)", italian="... (Anche se scompaio...[K]\nla mia essenza non cesserà di esistere...)", spanish="Oh... (Aunque yo desaparezca...[K]\n¡mi recuerdo permanecerá!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Please remember, [CS:N]Dusknoir[CR]!", french=" Souviens-toi, [CS:N]Noctunoir[CR]!", german=" Erinnere dich, [CS:N]Zwirrfinst[CR]!", italian="Ti prego, cerca di ricordare,\n[CS:N]Dusknoir[CR]!", spanish=" ¡Recuérdalo, [CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What I sensed in the dungeon\nthat time...[K] Your shining spirit!", french="Ce que j'ai ressenti dans le\ndonjon...[K] ton moi profond!", german="Daran, was ich im Dungeon\ngespürt habe...[K] Dein wahres Ich!", italian="La sensazione che ho avvertito\nnel dungeon quella volta...[K] Era la bontà\ndel tuo cuore!", spanish="Es lo que sentí mientras\nexplorábamos...[K] ¡tu lealtad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" M-my...[K]spirit?", french=" Mon...[K] moi profond?", german=" M-mein...[K] wahres Ich?", italian=" L-La bontà...[K] del mio cuore?", spanish=" ¿Có...[K] cómo dices?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There's nothing that...[K]\nNothing shines like that!", french="Balivernes...[K] Rien de tout\ncela n'existe!", german="Das ist nicht...[K]\nDas ist nicht mein wahres Ich!", italian="È una follia...[K] Una cosa simile\nnon esiste!", spanish="No tienes ni idea...[K]\n¡Yo no soy así!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You're...[K] You're deluding\nyourself!", french=" Tu...[K] tu te fourvoies!", german=" Du...[K] Du irrst dich!", italian="Ti...[K] Ti stai solo facendo\ndelle illusioni!", spanish="¡Es mentira![K] ¡Eso que dices\nno tiene sentido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(50) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" UOOOOOOOOOooooooohhhh!", french=" Rhoooooooooo!", german=" UOOOOOOOOOoooooooh!", italian=" UOOOOOOOOOooooooohhhh!", spanish=" ¡¡Ooooooooh!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(24), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 256, 320, Direction.Up, "NPC_YAMIRAMI5")
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-18), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-28), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 200, 128, Direction.Down, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="M-Master [CS:N]Dusknoir[CR]![K]\nA-are you all right?!", french="M-Maître [CS:N]Noctunoir[CR]![K]\nTout va bien?!", german="M-meister [CS:N]Zwirrfinst[CR]![K]\nI-ist alles in Ordnung?!?", italian="M-Maestro [CS:N]Dusknoir[CR]![K]\nT-Tutto bene?!", spanish=" ¡[CS:N]Dusknoir[CR]![K] ¡¿Estás bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Shut up!", french=" Silence!", german=" Seid still!", italian=" Chiudete il becco!", spanish=" ¡Cállate!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(12), 5, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_yamirami4, 204, 308, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 316, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_yamirami6, 296, 308, false, 2) -- SlidePositionMark (glissement)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" GWAH!", french=" Aaaah!", german=" GWAH!", italian=" GUAH!", spanish=" ¡¡Ay!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(51) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Ah ooh... (A-am I...[K] Has my\nspirit become a part of others' minds?)", french="Ooooh... (Ferai-je...[K] partie\ndes souvenirs des autres?)", german="Ächz... (Kann es sein...[K]\nSind die Gedanken anderer vielleicht in mein\nwahres Ich eingeflossen?)", italian="Ah ooh... (C-Che...[K] la mia\nessenza sia diventata parte della\ncoscienza di qualcun altro?)", spanish="Ooooh... (Entonces...[K] ¿mi recuerdo\npervive ya en los demás?)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" (Then...[K][CS:Y]Grovyle[CR]'s...[K]existence!)", french=" (Je...[K] Dois-je aider [CS:Y]Massko[CR]?)", german=" (Vielleicht...[K] die von...[K] [CS:Y]Reptain[CR]?)", italian="(Allora...[K] l'esistenza di...[K]\n[CS:Y]Grovyle[CR]!)", spanish=" (Entonces...[K] La vida...[K] de [CS:Y]Grovyle[CR]...)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" (Only...[K]it's too late now!)", french=" (Hélas...[K] il est trop tard!)", german="(Nur...[K] Dafür ist es\njetzt zu spät!)", italian=" (Però...[K] è troppo tardi ormai!)", spanish=" (Pero...[K] ¡ya es demasiado tarde!)"})
  -- message_KeyWait
  -- SetAnimation(50) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" AAaaaaaaaaaahooooooooohhhh!", french=" AAaaaaaaaaaah!", german=" AAaaaaaaaaaahoooooooooh!", italian=" AAAaaaaaaaaaahooooooooohhhh!", spanish=" ¡¡Aaaaaaaaaaah!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- SetAnimation(51) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" M-Master [CS:N]Dusknoir[CR]...", french=" M-Maître [CS:N]Noctunoir[CR]...", german=" M-meister [CS:N]Zwirrfinst[CR]...", italian=" M-Maestro [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ahhhhoooh...[K] [CS:N]Sableye[CR]!", french=" Aaaaah...[K] [CS:N]Ténéfix[CR]!", german=" Aaahoooh...[K] [CS:N]Zobiris[CR]!", italian=" Ahhhhoooh...[K] [CS:N]Sableye[CR]!", spanish=" Aaaaah...[K] ¡[CS:N]Sableye[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, hero, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's the same for you!", french=" Il en va de même pour vous!", german=" Das gilt auch für euch!", italian=" Anche per voi è lo stesso!", spanish=" ¡Lo mismo ocurre con vosotros!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Haven't you ever thought of the\nfuture or a new life?", french="N'avez-vous jamais songé à\nune vie nouvelle? A l'avenir?", german="Habt ihr euch nie Gedanken über\ndie Zukunft oder einen Neuanfang gemacht?", italian="Non avete mai pensato all'idea\ndi costruire un nuovo futuro?", spanish="¿Nunca habéis pensado en el futuro\nque nos aguarda aquí?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Giving in to Primal [CS:N]Dialga[CR] and\nliving your whole life in darkness...", french="Vous soumettre à [CS:N]Dialga[CR] Primal\net passer votre vie entière prisonniers de\ncette ombre malsaine...", german="[CS:N]Schatten-Dialga[CR] zu dienen und\ndie ganze Zeit in Dunkelheit zu verbringen...", italian="Obbedire a [CS:N]Dialga[CR] Oscuro e\nvivere tutta la vostra esistenza nelle tenebre...", spanish="Al entregaros al [CS:N]Dialga Primario[CR],\nos espera una vida de oscuridad..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is that truly what you want?", french="Est-ce vraiment ce que\nvous voulez?", german=" Wollt ihr das wirklich?", italian="È davvero questo ciò che\nvolete?", spanish=" ¿Es eso lo que queréis realmente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]![K]\nWhat does your heart tell you?", french="[CS:N]Ténéfix[CR]![K]\nEcoutez votre cœur!", german="[CS:N]Zobiris[CR]![K]\nWas sagt euch euer Herz?", italian="[CS:N]Sableye[CR]![K] Ascoltate il vostro\ncuore! Che cosa vi suggerisce?", spanish="¡[CS:N]Sableye[CR]![K]\n¿Qué os dice vuestro corazón?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Your sense of self-respect...[K]\nWhere has it gone?", french="Votre amour propre...[K]\nQu'en avez-vous fait?", german="Euer eigener Stolz...[K]\nHabt ihr ihn schon aufgegeben?", italian="Il rispetto per voi stessi...[K]\nChe fine ha fatto?", spanish="Vuestro amor propio...[K]\n¿Adónde ha ido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpLeft)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh...", french="[CS:N]Ténéfix[CR]: Whé hé...", german="[CS:N]Zobiris[CR]: Wähäh...", italian="[CS:N]Sableye[CR]: Meh-eh...", spanish="[CS:N]Sableye[CR]: Je, je..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:WaitFrames(60)
  -- GAP: se_Play(11521) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(252, 216, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GYAAAAAAAaaaaaaarrrrrrooooh!", french=" Aaaaaaaaaaaaaaaargh!", german=" GYAAAAAAAaaaaaaarrrrrrooooh!", italian=" GUAAAAAAAaaaaaaaooooh!", spanish=" ¡¡¡Aaaaayy!!!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="GYAAROOOH! (Th-the electric...[K]\nThe electrical discharge is getting stronger...)", french="AAAAAARGH! (Le courant...[K]\nle courant électrique s'intensifie...)", german="GYAAROOOH! (D-die Entlad...[K]\nDie Entladungen werden stärker...)", italian="GUAAAOOOH! (L-La scarica\nelettrica...[K] è diventata più forte...)", spanish="¡¡Aaaah!! (La descarga...[K]\nLa descarga eléctrica es más fuerte...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (C-can't hold on![K]\nMy strength...)", french="... (Je ne tiendrai pas le coup![K]\nMa force...)", german="...(D-das halte ich nicht aus![K]\nMeine Kraft...)", italian="... (Non resisto![K]\nLe mie forze...)", spanish="Ah... (¡Ya no aguanto más![K]\nMis fuerzas...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(My strength...[K]is draining\naway...)", french="(Ma force...[K] me quitte\npeu à peu...)", german="(Meine Kraft...[K]\nSie schwindet dahin...)", italian=" (Sto esaurendo...[K] le mie forze...)", spanish=" (Mis fuerzas...[K] me abandonan...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" If this goes on, [CS:Y]Grovyle[CR] can't...", french="Si ça continue, [CS:Y]Massko[CR]\nne pourra...", german="Wenn das so weitergeht,\nkann [CS:Y]Reptain[CR] nicht mehr...", italian=" Se va avanti così, [CS:Y]Grovyle[CR]...", spanish="Si esto no se detiene, [CS:Y]Grovyle[CR]\nno podrá..."})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:N]Spiritomb[CR]!", french=" [CS:N]Spiritomb[CR]!", german=" [CS:N]Kryppuk[CR]!", italian=" [CS:N]Spiritomb[CR]!", spanish=" ¡[CS:N]Spiritomb[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 256, 168, Direction.Down, "NPC_MIKARUGE")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mikaruge, npc_npc_serebii, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee!", french=" HEE hee!", german=" HEEhee!", italian=" EHH-Eh!", spanish=" ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" You can't let this happen!", french=" Tu ne peux pas laisser faire ça!", german=" Das kannst du nicht zulassen!", italian="Non puoi lasciare che accada\ntutto questo!", spanish="¡No puedes quedarte ahí y permitir\nque suceda esto!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="You can move, can't you?![K]\nDo something!", french="Tu peux bouger, non?![K]\nFais quelque chose!", german="Du kannst dich bewegen,\nnicht wahr?!?[K] Unternimm etwas!", italian="Tu puoi muoverti, non è vero?![K]\nFa' qualcosa!", spanish="Tú puedes moverte, ¡¿verdad?![K]\n¡Haz algo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE-hee HEE-hee!", french=" HEE hee HEE hee!", german=" HEEhee HEEhee!", italian=" EHH-Eh EHH-Eh!", spanish=" ¡Ji, ji, ji...! ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11522) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GYAAAAAAAaaaaaaarrrrrrooooh!", french=" Aaaaaaaaaaargh!", german=" GYAAAAAAAaaaaaaarrrrrrooooh!", italian=" GUAAAAAAAaaaaaaaooooooooh!", spanish=" ¡¡¡Aaaaayy!!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11523) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="GYAaroooh! (It's no good...[K]\nMy vision...[K]is going white...)", french="Rhaaaaaa! (Ça sent le roussi...[K]\nMa vue...[K] se trouble...)", german="GYAaroooh! (Oh nein...[K]\nMir...[K] Mir wird schwarz vor Augen...)", italian="GUAaaoooh! (Brutto segno...[K]\nLa vista...[K] mi si sta offuscando...)", spanish="¡¡Aaah!! (Es inútil...[K]\nEmpiezo a verlo todo...[K] de color blanco...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (My spirit...[K]is going to\nmelt away...)", french="... (Mes souvenirs...[K] vont être\ndésintégrés...)", german="...(Mein Körper...[K] Nur noch\neine Hülle...)", italian="... (La mia coscienza...[K] sta\nper svanire...)", spanish=" Ah... (Empiezo...[K] a debilitarme...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GYAAAAAAAaaaaaaarrrrrrooooh!", french=" Rhaaaaaaaargh!", german=" GYAAAAAAAaaaaaaarrrrrrooooh!", italian=" GUAAAAAAAaaaaaaaooooooh!", spanish=" ¡¡¡Aaaay!!!"})
  -- message_Close
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]My consciousness...[K]\nMy consciousness is fading...", french="...[K] Je perds...[K] peu à peu\nconscience...", german="...[K]Mein Bewusstsein...[K]\nIch verliere das Bewusstsein...", italian=" ...[K] Sto...[K] perdendo i sensi...", spanish="Yo...[K] Noto que mi conciencia...[K]\nse apaga..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" My consciousness...[K] My spirit...", french=" Mes souvenirs...[K] Ma mémoire...", german="Mein Bewusstsein...[K]\nMein Körper...", italian="La mia coscienza...[K]\nLa mia essenza...", spanish=" Mi energía...[K] Mis fuerzas..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Finally...[K]fading...", french=" Tout...[K] s'évanouit...", german=" Letztendlich...[K] verloren...", italian=" Alla fine...[K] stanno svanendo...", spanish=" Al fin...[K] todo se acaba..."})
  -- message_KeyWait
  -- GAP: se_Play(11524) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeIn(0)
  GROUND:TeleportTo(hero, 204, 172, Direction.Down)
  GROUND:TeleportTo(npc_npc_yonowaaru_n9, 252, 228, Direction.Down)
  GROUND:TeleportTo(npc_npc_mikaruge, 284, 148, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GROUND:EntTurn(npc_npc_mikaruge, Direction.Down)
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(51) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  -- supervision_RemoveActing(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(150)
  -- GAP: se_Play(11525) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  -- bgm2_PlayFadeIn(BGM_ANOTHER_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 312, 128, Direction.Down, "NPC_YAMIRAMI3")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_yamirami, 200, 140, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 204, 252, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_yamirami3, 308, 140, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 268, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 308, 252, false, 2)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Uhhhh....uhhhh....", french=" Hmmm... Hmmm...", german=" Schnauf... schnauf...", italian=" Anfff... Anfff...", spanish=" Ah... Aaaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:N]Dusk[CR]... [K][CS:N]Dusknoir[CR]...", french=" [CS:N]Noctu[CR]... [K][CS:N]Noctunoir[CR]...", german=" [CS:N]Z-[CR][K][CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusk[CR]...[K] [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusk[CR]...[K] [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Wheh-heh-heh?!\nMaster [CS:N]Dusknoir[CR]...", french="Whé hé hé?!\nMaître [CS:N]Noctunoir[CR]...", german="Wähähäh?!?\nMeister [CS:N]Zwirrfinst[CR]...", italian="Meh-eh-eh?!\nMaestro [CS:N]Dusknoir[CR]...", spanish=" ¡¿Je, je, je?! [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Master [CS:N]Dusknoir[CR]...[K]rescued\n[CS:Y]Grovyle[CR]...", french="Maître [CS:N]Noctunoir[CR]...[K] a sauvé\n[CS:Y]Massko[CR]...", german="Meister [CS:N]Zwirrfinst[CR]...[K]\nEr hat [CS:Y]Reptain[CR] gerettet...", italian="Il maestro [CS:N]Dusknoir[CR]...[K] ha salvato\n[CS:Y]Grovyle[CR]...", spanish=" [CS:N]Dusknoir[CR]...[K] ha rescatado a [CS:Y]Grovyle[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] Gasp...", french=" ...![K] Euh...", german=" ...[K]Röchel...", italian=" ...![K] Gasp...", spanish=" ¡Ah...![K] Ay..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questo è...", spanish=" Esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]! Are you all right?!", french=" [CS:Y]Massko[CR]! Tu vas bien?!", german=" [CS:Y]Reptain[CR]! Geht es dir gut?!?", italian=" [CS:Y]Grovyle[CR]! Stai bene?!", spanish=" ¡[CS:Y]Grovyle[CR]! ¡¿Estás bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooof uhhh...[K] Barely...", french=" Ouille, euh...[K] Pas vraiment...", german="Uuuuh ooooh... Schnauf...[K]\nEs ging mir schon mal besser...", italian=" Uff, uhhh...[K] Non molto...", spanish=" Cof, cof...[K] No demasiado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]D-Dusknoir[CR]...[K] You saved me...", french=" [CS:N]N-Noctunoir[CR]...[K] Tu m'as sauvé...", german="[CS:N]Z-Zwirrfinst[CR]...[K]\nDu hast mich gerettet...", italian=" [CS:N]D-Dusknoir[CR]...[K] Mi hai salvato...", spanish=" [CS:N]Du[CR]... [CS:N]Dusknoir[CR]...[K] Me has salvado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(7434) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 15)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V19P01A) [décor sub chargé: Sub_v19p01a]
  -- back2_SetEffect(7, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m12', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(7431) — id SE NDS sans portage PMDO identifié
  SkySubScreen.Show("v19p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(15)
  -- camera2_SetPositionMark(Position<'m13', 58.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(4)
  -- camera2_SetPositionMark(Position<'m14', 97.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(90)
  GAME:WaitFrames(2) -- join WaitSe
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V19P02A) [décor sub chargé: Sub_v19p02a]
  -- camera2_SetPositionMark(Position<'m15', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  SkySubScreen.Show("v19p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P02A1_281) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!", french="GRRROOOOOO... OOOOOH!", german="GRRR-OOOOOO...OOOOOH!", italian="GRRR-OOOOOO... OOOOOH!", spanish="¡¡¡GRRRRRRRRRRRRRR!!!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(90)
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeIn(0)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 256, 136, Direction.Down, "NPC_DARK_DIARUGA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  do local p=npc_npc_dark_diaruga.Position; GROUND:MoveToPosition(npc_npc_dark_diaruga, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  SkySubScreen.Show("v19p02a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: se_Play(11526) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-16), p.Y+(-16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 256, 112, Direction.Down, "NPC_YAMIRAMI2")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-16), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(16), p.Y+(-16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(16), p.Y+(16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_mikaruge, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_mikaruge.Position; GROUND:MoveToPosition(npc_npc_mikaruge, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" EEEWAAAAH!", french=" Ouaaaaah!", german=" EEEWAAAAH!", italian=" UUUAAAAH!", spanish=" ¡Ay, ay, ay, ay!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(31) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" M-[K]Master [CS:N]Dialga[CR]!", french=" M-[K]Maître [CS:N]Dialga[CR]!", german=" M-[K]meister [CS:N]Dialga[CR]!", italian=" M-[K]Maestro [CS:N]Dialga[CR]!", spanish=" Po...[K] ¡poderoso [CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(8), false, 1) end -- Slide2PositionOffset
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() GAME:MoveCamera(252, 252, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(36) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 252, 260, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(-40), p.Y+(0), false, 2) end
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GWAH!", french=" Ouaaaaah!", german=" GWAH!", italian=" GUAH!", spanish=" ¡¡Aah!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: M-Master [CS:N]Dusknoir[CR]...", french="[CS:N]Ténéfix[CR]: M-Maître [CS:N]Noctunoir[CR]...", german="[CS:N]Zobiris[CR]: M-meister [CS:N]Zwirrfinst[CR]...", italian="[CS:N]Sableye[CR]: M-Maestro [CS:N]Dusknoir[CR]...", spanish="[CS:N]Sableye[CR]: [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRRRRRRR!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_dark_diaruga, 252, 244, false, 1)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() GAME:MoveCamera(252, 292, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.DownLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.DownRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 252, 300, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_yamirami, 196, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 312, 212, false, 2)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GWOOOOOoooohhh!", french=" Oooooooohh!", german=" GWOOOOOooooh!", italian=" GUOOOOOoooohhh!", spanish=" ¡¡Aaaaaaaaah!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, npc_npc_dark_diaruga, 4) end)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, npc_npc_dark_diaruga, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_dark_diaruga, 4) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, npc_npc_dark_diaruga, 4) end)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" M-Master [CS:N]Dusknoir[CR]...", french=" M-Maître [CS:N]Noctunoir[CR]...", german=" M-meister [CS:N]Zwirrfinst[CR]...", italian=" M-Maestro [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Master [CS:N]Dusknoir[CR]...[K]\nWe must protect him![K] Let's go!", french="Maître [CS:N]Noctunoir[CR]...[K] Nous devons\nle protéger![K]\nAllons-y!", german="Meister [CS:N]Zwirrfinst[CR]...[K]\nWir müssen ihn beschützen![K] Los geht's!", italian="Maestro [CS:N]Dusknoir[CR]...[K]\nDobbiamo proteggerlo![K] Forza!", spanish="[CS:N]Dusknoir[CR]...[K]\n¡Hemos de protegerle![K] ¡Vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_Close
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami, 228, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 280, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 228, 260, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 280, 260, false, 2)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRRR!!"})
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(11532) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_yamirami, 164, 188, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_yamirami2, 308, 180, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami3, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_yamirami3, 340, 204, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_yamirami4, 156, 284, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_yamirami5, 188, 308, false, 2) -- Slide2PositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_yamirami6, 340, 284, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A2_434) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: GYAAAAAAAaaaaaaaa!!!", french="[CS:N]Ténéfix[CR]: Aahhhhhhhhhhhhhh!", german="[CS:N]Zobiris[CR]: GYAAAAAAAaaaaaaaa!!!", italian="[CS:N]Sableye[CR]: GUAAAAAAAaaaaaaaah!!!", spanish="[CS:N]Sableye[CR]: ¡¡¡Ayyyyy!!!"})
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Y-[K]you...", french=" V-[K]vous...", german=" I-[K]ihr...", italian=" V-[K]Voi...", spanish=" Vo...[K] vosotros..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 216, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] Need to move...", french="Argh...[K] Il faut que j'arrive\nà bouger...", german=" Argh...[K] Ich muss mich bewegen...", italian=" Argh...[K] Devo alzarmi...", spanish=" Ah...[K] Tengo que moverme..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My body...[K] It won't\ndo what I tell it to...", french="Mon corps...[K] Il refuse\nde m'obéir...", german="A-aber...[K] Mein Körper\ngehorcht mir nicht mehr...", italian=" Ma il mio corpo...[K] non risponde...", spanish=" Las piernas...[K] no me responden..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_dark_diaruga, 252, 276, false, 1)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(30)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(30)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡¡GRRRRRRRRRRRRR!!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(252, 188, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(9) [anim idle native]
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEE...[K] HEE-hee HEE-hee...", french=" HEE...[K] HEE hee HEE hee...", german=" HEE...[K] HEEhee HEEhee...", italian=" EHH...[K] EHH-Eh EHH-Eh...", spanish=" Ji...[K] ¡Ji, ji, ji...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D21P41A1_61) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(22) [anim idle native]
  -- GAP: se_Play(11527) — id SE NDS sans portage PMDO identifié
  -- Slide2PositionLives<object OBJECT_D21P41A1_61> [prop décor NDS]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D21P41A1_61) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  do local p=npc_npc_mikaruge.Position; GROUND:MoveToPosition(npc_npc_mikaruge, p.X+(0), p.Y+(-88), false, 2) end
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english=" HEEEEEEEEEEEEEE-hee HEE-hee!", french=" HEEEEEEEEEEEEEE hee HEE hee!", german=" HEEEEEEEEEEEEEEhee HEEhee!", italian=" EHHHHHHHHH-Eh EHH-Eh!", spanish=" ¡¡¡Ji, ji, ji, ji...!!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" My...[K]my paralysis is gone!", french="Je...[K] je suis enfin libre\nde mes mouvements!", german="Meine...[K]\nMeine Lähmung ist vorüber!", italian=" Posso...[K] Posso muovermi!", spanish=" Ya...[K] ¡Ya no estoy paralizada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:N]Dialga[CR]!", french=" [CS:N]Dialga[CR]!", german=" [CS:N]Dialga[CR]!", italian=" [CS:N]Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetEffect EFFECT_EXCLAMATION_MARK vers ACTOR_ACTOR_NPC_JUPUTORU [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] S-stop!", french=" ...![K] Arrête!", german=" ...[K]A-aufhören!", italian=" ...![K] F-Fermati!", spanish=" ¡Detente![K] ¡Para ya!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't! [CS:N]Celebi[CR]!", french=" Non! [CS:N]Celebi[CR]!", german=" Nein, nicht! [CS:N]Celebi[CR]!", italian=" Non farlo, [CS:N]Celebi[CR]!", spanish=" ¡No lo hagas! ¡[CS:N]Celebi[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 260, 60, false) end) -- performer/caméra
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(72), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(15) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(11528) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dark_diaruga, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Waaah![K] Wh-what?!", french=" Ouaaaah![K] Qu'est-ce que...?!", german=" Waaah![K] W-was?!?", italian=" Uaaah![K] C-Cosa?!", spanish=" ¡Aaaah![K] ¡¿Qué?!"})
  -- message_Close
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  SkySubScreen.Hide(15) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(90)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P05A) [décor sub chargé: Sub_v38p05a]
  -- camera2_SetPositionMark(Position<'m41', 18.5, 15>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(7) [neutre/état moteur]
  SkySubScreen.Show("v38p05a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  -- GAP: se_Play(11529) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Wh-what's that?!", french=" Qu'est-ce qui se passe?!", german=" W-was ist das?!?", italian=" C-Che cos'è quella?!", spanish=" ¡¿Qué es eso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(38) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I remember right, that's\ncalled...[K]an aurora...", french="Si mes souvenirs sont bons...[K]\non appelle ça l'aurore...", german="Wenn ich mich recht entsinne...[K]\nMan nennt das ein Polarlicht, glaube ich...", italian="Se ricordo bene, si chiama...[K]\naurora...", spanish=" Si no recuerdo mal,[K] eso es la aurora."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11530) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(10) [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" !?", french=" !?", german=" ?!?", italian=" ?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="A wind...[K] A wind has\nstarted blowing...", french="Le vent...[K] le vent s'est mis\nà souffler...", german=" Wind...[K] Wind kommt auf...", italian="Il vento...[K] Il vento ha cominciato\na soffiare...", spanish=" Noto algo fresco...[K] ¿Una brisa?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And up in the sky, there's\nan aurora...[K] That means...", french="Et l'aurore scintille dans\nle firmament...", german="Und dann das Polarlicht am\nHimmel...[K] Das bedeutet...", italian="E nel cielo splende l'aurora...[K]\nQuesto significa che...", spanish="Y en el cielo se ven los tonos\npropios del amanecer...[K] Por tanto..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The sun...[K] The air has started\nto move...", french="Le soleil, le vent...[K]\nAutrement dit...", german="Die Sonne...[K]\nDie Luft bewegt sich wieder...", italian="Questo bagliore...[K] e l'aria\nche sento...", spanish="Va a salir el sol...[K] ¡y el aire empieza\na moverse!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The paralyzed planet...[K]has\nstarted to move again!", french="La planète...[K] Elle n'est\nplus paralysée!", german="Die Lähmung des Planeten...[K]\nSie ist vorbei. Alles bewegt sich wieder!", italian="Il pianeta paralizzato...[K] ha\nricominciato a muoversi!", spanish="El planeta...[K] ¡ha empezado a moverse\nde nuevo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 260, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="C-could it be?[K] History has\nfinally...[K]changed...", french="Est-ce possible?[K] Le cours de\nl'histoire a fini par...[K] changer...", german="K-kann es wirklich sein?[K]\nDer Verlauf der Geschichte wurde\nendlich...[K] verändert...", italian="P-Possibile?[K] La storia è\nfinalmente...[K] cambiata...", spanish="¡¿Es posible?![K] La historia al fin\nha...[K] cambiado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You did it...[K]\n[c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...", french="Vous avez réussi...[K]\n[c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...", german="Ihr habt es geschafft...[K]\n[c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...", italian="Ce l'avete fatta...[K]\n[c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...", spanish="Lo habéis conseguido...[K]\n[c_name:NPC_HERO_FIRST],[K] [c_name:NPC_PARTNER_FIRST]..."})
  -- message_Close
  -- SetAnimation(29) [anim idle native]
  -- se_FadeOut(11530, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(90) end)
  GAME:WaitFrames(15)
  -- SetAnimation(36) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(48) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GIGI...[K] GIGIGIGI...", french=" GRR...[K] GRRRRRRRR...", german=" GIGI...[K] GIGIGIGI...", italian=" GIGI...[K] GIGIGIGI...", spanish=" Guiguí...[K] Guiguiguiguí..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GI![K] GIGIGIGIGI!", french=" GRR![K] GRRRRRRRRRRRRRRR!", german=" GI![K] GIGIGIGIGI!", italian=" GI![K] GIGIGIGIGI!", spanish=" ¡Gui![K] ¡Guiguiguiguiguí!"})
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Dialga[CR]...", french=" [CS:N]Dialga[CR]...", german=" [CS:N]Dialga[CR]...", italian=" [CS:N]Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Primal [CS:N]Dialga[CR] has become\nmore ferocious!", french="[CS:N]Dialga[CR] Primal est encore\nplus féroce!", german="[CS:N]Schatten-Dialga[CR] ist noch\nwilder geworden!", italian="[CS:N]Dialga[CR] Oscuro è diventato\npiù feroce!", spanish="¡El [CS:N]Dialga Primario[CR] se ha vuelto\naún más feroz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡¡GRRRRRRRRRR!!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.DownRight)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Right)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dark_diaruga, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(11532) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D52P32A2_434 [cible sans placement SSA zone: placement non joué]
  -- SetupOutputAttributeAndAnimation<object OBJECT_D52P32A2_434> [prop décor NDS, rendu du ground]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(36) [anim idle native]
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(24), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-24), false, 2) end -- Slide2PositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" EEEEeeek!", french=" Hiiiiiii!", german=" IEEEeeek!", italian=" IIIIIIiiiiiiiiih!", spanish=" ¡¡Ayyyy!!"})
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A2_434) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(50)
  -- message_CloseEnforce
  -- GAP: se_Play(8458) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D52P32A3_456) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(90)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRRRRRRR!!"})
  GAME:WaitFrames(10)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:FadeOutBGM(160) end)
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(120)
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(252, 332, 1, false) end) -- SetPositionMark performer/caméra
  SkySubScreen.Show("v38p05a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  -- GAP: se_Play(11530) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(90)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru_n9, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru_n9, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru_n9, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_yamirami, 236, 292, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 264, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 284, 300, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 212, 300, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 212, 340, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 292, 340, false, 2)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownLeft)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: M-Master [CS:N]Dusknoir[CR]!", french="[CS:N]Ténéfix[CR]: M-Maître [CS:N]Noctunoir[CR]!", german="[CS:N]Zobiris[CR]: M-meister [CS:N]Zwirrfinst[CR]!", italian="[CS:N]Sableye[CR]: M-Maestro [CS:N]Dusknoir[CR]!", spanish="[CS:N]Sableye[CR]: ¡[CS:N]Dusknoir[CR]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" D-don't worry...[K] I'm fine...", french=" Rassurez-vous...[K] je vais bien...", german="K-keine Sorge...[K]\nMir geht es gut...", italian="N-Non preoccupatevi...[K]\nSto bene...", spanish=" No os preocupéis...[K] Estoy bien..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's more important to...[K]follow\nMaster [CS:N]Dialga[CR]...", french="Il vaut mieux...[K] suivre Maître\n[CS:N]Dialga[CR]...", german="Es ist jetzt wichtiger,[K]\nMeister [CS:N]Dialga[CR] zu verfolgen...", italian="È più importante...[K] inseguire\nil Maestro [CS:N]Dialga[CR]...", spanish="Es más importante seguir a...[K]\n[CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The rest of you, take care of\n[CS:Y]Grovyle[CR] and [CS:N]Celebi[CR]...", french="Vous autres, occupez-vous de\n[CS:Y]Massko[CR] et [CS:N]Celebi[CR]...", german="Ihr anderen, kümmert euch um\n[CS:Y]Reptain[CR] und [CS:N]Celebi[CR]...", italian="Il resto di voi si prenda cura\ndi [CS:Y]Grovyle[CR] e [CS:N]Celebi[CR]...", spanish="Los demás ocupaos de [CS:Y]Grovyle[CR] y\n[CS:N]Celebi[CR]..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" H-hurry...", french=" Vite...", german=" B-beeilung...", italian=" P-Presto...", spanish=" Rápido..."})
  -- message_Close
  -- SetAnimation(36) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Down)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-16), p.Y+(-100), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(10)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-100), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(7)
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(16), p.Y+(-100), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(16), p.Y+(16), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(16), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-16), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(60)
  -- se_FadeOut(11530, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 3 -- $COMPULSORY_SAVE_POINT_SIDE = 3 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
