-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub t00p02 (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_test008(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="An event will be activated.\nWhich one would you like?", french="An event will be activated.\nWhich one would you like?", german="An event will be activated.\nWhich one would you like?", italian="An event will be activated.\nWhich one would you like?", spanish="An event will be activated.\nWhich one would you like?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="An Acting Test will be activated.\nWhich one would you like?", french="An Acting Test will be activated.\nWhich one would you like?", german="An Acting Test will be activated.\nWhich one would you like?", italian="An Acting Test will be activated.\nWhich one would you like?", spanish="An Acting Test will be activated.\nWhich one would you like?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="An Item Usage Test will be activated.\nWhich one would you like?", french="An Item Usage Test will be activated.\nWhich one would you like?", german="An Item Usage Test will be activated.\nWhich one would you like?", italian="An Item Usage Test will be activated.\nWhich one would you like?", spanish="An Item Usage Test will be activated.\nWhich one would you like?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]You have 1 Blue Gummi.", french="[CN]You have 1 Blue Gummi.", german="[CN]You have 1 Blue Gummi.", italian="[CN]You have 1 Blue Gummi.", spanish="[CN]You have 1 Blue Gummi."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]You have 2 or more Blue Gummis.", french="[CN]You have 2 or more Blue Gummis.", german="[CN]You have 2 or more Blue Gummis.", italian="[CN]You have 2 or more Blue Gummis.", spanish="[CN]You have 2 or more Blue Gummis."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]You have no Blue Gummis.", french="[CN]You have no Blue Gummis.", german="[CN]You have no Blue Gummis.", italian="[CN]You have no Blue Gummis.", spanish="[CN]You have no Blue Gummis."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]There are no Blue Gummis in storage.", french="[CN]There are no Blue Gummis in storage.", german="[CN]There are no Blue Gummis in storage.", italian="[CN]There are no Blue Gummis in storage.", spanish="[CN]There are no Blue Gummis in storage."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]A Blue Gummi couldn't be obtained.", french="[CN]A Blue Gummi couldn't be obtained.", german="[CN]A Blue Gummi couldn't be obtained.", italian="[CN]A Blue Gummi couldn't be obtained.", spanish="[CN]A Blue Gummi couldn't be obtained."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]Received [s_item:0].", french="[CN]Reçu l'objet [s_item:0].", german="[CN]Received [s_item:0].", italian="[CN]Received [s_item:0].", spanish="[CN]Objeto [s_item:0] recibido."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]You never had a Blue Gummi to start with.", french="[CN]You never had a Blue Gummi to start with.", german="[CN]You never had a Blue Gummi to start with.", italian="[CN]You never had a Blue Gummi to start with.", spanish="[CN]You never had a Blue Gummi to start with."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="[CN]You lost a Blue Gummi.", french="[CN]You lost a Blue Gummi.", german="[CN]You lost a Blue Gummi.", italian="[CN]You lost a Blue Gummi.", spanish="[CN]You lost a Blue Gummi."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="The Map will be switched.", french="The Map will be switched.", german="The Map will be switched.", italian="The Map will be switched.", spanish="The Map will be switched."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="The Map was switched.", french="The Map was switched.", german="The Map was switched.", italian="The Map was switched.", spanish="The Map was switched."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
end
local function talk_npc_test004(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="What can I help you with today?", french="What can I help you with today?", german="What can I help you with today?", italian="What can I help you with today?", spanish="What can I help you with today?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Do you really need help with anything?", french="Do you really need help with anything?", german="Do you really need help with anything?", italian="Do you really need help with anything?", spanish="Do you really need help with anything?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I can't help you with anything right now.", french="I can't help you with anything right now.", german="I can't help you with anything right now.", italian="I can't help you with anything right now.", spanish="I can't help you with anything right now."})
end
return {
  {species="makuhita", x=400, y=184, dir=Direction.Down, name="NPC_TEST008", talk=talk_npc_test008},
  {species="kangaskhan", x=264, y=192, dir=Direction.Down, name="NPC_TEST004", talk=talk_npc_test004},
}
