-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P07A/t02a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back_SetGround(LEVEL_V03P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- back2_SetGround(S13P01B2) [décor sub chargé: Sub_s13p01b2]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- camera2_SetPositionMark(Position<'m0', 16, 13.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- supervision_Acting(22) [neutre/état moteur]
  -- @label_21 [étiquette de flux ExplorerScript]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("s13p01b2", 0, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0)
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  -- @label_15 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(2000)
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  elseif __sw == 3 then
  -- SetAnimation(2) [anim idle native]
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- SetAnimation(2) [anim idle native]
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- SetAnimation(2) [anim idle native]
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- supervision_Acting(23) [neutre/état moteur]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_Acting(24) [neutre/état moteur]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- supervision_Acting(25) [neutre/état moteur]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_Acting(21) [neutre/état moteur]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 3 then
  -- back2_SetGround(S13P01B3) [décor sub chargé: Sub_s13p01b3]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back2_SetGround(S13P01B4) [décor sub chargé: Sub_s13p01b4]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back2_SetGround(S13P01B5) [décor sub chargé: Sub_s13p01b5]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back2_SetGround(S13P01B) [décor sub chargé: Sub_s13p01b]
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
