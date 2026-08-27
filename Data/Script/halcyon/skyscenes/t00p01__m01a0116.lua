-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0116.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_19 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An event will be activated.\nWhich one would you like to see?", french="An event will be activated.\nWhich one would you like to see?", german="An event will be activated.\nWhich one would you like to see?", italian="An event will be activated.\nWhich one would you like to see?", spanish="An event will be activated.\nWhich one would you like to see?"})
  do local __choice = SkySceneKit.ask({{english="ACTING_TEST", french="ACTING_TEST", german="ACTING_TEST", italian="ACTING_TEST", spanish="ACTING_TEST"}, {english="STATION_TEST", french="STATION_TEST", german="STATION_TEST", italian="STATION_TEST", spanish="STATION_TEST"}, {english="SOUND_TEST", french="SOUND_TEST", german="SOUND_TEST", italian="SOUND_TEST", spanish="SOUND_TEST"}, {english="DUNGEON_OPEN", french="DUNGEON_OPEN", german="DUNGEON_OPEN", italian="DUNGEON_OPEN", spanish="DUNGEON_OPEN"}, {english="VISUAL_TEST", french="VISUAL_TEST", german="VISUAL_TEST", italian="VISUAL_TEST", spanish="VISUAL_TEST"}, {english="PARTY_TEST", french="PARTY_TEST", german="PARTY_TEST", italian="PARTY_TEST", spanish="PARTY_TEST"}, {english="WORLD_MAP", french="WORLD_MAP", german="WORLD_MAP", italian="WORLD_MAP", spanish="WORLD_MAP"}, {english="KEY_WAIT", french="KEY_WAIT", german="KEY_WAIT", italian="KEY_WAIT", spanish="KEY_WAIT"}, {english="MIST_FADE", french="MIST_FADE", german="MIST_FADE", italian="MIST_FADE", spanish="MIST_FADE"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An Acting Test will be activated.\nWhich one would you like?", french="An Acting Test will be activated.\nWhich one would you like?", german="An Acting Test will be activated.\nWhich one would you like?", italian="An Acting Test will be activated.\nWhich one would you like?", spanish="An Acting Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="M01A01A", french="M01A01A", german="M01A01A", italian="M01A01A", spanish="M01A01A"}, {english="M01A02A", french="M01A02A", german="M01A02A", italian="M01A02A", spanish="M01A02A"}, {english="M01A03A", french="M01A03A", german="M01A03A", italian="M01A03A", spanish="M01A03A"}, {english="M01A04A", french="M01A04A", german="M01A04A", italian="M01A04A", spanish="M01A04A"}, {english="M01A05A", french="M01A05A", german="M01A05A", italian="M01A05A", spanish="M01A05A"}, {english="M01A06A", french="M01A06A", german="M01A06A", italian="M01A06A", spanish="M01A06A"}, {english="M01A07A", french="M01A07A", german="M01A07A", italian="M01A07A", spanish="M01A07A"}, {english="M01A08A", french="M01A08A", german="M01A08A", italian="M01A08A", spanish="M01A08A"}, {english="M01A09A", french="M01A09A", german="M01A09A", italian="M01A09A", spanish="M01A09A"}, {english="M01A10A", french="M01A10A", german="M01A10A", italian="M01A10A", spanish="M01A10A"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- debug_Print('EXECUTE_T00P01_M01A01A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a01a00", "t00p01__m01a01a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A01A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 2 then
  -- debug_Print('EXECUTE_T00P01_M01A02A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a02a00", "t00p01__m01a02a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A02A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- debug_Print('EXECUTE_T00P01_M01A03A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a03a00", "t00p01__m01a03a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A03A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- debug_Print('EXECUTE_T00P01_M01A04A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a04a00", "t00p01__m01a04a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A04A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- debug_Print('EXECUTE_T00P01_M01A05A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a05a00", "t00p01__m01a05a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A05A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- debug_Print('EXECUTE_T00P01_M01A06A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a06a00", "t00p01__m01a06a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A06A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- debug_Print('EXECUTE_T00P01_M01A07A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a07a00", "t00p01__m01a07a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A07A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- debug_Print('EXECUTE_T00P01_M01A08A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a08a00", "t00p01__m01a08a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A08A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  -- debug_Print('EXECUTE_T00P01_M01A09A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a09a00", "t00p01__m01a09a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A09A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  -- debug_Print('EXECUTE_T00P01_M01A10A') [neutre/état moteur]
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a10a00", "t00p01__m01a10a", hero, partner) -- supervision_ExecuteActing(LEVEL_T00P01, 'M01A10A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Station Test will be activated.\nWhich one would you like?", french="A Station Test will be activated.\nWhich one would you like?", german="A Station Test will be activated.\nWhich one would you like?", italian="A Station Test will be activated.\nWhich one would you like?", spanish="A Station Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="STATION_01", french="STATION_01", german="STATION_01", italian="STATION_01", spanish="STATION_01"}, {english="STATION_02", french="STATION_02", german="STATION_02", italian="STATION_02", spanish="STATION_02"}, {english="REMOVE_01", french="REMOVE_01", german="REMOVE_01", italian="REMOVE_01", spanish="REMOVE_01"}, {english="REMOVE_02", french="REMOVE_02", german="REMOVE_02", italian="REMOVE_02", spanish="REMOVE_02"}, {english="STATION_M01A02_0", french="STATION_M01A02_0", german="STATION_M01A02_0", italian="STATION_M01A02_0", spanish="STATION_M01A02_0"}, {english="STATION_M01A02_1", french="STATION_M01A02_1", german="STATION_M01A02_1", italian="STATION_M01A02_1", spanish="STATION_M01A02_1"}, {english="STATION_M01A02_2", french="STATION_M01A02_2", german="STATION_M01A02_2", italian="STATION_M01A02_2", spanish="STATION_M01A02_2"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- message_Close
  -- debug_Print('STATION_01') [neutre/état moteur]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- message_Close
  -- debug_Print('STATION_02') [neutre/état moteur]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- message_Close
  -- debug_Print('REMOVE_01') [neutre/état moteur]
  -- supervision_Remove(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- message_Close
  -- debug_Print('REMOVE_02') [neutre/état moteur]
  -- supervision_Remove(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a0200", "t00p01__m01a02", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A02', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a0201", "t00p01__m01a02", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A02', 1) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a0202", "t00p01__m01a02", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A02', 2) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Sound Test will be activated.\nWhich one would you like?", french="A Sound Test will be activated.\nWhich one would you like?", german="A Sound Test will be activated.\nWhich one would you like?", italian="A Sound Test will be activated.\nWhich one would you like?", spanish="A Sound Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="BGM1", french="BGM1", german="BGM1", italian="BGM1", spanish="BGM1"}, {english="BGM2", french="BGM2", german="BGM2", italian="BGM2", spanish="BGM2"}, {english="ME", french="ME", german="ME", italian="ME", spanish="ME"}, {english="SE", french="SE", german="SE", italian="SE", spanish="SE"}, {english="SPECIAL", french="SPECIAL", german="SPECIAL", italian="SPECIAL", spanish="ESPECIAL"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A BGM Test will be activated.\nWhich one would you like?", french="A BGM Test will be activated.\nWhich one would you like?", german="A BGM Test will be activated.\nWhich one would you like?", italian="A BGM Test will be activated.\nWhich one would you like?", spanish="A BGM Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="BGM_PLAY", french="BGM_PLAY", german="BGM_PLAY", italian="BGM_PLAY", spanish="BGM_PLAY"}, {english="BGM_FADEIN", french="BGM_FADEIN", german="BGM_FADEIN", italian="BGM_FADEIN", spanish="BGM_FADEIN"}, {english="BGM_STOP", french="BGM_STOP", german="BGM_STOP", italian="BGM_STOP", spanish="BGM_STOP"}, {english="BGM_FADEOUT", french="BGM_FADEOUT", german="BGM_FADEOUT", italian="BGM_FADEOUT", spanish="BGM_FADEOUT"}, {english="BGM_WAIT", french="BGM_WAIT", german="BGM_WAIT", italian="BGM_WAIT", spanish="BGM_WAIT"}, {english="BGM_CHANGE", french="BGM_CHANGE", german="BGM_CHANGE", italian="BGM_CHANGE", spanish="BGM_CHANGE"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() SOUND:PlayBGM("Boss Battle.ogg", true) end)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- GAP: BGM BGM_ON_THE_CEILING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  pcall(function() SOUND:StopBGM() end)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  -- GAP: BGM BGM_MISSION_FAILURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- bgm_ChangeVolume(120,80) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:WaitFrames(120)
  -- bgm_ChangeVolume(120,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:WaitFrames(120)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A BGM2 Test will be activated.\nWhich one would you like?", french="A BGM2 Test will be activated.\nWhich one would you like?", german="A BGM2 Test will be activated.\nWhich one would you like?", italian="A BGM2 Test will be activated.\nWhich one would you like?", spanish="A BGM2 Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="BGM2_PLAY", french="BGM2_PLAY", german="BGM2_PLAY", italian="BGM2_PLAY", spanish="BGM2_PLAY"}, {english="BGM2_FADEIN", french="BGM2_FADEIN", german="BGM2_FADEIN", italian="BGM2_FADEIN", spanish="BGM2_FADEIN"}, {english="BGM2_STOP", french="BGM2_STOP", german="BGM2_STOP", italian="BGM2_STOP", spanish="BGM2_STOP"}, {english="BGM2_FADEOUT", french="BGM2_FADEOUT", german="BGM2_FADEOUT", italian="BGM2_FADEOUT", spanish="BGM2_FADEOUT"}, {english="BGM2_WAIT", french="BGM2_WAIT", german="BGM2_WAIT", italian="BGM2_WAIT", spanish="BGM2_WAIT"}, {english="BGM2_CHANGE", french="BGM2_CHANGE", german="BGM2_CHANGE", italian="BGM2_CHANGE", spanish="BGM2_CHANGE"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- bgm2_Play(BGM_BOSS_BATTLE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- bgm2_PlayFadeIn(BGM_VIBRATING_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- bgm2_Stop [canal BGM sub: voir bgm2_Play]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  -- bgm2_Play(BGM_MISSION_SUCCESS) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(2) -- join WaitBgm2
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- bgm2_ChangeVolume(120, 80) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(120)
  -- bgm2_ChangeVolume(120, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(120)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 3 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An ME Test will be activated.\nWhich one would you like?", french="An ME Test will be activated.\nWhich one would you like?", german="An ME Test will be activated.\nWhich one would you like?", italian="An ME Test will be activated.\nWhich one would you like?", spanish="An ME Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="ME_PLAY", french="ME_PLAY", german="ME_PLAY", italian="ME_PLAY", spanish="ME_PLAY"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(0) [jingle ME NDS -> fanfare PMDO]
  GAME:WaitFrames(2) -- join WaitMe
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="An SE Test will be activated.\nWhich one would you like?", french="An SE Test will be activated.\nWhich one would you like?", german="An SE Test will be activated.\nWhich one would you like?", italian="An SE Test will be activated.\nWhich one would you like?", spanish="An SE Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="SE_PLAY", french="SE_PLAY", german="SE_PLAY", italian="SE_PLAY", spanish="SE_PLAY"}, {english="SE_STOP", french="SE_STOP", german="SE_STOP", italian="SE_STOP", spanish="SE_STOP"}, {english="SE_FADEOUT", french="SE_FADEOUT", german="SE_FADEOUT", italian="SE_FADEOUT", spanish="SE_FADEOUT"}, {english="SE_WAIT", french="SE_WAIT", german="SE_WAIT", italian="SE_WAIT", spanish="SE_WAIT"}, {english="SE_PLAY_VOLUME", french="SE_PLAY_VOLUME", german="SE_PLAY_VOLUME", italian="SE_PLAY_VOLUME", spanish="SE_PLAY_VOLUME"}, {english="SE_PLAY_PAN", french="SE_PLAY_PAN", german="SE_PLAY_PAN", italian="SE_PLAY_PAN", spanish="SE_PLAY_PAN"}, {english="SE_CHANGE_VOLUME", french="SE_CHANGE_VOLUME", german="SE_CHANGE_VOLUME", italian="SE_CHANGE_VOLUME", spanish="SE_CHANGE_VOLUME"}, {english="SE_CHANGE_PAN", french="SE_CHANGE_PAN", german="SE_CHANGE_PAN", italian="SE_CHANGE_PAN", spanish="SE_CHANGE_PAN"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(120)
  -- se_Stop(5131) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(60)
  -- se_FadeOut(5130, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 1", french="SE Play 1", german="SE Play 1", italian="SE Play 1", spanish="SE Play 1"})
  -- GAP: se_Play(4890) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 2", french="SE Play 2", german="SE Play 2", italian="SE Play 2", spanish="SE Play 2"})
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Se Play 3", french="Se Play 3", german="Se Play 3", italian="Se Play 3", spanish="Se Play 3"})
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 1", french="SE Play 1", german="SE Play 1", italian="SE Play 1", spanish="SE Play 1"})
  -- se_PlayFull(4890, 256, 0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 2", french="SE Play 2", german="SE Play 2", italian="SE Play 2", spanish="SE Play 2"})
  -- se_PlayFull(4890, 128, 0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Se Play 3", french="Se Play 3", german="Se Play 3", italian="Se Play 3", spanish="Se Play 3"})
  -- se_PlayFull(4890, 64, 0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 1", french="SE Play 1", german="SE Play 1", italian="SE Play 1", spanish="SE Play 1"})
  -- se_PlayFull(4890, 256, 0) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 2", french="SE Play 2", german="SE Play 2", italian="SE Play 2", spanish="SE Play 2"})
  -- se_PlayFull(4890, 256, -256) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Se Play 3", french="Se Play 3", german="Se Play 3", italian="Se Play 3", spanish="Se Play 3"})
  -- se_PlayFull(4890, 256, 256) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 4", french="SE Play 4", german="SE Play 4", italian="SE Play 4", spanish="SE Play 4"})
  -- se_PlayFull(4890, 256, -128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="SE Play 5", french="SE Play 5", german="SE Play 5", italian="SE Play 5", spanish="SE Play 5"})
  -- se_PlayFull(4890, 256, 128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 7 then
  SkySceneKit.say({english="Change Volume Test", french="Modifier le volume du test", german="Change Volume Test", italian="Change Volume Test", spanish="Change Volume Test"}) -- message_ImitationSound (onomatopée)
  -- GAP: se_Play(5130, 256) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Lower", french="Moins fort", german="Lower", italian="Lower", spanish="Lower"}) -- message_ImitationSound (onomatopée)
  -- se_ChangeVolume(5130, 120, 128) [canal SE NDS: one-shots PMDO, volume non scriptable]
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Higher", french="Plus fort", german="Higher", italian="Higher", spanish="Higher"}) -- message_ImitationSound (onomatopée)
  -- se_ChangeVolume(5130, 120, 256) [canal SE NDS: one-shots PMDO, volume non scriptable]
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Lower", french="Moins fort", german="Lower", italian="Lower", spanish="Lower"}) -- message_ImitationSound (onomatopée)
  -- se_ChangeVolume(5130, 240, 0) [canal SE NDS: one-shots PMDO, volume non scriptable]
  GAME:WaitFrames(240)
  SkySceneKit.say({english="Stop", french="Stop", german="Stop", italian="Stop", spanish="Stop"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="Higher", french="Plus fort", german="Higher", italian="Higher", spanish="Higher"}) -- message_ImitationSound (onomatopée)
  -- se_ChangeVolume(5130, 240, 128) [canal SE NDS: one-shots PMDO, volume non scriptable]
  GAME:WaitFrames(240)
  SkySceneKit.say({english="Stop", french="Stop", german="Stop", italian="Stop", spanish="Stop"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(120)
  -- se_Stop(5130) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 8 then
  SkySceneKit.say({english="Change Pan Test", french="Changer le test panoramique", german="Change Pan Test", italian="Change Pan Test", spanish="Change Pan Test"}) -- message_ImitationSound (onomatopée)
  -- se_PlayPan(5130, 0) [neutre/état moteur]
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Right", french="Droite", german="Right", italian="Right", spanish="Right"}) -- message_ImitationSound (onomatopée)
  -- se_ChangePan(5130, 120, 128) [neutre/état moteur]
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Left", french="Gauche", german="Left", italian="Left", spanish="Left"}) -- message_ImitationSound (onomatopée)
  -- se_ChangePan(5130, 120, -128) [neutre/état moteur]
  GAME:WaitFrames(120)
  SkySceneKit.say({english="Right", french="Droite", german="Right", italian="Right", spanish="Right"}) -- message_ImitationSound (onomatopée)
  -- se_ChangePan(5130, 240, 256) [neutre/état moteur]
  GAME:WaitFrames(240)
  SkySceneKit.say({english="Stop", french="Stop", german="Stop", italian="Stop", spanish="Stop"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="Left", french="Gauche", german="Left", italian="Left", spanish="Left"}) -- message_ImitationSound (onomatopée)
  -- se_ChangePan(5130, 240, -256) [neutre/état moteur]
  GAME:WaitFrames(240)
  SkySceneKit.say({english="Stop", french="Stop", german="Stop", italian="Stop", spanish="Stop"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(120)
  -- se_Stop(5130) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 5 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Sound Test will be activated.\nWhich one would you like?", french="A Sound Test will be activated.\nWhich one would you like?", german="A Sound Test will be activated.\nWhich one would you like?", italian="A Sound Test will be activated.\nWhich one would you like?", spanish="A Sound Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="SOUND_STOP", french="SOUND_STOP", german="SOUND_STOP", italian="SOUND_STOP", spanish="SOUND_STOP"}, {english="SOUND_FADEOUT", french="SOUND_FADEOUT", german="SOUND_FADEOUT", italian="SOUND_FADEOUT", spanish="SOUND_FADEOUT"}, {english="BGM_SIGNAL", french="BGM_SIGNAL", german="BGM_SIGNAL", italian="BGM_SIGNAL", spanish="BGM_SIGNAL"}, {english="ERROR_TEST", french="ERROR_TEST", german="ERROR_TEST", italian="ERROR_TEST", spanish="ERROR_TEST"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() SOUND:StopBGM() end)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="BGM Play", french="BGM Play", german="BGM Play", italian="BGM Play", spanish="BGM Play"})
  -- GAP: BGM BGM_POKEMON_EXPLORATION_TEAM_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="BGM Signal Reception", french="BGM Signal Reception", german="BGM Signal Reception", italian="BGM Signal Reception", spanish="BGM Signal Reception"})
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="BGM End", french="BGM End", german="BGM End", italian="BGM End", spanish="BGM End"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:W]Memo: Test 1[CR]", french="[CS:W]Memo: Test 1[CR]", german="[CS:W]Memo: Test 1[CR]", italian="[CS:W]Memo: Test 1[CR]", spanish="[CS:W]Memo: Test 1[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:W]Memo: Test 2[CR]", french="[CS:W]Memo: Test 2[CR]", german="[CS:W]Memo: Test 2[CR]", italian="[CS:W]Memo: Test 2[CR]", spanish="[CS:W]Memo: Test 2[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 4 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The Dungeon Mode will be set.\nWhich one would you like?", french="The Dungeon Mode will be set.\nWhich one would you like?", german="The Dungeon Mode will be set.\nWhich one would you like?", italian="The Dungeon Mode will be set.\nWhich one would you like?", spanish="The Dungeon Mode will be set.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="ALL_CLOSE", french="ALL_CLOSE", german="ALL_CLOSE", italian="ALL_CLOSE", spanish="ALL_CLOSE"}, {english="ALL_SCENARIO", french="ALL_SCENARIO", german="ALL_SCENARIO", italian="ALL_SCENARIO", spanish="ALL_SCENARIO"}, {english="ALL_RANDOM", french="ALL_RANDOM", german="ALL_RANDOM", italian="ALL_RANDOM", spanish="ALL_RANDOM"}, {english="TYPE1", french="TYPE1", german="TYPE1", italian="TYPE1", spanish="TYPE1"}, {english="D006B_CLOSE", french="D006B_CLOSE", german="D006B_CLOSE", italian="D006B_CLOSE", spanish="D006B_CLOSE"}, {english="D006B_SCENARIO", french="D006B_SCENARIO", german="D006B_SCENARIO", italian="D006B_SCENARIO", spanish="D006B_SCENARIO"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[0] = 0 -- dungeon_mode(0) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 0 -- dungeon_mode(1) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[2] = 0 -- dungeon_mode(2) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 0 -- dungeon_mode(3) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 0 -- dungeon_mode(4) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[5] = 0 -- dungeon_mode(5) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 0 -- dungeon_mode(6) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 0 -- dungeon_mode(7) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 0 -- dungeon_mode(8) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[9] = 0 -- dungeon_mode(9) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 0 -- dungeon_mode(10) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[11] = 0 -- dungeon_mode(11) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 0 -- dungeon_mode(12) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[13] = 0 -- dungeon_mode(13) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 0 -- dungeon_mode(14) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[15] = 0 -- dungeon_mode(15) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[16] = 0 -- dungeon_mode(16) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 0 -- dungeon_mode(17) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[18] = 0 -- dungeon_mode(18) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[19] = 0 -- dungeon_mode(19) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 0 -- dungeon_mode(20) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 0 -- dungeon_mode(21) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[22] = 0 -- dungeon_mode(22) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[23] = 0 -- dungeon_mode(23) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 0 -- dungeon_mode(24) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 0 -- dungeon_mode(25) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[26] = 0 -- dungeon_mode(26) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[27] = 0 -- dungeon_mode(27) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[28] = 0 -- dungeon_mode(28) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[29] = 0 -- dungeon_mode(29) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[30] = 0 -- dungeon_mode(30) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[31] = 0 -- dungeon_mode(31) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[32] = 0 -- dungeon_mode(32) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[33] = 0 -- dungeon_mode(33) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 0 -- dungeon_mode(34) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 0 -- dungeon_mode(35) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[36] = 0 -- dungeon_mode(36) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[37] = 0 -- dungeon_mode(37) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[38] = 0 -- dungeon_mode(38) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[39] = 0 -- dungeon_mode(39) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[40] = 0 -- dungeon_mode(40) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[41] = 0 -- dungeon_mode(41) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[42] = 0 -- dungeon_mode(42) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[43] = 0 -- dungeon_mode(43) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[44] = 0 -- dungeon_mode(44) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[45] = 0 -- dungeon_mode(45) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[46] = 0 -- dungeon_mode(46) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[47] = 0 -- dungeon_mode(47) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[48] = 0 -- dungeon_mode(48) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[49] = 0 -- dungeon_mode(49) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[50] = 0 -- dungeon_mode(50) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[51] = 0 -- dungeon_mode(51) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[52] = 0 -- dungeon_mode(52) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[53] = 0 -- dungeon_mode(53) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[54] = 0 -- dungeon_mode(54) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[55] = 0 -- dungeon_mode(55) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[56] = 0 -- dungeon_mode(56) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[57] = 0 -- dungeon_mode(57) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[58] = 0 -- dungeon_mode(58) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[59] = 0 -- dungeon_mode(59) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[60] = 0 -- dungeon_mode(60) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[61] = 0 -- dungeon_mode(61) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[62] = 0 -- dungeon_mode(62) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[63] = 0 -- dungeon_mode(63) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[64] = 0 -- dungeon_mode(64) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[65] = 0 -- dungeon_mode(65) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[66] = 0 -- dungeon_mode(66) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[67] = 0 -- dungeon_mode(67) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[68] = 0 -- dungeon_mode(68) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[69] = 0 -- dungeon_mode(69) = DMODE_CLOSED (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 2 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[0] = 1 -- dungeon_mode(0) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 1 -- dungeon_mode(1) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 1 -- dungeon_mode(3) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 1 -- dungeon_mode(4) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 1 -- dungeon_mode(6) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 1 -- dungeon_mode(7) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 1 -- dungeon_mode(8) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[9] = 1 -- dungeon_mode(9) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 1 -- dungeon_mode(10) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[11] = 1 -- dungeon_mode(11) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 1 -- dungeon_mode(12) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[13] = 1 -- dungeon_mode(13) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 1 -- dungeon_mode(14) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[15] = 1 -- dungeon_mode(15) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 1 -- dungeon_mode(17) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[18] = 1 -- dungeon_mode(18) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 1 -- dungeon_mode(20) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 1 -- dungeon_mode(21) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[22] = 1 -- dungeon_mode(22) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 1 -- dungeon_mode(24) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 1 -- dungeon_mode(25) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[27] = 1 -- dungeon_mode(27) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[28] = 1 -- dungeon_mode(28) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[29] = 1 -- dungeon_mode(29) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[30] = 1 -- dungeon_mode(30) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[32] = 1 -- dungeon_mode(32) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[33] = 1 -- dungeon_mode(33) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 1 -- dungeon_mode(34) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 1 -- dungeon_mode(35) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[36] = 1 -- dungeon_mode(36) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[38] = 1 -- dungeon_mode(38) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[39] = 1 -- dungeon_mode(39) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[41] = 1 -- dungeon_mode(41) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[42] = 1 -- dungeon_mode(42) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[44] = 1 -- dungeon_mode(44) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[46] = 1 -- dungeon_mode(46) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[47] = 1 -- dungeon_mode(47) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[50] = 1 -- dungeon_mode(50) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[51] = 1 -- dungeon_mode(51) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[54] = 1 -- dungeon_mode(54) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[55] = 1 -- dungeon_mode(55) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[56] = 1 -- dungeon_mode(56) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[57] = 1 -- dungeon_mode(57) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[58] = 1 -- dungeon_mode(58) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[59] = 1 -- dungeon_mode(59) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[60] = 1 -- dungeon_mode(60) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[61] = 1 -- dungeon_mode(61) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[62] = 1 -- dungeon_mode(62) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[63] = 1 -- dungeon_mode(63) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[64] = 1 -- dungeon_mode(64) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[65] = 1 -- dungeon_mode(65) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[67] = 1 -- dungeon_mode(67) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[68] = 1 -- dungeon_mode(68) = DMODE_OPEN (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[0] = 3 -- dungeon_mode(0) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[2] = 2 -- dungeon_mode(2) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 3 -- dungeon_mode(3) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 3 -- dungeon_mode(4) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[5] = 2 -- dungeon_mode(5) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[6] = 3 -- dungeon_mode(6) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 3 -- dungeon_mode(7) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[8] = 3 -- dungeon_mode(8) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[9] = 3 -- dungeon_mode(9) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[10] = 3 -- dungeon_mode(10) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[11] = 3 -- dungeon_mode(11) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 3 -- dungeon_mode(12) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[13] = 3 -- dungeon_mode(13) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 3 -- dungeon_mode(14) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[15] = 3 -- dungeon_mode(15) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[16] = 2 -- dungeon_mode(16) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 3 -- dungeon_mode(17) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[18] = 3 -- dungeon_mode(18) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[19] = 2 -- dungeon_mode(19) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 3 -- dungeon_mode(20) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 3 -- dungeon_mode(21) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[22] = 3 -- dungeon_mode(22) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[23] = 2 -- dungeon_mode(23) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 3 -- dungeon_mode(24) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 3 -- dungeon_mode(25) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[26] = 2 -- dungeon_mode(26) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[27] = 3 -- dungeon_mode(27) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[28] = 3 -- dungeon_mode(28) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[29] = 3 -- dungeon_mode(29) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[30] = 3 -- dungeon_mode(30) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[31] = 2 -- dungeon_mode(31) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[32] = 3 -- dungeon_mode(32) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[33] = 3 -- dungeon_mode(33) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 3 -- dungeon_mode(34) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[35] = 3 -- dungeon_mode(35) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[36] = 3 -- dungeon_mode(36) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[37] = 2 -- dungeon_mode(37) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[38] = 3 -- dungeon_mode(38) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[39] = 3 -- dungeon_mode(39) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[40] = 2 -- dungeon_mode(40) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[41] = 3 -- dungeon_mode(41) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[42] = 3 -- dungeon_mode(42) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[43] = 2 -- dungeon_mode(43) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[44] = 3 -- dungeon_mode(44) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[45] = 2 -- dungeon_mode(45) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[46] = 3 -- dungeon_mode(46) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[47] = 3 -- dungeon_mode(47) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[48] = 2 -- dungeon_mode(48) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[49] = 2 -- dungeon_mode(49) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[50] = 3 -- dungeon_mode(50) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[51] = 3 -- dungeon_mode(51) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[52] = 2 -- dungeon_mode(52) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[53] = 2 -- dungeon_mode(53) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[54] = 3 -- dungeon_mode(54) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[55] = 3 -- dungeon_mode(55) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[56] = 3 -- dungeon_mode(56) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[57] = 3 -- dungeon_mode(57) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[58] = 3 -- dungeon_mode(58) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[59] = 3 -- dungeon_mode(59) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[60] = 3 -- dungeon_mode(60) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[61] = 3 -- dungeon_mode(61) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[62] = 3 -- dungeon_mode(62) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[63] = 3 -- dungeon_mode(63) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[64] = 3 -- dungeon_mode(64) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[65] = 3 -- dungeon_mode(65) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[66] = 2 -- dungeon_mode(66) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[67] = 3 -- dungeon_mode(67) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[68] = 3 -- dungeon_mode(68) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[69] = 2 -- dungeon_mode(69) = DMODE_REQUEST (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[0] = 3 -- dungeon_mode(0) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[2] = 2 -- dungeon_mode(2) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 1 -- dungeon_mode(3) = DMODE_OPEN (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 0 -- dungeon_mode(4) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[5] = 0 -- dungeon_mode(5) = DMODE_CLOSED (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[212] = 0 -- dungeon_mode(212) = DMODE_CLOSED (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[212] = 1 -- dungeon_mode(212) = DMODE_OPEN (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 5 then
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Visual Test will be activated.\nWhich one would you like?", french="A Visual Test will be activated.\nWhich one would you like?", german="A Visual Test will be activated.\nWhich one would you like?", italian="A Visual Test will be activated.\nWhich one would you like?", spanish="A Visual Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="NEXT", french="NEXT", german="NEXT", italian="NEXT", spanish="NEXT"}, {english="V00P01_M01A01A", french="V00P01_M01A01A", german="V00P01_M01A01A", italian="V00P01_M01A01A", spanish="V00P01_M01A01A"}, {english="V00P01_M01A02A", french="V00P01_M01A02A", german="V00P01_M01A02A", italian="V00P01_M01A02A", spanish="V00P01_M01A02A"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Visual Test will be activated.\nWhich one would you like?", french="A Visual Test will be activated.\nWhich one would you like?", german="A Visual Test will be activated.\nWhich one would you like?", italian="A Visual Test will be activated.\nWhich one would you like?", spanish="A Visual Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="NEXT", french="NEXT", german="NEXT", italian="NEXT", spanish="NEXT"}, {english="V00P02_M01A01A", french="V00P02_M01A01A", german="V00P02_M01A01A", italian="V00P02_M01A01A", spanish="V00P02_M01A01A"}, {english="V00P02_M01A02A", french="V00P02_M01A02A", german="V00P02_M01A02A", italian="V00P02_M01A02A", spanish="V00P02_M01A02A"}, {english="V00P02_M01A03A", french="V00P02_M01A03A", german="V00P02_M01A03A", italian="V00P02_M01A03A", spanish="V00P02_M01A03A"}, {english="V00P02_M01A04A", french="V00P02_M01A04A", german="V00P02_M01A04A", italian="V00P02_M01A04A", spanish="V00P02_M01A04A"}, {english="V00P02_M01A05A", french="V00P02_M01A05A", german="V00P02_M01A05A", italian="V00P02_M01A05A", spanish="V00P02_M01A05A"}, {english="V00P02_M01A06A", french="V00P02_M01A06A", german="V00P02_M01A06A", italian="V00P02_M01A06A", spanish="V00P02_M01A06A"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Visual Test will be activated.\nWhich one would you like?", french="A Visual Test will be activated.\nWhich one would you like?", german="A Visual Test will be activated.\nWhich one would you like?", italian="A Visual Test will be activated.\nWhich one would you like?", spanish="A Visual Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="NEXT", french="NEXT", german="NEXT", italian="NEXT", spanish="NEXT"}, {english="V00P03_M01A01A", french="V00P03_M01A01A", german="V00P03_M01A01A", italian="V00P03_M01A01A", spanish="V00P03_M01A01A"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p03__m01a01a00", "v00p03__m01a01a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P03, 'M01A01A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a01a00", "v00p02__m01a01a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A01A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a02a00", "v00p02__m01a02a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A02A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a03a00", "v00p02__m01a03a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A03A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a04a00", "v00p02__m01a04a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A04A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a05a00", "v00p02__m01a05a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A05A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a06a00", "v00p02__m01a06a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A06A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p01__m01a01a00", "v00p01__m01a01a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P01, 'M01A01A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p01__m01a02a00", "v00p01__m01a02a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P01, 'M01A02A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 6 then
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Party Test will be activated.\nWhich one would you like?", french="A Party Test will be activated.\nWhich one would you like?", german="A Party Test will be activated.\nWhich one would you like?", italian="A Party Test will be activated.\nWhich one would you like?", spanish="A Party Test will be activated.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="NEXT", french="NEXT", german="NEXT", italian="NEXT", spanish="NEXT"}, {english="PLAYER_HERO", french="PLAYER_HERO", german="PLAYER_HERO", italian="PLAYER_HERO", spanish="PLAYER_HERO"}, {english="PLAYER_APPOINT", french="PLAYER_APPOINT", german="PLAYER_APPOINT", italian="PLAYER_APPOINT", spanish="PLAYER_APPOINT"}, {english="ATTENDANT1_NONE", french="ATTENDANT1_NONE", german="ATTENDANT1_NONE", italian="ATTENDANT1_NONE", spanish="ATTENDANT1_NONE"}, {english="ATTENDANT1_PARTNER", french="ATTENDANT1_PARTNER", german="ATTENDANT1_PARTNER", italian="ATTENDANT1_PARTNER", spanish="ATTENDANT1_PARTNER"}, {english="ATTENDANT2_NONE", french="ATTENDANT2_NONE", german="ATTENDANT2_NONE", italian="ATTENDANT2_NONE", spanish="ATTENDANT2_NONE"}, {english="ATTENDANT2_MANAFI", french="ATTENDANT2_MANAFI", german="ATTENDANT2_MANAFI", italian="ATTENDANT2_MANAFI", spanish="ATTENDANT2_MANAFI"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="A Party Test will be activated for adding\na new team member.\nWhich one would you like?", french="A Party Test will be activated for adding\na new team member.\nWhich one would you like?", german="A Party Test will be activated for adding\na new team member.\nWhich one would you like?", italian="A Party Test will be activated for adding\na new team member.\nWhich one would you like?", spanish="A Party Test will be activated for adding\na new team member.\nWhich one would you like?"})
  do local __choice = SkySceneKit.ask({{english="NEXT", french="NEXT", german="NEXT", italian="NEXT", spanish="NEXT"}, {english="CHECK_LIVES_EXIST", french="CHECK_LIVES_EXIST", german="CHECK_LIVES_EXIST", italian="CHECK_LIVES_EXIST", spanish="CHECK_LIVES_EXIST"}, {english="CHECK_LIVES_LEVEL", french="CHECK_LIVES_LEVEL", german="CHECK_LIVES_LEVEL", italian="CHECK_LIVES_LEVEL", spanish="CHECK_LIVES_LEVEL"}, {english="JOIN_LIVES", french="JOIN_LIVES", german="JOIN_LIVES", italian="JOIN_LIVES", spanish="JOIN_LIVES"}, {english="CHECK_HERO", french="CHECK_HERO", german="CHECK_HERO", italian="CHECK_HERO", spanish="CHECK_HERO"}, {english="CHECK_PARTNER", french="CHECK_PARTNER", german="CHECK_PARTNER", italian="CHECK_PARTNER", spanish="CHECK_PARTNER"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_T) [ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_MANAFI] isn't in the team.", french="[CN][c_name:NPC_MANAFI] ne fait pas partie de l'équipe.", german="[CN][c_name:NPC_MANAFI] ist nicht Teil des Teams.", italian="[CN][c_name:NPC_MANAFI] non è in squadra.", spanish="[CN][c_name:NPC_MANAFI] isn't in the team."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_MANAFI] is in the team.", french="[CN][c_name:NPC_MANAFI] is in the team.", german="[CN][c_name:NPC_MANAFI] is in the team.", italian="[CN][c_name:NPC_MANAFI] è in squadra.", spanish="[CN][c_name:NPC_MANAFI] is in the team."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 3 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RECURITABLE_CURRENT_LEVEL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RECURITABLE_CUR) [ProcessSpecial(PROCESS_SPECIAL_GET_RECURITABLE_CURRENT_LEVEL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_MANAFI] is Level 1.", french="[CN][c_name:NPC_MANAFI] est au niveau 1.", german="[CN][c_name:NPC_MANAFI] ist nicht Teil des Teams.", italian="[CN][c_name:NPC_MANAFI] è di L. 1.", spanish="[CN][c_name:NPC_MANAFI] is Level 1."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw >= 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_MANAFI] is at least Level 2.", french="[CN][c_name:NPC_MANAFI] is at least Level 2.", german="[CN][c_name:NPC_MANAFI] is at least Level 2.", italian="[CN][c_name:NPC_MANAFI] è almeno di L. 2.", spanish="[CN][c_name:NPC_MANAFI] is at least Level 2."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_MANAFI] is not here.", french="[CN][c_name:NPC_MANAFI] n'est pas là.", german="[CN][c_name:NPC_MANAFI] ist nicht Teil des Teams.", italian="[CN][c_name:NPC_MANAFI] non c'è.", spanish="[CN][c_name:NPC_MANAFI] is not here."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 4 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ADD_RECRUITABLE_TO_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_RECRUITABLE_TO_) [ProcessSpecial(PROCESS_SPECIAL_ADD_RECRUITABLE_TO_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]", french="[CN]", german="[CN]", italian="[CN]", spanish="[CN]"})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team.", french="[CN][c_name:NPC_NEW_FRIEND] joined the team.", german="[CN][c_name:NPC_NEW_FRIEND] joined the team.", italian="[CN][c_name:NPC_NEW_FRIEND] ora fa parte della squadra!", spanish="[CN][c_name:NPC_NEW_FRIEND] joined the team."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 5 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_HERO_KIND"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND, 0, 0) [ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's Torchic.", french="It's Torchic.", german="It's Torchic.", italian="It's Torchic.", spanish="It's Torchic."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's Charmander.", french="It's Charmander.", german="It's Charmander.", italian="It's Charmander.", spanish="It's Charmander."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's something else.", french="It's something else.", german="It's something else.", italian="It's something else.", spanish="It's something else."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __choice == 6 then
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_PARTNER_KIND"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_PARTNER_KIND, 0) [ProcessSpecial(PROCESS_SPECIAL_GET_PARTNER_KIND): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's Torchic.", french="It's Torchic.", german="It's Torchic.", italian="It's Torchic.", spanish="It's Torchic."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's Charmander.", french="It's Charmander.", german="It's Charmander.", italian="It's Charmander.", spanish="It's Charmander."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's something else.", french="It's something else.", german="It's something else.", italian="It's something else.", spanish="It's something else."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 2 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PLAYER_KIND = 0 -- $PLAYER_KIND = 0 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PLAYER_KIND = 3 -- $PLAYER_KIND = 3 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 4 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT1_KIND = 0 -- $ATTENDANT1_KIND = 0 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 5 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT1_KIND = 2 -- $ATTENDANT1_KIND = 2 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 6 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT2_KIND = 0 -- $ATTENDANT2_KIND = 0 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 7 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT2_KIND = 10 -- $ATTENDANT2_KIND = 10 (ROM)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __choice == 7 then
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("v00p02__m01a06a00", "v00p02__m01a06a", hero, partner) -- supervision_ExecuteActing(LEVEL_V00P02, 'M01A06A', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  -- debug_Print('Talk1') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_INIT, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_PRESS, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- debug_Print('Talk2') [neutre/état moteur]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_INIT, 160, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- @label_95 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  GAME:WaitFrames(1)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_KEY_WAIT_CHECK"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_CHECK, 0, ) [ProcessSpecial(PROCESS_SPECIAL_KEY_WAIT_CHECK): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif true then -- default
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- debug_Print('Talk3') [neutre/état moteur]
  -- jump @label_19 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 9 then
  -- back_SetWeather(11) [météo visuelle ground NDS - documenté]
  GAME:WaitFrames(120)
  GAME:WaitFrames(240) -- back_SetEffect(17, 240) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(240)
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I see...", french="I see...", german="I see...", italian="I see...", spanish="I see..."})
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
end
