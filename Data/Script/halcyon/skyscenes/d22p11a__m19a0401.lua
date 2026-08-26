-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/m19a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 144, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You seem to be finally prepared.", french="Vous avez enfin fini de vous\npréparer, semble-t-il.", german="Eure Vorbereitung scheint\nabgeschlossen zu sein.", italian="Alla fine sembra tutto pronto\nper la partenza.", spanish=" Parece que ya estáis."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Let's go, then.[K] We'll find [CS:N]Celebi[CR]\nand return to the past.", french="Allez, on y va.[K] Trouvons [CS:N]Celebi[CR]\net retournons dans le passé.", german="Dann lasst uns gehen.[K] Wir\nwerden [CS:N]Celebi[CR] finden und in die Vergangenheit\nzurückkehren.", italian="Andiamo, allora.[K] Troviamo\n[CS:N]Celebi[CR] e torniamo nel passato.", spanish="Entonces vámonos.[K] Buscaremos a\n[CS:N]Celebi[CR] para poder regresar al pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go.", french=" En route.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Adelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 84, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(160) end)
  SkySceneKit.say({english=" Oh, wait! Hold on!", french=" Une seconde! Attends!", german=" Oh, warte mal einen Moment!", italian=" Oh, aspetta! Fermo!", spanish=" ¡Un momento! ¡Espera!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qu'il y a?", german=" Was ist los?", italian=" Cosa c'è?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="[CS:N]Grovyle[CR], will you...[K]keep stealing\nthe Time Gears like you were doing before?", french="[CS:N]Massko[CR], est-ce que...[K]\ntu te remettras à voler les Rouages du Temps?", german="[CS:N]Reptain[CR], wirst du dann...[K]\nWirst du dann weiterhin Zahnräder der Zeit\nstehlen?", italian="[CS:N]Grovyle[CR], tu...[K] continuerai a\nrubare gli Ingranaggi del Tempo come\nfacevi prima?", spanish="¿Vas a...?[K] ¿Vas a seguir robando\nlos Engranajes del Tiempo igual que antes,\n[CS:N]Grovyle[CR]?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Well...[K]yes, I will.", french=" Eh bien... [K]oui, je recommencerai.", german=" Nun...[K] Ja, das werde ich.", italian=" Beh...[K] Sì, lo farò.", spanish=" Pues...[K] Sí, por supuesto."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Otherwise, the planet's paralysis\ncan't be stopped.", french="Autrement, la planète sera\nparalysée.", german="Anders kann die Lähmung des\nPlaneten nicht aufgehalten werden.", italian="È l'unico modo per bloccare la\nparalisi del pianeta.", spanish="No hay otra forma de revertir\nla parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" I'm going to stop you, [CS:N]Grovyle[CR]!", french=" Je ferai tout pour t'arrêter!", german="Dann werde ich dich aufhalten,\n[CS:N]Reptain[CR]!", italian=" Beh, ti fermerò, [CS:N]Grovyle[CR]!", spanish=" Tendré que detenerte, [CS:N]Grovyle[CR]."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Humph! Do as you will. But keep\nthis in mind...", french="Pfff! Fais comme tu veux. Mais\nn'oublie pas...", german="Hmpf! Tu, was du nicht lassen\nkannst. Aber denk daran...", italian="Uff! Fai come vuoi.\nMa ricordati una cosa.", spanish="Hum... Haz lo que consideres\noportuno. Pero recuerda esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="What's important now is getting\nourselves safely back to your world.", french="Ce qui compte maintenant, c'est\nde réussir à retourner indemnes dans\nvotre monde.", german="Das Wichtigste ist jetzt, dass\nwir wieder sicher in eure Welt gelangen.", italian="L'importante ora è riuscire a\nritornare nel presente sani e salvi.", spanish="Lo importante ahora es regresar\nsanos y salvos a tu mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So for the time being...[K]focus on\ngetting back home.", french="Alors pour l'instant...[K]\nconcentre-toi là-dessus.", german="Also fürs Erste[K] solltet ihr\neuch darauf konzentrieren, sicher nach Hause\nzu kommen.", italian="Quindi per ora...[K] concentrati\nsu come tornare a casa.", spanish="Así que de momento...[K]\nNo pienses en nada más."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 4, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 252, 60, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 300, 92, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="(I am sensing something strange...)", french="(Je ressens quelque chose d'étrange...)", german="(Ich fühle etwas Seltsames...)", italian="(Sento qualcosa di strano...)", spanish="(Noto algo extraño...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  SkySceneKit.say({english=" Hm?[K] What is it, [hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german="Hm?[K] Was gibt es,\n[hero]?", italian=" Eh?[K] Cosa c'è, [hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(It was...)", french="(C'était...)", german="(Es war...)", italian="(Era...)", spanish="(Sucedió cuando...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.say({english="(That's it![K] It was when...)", french="(J'y suis![K] C'était quand...)", german="(Das ist es![K] Es war, als...)", italian="(Ecco![K] È stato quando...)", spanish="(¡Eso es![K] Sucedió cuando...)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
