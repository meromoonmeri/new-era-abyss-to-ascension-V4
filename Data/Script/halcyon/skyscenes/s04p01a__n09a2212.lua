-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n09a2212.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P06D) [décor sub chargé: Sub_v38p06d]
  -- back_SetGround(LEVEL_V38P06C) [neutre/état moteur]
  -- GAP: BGM BGM_LIFE_GOES_ON_ENDING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_SetWaitMode(210, 90) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_HERO_FIRST]! [K][c_name:NPC_PARTNER_FIRST]![K]\n[CN]Can you hear me?!", french="[CN][c_name:NPC_HERO_FIRST]! [K][c_name:NPC_PARTNER_FIRST]![K]\n[CN]Vous m'entendez?!", german="[CN][c_name:NPC_HERO_FIRST]![K] [c_name:NPC_PARTNER_FIRST]![K]\n[CN]Könnt ihr mich hören?", italian="[CN][c_name:NPC_HERO_FIRST]![K] [c_name:NPC_PARTNER_FIRST]![K]\n[CN]Riuscite a sentirmi?!", spanish="[CN]¡[c_name:NPC_HERO_FIRST]![K] ¡[c_name:NPC_PARTNER_FIRST]![K]\n[CN]¡¿Me oís?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We are still alive!!", french="[CN]La vie continue!", german="[CN]Das Leben geht weiter!", italian="[CN]Noi esistiamo ancora!!!", spanish="[CN]¡¡Seguimos aquí!!"})
  -- message_Close
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- switch(message_Menu(MENU_STAFF_CREDITS1)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(15)
  SkySubScreen.Show("v38p06d", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(180)
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_STAFF_CREDITS2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(message_Menu(MENU_STAFF_CREDITS3)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  pcall(function() SOUND:FadeOutBGM(210) end)
  SkySubScreen.Hide(180) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 180)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_V26P11A2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(360)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="", french="", german="", italian="", spanish=""})
  -- message_Close
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(90)
  -- switch(message_Menu(MENU_STAFF_CREDITS4)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_TYPE = -1 -- $SPECIAL_EPISODE_TYPE = -1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 0 -- $SIDE08_BOSS2ND[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.ADVENTURE_LOG = 1004 -- adventure_log = 1004 (journal NDS)
  -- switch(message_Menu(MENU_SAVE_MENU)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- switch(ProcessSpecial(24, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  elseif __sw == 3 then
  -- back_SetGround(LEVEL_V26P11A3) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back_SetGround(LEVEL_V26P11A4) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back_SetGround(LEVEL_V26P11A5) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back_SetGround(LEVEL_V26P11A) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
