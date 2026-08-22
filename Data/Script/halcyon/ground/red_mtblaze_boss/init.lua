require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local red_mtblaze_boss = {}
function red_mtblaze_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function red_mtblaze_boss.Enter(map_data)
  GAME:FadeIn(20)
  UI:WaitShowDialogue('Le voyage est terminé.')
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
end
return red_mtblaze_boss
