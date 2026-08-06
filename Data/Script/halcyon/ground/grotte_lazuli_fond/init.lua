--[[ grotte_lazuli_fond — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local grotte_lazuli_fond = {}

function grotte_lazuli_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grotte_lazuli_fond.Enter(map)
  FugitiveArc.Play('grotte_lazuli_fond')
end

function grotte_lazuli_fond.Update(map) end
function grotte_lazuli_fond.GameSave(map) end
function grotte_lazuli_fond.GameLoad(map)
  GAME:FadeIn(20)
end

return grotte_lazuli_fond
