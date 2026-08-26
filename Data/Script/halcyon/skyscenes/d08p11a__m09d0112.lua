-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09d0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Hm? What's wrong,\n[hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german="Hm? Stimmt was nicht,\n[hero]?", italian="Eh? Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué te ocurre, [hero]?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Wait a second! I know this place!)", french="(C'est ça! Je connais cet endroit!)", german="(Moment mal! Ich kenne diesen Ort!)", italian="(Un secondo! Questo posto lo conosco!)", spanish="(¡Un momento! ¡Yo conozco este sitio!)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
end
