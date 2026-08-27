-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/dus03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- @label_11 [étiquette de flux ExplorerScript]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 392, 192, Direction.Down, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="I'm [CS:N]Zubat[CR]. What do you want\nto do?", french="I'm [CS:N]Zubat[CR]. What do you want to\ndo?", german="I'm [CS:N]Zubat[CR]. What do you want\nto do?", italian="I'm [CS:N]Zubat[CR]. What do you want\nto do?", spanish="I'm [CS:N]Zubat[CR]. What do you want to\ndo?"})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="Message Wait Test", french="Message Wait Test", german="Message Wait Test", italian="Message Wait Test", spanish="Message Wait Test"}, {english="Emoticon Test", french="Emoticon Test", german="Emoticon Test", italian="Emoticon Test", spanish="Emoticon Test"}, {english="Message Test", french="Message Test", german="Message Test", italian="Message Test", spanish="Message Test"}, {english="Message Color", french="Message Color", german="Message Color", italian="Message Color", spanish="Message Color"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A5_568) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(140)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A5_568) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(19) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(9) [anim idle native]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 416, 168, Direction.Right, "NPC_PUKURIN")
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  -- StopAnimation() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(768) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(5)
  -- StopAnimation() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(768) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- message_Close
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 88, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 98, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 110, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 126, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 147, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 176, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 221, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 296, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 352, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 442, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(0), 751, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(0), 901, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 88, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 98, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 110, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 126, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 147, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 176, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 221, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 296, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 352, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 442, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(88), g.ViewCenter.Y+(-88), 751, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-88), g.ViewCenter.Y+(88), 901, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- message_Close
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 6 then
  GAME:FadeOut(false, 15)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Narration[CR]", french="[CS:W]Narration[CR]", german="[CS:W]Narration[CR]", italian="[CS:W]Narration[CR]", spanish="[CS:W]Narration[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(100, 30) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CN]Exploration Team Federation\n[CN]has sent a message...", french="[CN]Exploration Team Federation\n[CN]has sent a message...", german="[CN]Exploration Team Federation\n[CN]has sent a message...", italian="[CN]Exploration Team Federation\n[CN]has sent a message...", spanish="[CN]Exploration Team Federation\n[CN]has sent a message..."})
  -- message_Close
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]EXPLANATION[CR]", french="[CS:W]EXPLANATION[CR]", german="[CS:W]EXPLANATION[CR]", italian="[CS:W]EXPLANATION[CR]", spanish="[CS:W]EXPLANATION[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  -- message_SetWaitMode(120, 60) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded\n[CN]with an enlarged Treasure Bag![W:100]", french="[CN]L'équipe de [hero] reçoit\n[CN]un Sac à Trésor plus grand![W:100]", german="[CN]Das Team von [hero] wurde mit einem\n[CN]größeren Schatzbeutel belohnt![W:100]", italian="[CN]La squadra di [hero] riceve come\n[CN]ricompensa una Sacca dei tesori più grande![W:100]", spanish="[CN]¡El equipo de [hero] fue recompensado\n[CN]con una Bolsa mayor![W:100]"})
  -- message_KeyWait
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CN]You can now carry more\n[CN]items than you could before!", french="[CN]You can now carry more\n[CN]items than you could before!", german="[CN]You can now carry more\n[CN]items than you could before!", italian="[CN]Ora puoi trasportare più strumenti\n[CN]di prima!", spanish="[CN]You can now carry more\n[CN]items than you could before!"})
  -- message_Close
  GAME:FadeIn(15)
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 7 then
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Emoticon Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="Emoticon Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="Emoticon Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="Emoticon Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="Emoticon Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Charmander", french="Charmander", german="Charmander", italian="Charmander", spanish="Charmander"}, {english="[CS:N]Ursaring[CR]", french="[CS:N]Ursaring[CR]", german="[CS:N]Ursaring[CR]", italian="[CS:N]Ursaring[CR]", spanish="[CS:N]Ursaring[CR]"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- supervision_Remove(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Exit", french="Exit", german="Exit", italian="Exit", spanish="Exit"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- supervision_Remove(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 392, 160, Direction.Up, "NPC_RINGUMA")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_ringuma, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_ringuma, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_ringuma, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]![CR]", french="[CS:W]![CR]", german="[CS:W]![CR]", italian="[CS:W]![CR]", spanish="[CS:W]![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]?[CR]", french="[CS:W]?[CR]", german="[CS:W]?[CR]", italian="[CS:W]?[CR]", spanish="[CS:W]?[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Celebrate![CR]", french="[CS:W]Celebrate![CR]", german="[CS:W]Celebrate![CR]", italian="[CS:W]Celebrate![CR]", spanish="[CS:W]Celebrate![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Shocked![CR]", french="[CS:W]Shocked![CR]", german="[CS:W]Shocked![CR]", italian="[CS:W]Shocked![CR]", spanish="[CS:W]Shocked![CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Cold sweat[CR]", french="[CS:W]Cold sweat[CR]", german="[CS:W]Cold sweat[CR]", italian="[CS:W]Cold sweat[CR]", spanish="[CS:W]Cold sweat[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Laughter[CR]", french="[CS:W]Laughter[CR]", german="[CS:W]Laughter[CR]", italian="[CS:W]Laughter[CR]", spanish="[CS:W]Laughter[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Anger[CR]", french="[CS:W]Anger[CR]", german="[CS:W]Anger[CR]", italian="[CS:W]Anger[CR]", spanish="[CS:W]Anger[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "angry", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Flustered[CR]", french="[CS:W]Flustered[CR]", german="[CS:W]Flustered[CR]", italian="[CS:W]Flustered[CR]", spanish="[CS:W]Flustered[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="[CS:W]Noticed[CR]", french="[CS:W]Noticed[CR]", german="[CS:W]Noticed[CR]", italian="[CS:W]Noticed[CR]", spanish="[CS:W]Noticed[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Exit", french="Exit", german="Exit", italian="Exit", spanish="Exit"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" See you.", french=" See you.", german=" See you.", italian=" Ci vediamo.", spanish=" See you."})
  -- message_Close
  else -- default/annulation
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 8 then
  -- @label_7 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Message Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="Message Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="Message Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="Message Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="Message Test, huh? Which one?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Message Control", french="Message Control", german="Message Control", italian="Message Control", spanish="Message Control"}, {english="Message Output", french="Message Output", german="Message Output", italian="Message Output", spanish="Message Output"}, {english="Choice Message", french="Choice Message", german="Choice Message", italian="Choice Message", spanish="Choice Message"}, {english="Multiple-Choice Tag", french="Multiple-Choice Tag", german="Multiple-Choice Tag", italian="Multiple-Choice Tag", spanish="Multiple-Choice Tag"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_15 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Message Control, huh? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="Message Control, huh? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="Message Control, huh? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="Message Control, huh? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="Message Control, huh? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Close", french="Close", german="Close", italian="Close", spanish="Close"}, {english="Close Enforce", french="Close Enforce", german="Close Enforce", italian="Close Enforce", spanish="Close Enforce"}, {english="SetActor", french="SetActor", german="SetActor", italian="SetActor", spanish="SetActor"}, {english="SetFace", french="SetFace", german="SetFace", italian="SetFace", spanish="SetFace"}, {english="Next", french="Next", german="Next", italian="Next", spanish="Next"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="It's good-bye if you press\na button.", french="It's good-bye if you press a\nbutton.", german="It's good-bye if you press\na button.", italian="It's good-bye if you press\na button.", spanish="It's good-bye if you press a\nbutton."})
  -- message_Close
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" There's nothing set yet.", french=" There's nothing set yet.", german=" There's nothing set yet.", italian=" There's nothing set yet.", spanish=" There's nothing set yet."})
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="First, you set the\nportrait window.", french="First, you set the portrait\nwindow.", german="First, you set the\nportrait window.", italian="First, you set the\nportrait window.", spanish="First, you set the portrait\nwindow."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end) -- message_SetActor(ACTOR_NPC_ZUBATTO)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" There's no portrait window.", french="There's no portrait window.", german="There's no portrait window.", italian="There's no portrait window.", spanish=" There's no portrait window."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Is this OK?", french=" Is this OK?", german=" Is this OK?", italian=" Is this OK?", spanish=" Is this OK?"})
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- @label_22 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Standard", french="Standard", german="Standard", italian="Standard", spanish="Standard"}, {english="Grin", french="Grin", german="Grin", italian="Grin", spanish="Grin"}, {english="Pained", french="Pained", german="Pained", italian="Pained", spanish="Pained"}, {english="Angry", french="Angry", german="Angry", italian="Angry", spanish="Angry"}, {english="Others", french="Others", german="Others", italian="Others", spanish="Others"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 0\nStandard", french="Expression 0\nStandard", german="Expression 0\nStandard", italian="Expression 0\nStandard", spanish="Expression 0\nStandard"})
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 1\nGrin", french="Expression 1\nGrin", german="Expression 1\nGrin", italian="Expression 1\nGrin", spanish="Expression 1\nGrin"})
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 2\nPained", french="Expression 2\nPained", german="Expression 2\nPained", italian="Expression 2\nPained", spanish="Expression 2\nPained"})
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 3\nAngry", french="Expression 3\nAngry", german="Expression 3\nAngry", italian="Expression 3\nAngry", spanish="Expression 3\nAngry"})
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- @label_28 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Worried", french="Worried", german="Worried", italian="Worried", spanish="Worried"}, {english="Sad", french="Sad", german="Sad", italian="Sad", spanish="Sad"}, {english="Crying", french="Crying", german="Crying", italian="Crying", spanish="Crying"}, {english="Shouting", french="Shouting", german="Shouting", italian="Shouting", spanish="Shouting"}, {english="Others", french="Others", german="Others", italian="Others", spanish="Others"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 4\nWorried", french="Expression 4\nWorried", german="Expression 4\nWorried", italian="Expression 4\nWorried", spanish="Expression 4\nWorried"})
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 5\nSad", french="Expression 5\nSad", german="Expression 5\nSad", italian="Expression 5\nSad", spanish="Expression 5\nSad"})
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 6\nCrying", french="Expression 6\nCrying", german="Expression 6\nCrying", italian="Expression 6\nCrying", spanish="Expression 6\nCrying"})
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 7\nShouting", french="Expression 7\nShouting", german="Expression 7\nShouting", italian="Expression 7\nShouting", spanish="Expression 7\nShouting"})
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- @label_33 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Teary-eyed", french="Teary-eyed", german="Teary-eyed", italian="Teary-eyed", spanish="Teary-eyed"}, {english="Determined", french="Determined", german="Determined", italian="Determined", spanish="Determined"}, {english="Joyous", french="Joyous", german="Joyous", italian="Joyous", spanish="Joyous"}, {english="Inspired", french="Inspired", german="Inspired", italian="Inspired", spanish="Inspired"}, {english="Others", french="Others", german="Others", italian="Others", spanish="Others"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 8\nTeary-eyed", french="Expression 8\nTeary-eyed", german="Expression 8\nTeary-eyed", italian="Expression 8\nTeary-eyed", spanish="Expression 8\nTeary-eyed"})
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 9\nDetermined", french="Expression 9\nDetermined", german="Expression 9\nDetermined", italian="Expression 9\nDetermined", spanish="Expression 9\nDetermined"})
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 10\nJoyous", french="Expression 10\nJoyous", german="Expression 10\nJoyous", italian="Expression 10\nJoyous", spanish="Expression 10\nJoyous"})
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 11\nInspired", french="Expression 11\nInspired", german="Expression 11\nInspired", italian="Expression 11\nInspired", spanish="Expression 11\nInspired"})
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- @label_38 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is your partner Totodile's\nPortrait. What expression do you want?\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Surprised", french="Surprised", german="Surprised", italian="Surprised", spanish="Surprised"}, {english="Dizzy", french="Dizzy", german="Dizzy", italian="Dizzy", spanish="Dizzy"}, {english="Back", french="Back", german="Back", italian="Back", spanish="Back"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 12\nSurprised", french="Expression 12\nSurprised", german="Expression 12\nSurprised", italian="Expression 12\nSurprised", spanish="Expression 12\nSurprised"})
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Expression 13\nDizzy", french="Expression 13\nDizzy", german="Expression 13\nDizzy", italian="Expression 13\nDizzy", spanish="Expression 13\nDizzy"})
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_33 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_28 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 5 then
  -- @label_23 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="This is Message Control.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is Message Control.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is Message Control.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is Message Control.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is Message Control.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="ResetActor", french="ResetActor", german="ResetActor", italian="ResetActor", spanish="ResetActor"}, {english="SetFacePosition", french="SetFacePosition", german="SetFacePosition", italian="SetFacePosition", spanish="SetFacePosition"}, {english="FacePositionOffset", french="FacePositionOffset", german="FacePositionOffset", italian="FacePositionOffset", spanish="FacePositionOffset"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Set just the Portrait Window.", french=" Set just the Portrait Window.", german=" Set just the Portrait Window.", italian=" Set just the Portrait Window.", spanish=" Set just the Portrait Window."})
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Delete!", french=" Delete!", german=" Delete!", italian=" Delete!", spanish=" Delete!"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Set the Portrait Window and\nspeaking character.", french="Set the Portrait Window and\nspeaking character.", german="Set the Portrait Window and\nspeaking character.", italian="Set the Portrait Window and\nspeaking character.", spanish="Set the Portrait Window and\nspeaking character."})
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Delete!", french=" Delete!", german=" Delete!", italian=" Delete!", spanish=" Delete!"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end) -- message_SetActor(ACTOR_NPC_ZUBATTO)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" There's no character portrait.", french=" There's no character portrait.", german=" There's no character portrait.", italian=" There's no character portrait.", spanish=" There's no character portrait."})
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Delete!", french=" Delete!", german=" Delete!", italian=" Delete!", spanish=" Delete!"})
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- @label_43 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Choose the placement position.", french=" Choose the placement position.", german=" Choose the placement position.", italian=" Choose the placement position.", spanish=" Choose the placement position."})
  do local __choice = SkySceneKit.ask({{english="Standard", french="Standard", german="Standard", italian="Standard", spanish="Standard"}, {english="Bottom", french="Bas", german="Unten", italian="Basso", spanish="Abajo"}, {english="Top", french="Haut", german="Oben", italian="Alto", spanish="Arriba"}, {english="Cancel", french="Annuler", german="Zurück", italian="Indietro", spanish="Cancelar"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_SetFacePosition(FACE_POS_STANDARD) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Standard", french=" Standard", german=" Standard", italian=" Standard", spanish=" Estándar"})
  -- message_SetFacePosition(FACE_POS_ABSCOORD) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Absolute Coordinates Standard", french=" Absolute Coordinates Standard", german=" Absolute Coordinates Standard", italian=" Absolute Coordinates Standard", spanish=" Absolute Coordinates Standard"})
  -- message_SetFacePosition(FACE_POS_ABSCOORDFACEL) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Absolute Coordinates Left", french=" Absolute Coordinates Left", german=" Absolute Coordinates Left", italian=" Absolute Coordinates Left", spanish=" Absolute Coordinates Left"})
  -- message_SetFacePosition(FACE_POS_ABSCOORDFACER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Absolute Coordinates Right", french=" Absolute Coordinates Right", german=" Absolute Coordinates Right", italian=" Absolute Coordinates Right", spanish=" Absolute Coordinates Right"})
  -- jump @label_43 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- message_SetFacePosition(FACE_POS_BOTTOM_C_FACER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Center Right-Facing", french=" Bottom Center Right-Facing", german=" Bottom Center Right-Facing", italian=" Bottom Center Right-Facing", spanish=" Bottom Center Right-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_L_FACEINW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Left Inner-Facing", french=" Bottom Left Inner-Facing", german=" Bottom Left Inner-Facing", italian=" Bottom Left Inner-Facing", spanish=" Bottom Left Inner-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_R_FACEINW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Right Inner-Facing", french=" Bottom Right Inner-Facing", german=" Bottom Right Inner-Facing", italian=" Bottom Right Inner-Facing", spanish=" Bottom Right Inner-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_L_CENTER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Left Center", french=" Bottom Left Center", german=" Bottom Left Center", italian=" Bottom Left Center", spanish=" Bottom Left Center"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_R_CENTER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Right Center", french=" Bottom Right Center", german=" Bottom Right Center", italian=" Bottom Right Center", spanish=" Bottom Right Center"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_C_FACEL) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Center Left-Facing", french=" Bottom Center Left-Facing", german=" Bottom Center Left-Facing", italian=" Bottom Center Left-Facing", spanish=" Bottom Center Left-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_L_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Left Outer-Facing", french=" Bottom Left Outer-Facing", german=" Bottom Left Outer-Facing", italian=" Bottom Left Outer-Facing", spanish=" Bottom Left Outer-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_R_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Right Outer-Facing", french=" Bottom Right Outer-Facing", german=" Bottom Right Outer-Facing", italian=" Bottom Right Outer-Facing", spanish=" Bottom Right Outer-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_LC_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Left-Center Outer-Facing", french=" Bottom Left-Center Outer-Facing", german=" Bottom Left-Center Outer-Facing", italian=" Bottom Left-Center Outer-Facing", spanish=" Bottom Left-Center Outer-Facing"})
  -- message_SetFacePosition(FACE_POS_BOTTOM_RC_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Bottom Right-Center Outer-Facing", french=" Bottom Right-Center Outer-Facing", german=" Bottom Right-Center Outer-Facing", italian=" Bottom Right-Center Outer-Facing", spanish=" Bottom Right-Center Outer-Facing"})
  -- jump @label_43 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- message_SetFacePosition(FACE_POS_TOP_C_FACER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Center (Right-Facing)", french=" Top Center (Right-Facing)", german=" Top Center (Right-Facing)", italian=" Top Center (Right-Facing)", spanish=" Top Center (Right-Facing)"})
  -- message_SetFacePosition(FACE_POS_TOP_L_FACEINW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Left Inner-Facing", french=" Top Left Inner-Facing", german=" Top Left Inner-Facing", italian=" Top Left Inner-Facing", spanish=" Top Left Inner-Facing"})
  -- message_SetFacePosition(FACE_POS_TOP_R_FACEINW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Right Inner-Facing", french=" Top Right Inner-Facing", german=" Top Right Inner-Facing", italian=" Top Right Inner-Facing", spanish=" Top Right Inner-Facing"})
  -- message_SetFacePosition(FACE_POS_TOP_L_CENTER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Left Center", french=" Top Left Center", german=" Top Left Center", italian=" Top Left Center", spanish=" Top Left Center"})
  -- message_SetFacePosition(FACE_POS_TOP_R_CENTER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Right Center", french=" Top Right Center", german=" Top Right Center", italian=" Top Right Center", spanish=" Top Right Center"})
  -- message_SetFacePosition(FACE_POS_TOP_C_FACEL) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Center (Left-Facing)", french=" Top Center (Left-Facing)", german=" Top Center (Left-Facing)", italian=" Top Center (Left-Facing)", spanish=" Top Center (Left-Facing)"})
  -- message_SetFacePosition(FACE_POS_TOP_L_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Left-Center Right-Facing", french=" Top Left-Center Right-Facing", german=" Top Left-Center Right-Facing", italian=" Top Left-Center Right-Facing", spanish=" Top Left-Center Right-Facing"})
  -- message_SetFacePosition(FACE_POS_TOP_RC_FACER) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Right-Center Right-Facing", french=" Top Right-Center Right-Facing", german=" Top Right-Center Right-Facing", italian=" Top Right-Center Right-Facing", spanish=" Top Right-Center Right-Facing"})
  -- message_SetFacePosition(FACE_POS_TOP_LC_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Left-Center Outer-Facing", french=" Top Left-Center Outer-Facing", german=" Top Left-Center Outer-Facing", italian=" Top Left-Center Outer-Facing", spanish=" Top Left-Center Outer-Facing"})
  -- message_SetFacePosition(FACE_POS_TOP_RC_FACEOUTW) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Top Right-Center Outer-Facing", french=" Top Right-Center Outer-Facing", german=" Top Right-Center Outer-Facing", italian=" Top Right-Center Outer-Facing", spanish=" Top Right-Center Outer-Facing"})
  -- jump @label_43 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Set the Portrait Window.", french=" Set the Portrait Window.", german=" Set the Portrait Window.", italian=" Set the Portrait Window.", spanish=" Set the Portrait Window."})
  -- message_FacePositionOffset(10, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="The Portrait was moved\n(X: 10). Moving it on the Y-axis will make it\ncover the Message Window.", french="The Portrait was moved\n(X: 10). Moving it on the Y-axis will make it\ncover the Message Window.", german="The Portrait was moved\n(X: 10). Moving it on the Y-axis will make it\ncover the Message Window.", italian="The Portrait was moved\n(X: 10). Moving it on the Y-axis will make it\ncover the Message Window.", spanish="The Portrait was moved\n(X: 10). Moving it on the Y-axis will make it\ncover the Message Window."})
  -- message_FacePositionOffset(0, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" The Portrait was moved back.", french=" The Portrait was moved back.", german=" The Portrait was moved back.", italian=" The Portrait was moved back.", spanish=" The Portrait was moved back."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Right-Facing and on the corner\nis the default position.", french="Right-Facing and on the corner\nis the default position.", german="Right-Facing and on the corner\nis the default position.", italian="Right-Facing and on the corner\nis the default position.", spanish="Right-Facing and on the corner\nis the default position."})
  -- message_FacePositionOffset(20, 10) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Moved the Portrait.\n(X: 20, Y: 10)", french="Moved the Portrait.\n(X: 20, Y: 10)", german="Moved the Portrait.\n(X: 20, Y: 10)", italian="Moved the Portrait.\n(X: 20, Y: 10)", spanish="Moved the Portrait.\n(X: 20, Y: 10)"})
  -- message_FacePositionOffset(0, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="The Portrait was returned to\nthe corner.", french="The Portrait was returned to\nthe corner.", german="The Portrait was returned to\nthe corner.", italian="The Portrait was returned to\nthe corner.", spanish="The Portrait was returned to\nthe corner."})
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- @label_16 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="This is Message Output.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", french="This is Message Output.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", german="This is Message Output.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", italian="This is Message Output.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]", spanish="This is Message Output.\nWhat do you want to do? Choose.\n[CS:E]B Button Cancel: Go back one menu step[CR]"})
  do local __choice = SkySceneKit.ask({{english="Notice", french="Notice", german="Notice", italian="Notice", spanish="Notice"}, {english="Monologue", french="Monologue", german="Monologue", italian="Monologue", spanish="Monologue"}, {english="Talk", french="Talk", german="Talk", italian="Talk", spanish="Talk"}, {english="Mail", french="Mail", german="Mail", italian="Mail", spanish="Mail"}, {english="ImitationSound", french="ImitationSound", german="ImitationSound", italian="ImitationSound", spanish="ImitationSound"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Text is displayed all at once.\nThere is no Portrait Window.", french="Text is displayed all at once.\nThere is no Portrait Window.", german="Text is displayed all at once.\nThere is no Portrait Window.", italian="Text is displayed all at once.\nThere is no Portrait Window.", spanish="Text is displayed all at once.\nThere is no Portrait Window."})
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" It's like this.", french=" It's like this.", german=" It's like this.", italian=" It's like this.", spanish=" It's like this."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You don't get the talking\nsound effect.", french="You don't get the talking sound\neffect.", german="You don't get the talking\nsound effect.", italian="You don't get the talking\nsound effect.", spanish="You don't get the talking sound\neffect."})
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" It's like this.", french=" It's like this.", german=" It's like this.", italian=" It's like this.", spanish=" It's like this."})
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="It's like this. You don't get a\nPortrait Window.", french="It's like this. You don't get a\nPortrait Window.", german="It's like this. You don't get a\nPortrait Window.", italian="It's like this. You don't get a\nPortrait Window.", spanish="It's like this. You don't get a\nPortrait Window."})
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  SkySceneKit.say({english="Kabooooooom!", french="Kabooooooom!", german="Kabooooooom!", italian="Kabooooooom!", spanish="¡Kabooooooom!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You can use that for\nindicating sounds.", french="You can use that for indicating\nsounds.", german="You can use that for\nindicating sounds.", italian="You can use that for\nindicating sounds.", spanish="You can use that for indicating\nsounds."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Incidentally, it shouldn't be\nset to wait for the A Button, but it is.", french="Incidentally, it shouldn't be\nset to wait for the A Button, but it is.", german="Incidentally, it shouldn't be\nset to wait for the A Button, but it is.", italian="Incidentally, it shouldn't be\nset to wait for the A Button, but it is.", spanish="Incidentally, it shouldn't be\nset to wait for the A Button, but it is."})
  SkySceneKit.say({english="The Portrait Window should be\ndisplayed, but it doesn't appear to be set.", french="The Portrait Window should be\ndisplayed, but it doesn't appear to be set.", german="The Portrait Window should be\ndisplayed, but it doesn't appear to be set.", italian="The Portrait Window should be\ndisplayed, but it doesn't appear to be set.", spanish="The Portrait Window should be\ndisplayed, but it doesn't appear to be set."}) -- message_ImitationSound (onomatopée)
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 6 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="The speech will change depending\non the hero and partner characters.", french="The speech will change depending\non the hero and partner characters.", german="The speech will change depending\non the hero and partner characters.", italian="The speech will change depending\non the hero and partner characters.", spanish="The speech will change depending\non the hero and partner characters."})
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I'm disappointed but I'm a boy.)", french="(I'm disappointed but I'm a boy.)", german="(I'm disappointed but I'm a boy.)", italian="(I'm disappointed but I'm a boy.)", spanish="(I'm disappointed but I'm a boy.)"})
  else
  SkySceneKit.say({english="(I'm a girl...)", french="(I'm a girl...)", german="(I'm a girl...)", italian="(I'm a girl...)", spanish="(I'm a girl...)"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm a Type 1 [partner].[K]\nNice to meet you!", french="I'm a Type 1 [partner].[K]\nNice to meet you!", german="Ich bin ein Typ 1-[partner].[K]\nFreut mich, dich kennenzulernen!", italian="I'm a Type 1 [partner].[K]\nNice to meet you!", spanish="I'm a Type 1 [partner].[K]\nNice to meet you!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm a Type 2 [partner].[K]\nNice to meet you!", french="I'm a Type 2 [partner].[K]\nNice to meet you!", german="Ich bin ein Typ 2-[partner].[K]\nFreut mich, dich kennenzulernen!", italian="I'm a Type 2 [partner].[K]\nNice to meet you!", spanish="I'm a Type 2 [partner].[K]\nNice to meet you!"})
  else
  SkySceneKit.say({english="I'm a Type 3 [partner].[K]\nNice to meet you!", french="I'm a Type 3 [partner].[K]\nNice to meet you!", german="Ich bin ein Typ 3-[partner].[K]\nFreut mich, dich kennenzulernen!", italian="I'm a Type 3 [partner].[K]\nNice to meet you!", spanish="I'm a Type 3 [partner].[K]\nNice to meet you!"})
  end
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 4 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="To be added", french="To be added", german="To be added", italian="To be added", spanish="To be added"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 5 then
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 9 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:T]Transparent[CR]\n[CS:D]Standard Color[CR]\n[CS:E]Bold Text[CR]", french="[CS:T]Transparent[CR]\n[CS:D]Standard Color[CR]\n[CS:E]Bold Text[CR]", german="[CS:T]Transparent[CR]\n[CS:D]Standard Color[CR]\n[CS:E]Bold Text[CR]", italian="[CS:T]Transparent[CR]\n[CS:D]Standard Color[CR]\n[CS:E]Bold Text[CR]", spanish="[CS:T]Transparent[CR]\n[CS:D]Standard Color[CR]\n[CS:E]Bold Text[CR]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:C]Caution[CR]\n[CS:W]Warning[CR]\n[CS:F]Team Pokémon Name[CR]", french="[CS:C]Caution[CR]\n[CS:W]Warning[CR]\n[CS:F]Team Pokémon Name[CR]", german="[CS:C]Caution[CR]\n[CS:W]Warning[CR]\n[CS:F]Team Pokémon Name[CR]", italian="[CS:C]Caution[CR]\n[CS:W]Warning[CR]\n[CS:F]Team Pokémon Name[CR]", spanish="[CS:C]Caution[CR]\n[CS:W]Warning[CR]\n[CS:F]Team Pokémon Name[CR]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Pokémon Name[CR]\n[CS:K]Poké Species Name[CR]\n[CS:M]Move Name[CR]", french="[CS:N]Pokémon Name[CR]\n[CS:K]Poké Species Name[CR]\n[CS:M]Move Name[CR]", german="[CS:N]Pokémon Name[CR]\n[CS:K]Poké Species Name[CR]\n[CS:M]Move Name[CR]", italian="[CS:N]Pokémon Name[CR]\n[CS:K]Poké Species Name[CR]\n[CS:M]Move Name[CR]", spanish="[CS:N]Pokémon Name[CR]\n[CS:K]Poké Species Name[CR]\n[CS:M]Move Name[CR]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:P]Place Name[CR]\n[CS:I]Item Name[CR]\n[CS:V]Number[CR]", french="[CS:P]Place Name[CR]\n[CS:I]Item Name[CR]\n[CS:V]Number[CR]", german="[CS:P]Place Name[CR]\n[CS:I]Item Name[CR]\n[CS:V]Number[CR]", italian="[CS:P]Place Name[CR]\n[CS:I]Item Name[CR]\n[CS:V]Number[CR]", spanish="[CS:P]Place Name[CR]\n[CS:I]Item Name[CR]\n[CS:V]Number[CR]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:B]Forbidden Choice[CR]\n[CS:S]Multiple Items Selected[CR]\n[CS:A]Identified Item[CR]", french="[CS:B]Forbidden Choice[CR]\n[CS:S]Multiple Items Selected[CR]\n[CS:A]Identified Item[CR]", german="[CS:B]Forbidden Choice[CR]\n[CS:S]Multiple Items Selected[CR]\n[CS:A]Identified Item[CR]", italian="[CS:B]Forbidden Choice[CR]\n[CS:S]Multiple Items Selected[CR]\n[CS:A]Identified Item[CR]", spanish="[CS:B]Forbidden Choice[CR]\n[CS:S]Multiple Items Selected[CR]\n[CS:A]Identified Item[CR]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:U]Unidentified Item[CR]\n[CS:G]Money[CR]\n[CS:R]Selling Price[CR]", french="[CS:U]Unidentified Item[CR]\n[CS:G]Money[CR]\n[CS:R]Selling Price[CR]", german="[CS:U]Unidentified Item[CR]\n[CS:G]Money[CR]\n[CS:R]Selling Price[CR]", italian="[CS:U]Unidentified Item[CR]\n[CS:G]Money[CR]\n[CS:R]Selling Price[CR]", spanish="[CS:U]Unidentified Item[CR]\n[CS:G]Money[CR]\n[CS:R]Selling Price[CR]"})
  -- message_Close
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 10 then
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" All right.", french=" All right.", german=" All right.", italian=" Va bene.", spanish=" All right."})
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Oh, you canceled? Leaving me\nlonesome again...", french="Oh, you canceled? Leaving me\nlonesome again...", german="Oh, you canceled? Leaving me\nlonesome again...", italian="Oh, you canceled? Leaving me\nlonesome again...", spanish="Oh, you canceled? Leaving me\nlonesome again..."})
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
