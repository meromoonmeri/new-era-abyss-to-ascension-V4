-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/dus04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- @label_14 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  local npc_npc_mankii = SkySceneKit.spawn_npc("mankey", 344, 192, Direction.Down, "NPC_MANKII")
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="What's it take for you to give\nme a Chestnut?!", french="What's it take for you to give\nme a Chestnut?!", german="What's it take for you to give\nme a Chestnut?!", italian="What's it take for you to give\nme a Chestnut?!", spanish="What's it take for you to give\nme a Chestnut?!"})
  do local __choice = SkySceneKit.ask({{english="Wait & Movement Test", french="Wait & Movement Test", german="Wait & Movement Test", italian="Wait & Movement Test", spanish="Wait & Movement Test"}, {english="You can't have one!", french="You can't have one!", german="You can't have one!", italian="You can't have one!", spanish="You can't have one!"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="What's the holdup? Hurry up\nand choose!", french="What's the holdup? Hurry up\nand choose!", german="What's the holdup? Hurry up\nand choose!", italian="What's the holdup? Hurry up\nand choose!", spanish="What's the holdup? Hurry up\nand choose!"})
  do local __choice = SkySceneKit.ask({{english="Hang on...", french="Hang on...", german="Hang on...", italian="Hang on...", spanish="Hang on..."}, {english="What should I do...", french="What should I do...", german="What should I do...", italian="What should I do...", spanish="What should I do..."}, {english="Do the [CS:N]Mankey[CR] Dance.", french="Do the [CS:N]Mankey[CR] Dance.", german="Do the [CS:N]Mankey[CR] Dance.", italian="Do the [CS:N]Mankey[CR] Dance.", spanish="Do the [CS:N]Mankey[CR] Dance."}, {english="You can't have one!", french="You can't have one!", german="You can't have one!", italian="You can't have one!", spanish="You can't have one!"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="What's the deal with making me\nwait randomly?!", french="What's the deal with making me\nwait randomly?!", german="What's the deal with making me\nwait randomly?!", italian="What's the deal with making me\nwait randomly?!", spanish="What's the deal with making me\nwait randomly?!"})
  -- message_Close
  GAME:WaitFrames(math.random(15, 60))
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Come on, gimme a Chestnut!", french=" Come on, gimme a Chestnut!", german=" Come on, gimme a Chestnut!", italian=" Come on, gimme a Chestnut!", spanish=" Come on, gimme a Chestnut!"})
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Darn tootin'! You watch me until\nI finish my dance!", french="Darn tootin'! You watch me until\nI finish my dance!", german="Darn tootin'! You watch me until\nI finish my dance!", italian="Darn tootin'! You watch me until\nI finish my dance!", spanish="Darn tootin'! You watch me until\nI finish my dance!"})
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But let me ask you this first:\nwill it be all right if I bumped into things?", french="But let me ask you this first:\nwill it be all right if I bumped into things?", german="But let me ask you this first:\nwill it be all right if I bumped into things?", italian="But let me ask you this first:\nwill it be all right if I bumped into things?", spanish="But let me ask you this first:\nwill it be all right if I bumped into things?"})
  do local __choice = SkySceneKit.ask({{english="No problem.", french="No problem.", german="No problem.", italian="No problem.", spanish="No problem."}, {english="I don't like pain...", french="I don't like pain...", german="I don't like pain...", italian="I don't like pain...", spanish="I don't like pain..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- SetHitAttribute(4) [neutre/état moteur]
  -- SetHitAttribute(4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="It could be lights-out if you\nbump into me! Be prepared for that!", french="It could be lights-out if you\nbump into me! Be prepared for that!", german="It could be lights-out if you\nbump into me! Be prepared for that!", italian="It could be lights-out if you\nbump into me! Be prepared for that!", spanish="It could be lights-out if you\nbump into me! Be prepared for that!"})
  -- message_Close
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="All right! Now I can dance with\nwild abandon!", french="All right! Now I can dance with\nwild abandon!", german="All right! Now I can dance with\nwild abandon!", italian="All right! Now I can dance with\nwild abandon!", spanish="All right! Now I can dance with\nwild abandon!"})
  -- message_Close
  -- @label_8 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", french="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", german="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", italian="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", spanish="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time"})
  do local __choice = SkySceneKit.ask({{english="MovePosition-Related", french="MovePosition-Related", german="MovePosition-Related", italian="MovePosition-Related", spanish="MovePosition-Related"}, {english="Move2Position-Related", french="Move2Position-Related", german="Move2Position-Related", italian="Move2Position-Related", spanish="Move2Position-Related"}, {english="Move3Position-Related", french="Move3Position-Related", german="Move3Position-Related", italian="Move3Position-Related", spanish="Move3Position-Related"}, {english="************", french="************", german="************", italian="************", spanish="************"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_9 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Hey! Let's dance!\nThe Direction Changing Dance!", french="Hey! Let's dance!\nThe Direction Changing Dance!", german="Hey! Let's dance!\nThe Direction Changing Dance!", italian="Hey! Let's dance!\nThe Direction Changing Dance!", spanish="Hey! Let's dance!\nThe Direction Changing Dance!"})
  -- message_Close
  GAME:WaitFrames(30)
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="When I was a young lad,\nI lived on the straight and narrow! ♪", french="When I was a young lad,\nI lived on the straight and narrow! ♪", german="When I was a young lad,\nI lived on the straight and narrow! ♪", italian="When I was a young lad,\nI lived on the straight and narrow! ♪", spanish="When I was a young lad,\nI lived on the straight and narrow! ♪"})
  -- message_Close
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(64), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-64), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But I didn't notice myself\nrunning crooked! ♪ Lalala, I'm the smooth\n[CS:N]Mankey[CR]! ♪", french="But I didn't notice myself\nrunning crooked! ♪ Lalala, I'm the smooth\n[CS:N]Mankey[CR]! ♪", german="But I didn't notice myself\nrunning crooked! ♪ Lalala, I'm the smooth\n[CS:N]Mankey[CR]! ♪", italian="But I didn't notice myself\nrunning crooked! ♪ Lalala, I'm the smooth\n[CS:N]Mankey[CR]! ♪", spanish="But I didn't notice myself\nrunning crooked! ♪ Lalala, I'm the smooth\n[CS:N]Mankey[CR]! ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 128, 128, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Sometimes, I turn 'round! ♪", french=" Sometimes, I turn 'round! ♪", german=" Sometimes, I turn 'round! ♪", italian=" Sometimes, I turn 'round! ♪", spanish=" Sometimes, I turn 'round! ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 43, 23, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" But I always run, run, run! ♪♪", french=" But I always run, run, run! ♪♪", german=" But I always run, run, run! ♪♪", italian=" But I always run, run, run! ♪♪", spanish=" But I always run, run, run! ♪♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" But with a look back... ♪", french=" But with a look back... ♪", german=" But with a look back... ♪", italian=" But with a look back... ♪", spanish=" But with a look back... ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 408, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" And sometimes slow... ♪", french=" And sometimes slow... ♪", german=" And sometimes slow... ♪", italian=" And sometimes slow... ♪", spanish=" And sometimes slow... ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But I get my groove back,\n'cause it's my comeback. ♪", french="But I get my groove back,\n'cause it's my comeback. ♪", german="But I get my groove back,\n'cause it's my comeback. ♪", italian="But I get my groove back,\n'cause it's my comeback. ♪", spanish="But I get my groove back,\n'cause it's my comeback. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 64, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Let's kick it up to high speed. ♪", french=" Let's kick it up to high speed. ♪", german=" Let's kick it up to high speed. ♪", italian=" Let's kick it up to high speed. ♪", spanish=" Let's kick it up to high speed. ♪"})
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" No walls can hold me back. ♪", french=" No walls can hold me back. ♪", german=" No walls can hold me back. ♪", italian=" No walls can hold me back. ♪", spanish=" No walls can hold me back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Thank you. ♪", french=" Thank you. ♪", german=" Thank you. ♪", italian=" Thank you. ♪", spanish=" Thank you. ♪"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Hey! Let's dance!\nThe Direction Constant Dance!", french="Hey! Let's dance!\nThe Direction Constant Dance!", german="Hey! Let's dance!\nThe Direction Constant Dance!", italian="Hey! Let's dance!\nThe Direction Constant Dance!", spanish="Hey! Let's dance!\nThe Direction Constant Dance!"})
  -- message_Close
  GAME:WaitFrames(30)
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(-32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="I lived straight and narrow\nwithout a look back. ♪", french="I lived straight and narrow\nwithout a look back. ♪", german="I lived straight and narrow\nwithout a look back. ♪", italian="I lived straight and narrow\nwithout a look back. ♪", spanish="I lived straight and narrow\nwithout a look back. ♪"})
  -- message_Close
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(-32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(64), p.Y+(-32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-64), p.Y+(32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", french="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", german="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", italian="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", spanish="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 128, 128, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" I sometimes go back. ♪", french=" I sometimes go back. ♪", german=" I sometimes go back. ♪", italian=" I sometimes go back. ♪", spanish=" I sometimes go back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 43, 23, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Then I run again without\nchanging direction. ♪♪", french="Then I run again without\nchanging direction. ♪♪", german="Then I run again without\nchanging direction. ♪♪", italian="Then I run again without\nchanging direction. ♪♪", spanish="Then I run again without\nchanging direction. ♪♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Never will I look back. ♪", french=" Never will I look back. ♪", german=" Never will I look back. ♪", italian=" Never will I look back. ♪", spanish=" Never will I look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 408, 184, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Sometimes slow... ♪", french=" Sometimes slow... ♪", german=" Sometimes slow... ♪", italian=" Sometimes slow... ♪", spanish=" Sometimes slow... ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" But not a look back. ♪", french=" But not a look back. ♪", german=" But not a look back. ♪", italian=" But not a look back. ♪", spanish=" But not a look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 64, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Now let's go high speed. ♪", french=" Now let's go high speed. ♪", german=" Now let's go high speed. ♪", italian=" Now let's go high speed. ♪", spanish=" Now let's go high speed. ♪"})
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="My own walls can't hold\nme now. ♪", french="My own walls can't hold me\nnow. ♪", german="My own walls can't hold\nme now. ♪", italian="My own walls can't hold\nme now. ♪", spanish="My own walls can't hold\nme now. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move2Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Thank you. ♪", french=" Thank you. ♪", german=" Thank you. ♪", italian=" Thank you. ♪", spanish=" Thank you. ♪"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- @label_11 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Hey! Let's dance!\nThe Direction Time Dance!", french="Hey! Let's dance!\nThe Direction Time Dance!", german="Hey! Let's dance!\nThe Direction Time Dance!", italian="Hey! Let's dance!\nThe Direction Time Dance!", spanish="Hey! Let's dance!\nThe Direction Time Dance!"})
  -- message_Close
  GAME:WaitFrames(30)
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(0), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(0), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(-32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(0), p.Y+(32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="I lived straight and narrow\nwithout a look back. ♪", french="I lived straight and narrow\nwithout a look back. ♪", german="I lived straight and narrow\nwithout a look back. ♪", italian="I lived straight and narrow\nwithout a look back. ♪", spanish="I lived straight and narrow\nwithout a look back. ♪"})
  -- message_Close
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(32), p.Y+(32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-32), p.Y+(-32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(64), p.Y+(-32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mankii.Position; GROUND:MoveToPosition(npc_npc_mankii, p.X+(-64), p.Y+(32), false, 2) end -- Move3PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", french="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", german="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", italian="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪", spanish="But I ran crooked without\nmeaning to. ♪ And never a look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 128, 128, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" I sometimes go back. ♪", french=" I sometimes go back. ♪", german=" I sometimes go back. ♪", italian=" I sometimes go back. ♪", spanish=" I sometimes go back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 43, 23, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Then I run again without\nchanging direction. ♪♪", french="Then I run again without\nchanging direction. ♪♪", german="Then I run again without\nchanging direction. ♪♪", italian="Then I run again without\nchanging direction. ♪♪", spanish="Then I run again without\nchanging direction. ♪♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Never will I look back. ♪", french=" Never will I look back. ♪", german=" Never will I look back. ♪", italian=" Never will I look back. ♪", spanish=" Never will I look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 408, 184, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Sometimes slow... ♪", french=" Sometimes slow... ♪", german=" Sometimes slow... ♪", italian=" Sometimes slow... ♪", spanish=" Sometimes slow... ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" But not a look back. ♪", french=" But not a look back. ♪", german=" But not a look back. ♪", italian=" But not a look back. ♪", spanish=" But not a look back. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 64, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Now let's go high speed. ♪", french=" Now let's go high speed. ♪", german=" Now let's go high speed. ♪", italian=" Now let's go high speed. ♪", spanish=" Now let's go high speed. ♪"})
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="My own walls can't hold\nme now. ♪", french="My own walls can't hold me\nnow. ♪", german="My own walls can't hold\nme now. ♪", italian="My own walls can't hold\nme now. ♪", spanish="My own walls can't hold\nme now. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mankii, 344, 184, false, 2) -- Move3Position (px absolus)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Thank you. ♪", french=" Thank you. ♪", german=" Thank you. ♪", italian=" Thank you. ♪", spanish=" Thank you. ♪"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", french="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", german="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", italian="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time", spanish="Which Dance should I do?\nNo. 1 Direction Variable   No. 2 Constant\nNo. 3 Time"})
  do local __choice = SkySceneKit.ask({{english="MovePosition-Related", french="MovePosition-Related", german="MovePosition-Related", italian="MovePosition-Related", spanish="MovePosition-Related"}, {english="Move2Position-Related", french="Move2Position-Related", german="Move2Position-Related", italian="Move2Position-Related", spanish="Move2Position-Related"}, {english="Move3Position-Related", french="Move3Position-Related", german="Move3Position-Related", italian="Move3Position-Related", spanish="Move3Position-Related"}, {english="************", french="************", german="************", italian="************", spanish="************"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 or __choice == 5 then
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __choice == 4 then
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Hah?! You won't give me one?!", french=" Hah?! You won't give me one?!", german=" Hah?! You won't give me one?!", italian=" Hah?! You won't give me one?!", spanish=" Hah?! You won't give me one?!"})
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" I'm out of here!", french=" I'm out of here!", german=" I'm out of here!", italian=" I'm out of here!", spanish=" I'm out of here!"})
  -- message_Close
  -- SetHitAttribute(0) [neutre/état moteur]
  -- SetHitAttribute(0) [neutre/état moteur]
  -- supervision_Suspend(-2) [neutre/état moteur]
  else -- default/annulation
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" What, you're holding out?!", french=" What, you're holding out?!", german=" What, you're holding out?!", italian=" What, you're holding out?!", spanish=" What, you're holding out?!"})
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" What, you're holding out on me?!", french=" What, you're holding out on me?!", german=" What, you're holding out on me?!", italian=" What, you're holding out on me?!", spanish=" What, you're holding out on me?!"})
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_mankii) end)
  SkySceneKit.say({english=" Hah?! You canceled? Get lost!", french=" Hah?! You canceled? Get lost!", german=" Hah?! You canceled? Get lost!", italian=" Hah?! You canceled? Get lost!", spanish=" Hah?! You canceled? Get lost!"})
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
