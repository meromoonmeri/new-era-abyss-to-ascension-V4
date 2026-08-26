-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d12p04 (dialogues ROM 0x0854487C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Are you all right?", french="Vous allez bien?", german="Seid ihr in Ordnung?", italian="Tutto a posto?", spanish="¿Estás bien?"})
  SkySceneKit.say({english="Are you OK?", french="Vous vous sentez bien?", german="Geht es euch gut?", italian="Tutto OK?", spanish="¿Te encuentras bien?"})
end
