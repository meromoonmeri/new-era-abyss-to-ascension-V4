-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d02p02 (dialogues ROM 0x084D86F8).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, hey, there they are. Let's get them out.", french="Oh, hé, ils sont là. Sortons-les de là.", german="Oh, hey, da sind sie ja. Holen wir sie hier heraus.", italian="Oh... eccoli lì. Aiutiamoli ad uscire.", spanish="Oh, mira, ahí están. Saquémoslos de aquí."})
  SkySceneKit.say({english="Oh, there they are! Let's get them out safely.", french="Oh, les voilà! Sortons-les de là.", german="Oh, da sind sie! Bringen wir sie sicher hier heraus.", italian="Oh... eccoli lì! Portiamoli in salvo.", spanish="Oh, ¡aquí están! Saquémoslos de aquí."})
end
