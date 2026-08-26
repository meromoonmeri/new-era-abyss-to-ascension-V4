-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s31a3707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next day...", french="[CN]Le jour suivant...", german="[CN]Am nächsten Tag...", italian="[CN]Il giorno dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" It's late, [hero]!", french=" Il se fait tard, [hero]!", german=" Es ist an der Zeit, [hero]!", italian=" È tardi, [hero]!", spanish=" ¡Mira qué horas, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="I won't be able to forget\neveryone's smiling faces!", french="Mais je n'oublierai pas la mine\nréjouie des invités!", german="Aber die vielen lächelnden\nGesichter bleiben unvergesslich!", italian="... ma non dimenticherò mai\nil sorriso stampato sul volto di chi ci\nascoltava!", spanish="¡Nunca me olvidaré de la sonrisa\nque todos tenían en la cara!"}) -- SwitchTalk: branche default (canon générique)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
