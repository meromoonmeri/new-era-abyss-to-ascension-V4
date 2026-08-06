--[[ fosse_ardente — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local fosse_ardente = {}

function fosse_ardente.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function fosse_ardente.Enter(map)
  FugitiveArc.Play('fosse_ardente')
end

function fosse_ardente.Update(map) end
function fosse_ardente.GameSave(map) end
function fosse_ardente.GameLoad(map)
  GAME:FadeIn(20)
end

return fosse_ardente
