-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local canyon_sinueux = {}
function canyon_sinueux.Init(map) DEBUG.EnableDbgCoro() end
function canyon_sinueux.Enter(map) GAME:FadeIn(20) end
function canyon_sinueux.Update(map) end
function canyon_sinueux.North_Exit_Touch(obj, activator)
  GAME:FadeOut(false, 30)
  GAME:EnterGroundMap('searing_tunnel_entrance', 'Main_Entrance_Marker')
end
return canyon_sinueux
