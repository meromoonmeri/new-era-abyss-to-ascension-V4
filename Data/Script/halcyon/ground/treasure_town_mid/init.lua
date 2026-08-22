require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local treasure_town_mid = {}
function treasure_town_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function treasure_town_mid.Enter(map_data) GAME:FadeIn(20) end
function treasure_town_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer dans Nouvelle Route de Guilde ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('treasure_town', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function treasure_town_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('treasure_town_entrance', 'Main_Entrance_Marker')
end
function treasure_town_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return treasure_town_mid
