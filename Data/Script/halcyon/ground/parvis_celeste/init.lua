--[[ parvis_celeste — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local parvis_celeste = {}

function parvis_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function parvis_celeste.Enter(map)
  FugitiveArc.Play('parvis_celeste')
end

function parvis_celeste.Update(map) end
function parvis_celeste.GameSave(map) end
function parvis_celeste.GameLoad(map)
  GAME:FadeIn(20)
end

return parvis_celeste
