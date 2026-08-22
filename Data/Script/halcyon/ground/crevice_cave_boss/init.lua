require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local crevice_cave_boss = {}
function crevice_cave_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function crevice_cave_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('crevice_cave', 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return crevice_cave_boss
