-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D09P11A/m10a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ouchie![K] We didn't get through!", french=" Argh![K] On a échoué!", german="Autschie![K] Wir sind nicht\ndurchgekommen!", italian=" Ahi ahi![K] Non ce l'abbiamo fatta!", spanish=" ¡Ay![K] ¡No hemos podido pasar!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D09P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.say({english=" I guess we got a little careless?", french=" On a dû manquer de prudence.", german="Wir waren wohl etwas\nleichtsinnig, was?", italian="Avremmo dovuto agire con\nmaggiore prudenza.", spanish=" Supongo que nos hemos confiado."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" [hero], let's keep at it!", french=" Accrochons-nous, [hero]!", german="[hero], lass uns nicht\naufgeben!", italian=" Forza e coraggio, [hero]!", spanish=" ¡[hero], sigamos adelante!"}) -- SwitchTalk: branche default (canon générique)
end
