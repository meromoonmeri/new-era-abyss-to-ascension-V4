--[[ palier_celeste — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local palier_celeste = {}

function palier_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function palier_celeste.Enter(map)
  FugitiveArc.Play('palier_celeste')
end

function palier_celeste.Update(map) end
function palier_celeste.GameSave(map) end
function palier_celeste.GameLoad(map)
  GAME:FadeIn(20)
end

return palier_celeste
