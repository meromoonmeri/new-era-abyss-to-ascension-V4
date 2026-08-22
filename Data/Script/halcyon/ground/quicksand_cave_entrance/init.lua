require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local quicksand_cave_entrance = {}
function quicksand_cave_entrance.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function quicksand_cave_entrance.Enter(map_data) GAME:FadeIn(20) end
function quicksand_cave_entrance.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Entrer dans Grotte Sables Mouvants ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('quicksand_cave', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end
end
function quicksand_cave_entrance.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end
return quicksand_cave_entrance
