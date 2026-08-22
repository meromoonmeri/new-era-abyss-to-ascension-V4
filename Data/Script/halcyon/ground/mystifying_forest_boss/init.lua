require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local mystifying_forest_boss = {}
function mystifying_forest_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function mystifying_forest_boss.Enter(map_data)
  GAME:FadeIn(20)
  UI:WaitShowDialogue('Le voyage est terminé.')
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
end
return mystifying_forest_boss
