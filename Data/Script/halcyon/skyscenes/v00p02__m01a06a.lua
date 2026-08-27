-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a06a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(160, 116, 1, false) end)
  GAME:FadeIn(30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[0] = 3 -- dungeon_mode(0) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[2] = 2 -- dungeon_mode(2) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 1 -- dungeon_mode(3) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 0 -- dungeon_mode(4) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[5] = 0 -- dungeon_mode(5) = DMODE_CLOSED (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which function would you like to use?", french="Which function would you like to use?", german="Which function would you like to use?", italian="Which function would you like to use?", spanish="Which function would you like to use?"})
  do local __choice = SkySceneKit.ask({{english="Overall Presentation Check", french="Overall Presentation Check", german="Overall Presentation Check", italian="Overall Presentation Check", spanish="Overall Presentation Check"}, {english="Clear clouds", french="Clear clouds", german="Clear clouds", italian="Clear clouds", spanish="Clear clouds"}, {english="Presentation Test", french="Presentation Test", german="Presentation Test", italian="Presentation Test", spanish="Presentation Test"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- worldmap_SetMode(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_BlinkMark(1) [neutre/état moteur]
  -- worldmap_BlinkMark(2) [neutre/état moteur]
  -- worldmap_BlinkMark(192) [neutre/état moteur]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  -- worldmap_MoveCamera(181) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetMessagePlace(181) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- worldmap_OffMessage() [neutre/état moteur]
  -- worldmap_MoveCamera(192) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetMessagePlace(192) [neutre/état moteur]
  GAME:WaitFrames(120)
  -- worldmap_MoveCamera(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetMessagePlace(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  -- worldmap_OffMessage() [neutre/état moteur]
  -- worldmap_SetLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- worldmap_ChangeLevel(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- worldmap_SetLevel(0) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(193) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- worldmap_SetMode(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(30)
  -- worldmap_BlinkMark(2) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- worldmap_SetMark(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  -- worldmap_SetArrow(2) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  GAME:WaitFrames(60)
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  GAME:WaitFrames(30)
  -- worldmap_MoveCamera(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  -- worldmap_BlinkMark(2) [neutre/état moteur]
  -- worldmap_BlinkMark(184) [neutre/état moteur]
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- @label_3 [étiquette de flux ExplorerScript]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which Level would you like?", french="Which Level would you like?", german="Which Level would you like?", italian="Which Level would you like?", spanish="Which Level would you like?"})
  do local __choice = SkySceneKit.ask({{english="Level 2", french="Level 2", german="Level 2", italian="Level 2", spanish="Level 2"}, {english="Level 3", french="Level 3", german="Level 3", italian="Level 3", spanish="Level 3"}, {english="Level 4", french="Level 4", german="Level 4", italian="Level 4", spanish="Level 4"}, {english="Level 5", french="Level 5", german="Level 5", italian="Level 5", spanish="Level 5"}, {english="Level 6", french="Level 6", german="Level 6", italian="Level 6", spanish="Level 6"}, {english="Level 7", french="Level 7", german="Level 7", italian="Level 7", spanish="Level 7"}, {english="Level 8", french="Level 8", german="Level 8", italian="Level 8", spanish="Level 8"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_Close
  -- worldmap_ChangeLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(15) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- message_Close
  -- worldmap_ChangeLevel(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(25) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- message_Close
  -- worldmap_ChangeLevel(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(30) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- message_Close
  -- worldmap_ChangeLevel(5) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(35) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- message_Close
  -- worldmap_ChangeLevel(6) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(42) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 6 then
  -- message_Close
  -- worldmap_ChangeLevel(7) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(47) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 7 then
  -- message_Close
  -- worldmap_ChangeLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(68) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(60)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  -- message_Close
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(15) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(15) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  GAME:WaitFrames(60)
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_BlinkMark(15) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- worldmap_SetMark(15) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
