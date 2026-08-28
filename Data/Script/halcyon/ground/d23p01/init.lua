-- [red_direct_animation] Ground GBA d23p01 — animation de palette canonique ROM.
-- Adaptateur généré (RESERVE/pmdred_direct, campagne 219 pixel-exacte).
local AnimAdapter = require 'halcyon.ground.d23p01.animation_callbacks'

local d23p01 = {}

function d23p01.Init(map)
  AnimAdapter.Init(map)
end

function d23p01.Enter(map)
  GAME:FadeIn(20)
end

function d23p01.Update(map)
  AnimAdapter.Update(map)
end

function d23p01.GameSave(map) end
function d23p01.GameLoad(map)
  GAME:FadeIn(20)
end

return d23p01
