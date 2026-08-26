-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02B) [décor sub chargé: Sub_v21p02b]
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_ChangeVolume(140, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("v21p02b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  SkySceneKit.say({english=" ...[K]I'm...[K]ashamed.", french=" ...[K] J'ai...[K] honte.", german=" ...[K]Ich...[K] schäme mich.", italian=" ...[K] Mi...[K] vergogno.", spanish=" Yo...[K] Me...[K] Me avergüenzo."}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(partner, 176, 148, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  SkySceneKit.say({english=" I won't give up, either!", french="... moi non plus, je\nn'abandonnerai pas!", german=" Dann gebe ich auch nicht auf!", italian=" ... non lo farò neanche io!", spanish=" ¡Yo tampoco!"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"}) -- SwitchMonologue: branche default
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  SkySceneKit.say({english="There has to be a way of fixing\nthings without us having to disappear!", french="Il y a sûrement une façon de\nrégler le problème sans que nous\ndisparaissions!", german="Es muss einen Weg geben, wie\nwir die Dinge richten können, ohne dass wir\nverschwinden müssen!", italian="Ci deve essere un modo per\nsistemare le cose, senza che noi scompariamo!", spanish="¡Debe de haber una forma de\narreglarlo todo sin que tengamos que\ndesaparecer!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(That's the [partner] I know!)", french="(C'est bien [partner]!)", german="(So kenne ich dich, [partner]!)", italian="(Adesso ti riconosco, [partner]!)", spanish="(¡Así se habla, [partner]!)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  SkySceneKit.say({english=" Let's find a way out of this!", french="On doit trouver un moyen de\ns'en sortir!", german=" Lass uns einen Ausweg finden!", italian=" Troviamo una soluzione!", spanish=" ¡Busquemos una solución!"}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
