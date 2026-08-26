-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="(...![K] Huh?)", french="(...![K] Hein?)", german="(Äh?)", italian="(...![K] Eh?)", spanish="(¿Cómo?[K] ¿Eh?)"}) -- SwitchMonologue: branche default
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="([partner] isn't here...)", french="([partner] n'est pas là...)", german="([partner] ist nicht hier...)", italian="([partner] non è qui...)", spanish="([partner] no está aquí...)"}) -- SwitchMonologue: branche default
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(Maybe outside...?)", french="(Peut-être dehors...?)", german="(Vielleicht draußen?)", italian="(Che sia fuori...?)", spanish="(Quizás está afuera...)"}) -- SwitchMonologue: branche default
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
