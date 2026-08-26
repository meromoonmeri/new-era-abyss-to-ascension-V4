-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P21A/m10a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ack...[K] We didn't make it!", french=" Argh...[K] On a échoué!", german="Argh...[K] Wir haben es nicht\ngeschafft!", italian=" Nooo...[K] Non c'è l'abbiamo fatta!", spanish=" Ay...[K] ¡Ha ido de pena!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D10P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Upper Steam Cave.ogg", true) end)
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
  SkySceneKit.say({english=" Wow, that was really tough!", french="Ça devient de plus en plus\ndifficile.", german=" Wow, das war echt schwierig!", italian=" Che fatica!", spanish=" Vaya, ¡qué duro ha resultado!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="But we're so close![K] We just\ncan't give up now! Let's keep trying!", french="Mais on se rapproche![K] Courage,\nil faut continuer!", german="Aber wir sind so nah dran![K]\nWir dürfen jetzt nicht aufgeben! Wir müssen\nweiterkämpfen!", italian="Però ormai ci siamo.[K]\nNon possiamo arrenderci. Dobbiamo farcela!", spanish="¡Pero ya no queda mucho![K]\n¡No nos rindamos ahora! ¡Sigamos intentándolo!"}) -- SwitchTalk: branche default (canon générique)
end
