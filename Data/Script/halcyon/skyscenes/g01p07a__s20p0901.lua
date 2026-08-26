-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s20p0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 208, 208, Direction.Up, "NPC_SURIIPU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_suriipu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Ah!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Are you two ready to go into\nthe dream?", french=" Voulez-vous aller dans le rêve?", german="Seid ihr zwei bereit,\nin den Traum zu gehen?", italian="È tutto pronto? Volete entrare\nnel sogno?", spanish=" ¿Ya os habéis preparado?"})
  SkySceneKit.cleanup_npcs()
end
