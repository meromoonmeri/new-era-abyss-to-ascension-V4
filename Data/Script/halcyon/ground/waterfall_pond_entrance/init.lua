require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local waterfall_pond_entrance = {}
function waterfall_pond_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function waterfall_pond_entrance.Enter(map_data) GAME:FadeIn(20) end
function waterfall_pond_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Entrer dans Sanctuaire de Cristal ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('waterfall_pond', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function waterfall_pond_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return waterfall_pond_entrance
