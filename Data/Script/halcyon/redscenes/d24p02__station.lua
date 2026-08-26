-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d24p02 (dialogues ROM 0x0856181C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Stormy Sea", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You're going to the DMurky Cave?", french="Tu vas à la DGrotte Ténèbres?", german="Gehst du zur DDüsterhöhle?", italian="Ti stai recando alla DGrotta Tenebrosa?", spanish="¿Vas a la DVieja Cueva?"})
  SkySceneKit.say({english="Don't forget to take me, kekeh!", french="N'oublie pas de m'emmener, ec, ec!", german="Vergiss nicht, mich mitzunehmen, kekeh!", italian="Non dimenticare di portare anche me, kekeh!", spanish="¡No olvides llevarme contigo, ueje, je!"})
end
