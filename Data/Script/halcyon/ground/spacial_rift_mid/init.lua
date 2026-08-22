require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local spacial_rift_mid = {}
function spacial_rift_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function spacial_rift_mid.Enter(map_data) GAME:FadeIn(20) end
function spacial_rift_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer dans Faille Spatiale ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('spacial_rift', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function spacial_rift_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('spacial_rift_entrance', 'Main_Entrance_Marker')
end
function spacial_rift_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return spacial_rift_mid
