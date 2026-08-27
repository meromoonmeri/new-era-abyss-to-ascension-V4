-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P03A/t02a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(6) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-14400), g.ViewCenter.Y+(-720), 120, false) end) -- back_SetBackScrollSpeed(-120.0,-6.0) px/frame -> caméra continue (pilote scroll)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(15)
  pcall(function() GAME:MoveCamera(148, 380, 60, false) end) -- performer/caméra
  GAME:WaitFrames(127)
  -- Move2PositionOffset<object OBJECT_S13P03A1_355> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(86)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
