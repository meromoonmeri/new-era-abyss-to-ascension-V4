-- [red_direct_animation] Ground GBA d20p01 — animation de palette canonique ROM.
-- Adaptateur généré (RESERVE/pmdred_direct, campagne 219 pixel-exacte).
local AnimAdapter = require 'halcyon.ground.d20p01.animation_callbacks'

local d20p01 = {}

function d20p01.Init(map)
  AnimAdapter.Init(map)
end

function d20p01.Enter(map)
  GAME:FadeIn(20)
end

function d20p01.Update(map)
  AnimAdapter.Update(map)
end

function d20p01.GameSave(map) end
function d20p01.GameLoad(map)
  GAME:FadeIn(20)
end

return d20p01
