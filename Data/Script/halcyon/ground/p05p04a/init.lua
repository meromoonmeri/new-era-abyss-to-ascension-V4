--[[ p05p04a — Arc du futur (PMD Sky, cast New Era).
     Ground pixel-perfect du port PMD-SKY-PMDO-PORT. La cinématique est jouée
     par FutureArc.Play (chorégraphie 1:1, cast New Era). ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local p05p04a = {}

function p05p04a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function p05p04a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FutureArc.Play('p05p04a')
end

function p05p04a.Update(map) end
function p05p04a.GameSave(map) end
function p05p04a.GameLoad(map)
  GAME:FadeIn(20)
end

return p05p04a
