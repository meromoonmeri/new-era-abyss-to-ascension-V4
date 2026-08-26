-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P21A/m12a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ugh, that wasn't so good...", french=" Argh, quelle défaite...", german=" Ugh, das lief nicht gut...", italian=" Ohi, non è andata troppo bene...", spanish=" ¡Ay! Esto no ha ido muy bien..."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D12P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FAR_AMP_PLAINS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  SkySceneKit.say({english=" This won't be easy...", french="C'est plus dur que je ne le\npensais!", german=" Das wird nicht leicht...", italian=" Non sarà facile...", spanish=" ¡Esto no va a ser fácil!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="But we're almost there.\nLet's keep at it!", french="Mais on y est presque! Il faut\ntenir bon!", german="Aber wir sind fast da.\nGeben wir nicht auf!", italian="Ma non manca molto ormai.\nDiamo del nostro meglio!", spanish="Pero ya casi estamos.\n¡Hay que seguir!"}) -- SwitchTalk: branche default (canon générique)
end
