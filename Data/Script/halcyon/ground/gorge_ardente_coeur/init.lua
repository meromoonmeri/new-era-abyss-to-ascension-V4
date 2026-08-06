--[[ gorge_ardente_coeur — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local gorge_ardente_coeur = {}

function gorge_ardente_coeur.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function gorge_ardente_coeur.Enter(map)
  FugitiveArc.Play('gorge_ardente_coeur')
end

function gorge_ardente_coeur.Update(map) end
function gorge_ardente_coeur.GameSave(map) end
function gorge_ardente_coeur.GameLoad(map)
  GAME:FadeIn(20)
end

return gorge_ardente_coeur
