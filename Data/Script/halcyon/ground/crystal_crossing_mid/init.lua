require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local crystal_crossing_mid = {}
function crystal_crossing_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function crystal_crossing_mid.Enter(map_data) GAME:FadeIn(20) end
function crystal_crossing_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Passage Cristal ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('crystal_crossing', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function crystal_crossing_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('crystal_crossing_entrance', 'Main_Entrance_Marker')
end
function crystal_crossing_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return crystal_crossing_mid
