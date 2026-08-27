-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/hdebug.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D41P41A, 'HUS') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(true, 16) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(5)
  GAME:FadeIn(16)
  pcall(function() GAME:MoveCamera(280, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 184, 176, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- @label_16 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_14 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Yes", french="Yes", german="Yes", italian="Sì", spanish="Yes"}, {english="No", french="No", german="No", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 2) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  end
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 280, 190, false, 2)
  GROUND:MoveToPosition(partner, 264, 200, false, 2)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(280, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(true, 16) -- screen_WhiteOut
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:FadeIn(16)
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(3), p.Y+(25), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(3), p.Y+(25), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  local npc_npc_yamikarasu = SkySceneKit.spawn_npc("murkrow", 328, 200, Direction.Left, "NPC_YAMIKARASU")
  GROUND:EntTurn(npc_npc_yamikarasu, Direction.Down)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 240, 200, Direction.DownRight, "NPC_YAMIRAMI")
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  local npc_npc_kabutopusu = SkySceneKit.spawn_npc("kabutops", 280, 264, Direction.Up, "NPC_KABUTOPUSU")
  GROUND:EntTurn(npc_npc_kabutopusu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 16) -- screen_WhiteOut
  GAME:FadeIn(16)
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_rejirokku = SkySceneKit.spawn_npc("regirock", 280, 376, Direction.Up, "NPC_REJIROKKU")
  pcall(function() local p=npc_npc_rejirokku.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_REJIROKKU
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 248, 384, Direction.Up, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 312, 384, Direction.Up, "NPC_KOOTASU")
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() local p=npc_npc_yamikarasu.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_YAMIKARASU
  GROUND:MoveToPosition(npc_npc_rejirokku, 328, 192, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7172) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, "shock", 1) end)
  do local p=npc_npc_yamikarasu.Position; GROUND:MoveToPosition(npc_npc_yamikarasu, p.X+(120), p.Y+(340), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_rejirokku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local p=npc_npc_emuritto.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_EMURITTO
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() local p=npc_npc_yamirami.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_YAMIRAMI
  GROUND:MoveToPosition(npc_npc_emuritto, 240, 192, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  -- GAP: se_Play(7172) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(144), p.Y+(396), false, 2) end -- SlidePositionOffset
  GAME:FadeIn(2)
  GAME:WaitFrames(2)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_emuritto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local p=npc_npc_kootasu.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_KOOTASU
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local p=npc_npc_kabutopusu.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_KABUTOPUSU
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kabutopusu, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(16)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kabutopusu, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kabutopusu.Position; GROUND:MoveToPosition(npc_npc_kabutopusu, p.X+(0), p.Y+(56), false, 2) end
  do local p=npc_npc_kootasu.Position; GROUND:MoveToPosition(npc_npc_kootasu, p.X+(-32), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  pcall(function() local p=npc_npc_kootasu.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_KOOTASU
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: se_Play(7172) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kabutopusu, "shock", 1) end)
  do local p=npc_npc_kabutopusu.Position; GROUND:MoveToPosition(npc_npc_kabutopusu, p.X+(144), p.Y+(396), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rejirokku, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_emuritto, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kootasu.Position; GROUND:MoveToPosition(npc_npc_kootasu, p.X+(0), p.Y+(-88), false, 2) end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- message_Close
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rejirokku, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_emuritto, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rejirokku) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rejirokku, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_emuritto, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_rejirokku, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_emuritto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(16)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rejirokku, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_emuritto, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(280, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Destroy() [neutre/état moteur]
  -- CallCommon CORO_EVENT_END_MAPIN (fermeture/attente message: géré par say())
  -- main_SetGround(LEVEL_D41P41A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- supervision_ExecuteStationCommon(LEVEL_D41P41A, 1) [exécution de station sans cible littérale: harnais journey]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 160, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 280, 200, Direction.Up, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  -- SlidePositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 256, 156, false, 1)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_daakurai, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_daakurai, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, npc_npc_daakurai, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_daakurai, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 296, 196, false, 1)
  GROUND:MoveToPosition(hero, 280, 172, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  do local __choice = SkySceneKit.ask({{english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}, {english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 30)
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 30)
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_7 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_8 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).HERO_TALK_KIND or 0) -- switch($HERO_TALK_KIND) [GameVar HERO_TALK_KIND (genre héros)]
  if __sw == 4 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- @label_11 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeIn(0)
  GROUND:TeleportTo(partner, 264, 220, Direction.Down)
  GROUND:TeleportTo(npc_npc_kureseria, 296, 220, Direction.Down)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(13) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-12), false, 2) end -- SlidePositionOffset
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_daakurai, 280, 164, false, 2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:MoveToPosition(hero, 280, 196, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(68) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  else
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 30)
  -- supervision_Acting(11) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  else
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0] ", french="[M:D0] ", german="[M:D0] ", italian="[M:D0] ", spanish="[M:D0] "})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  elseif true then -- default
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[M:D0]", french="[M:D0]", german="[M:D0]", italian="[M:D0]", spanish="[M:D0]"})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
