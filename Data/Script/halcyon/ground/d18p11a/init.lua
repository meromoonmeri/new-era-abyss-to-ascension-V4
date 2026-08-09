--[[
    d18p11a — CHASM CAVE (dungeon 27, arc du futur main story).

    Map fixe NDS D18P11A : le trio (héros + partenaire + Grovyle) fuit dans le
    futur. Ordre canonique (LSD) : m17a0501 -> m17a0504 -> m17a0601 (entrée
    donjon) -> [Chasm Cave 8 floors] -> retour m17a0701 -> Dark Hill.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d18p11a = {}

function d18p11a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d18p11a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    -- Arrivée : le trio reprend son souffle
    local s1 = require('halcyon.future_arc.scene.d18p11a_m17a0501')
    if s1 and s1.Cutscene then FutureCast.Spawn('D18P11A_m17a0501'); s1.Cutscene() end
    -- Dialogue avec Grovyle
    local s2 = require('halcyon.future_arc.scene.d18p11a_m17a0504')
    if s2 and s2.Cutscene then FutureCast.Spawn('D18P11A_m17a0504'); s2.Cutscene() end
    GAME:CutsceneMode(false)
    -- Entrée dans le donjon Chasm Cave (dungeon 27, 8 floors)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('chasm_cave', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d18p11a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

-- Appelé au retour du donjon (sortie) : scène de sortie puis Dark Hill.
function d18p11a.AfterDungeon()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    local s3 = require('halcyon.future_arc.scene.d18p11a_m17a0701')
    if s3 and s3.Cutscene then FutureCast.Spawn('D18P11A_m17a0701'); s3.Cutscene() end
    GAME:CutsceneMode(false)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d19p11a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d18p11a] sortie interrompue : ' .. tostring(err)) end
end

function d18p11a.Update(map) end
function d18p11a.GameSave(map) end
function d18p11a.GameLoad(map) GAME:FadeIn(20) end

return d18p11a
