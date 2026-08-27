-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S11P02C/t01p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  do local __sw = SkySceneKit.lang_id() -- switch($LANGUAGE_TYPE) [$LANGUAGE_TYPE: langue du joueur (contenu localisé)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_S11P02C2) [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_TITLE_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- back_SetEffect(5, 0) [transition couches décor NDS immédiate]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60) -- back_SetEffect(3, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(120)
  GAME:WaitFrames(60) -- back_SetEffect(5, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  pcall(function() GAME:MoveCamera(396, 108, 1, false) end) -- SetPositionMark performer/caméra
  GAME:WaitFrames(60)
  GAME:WaitFrames(30) -- back_SetEffect(3, 30) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  SkyProg.set(3, 0) -- $SCENARIO_MAIN = scn[3,0] (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  elseif __sw == 3 then
  -- back_SetGround(LEVEL_S11P02C3) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- back_SetGround(LEVEL_S11P02C4) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- back_SetGround(LEVEL_S11P02C5) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- back_SetGround(LEVEL_S11P02C) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
