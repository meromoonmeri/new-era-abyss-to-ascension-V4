--[[
    d19p11a — DARK HILL (dungeon 28, arc du futur main story).

    Map fixe NDS D19P11A. Ordre canonique (LSD) : m18a0101 -> m18a0201
    (entrée donjon) -> [Dark Hill 15 floors] -> retour m18a0301 -> Sealed Ruin.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d19p11a = {}

function d19p11a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d19p11a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s1 = require('halcyon.future_arc.scene.d19p11a_m18a0101')
    if s1 and s1.Cutscene then FutureCast.Spawn('D19P11A_m18a0101'); s1.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('dark_hill', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d19p11a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

function d19p11a.AfterDungeon()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s3 = require('halcyon.future_arc.scene.d19p11a_m18a0301')
    if s3 and s3.Cutscene then FutureCast.Spawn('D19P11A_m18a0301'); s3.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d20p11a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d19p11a] sortie interrompue : ' .. tostring(err)) end
end

function d19p11a.Update(map) end
function d19p11a.GameSave(map) end
function d19p11a.GameLoad(map) GAME:FadeIn(20) end

return d19p11a
