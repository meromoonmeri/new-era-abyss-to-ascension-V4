-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V00P02/m01a02a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeOut(false, 30)
  -- back_SetBanner2(LEVEL_G01P01C, 1, 240, 80, -1,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Special Banner Test 3", french="Test spécial titre 3", german="Spezieller Bannertest 3", italian="Test Grafico Speciale 3", spanish="Special Banner Test 3"}) -- bannière d'épisode spécial (titre ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false,  30)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Special Banner Test 2", french="Test spécial titre 2", german="Spezieller Bannertest 2", italian="Test Grafico Speciale 2", spanish="Special Banner Test 2"}) -- bannière d'épisode spécial (titre ROM)
  GAME:WaitFrames(120)
  GAME:FadeOut(false,  30)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Special Banner Test 1", french="Test spécial titre 1", german="Spezieller Bannertest 1", italian="Test Grafico Speciale 1", spanish="Special Banner Test 1"}) -- bannière d'épisode spécial (titre ROM)
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 30)
  -- back_SetBanner(-1, 5) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 30)
  -- back_SetTitleBanner(56, {
        english="""
            A Tale of an) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 30)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(10, -1)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 30)
  -- back_SetGround(32767) [neutre/état moteur]
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
