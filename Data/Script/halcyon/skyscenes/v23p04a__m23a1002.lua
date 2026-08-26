-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V23P04A/m23a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V23P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="We couldn't see it from outside\nbecause it's in the shadows.", french="On ne peut pas voir la sortie\nde l'extérieur parce qu'elle est cachée\ndans l'ombre.", german="Von außen konnten wir ihn nicht\nsehen, weil er im Schatten liegt.", italian="Da fuori non si vede perché\nrimane nell'ombra.", spanish="No podíamos verla desde\nel exterior porque está oscura."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
end
