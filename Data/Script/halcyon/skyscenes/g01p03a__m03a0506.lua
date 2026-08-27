-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0506.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GROUND:EntTurn(partner, Direction.Up)
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- ResetHitAttribute(31) [neutre/état moteur]
    -- SetAnimation(3) [anim idle native]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(1)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(1)
    do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
    if __sw == 1 then
    -- break_loop [contrôle de boucle forever NDS: une itération compilée]
    elseif true then -- default
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
    end
    end
    -- @label_0 [étiquette de flux ExplorerScript]
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V03P02A) [décor sub chargé: Sub_v03p02a]
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 472, 224, Direction.Left, "NPC_BIPPA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySubScreen.Show("v03p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, is that so?", french=" Oh, vraiment?", german=" Oh, ist er das?", italian=" Oh, davvero?", spanish=" ¿Ah, sí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, is that so?", french=" Oh, vraiment?", german=" Oh, ist er das?", italian=" Oh, davvero?", spanish=" ¿Ah, sí?"})
  else
  SkySceneKit.say({english=" Oh, is that so?", french=" Oh, vraiment?", german=" Oh, ist er das?", italian=" Oh, davvero?", spanish=" ¿Ah, sí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- GAP: se_Play(6415) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(15)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 424, 248, Direction.Up, "NPC_DAGUTORIO")
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end) -- message_SetActor(ACTOR_NPC_DAGUTORIO)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Update completed! Stand clear!", french=" Mise à jour terminée! Reculez!", german="Aktualisierung fertig!\nZurücktreten!", italian="Aggiornamento completato! State\nlontani!", spanish=" ¡Tablones listos! ¡A un lado!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Update completed! Stand clear!", french=" Mise à jour terminée! Reculez!", german="Aktualisierung fertig!\nZurücktreten!", italian="Aggiornamento completato! State\nlontani!", spanish=" ¡Tablones listos! ¡A un lado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, looks like he's done.", french=" Ah, on dirait qu'il a fini.", german=" Oh, er scheint fertig zu sein.", italian=" Oh, sembra che abbia finito.", spanish=" Parece que ya ha acabado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, looks like he's done.", french=" Ah, on dirait qu'il a fini.", german=" Oh, er scheint fertig zu sein.", italian=" Oh, sembra che abbia finito.", spanish=" Parece que ya ha acabado."})
  else
  SkySceneKit.say({english=" Oh, looks like he's done.", french=" Ah, on dirait qu'il a fini.", german=" Oh, er scheint fertig zu sein.", italian=" Oh, sembra che abbia finito.", spanish=" Parece que ya ha acabado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- bgm2_Play(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(45)
  -- bgm2_Stop [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(6416) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P03A1_100) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(9) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yes sirree! The data is updated.", french="Ouaip ouaip! Les infos, elles ont\nété mises à jour.", german="Ja wirklich! Die Daten sind\naktualisiert.", italian="Sissignore! I dati sono\nstati aggiornati.", spanish="¡Sí, señor! Tenemos listas\nnuevas."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The list of outlaws has been\nrefreshed, so let's pick one.", french="Maintenant que la liste des\nhors-la-loi a été actualisée, on peut en\nchoisir un.", german="Die Ganovenliste ist jetzt auf\ndem neuesten Stand, also suchen wir einen aus.", italian="La lista dei ricercati è stata\naggiornata, quindi scegliamone uno.", spanish="Ya ha sido renovada la lista de\nmalhechores, así que podemos escoger uno."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh? What's ailing you?[K] Why\nare you shivering all of a sudden?", french="Sapristi![K] Mais tu trembles\ncomme une feuille, pardi! T'as d'la fièvre\nou quoi?", german="Äh? Was ist denn los?[K]\nWarum zitterst du denn plötzlich?", italian="Eh? Cosa ti turba?[K] Perché hai\niniziato a tremare di punto in bianco?", spanish="¿Eh? ¿Qué pasa?[K]\n¿Por qué te has echado a temblar?"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  SkySceneKit.spin(npc_npc_bippa, 3, 2, 2)
  GAME:WaitFrames(20)
  SkySceneKit.spin(npc_npc_bippa, 3, 1, 3)
  GAME:WaitFrames(30)
  SkySceneKit.spin(npc_npc_bippa, 3, 2, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" It's not cold here, after all.", french="Pourtant il fait pas si\nfroid que ça ici, j'trouve...", german=" Es ist doch nicht kalt hier.", italian=" Non fa freddo qui.", spanish=" No hace tanto frío."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="T-t-take a look at this,\n[hero]!", french="Re... regarde ça,\n[hero]!", german=" S-sieh dir das an, [hero]!", italian="D-D-Dai un'occhiata qui,\n[hero]!", spanish=" ¡Mi... mira esto, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" L-l-look at this, [hero]!", french="Re... regarde ça,\n[hero]!", german=" S-sieh dir das an, [hero]!", italian="Guarda qui,\n[hero]!", spanish=" ¡Mi... mira esto, [hero]!"})
  else
  SkySceneKit.say({english="P-p-please look at this,\n[hero]!", french="Re... regarde ça,\n[hero]!", german="B-b-bitte schau mal da,\n[hero]!", italian="Hai visto qui,\n[hero]?", spanish=" ¡Mi... mira esto, [hero]!"})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetGround(V03P01A) [décor sub chargé: Sub_v03p01a]
  -- camera2_SetPositionMark(Position<'m1', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v03p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Up top! On the left!", french=" Tout en haut! A gauche!", german=" Oben! Auf der linken Seite!", italian=" In alto! A sinistra!", spanish=" ¡Arriba! ¡A la izquierda!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" At the top! On the left!", french=" Tout en haut! A gauche!", german=" Ganz oben! Auf der linken Seite!", italian=" In alto! A sinistra!", spanish=" ¡Arriba! ¡A la izquierda!"})
  else
  SkySceneKit.say({english=" At the top! On the left!", french=" Tout en haut! A gauche!", german=" Ganz oben! Auf der linken Seite!", italian=" In alto! A sinistra!", spanish=" ¡Arriba! ¡A la izquierda!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V03P04A) [décor sub chargé: Sub_v03p04a]
  -- camera2_SetPositionMark(Position<'m2', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v03p04a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's [CS:N]Drowzee[CR]![K] H-he's a\nwanted criminal!", french="[CS:N]Soporifik[CR]![K] C'est un criminel\nrecherché!", german="Das ist [CS:N]Traumato[CR]![K] E-er ist ein\ngesuchter Verbrecher!", italian="Quello è [CS:N]Drowzee[CR]![K] È un\nricercato!", spanish="¡Es [CS:N]Drowzee[CR]![K] ¡Ahí dice\nque es un bandido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's [CS:N]Drowzee[CR]![K] H-he's a\nwanted criminal!", french="[CS:N]Soporifik[CR]![K] C'est un criminel\nrecherché!", german="Das ist [CS:N]Traumato[CR]![K] E-er ist ein\ngesuchter Verbrecher!", italian="Quello è [CS:N]Drowzee[CR]![K] È un\nricercato!", spanish="¡Es [CS:N]Drowzee[CR]![K]\n¡Lo busca la justicia!"})
  else
  SkySceneKit.say({english="It's [CS:N]Drowzee[CR]![K] H-he's a\nwanted criminal!", french="[CS:N]Soporifik[CR]![K] C'est un criminel\nrecherché!", german="Das ist [CS:N]Traumato[CR]![K] E-er ist ein\ngesuchter Verbrecher!", italian="Quello è [CS:N]Drowzee[CR]![K] È un\nricercato!", spanish="¡Es [CS:N]Drowzee[CR]![K]\n¡Es un maleante!"})
  end
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to get moving! [CS:N]Azurill[CR]\nwill be in serious trouble!", french="On doit se dépêcher! [CS:N]Azurill[CR]\nest en grand danger!", german="Wir müssen los! [CS:N]Azurill[CR]\nist in ernsthaften Schwierigkeiten!", italian="Dobbiamo andare! [CS:N]Azurill[CR]\nsarà nei guai!", spanish="¡Tenemos que ir a por él!\n¡[CS:N]Azurill[CR] corre un serio peligro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to get moving! [CS:N]Azurill[CR]\nwill be in danger!", french="On doit se dépêcher! [CS:N]Azurill[CR]\nest en grand danger!", german="Wir müssen los! [CS:N]Azurill[CR]\nist in ernsthaften Schwierigkeiten!", italian="Dobbiamo andare! [CS:N]Azurill[CR]\nsarà nei guai!", spanish="¡Tenemos que ir a por él!\n¡[CS:N]Azurill[CR] corre un serio peligro!"})
  else
  SkySceneKit.say({english="We have to hurry! [CS:N]Azurill[CR] will\nbe in trouble!", french="On doit se dépêcher! [CS:N]Azurill[CR]\nest en grand danger!", german="Wir müssen uns beeilen! [CS:N]Azurill[CR]\nist in ernsthaften Schwierigkeiten!", italian="Dobbiamo andare! [CS:N]Azurill[CR]\nsarà nei guai!", spanish="¡Tenemos que ir a por él!\n¡[CS:N]Azurill[CR] corre un serio peligro!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 332, 220, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 332, 220, false, 2)
  GROUND:MoveToPosition(partner, 332, 124, false, 2)
  GROUND:MoveToPosition(hero, 332, 124, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-32), false, 2) end -- Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Now what's going on?", french=" Ben quoi?", german=" Was ist denn jetzt los?", italian=" Adesso cosa c'è?", spanish=" ¿Pero qué pasa?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Where are you all off to?", french="Où est-ce que vous allez comme\nça?", german=" Wohin rennt ihr denn?", italian=" Dove staranno andando?", spanish=" ¿Adónde vais?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[3] = 1 -- $PERFORMANCE_PROGRESS_LIST[3] = 1 (ROM)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
