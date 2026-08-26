-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d02p01 (dialogues ROM 0x084D8010).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Thunderwave Cave", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Let's give it our best and rescue them [hero]!", french="Faisons de notre mieux et secourons-les, [hero]!", german="Geben wir unser Bestes und retten sie, [hero]!", italian="[hero], facciamo del nostro meglio per salvarli!", spanish="¡Vamos a rescatarlos! ¡Adelante, [hero]!"})
  SkySceneKit.say({english="Let's do our best to rescue them, [hero]!", french="Faisons de notre mieux pour les secourir, [hero]!", german="Lass sie uns retten, [hero]!", italian="[hero], dobbiamo fare il possibile per salvarli!", spanish="¡Vamos a darlo todo para rescatarlos, [hero]!"})
end
