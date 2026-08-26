-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a02p01 (dialogues ROM 0x0849BB10).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("The Escape", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Whoa! These cracks go down deep!", french="Waouh! Ces crevasses sont profondes!", german="Hui! Das sind aber tiefe Spalten!", italian="Wow! Quant'è profondo qui?!", spanish="¡Cuidado! ¡Esas grietas son muy profundas!"})
  SkySceneKit.say({english="Wow! Aren't these fissures amazing?!", french="Ouh, là, là! Tu as vu ces crevasses?", german="Wow! Hier geht es aber in die Tiefe! Beeindruckend!", italian="Wow! Questi crepacci sono incredibili!", spanish="¡Increíble! ¡Un paisaje sobrecogedor!..."})
  SkySceneKit.say({english="Thus began [hero]'s", french="C'est ainsi que débuta le voyage de [hero].", german="Und so begann für [hero]...", italian="E così per [hero] ha inizio", spanish="Y así comenzó la odisea de [hero]."})
  SkySceneKit.say({english="cruel and arduous journey as a fugitive.", french="Un long et difficile périple l'attendait.", german="Die Flucht ins Ungewisse voller Gefahren und Entbehrungen.", italian="una lunga e travagliata fuga.", spanish="La dura y hostil vida de los fugitivos."})
  SkySceneKit.say({english="Over forbidding mountains...", french="Traversant des montagnes inhospitalières...", german="Über zerklüftetes Gebirge...", italian="Attraverso montagne inaccessibili...", spanish="Cruzando montañas prohibidas..."})
end
