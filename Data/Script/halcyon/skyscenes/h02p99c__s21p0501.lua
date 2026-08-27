-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(62) [anim idle native]
  -- SetAnimation(62) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(150)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] Earthquake?!", french="Aaah![K] Un tremblement de\nterre?!", german=" Holla![K] Ein Erdbeben?!?", italian=" Waah![K] Un terremoto?!", spanish=" ¡Ah![K] ¡¿Un terremoto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-wah![K] Tremors?!", french="Aaah![K] Un tremblement de\nterre?!", german=" Ua-aah![K] Erschütterungen?!?", italian=" Wa-wah![K] Scosse?!", spanish=" ¡Aaah![K] ¡¿Temblores de tierra?!"})
  else
  SkySceneKit.say({english=" Wa-wah![K] Tremors?!", french="Aaah![K] Un tremblement de\nterre?!", german=" Ua-aah![K] Erschütterungen?!?", italian=" Wa-wah![K] Scosse?!", spanish=" ¡Aaah![K] ¡¿Temblores de tierra?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(80)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 504, 136, Direction.Down, "NPC_PARUKIA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2')
  GAME:FadeIn(15)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Aaaah!", german=" Uaaaah!", italian=" Waaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Aaaah!", german=" Uaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Aaaah!", german=" Uaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I HAVE FOUND YOU AT LAST!", french=" VOUS VOILA ENFIN!", german=" HABE ICH EUCH ENDLICH GEFUNDEN!", italian=" ECCOVI QUI, FINALMENTE!", spanish=" ¡POR FIN OS HE ENCONTRADO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THE DEFILERS WHO ARE CAUSING...[K]\nTHE DISTORTION OF SPACE!", french="LES PROFANATEURS QUI PROVOQUENT...[K]\nLA DISTORSION DE L'ESPACE!", german="DIE SCHÄNDER, DIE... [K]DEN RAUM\nVERZERREN!", italian="SIETE VOI CHE STATE CAUSANDO...[K]\nLA DISTORSIONE DELLO SPAZIO!", spanish="SOIS CULPABLES DE...[K] ¡LA DEFORMACIÓN\nDEL ESPACIO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who are you...?", french=" Qui es-tu...?", german=" Wer bist du?", italian=" Chi sei...?", spanish=" ¿Y tú quién eres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who are you...?", french=" Qui es-tu...?", german=" Wer bist du?", italian=" Chi sei...?", spanish=" ¿Y tú quién eres?"})
  else
  SkySceneKit.say({english=" Who are you...?", french=" Qui es-tu...?", german=" Wer bist du?", italian=" Chi sei...?", spanish=" ¿Y tú quién eres?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I AM [CS:N]PALKIA[CR]![K] I HOLD SWAY OVER SPACE!\nI HAVE DOMINION OVER DIMENSION!", french="JE SUIS [CS:N]PALKIA[CR]![K] JE CONTROLE L'ESPACE!\nJE SUIS LE MAITRE DES DIMENSIONS!", german="ICH BIN [CS:N]PALKIA[CR]![K] ICH HERRSCHE ÜBER\nDEN RAUM! ICH GEBIETE ÜBER DIE DREI\nDIMENSIONEN!", italian="IO SONO [CS:N]PALKIA[CR]![K] REGNO SULLO SPAZIO!\nLA DIMENSIONE È IL MIO REGNO!", spanish="¡YO SOY [CS:N]PALKIA[CR]![K] ¡DUEÑO Y SEÑOR DEL\nESPACIO! ¡DUEÑO Y SEÑOR DE TODAS LAS\nDIMENSIONES!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]P-Palkia[CR]?!)", french="([CS:N]P-Palkia[CR]?!)", german="([CS:N]P-Palkia[CR]?!?)", italian="([CS:N]P-Palkia[CR]?!)", spanish="(¿[CS:N]Pa[CR]... [CS:N]Palkia[CR]?)"})
  else
  SkySceneKit.say({english="([CS:N]P-Palkia[CR]?!)", french="([CS:N]P-Palkia[CR]?!)", german="([CS:N]P-Palkia[CR]?!?)", italian="([CS:N]P-Palkia[CR]?!)", spanish="(¿[CS:N]Pa[CR]... [CS:N]Palkia[CR]?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Y-you're [CS:N]Palkia[CR]?!", french=" T-tu es [CS:N]Palkia[CR]?!", german=" D-du bist [CS:N]Palkia[CR]?!?", italian=" T-Tu sei [CS:N]Palkia[CR]?!", spanish=" ¡¿Tú... tú eres [CS:N]Palkia[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Y-you're [CS:N]Palkia[CR]?!", french=" T-tu es [CS:N]Palkia[CR]?!", german=" D-du bist [CS:N]Palkia[CR]?!?", italian=" T-Tu sei [CS:N]Palkia[CR]?!", spanish=" ¡¿Tú... tú eres [CS:N]Palkia[CR]?!"})
  else
  SkySceneKit.say({english=" Y-you're [CS:N]Palkia[CR]?!", french=" T-tu es [CS:N]Palkia[CR]?!", german=" D-du bist [CS:N]Palkia[CR]?!?", italian=" T-Tu sei [CS:N]Palkia[CR]?!", spanish=" ¡¿Tú... tú eres [CS:N]Palkia[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU CANNOT ESCAPE NOW!\nTHIS IS THE END OF YOU!", french="VOUS NE POUVEZ PLUS FUIR!\nC'EST LA FIN POUR VOUS!", german="IHR KÖNNT NICHT FLIEHEN!\nDIES IST EUER ENDE!", italian="STAVOLTA NON POTETE\nSCAPPARE! È GIUNTA LA VOSTRA FINE!", spanish="¡NO PODÉIS ESCAPAR!\n¡HA LLEGADO VUESTRO FIN!"})
  -- message_KeyWait
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2')
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(8196) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end) -- message_SetActor(ACTOR_NPC_PARUKIA)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(50)
  GAME:FadeOut(true, 15) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaaah!", french=" Aaaah!", german=" Uaaaaaah!", italian=" Waaaaaah!", spanish=" ¡Aaaaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaaah!", french=" Aaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaaah!", french=" Aaaah!", german=" Uaaaaaah!", italian=" Aaaaaaah!", spanish=" ¡Aaaaaaah!"})
  end
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  -- SetPositionOffset<object OBJECT_H02P99C5_120> [prop décor NDS]
  -- GAP: se_Play(8197) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(45)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(240, 220, 60, false) end) -- performer/caméra
  -- MovePositionMark OBJECT_H02P99C5_120 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 0 -- $PERFORMANCE_PROGRESS_LIST[5] = 0 (ROM)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
