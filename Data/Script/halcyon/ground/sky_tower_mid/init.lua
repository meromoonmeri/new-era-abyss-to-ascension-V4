require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local sky_tower_mid = {}
function sky_tower_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function sky_tower_mid.Enter(map_data) GAME:FadeIn(20) end
function sky_tower_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo("Continuer dans Tour Céleste ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('sky_tower', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function sky_tower_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('sky_tower_entrance', 'Main_Entrance_Marker')
end
function sky_tower_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return sky_tower_mid
