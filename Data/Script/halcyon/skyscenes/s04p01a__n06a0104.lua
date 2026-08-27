-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n06a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Here Comes Team Charm!", french="Voilà l'Equipe Charme!", german="Platz für Team Charme!", italian="Arriva il Team Malia!", spanish="¡Llega el Equipo Carisma!"}) -- bannière d'épisode spécial (titre ROM)
  -- GAP: BGM BGM_HERE_COMES_TEAM_CHARM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(15)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:FadeOut(false,  30)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
end
