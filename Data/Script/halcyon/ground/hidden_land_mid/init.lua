require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local hidden_land_mid = {}
function hidden_land_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function hidden_land_mid.Enter(map_data) GAME:FadeIn(20) end
function hidden_land_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Fracture de la Terre Cachée ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('hidden_land', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function hidden_land_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('hidden_land_entrance', 'Main_Entrance_Marker')
end
function hidden_land_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return hidden_land_mid
