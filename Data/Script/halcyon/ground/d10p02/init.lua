--[[ d10p02 — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local d10p02 = {}

function d10p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d10p02.Enter(map)
  FugitiveArc.Play('d10p02')
end

function d10p02.Update(map) end
function d10p02.GameSave(map) end
function d10p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d10p02
