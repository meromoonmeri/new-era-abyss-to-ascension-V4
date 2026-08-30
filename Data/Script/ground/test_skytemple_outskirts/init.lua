-- Ground Script for Test SkyTemple Outskirts
-- Generated via SkyTemple PMD Level Designer

require 'origin.common'

local test_skytemple_outskirts = {}

function test_skytemple_outskirts.Init(map)
  DEBUG.EnableLogs(false)
end

function test_skytemple_outskirts.Enter(map)
  SOUND:PlayBGM("Metano Town.ogg", true)
  GAME:FadeIn(20)
end

function test_skytemple_outskirts.Update(map, time)
  -- Real-time updates (fountains, river ripples, animated campfires)
end

function test_skytemple_outskirts.Exit(map)
  GAME:FadeOut(20)
end

-- NPC & Building Interactions

function test_skytemple_outskirts.Door_outskirts_shop_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Shop...")
  -- GAME:EnterGroundMap("interior_shop", "Entry")
end

function test_skytemple_outskirts.Door_outskirts_cafe_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Cafe...")
  -- GAME:EnterGroundMap("interior_cafe", "Entry")
end

function test_skytemple_outskirts.Door_outskirts_inn_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Inn...")
  -- GAME:EnterGroundMap("interior_inn", "Entry")
end

function test_skytemple_outskirts.Door_house_1_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Residential...")
  -- GAME:EnterGroundMap("interior_house_1", "Entry")
end

function test_skytemple_outskirts.Door_house_2_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Residential...")
  -- GAME:EnterGroundMap("interior_house_2", "Entry")
end

function test_skytemple_outskirts.Door_house_3_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Residential...")
  -- GAME:EnterGroundMap("interior_house_3", "Entry")
end

function test_skytemple_outskirts.Door_outskirts_fountain_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Entering Monument...")
  -- GAME:EnterGroundMap("", "Entry")
end

function test_skytemple_outskirts.sign_welcome_Action(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Welcome to Metano Outskirts!\nDirect path to Mountain Dungeon\n")
end

function test_skytemple_outskirts.sign_lookout_Action(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Spinda's Lookout Point\nFinest berry brews in the forest\n")
end

return test_skytemple_outskirts
