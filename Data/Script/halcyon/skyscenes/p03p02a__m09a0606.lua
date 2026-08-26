-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P02A/m09a0606.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P03P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- bgm2_PlayFadeIn(BGM_RAIN2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  SkySubScreen.Show("v24p08a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 424, 544, Direction.Down, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! The fog is gone!", french="Eh dis donc! Le brouillard\na disparu!", german=" Hey, hey! Der Nebel ist weg!", italian=" Ehi, ehi! La nebbia è sparita!", spanish="¡Oye, oye! ¡La niebla ha\ndesaparecido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" The sunlight's harsh!", french=" Le soleil brille fort!", german=" Das Sonnenlicht blendet richtig!", italian=" La luce del sole è abbagliante!", spanish=" El sol brilla con fuerza."}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(73) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  SkySceneKit.say({english=" Hey! Look!", french=" Hé! Regardez!", german=" Hey! Sieh nur!", italian=" Ehi! Guardate!", spanish=" ¡Vaya! ¡Mirad!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" B-both of you![K] Up! Look up!", french="Vous deux![K] En l'air! Regardez\nen l'air!", german=" I-ihr beide![K] Da oben! Seht!", italian="Voi due![K] In alto!\nGuardate in alto!", spanish=" ¡Los dos![K] ¡Mirad allí arriba!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! What is that?!", french="Eh dis donc! Qu'est-ce que\nc'est?!", german=" Hey, hey! Was ist das?!?", italian=" Ehi, ehi! Cos'è?!", spanish=" ¡Oye, oye! ¡¿Qué es eso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(15)
  SkySceneKit.say({english="We were just wandering around\nin circles ourselves.", french="Même nous, nous avons tourné\nen rond pendant pas mal de temps.", german="Wir sind selbst gerade die ganze\nZeit im Kreis gelaufen.", italian="Anche noi ci stavamo\ngirando attorno.", spanish="No hemos hecho otra cosa que\nandar en círculo."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! So you're saying...", french="Eh dis donc! Tu es en train\nde nous dire...", german=" Hey, hey! Du meinst also...", italian=" Ehi, ehi! Quindi stai dicendo...", spanish=" ¡Oye, oye! ¿Quieres decir que...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You're saying [CS:P]Fogbound Lake[CR] is\nup there? Hey, hey, hey?!", french="... que le [CS:P]Lac des Brumes[CR]\nest là-haut? Dis donc!", german="Du meinst, dass der [CS:P]Nebelsee[CR]\nda oben ist? Hey, hey, hey?!?", italian="Stai dicendo che quello lassù\nè il [CS:P]Lago Foschia[CR]?\nEhi, ehi, ehi?!", spanish="¿Estás diciendo que el [CS:P]Lago[CR]\n[CS:P]Velado[CR] está allí arriba?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="[CS:P]Fogbound Lake[CR] has to be\nup there!", french="Le [CS:P]Lac des Brumes[CR] doit être\nlà-haut!", german=" Der [CS:P]Nebelsee[CR] muss da oben sein!", italian="Il [CS:P]Lago Foschia[CR] dev'essere\nlassù!", spanish="¡El [CS:P]Lago Velado[CR] tiene que estar\nallí arriba!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-180), 51, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(20)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
