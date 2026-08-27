-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D16P31A8_55 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) -- switch($CRYSTAL_COLOR_01) [GameVar CRYSTAL_COLOR_01 (Crevice Cave)]
  if __sw == 2 then
  -- debug_Print('PURPLE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_40) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 0 then
  -- debug_Print('RED_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_43) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_46) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_49) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- debug_Print('GREEN_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_52) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('BLUE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_37) [routine d'objet NDS non simulée - documenté]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('NEXTCOLOR') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CRYSTAL_COLOR_01 = ((SV.SkyVars.CRYSTAL_COLOR_01) or 0) + 1 -- $CRYSTAL_COLOR_01 += 1 (ROM)
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) < 6) then -- if ROM: $CRYSTAL_COLOR_01 < 6
  -- @label_7 [étiquette de flux ExplorerScript]
  -- debug_Print('REMOVE') [neutre/état moteur]
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(19) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(25) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(28) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('SWITCH') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) -- switch($CRYSTAL_COLOR_01) [GameVar CRYSTAL_COLOR_01 (Crevice Cave)]
  if __sw == 0 then
  -- debug_Print('RED') [neutre/état moteur]
  -- supervision_StationCommon(19) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_43) [routine d'objet NDS non simulée - documenté]
  -- @label_14 [étiquette de flux ExplorerScript]
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) ~= 5) then -- if ROM: $CRYSTAL_COLOR_01 != 5 || $CRYSTAL_COLOR_02 != 5 || $CRYSTAL
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- supervision_ExecuteCommon(CORO_EVENT_M15_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif __sw == 1 then
  -- debug_Print('GREEN') [neutre/état moteur]
  -- supervision_StationCommon(28) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_52) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- debug_Print('PURPLE') [neutre/état moteur]
  -- supervision_StationCommon(16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_40) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE') [neutre/état moteur]
  -- supervision_StationCommon(22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_46) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW') [neutre/état moteur]
  -- supervision_StationCommon(25) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_49) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BLUE') [neutre/état moteur]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_37) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_01 = 0 -- $CRYSTAL_COLOR_01 = 0 (ROM)
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
