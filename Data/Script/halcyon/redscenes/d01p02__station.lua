-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d01p02 (dialogues ROM 0x084D577C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Waaaaah...", french="Ouiiiiiiin...", german="Waaaaah...", italian="Uuuuuè...", spanish="Buaaaaa..."})
  SkySceneKit.say({english="Mommy... Where are you...? Sniffle...", french="Maman... Où es-tu? Sniff...", german="Mami... Wo bist du...? Schnüff...", italian="Mamma... dove sei? Sigh...", spanish="Mamá... ¿Dónde estás?... Snif..."})
  SkySceneKit.say({english="We came to rescue you.", french="On est là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Hola, hemos venido a rescatarte."})
  SkySceneKit.say({english="We came to rescue you.", french="Nous sommes là pour te sauver.", german="Wir sind hier, um dich zu retten.", italian="Siamo qui per salvarti.", spanish="Tranquilízate, pequeñín, hemos venido a rescatarte."})
  SkySceneKit.say({english="Huh?", french="Hein?", german="Huch?", italian="Eh?", spanish="¿Eh?"})
  SkySceneKit.say({english="Your mom's waiting. Let's get you out!", french="Ta maman t'attend. Sortons d'ici!", german="Deine Mami wartet schon auf dich. Komm, gehen wir zu ihr.", italian="La tua mamma ti aspetta. Usciamo di qui!", spanish="Tu mamá te está esperando. ¡Vamos a sacarte de aquí!"})
  SkySceneKit.say({english="OK.", french="D'accord.", german="Okay.", italian="OK!", spanish="¡Yupi!"})
end
