-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P05A/t02a0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-100), 1, false) end) -- SetPositionOffset caméra
  pcall(function() GAME:MoveCamera(156, 380, 60, false) end) -- performer/caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-70), 1, false) end) -- back_SetBackScrollOffset px NDS (pilote scroll)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(83), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(0.6992,0.0) px/frame -> caméra continue (pilote scroll)
  -- SetPositionOffset<object OBJECT_S13P05A1_367> [prop décor NDS]
  -- MovePositionMark OBJECT_S13P05A1_367 [cible sans placement SSA zone: mouvement non joué]
  -- SetAnimation(17) [anim idle native]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  -- SetAnimation(17) [anim idle native]
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(25)
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
