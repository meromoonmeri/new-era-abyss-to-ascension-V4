-- [red_direct_animation] Ground GBA d13p02 — animation de palette canonique ROM.
-- Adaptateur généré (RESERVE/pmdred_direct, campagne 219 pixel-exacte).
local AnimAdapter = require 'halcyon.ground.d13p02.animation_callbacks'

local d13p02 = {}

function d13p02.Init(map)
  AnimAdapter.Init(map)
end

function d13p02.Enter(map)
  GAME:FadeIn(20)
end

function d13p02.Update(map)
  AnimAdapter.Update(map)
end

function d13p02.GameSave(map) end
function d13p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d13p02
