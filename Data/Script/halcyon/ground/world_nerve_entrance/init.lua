require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local world_nerve_entrance = {}
function world_nerve_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function world_nerve_entrance.Enter(map_data) GAME:FadeIn(20) end
function world_nerve_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Entrer dans Des Abysses à l’Ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('world_nerve', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function world_nerve_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return world_nerve_entrance
