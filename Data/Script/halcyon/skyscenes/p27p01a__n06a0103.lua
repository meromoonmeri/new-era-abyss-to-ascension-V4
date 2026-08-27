-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P27P01A/n06a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM 201 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V39P01A) [décor sub chargé: Sub_v39p01a]
  -- back_SetGround(LEVEL_P27P01A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 12>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera2_SetEffect(2, 1.0, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v39p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- SlidePositionOffset<object OBJECT_V39P01A1_531> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V39P01A1_532> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(300)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '1', '0')
  GAME:FadeIn(30)
  GAME:WaitFrames(40)
  -- camera2_SetEffect(2, 0.5, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(10)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 30)) end) -- camera_SetEffect('2', '0', '3984', '1', '0')
  GAME:WaitFrames(20)
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- back2_SetEffect(12, 45) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(20)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- camera2_SetEffect(2, 0.1992, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(10)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 30)) end) -- camera_SetEffect('2', '0', '0977', '1', '0')
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V39P01A1_532) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(90)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 216, 152, Direction.Up, "NPC_SAANAITO")
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 152, 152, Direction.Up, "NPC_CHAAREMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" All right![K] That went well!", french=" Parfait![K] Net et sans bavure!", german=" Sehr gut![K] Das ist gut gelaufen!", italian=" Ok![K] È andato tutto bene!", spanish=" ¡Genial![K] Ha ido muy bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="The treasure of the ruins\nis ours!", french=" Le trésor des ruines est à nous!", german=" Der Schatz der Ruinen ist unser!", italian=" Il tesoro delle rovine è nostro!", spanish="¡El tesoro de las ruinas\nya es nuestro!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="This was a pretty easy job,\nwasn't it? ♪", french="Un vrai jeu d'enfant, n'est-ce\npas? ♪", german="Ein Zuckerschlecken, nicht\nwahr? ♪", italian="È stato un lavoretto\nfacile facile, vero? ♪", spanish=" Ha sido de lo más facilito, ¿no? ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="That's one victory right\nafter another! ♪", french="Nous enchaînons les\nvictoires! ♪", german=" Ein Sieg nach dem anderen! ♪", italian="Abbiamo ottenuto un altro\nsuccesso! ♪", spanish=" ¡Vamos de victoria en victoria! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's right...[K] We haven't lost\nout on a treasure we've aimed for yet...", french="Bien dit...[K] Jamais un seul trésor\nne nous a échappé...", german="Ganz genau![K] Noch nicht ein\nSchatz, den wir haben wollten, ist\nuns bisher durch die Lappen gegangen...", italian="Proprio così...[K] Finora nessun\ntesoro su cui abbiamo posato gli occhi\nci è mai sfuggito...", spanish="Es cierto...[K] Nunca se nos ha\nescapado ningún tesoro que quisiéramos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Not even one...", french=" C'est un sans faute...", german=" Kein einziger...", italian=" Nemmeno uno...", spanish=" Ni uno chiquitito..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Team [CS:X]Charm[CR] has a 100 percent\nsuccess rate, and we take pride in that!", french="L'Equipe [CS:X]Charme[CR] peut se vanter\nd'un taux de réussite de cent pour cent!", german="Team [CS:X]Charme[CR] hat eine\nErfolgsquote von 100 %! Darauf sind\nwir stolz!", italian="Il Team [CS:X]Malia[CR] non ha mai fallito\ne siamo molto orgogliose di questo!", spanish="El [CS:X]Equipo Carisma[CR] tiene un\níndice de éxito del cien por cien. ¡Es para\nestar orgullosas!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="All right, let's go on--and\ngo undefeated!", french=" Continuons sur notre lancée!", german="Alles klar, weiter geht's!\nUnd weiterhin ungeschlagen!", italian="Bene, continuiamo così...\nImbattibili come sempre!", spanish="Bueno, vamos a seguir.\n¡Y a permanecer invictas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We're the treasure hunters--\nTeam [CS:X]Charm[CR]!", french="Nous sommes les chasseuses de\ntrésor de l'Equipe [CS:X]Charme[CR]!", german="Wir sind die Schatzjäger von\nTeam [CS:X]Charme[CR]!", italian="Noi siamo le cacciatrici\ndi tesori... Siamo il Team [CS:X]Malia[CR]!", spanish="Somos buscadoras de tesoros...\n¡El [CS:X]Equipo Carisma[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Among the three of us...", french=" A nous trois...", german=" Zu dritt...", italian=" Noi tre insieme...", spanish=" Entre las tres..."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's nothing we\ncan't do! [M:H8]", french=" ... rien ne peut nous arrêter! [M:H8]", german="Zu dritt gibt es nichts, was wir\nnicht können! [M:H8]", italian=" ... siamo inarrestabili! [M:H8]", spanish=" ¡No hay nada que se nos resista! [M:H8]"})
  GAME:WaitFrames(20)
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
