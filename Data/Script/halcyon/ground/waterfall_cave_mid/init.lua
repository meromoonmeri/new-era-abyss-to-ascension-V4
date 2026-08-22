require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local waterfall_cave_mid = {}
function waterfall_cave_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function waterfall_cave_mid.Enter(map_data) GAME:FadeIn(20) end
function waterfall_cave_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Grotte Cascade ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('waterfall_cave', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function waterfall_cave_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('waterfall_cave_entrance', 'Main_Entrance_Marker')
end
function waterfall_cave_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return waterfall_cave_mid
