-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m14a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" Now!", french=" Maintenant!", german=" Jetzt!", italian=" Via!", spanish=" ¡Ahora!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(hero, 248, 180, false, 2)
  GROUND:MoveToPosition(partner, 216, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 248, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 216, 148, false, 2)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7169) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(74) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(74) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(7169, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(21, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
