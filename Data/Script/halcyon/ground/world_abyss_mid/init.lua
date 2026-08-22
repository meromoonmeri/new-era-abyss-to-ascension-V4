require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local world_abyss_mid = {}
function world_abyss_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function world_abyss_mid.Enter(map_data) GAME:FadeIn(20) end
function world_abyss_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Abîme du Monde ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('world_abyss', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function world_abyss_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('world_abyss_entrance', 'Main_Entrance_Marker')
end
function world_abyss_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return world_abyss_mid
