-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P11A/m16a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D16P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 316, 140, false, 2)
  GROUND:MoveToPosition(partner, 284, 140, false, 2)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="I got so curious, I couldn't help\ncoming out here, but...", french="C'est la curiosité qui m'a\npoussée à venir ici, mais...", german="Ich war so neugierig, dass ich\neinfach herkommen musste, aber...", italian="Anch'io sono curiosa. Volevo\ndavvero venire a dare un'occhiata, però...", spanish="Sentía tanta curiosidad que\nhe tenido que venir aquí, pero..."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="We have to stay out of this.\nLet's go back.", french="Mieux vaut ne pas s'en mêler.\nFaisons demi-tour.", german="Wir müssen uns raushalten.\nLass uns zurückgehen.", italian="È meglio se non c'immischiamo.\nTorniamo indietro.", spanish="Tenemos que alejarnos de aquí.\nDemos la vuelta."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GROUND:MoveToPosition(partner, 284, 252, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 252, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_SetGround(LEVEL_D16P11A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
