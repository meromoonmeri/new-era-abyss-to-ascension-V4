--[[ tour_ciel_sommet — étape de l'Arc Fugitif (ch11, canon PMD Red).
     Ground pixel-perfect du port PMD-RED-PMDO-PORT. La scène est jouée
     par FugitiveArc.Play (dialogues par clés SCENE_*, à adopter). ]]
require 'origin.common'
require 'halcyon.FugitiveArc'

local tour_ciel_sommet = {}

function tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function tour_ciel_sommet.Enter(map)
  FugitiveArc.Play('tour_ciel_sommet')
end

function tour_ciel_sommet.Update(map) end
function tour_ciel_sommet.GameSave(map) end
function tour_ciel_sommet.GameLoad(map)
  GAME:FadeIn(20)
end

return tour_ciel_sommet
