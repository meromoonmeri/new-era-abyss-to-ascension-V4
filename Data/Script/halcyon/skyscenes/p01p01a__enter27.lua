-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter27.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]- Assembly Post -\n[CN]For service, please ring bell!\n[CN]            -[CS:N]Chimecho[CR]", french="[CN]- Point de Rassemblement -\n[CN]Prière d'utiliser la cloche!\n[CN]            - [CS:N]Eoko[CR]", german="[CN]- Versammlungsort -\n[CN]Bitte Glocke läuten!\n[CN]  -[CS:N]Palimpalim[CR]", italian="[CN]- Raduno Squadra -\n[CN]Per assistenza, suonare la campana!\n[CN]            - [CS:N]Chimecho[CR] -", spanish="[CN]Punto de reunión\n[CN]¡Toca la campana y acudiré!\n[CN]            -[CS:N]Chimecho[CR]"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Ring the bell and\n[CN]summon [CS:N]Chimecho[CR]?", french="[CN]Voulez-vous faire sonner la cloche\n[CN]pour appeler [CS:N]Eoko[CR]?", german="[CN]Glocke läuten und\n[CN][CS:N]Palimpalim[CR] herbeirufen?", italian="[CN]Vuoi suonare la campana per\n[CN]chiamare [CS:N]Chimecho[CR]?", spanish="[CN]¿Tocar la campana y\n[CN]llamar a [CS:N]Chimecho[CR]?"})
end
