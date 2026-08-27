-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S99P03A/sale_s01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- screen2_WhiteOut [sub déjà caché]
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:FadeIn(0)
  -- back2_SetMode(8) [mode d'affichage sub NDS: géré par SubScreen]
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_S99P03A2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  SkySceneKit.unlock(4) -- Unlock(4) NDS
  -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_INIT, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_KEY_WAIT_PRESS"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_PRESS, 0, ) [ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_PRESS): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_5 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false,  30)
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- back_SetGround(LEVEL_S99P01A2) [neutre/état moteur]
  -- @label_10 [étiquette de flux ExplorerScript]
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  SkySceneKit.unlock(4) -- Unlock(4) NDS
  -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_INIT, 3600, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_KEY_WAIT_PRESS"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_PRESS, 0, ) [ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_PRESS): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_11 [étiquette de flux ExplorerScript]
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:WaitFrames(60)
  elseif true then -- default
  -- GAP: se_Play(16130) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(128, 300, 1, false) end) -- SetPositionMark performer/caméra
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- back_SetGround(LEVEL_S99P01A3) [neutre/état moteur]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back_SetGround(LEVEL_S99P01A4) [neutre/état moteur]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back_SetGround(LEVEL_S99P01A5) [neutre/état moteur]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back_SetGround(LEVEL_S99P01A) [neutre/état moteur]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- GAP: se_Play(16130) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(132, 300, 1, false) end) -- SetPositionMark performer/caméra
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 3 then
  -- back_SetGround(LEVEL_S99P03A3) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back_SetGround(LEVEL_S99P03A4) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back_SetGround(LEVEL_S99P03A5) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back_SetGround(LEVEL_S99P03A) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
