require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.PartnerEssentials'
local the_sky_mid = {}
function the_sky_mid.Init(map_data)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end
function the_sky_mid.Enter(map_data) GAME:FadeIn(20) end
function the_sky_mid.North_Exit_Touch(obj, activator)
  UI:ChoiceMenuYesNo('Continuer dans Ciel Suspendu ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(20)
    GAME:FadeOut(false, 20)
    GAME:EnterDungeon('the_sky', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end
function the_sky_mid.South_Exit_Touch(obj, activator)
  GAME:EnterGroundMap('the_sky_entrance', 'Main_Entrance_Marker')
end
function the_sky_mid.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end
return the_sky_mid
