require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local waterfall_pond_mid = {}
function waterfall_pond_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function waterfall_pond_mid.Enter(map_data) GAME:FadeIn(20) end
function waterfall_pond_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer dans Sanctuaire de Cristal ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('waterfall_pond', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function waterfall_pond_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('waterfall_pond_entrance', 'Main_Entrance_Marker')
end
function waterfall_pond_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return waterfall_pond_mid
