require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local fugitive_arc_mid = {}
function fugitive_arc_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function fugitive_arc_mid.Enter(map_data) GAME:FadeIn(20) end
function fugitive_arc_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Les Accusés ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('fugitive_arc', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function fugitive_arc_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('fugitive_arc_entrance', 'Main_Entrance_Marker')
end
function fugitive_arc_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return fugitive_arc_mid
