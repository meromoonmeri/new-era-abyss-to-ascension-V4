-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P03A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Items and money must be\n[CN]stored or they will be lost.\n[CN]Return to the menu?", french="[CN]Les objets doivent être stockés et l'argent\n[CN]déposé ou bien ils seront perdus.\n[CN]Revenir au menu?", german="[CN]Items und Geld müssen eingelagert werden,\n[CN]sonst gehen sie verloren.\n[CN]Zum Hauptmenü zurückkehren?", italian="[CN]Devi depositare gli strumenti e\n[CN]i soldi altrimenti andranno perduti.\n[CN]Vuoi tornare al menu?", spanish="[CN]Perderás los objetos y\n[CN]el dinero que no almacenes.\n[CN]¿Quieres regresar al menú principal?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 2 then
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[40] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[40]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_SAVE_MENU)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_3 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_JUMP_TO_TITLE_SCREEN, 30, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  else
  do local __sw = ((SV.SkyVars or {}).NOTE_MODIFY_FLAG or 0) -- switch($NOTE_MODIFY_FLAG) [GameVar NOTE_MODIFY_FLAG (SV.SkyVars)]
  if __sw == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
end
