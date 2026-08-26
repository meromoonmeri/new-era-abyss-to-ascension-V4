-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m13d0712.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(I...[K]I know this place!)", french="(Je...[K] je connais cet endroit!)", german="(Ich...[K] Ich kenne diesen Ort!)", italian="(Io...[K] sono già stata qui!)", spanish="(Yo...[K] ¡conozco este lugar!)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
