--[[ p09p01a — Arc du futur (PMD Sky, cast New Era).
     Ground pixel-perfect du port PMD-SKY-PMDO-PORT. La cinématique est jouée
     par FutureArc.Play (chorégraphie 1:1, cast New Era). ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local p09p01a = {}

function p09p01a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function p09p01a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FutureArc.Play('p09p01a')
end

function p09p01a.Update(map) end
function p09p01a.GameSave(map) end
function p09p01a.GameLoad(map)
  GAME:FadeIn(20)
end

return p09p01a
