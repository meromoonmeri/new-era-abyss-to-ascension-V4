-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m14a0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="So let's go for it! Let's jump into\nthat quicksand pit, [hero]!", french="Alors on fonce! Sautons les yeux\nfermés dans les sables mouvants,\n[hero]!", german="Also, lass es uns tun! Lass uns\nin den Treibsandstrudel springen, [hero]!", italian="Andiamo! Tuffiamoci nelle\nsabbie mobili, [hero]!", spanish="Entonces, adelante... ¡Saltemos\na esas arenas movedizas, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(hero, 248, 180, false, 2)
  GROUND:MoveToPosition(partner, 216, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 248, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 216, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7169) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(74) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(74) [anim idle native]
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 60)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
end
