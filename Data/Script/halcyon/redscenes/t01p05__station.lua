-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground t01p05 (dialogues ROM 0x08383C28).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_POKEMON_SQUARE: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There appears to be no one inside.", french="Il n'y a personne à l'intérieur.", german="Es ist niemand da.", italian="Sembra non esserci nessuno.", spanish="Parece que no hay nadie."})
  SkySceneKit.say({english="............! There is a notice posted in the back.", french="... ... ... ... ... ... ... ... ... ... ... ... Il y a un mot accroché sur la porte.", german="............! Da ist eine Notiz angebracht.", italian="... ... ... ...! C'è un cartello.", spanish="¡Anda!... Hay una nota colgada aquí."})
  SkySceneKit.say({english="Under Construction - Keep Out - Makuhita Dojo -", french="En construction - Ne pas entrer - Dojo Makuhita -", german="Im Umbau - Zutritt verboten - Makuhita-Dojo -", italian="Lavori in corso - Non avvicinarsi - Dojo Makuhita -", spanish="Estamos en obras. No pasar. - Dojo Makuhita -"})
end
