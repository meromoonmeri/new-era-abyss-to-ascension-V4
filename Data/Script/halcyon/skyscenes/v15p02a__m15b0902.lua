-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V15P02A/m15b0902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V15P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(456, 180, 60, false) end) -- performer/caméra
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_SetWaitMode(100, 60) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Fantastic!", french=" Incroyable!", german=" Fantastisch!", italian=" È fantastico!", spanish=" ¡Fantástico!"}) -- SwitchTalk: branche default (canon générique)
  -- message_SetWaitMode(150, 45) [neutre/état moteur]
  SkySceneKit.say({english="Look at all those crystals\nsticking up from the surface.", french="Regarde un peu tous\nces cristaux!", german="Sieh dir all die Kristalle an,\ndie aus dem See ragen.", italian="Guarda tutti quei cristalli che\nspuntano dall'acqua...", spanish="Mira todos esos cristales que\nasoman sobre la superficie del lago."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" Is this lake...[K]where [CS:N]Azelf[CR] lives?", french="Est-ce que c'est le lac...[K]\nde [CS:N]Créfadet[CR]?", german="Ist das der See,[K] an dem [CS:N]Tobutz[CR]\nlebt?", italian="Sarà questo...[K] il lago dove vive\n[CS:N]Azelf[CR]?", spanish="¿Será este el lago?[K] ¿Será aquí\ndonde vive [CS:N]Azelf[CR]?"}) -- SwitchTalk: branche default (canon générique)
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  SkySceneKit.say({english="Look! In the middle of the\nlake...[K] Where it's like an island...", french="Regarde! Au milieu du lac...\n[K]il y a une sorte d'île...", german="Sieh nur! In der Mitte des\nSees![K] Da ist eine Art Insel...", italian="Al centro del lago...[K] c'è come\nun'isoletta.", spanish="¡Mira! En medio del lago...[K]\nEso que parece una isla..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GAME:MoveCamera(352, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Gehen wir hin!", italian=" Andiamo!", spanish=" ¡Vamos!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
end
