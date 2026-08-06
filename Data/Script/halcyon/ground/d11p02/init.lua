--[[ d11p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d11p02 = {}

function d11p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d11p02.Enter(map)
  FugitiveArc.Play('d11p02')
end

function d11p02.Update(map) end
function d11p02.GameSave(map) end
function d11p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d11p02
