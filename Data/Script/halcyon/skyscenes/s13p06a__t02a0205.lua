-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S13P06A/t02a0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back2_SetGround(S13P01A2) [décor sub chargé: Sub_s13p01a2]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_S13P06A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(4.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(0) [neutre/état moteur]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- supervision_Acting(2) [neutre/état moteur]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- back_SetEffect(12, 0) [transition couches décor NDS immédiate]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("s13p01a2", 10, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(10)
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(67)
  GAME:WaitFrames(24)
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- @label_14 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(10) -- back_SetEffect(11, 10) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(88)
  GAME:WaitFrames(32)
  GAME:WaitFrames(106)
  GAME:WaitFrames(12)
  GAME:FadeOut(false, 30)
  elseif __sw == 3 then
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- supervision_Acting(3) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_Acting(4) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- supervision_Acting(5) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_Acting(1) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- back2_SetGround(S13P01A3) [décor sub chargé: Sub_s13p01a3]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back2_SetGround(S13P01A4) [décor sub chargé: Sub_s13p01a4]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back2_SetGround(S13P01A5) [décor sub chargé: Sub_s13p01a5]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back2_SetGround(S13P01A) [décor sub chargé: Sub_s13p01a]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
