require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local red_mtthunder_entrance = {}
function red_mtthunder_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function red_mtthunder_entrance.Enter(map_data) GAME:FadeIn(20) end
function red_mtthunder_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Entrer dans Mont Grondant ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('red_mtthunder', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function red_mtthunder_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return red_mtthunder_entrance
