-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d01p02 (dialogues ROM 0x084D577C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We came to rescue you.", french="On est là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hola, hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Tranquilízate, pequeñín, hemos venido a rescatarte."})
end
