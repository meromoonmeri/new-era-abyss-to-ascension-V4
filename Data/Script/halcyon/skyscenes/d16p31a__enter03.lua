-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D16P31A8_55 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) -- switch($CRYSTAL_COLOR_03) [GameVar CRYSTAL_COLOR_03]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('RED_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_45) [routine d'objet NDS non simulée - documenté]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('NEXTCOLOR') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CRYSTAL_COLOR_03 = ((SV.SkyVars.CRYSTAL_COLOR_03) or 0) + 1 -- $CRYSTAL_COLOR_03 += 1 (ROM)
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) < 6) then -- if ROM: $CRYSTAL_COLOR_03 < 6
  -- @label_7 [étiquette de flux ExplorerScript]
  -- debug_Print('REMOVE') [neutre/état moteur]
  -- supervision_RemoveCommon(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(18) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(24) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(27) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('SWITCH') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) -- switch($CRYSTAL_COLOR_03) [GameVar CRYSTAL_COLOR_03]
  if __sw == 0 then
  -- debug_Print('RED') [neutre/état moteur]
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_45) [routine d'objet NDS non simulée - documenté]
  -- @label_14 [étiquette de flux ExplorerScript]
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) ~= 5) then -- if ROM: $CRYSTAL_COLOR_01 != 5 || $CRYSTAL_COLOR_02 != 5 || $CRYSTAL
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- supervision_ExecuteCommon(CORO_EVENT_M15_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif __sw == 1 then
  -- debug_Print('GREEN') [neutre/état moteur]
  -- supervision_StationCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_54) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- debug_Print('PURPLE') [neutre/état moteur]
  -- supervision_StationCommon(18) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_42) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE') [neutre/état moteur]
  -- supervision_StationCommon(24) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_48) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW') [neutre/état moteur]
  -- supervision_StationCommon(27) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_51) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BLUE') [neutre/état moteur]
  -- supervision_StationCommon(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_39) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_03 = 0 -- $CRYSTAL_COLOR_03 = 0 (ROM)
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 1 then
  -- debug_Print('GREEN_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_54) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- debug_Print('PURPLE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_42) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_48) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_51) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BLUE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_39) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
