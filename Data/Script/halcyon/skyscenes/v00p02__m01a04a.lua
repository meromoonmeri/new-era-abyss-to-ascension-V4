-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a04a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false,  30)
  GAME:FadeIn(0)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S02P01A) [décor sub chargé: Sub_s02p01a]
  -- back_SetGround(LEVEL_S02P01A) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 16, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GAME:MoveCamera(128, 124, 1, false) end)
  SkySubScreen.Show("s02p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false,  30)
  -- back_SetGround(LEVEL_S03P01A) [neutre/état moteur]
  -- back_SetWeather(0) [météo visuelle ground NDS - documenté]
  pcall(function() GAME:MoveCamera(264, 188, 1, false) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- back_SetBackEffect(2) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(120)
  -- back_SetWeatherEffect(3) [neutre/état moteur]
  GAME:WaitFrames(240) -- back_SetEffect(1, 240) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(120)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetGround(S04P01A) [décor sub chargé: Sub_s04p01a]
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  SkySubScreen.Show("s04p01a", 0, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  SkySubScreen.Show("s04p01a", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(60)
  SkySubScreen.Hide(0) -- screen2_FlushOut: retour BOTTOM_FOCUS (timeline ROM)
  -- screen2_FadeOut [sub déjà caché]
  SkySubScreen.Show("s04p01a", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  -- back2_SetGround(S02P01A) [décor sub chargé: Sub_s02p01a]
  -- back_SetGround(LEVEL_S02P01A) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m3', 16, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GAME:MoveCamera(128, 124, 1, false) end)
  SkySubScreen.Show("s02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false,  30)
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
