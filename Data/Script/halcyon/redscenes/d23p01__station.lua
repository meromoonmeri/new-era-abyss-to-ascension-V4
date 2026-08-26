-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d23p01 (dialogues ROM 0x08559EEC).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Look. Over there. Let's get this rescue done.", french="Regarde! Là-bas. Occupons-nous de ce sauvetage.", german="Sieh mal dort. Da drüben. Bringen wir den Auftrag hinter uns.", italian="Guarda! Portiamo a termine la missione!", spanish="Mira. Allí. Terminemos con este rescate."})
  SkySceneKit.say({english="Look, there's our Pokémon. We can get this rescue done.", french="Regarde, il y a notre Pokémon. Nous pouvons nous occuper de ce sauvetage.", german="Sieh mal, da ist das Pokémon. Wir werden es retten können.", italian="Guarda! Il nostro Pokémon! Possiamo farcela!", spanish="Mira, ahí está el Pokémon que buscábamos. Ya podemos terminar este rescate."})
end
