require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local red_fieryfield_mid = {}
function red_fieryfield_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function red_fieryfield_mid.Enter(map_data) GAME:FadeIn(20) end
function red_fieryfield_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer dans Plaine Ardent ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('red_fieryfield', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function red_fieryfield_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('red_fieryfield_entrance', 'Main_Entrance_Marker')
end
function red_fieryfield_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return red_fieryfield_mid
