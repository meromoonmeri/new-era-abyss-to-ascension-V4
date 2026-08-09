--[[
    d21p21a — SEALED RUIN PIT (dungeon 30, arc du futur main story).

    Map fixe NDS D21P21A. Ordre canonique (LSD) : m18b0801 -> m18b0901
    (entrée donjon) -> [Sealed Ruin Pit 6 floors, monster house 5%] ->
    retour m18b1002 -> Salle du boss SPIRITOMB (D21P41A).
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d21p21a = {}

function d21p21a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d21p21a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s1 = require('halcyon.future_arc.scene.d21p21a_m18b0801')
    if s1 and s1.Cutscene then FutureCast.Spawn('D21P21A_m18b0801'); s1.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('sealed_ruin_pit', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d21p21a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

function d21p21a.AfterDungeon()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s3 = require('halcyon.future_arc.scene.d21p21a_m18b1002')
    if s3 and s3.Cutscene then FutureCast.Spawn('D21P21A_m18b1002'); s3.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d21p41a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d21p21a] sortie interrompue : ' .. tostring(err)) end
end

function d21p21a.Update(map) end
function d21p21a.GameSave(map) end
function d21p21a.GameLoad(map) GAME:FadeIn(20) end

return d21p21a
