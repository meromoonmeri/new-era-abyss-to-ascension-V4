-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P41C/n09a2208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_A_NEW_WORLD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P06C) [décor sub chargé: Sub_v38p06c]
  -- back_SetGround(LEVEL_D53P41C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 15.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  SkySubScreen.Show("v38p06c", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]We...", french=" ...[K] Nous...", german=" ...[K]Wir...", italian=" ...[K] Noi...", spanish=" Nosotros...[K] aún..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We...[K]truly...are still here...", french=" Nous sommes...[K] encore ici...", german="Wir...[K] sind...\nalle wirklich noch da...", italian=" Noi...[K] siamo qui... veramente...", spanish=" Todavía...[K] seguimos aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 304, 280, Direction.Left, "NPC_SEREBII")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Wonderful!!", french=" Merveilleux!!", german=" Juchhu!!!", italian=" È magnifico!!!", spanish=" ¡¡Espléndido!!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="But I don't know why we were\nfading and then didn't disappear...", french="Mais comment expliquer que\nnous soyons toujours là alors même que\nnous commencions à disparaître?", german="Aber ich kann mir nicht\nerklären, warum wir erst verblassten, dann\naber doch nicht verschwanden...", italian="Non capisco come mai i nostri\ncorpi non siano svaniti completamente...", spanish="Pero estábamos desapareciendo.\nTodos lo hemos notado. ¿Por qué?"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" But anyway...[K] Everyone is alive!", french="Enfin bref...[K] Tout le monde\nest là!", german="Wie dem auch sei...[K]\nWir sind alle noch da!", italian=" Ma non importa...[K] Siamo qui!", spanish=" En fin, da igual...[K] ¡Seguimos aquí!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Everyone is safe!", french=" Tout le monde est sain et sauf!", german=" Alle sind in Sicherheit!", italian=" Siamo tutti salvi!", spanish=" ¡Todos estamos a salvo!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Isn't this just an amazingly\nwonderful thing?!", french=" N'est-ce pas formidable?!", german="Findet ihr das nicht auch\neinfach wunderschön?!?", italian="Non è una cosa assolutamente\nfantastica?!", spanish=" ¡¿No os parece asombroso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="...[K]If this happened,\ndoes that mean...?", french="...[K] Certes, mais que faut-il\nen déduire...?", german="...[K]Wenn es wirklich so passiert\nist, bedeutet das also...", italian="...[K] Ma se è successo tutto\nquesto, allora...", spanish="Vaya...[K] Si esto ha ocurrido,\n¿significa que...?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="This was a miracle...[K]\nCan we say that...?", french=" Serait-ce...[K] un miracle...?", german="Es ist ein Wunder...[K]\nKönnen wir es so nennen?", italian="Si tratta di un prodigio...[K]\nNon è forse così...?", spanish="Ha sido un milagro...[K]\n¿Puedo decirlo...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker("Dialga", true, "dialga", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_DARK_DIARUGA) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" NO.[K] IT WAS NO MIRACLE.", french=" NON.[K] CE N'EST PAS UN MIRACLE.", german=" NEIN.[K] DAS WAR KEIN WUNDER.", italian="NO.[K] NON SI TRATTA\nDI UN PRODIGIO.", spanish=" NO.[K] NO HA SIDO UN MILAGRO."})
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 208, 264, Direction.DownRight, "NPC_YONOWAARU_N9")
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_serebii, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-88), 88, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(90)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(88), 88, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 256, 168, Direction.Down, "NPC_DIARUGA")
  GROUND:MoveToPosition(npc_npc_diaruga, 252, 236, false, 2)
  GAME:WaitFrames(60)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-8), p.Y+(16), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(7)
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(8), p.Y+(8), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Dialga[CR]!", french=" [CS:N]Dialga[CR]!", german=" [CS:N]Dialga[CR]!", italian=" [CS:N]Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Master [CS:N]Dialga[CR]!", french=" Maître [CS:N]Dialga[CR]!", german=" Meister [CS:N]Dialga[CR]!", italian=" Maestro [CS:N]Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="FOR A VERY LONG TIME...[K]\nI SAW ONLY DARKNESS...", french="PENDANT LONGTEMPS...[K]\nJ'AI ETE AVEUGLE PAR L'OMBRE...", german="LANGE ZEIT...[K]\nWAR ICH IN DUNKELHEIT GEHÜLLT...", italian="PER LUNGO TEMPO...[K]\nHO VISSUTO NELL'OSCURITÀ...", spanish="DURANTE MUCHO TIEMPO...[K]\nSOLO VI LA OSCURIDAD..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" AND DURING THAT TIME...", french=" ET PENDANT CE TEMPS...", german=" UND WÄHREND DIESER ZEIT...", italian=" DURANTE QUESTO PERIODO...", spanish=" Y DURANTE ESE TIEMPO..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THE WORLD BECAME FILLED\nWITH CHAOS...", french="LE MONDE A SOMBRE DANS\nLE CHAOS...", german="MACHTE SICH IN DER WELT\nDAS CHAOS BREIT...", italian="... IL MONDO È PIOMBATO\nNEL CAOS...", spanish=" EL CAOS SE EXTENDIÓ POR EL MUNDO..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" M-Master [CS:N]Dialga[CR]...", french=" M-Maître [CS:N]Dialga[CR]...", german=" M-meister [CS:N]Dialga[CR]...", italian=" M-Maestro [CS:N]Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" I TAKE RESPONSIBILITY FOR IT!", french="JE SUIS LE SEUL\nRESPONSABLE!", german="DAFÜR ÜBERNEHME ICH\nDIE VERANTWORTUNG!", italian=" LA COLPA È SOLO MIA!", spanish=" ASUMO LA RESPONSABILIDAD."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="NOW THAT THINGS HAVE BEEN\nRESOLVED...[K]I'LL SUPPORT THIS\nNEW WORLD FROM HERE ON OUT.", french="MAINTENANT QUE TOUT EST\nREGLE...[K] JE M'ENGAGE A ASSURER L'AVENIR\nDE CE MONDE.", german="JETZT, DA DIE ORDNUNG\nWIEDERHERGESTELLT IST,[K] WERDE ICH DIESE\nNEUE WELT VON ANBEGINN UNTERSTÜTZEN.", italian="ORA CHE LE COSE SONO TORNATE\nAL LORO POSTO...[K] DIFENDERÒ QUESTO NUOVO\nMONDO CON TUTTE LE MIE FORZE.", spanish="AHORA QUE TODO SE HA RESUELTO...[K]\nPRESTARÉ MI APOYO A ESTE NUEVO MUNDO."})
  -- message_Close
  -- GAP: se_Play(11537) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(60)
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- GAP: se_Play(11540) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRROOOOOO...OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡¡GRRRRRRRRR!!"})
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_CloseEnforce
  -- SetPositionOffset<object OBJECT_D53P41C1_457> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(10)
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
