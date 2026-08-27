-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S08P01A/quiz01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V04P03A) [décor sub chargé: Sub_v04p03a]
  -- back_SetGround(LEVEL_S08P01A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(128, 84, 1, false) end)
  -- camera2_SetPositionMark(Position<'m1', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  if (SkyProg.cmp(5, 2) == 0) or (SkyProg.cmp(7, 5) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [5, 2] || scn($SCENARIO_MAIN) == [7, 
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- @label_1 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_GUILD_MINI_GAME_START)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision2_SpecialActing(15, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Show("v04p03a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GUILD_MINI_GAME_FLAG_CHECK"] or 0) -- switch(message_Menu(MENU_GUILD_MINI_GAME_FLAG_CHECK)) [message_Menu(MENU_GUILD_MINI_GAME_FLAG_CHECK): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 0 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 0 -- $EVENT_LOCAL = 0 (ROM)
  -- @label_10 [étiquette de flux ExplorerScript]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- switch(message_Menu(MENU_GUILD_MINI_GAME_END)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  do local __sw = ((SV.SkyVars or {}).SCENARIO_SELECT_MAIN or 0) -- switch(scn($SCENARIO_SELECT)[0]) [scn($SCENARIO_SELECT)[0]: scénario sélectionné]
  if __sw == 53 then
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  end
  end
  elseif __sw == 1 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 3 -- $EVENT_LOCAL = 3 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 4 -- $EVENT_LOCAL = 4 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 5 -- $EVENT_LOCAL = 5 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 6 -- $EVENT_LOCAL = 6 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 7 -- $EVENT_LOCAL = 7 (ROM)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 0 -- $EVENT_LOCAL = 0 (ROM)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
