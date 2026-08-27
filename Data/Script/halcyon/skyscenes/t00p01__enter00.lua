-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('ENTER_T00P01') [neutre/état moteur]
  if false --[[BranchDebug: build debug]] then -- if ROM: debug
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- debug_Print('ENTER_T00P01_LOCAL') [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- back_SetGround(LEVEL_T00P01) [neutre/état moteur]
  SkySceneKit.play_scene("t00p01__m01a0101", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_T00P01, 'M01A01', 1) [chaînage scène ROM]
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_START_MODE or 0) -- switch($GROUND_START_MODE) [GameVar GROUND_START_MODE]
  if __sw == 1 then
  -- @label_5 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_11 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeOut(false,  0)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 4 then
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- @switch2_30 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 2 then
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- supervision_StationCommon(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 8 or __sw == 9 then
  -- supervision_StationCommon(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 or __sw == 11 then
  -- jump @switch2_30 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  else
  GAME:WaitFrames(1) -- hold
  end
end
