-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P34A/m15b0904.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D17P34A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 216, Direction.Down, "NPC_AGUNOMU")
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownRight)
  -- SetAnimation(42) [anim idle native]
  SkySceneKit.cleanup_npcs()
end
