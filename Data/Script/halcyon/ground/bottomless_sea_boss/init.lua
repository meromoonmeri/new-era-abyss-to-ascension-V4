require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local bottomless_sea_boss = {}
function bottomless_sea_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function bottomless_sea_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('bottomless_sea', 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return bottomless_sea_boss
