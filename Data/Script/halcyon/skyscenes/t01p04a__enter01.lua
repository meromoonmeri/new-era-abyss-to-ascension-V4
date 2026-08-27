-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P04A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[191] = 3 -- dungeon_mode(191) = DMODE_OPEN_AND_REQUEST (ROM)
  do local __sw = 0 -- switch(main_EnterTraining2(-1, 30)) [main_EnterTraining2(-1, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Caution!", french="[CN]Attention!", german="[CN]Achtung!", italian="[CN]Attenzione!", spanish="[CN]¡Atención!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]If you enter here, all the items in\n[CN]your Treasure Bag will be lost.", french="[CN]Si vous entrez ici, tous les objets\n[CN]de votre Sac à Trésor seront perdus.", german="[CN]Wenn ihr eintretet, gehen alle Items in eurem\n[CN]Schatzbeutel verloren.", italian="[CN]Entrando qui, tutti gli strumenti nella Sacca\n[CN]dei tesori andranno persi.", spanish="[CN]Si continúas, perderás todos los\n[CN]objetos que llevas en la Bolsa."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Will you enter, even though\n[CN]all your items will be lost?", french="[CN]Voulez-vous entrer quand même, au risque\n[CN]de perdre tous vos objets?", german="[CN]Tretet ihr ein, auch wenn dadurch alle Items\n[CN]in eurem Schatzbeutel verloren gehen?", italian="[CN]Vuoi entrare anche se tutti gli strumenti\n[CN]andranno persi?", spanish="[CN]¿Quieres entrar aunque vayas a\n[CN]perder todos tus objetos?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 1 then
  -- message_Close
  -- switch(main_EnterTraining2(251, 30)) corps vide [main_EnterTraining2(251, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- message_Close
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You should leave important items with\n[CN][CS:K]Kangaskhan[CR] Storage before coming here.", french="[CN]Vous devriez stocker vos objets précieux\n[CN]dans la [CS:K]Réserve Kangourex[CR] avant d'entrer.", german="[CN]Wichtige Items solltet ihr im [CS:K]Kangama-Lager[CR]\n[CN]aufbewahren lassen, bevor ihr hierherkommt.", italian="[CN]Prima di venire qui bisognerebbe lasciare\n[CN]gli strumenti più importanti al Deposito\n[CN][CS:K]Kangaskhan[CR].", spanish="[CN]Deberías dejar los objetos importantes en la\n[CN][CS:K]Consigna Kangaskhan[CR] antes de venir aquí."})
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
end
