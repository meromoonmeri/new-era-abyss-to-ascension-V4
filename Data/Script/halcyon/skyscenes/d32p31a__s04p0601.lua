-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P31A/s04p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D32P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7950) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A3_86) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- MovePositionMark OBJECT_D32P44A3_86 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A3_86) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(30)
  -- se_FadeOut(7950, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]A mysterious light\n[CN]enveloped [player]!", french="[CN]Une lumière mystérieuse\n[CN]enveloppe [player]!", german="[CN]Ein mysteriöses Licht\n[CN]umhüllt [player]!", italian="[CN]Una luce misteriosa\n[CN]avvolge [player]!", spanish="[CN]¡Una luz misteriosa\n[CN]ha envuelto a [player]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7951) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A3_86) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The guardian's permission was granted!", french="[CN]Le gardien vous accorde le droit de continuer!", german="[CN]Der Torwächter gewährt seine Erlaubnis!", italian="[CN]Hai ottenuto il permesso del guardiano!", spanish="[CN]¡Has conseguido el permiso del guardián!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if (SkyProg.cmp(29, 67) < 0) then -- if ROM: scn($SCENARIO_MAIN) < [29, 67]
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() GAME:MoveCamera(180, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(10)
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(612, 268, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 612, 124, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  else
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw < 50 then
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]........................", french="[CN]........................", german="[CN]........................", italian="[CN]........................", spanish="[CN]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]A voice echoed from somewhere...", french="[CN]Une voix retentit de nulle part...", german="[CN]Eine Stimme schallt von irgendwoher...", italian="[CN]Si sente una voce echeggiare in lontananza...", spanish="[CN]Un eco proveniente de algún lugar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING_OUT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(15)
  local npc_npc_rejiaisu = SkySceneKit.spawn_npc("regice", 184, 216, Direction.Down, "NPC_REJIAISU")
  pcall(function() UI:SetSpeaker(npc_npc_rejiaisu) end)
  SkySceneKit.say({english=" I AM [CS:N]REGICE[CR]...", french=" JE SUIS [CS:N]REGICE[CR]...", german=" ICH BIN [CS:N]REGICE[CR]...", italian=" IO SONO [CS:N]REGICE[CR]...", spanish=" YO SOY [CS:N]REGICE[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_rejiaisu) end)
  SkySceneKit.say({english=" I PLEDGE...SERVICE TO YOU...", french=" JE VOUS DOIS... ALLEGEANCE...", german="ICH VERSPRECHE, DIR ZU\nDIENEN...", italian=" MI IMPEGNO A... SERVIRTI...", spanish=" PROMETO SERVIROS..."})
  -- @label_4 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_rejiaisu) end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] si unisce alla squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se ha unido al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejiaisu) end)
  SkySceneKit.say({english="[CN]Are you sure?[K]\n[CN]You're sure you won't accept\n[CN]this potential new member?", french="[CN]Etes-vous sûr?[K]\n[CN]Vous ne voulez vraiment pas\n[CN]accepter cette nouvelle recrue?", german="[CN]Bist du sicher?[K]\n[CN]Möchtest du dieses potenzielle neue\n[CN]Mitglied wirklich abweisen?", italian="[CN]Davvero?[K]\n[CN]Confermi di non voler accettare\n[CN]questo potenziale nuovo membro?", spanish="[CN]¿Seguro?[K]\n[CN]¿Seguro que prefieres que no\n[CN]se incorpore al equipo?"})
  do local __choice = SkySceneKit.ask({{english="Reconsider", french="Reconsidérer", german="Überdenken", italian="Ripensaci", spanish="Reconsiderar"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rejiaisu) end)
  SkySceneKit.say({english="[CN][player] turned down\n[CN][CS:N]Regice[CR]'s offer to join.", french="[CN][player] refuse l'offre\n[CN]de [CS:N]Regice[CR].", german="[CN][player] lehnt das Beitrittsangebot von\n[CN][CS:N]Regice[CR] ab.", italian="[CN][player] rifiuta\n[CN]l'offerta di [CS:N]Regice[CR].", spanish="[CN][player] declinó el ofrecimiento de\n[CN][CS:N]Regice[CR]."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_WHITE_LIGHT_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
