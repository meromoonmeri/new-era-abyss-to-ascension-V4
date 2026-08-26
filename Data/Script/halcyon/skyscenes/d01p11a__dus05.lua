-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/dus05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- @label_3 [étiquette de flux ExplorerScript]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 432, 192, Direction.Down, "NPC_DAGUTORIO")
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Where do you want to go?", french=" Where do you want to go?", german=" Where do you want to go?", italian=" Where do you want to go?", spanish=" Where do you want to go?"})
  SkySceneKit.cleanup_npcs()
end
