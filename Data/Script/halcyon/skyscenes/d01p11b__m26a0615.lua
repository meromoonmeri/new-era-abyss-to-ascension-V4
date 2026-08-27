-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0615.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    -- SetOutputAttribute(2) [neutre/état moteur]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(3) [anim idle native]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
    do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
    GAME:WaitFrames(2)
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
    SkySceneKit.lock(6) -- Lock(6) NDS
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
    -- SetAnimation(81) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(30)
    GROUND:EntTurn(partner, Direction.Right)
    GAME:WaitFrames(8)
    SkySceneKit.lock(8) -- Lock(8) NDS
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
    SkySceneKit.lock(9) -- Lock(9) NDS
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
    -- SetAnimation(81) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    SkySceneKit.lock(10) -- Lock(10) NDS
    GAME:WaitFrames(1) -- hold
  end)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 720, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 720, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I remember it all so fondly.", french="Quand j'y repense, l'émotion\nme submerge.", german=" Das sind so schöne Erinnerungen.", italian="Ricordo tutto con grande\nnostalgia.", spanish=" ¡Qué buenos recuerdos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I remember it all so fondly.", french="Quand j'y repense, l'émotion\nme submerge.", german=" Das sind so schöne Erinnerungen.", italian="Ricordo tutto con grande\nnostalgia.", spanish=" ¡Qué buenos recuerdos!"})
  else
  SkySceneKit.say({english=" I remember it all so fondly.", french="Quand j'y repense, l'émotion\nme submerge.", german=" Das sind so schöne Erinnerungen.", italian="Ricordo tutto con grande\nnostalgia.", spanish=" ¡Qué buenos recuerdos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All those memories of my time\nwith [hero]...", french="Tous ces souvenirs du temps\npassé avec [hero]...", german="All diese Erinnerungen an meine\nZeit mit [hero]...", italian="Tutti questi ricordi del tempo\npassato con [hero]...", spanish="Recuerdos de mi tiempo con\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All those memories of my time\nwith [hero]...", french="Tous ces souvenirs du temps\npassé avec [hero]...", german="All diese Erinnerungen an meine\nZeit mit [hero]...", italian="Tutti questi ricordi del tempo\npassato con [hero]...", spanish="Recuerdos de mi tiempo con\n[hero]..."})
  else
  SkySceneKit.say({english="All those memories of my time\nwith [hero]...", french="Tous ces souvenirs du temps\npassé avec [hero]...", german="All diese Erinnerungen an meine\nZeit mit [hero]...", italian="Tutti questi ricordi del tempo\npassato con [hero]...", spanish="Recuerdos de mi tiempo con\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Memories...[K]of [hero]...", french="... Tant de souvenirs...[K]\nde [hero]...", german="Erinnerungen...[K]\nan [hero]...", italian=" Ricordi...[K] di [hero]...", spanish=" Recuerdos...[K] de [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Memories...[K]of [hero]...", french="... Tant de souvenirs...[K]\nde [hero]...", german="Erinnerungen...[K]\nan [hero]...", italian=" Ricordi...[K] di [hero]...", spanish=" Recuerdos...[K] de [hero]..."})
  else
  SkySceneKit.say({english=" ...Memories...[K]of [hero]...", french="... Tant de souvenirs...[K]\nde [hero]...", german="Erinnerungen...[K]\nan [hero]...", italian=" Ricordi...[K] di [hero]...", spanish=" Recuerdos...[K] de [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if SV.SkyVars then SV.SkyVars.EVENT_LOCAL = 0 end -- clear $EVENT_LOCAL (ROM)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But now...[K][hero] is gone.", french="Mais c'est fini...[K] [hero]\na disparu.", german="Doch jetzt...[K] Jetzt ist\n[hero] weg.", italian=" Ma ora...[K] [hero] non c'è.", spanish="Pero ahora...[K] [hero] se\nha ido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But now...[K][hero] is gone.", french="Mais c'est fini...[K] [hero]\na disparu.", german="Doch jetzt...[K] Jetzt ist\n[hero] weg.", italian=" Ma ora...[K] [hero] non c'è.", spanish="Pero ahora...[K] [hero] se\nha ido."})
  else
  SkySceneKit.say({english=" But now...[K][hero] is gone.", french="Mais c'est fini...[K] [hero]\na disparu.", german="Doch jetzt...[K] Jetzt ist\n[hero] weg.", italian=" Ma ora...[K] [hero] non c'è.", spanish="Pero ahora...[K] [hero] se\nha ido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And [hero]...[K]isn't here\nanymore...", french="Et [hero]...[K] n'est plus\nà mes côtés...", german="[hero]...[K] ist einfach nicht\nmehr da...", italian="E [hero]...[K] non è più\nqui...", spanish="[hero]...[K] ya no está\nconmigo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And [hero]...[K]isn't here\nanymore...", french="Et [hero]...[K] n'est plus\nà mes côtés...", german="[hero]...[K] ist einfach nicht\nmehr da...", italian="E [hero]...[K] non è più\nqui...", spanish="[hero]...[K] ya no está\nconmigo."})
  else
  SkySceneKit.say({english="And [hero]...[K]isn't here\nanymore...", french="Et [hero]...[K] n'est plus\nà mes côtés...", german="[hero]...[K] ist einfach nicht\nmehr da...", italian="E [hero]...[K] non è più\nqui...", spanish="[hero]...[K] ya no está a\nmi lado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:WaitFrames(90)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- bgm2_ChangeVolume(0, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 568, 184, Direction.Left, "NPC_BIPPA")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_bippa, 488, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Wah! [partner]!", french=" Ouh là! [partner]!", german=" Wah! [partner]!", italian=" Aah! [partner]!", spanish=" ¡Aaaah! ¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(1024) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_bippa, 408, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="You've been gone so long, I took\nto worrying about you...", french="J'me suis inquiété voyant\nqu'tu rev'nais pas...", german="Du warst so lange weg, ich\nverging fast vor Sorge um dich...", italian="È da tanto che sei fuori, ero\npreoccupato per te...", spanish="Tardabas tanto en volver que\nempecé a preocuparme..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Wh-what's the matter?", french=" Euh, y'a un problème?", german=" W-was ist los?", italian=" C-Che cosa ti succede?", spanish=" ¿Qué te pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_ENDING_THEME_INTRO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  -- message_SetWaitMode(150, 80) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]![K] [CS:N]Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]![K] [CS:N]Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]![K] ¡[CS:N]Bidoof[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]![K] [CS:N]Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]![K] [CS:N]Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]![K] ¡[CS:N]Bidoof[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]![K] [CS:N]Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]![K] [CS:N]Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]![K] [CS:N]Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]![K] ¡[CS:N]Bidoof[CR]!"})
  end
  -- message_KeyWait
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Buaaaa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Buaaaa!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Buaaaa!"})
  end
  GAME:WaitFrames(20)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-2), p.Y+(0), false, 2) end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  -- message_SetWaitMode(160, 80) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Wa-wah?![K] What all is the\nmatter?", french="Hein, quoi?![K] Mais qu'est-c'qui\nt'arrive?", german=" W-wah?!?[K] Was ist denn los?", italian=" C-Co...?[K] Qual è il problema?", spanish=" ¡¿Qué?![K] ¿Pero qué te pasa?"})
  -- message_Close
  GAME:WaitFrames(90)
  SkySubScreen.Hide(120) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 120)
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
  SkySceneKit.join_routines()
end
