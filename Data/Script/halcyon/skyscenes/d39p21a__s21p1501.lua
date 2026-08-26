-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P21A/s21p1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Urggh...[K] That ended poorly...", french="Argh...[K] On a manqué notre\ncoup...", german="Urks...[K] Das ist schlecht\nausgegangen...", italian=" Urggh...[K] È andata male...", spanish=" Uf...[K] No ha acabado nada bien..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D39P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
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
  SkySceneKit.say({english=" Urk![K] This is difficult...", french="Argh![K] Ça commence\nà se corser...", german=" Uff![K] Sehr schwierig...", italian=" Uh![K] È difficile...", spanish="Está resultando duro...[K] Más de\nlo que pensaba..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="We have to force [CS:N]Palkia[CR] to tell\nus what we need to know!", french="De gré ou de force, il faut que\n[CS:N]Palkia[CR] nous dise ce qu'on veut savoir!", german="Wir müssen [CS:N]Palkia[CR] zwingen,\nuns zu sagen, was wir wissen müssen!", italian="Dobbiamo costringere [CS:N]Palkia[CR] a\nrivelarci ciò che abbiamo bisogno di sapere!", spanish="¡Hay que obligar a [CS:N]Palkia[CR]\na contarnos lo que necesitamos saber!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Legen wir los, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos allá, [hero]!"}) -- SwitchTalk: branche default (canon générique)
end
