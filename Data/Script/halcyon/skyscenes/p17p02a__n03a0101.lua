-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n03a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Where will you go?", french="[CN]Où voulez-vous aller?", german="[CN]Wohin gehst du?", italian="[CN]Dove vuoi andare?", spanish="[CN]¿Adónde quieres ir?"})
  -- message_Close
  do local __sw = 0 -- switch(main_EnterAdventure(-1, 30)) [main_EnterAdventure(-1, 30): bascule d'écran aventure moteur NDS (retour 0 fermeture, branches préservées)]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- switch(main_EnterAdventure(251, 30)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  end
  end
  SkySceneKit.cleanup_npcs()
end
