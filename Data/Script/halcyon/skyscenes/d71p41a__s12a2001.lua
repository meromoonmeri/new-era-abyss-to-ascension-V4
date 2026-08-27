-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D71P41A/s12a2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D71P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: se_Play(8194) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING2 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The treasure box contained...[K]\n[CN]a [CS:I]Sky Melodica[CR]!", french="[CN]Le Coffre au Trésor contient...[K]\n[CN]un [CS:I]Aéromélodica[CR]!", german="[CN]Die Schatzbox enthält[K]\n[CN]eine [CS:I]Aeromonika[CR]!", italian="[CN]Il forziere contiene...[K]\n[CN]la [CS:I]Cielmelodica[CR]!", spanish="[CN]El cofre del tesoro contenía...[K]\n[CN]¡una [CS:I]Aeromelódica[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 65, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GIVE_ITEM"] or 0) -- switch(message_Menu(MENU_GIVE_ITEM)) [message_Menu(MENU_GIVE_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw < 50 then
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(36), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING_OUT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(15)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Oh?[K]\n[CN][CS:N]Rayquaza[CR] is saying something.", french="[CN]Oh![K]\n[CN][CS:N]Rayquaza[CR] vous parle.", german="[CN]Oh?[K]\n[CN][CS:N]Rayquaza[CR] will etwas sagen.", italian="[CN]Oh?[K]\n[CN][CS:N]Rayquaza[CR] sta dicendo qualcosa.", spanish="[CN]¿Qué?[K]\n[CN][CS:N]Rayquaza[CR] está diciendo algo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It seemed to develop a kinship\n[CN]with [player] while battling!", french="[CN]Il semble qu'il ait développé\n[CN]des affinités avec [player]\n[CN]lors du combat!", german="[CN]Es scheint eine Verbindung mit [player]\n[CN]während des Kämpfens entwickelt zu haben!", italian="[CN]Sembra che abbia sviluppato un'affinità\n[CN]con [player] durante la lotta!", spanish="[CN]¡Parece haber desarrollado una afinidad\n[CN]con [player] mientras estaba luchando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It says that it wants\n[CN]to join the team!", french="[CN]Il dit qu'il veut\n[CN]rejoindre votre équipe!", german="[CN]Es sagt, es möchte gerne\n[CN]dem Team beitreten!", italian="[CN]Sta dicendo che vuole\n[CN]unirsi alla squadra!", spanish="[CN]¡Dice que quiere\n[CN]unirse al equipo!"})
  -- @label_6 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 19, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se ha unido al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  local npc_npc_rekkuuza = SkySceneKit.spawn_npc("rayquaza", 400, 304, Direction.Down, "NPC_REKKUUZA")
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  -- @label_3 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[39] = 0 -- $SCENARIO_MAIN_BIT_FLAG[39] = 0 (ROM)
  if ((SV.SkyScenarioBitFlags or {})[33] == 1) or ((SV.SkyScenarioBitFlags or {})[34] == 1) or ((SV.SkyScenarioBitFlags or {})[35] == 1) or ((SV.SkyScenarioBitFlags or {})[36] == 1) or ((SV.SkyScenarioBitFlags or {})[37] == 1) or ((SV.SkyScenarioBitFlags or {})[38] == 1) or ((SV.SkyScenarioBitFlags or {})[39] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[33] || $SCENARIO_MAIN_BIT_FLAG[34] |
  -- @label_8 [étiquette de flux ExplorerScript]
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[21] = 1 -- $PERFORMANCE_PROGRESS_LIST[21] = 1 (ROM)
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Etes-vous sûr?[K]\n[CN]Vous ne voulez vraiment pas\n[CN]accepter cette nouvelle recrue?", german="[CN]Bist du sicher?[K]\n[CN]Möchtest du dieses potenzielle neue\n[CN]Mitglied wirklich abweisen?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:N]Rayquaza[CR] was turned down\n[CN]as a team member.", french="[CN]Vous avez refusé l'offre\n[CN]de [CS:N]Rayquaza[CR].", german="[CN][CS:N]Rayquaza[CR] wird\n[CN]als Team-Mitglied abgelehnt.", italian="[CN]Non hai accettato [CS:N]Rayquaza[CR] come nuovo\n[CN]membro della squadra.", spanish="[CN]Has rechazado el ofrecimiento de [CS:N]Rayquaza[CR]\n[CN]de formar parte del equipo."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] obtained\n[CN]a [CS:I]Sky Melodica[CR], one of\n[CN]the seven treasures!", french="[CN][player] obtient\n[CN]un [CS:I]Aéromélodica[CR],\n[CN]un des sept trésors!", german="[CN][player] erhält die\n[CN][CS:I]Aeromonika[CR], einen der sieben\n[CN]Schätze!", italian="[CN][player] ottiene\n[CN]la [CS:I]Cielmelodica[CR], uno dei\n[CN]sette tesori!", spanish="[CN][player] ha obtenido\n[CN]una [CS:I]Aeromelódica[CR],\n[CN]¡uno de los siete tesoros!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
