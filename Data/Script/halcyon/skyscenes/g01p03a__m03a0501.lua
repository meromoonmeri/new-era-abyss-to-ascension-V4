-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 472, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?[K] Are you folks all set and\nready for some exploring?", french="Alors?[K] Z'avez bien fait\nvos préparatifs? Vous voulez partir en\nmission?", german="Na?[K] Seid ihr bereit für eine\nGanovenjagd?", italian=" Eh?[K] Tutto pronto?", spanish=" ¿Eh?[K] ¿Ya habéis acabado?"})
  SkySceneKit.cleanup_npcs()
end
