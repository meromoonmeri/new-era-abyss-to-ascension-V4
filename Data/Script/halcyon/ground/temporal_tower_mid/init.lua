require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local temporal_tower_mid = {}
function temporal_tower_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function temporal_tower_mid.Enter(map_data) GAME:FadeIn(20) end
function temporal_tower_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Tour du Temps Restaurée ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('temporal_tower', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function temporal_tower_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('temporal_tower_entrance', 'Main_Entrance_Marker')
end
function temporal_tower_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return temporal_tower_mid
