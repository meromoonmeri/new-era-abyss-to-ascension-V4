-- Ground Controller Script for Metano Outskirts (Clairière de Metano) (skytemple_metano_outskirts)
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

function GroundScene.Door_outskirts_shop_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_shop", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_outskirts_cafe_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  -- Warp to interior map
  -- GAME:EnterGroundMap("interior_cafe", "Entrance")
  GAME:FadeIn(20)
end

function GroundScene.Door_outskirts_inn_Touch(obj, activator)
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
  UI:WaitShowDialogue("Welcome to Metano Outskirts!")
  UI:WaitShowDialogue("Direct path to Mountain Dungeon")
end

function GroundScene.sign_lookout_Action(obj, activator)
  UI:WaitShowDialogue("Spinda's Lookout Point")
  UI:WaitShowDialogue("Finest berry brews in the forest")
end

return GroundScene
