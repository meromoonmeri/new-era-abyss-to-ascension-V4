--[[
    d20p11a — SEALED RUIN (dungeon 29, arc du futur main story).

    Map fixe NDS D20P11A. Ordre canonique (LSD) : m18b0501 -> m18b0601
    (entrée donjon) -> [Sealed Ruin 8 floors, monster house 5%] ->
    retour m18b0701 -> Sealed Ruin Pit.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d20p11a = {}

function d20p11a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d20p11a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s1 = require('halcyon.future_arc.scene.d20p11a_m18b0501')
    if s1 and s1.Cutscene then FutureCast.Spawn('D20P11A_m18b0501'); s1.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('sealed_ruin', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d20p11a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

function d20p11a.AfterDungeon()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s3 = require('halcyon.future_arc.scene.d20p11a_m18b0701')
    if s3 and s3.Cutscene then FutureCast.Spawn('D20P11A_m18b0701'); s3.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d21p21a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d20p11a] sortie interrompue : ' .. tostring(err)) end
end

function d20p11a.Update(map) end
function d20p11a.GameSave(map) end
function d20p11a.GameLoad(map) GAME:FadeIn(20) end

return d20p11a
