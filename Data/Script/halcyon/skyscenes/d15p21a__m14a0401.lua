-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P21A/m14a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ugh! We didn't make it!", french="Argh! On a lamentablement\néchoué!", german="Ugh! Wir haben es nicht\ngeschafft!", italian=" Ohi ohi. Niente da fare.", spanish=" ¡Ay! ¡No lo hemos conseguido!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D15P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_QUICKSAND_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  SkySceneKit.say({english="Ugh! The going is really\nrough here!", french="Argh! Ce n'est pas une sinécure,\nici!", german="Ugh! Es ist wirklich schwierig,\nhier voranzukommen!", italian="Ugh! È proprio difficile\nproseguire.", spanish="¡Ay! ¡Las cosas no son nada\nfáciles por aquí!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="But we're so close. There's no\ngiving up now. We have to keep trying!", french="Mais on se rapproche du but.\nPas question de baisser les bras!\nAccrochons-nous!", german="Aber wir sind so nah dran.\nWir dürfen jetzt nicht aufgeben. Wir müssen\nweitermachen!", italian="Ma dobbiamo andare avanti.\nCoraggio! Non manca molto ormai!", spanish="Pero ya no queda mucho.\nNo podemos rendirnos. ¡Tenemos\nque seguir intentándolo!"}) -- SwitchTalk: branche default (canon générique)
end
