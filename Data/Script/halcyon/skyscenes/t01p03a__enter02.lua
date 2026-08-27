-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/enter02.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There's a notice posted here.[K]\n[CN]Something's written on it...", french="[CN]Il y a une affiche ici.[K]\n[CN]Quelque chose y est écrit...", german="[CN]Hier hängt ein Notizzettel.[K]\n[CN]Etwas steht darauf geschrieben.", italian="[CN]C'è un biglietto.[K]\n[CN]E c'è scritto qualcosa...", spanish="[CN]Aquí hay una nota.[K]\n[CN]A ver qué pone..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"[CS:K]Marowak[CR] Dojo has collapsed.[K] But it will rise\nfrom the rubble again!\"", french="\"Le [CS:K]Dojo Ossatueur[CR] s'est effondré.[K]\nMais il renaîtra de ses cendres!", german="Das [CS:K]Knogga-Dojo[CR] ist eingestürzt.[K] Aber es wird\nsich wieder aus seinen Trümmern erheben!", italian="\"Il Dojo [CS:K]Marowak[CR] è crollato.[K] Ma risorgerà\ndalle macerie!\"", spanish="\"El [CS:K]Dojo Marowak[CR] se ha hundido...[K] ¡pero\nresurgirá de sus cenizas!\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Yes! The Dojo will be resurrected to its\nformer glory![K]\n- [CS:K]Marowak[CR] Dojo's Sensei -\"", french="Oui! Le Dojo retrouvera sa grandeur passée![K]\n- [CS:K]Ossatueur[CR], sensei du dojo -\"", german="Jawohl! Das Dojo wird seine frühere Pracht\nzurückerlangen![K]\n- Meister des [CS:K]Knogga-Dojos[CR] -", italian="\"Sì! Il Dojo tornerà alla\nsua antica gloria!\"[K]\n- [CS:K]Marowak[CR], maestro del Dojo -", spanish="\"¡Sí! ¡El dojo recuperará la gloria de antaño!\"[K]\n- Maestro [CS:K]Marowak[CR]"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[180] = 3 -- dungeon_mode(180) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[181] = 3 -- dungeon_mode(181) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[182] = 3 -- dungeon_mode(182) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[183] = 3 -- dungeon_mode(183) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[184] = 3 -- dungeon_mode(184) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[185] = 3 -- dungeon_mode(185) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[186] = 3 -- dungeon_mode(186) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[187] = 3 -- dungeon_mode(187) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[188] = 3 -- dungeon_mode(188) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[189] = 3 -- dungeon_mode(189) = DMODE_OPEN_AND_REQUEST (ROM)
  do local __sw = 0 -- switch(main_EnterTraining(-1, 30)) [main_EnterTraining(-1, 30): écran entraînement moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 1 then
  -- @label_1 [étiquette de flux ExplorerScript]
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
  -- switch(main_EnterTraining(251, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- message_Close
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You should leave important items with\n[CN][CS:K]Kangaskhan[CR] Storage before coming here.", french="[CN]Vous devriez stocker vos objets précieux\n[CN]dans la [CS:K]Réserve Kangourex[CR] avant d'entrer.", german="[CN]Wichtige Items solltet ihr im [CS:K]Kangama-Lager[CR]\n[CN]aufbewahren lassen, bevor ihr hierherkommt.", italian="[CN]Prima di venire qui bisognerebbe lasciare\n[CN]gli strumenti più importanti al Deposito\n[CN][CS:K]Kangaskhan[CR].", spanish="[CN]Deberías dejar los objetos importantes en la\n[CN][CS:K]Consigna Kangaskhan[CR] antes de venir aquí."})
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
end
