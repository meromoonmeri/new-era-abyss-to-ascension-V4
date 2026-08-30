-- Ground Controller Script for Metano Town (Recreated) (metano_town_recreated)
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

function GroundScene.Door_metano_shop_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_shop", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_metano_inn_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_inn", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_metano_cafe_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_cafe", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_normal_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_normal_home", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_rock_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_rock_home", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_fire_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_fire_home", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.sign_welcome_Action(obj, activator)
  UI:WaitShowDialogue("Welcome to Metano Town!")
  UI:WaitShowDialogue("Center of Trade & Adventure")
end

function GroundScene.sign_cafe_Action(obj, activator)
  UI:WaitShowDialogue("Spinda's Cafe")
  UI:WaitShowDialogue("Best Gummi Drinks in the World!")
end

function GroundScene.sign_shop_Action(obj, activator)
  UI:WaitShowDialogue("Kecleon Shop")
  UI:WaitShowDialogue("High quality items and orbs!")
end

return GroundScene
