-- ==============================================================================
-- PMDO Ground Script: LeafVillage (Village de la Feuille)
-- Converted from canonical animated map: town_map (1).gif
-- Commit: 5968f338b9eca113498e863b3d38e5aef8da1d13
-- ==============================================================================
require 'origin.common'

local leaf_village = {}

function leaf_village.Init(map)
  DEBUG.EnableDbgLoc(true)
  GROUND:SetMusic("Leaf_Village_Sanctuary.ogg", 0.8)
  
  -- Register animated tile regions (40 frames, 180ms cycle)
  if GROUND.RegisterAnimatedTiles then
    GROUND:RegisterAnimatedTiles("Content/Tile/LeafVillage/animation/tiles_manifest.json")
  end
end

function leaf_village.OnMapStart()
  GAME:FadeIn(20)
end

-- ==============================================================================
-- Transitions & Gateways
-- ==============================================================================

-- West Entrance (Connecting to Altair Transition / Metano Outskirts)
function leaf_village.Entrance_West_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("pixellab_altair_completed", "Entrance_East")
end

-- North-West Road Exit (Connecting to Apricorn Grove)
function leaf_village.Exit_NorthWest_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("pixellab_apricorn_glade", "Entrance_Default")
end

-- South Road Exit (Connecting to Southern Valley)
function leaf_village.Exit_South_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("pixellab_altere_pond", "Entrance_North")
end

-- ==============================================================================
-- Building Interactors
-- ==============================================================================

-- Grand Treehouse Main Doorway (Grid: cx=89, cy=50)
function leaf_village.Treehouse_Door_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("treehouse_interior_hub", "Entrance_Default")
end

-- Treehouse Spiral Stairs Warp (Grid: cx=75, cy=48 -> Balcony)
function leaf_village.Treehouse_Stairs_Touch(obj, activator)
  GAME:FadeOut(false, 15)
  GAME:EnterGroundMap("treehouse_balcony_deck", "Entrance_Default")
end

-- Waterfall Cottage Doorway (Grid: cx=29, cy=87)
function leaf_village.Cottage_Door_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("waterfall_cottage_interior", "Entrance_Default")
end

-- ==============================================================================
-- Landmarks & Environmental Objects
-- ==============================================================================

function leaf_village.Mushroom_Shrine_Action(obj, activator)
  UI:SetSpeaker(STRINGS:Format("\\u{E040}"))
  UI:WaitShowDialogue("An ancient shrine surrounded by glowing forest mushrooms.")
end

function leaf_village.Wooden_Bridge_Action(obj, activator)
  UI:SetSpeaker(STRINGS:Format("\\u{E040}"))
  UI:WaitShowDialogue("The clear waters of the northern brook flow gently below.")
end

return leaf_village
