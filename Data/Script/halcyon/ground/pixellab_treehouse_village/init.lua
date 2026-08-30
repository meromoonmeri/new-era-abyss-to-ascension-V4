-- PMDO Ground Script: pixellab_treehouse_village
-- Connected adjacent to MAPACOMPLETEVIAPIXELLAB_COMPLETED
require 'origin.common'

local pixellab_treehouse_village = {}

function pixellab_treehouse_village.Init(map)
  DEBUG.EnableDbgLoc(true)
  GROUND:SetMusic("Treehouse_Village_Theme.ogg", 0.8)
end

function pixellab_treehouse_village.OnMapStart()
  GAME:FadeIn(20)
end

function pixellab_treehouse_village.Entrance_West_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("pixellab_altair_completed", "Entrance_East")
end

function pixellab_treehouse_village.Treehouse_Door_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("treehouse_interior_hub", "Entrance_Default")
end

function pixellab_treehouse_village.Cottage_Door_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("waterfall_cottage_interior", "Entrance_Default")
end

return pixellab_treehouse_village
