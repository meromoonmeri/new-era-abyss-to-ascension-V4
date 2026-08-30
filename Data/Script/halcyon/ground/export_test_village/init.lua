-- Ground Controller Script for Starter Village (export_test_village)
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

function GroundScene.Door_pokemon_center_1_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_pokemon_center", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_shop_2_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_shop", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_medium_4_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_medium", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_medium_5_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_medium", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_small_6_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_small", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_small_7_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_small", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_small_8_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_small", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_house_small_9_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_house_small", "Entrance")
  GAME:FadeIn(20)
end

return GroundScene
