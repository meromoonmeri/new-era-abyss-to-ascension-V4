-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local arene_finale = {}
function arene_finale.Init(map) DEBUG.EnableDbgCoro() end
function arene_finale.Enter(map) GAME:FadeIn(20) end
function arene_finale.Update(map) end
function arene_finale.North_Exit_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue('Cette sortie doit être reliée par le contrat du donjon parent.')
end
return arene_finale
