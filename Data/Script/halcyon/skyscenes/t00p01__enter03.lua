-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Which one will you enter?", french="Which one will you enter?", german="Which one will you enter?", italian="Which one will you enter?", spanish="Which one will you enter?"})
  do local __choice = SkySceneKit.ask({{english="Dojo 1", french="Dojo 1", german="Dojo 1", italian="Dojo 1", spanish="Dojo 1"}, {english="Dojo 2", french="Dojo 2", german="Dojo 2", italian="Dojo 2", spanish="Dojo 2"}, {english="Boss Stage", french="Boss Stage", german="Boss Stage", italian="Boss Stage", spanish="Boss Stage"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[180] = 3 -- dungeon_mode(180) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[181] = 3 -- dungeon_mode(181) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[182] = 3 -- dungeon_mode(182) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[183] = 3 -- dungeon_mode(183) = DMODE_OPEN_AND_REQUEST (ROM)
  do local __sw = 0 -- switch(main_EnterTraining(-1, 30)) [main_EnterTraining(-1, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 1 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif true then -- default
  -- switch(main_EnterTraining(251, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __choice == 2 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[196] = 3 -- dungeon_mode(196) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[197] = 3 -- dungeon_mode(197) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[198] = 3 -- dungeon_mode(198) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[199] = 3 -- dungeon_mode(199) = DMODE_OPEN_AND_REQUEST (ROM)
  do local __sw = 0 -- switch(main_EnterTraining2(-1, 30)) [main_EnterTraining2(-1, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 1 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- switch(main_EnterTraining2(251, 30)) corps vide [main_EnterTraining2(251, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  GAME:WaitFrames(1) -- hold
  end
  end
  elseif __choice == 3 then
  pcall(function() SOUND:PlayBGM("Boss Battle.ogg", true) end)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- main_EnterDungeon(2, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
