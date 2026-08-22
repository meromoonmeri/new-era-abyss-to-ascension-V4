require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local fogbound_lake_boss = {}
function fogbound_lake_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function fogbound_lake_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('fogbound_lake', 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return fogbound_lake_boss
