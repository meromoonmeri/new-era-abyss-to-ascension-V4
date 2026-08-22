require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local starfall_heights_mid = {}
function starfall_heights_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function starfall_heights_mid.Enter(map_data) GAME:FadeIn(20) end
function starfall_heights_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Les Deux Lumières ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('starfall_heights', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function starfall_heights_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('starfall_heights_entrance', 'Main_Entrance_Marker')
end
function starfall_heights_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return starfall_heights_mid
