-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D07P11A/m08a1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  -- back_SetGround(LEVEL_D07P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D07P11A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 176, 208, Direction.Left, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" It's not far now.", french=" On y est presque.", german=" Es ist nicht mehr weit.", italian=" Non è molto lontano.", spanish=" Ya queda poco."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="If we cross this mountain, we'll\nreach the base camp.", french="Il ne nous reste plus qu'à\ntraverser cette montagne pour arriver\nau camp de base.", german="Das Basislager liegt gleich hinter\ndiesem Berg.", italian="Dobbiamo solo superare questa\nmontagna per raggiungere il Campo Base.", spanish="Si cruzamos esta montaña\nllegaremos al campamento base."}) -- SwitchTalk: branche default (canon générique)
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Whoops... That was my belly\ngrowling.", french="Oups... c'est mon estomac qui\ngargouille.", german=" Huch! Mein Magen hat geknurrt.", italian="Ooops... Era il mio stomaco\nche si lamentava.", spanish=" Vaya, me ha rugido el estómago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  SkySceneKit.say({english=" Ha ha ha! Us too!", french=" Ha ha ha! Nous aussi!", german=" Hahaha! Unserer auch!", italian=" Ah ah ah! Anche il nostro!", spanish=" ¡Ja, ja, ja! ¡El nuestro también!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  SkySceneKit.say({english="Do you want to call it a day?[K]\nWe can rest here tonight.", french="On en a assez fait pour\naujourd'hui...[K] On devrait se reposer ici\ncette nuit.", german="Sollen wir für heute Schluss\nmachen?[K] Wir können hier übernachten.", italian="Volete fermarvi per oggi?[K]\nPossiamo trascorrere la notte qui.", spanish="¿Y si lo dejamos por hoy?[K]\nPodemos pasar la noche aquí antes de seguir."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I agree completely!", french=" J'suis bien d'accord, tiens!", german=" Ich stimme voll und ganz zu!", italian=" Sono completamente d'accordo!", spanish=" ¡Estoy plenamente de acuerdo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" Then let's eat!", french=" On mange!", german=" Dann lasst uns essen!", italian=" Allora mangiamo!", spanish=" Entonces, ¡a comer!"}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yeeeehaw!", french=" Youhouuuuuu!", german=" Juuuuchhuuuu!", italian=" Evviva!", spanish=" ¡Bieeeen!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(120)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="All right, gang. We have to\nget moving.", french="Allez, les amis. Il faut qu'on\nparte.", german="Okay, Leute. Wir müssen uns\nauf den Weg machen.", italian="Va bene, squadra. È ora di\npartire.", spanish="De acuerdo, equipo. Hay que\nponerse en marcha."}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(npc_npc_bippa, 280, 204, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 328, 212, false, 2)
  GAME:WaitFrames(40)
  GROUND:MoveToPosition(hero, 312, 196, false, 2)
  pcall(function() GAME:MoveCamera(304, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 328, 156, false, 2)
  GROUND:MoveToPosition(partner, 360, 180, false, 2)
  pcall(function() GAME:MoveCamera(344, 164, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 328, 180, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Crossing this mountain's going\nto take us to the base camp. Yup yup!", french="On traverse c'te montagne et\non est au camp d'base. Ouaip ouaip!", german="Über diesen Berg kommen wir\nzum Basislager. Jawollja!", italian="Oltrepassata la montagna,\narriveremo al Campo Base. Già, già!", spanish="Al cruzar esta montaña,\nllegaremos al campamento base.\n¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Let's get it done!", french=" Allons-y!", german=" Packen wir es an!", italian=" Forza!", spanish=" ¡A por ello!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
