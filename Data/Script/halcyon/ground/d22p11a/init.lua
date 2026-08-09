--[[
    d22p11a — DUSK FOREST (dungeon 32, arc du futur main story).

    Map fixe NDS D22P11A. Ordre canonique (LSD) : m19a0201 -> m19a0301
    (entrée donjon) -> [Dusk Forest 8 floors, dark F6-8] -> retour m19a0501
    -> continuation vers le climax (P08P01A / Passage du Temps).
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d22p11a = {}

function d22p11a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d22p11a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s1 = require('halcyon.future_arc.scene.d22p11a_m19a0201')
    if s1 and s1.Cutscene then FutureCast.Spawn('D22P11A_m19a0201'); s1.Cutscene() end
    local s2 = require('halcyon.future_arc.scene.d22p11a_m19a0301')
    if s2 and s2.Cutscene then FutureCast.Spawn('D22P11A_m19a0301'); s2.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('dusk_forest', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d22p11a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

function d22p11a.AfterDungeon()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s3 = require('halcyon.future_arc.scene.d22p11a_m19a0501')
    if s3 and s3.Cutscene then FutureCast.Spawn('D22P11A_m19a0501'); s3.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    -- continuation : le trio poursuit vers le Passage du Temps / climax
    GAME:EnterGroundMap('p08p01a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d22p11a] sortie interrompue : ' .. tostring(err)) end
end

function d22p11a.Update(map) end
function d22p11a.GameSave(map) end
function d22p11a.GameLoad(map) GAME:FadeIn(20) end

return d22p11a
