-- Sinister Woods b41 uses the native PMDO TileLayer animation clock.
--
-- The former adapter rewrote shared AutoTile frame lists from a delayed
-- DungeonMapInit coroutine.  AutoTiles are global data: when the player left
-- a floor before the 8/12 tick callbacks fired, those callbacks could mutate
-- the next floor's lists.  That produced the visible shifted/interior tiles.
-- Keep this service name as a save/mod compatibility anchor, but never mutate
-- shared tile definitions at runtime.  The promoted b41 tile packages already
-- contain their canonical frame sequence and PMDO advances it natively.
require 'origin.common'
require 'origin.services.baseservice'

local V = Class('SinisterWoodsB41StartupAdapter', BaseService)

function V:initialize()
  BaseService.initialize(self)
end

function V:Subscribe(med)
  -- Intentionally no DungeonMapInit subscription.  A per-map callback must
  -- not rewrite global AutoTile layers, because a dungeon transition may occur
  -- before the callback's delayed animation phase completes.
end

function V:UnSubscribe(med)
end

SCRIPT:AddService('SinisterWoodsB41StartupAdapter', V:new())
return V
