-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/enter02.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D16P31A8_55 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) -- switch($CRYSTAL_COLOR_02) [GameVar CRYSTAL_COLOR_02]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('RED_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_44) [routine d'objet NDS non simulée - documenté]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('NEXTCOLOR') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CRYSTAL_COLOR_02 = ((SV.SkyVars.CRYSTAL_COLOR_02) or 0) + 1 -- $CRYSTAL_COLOR_02 += 1 (ROM)
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) < 6) then -- if ROM: $CRYSTAL_COLOR_02 < 6
  -- @label_7 [étiquette de flux ExplorerScript]
  -- debug_Print('REMOVE') [neutre/état moteur]
  -- supervision_RemoveCommon(14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(26) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(29) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('SWITCH') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) -- switch($CRYSTAL_COLOR_02) [GameVar CRYSTAL_COLOR_02]
  if __sw == 0 then
  -- debug_Print('RED') [neutre/état moteur]
  -- supervision_StationCommon(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_44) [routine d'objet NDS non simulée - documenté]
  -- @label_14 [étiquette de flux ExplorerScript]
  if (((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) ~= 5) or (((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) ~= 5) then -- if ROM: $CRYSTAL_COLOR_01 != 5 || $CRYSTAL_COLOR_02 != 5 || $CRYSTAL
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- supervision_ExecuteCommon(CORO_EVENT_M15_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif __sw == 1 then
  -- debug_Print('GREEN') [neutre/état moteur]
  -- supervision_StationCommon(29) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_53) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- debug_Print('PURPLE') [neutre/état moteur]
  -- supervision_StationCommon(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_41) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE') [neutre/état moteur]
  -- supervision_StationCommon(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_47) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW') [neutre/état moteur]
  -- supervision_StationCommon(26) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_50) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BLUE') [neutre/état moteur]
  -- supervision_StationCommon(14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_38) [routine d'objet NDS non simulée - documenté]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_02 = 0 -- $CRYSTAL_COLOR_02 = 0 (ROM)
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 1 then
  -- debug_Print('GREEN_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_53) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- debug_Print('PURPLE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_41) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- debug_Print('ORANGE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_47) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- debug_Print('YELLOW_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_50) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- debug_Print('BLUE_TO') [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_38) [routine d'objet NDS non simulée - documenté]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
