-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a02a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A02A') [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Event Test is under way.", french="An Event Test is under way.", german="An Event Test is under way.", italian="An Event Test is under way.", spanish="An Event Test is under way."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Placement Test will be conducted.", french="A Placement Test will be conducted.", german="A Placement Test will be conducted.", italian="A Placement Test will be conducted.", spanish="A Placement Test will be conducted."})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Place Sector 1", french="Place Sector 1", german="Place Sector 1", italian="Place Sector 1", spanish="Place Sector 1"})
  -- message_Close
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Place Sector 2", french="Place Sector 2", german="Place Sector 2", italian="Place Sector 2", spanish="Place Sector 2"})
  -- message_Close
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Remove Sector 1", french="Remove Sector 1", german="Remove Sector 1", italian="Remove Sector 1", spanish="Remove Sector 1"})
  -- message_Close
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Remove Sector 2", french="Remove Sector 2", german="Remove Sector 2", italian="Remove Sector 2", spanish="Remove Sector 2"})
  -- message_Close
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Place Date Indicator on Sector 1", french="Place Date Indicator on Sector 1", german="Place Date Indicator on Sector 1", italian="Place Date Indicator on Sector 1", spanish="Place Date Indicator on Sector 1"})
  -- message_Close
  GAME:WaitFrames(30)
  -- supervision_ActingInvisible(1) [acting caché superviseur NDS]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Place Date Indicator on Sector 2", french="Place Date Indicator on Sector 2", german="Place Date Indicator on Sector 2", italian="Place Date Indicator on Sector 2", spanish="Place Date Indicator on Sector 2"})
  -- message_Close
  -- supervision_ActingInvisible(2) [acting caché superviseur NDS]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Label Request", french="Label Request", german="Label Request", italian="Label Request", spanish="Label Request"})
  -- message_Close
  local npc_npc_test009 = SkySceneKit.spawn_npc("magnemite", 488, 280, Direction.Down, "NPC_TEST009")
  -- ResetOutputAttribute(128) [neutre/état moteur]
  local npc_npc_test010 = SkySceneKit.spawn_npc("jumpluff", 552, 280, Direction.Down, "NPC_TEST010")
  -- SetupOutputAttributeAndAnimation(4, 128, 11) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Remove", french="Enlever", german="Remove", italian="Remove", spanish="Remove"})
  -- message_Close
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Event Test is finished.", french="The Event Test is finished.", german="The Event Test is finished.", italian="The Event Test is finished.", spanish="The Event Test is finished."})
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
end
