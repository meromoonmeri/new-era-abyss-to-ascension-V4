require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local mystifying_forest_mid = {}
function mystifying_forest_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function mystifying_forest_mid.Enter(map_data) GAME:FadeIn(20) end
function mystifying_forest_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Héritage de la Remise de Diplôme ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('mystifying_forest', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function mystifying_forest_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('mystifying_forest_entrance', 'Main_Entrance_Marker')
end
function mystifying_forest_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return mystifying_forest_mid
