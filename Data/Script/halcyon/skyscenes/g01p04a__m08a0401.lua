-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m08a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff Guild.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh? Are you all ready for the\nexpedition?", french="Ça y est? Vous avez terminé\nvos préparatifs pour l'expédition?", german="Oh? Sind alle bereit für die\nExpedition?", italian="Allora? È tutto pronto per la\nspedizione?", spanish="¿Ah? ¿Lo tenéis todo\npara la expedición?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The expedition will be a long\njourney. You should be stocked up on items.\nAre you all ready to go?", french="L'expédition sera un long voyage.\nVous devriez prendre le maximum d'objets\navec vous. Avez-vous tout ce qu'il vous faut?", german="Diese Expedition wird eine lange\nReise sein. Ihr solltet ausreichend Items dabei\nhaben. Seid ihr bereit?", italian="La spedizione sarà lunga.\nDovreste fare provvista di strumenti.\nÈ davvero tutto pronto?", spanish="La expedición será un viaje\nmuy largo. Os conviene llevar todos los\nobjetos que necesitéis. ¿Todo listo?"})
end
