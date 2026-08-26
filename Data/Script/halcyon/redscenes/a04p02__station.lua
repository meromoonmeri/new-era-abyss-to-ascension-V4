-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a04p02 (dialogues ROM 0x084C59E8).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_SKY_TOWER: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's a huge tower of clouds...", french="C'est une tour énorme faite de nuages...", german="Das ist ein hoher Turm aus Wolken...", italian="È un'enorme torre di nuvole...", spanish="Es como una gran torre de nubes..."})
end
