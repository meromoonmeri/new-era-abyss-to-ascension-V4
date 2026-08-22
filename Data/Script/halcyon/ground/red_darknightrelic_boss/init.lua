require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local red_darknightrelic_boss = {}
function red_darknightrelic_boss.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function red_darknightrelic_boss.Enter(map_data)
  GAME:FadeIn(20)
  UI:WaitShowDialogue('Le voyage est terminé.')
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, 'master_zone', -1, 1, 0, true, true)
end
return red_darknightrelic_boss
