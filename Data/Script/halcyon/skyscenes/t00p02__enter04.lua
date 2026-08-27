-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P02/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_TALK_MAIN
    -- debug_Print('LIVES_REPLY_NORMAL_A') [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    -- TurnDirection(32767) [mouvement directionnel de routine: idle figurant]
    -- debug_Print('LIVES_REPLY_NORMAL_A_HOLD') [neutre/état moteur]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_TALK_SUB
    -- debug_Print('LIVES_REPLY_NORMAL_B') [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    -- TurnDirection(32767) [mouvement directionnel de routine: idle figurant]
    -- debug_Print('LIVES_REPLY_NORMAL_B_HOLD') [neutre/état moteur]
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What can I help you with today?", french="What can I help you with today?", german="What can I help you with today?", italian="What can I help you with today?", spanish="What can I help you with today?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Yes", italian="Yes", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Do you really need help with anything?", french="Do you really need help with anything?", german="Do you really need help with anything?", italian="Do you really need help with anything?", spanish="Do you really need help with anything?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Yes", italian="Yes", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I can't help you with anything right now.", french="I can't help you with anything right now.", german="I can't help you with anything right now.", italian="I can't help you with anything right now.", spanish="I can't help you with anything right now."})
  -- @label_3 [étiquette de flux ExplorerScript]
  -- debug_Print('END_TALK') [neutre/état moteur]
  -- message_Close
  -- debug_Print('SUSPEND_START') [neutre/état moteur]
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- debug_Print('SUSPEND_END') [neutre/état moteur]
  end
  end
  end
  end
  SkySceneKit.join_routines()
end
