-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d11p02 (dialogues ROM 0x0852E1DC).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mt Freeze", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Keep going?", french="Continuer?", german="Weitergehen?", italian="Vuoi proseguire?", spanish="¿Quieres continuar?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the rescue team base?", french="Retourner à la base de l'équipe de secours?", german="Zurück zur Retterteam-Basis?", italian="Vuoi tornare alla base della Squadra di Soccorso?", spanish="¿Quieres volver a la base del equipo de rescate?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Return to the entrance?", french="Retourner à l'entrée?", german="Zurück zum Eingang?", italian="Vuoi tornare all'ingresso?", spanish="¿Quieres volver a la entrada?"})
  SkySceneKit.say({english="Yes.", french="Oui", german="Ja", italian="Sì", spanish="Sí"})
  SkySceneKit.say({english="*No.", french="*Non", german="*Nein", italian="*No", spanish="*No"})
  SkySceneKit.say({english="Hmm... Well, that didn't go well.", french="Hum... Eh bien, ça s'est mal passé.", german="Hmm... Das lief nicht gerade gut.", italian="Hmm... Niente da fare.", spanish="Mmm... Vaya, no nos ha ido muy bien."})
  SkySceneKit.say({english="Hmm... That didn't work out...", french="Hum... Ça n'a pas marché...", german="Hmm... Das war ein Fehlschlag...", italian="Hmm... Qualcosa non ha funzionato...", spanish="Mmm... No nos ha salido bien..."})
  SkySceneKit.say({english="But we didn't have far to go!", french="Mais on y était presque!", german="Dabei waren wir schon fast am Ziel!", italian="Ma c'eravamo quasi!", spanish="¡Pero hemos estado cerca!"})
  SkySceneKit.say({english="Let's storm our way to the top this time, [hero]!", french="Atteignons le sommet cette fois, [hero]!", german="Dieses Mal werden wir den Gipfel erstürmen, [hero]!", italian="Questa volta facciamoci largo fino alla vetta, [hero]!", spanish="¡Esta vez lucharemos hasta la cima, [hero]!"})
  SkySceneKit.say({english="But we were very close!", french="Mais on était si proches!", german="Wir waren schon nah dran!", italian="Ma eravamo a un passo dalla fine!", spanish="¡Pero nos faltó muy poco!"})
  SkySceneKit.say({english="Let's be sure to reach the peak this time, [hero]!", french="Assurons-nous d'atteindre le sommet, cette fois, [hero]!", german="Diesmal müssen wir den Gipfel einfach erstürmen, [hero]!", italian="Non possiamo permetterci di mancare la cima anche questa volta, [hero]!", spanish="¡Esta vez seguro que llegaremos a la cima, [hero]!"})
end
