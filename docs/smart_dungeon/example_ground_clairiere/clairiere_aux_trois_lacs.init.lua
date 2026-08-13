-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local clairiere_aux_trois_lacs = {}
function clairiere_aux_trois_lacs.Init(map) DEBUG.EnableDbgCoro() end
function clairiere_aux_trois_lacs.Enter(map) GAME:FadeIn(20) end
function clairiere_aux_trois_lacs.Update(map) end
function clairiere_aux_trois_lacs.North_Exit_Touch(obj, activator)
  GAME:FadeOut(false, 30)
  GAME:EnterGroundMap('altere_pond', 'Main_Entrance_Marker')
end
return clairiere_aux_trois_lacs
