-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P11A/s01p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Urk![K] We paid for our mistakes!", french="Argh...[K] Quelle raclée on s'est\nprise.", german="Umpf![K] Unsere Fehler haben sich\ngerächt!", italian="Ah![K] Abbiamo pagato per i\nnostri errori!", spanish="¡Vaya![K] ¡Nuestros errores nos\nhan salido caros!"}) -- SwitchTalk: branche default (canon générique)
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
  SkySceneKit.say({english="Urk![K] We were too careless,\nI think.", french="Ouille...[K] On a pris\ntrop de risques.", german="Umpf![K] Wir waren zu\nunvorsichtig, denke ich.", italian="Urk![K] Non abbiamo fatto\nabbastanza attenzione.", spanish="¡Uf![K] Creo que nos hemos\ndejado llevar demasiado."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="Besides, the minions were all\nguild members...[K] What are they trying\nto prove?", french="En plus, ses sbires, c'étaient\nles apprentis de la Guilde...[K] A quoi ils\njouent?", german="Außerdem waren die\nUntergebenen alles Gildenmitglieder...[K] Was\nversuchen sie zu beweisen?", italian="Inoltre, gli sgherri erano tutti\nmembri della Gilda...[K] Cosa stanno cercando\ndi dimostrare?", spanish="Además, los secuaces eran todos\nlos miembros del [CS:N]Pokégremio[CR]...[K] ¿A quién\nquieren engañar?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We have to keep at this,\n[hero]!", french="Il faut avancer,\n[hero]!", german="Wir müssen dranbleiben,\n[hero]!", italian="Continuiamo ad andare avanti,\n[hero]!", spanish="¡Tenemos que esforzarnos,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
end
