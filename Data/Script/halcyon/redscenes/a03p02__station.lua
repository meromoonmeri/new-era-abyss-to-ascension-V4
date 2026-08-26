-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a03p02 (dialogues ROM 0x084A8664).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Escape Through the Snow", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Wow! The snow is like frozen powder!", french="Waouh! La neige ressemble à du coton!", german="Wow! Der Schnee sieht aus wie gefrorener Puder!", italian="Wow! La neve sembra polvere ghiacciata!", spanish="¡Mira eso! ¡La nieve es como polvo helado!"})
  SkySceneKit.say({english="It looks pretty, but... It must be harsh there...", french="C'est joli, mais... ça doit être difficile de vivre ici...", german="Das sieht sehr schön aus... Aber das Leben hier muss sehr hart sein...", italian="È bello, ma... dev'essere dura vivere qui...", spanish="Es muy hermoso, pero debe de ser duro vivir aquí..."})
end
