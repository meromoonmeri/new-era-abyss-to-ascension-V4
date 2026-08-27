-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 288, Direction.Down, "NPC_DAAKURAI")
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Gah![K] Gaaaah!", french=" Argh![K] Aaah!", german=" Gah![K] Gaaaah!", italian=" Gah![K] Aaargh!", spanish=" ¡Aah![K] ¡Aaaah!"})
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
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 280, 328, Direction.Up, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" We...[K]did it...", french=" On a...[K] réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce l'abbiamo...[K] fatta...", spanish=" Lo...[K] lo logramos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Urrgggghh!", french=" Aaaaaaarrrggghhh!", german=" Urrgggghh!", italian=" Urrgggghh!", spanish=" ¡Grrrr!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" This is the end for you, [CS:N]Darkrai[CR]!", french=" Ton heure a sonné, [CS:N]Darkrai[CR]!", german=" Das ist dein Ende, [CS:N]Darkrai[CR]!", italian=" Questa è la fine per te, [CS:N]Darkrai[CR]!", spanish=" ¡Se acabó, [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  -- SetAnimation(11) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(44) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Urrggghh...", french=" Aaargh...", german=" Urrggghh...", italian=" Urrggghh...", spanish=" ¡Grrrr!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CS:N]C-Cresselia[CR]...[K] Don't you\nremember...?", french="[CS:N]C-Cresselia[CR]...[K] Tu ne te souviens\npas...?", german="[CS:N]C-Cresselia[CR]...[K] Erinnerst du dich\nnicht?", italian="[CS:N]C-Cresselia[CR]...[K] Non ti\nricordi...?", spanish=" [CS:N]Cresselia[CR]...[K] ¿No lo recuerdas?"})
  -- message_KeyWait
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" I said you...[K]cannot catch me!", french="Je t'ai déjà dit que...[K]\ntu ne pouvais pas m'attraper!", german="Ich sagte,[K] du fängst mich\nnicht!", italian="Ho detto che non potrai mai...[K]\nprendermi!", spanish="Como te dije...[K] ¡nunca podrás\natraparme!"})
  -- message_Close
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(276, 188, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  -- GAP: se_Play(8706) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_T01P01A6_195) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GAME:MoveCamera(276, 324, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! What is that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Hey! Was ist das?", italian=" Ehi! Cos'è quello?!", spanish=" ¡Eh! ¿Qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! What is that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Hey! Was ist das?", italian=" Ehi! Cos'è quello?!", spanish=" ¡Eh! ¿Qué es eso?"})
  else
  SkySceneKit.say({english=" Hey! What is that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Hey! Was ist das?", italian=" Ehi! Cos'è quello?!", spanish=" ¡Eh! ¿Qué es eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's a dimensional hole!)", french="(C'est un gouffre dimensionnel!)", german="(Es ist ein dimensionales Loch!)", italian="(È un tunnel dimensionale!)", spanish="(¡Es un agujero dimensional!)"})
  else
  SkySceneKit.say({english="(It's a dimensional hole!)", french="(C'est un gouffre dimensionnel!)", german="(Es ist ein dimensionales Loch!)", italian="(È un tunnel dimensionale!)", spanish="(¡Es un agujero dimensional!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Mwahaha...", french=" Mwa ha ha...", german=" Muahaha...", italian=" Muahaha...", spanish=" Ja, ja, ja..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="This dimensional hole may take\nme to the future...[K]or the past...", french="Ce gouffre dimensionnel\nm'emmènera peut-être dans le futur...[K]\nou dans le passé...", german="Dieses dimensionale Loch kann\nmich in die Zukunft führen...[K] Oder in die\nVergangenheit...", italian="Questo tunnel dimensionale\npotrebbe portarmi nel futuro...[K] o nel\npassato...", spanish="Este agujero dimensional me\nllevará al futuro...[K] o al pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Even I don't know where it will\nlead me...[K] But...!", french="Même moi, je ne sais pas où\nil conduit...[K] Pourtant...", german="Wenn ich auch nicht weiß,[K] wo\nes mich hinführt...", italian="Neanche io so dove mi\ncondurrà...[K] Ma...!", spanish="Ni siquiera yo sé adónde\nconduce...[K] pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" I've failed only in this time.", french="... j'ai perdu cette bataille, mais\npas la guerre.", german="Ich habe nur in dieser Zeit hier\nversagt.", italian=" Questa volta ho fallito.", spanish=" He fracasado en esta ocasión."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I will simply plunge the world\ninto darkness in another time.", french="Ce n'est que partie remise.\nJe plongerai le monde dans l'ombre\ntôt ou tard.", german="Ich werde die Welt einfach in\neiner anderen Zeit in die Dunkelheit stürzen.", italian="Avvolgerò il mondo\nnell'oscurità in un altro tempo.", spanish="Sumiré al mundo en la oscuridad\nla próxima vez."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" S-stop![K] [CS:N]Darkrai[CR]!", french=" Arrête![K] [CS:N]Darkrai[CR]!", german=" St-stopp![K] [CS:N]Darkrai[CR]!", italian=" F-Fermo,[K] [CS:N]Darkrai[CR]!", spanish=" ¡Espera![K] ¡[CS:N]Darkrai[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" S-stop![K] [CS:N]Darkrai[CR]!", french=" Arrête![K] [CS:N]Darkrai[CR]!", german=" St-stopp![K] [CS:N]Darkrai[CR]!", italian=" F-Fermo,[K] [CS:N]Darkrai[CR]!", spanish=" ¡Espera![K] ¡[CS:N]Darkrai[CR]!"})
  else
  SkySceneKit.say({english=" S-stop![K] [CS:N]Darkrai[CR]!", french=" Arrête![K] [CS:N]Darkrai[CR]!", german=" St-stopp![K] [CS:N]Darkrai[CR]!", italian=" F-Fermo,[K] [CS:N]Darkrai[CR]!", spanish=" ¡Espera![K] ¡[CS:N]Darkrai[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" You're not getting away!", french=" Tu ne nous échapperas pas!", german=" Du kommst nicht davon!", italian=" Non riuscirai a scappare!", spanish=" ¡No te escaparás!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 236, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_daakurai, 276, 188, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_kureseria, 276, 240, false, 2)
  GROUND:MoveToPosition(partner, 260, 256, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 292, 256, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Uff...", italian=" Ugh...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Uff...", italian=" Ugh...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Uff...", italian=" Ugh...", spanish=" Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_daakurai, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Humph. Too bad for you.[K] I can\nslip away through time with just one step.", french="Pfff, dommage pour vous.[K]\nUn seul pas, et je disparais dans le temps.", german="Hmpf. Schade für euch.[K] Ich kann\nmit einem Schritt ganz einfach durch die Zeit\nentschwinden.", italian="Pfui! Sono spiacente.[K] Posso\nscappare attraverso il tempo semplicemente\nfacendo un altro passo.", spanish="Mala suerte.[K] Estoy a un paso de\nescaparme."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" You cannot catch me.", french=" Vous ne pouvez pas m'attraper.", german=" Ihr könnt mich nicht fangen.", italian=" Non potete fermarmi.", spanish=" No podéis atraparme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" ¡Oh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-12), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Good-bye to you!", french=" Au revoir!", german=" Auf Wiedersehen, allerseits!", italian=" Addio!", spanish=" ¡Adiós!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Hmpf...", italian=" Aah...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Hmpf...", italian=" Aah...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Hmpf...", italian=" Aah...", spanish=" Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Mwahaha![K] Well, how do you like\nthat?![K] Finally, in the end...", french="Mwa ha ha![K] Eh bien, qu'est-ce\nque vous dites de ça?![K] Finalement...", german="Muahaha![K] Na, wie gefällt euch\ndas?[K] Zu guter Letzt...", italian="Muahaha![K] Beh, cosa ve ne\npare?![K] Alla fine...", spanish="¡Ja, ja, ja![K] ¿Qué os parece? [K]\nAl final..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" It ends in my ultimate victory!", french=" ... c'est moi qui l'emporte!", german="Zu guter Letzt steht mein\nendgültiger Sieg bevor!", italian=" Sì, ho vinto comunque io!", spanish=" ¡Yo gano!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 224, 184, Direction.UpRight, "NPC_PARUKIA")
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end) -- message_SetActor(ACTOR_NPC_PARUKIA)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I WON'T ALLOW THAT!", french=" JE NE LE PERMETTRAI PAS!", german="DAS WERDE ICH NICHT\nZULASSEN!", italian=" NON TE LO PERMETTERÒ!", spanish=" ¡NO LO PERMITIRÉ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Que... quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Quéee?!"})
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(80)
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(32), false, 2) end -- SlidePositionOffset
  GAME:FadeIn(15)
  GROUND:EntTurn(npc_npc_daakurai, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Y-you're...", french=" Tu es...", german=" D-du bist...", italian=" M-Ma tu sei...", spanish=" Es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Pa[CR]... [CS:N]Palkia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Pa[CR]... [CS:N]Palkia[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Pa[CR]... [CS:N]Palkia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU WILL PAY A GRAVE PRICE\nFOR EXPANDING THE DISTORTION OF SPACE,\n[CS:N]DARKRAI[CR]!", french="TU ES RESPONSABLE DE\nLA DISTORSION DE L'ESPACE, [CS:N]DARKRAI[CR]!\nSUBIS TON CHATIMENT!", german="DU WIRST EINEN HOHEN PREIS\nZAHLEN FÜR DIE VERZERRUNG DES\nRAUMGEFÜGES, [CS:N]DARKRAI[CR]!", italian="LA PAGHERAI CARA PER AVER\nALLARGATO LA DISTORSIONE DELLO SPAZIO,\n[CS:N]DARKRAI[CR]!", spanish="¡PAGARÁS CARO EL HABER\nEXPANDIDO LA DEFORMACIÓN DEL\nESPACIO, [CS:N]DARKRAI[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS IS A STRIKE FOR JUSTICE!", french=" AU NOM DE LA JUSTICE!", german="DIESER SCHLAG IST FÜR DIE\nGERECHTIGKEIT!", italian="QUESTO COLPO È PER LA\nGIUSTIZIA!", spanish=" ¡HARÉ JUSTICIA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" TAKE THIS!", french=" PRENDS ÇA!", german=" NIMM DAS!", italian=" PRENDI QUESTO!", spanish=" ¡TOMA ESTO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="GRRR-OOOOOO!", french="GRRR-OOOOOO!", german="GRRR-OOOOOO!", italian="GRRR-OOOOOO!", spanish="¡GRRRRRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  GAME:WaitFrames(90)
  -- GAP: se_Play(8708) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_END_ENGULFING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  -- message_CloseEnforce
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" What...[K] Waaaaaah!", french=" Que...[K] Ouaaaah!", german=" Was...[K] Uaaaaaah!", italian=" Cosa?![K] Aaaaaaah!", spanish=" Qué...[K] ¡Aaaaah!"})
  -- message_Close
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THERE IS NO ESCAPE!", french=" IL N'Y A PAS D'ECHAPPATOIRE!", german=" ES GIBT KEIN ENTRINNEN!", italian=" NON PUOI SCAPPARE!", spanish=" ¡NO HAY ESCAPATORIA!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- se_Stop(8708) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- GAP: se_Play(8707) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C6_121) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- Move2PositionMark<object OBJECT_H02P99C6_121> [prop décor NDS, géré par le rendu du ground]
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end) -- message_SetActor(ACTOR_NPC_DAAKURAI)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Gaaaaaah!", french=" Aaaaah!", german=" Gaaaaaah!", italian=" Gaaaaaah!", spanish=" ¡Aaaaaah!"})
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:FadeIn(0)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 1, false) end) -- SetPositionOffset caméra
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8705) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_T01P01A6_195) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(276, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The dimensional hole...)", french="(Le gouffre dimensionnel...)", german="(Das dimensionale Loch...)", italian="(Il tunnel dimensionale...)", spanish="(El agujero dimensional...)"})
  else
  SkySceneKit.say({english="(The dimensional hole...)", french="(Le gouffre dimensionnel...)", german="(Das dimensionale Loch...)", italian="(Il tunnel dimensionale...)", spanish="(El agujero dimensional...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The dimensional hole completely\nshattered![K] With [CS:N]Darkrai[CR] still inside of it!", french="Le gouffre dimensionnel\na littéralement explosé![K] Avec [CS:N]Darkrai[CR]\nà l'intérieur!", german="Das dimensionale Loch ist\nvollständig zerschmettert![K]\nMit [CS:N]Darkrai[CR] darin!", italian="Il tunnel dimensionale si è\ndisintegrato![K] E [CS:N]Darkrai[CR] era ancora all'interno!", spanish="¡El agujero dimensional hecho\nañicos![K] ¡Y con [CS:N]Darkrai[CR] dentro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I heard [CS:N]Darkrai[CR] scream...", french=" J'ai entendu [CS:N]Darkrai[CR] crier...", german="Ich habe [CS:N]Darkrai[CR] schreien\ngehört...", italian=" Ho sentito [CS:N]Darkrai[CR] gridare...", spanish=" He oído gritar a [CS:N]Darkrai[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I heard [CS:N]Darkrai[CR] scream...", french=" J'ai entendu [CS:N]Darkrai[CR] crier...", german="Ich habe [CS:N]Darkrai[CR] schreien\ngehört...", italian=" Ho sentito [CS:N]Darkrai[CR] gridare...", spanish=" He oído gritar a [CS:N]Darkrai[CR]..."})
  else
  SkySceneKit.say({english=" I heard [CS:N]Darkrai[CR] scream...", french=" J'ai entendu [CS:N]Darkrai[CR] crier...", german="Ich habe [CS:N]Darkrai[CR] schreien\ngehört...", italian=" Ho sentito [CS:N]Darkrai[CR] gridare...", spanish=" He oído gritar a [CS:N]Darkrai[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Did [CS:N]Darkrai[CR] disappear forever?", french="Est-ce que [CS:N]Darkrai[CR] a disparu\npour toujours?", german="Ist [CS:N]Darkrai[CR] für immer\nverschwunden?", italian="[CS:N]Darkrai[CR] sarà scomparso\nper sempre?", spanish="¿Ha desaparecido [CS:N]Darkrai[CR] para\nsiempre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Did [CS:N]Darkrai[CR] disappear forever?", french="Est-ce que [CS:N]Darkrai[CR] a disparu\npour toujours?", german="Ist [CS:N]Darkrai[CR] für immer\nverschwunden?", italian="[CS:N]Darkrai[CR] sarà scomparso\nper sempre?", spanish="¿Ha desaparecido [CS:N]Darkrai[CR] para\nsiempre?"})
  else
  SkySceneKit.say({english=" Did [CS:N]Darkrai[CR] disappear forever?", french="Est-ce que [CS:N]Darkrai[CR] a disparu\npour toujours?", german="Ist [CS:N]Darkrai[CR] für immer\nverschwunden?", italian="[CS:N]Darkrai[CR] sarà scomparso\nper sempre?", spanish="¿Ha desaparecido [CS:N]Darkrai[CR] para\nsiempre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_parukia, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" NO.[K] THAT HAS NOT HAPPENED.", french=" NON.[K] PAS POUR TOUJOURS.", german=" NEIN.[K] DAS IST NICHT PASSIERT.", italian=" NO.[K] NON È COSÌ.", spanish="NO.[K] NO ES ESO LO QUE HA\nPASADO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="HE HAS SUFFERED GRIEVOUS\nDAMAGE...[K]AND BEEN BANISHED TO SOME\nUNKNOWN PLACE...", french="IL EST GRAVEMENT BLESSE...[K]\nET BANNI DANS UN LIEU INCONNU...", german="ES HAT SCHWER SCHADEN\nGENOMMEN...[K] UND WURDE AN EINEN\nUNBEKANNTEN ORT VERBANNT...", italian="HA SUBITO DEI DANNI\nGRAVISSIMI...[K] ED È STATO ESILIATO IN\nQUALCHE LUOGO SCONOSCIUTO...", spanish="HA SUFRIDO DAÑOS...[K] Y SE HA\nMARCHADO A UN LUGAR DESCONOCIDO..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="BUT, WHEREVER HE MAY\nBE...[K]HE LIVES.", french="MAIS OU QU'IL SOIT...[K] IL EST\nEN VIE.", german="ABER WO IMMER ES SEIN\nMAG...[K] ES LEBT.", italian="MA, DOVUNQUE SI TROVI...[K]\nÈ VIVO.", spanish="PERO DONDEQUIERA QUE ESTÉ...[K]\nESTÁ VIVO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" When he recovers from injury...", french=" Mais quand il aura récupéré...", german="Wenn es sich von seinen\nVerletzungen erholt hat...", italian="Quando si riprenderà dalle\nferite...", spanish="Cuando se recupere de sus\nheridas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" When he recovers from injury...", french=" Mais quand il aura récupéré...", german="Wenn es sich von seinen\nVerletzungen erholt hat...", italian="Quando si riprenderà dalle\nferite...", spanish="Cuando se recupere de sus\nheridas..."})
  else
  SkySceneKit.say({english=" When he recovers from injury...", french=" Mais quand il aura récupéré...", german="Wenn es sich von seinen\nVerletzungen erholt hat...", italian="Quando si riprenderà dalle\nferite...", spanish="Cuando se recupere de sus\nheridas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Won't [CS:N]Darkrai[CR] go back to his\nwicked ways?", french="... vous ne croyez pas qu'il va\nse remettre à comploter contre nous?", german="Wird [CS:N]Darkrai[CR] dann nicht wieder\nsein Unwesen treiben?", italian="... [CS:N]Darkrai[CR] ricomincerà\nad agire in modo malvagio?", spanish=" ¿Volverá [CS:N]Darkrai[CR] a las andadas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Won't [CS:N]Darkrai[CR] go back to his\nwicked ways?", french="... vous ne croyez pas qu'il va\nse remettre à comploter contre nous?", german="Wird [CS:N]Darkrai[CR] dann nicht wieder\nsein Unwesen treiben?", italian="... [CS:N]Darkrai[CR] ricomincerà\nad agire in modo malvagio?", spanish=" ¿Volverá [CS:N]Darkrai[CR] a las andadas?"})
  else
  SkySceneKit.say({english="Won't [CS:N]Darkrai[CR] go back to his\nwicked ways?", french="... vous ne croyez pas qu'il va\nse remettre à comploter contre nous?", german="Wird [CS:N]Darkrai[CR] dann nicht wieder\nsein Unwesen treiben?", italian="... [CS:N]Darkrai[CR] ricomincerà\nad agire in modo malvagio?", spanish=" ¿Volverá [CS:N]Darkrai[CR] a las andadas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" That remains to be seen...", french=" Nous verrons bien...", german=" Das bleibt abzuwarten...", italian=" Non è possibile saperlo.", spanish=" Eso está por ver..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Because when [CS:N]Darkrai[CR] entered\nthe dimensional hole...[K]he began to time travel...", french="A l'instant où [CS:N]Darkrai[CR] est entré\ndans le gouffre dimensionnel...[K] il a commencé\nà voyager dans le temps...", german="Denn als [CS:N]Darkrai[CR] in das\ndimensionale Loch geschlüpft ist...[K] Da trat es\neine Reise durch die Zeit an...", italian="Perché quando [CS:N]Darkrai[CR] è\nentrato nel tunnel dimensionale...[K] ha iniziato\na viaggiare nel tempo.", spanish="Cuando [CS:N]Darkrai[CR] entró en el\nagujero dimensional...[K] comenzó a viajar en\nel tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="At that precise moment, he was\nstruck with [CS:N]Palkia[CR]'s attack.", french="... et à ce moment précis, [CS:N]Palkia[CR]\nl'a attaqué.", german="Genau in diesem Moment wurde\nes von der Attacke von [CS:N]Palkia[CR] getroffen.", italian="In quel preciso istante è stato\ncolpito dall'attacco di [CS:N]Palkia[CR].", spanish="Y justo en ese momento recibió\nel ataque de [CS:N]Palkia[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Remember what [CS:N]Darkrai[CR] said\nabout [hero]'s arrival from the future?", french="Rappelez-vous ce que [CS:N]Darkrai[CR]\na dit à propos de l'accident dont [hero]\na été victime pendant son voyage.", german="Erinnerst du dich, was [CS:N]Darkrai[CR]\nüber die Ankunft von [hero] aus der\nZukunft gesagt hat?", italian="Vi ricordate cosa ha detto\n[CS:N]Darkrai[CR] in merito all'arrivo di [hero]\ndal futuro?", spanish="¿Recuerdas lo que dijo [CS:N]Darkrai[CR]\nsobre la llegada de [hero] del futuro?"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] attacked during time\ntravel...[K] So [hero] got hit with amnesia.", french="[CS:N]Darkrai[CR] est passé à l'attaque\npendant le voyage dans le temps...[K] et\n[hero] a perdu la mémoire.", german="[CS:N]Darkrai[CR] hat während der\nZeitreise angegriffen...[K] [hero] erlitt\neinen Gedächtnisverlust.", italian="[CS:N]Darkrai[CR] ha attaccato durante\nil viaggio attraverso il tempo.[K] E per\nquesto [hero] ha perso la memoria.", spanish="[CS:N]Darkrai[CR] le atacó durante su\nviaje en el tiempo...[K] Y [hero] perdió\nla memoria."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" So just like [hero]...", french="Par conséquent, tout comme\n[hero]...", german="Also erging es ihm wie\n[hero]...", italian="Quindi, proprio come è\nsuccesso a [hero]...", spanish=" Como [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It's likely that [CS:N]Darkrai[CR] has lost\nhis memory as well.", french="... il y a de fortes chances que\n[CS:N]Darkrai[CR] soit lui aussi frappé d'amnésie.", german="[CS:N]Darkrai[CR] wird sehr\nwahrscheinlich auch sein Gedächtnis verloren\nhaben.", italian="... è probabile che anche\n[CS:N]Darkrai[CR] abbia perso la memoria.", spanish="Es muy probable que [CS:N]Darkrai[CR]\ntambién haya perdido la memoria."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] has lost his memory?!", french="[CS:N]Darkrai[CR] aurait perdu\nla mémoire?!", german="[CS:N]Darkrai[CR] hat sein Gedächtnis\nverloren?!?", italian=" [CS:N]Darkrai[CR] ha perso la memoria?!", spanish="¿[CS:N]Darkrai[CR] puede haber perdido\nla memoria?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] has lost his memory?!", french="[CS:N]Darkrai[CR] aurait perdu\nla mémoire?!", german="[CS:N]Darkrai[CR] hat sein Gedächtnis\nverloren?!?", italian=" [CS:N]Darkrai[CR] ha perso la memoria?!", spanish="¿[CS:N]Darkrai[CR] puede haber perdido\nla memoria?"})
  else
  SkySceneKit.say({english=" [CS:N]Darkrai[CR] has lost his memory?!", french="[CS:N]Darkrai[CR] aurait perdu\nla mémoire?!", german="[CS:N]Darkrai[CR] hat sein Gedächtnis\nverloren?!?", italian=" [CS:N]Darkrai[CR] ha perso la memoria?!", spanish="¿[CS:N]Darkrai[CR] puede haber perdido\nla memoria?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Yes. [CS:N]Darkrai[CR] will likely never\nrecover his memory...", french="Oui. Et il ne la retrouvera\nprobablement jamais...", german="Ja. [CS:N]Darkrai[CR] wird sein\nGedächtnis sehr wahrscheinlich nicht mehr\nwiedererlangen...", italian="Esatto. Probabilmente [CS:N]Darkrai[CR]\nnon riuscirà mai a recuperare i suoi ricordi...", spanish="Sí, y puede que no la recupere\nnunca."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="And he will wander lost through\nthe world.", french="... il finira par errer sans but\npour l'éternité.", german="Es wird verloren durch die Welt\nirren.", italian="E vagabonderà sperduto per il\nmondo.", spanish="Incluso puede que acabe vagando\npor el mundo sin recordar nada de nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]...", french=" [CS:N]Darkrai[CR]...", german=" [CS:N]Darkrai[CR]...", italian=" [CS:N]Darkrai[CR]...", spanish=" [CS:N]Darkrai[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]...", french=" [CS:N]Darkrai[CR]...", german=" [CS:N]Darkrai[CR]...", italian=" [CS:N]Darkrai[CR]...", spanish=" [CS:N]Darkrai[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]...", french=" [CS:N]Darkrai[CR]...", german=" [CS:N]Darkrai[CR]...", italian=" [CS:N]Darkrai[CR]...", spanish=" [CS:N]Darkrai[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="WE ARE DONE WITH HIM.[K]\nHE WILL NOT LIKELY EXPAND THE DISTORTION\nOF SPACE AGAIN.", french="C'EN EST FINI DE LUI.[K] IL EST\nFORT PEU PROBABLE QU'IL TENTE ENCORE\nD'ETENDRE LA DISTORSION DE L'ESPACE.", german="WIR SIND FERTIG MIT IHM.[K]\nES WIRD WOHL NICHT WIEDER DIE\nVERZERRUNG DES RAUMES AUSWEITEN.", italian="CE NE SIAMO LIBERATI.[K]\nNON PENSO CHE TENTERÀ DI AMPLIARE\nANCORA LA DISTORSIONE DELLO SPAZIO.", spanish="SE ACABÓ.[K] NO VOLVERÁ A\nAUMENTAR LA DEFORMACIÓN DEL\nESPACIO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I WILL RETURN TO\n[CS:P]SPACIAL RIFT[CR].", french="JE REGAGNE LA [CS:P]FAILLE\nSPATIALE[CR] DE CE PAS.", german="ICH WERDE ZUR [CS:P]RAUMSPALTE[CR]\nZURÜCKKEHREN.", italian="ADESSO FARÒ RITORNO ALLA\n[CS:P]VALLE DIMENSIONALE[CR].", spanish="YO HE DE REGRESAR A LA\n[CS:P]GRIETA ESPACIAL[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="I FORESEE NO REASON TO\nEVER RETURN HERE.[K] FAREWELL.", french="JE NE VOIS PAS DE RAISON DE\nREVENIR ICI UN JOUR.[K] ADIEU.", german="ICH SEHE KEINEN GRUND,\nJEMALS HIERHER ZURÜCKZUKEHREN.[K]\nLEBT WOHL.", italian="PENSO CHE NON TORNERÒ MAI\nPIÙ QUI.[K] ADDIO.", spanish="NO VEO NINGUNA RAZÓN PARA\nVOLVER AQUÍ JAMÁS.[K] ADIÓS."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8200) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end) -- message_SetActor(ACTOR_NPC_PARUKIA)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_H02P99C5_120) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Well, that is that.[K] Shall we also\ngo back?", french="Bien, nous avons fait du beau\ntravail.[K] Et si nous rentrions?", german="Nun, das war es wohl.[K] Sollen wir\nauch zurückgehen?", italian="Beh, è finita.[K] Cosa ne dite di\ntornare a casa?", spanish="Bueno, eso ha sido todo.[K] ¿Habrá\nque regresar, no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup!", french=" Ouaip!", german=" Jep!", italian=" Sì!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Ouaip!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Sì!", spanish=" ¡Sí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go home, [hero]![K]\nBack to Treasure Town!", french="On rentre à la maison,\n[hero]![K] En route pour Bourg-Trésor!", german="Gehen wir nach Hause,\n[hero]![K] Zurück nach Schatzstadt!", italian="Andiamo a casa, [hero]![K]\nTorniamo a Borgo Tesoro!", spanish="¡A casa, [hero]![K]\n¡De vuelta a Aldea Tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go home, [hero]![K]\nBack to Treasure Town!", french="On rentre à la maison,\n[hero]![K] En route pour Bourg-Trésor!", german="Gehen wir nach Hause,\n[hero]![K] Zurück nach Schatzstadt!", italian="Andiamo a casa, [hero]![K]\nTorniamo a Borgo Tesoro!", spanish="¡A casa, [hero]![K]\n¡De vuelta a Aldea Tesoro!"})
  else
  SkySceneKit.say({english="Let's go home, [hero]![K]\nBack to Treasure Town!", french="On rentre à la maison,\n[hero]![K] En route pour Bourg-Trésor!", german="Gehen wir nach Hause,\n[hero]![K] Zurück nach Schatzstadt!", italian="Andiamo a casa, [hero]![K]\nTorniamo a Borgo Tesoro!", spanish="¡A casa, [hero]![K]\n¡De vuelta a Aldea Tesoro!"})
  end
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
