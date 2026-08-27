-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if ((SV.SkyScenarioBitFlags or {})[1] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[1]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('CHOUREI') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 0 -- $SCENARIO_MAIN_BIT_FLAG[1] = 0 (ROM)
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 3 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M02_07B) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_3 [étiquette de flux ExplorerScript]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw >= 5 then
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 7 then
  -- @label_18 [étiquette de flux ExplorerScript]
  -- debug_Print('HANYOU_CHOUREI') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 8 then
  -- @label_45 [étiquette de flux ExplorerScript]
  -- supervision_ExecuteCommon(CORO_EVENT_HA_CHO_DO) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_G01P08A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- supervision_ExecuteCommon(CORO_EVENT_HA_CHO) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M03_07B) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_4 [étiquette de flux ExplorerScript]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M04_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M05_01_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_6 [étiquette de flux ExplorerScript]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M06_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_25 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- message_Close
  -- debug_Print('IRAIWOKONASU') [neutre/état moteur]
  -- supervision_ExecuteCommon(CORO_EVENT_M06_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_24 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M06_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_23 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M06_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_7 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN07_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  -- debug_Print('MAIN07_SEKAIICHI') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M07_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_27 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN07_PERAPPUNOKOGOTO') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M07_14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_28 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_MAIN07_MOUSUGUENSEI') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M07_13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_8 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN08_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  -- debug_Print('LABEL_MAIN07_MOUSUGUENSEI') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M08_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_9 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN11_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M11_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_31 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M11_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_10 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN12_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  -- @label_32 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M12_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_33 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M12_03B) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_11 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN13_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 2 then
  SkyProg.set(14, 3) -- $SCENARIO_MAIN = scn[14,3] (ROM)
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M13_05B) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_36 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M13_09) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_12 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN14_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 or __sw == 1 or __sw == 2 or __sw == 3 then
  -- @label_37 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M14_02B) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_38 [étiquette de flux ExplorerScript]
  SkyProg.set(16, 0) -- $SCENARIO_MAIN = scn[16,0] (ROM)
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 5 then
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- jump @label_37 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 or __sw == 3 or __sw == 4 then
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  -- jump @label_31 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 0 then
  -- jump @label_32 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 1 or __sw == 2 then
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 5 then
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).REQUEST_CLEAR_COUNT or 0) -- switch($REQUEST_CLEAR_COUNT) [GameVar REQUEST_CLEAR_COUNT (missions accomplies)]
  if __sw >= 1 then
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_25 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 4 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  -- debug_Print('MAIN16_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 2 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M16_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_40 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M16_06_07) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_14 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN21_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 1 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M21_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_42 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M21_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_15 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN22_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M22_01_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_16 [étiquette de flux ExplorerScript]
  -- debug_Print('MAIN23_CHOUREI') [neutre/état moteur]
  do local __sw = select(2, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[1]) [scn($SCENARIO_MAIN)[1]: sous-état du chapitre]
  if __sw == 0 then
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M23_01_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_17 [étiquette de flux ExplorerScript]
  -- debug_Print('SUB01_CHOUREI') [neutre/état moteur]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_S01_12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  -- jump @label_42 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 4 then
  -- jump @label_40 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 22 then
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 29 then
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
