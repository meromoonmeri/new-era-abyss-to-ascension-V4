-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/n08a2608.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 280, 320, Direction.Down, "NPC_YONOWAARU_N8")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOutAll
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(32), 13, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 248, 328, Direction.UpRight, "NPC_YAMIRAMI4")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 280, 336, Direction.Up, "NPC_YAMIRAMI5")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 312, 328, Direction.UpLeft, "NPC_YAMIRAMI6")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpRight)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-24), p.Y+(32), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(24), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 184, 296, Direction.DownRight, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Gwah!", french=" Aaah!", german=" Gwah!", italian=" Guaaah!", spanish=" ¡Ah!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 272, Direction.Down, "NPC_YAMIRAMI2")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 376, 296, Direction.DownLeft, "NPC_YAMIRAMI3")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Wheh-heh-heh...[K]\nEeee...[K]eeeeeeeek!", french="Whé hé hé...[K]\nHiii...[K] hiiiiii!", german="Wähähäh...[K]\nIeee...[K]ieeeeeeek!", italian="Meh-eh-eh...[K]\nIiiiii[K]iiiiiiiiiiiiiiih!", spanish="Je, je, je...[K]\nAy...[K] ¡Ayyyy!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(2)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-80), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(80), p.Y+(0), false, 2) end
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(16), p.Y+(40), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(120), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-16), p.Y+(40), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(120), false, 2) end -- waypoint MovePositionOffset
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Wait!", french=" Attends!", german=" Hiergeblieben!", italian=" Fermo!", spanish=" ¡Un momento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(44), 44, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(32), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(36), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- SetAnimation(11) [anim idle native]
  -- GAP: se_Play(7943) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Ooogh...", french=" Bou hou hou...", german=" Uuuff...", italian=" Oooh...", spanish=" ¡Aaarg!..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Ugh...[K] You're squishing me...", french=" Argh...[K] Vous m'écrasez...", german=" Aua...[K] Du tust mir weh...", italian=" Urgh...[K] Aiuto...", spanish=" Ay...[K] Deja de estrujarme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 316, 392, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Tell us!", french=" Parle!", german=" Nun sag schon!", italian=" Parla!", spanish=" ¡Dínoslo todo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What happened to [CS:N]Celebi[CR]?!", french=" Qu'est-il arrivé à [CS:N]Celebi[CR]?!", german=" Was ist mit [CS:N]Celebi[CR] passiert?!?", italian=" Cos'è successo a [CS:N]Celebi[CR]?!", spanish=" ¡¿Qué ha pasado con [CS:N]Celebi[CR]?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Where's [CS:N]Dialga[CR]?!", french=" Où est [CS:N]Dialga[CR]?!", german=" Wo ist [CS:N]Dialga[CR]?!?", italian=" Dov'è [CS:N]Dialga[CR]?!", spanish=" ¡¿Dónde está [CS:N]Dialga[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Ugh...[K] M...[K]Master [CS:N]Dialga[CR]...[K]\nRan off in pursuit of [CS:N]Celebi[CR]...", french="Argh...[K] M...[K] Maître [CS:N]Dialga[CR]...[K]\ns'est lancé à la poursuite de [CS:N]Celebi[CR]...", german="Urks...[K] M-[K]meister [CS:N]Dialga[CR]...[K]\nhat [CS:N]Celebi[CR] in hohem Tempo verfolgt...", italian="Urgh...[K] I-Il...[K] Maestro [CS:N]Dialga[CR]...[K]\nè partito alla ricerca di [CS:N]Celebi[CR]...", spanish="Ay...[K] Esto...[K] [CS:N]Dialga[CR]...[K]\nsalió en persecución de [CS:N]Celebi[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" T-to...[K][CS:P]Frozen Island[CR]...", french=" Il est parti pour...[K] l'[CS:P]Ile de Glace[CR].", german=" Z-zur...[K] [CS:P]Frostinsel[CR]...", italian=" S-[K]Sull'[CS:P]Isola Glaciale[CR]...", spanish=" Hacia la...[K] [CS:P]Isla Helada[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:P]Frozen Island[CR]?", french=" L'[CS:P]Ile de Glace[CR]?", german=" [CS:P]Frostinsel[CR]?", italian=" [CS:P]Isola Glaciale[CR]?", spanish=" ¿La [CS:P]Isla Helada[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That solitary island to the\nsouth of here!?", french="Cette petite île désolée,\nau sud d'ici?!", german="Die abgelegene Insel\nim Süden?!?", italian="Quell'isola sperduta a sud\ndi dove ci troviamo adesso?!", spanish="¡¿Esa isla solitaria que está\nal sur de aquí?!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Is that right?!", french=" En es-tu sûr?!", german=" Ist das wahr?!?", italian=" È così?!", spanish=" ¡¿Es cierto eso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Y...[K]yeah![K] That's right...", french=" Euh...[K] oui![K] Sûr et certain...", german=" J-[K]ja![K] Das ist die Wahrheit...", italian=" S-[K]Sì![K] Esatto...", spanish=" Sí...[K] ¡Así es![K] Han ido allí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(40) [anim idle native]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(15)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(42), false, 2) end -- Slide2PositionOffset
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(27) [anim idle native]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.DownLeft)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Gwah!", french=" Aaah!", german=" Gwah!", italian=" Guaaah!", spanish=" ¡Aaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Ooogh...[K] Ahem...", french=" Ouille...[K] Hum...", german=" Ouuuff...[K] Ähem...", italian=" Oooh...[K] Ehm...", spanish=" Ay...[K] Ejem..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Down)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Beat it!", french=" Déguerpis!", german=" Jetzt verschwinde!", italian=" Sparisci!", spanish=" ¡Lárgate!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Eeee...[K]eeeeeek!", french=" Hiii...[K] hiiiiii!", german=" Ieee...[K]ieeeeek!", italian=" Iiiiii[K]iiiiiiiiih!", spanish=" Ay...[K] ¡Ayyy!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(120), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(150)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n8, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n8, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:P]Frozen Island[CR]...[K]\nIs it a different land?", french="L'[CS:P]Ile de Glace[CR]...[K]\nElle se situe sur un autre continent?", german="[CS:P]Frostinsel[CR]...[K]\nIst das nicht ein anderes Land?", italian="[CS:P]Isola Glaciale[CR]...[K] Non si trova\nin un altro luogo?", spanish="La [CS:P]Isla Helada[CR]...[K]\n¿Eso está más allá del mar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That's right.[K] We'll have to\nmove across space.", french="Oui, certes.[K] Il nous faudra\nvoyager à travers l'espace.", german="Ganz genau.[K] Dafür müssen wir\ndas Raumgefüge durchqueren.", italian="Infatti.[K] Dovremo viaggiare\nin un'altra dimensione.", spanish="Exacto.[K] Tendremos que movernos\npor el espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" How do we do that?", french="Et comment comptes-tu t'y\nprendre?", german=" Und wie stellen wir das an?", italian=" E come facciamo?", spanish=" ¿Y eso cómo lo haremos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Don't worry.", french=" Ne t'inquiète pas.", german=" Keine Sorge.", italian=" Non preoccuparti.", spanish=" No te preocupes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we follow the cliff\nsouth from here...", french="Si nous suivons la falaise\nvers le sud...", german="Wenn wir den Klippen von hier\naus nach Süden folgen...", italian=" Se seguiamo la scogliera a sud...", spanish="Si seguimos el barranco que está\nal sur de aquí..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The [CS:N]Porygon[CR] there will send\nus across space.", french="... nous trouverons des [CS:N]Porygon[CR]\ncapables de nous aider à traverser l'espace.", german="Dann werden uns die [CS:N]Porygon[CR]\nhelfen, das Raumgefüge zu durchqueren.", italian="... arriveremo nel luogo dove\nvivono i [CS:N]Porygon[CR]. Grazie a loro potremo\nraggiungere l'isola.", spanish="Allí los [CS:N]Porygon[CR] nos enviarán\na través del espacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Let's go.", french=" Partons.", german=" Also los.", italian=" Andiamo.", spanish=" Vamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(32), 64, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(64), false, 2) end
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(41) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What is it?", french=" Que se passe-t-il?", german=" Was ist los?", italian=" Che succede?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_ON_THE_CEILING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Oh, it's nothing...", french=" Oh, ce n'est rien...", german=" Ach, gar nichts...", italian=" Oh, non è nulla...", spanish=" Oh, no es nada..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's just...[K]my arms...", french=" Seulement...[K] mes bras...", german=" Es sind nur...[K] Meine Arme...", italian=" È solo che...[K] le mie braccia...", spanish=" Es solo que...[K] mis brazos..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I feel like I've regained the\nstrength in my arms.", french="Je sens qu'ils retrouvent\nleurs forces.", german="Es fühlt sich so an, als hätten\nmeine Arme ihre Kraft endlich wiedererlangt.", italian="Mi sembra di aver recuperato\nla forza nelle braccia.", spanish="Noto que he recuperado la fuerza\nen los brazos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! (Now that you mention it...)", french=" ...! (Maintenant qu'il le dit...)", german=" ...(Jetzt, wo du es erwähnst...)", italian=" ...! (Ora che ci penso...)", spanish=" ¡Vaya! (Ahora que lo dices...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Earlier, when he was pushing\naround the [CS:N]Sableye[CR], that incredible power...)", french="(Tout à l'heure, quand il\nmalmenait ce [CS:N]Ténéfix[CR], un pouvoir\nincroyable...)", german="(Vorhin, als er [CS:N]Zobiris[CR]\nim Schwitzkasten hatte... Die schiere Kraft...)", italian="(Quando prima ha afferrato\nil [CS:N]Sableye[CR], quell'incredibile potere...)", spanish="(Antes, cuando zarandeaba al\n[CS:N]Sableye[CR], esa increíble fuerza...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (There's no mistaking it...)", french=" (Impossible de s'y tromper...)", german=" (Es kann nicht anders sein...)", italian=" (Non c'è dubbio...)", spanish=" (Está claro...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="([CS:N]Dusknoir[CR]'s power is growing\nstronger than ever before...)", french="([CS:N]Noctunoir[CR] devient plus fort\nque jamais...)", german="(Die Kraft von [CS:N]Zwirrfinst[CR] ist\ngrößer als je zuvor...)", italian="(Il potere di [CS:N]Dusknoir[CR]\nsta crescendo come mai prima d'ora...)", spanish="([CS:N]Dusknoir[CR] se ha vuelto mucho\nmás fuerte que antes...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(I wonder if his wounds have\nsignificantly healed...)", french="(Ses blessures doivent être\ncomplètement guéries...)", german="(Ob seine Verletzungen wohl\nschon geheilt sind...)", italian="(Chissà se è già guarito dalle\nferite che aveva riportato...)", spanish="(Me pregunto si ya se habrá\nrecuperado del todo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(7)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Heh-heh-heh... My strength...[K]\nMy strength is returning...", french="Hé hé hé... Ma force...[K]\nElle est de retour...", german="Hehehe... Meine Kraft...[K]\nMeine Kraft kehrt zurück...", italian="Eh-eh-eh... La mia forza...[K]\nSto recuperando la mia forza...", spanish="Ja, ja, ja... Mi fuerza...[K]\n¡Estoy recuperándola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" ...........", german=" .........", italian=" ...........", spanish=" ..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
