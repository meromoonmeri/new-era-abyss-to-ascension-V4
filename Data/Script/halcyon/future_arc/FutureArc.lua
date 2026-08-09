--[[
    FutureArc.lua — ARC DU FUTUR (PMD Sky, arc des 8 zones, cast New Era).

    Reproduction 1:1 des cinématiques canoniques de Sky (P05P01A..P09P01A).
    Chorégraphie, positions, timings, animations, caméra, fades, SFX, BGM,
    transitions, flags, embranchements : intacts. Seul le CAST change
    (FutureCast). Les 24 scènes se jouent dans l'ordre canonique, enchaînées
    sur chaque ground, puis le passage au ground suivant.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'

FutureArc = {}

FutureArc.SEQUENCE = {
  { ground='p05p01a', scene='m17a0103' },
  { ground='p05p01a', scene='m19a0102' },
  { ground='p05p01a', scene='n08a2008' },
  { ground='p05p02a', scene='m17a0104' },
  { ground='p05p02a', scene='m17a0201' },
  { ground='p05p02a', scene='m17a0301' },
  { ground='p05p03a', scene='m17a0302' },
  { ground='p05p03a', scene='m26a06d3' },
  { ground='p05p04a', scene='m17a0401' },
  { ground='p05p04a', scene='m17a0403' },
  { ground='p06p01a', scene='m18a0401' },
  { ground='p06p01a', scene='m26a0614' },
  { ground='p07p01a', scene='m18b1401' },
  { ground='p07p01a', scene='m26a06e6' },
  { ground='p08p01a', scene='m19a0601' },
  { ground='p08p01a', scene='m19d0612' },
  { ground='p08p01a', scene='n08a2308' },
  { ground='p08p01a', scene='n08a2408' },
  { ground='p08p01a', scene='n08a2508' },
  { ground='p08p01a', scene='n08a2608' },
  { ground='p09p01a', scene='m19b1001' },
  { ground='p09p01a', scene='m19b1007' },
  { ground='p09p01a', scene='m19b1009' },
  { ground='p09p01a', scene='m19d1072' },
}

FutureArc.INDEX = {}
FutureArc.BY_GROUND = {}
for i, step in ipairs(FutureArc.SEQUENCE) do
  FutureArc.INDEX[step.scene] = i
  if FutureArc.BY_GROUND[step.ground] == nil then FutureArc.BY_GROUND[step.ground] = {} end
  table.insert(FutureArc.BY_GROUND[step.ground], step)
end
FutureArc.NEXT_GROUND = {}
for i, step in ipairs(FutureArc.SEQUENCE) do
  if i < #FutureArc.SEQUENCE then
    FutureArc.NEXT_GROUND[step.ground] = FutureArc.SEQUENCE[i + 1].ground
  end
end

-- Démarre l'arc : entre dans le premier ground (p05p01a, repaire de Necrozma).
function FutureArc.Begin()
  DEBUG.EnableDbgCoro()
  if SV.FutureArc == nil then SV.FutureArc = {} end
  SV.FutureArc.Step = 1
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:EnterGroundMap(FutureArc.SEQUENCE[1].ground, 'Main_Entrance_Marker')
end

-- Joue toutes les scènes du ground courant puis passe au suivant.
function FutureArc.Play(ground)
  DEBUG.EnableDbgCoro()
  local steps = FutureArc.BY_GROUND[ground]
  if steps == nil then
    PrintInfo('[FutureArc] ground inconnu : ' .. tostring(ground))
    GAME:FadeIn(20)
    return
  end
  if SV.FutureArc == nil then SV.FutureArc = {} end
  if SV.FutureArc.Step == nil then SV.FutureArc.Step = 1 end
  local ok, err = pcall(function()
    for i = SV.FutureArc.Step, #steps, 1 do
      local step = steps[i]
      SV.FutureArc.Step = i
      -- place le cast New Era aux positions canoniques
      FutureCast.Spawn(step.scene)
      -- joue la scène (module Lua, chorégraphie 1:1)
      local mod = require('halcyon.future_arc.scene.' .. step.scene)
      if mod ~= nil and mod.Cutscene ~= nil then
        mod.Cutscene()
      end
      GAME:WaitFrames(10)
    end
    SV.FutureArc.Step = 1
    -- transition vers le ground suivant
    local nextGround = FutureArc.NEXT_GROUND[ground]
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    if nextGround ~= nil then
      GAME:EnterGroundMap(nextGround, 'Main_Entrance_Marker')
    else
      -- fin de l'arc du futur (à brancher sur la suite du chapitre)
      SV.FutureArc.Completed = true
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
      PrintInfo('[FutureArc] arc du futur terminé')
    end
  end)
  if not ok then
    PrintInfo('[FutureArc] interrompu sur ' .. tostring(ground) .. ' : ' .. tostring(err))
    pcall(function()
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end)
  end
end

return FutureArc
