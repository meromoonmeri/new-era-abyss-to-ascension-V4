require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local crevice_cave_entrance = {}
function crevice_cave_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function crevice_cave_entrance.Enter(map_data) GAME:FadeIn(20) end
function crevice_cave_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Entrer dans Grotte Fissure ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('crevice_cave', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function crevice_cave_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return crevice_cave_entrance
