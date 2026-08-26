-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ugh...[K] That didn't work.", french=" Argh...[K] on a raté notre coup.", german=" Uff...[K] Das war wohl nichts.", italian=" Ugh...[K] Non ce l'abbiamo fatta.", spanish=" Uf...[K] Eso no ha funcionado."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D31P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mystifying Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  -- Unlock(5) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- Unlock(7) [neutre/état moteur]
  -- Lock(3) [neutre/état moteur]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.say({english="Urk![K] We need to be more\ncautious.", french="Pff...[K] On a fait preuve\nde négligence, je crois.", german="Umpf![K] Wir müssen vorsichtiger\nsein.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="Hum...[K] Habrá que ir con más\ncuidado."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We're so close, though...[K] Let's go\nfor it and graduate, [hero]!", french="On y était presque...[K] Il faut\ny retourner pour réussir l'examen,\n[hero]!", german="Aber wir sind so nah dran...[K]\nProbieren wir es noch mal! Lass uns den\nAbschluss machen, [hero]!", italian="Però c'eravamo quasi...[K] Forza,\nriproviamoci e superiamo l'esame,\n[hero]!", spanish="Aunque hemos estado a punto de\nlograrlo...[K]\n¡Hay que darlo todo, [hero]!"}) -- SwitchTalk: branche default (canon générique)
end
