-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/evolve.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(177, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_P14P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GAME:FadeIn(30)
  -- switch(message_Menu(MENU_EVOLUTION_SEQUENCE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_5 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_EVOLUTION_SEQUENCE2"] or 0) -- switch(message_Menu(MENU_EVOLUTION_SEQUENCE2)) [message_Menu(MENU_EVOLUTION_SEQUENCE2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 2 then
  GAME:FadeOut(false, 30)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 3 then
  -- supervision_SpecialActing(19, 0, 0) [cadrage NDS]
  GAME:WaitFrames(120)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 4 then
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif true then -- default
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- @label_4 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).SCENARIO_SELECT_MAIN or 0) -- switch(scn($SCENARIO_SELECT)[0]) [scn($SCENARIO_SELECT)[0]: scénario sélectionné]
  if __sw == 53 then
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  end
  end
end
