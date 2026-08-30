-- Ground Controller Script for Metano Waterfall Haven (metano_waterfall_haven)
-- Generated deterministically by PMDO-PixelLab Engine

local GroundScene = {}

function GroundScene.Init(map)
  DEBUG.EnableDebugging()
end

function GroundScene.Enter(map)
  SOUND:PlayBGM("Treasure Town.ogg", true)
  GAME:FadeIn(20)
end

function GroundScene.Update(map, time)
end

function GroundScene.Exit(map)
end

function GroundScene.Door_haven_shop_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_shop", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_haven_cafe_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_cafe", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_haven_inn_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_inn", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_1_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_1", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_2_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_2", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_3_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_3", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.sign_welcome_Action(obj, activator)
  UI:WaitShowDialogue("Welcome to Waterfall Haven!")
  UI:WaitShowDialogue("Crystal waters and mountain breezes")
end

function GroundScene.sign_waterfall_Action(obj, activator)
  UI:WaitShowDialogue("Waterfall Lookout Point")
  UI:WaitShowDialogue("Spinda's Cafe & Terrace")
end

return GroundScene
