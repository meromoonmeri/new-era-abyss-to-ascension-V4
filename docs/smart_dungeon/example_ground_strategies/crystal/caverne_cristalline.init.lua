-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local caverne_cristalline = {}
function caverne_cristalline.Init(map) DEBUG.EnableDbgCoro() end
function caverne_cristalline.Enter(map) GAME:FadeIn(20) end
function caverne_cristalline.Update(map) end
function caverne_cristalline.North_Exit_Touch(obj, activator)
  GAME:FadeOut(false, 30)
  GAME:EnterGroundMap('crooked_cavern_entrance', 'Main_Entrance_Marker')
end
return caverne_cristalline
