-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a05p03 (dialogues ROM 0x084CB098).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Would you like to save your adventure?", french="Voulez-vous sauvegarder votre aventure?", german="Möchtest du dein Abenteuer speichern?", italian="Vuoi salvare l'avventura?", spanish="¿Quieres guardar la partida?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="No.", french="Non", german="Nein", italian="No", spanish="No"})
end
