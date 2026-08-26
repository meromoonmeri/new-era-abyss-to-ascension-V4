-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d04p02 (dialogues ROM 0x084DFD1C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, those pests are gone. Let's find .", french="Eh bien, ces fléaux sont partis. Allons trouver .", german="Die Nervensägen sind weg. Jetzt müssen wir nur noch finden.", italian="Quelle pesti se ne sono andate. Troviamo .", spanish="Bueno, nos deshicimos de esos matones. Busquemos a ."})
  SkySceneKit.say({english="No one should hold us back now. Let's find .", french="Plus personne ne devrait nous gêner maintenant. Allons retrouver .", german="Niemand wird uns jetzt noch aufhalten. Suchen wir .", italian="Ora nessuno può fermarci. Troviamo .", spanish="Ya nada nos retiene. Busquemos a ."})
  SkySceneKit.say({english="No one should hold us back now. Let's find .", french="Plus personne ne devrait nous gêner maintenant. Allons retrouver .", german="Niemand wird uns jetzt noch aufhalten. Suchen wir .", italian="Ora nessuno può fermarci. Troviamo .", spanish="Parece que ya podemos seguir buscando a ."})
end
