-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Try solving the secret of the\nthree crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german="Versuche das Rätsel der\nKristalle zu lösen!", italian="Vai e risolvi il mistero dei tre\ncristalli!", spanish="¡Intenta resolver el secreto de\nlos tres cristales!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Let's give it a try!)", french="(Faisons un essai!)", german="(Versuchen wir es mal!)", italian="(Proviamo!)", spanish="(¡Probemos!)"}) -- SwitchMonologue: branche default
end
