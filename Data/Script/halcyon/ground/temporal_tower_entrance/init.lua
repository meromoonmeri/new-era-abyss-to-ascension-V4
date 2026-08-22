require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local temporal_tower_entrance = {}
function temporal_tower_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function temporal_tower_entrance.Enter(map_data) GAME:FadeIn(20) end
function temporal_tower_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Entrer dans Tour du Temps Restaurée ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('temporal_tower', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function temporal_tower_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return temporal_tower_entrance
