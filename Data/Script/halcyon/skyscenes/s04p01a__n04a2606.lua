-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n04a2606.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- CallCommon CORO_DEBUG_FLAG_SETTING_KIMAWARI (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S04P01A) [décor sub chargé: Sub_s04p01a]
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  -- switch(message_Menu(MENU_STAFF_CREDITS1)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  SkySubScreen.Show("s04p01a", 5, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(5)
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(180)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(1008)
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- MovePositionMark OBJECT_S05P02B4_181 [cible sans placement SSA zone: mouvement non joué]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_STAFF_CREDITS3)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P02B4_181) [routine d'objet NDS non simulée - documenté]
  -- @label_14 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(210)
  pcall(function() SOUND:FadeOutBGM(360) end)
  SkySubScreen.Hide(180) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 180)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(90)
  -- switch(message_Menu(MENU_STAFF_CREDITS4)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_TYPE = -1 -- $SPECIAL_EPISODE_TYPE = -1 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1002 -- adventure_log = 1002 (journal NDS)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_SAVE_MENU)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(ProcessSpecial(24, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  elseif __sw == 3 then
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P02C4_182) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P02D4_183) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P02E4_184) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S05P02A4_180) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- MovePositionMark OBJECT_S05P02C4_182 [cible sans placement SSA zone: mouvement non joué]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- MovePositionMark OBJECT_S05P02D4_183 [cible sans placement SSA zone: mouvement non joué]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- MovePositionMark OBJECT_S05P02E4_184 [cible sans placement SSA zone: mouvement non joué]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- MovePositionMark OBJECT_S05P02A4_180 [cible sans placement SSA zone: mouvement non joué]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- supervision_Acting(3) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_Acting(4) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- supervision_Acting(5) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_Acting(1) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
