-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P31A/m05d0612.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="Can you give it a try,\n[hero]?", french="Tu veux essayer,\n[hero]?", german="Kannst du es mal versuchen,\n[hero]?", italian="Vuoi provare tu,\n[hero]?", spanish="¿Por qué no pruebas tú,\n[hero]?"}) -- SwitchTalk: branche default (canon générique)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 252, 164, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
