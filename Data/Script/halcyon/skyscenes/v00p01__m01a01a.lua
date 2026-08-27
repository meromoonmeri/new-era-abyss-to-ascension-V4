-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P01/m01a01a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V00P01) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(210), g.ViewCenter.Y+(0), 420, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="[CS:W]Memo: WI.\nNo BG prepared.[CR]", french="[CS:W]Memo: WI.\nNo BG prepared.[CR]", german="[CS:W]Memo: WI.\nNo BG prepared.[CR]", italian="[CS:W]Memo: WI.\nNo BG prepared.[CR]", spanish="[CS:W]Memo: WI.\nNo BG prepared.[CR]"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(60)
  -- PauseEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- ResumeEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  SkySceneKit.say({english="[CS:W]Memo: Raging sea\nSide scroll[CR].", french="[CS:W]Memo: Raging sea\nSide scroll[CR].", german="[CS:W]Memo: Raging sea\nSide scroll[CR].", italian="[CS:W]Memo: Raging sea\nSide scroll[CR].", spanish="[CS:W]Memo: Raging sea\nSide scroll[CR]."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
