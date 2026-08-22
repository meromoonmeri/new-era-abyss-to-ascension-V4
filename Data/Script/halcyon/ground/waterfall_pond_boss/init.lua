require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local waterfall_pond_boss = {}
function waterfall_pond_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function waterfall_pond_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('waterfall_pond', 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return waterfall_pond_boss
