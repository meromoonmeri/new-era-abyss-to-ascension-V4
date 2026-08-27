-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P02A/t02a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- switch(ProcessSpecial(23, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S13P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(177, 296, 1, false) end) -- SetPosition performer/caméra (immédiat)
  -- GAP: BGM BGM_POKEMON_EXPLORATION_TEAM_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(15)
  GAME:WaitFrames(15)
  SkySubScreen.Hide(15) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(15)
  -- screen2_FadeIn(0, 15) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:WaitFrames(25)
  -- MovePosition 0 [cible sans placement SSA zone: déplacement non joué]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(52)
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(150)
  GAME:WaitFrames(110)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
