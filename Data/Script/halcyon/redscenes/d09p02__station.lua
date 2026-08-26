-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground d09p02 (dialogues ROM 0x0850E5A0).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mt Blaze", true) end)
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
  SkySceneKit.say({english="Hmm... Well, that didn't go well.", french="Hum... Eh bien, ça ne s'est pas bien passé.", german="Hmm... Das ging daneben.", italian="Hmm... Ci è andata storta.", spanish="Mmm... Vaya, no nos ha ido muy bien."})
  SkySceneKit.say({english="Hmm... That didn't work out...", french="Hum... Ça n'a pas marché...", german="Hmm... Das ist schief gelaufen.", italian="Hmm... Poteva andarci meglio...", spanish="Mmm... Esto no nos ha salido bien..."})
  SkySceneKit.say({english="But we almost made it. Let's give it our best again!", french="Mais on a failli réussir. Faisons encore de notre mieux!", german="Aber wir hätten es fast geschafft. Lass es uns noch einmal versuchen!", italian="Non ce l'abbiamo fatta per un soffio. Riproviamoci!", spanish="Pero casi lo logramos. ¡Vamos a intentarlo de nuevo!"})
  SkySceneKit.say({english="But we came close. Let's keep doing our best!", french="Mais c'était tout proche. Continuons à faire de notre mieux!", german="Aber wir waren nah am Ziel. Geben wir noch einmal unser Bestes!", italian="Sarebbe bastato poco. Non scoraggiamoci!", spanish="Pero nos faltaba poco. ¡Vamos a seguir intentándolo!"})
  SkySceneKit.say({english="But we came close. Let's keep doing our best!", french="Mais c'était tout près. Continuons à faire de notre mieux!", german="Aber wir waren nah dran. Geben wir weiter unser Bestes!", italian="Sarebbe bastato poco. Non scoraggiamoci!", spanish="Antes casi lo conseguimos... ¡Tenemos que seguir intentándolo!"})
end
