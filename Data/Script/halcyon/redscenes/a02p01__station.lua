-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a02p01 (dialogues ROM 0x0849BB10).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("The Escape", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Whoa! These cracks go down deep!", french="Waouh! Ces crevasses sont profondes!", german="Hui! Das sind aber tiefe Spalten!", italian="Wow! Quant'è profondo qui?!", spanish="¡Cuidado! ¡Esas grietas son muy profundas!"})
  SkySceneKit.say({english="Wow! Aren't these fissures amazing?!", french="Ouh, là, là! Tu as vu ces crevasses?", german="Wow! Hier geht es aber in die Tiefe! Beeindruckend!", italian="Wow! Questi crepacci sono incredibili!", spanish="¡Increíble! ¡Un paisaje sobrecogedor!..."})
end
