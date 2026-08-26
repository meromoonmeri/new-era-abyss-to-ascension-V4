-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m26a0612.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero]!", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
end
