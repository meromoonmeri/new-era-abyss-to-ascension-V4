-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d05p02 (dialogues ROM 0x084E827C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_IN_THE_DEPTHS_OF_THE_PIT: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="'s friend is supposed to be around here, right?", french="L'ami de est censé se trouver dans le coin, pas vrai?", german="s Freund sollte sich hier irgendwo befinden, nicht wahr?", italian="L'amico di dovrebbe trovarsi da queste parti, giusto?", spanish="El amigo de debe de estar por aquí, ¿no?"})
  SkySceneKit.say({english="Isn't this the place? Where 's friend is supposed to be?", french="C'est ici, n'est-ce pas? Je crois que c'est ici que l'ami de est censé se trouver.", german="Sind wir nicht schon da? Hier soll sich doch s Freund befinden!", italian="Non è questo il luogo dove l'amico di dovrebbe trovarsi?", spanish="¿No es este el sitio donde se supone que está el amigo de ?"})
  SkySceneKit.say({english="Hey! Are you all right? Get it together!", french="Hé! Tu vas bien? Dis quelque chose!", german="Hey! Geht es dir gut? Reiß dich zusammen!", italian="Ehi! Tutto bene? Riprenditi!", spanish="¡Eh! ¿Estás bien? ¡Aguanta!"})
  SkySceneKit.say({english="Listen! Are you OK? Snap out of it!", french="Oh! Tu vas bien? Dis quelque chose!", german="Hallo! Wie geht es dir? Komm zu dir!", italian="È tutto OK? Rimettiti in sesto!", spanish="¡Escucha! ¿Estás bien? ¡Espabila!"})
  SkySceneKit.say({english="Wh-what happened?! It's pitch-black! I can't see!", french="Que... que se passe-t-il??? Il fait tout noir! Je ne vois rien!", german="Was ist denn jetzt passiert?!? Es ist stockdunkel! Ich kann gar nichts sehen!", italian="Cosa succede?! È tutto buio! Non vedo!", spanish="¡¿Qué ha pasado?! ¡No veo nada de nada!"})
  SkySceneKit.say({english="Wh-what's going on?! Why did it turn pitch-black?", french="Que... que se passe-t-il??? Pourquoi fait-il tout noir?", german="W-was ist denn jetzt los? Warum ist es plötzlich dunkel geworden?", italian="Cosa succede?! Perché è buio pesto?", spanish="¡¿Qué pasa?! ¿Quién ha apagado la luz?"})
end
