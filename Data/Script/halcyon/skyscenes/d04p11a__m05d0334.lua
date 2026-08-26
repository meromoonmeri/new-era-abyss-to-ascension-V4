-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05d0334.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" Be brave...[K] Use all your courage!", french=" Il faut que...[K] je sois courageuse!", german="Sei tapfer...[K] Nimm all deinen\nMumm zusammen!", italian="Sii coraggiosa...[K] Sii la più\ncoraggiosa di tutti!", spanish="Debo ser valiente...[K]\n¡Tengo que echarle coraje!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
