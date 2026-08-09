--[[ p05p02a — Arc du futur (PMD Sky, cast New Era).
     Ground pixel-perfect du port PMD-SKY-PMDO-PORT. La cinématique est jouée
     par FutureArc.Play (chorégraphie 1:1, cast New Era). ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local p05p02a = {}

function p05p02a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function p05p02a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FutureArc.Play('p05p02a')
end

function p05p02a.Update(map) end
function p05p02a.GameSave(map) end
function p05p02a.GameLoad(map)
  GAME:FadeIn(20)
end

return p05p02a
