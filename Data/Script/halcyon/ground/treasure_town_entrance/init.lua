require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local treasure_town_entrance = {}
function treasure_town_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function treasure_town_entrance.Enter(map_data) GAME:FadeIn(20) end
function treasure_town_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Entrer dans Nouvelle Route de Guilde ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('treasure_town', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function treasure_town_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return treasure_town_entrance
