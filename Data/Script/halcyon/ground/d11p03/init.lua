--[[ d11p03 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d11p03 = {}

function d11p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d11p03.Enter(map)
  FugitiveArc.Play('d11p03')
end

function d11p03.Update(map) end
function d11p03.GameSave(map) end
function d11p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d11p03
