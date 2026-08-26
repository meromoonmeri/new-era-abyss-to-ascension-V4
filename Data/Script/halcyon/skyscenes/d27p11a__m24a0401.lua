-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D27P11A/m24a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_HIDDEN_LAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
end
