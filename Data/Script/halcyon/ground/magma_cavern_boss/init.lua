require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local magma_cavern_boss = {}
function magma_cavern_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function magma_cavern_boss.Enter(map_data)
  SV.CanonicalBundle = SV.CanonicalBundle or {}
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterDungeon('magma_cavern', 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
return magma_cavern_boss
