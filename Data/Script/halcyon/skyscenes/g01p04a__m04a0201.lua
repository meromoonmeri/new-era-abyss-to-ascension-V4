-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m04a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(5, 3) -- $SCENARIO_MAIN = scn[5,3] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetMyself() [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).EVENT_LOCAL or 0) -- switch($EVENT_LOCAL) [GameVar EVENT_LOCAL (SV.SkyVars)]
  if __sw == 0 then
  -- @switch0_724 [étiquette de flux ExplorerScript]
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 176, 256, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've done an honest\nday's work! ♪", french="Voilà une bonne journée de\ntravail qui se termine! ♪", german="Ihr habt einen langen Arbeitstag\nhinter euch, ihr zwei! ♪", italian=" Avete lavorato abbastanza! ♪", spanish=" ¡Hoy habéis trabajado duro! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me review your sentry-duty\nperformance...", french="Je vais examiner vos\nrésultats...", german="Lasst mich überprüfen, wie ihr\neuch angestellt habt.", italian="Fatemi vedere come ve la siete\ncavata con il turno di guardia...", spanish="Ahora me toca valorar vuestro\ntrabajo como vigías."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Your results were...[K]dreadful!", french="Vos résultats sont...[K]\ntout simplement effroyables!", german="Eure Ergebnisse sind...[K]\nschrecklich!", italian="Avete ottenuto dei risultati...[K]\npessimi!", spanish="Vuestro resultado ha sido...[K]\n¡horrible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_FAILED_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 152, 264, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You failed so many times!", french=" Vous avez échoué tant de fois!", german=" Ihr habt unzählige Male versagt!", italian=" Avete sbagliato così tante volte!", spanish=" ¡Habéis fallado demasiado!"})
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- message_Close
  GAME:WaitFrames(20)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You slackers! Did you do\nanything besides goof off?", french="Bande de tire-au-flanc!\nVous avez dû passer la journée à bayer\naux corneilles, c'est pas possible!", german="Ihr Nichtsnutze! Habt ihr dort\nunten nur gefaulenzt?", italian="Scansafatiche! Non avete fatto\naltro che poltrire?", spanish="¡Menudos gandules!\n¿Habéis hecho algo en todo el día?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" UGH...!", french=" ARGH...!", german=" ARGH!", italian=" UFF...!", spanish=" ¡Vaya, vaya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You two got SO many wrong...", french="C'est quand même PAS POSSIBLE\nde commettre autant d'erreurs...", german="Ihr habt euch SO dumm\nangestellt...", italian="Avete sbagliato DAVVERO tante\nvolte!", spanish="¡Menudo marrón! ¡Vaya manera\nde equivocarse!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I even got in TROUBLE for it!", french="Je vais avoir des ENNUIS à\ncause de vous!", german="Damit habt ihr auch noch MICH\nin Schwierigkeiten gebracht!", italian="Sono finito nei GUAI anche io\nper colpa vostra!", spanish="¡Hasta a mí me ha caído una\nbronca!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" H-hush!", french=" Silence!", german=" P-pssst!", italian=" S-Silenzio!", spanish=" ¡Silencio!"})
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Don't you dare blame\nanyone else!", french="Comment oses-tu rejeter la\nfaute sur les autres?!", german="Gib nicht den anderen die\nSchuld!", italian=" Non osare dare la colpa ad altri!", spanish="¡¿Cómo te atreves a escurrir el\nbulto de esa manera?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sentry duty is a cooperative job,\nisn't it?", french="Monter la garde est un travail\nd'équipe, non?", german="Im Wachdienst kommt es auch\nauf Zusammenarbeit an, nicht wahr?", italian="Il turno di guardia è un lavoro\ndi cooperazione, no?", spanish="¡La vigilancia es un trabajo de\nequipo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Anyway, this job was a\nfiasco, no doubt about it!", french="En tout cas, c'est un fiasco,\nil n'y a aucun doute là-dessus!", german="Wie auch immer, dieser Job\nwar ein Fiasko, kein Zweifel!", italian="In ogni caso, questo lavoro\nè stato un fiasco clamoroso!", spanish="En cualquier caso, ¡lo que habéis\nhecho ha sido un desastre!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As such, there shall be\nno reward!", french="Il n'y aura donc aucune\nrécompense!", german="Daher wird es keine Belohnung\nfür euch geben!", italian="Pertanto...\nNiente ricompensa!", spanish="Por tanto, no habrá ninguna\nrecompensa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHAAAT?!", french=" QUOIIII?!", german=" WAAAS?!?", italian=" COOOSA?!", spanish=" ¡¿QUÉEEE?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Furthermore!", french=" Ce n'est pas tout!", german=" Das ist nicht alles!", italian=" E non è tutto!", spanish=" ¡Es más...!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You'll go without dinner tonight!", french="Vous irez vous coucher sans\nmanger!", german="Ihr geht heute ohne Abendessen\nins Bett!", italian="Stasera andrete a letto senza\ncena!", spanish="¡Esta noche os iréis a la cama\nsin cenar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-but...", french=" M-mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-but...", french=" M-mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  else
  SkySceneKit.say({english=" B-but...", french=" M-mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkyProg.set(5, 4) -- $SCENARIO_MAIN = scn[5,4] (ROM)
  -- @label_4 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  elseif __sw == 1 then
  -- @switch0_727 [étiquette de flux ExplorerScript]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've done an honest\nday's work! ♪", french="Voilà une bonne journée de\ntravail qui se termine! ♪", german="Ihr habt einen langen Arbeitstag\nhinter euch, ihr zwei! ♪", italian=" Avete lavorato abbastanza! ♪", spanish=" ¡Hoy habéis trabajado mucho! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me review your sentry-duty\nperformance...", french="Je vais examiner vos\nrésultats...", german="Lasst mich überprüfen, wie ihr\neuch angestellt habt.", italian="Fatemi vedere come ve la siete\ncavata con il turno di guardia...", spanish="Ahora me toca valorar vuestro\ntrabajo como vigías."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Your results were...[K]adequate.", french=" Vos résultats sont...[K] passables.", german="Eure Ergebnisse sind...[K]\nbefriedigend.", italian="I vostri risultati sono...[K]\ncosì così.", spanish="Vuestro resultado ha sido...[K]\ncorrecto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_DECENT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Oh, oh..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Oh, oh..."})
  else
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Oh, oh..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Here are your rewards for\nthe job.", french="Voici vos récompenses\npour ce travail.", german="Hier ist eure Belohnung für den\nJob.", italian="Ecco la vostra ricompensa per il\nlavoro svolto.", spanish=" Esta es vuestra recompensa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]As a reward for doing the job,\n[CN][hero]'s team...", french="[CN]En récompense pour le travail\n[CN]accompli, l'équipe de [hero]...", german="[CN]Für den ausgeführten Job\n[CN]erhält das Team von [hero]...", italian="[CN]Come ricompensa per il lavoro,\n[CN]la squadra di [hero]...", spanish="[CN]Como recompensa por cumplir con\n[CN]su deber, el equipo de [hero]..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]received [CS:G]100[CR][M:S0]!", french="[CN]reçoit [CS:G]100[CR][M:S0]!", german="[CN]Eine Belohnung von [CS:G]100[CR][M:S0]!", italian="[CN]riceve [CS:G]100[CR][M:S0]!", spanish="[CN]¡Recibió [CS:G]100[CR][M:S0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CARRY_GOLD = ((SV.SkyVars.CARRY_GOLD) or 0) + 100 -- $CARRY_GOLD += 100 (ROM)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]In addition, the team\n[CN]also received a [CS:I]Protein[CR]!", french="[CN]De plus, l'équipe reçoit\n[CN]aussi une [CS:I]Protéine[CR]!", german="[CN]Außerdem erhält das Team\n[CN]ein [CS:I]Protein[CR]!", italian="[CN]Inoltre, la squadra\n[CN]riceve una [CS:I]Proteina[CR]!", spanish="[CN]Además, ¡el equipo recibió\n[CN]también una [CS:I]Proteína[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 100, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I expect to see better effort\nout of you lot next time. ♪", french="J'attends de vous de meilleurs\nrésultats la prochaine fois. ♪", german="Das nächste Mal erwarte ich\neine bessere Leistung von euch. ♪", italian="Spero che la prossima volta\nvi impegnerete di più! ♪", spanish="Espero que os esforcéis más\nla próxima vez. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- @switch0_726 [étiquette de flux ExplorerScript]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You've all worked an honest day.", french="Voilà une bonne journée de\ntravail qui se termine! ♪", german="Ihr habt einen langen Arbeitstag\nhinter euch, ihr zwei! ♪", italian=" Avete lavorato abbastanza! ♪", spanish=" Habéis trabajado duro."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me review your sentry-duty\nperformance...", french="Je vais examiner vos\nrésultats...", german="Lasst mich überprüfen, wie ihr\neuch angestellt habt...", italian="Fatemi vedere come ve la siete\ncavata con il turno di guardia...", spanish="Ahora me toca valorar vuestro\ntrabajo como vigías."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your results were...[K]\nHmm! Well done!", french="Vos résultats sont...[K] pas mal!\nHum! Bien joué!", german="Eure Ergebnisse sind...[K]\nHmm! Nicht schlecht!", italian="I vostri risultati sono...[K]\nMmm! Niente male!", spanish="Vuestros resultados han sido...[K]\nHum... ¡Bastante buenos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Good job, team! ♪", french=" Beau travail, tout le monde! ♪", german=" Gut gemacht, Team! ♪", italian=" Buon lavoro, squadra! ♪", spanish=" ¡Buen trabajo, equipo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_GOOD_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Good!", french=" Super!", german=" Gut!", italian=" Bene!", spanish=" ¡Bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yay!", french=" Youpi!", german=" Jaaa!", italian=" Vai!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yay!", french=" Youpi!", german=" Jaaa!", italian=" Vai!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yay!", french=" Youpi!", german=" Jaaa!", italian=" Vai!", spanish=" ¡Sí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Here are your rewards for all\nyour work today! ♪", french="Voici vos récompenses pour le\ntravail de la journée! ♪", german="Hier ist eure Belohnung für die\nheutige Arbeit! ♪", italian="Ecco la vostra ricompensa per il\nlavoro svolto. ♪", spanish="¡Aquí tenéis vuestra recompensa\npor el trabajo de hoy! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]As thanks for a job well\n[CN]done, [hero]'s team...", french="[CN]En remerciement pour son travail\n[CN]bien fait, l'équipe de [hero]...", german="[CN]Für den gut ausgeführten Job\n[CN]erhält das Team von [hero]...", italian="[CN]Come ricompensa per il buon lavoro,\n[CN]la squadra di [hero]...", spanish="[CN]Como premio por el trabajo bien\n[CN]hecho, el equipo de [hero]..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]received [CS:G]200[CR][M:S0]!", french="[CN]reçoit [CS:G]200[CR][M:S0]!", german="[CN][CS:G]200[CR][M:S0] als Dankeschön!", italian="[CN]riceve [CS:G]200[CR][M:S0]!", spanish="[CN]¡Recibió [CS:G]200[CR][M:S0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CARRY_GOLD = ((SV.SkyVars.CARRY_GOLD) or 0) + 200 -- $CARRY_GOLD += 200 (ROM)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]In addition, the team\n[CN]also received a [CS:I]Zinc[CR]!", french="[CN]En outre, l'équipe reçoit\n[CN]aussi un [CS:I]Zinc[CR]!", german="[CN]Außerdem erhält das Team\n[CN]ein [CS:I]Zink[CR]!", italian="[CN]Inoltre, la squadra\n[CN]riceve dello [CS:I]Zinco[CR]!", spanish="[CN]¡El equipo recibió además\n[CN]un [CS:I]Zinc[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 108, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]Not only that, the team\n[CN]also received a [CS:I]Nectar[CR]!", french="[CN]Et ce n'est pas tout, l'équipe\n[CN]reçoit aussi un [CS:I]Nectar[CR]!", german="[CN]Und nicht nur das, das Team\n[CN]erhält außerdem einen [CS:I]Nektar[CR]!", italian="[CN]Non solo, la squadra\n[CN]riceve anche un [CS:I]Nettare[CR]!", spanish="[CN]Y no solo eso, ¡el equipo recibió\n[CN]también un [CS:I]Néctar[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 103, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Keep up the good work! ♪", french="Continuez à bien\ntravailler! ♪", german=" Macht weiter so! ♪", italian=" Continuate così! ♪", spanish=" ¡Seguid así! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- jump @switch0_724 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 5 then
  -- jump @switch0_727 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 6 then
  -- jump @switch0_726 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- jump @switch0_725 [saut final vers l'épilogue de switch: flux naturel]
  elseif true then -- default
  -- @switch0_725 [étiquette de flux ExplorerScript]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've worked an honest day,\nyou two! ♪", french="Voilà une bonne journée de\ntravail qui se termine! ♪", german="Ihr habt einen langen Arbeitstag\nhinter euch, ihr zwei! ♪", italian=" Avete lavorato abbastanza! ♪", spanish=" ¡Hoy habéis trabajado mucho! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me review your sentry-duty\nperformance...", french="Je vais examiner vos\nrésultats...", german="Lasst mich überprüfen, wie ihr\neuch angestellt habt.", italian="Fatemi vedere come ve la siete\ncavata con il turno di guardia...", spanish="Ahora me toca valorar vuestro\ntrabajo como vigías."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well, well![K] Your results were...\ncompletely perfect!", french="Bien![K] Vos résultats sont...\nirréprochables! Parfait!", german="Na also![K] Eure Ergebnisse sind\nabsolut perfekt!", italian="Bene, bene![K] I vostri risultati\nsono... assolutamente perfetti!", spanish="¡Bien, bien! Vuestros resultados\nhan sido...[K] ¡completamente perfectos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You identified every visitor\ncorrectly! ♪", french="Vous avez correctement\nidentifié chaque visiteur! ♪", german="Ihr habt jeden Besucher richtig\nidentifiziert! ♪", italian="Avete identificato\ntutti correttamente! ♪", spanish="¡Habéis identificado\ncorrectamente a todos los visitantes! ♪"})
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GAME:MoveCamera(172, 284, 1, false) end) -- SetPositionMark performer/caméra
  pcall(function() GAME:MoveCamera(144, 284, 1, false) end) -- SetPositionMark performer/caméra
  pcall(function() GAME:MoveCamera(200, 284, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_5 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_6 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_7 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Excellent!", french=" Excellent!", german=" Hervorragend!", italian=" Eccellente!", spanish=" ¡Excelente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We did it!", french=" On a réussi!", german=" Wir haben es geschafft!", italian=" Ce l'abbiamo fatta!", spanish=" ¡Lo logramos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We did it!", french=" On a réussi!", german=" Wir haben es geschafft!", italian=" Ce l'abbiamo fatta!", spanish=" ¡Lo logramos!"})
  else
  SkySceneKit.say({english=" We did it!", french=" On a réussi!", german=" Wir haben es geschafft!", italian=" Ce l'abbiamo fatta!", spanish=" ¡Lo logramos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7944, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We'll reward your effort![K]\nGenerously, I might add!", french="Vos efforts vont être\nrécompensés![K] Et plutôt généreusement,\nmême!", german="Wir werden eure Mühe\nbelohnen![K] Und zwar nicht zu knapp, möchte ich\nhinzufügen!", italian="Ricompenseremo i vostri\nsforzi![K] In modo generoso, aggiungerei!", spanish="¡Recompensaré vuestro\nesfuerzo![K] ¡Generosamente, además!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You all deserve an especially\nlarge reward! ♪", french="Vous avez mérité une jolie\nrécompense! ♪", german="Ihr habt euch eine besonders\ngroße Belohnung verdient! ♪", italian="Vi meritate una lautissima\nricompensa! ♪", spanish="¡Os merecéis un premio\nespecial! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]As the reward for a job perfectly\n[CN]done, [hero]'s team...", french="[CN]En récompense pour son travail parfaitement\n[CN]exécuté, l'équipe de [hero]...", german="[CN]Für den perfekt ausgeführten Job\n[CN]erhält das Team von [hero]...", italian="[CN]Come ricompensa per il lavoro svolto in\n[CN]modo perfetto, la squadra di [hero]...", spanish="[CN]Como recompensa por un trabajo impecable,\n[CN]el equipo de [hero]..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]received [CS:G]500[CR][M:S0]!", french="[CN]... reçoit [CS:G]500[CR][M:S0]!", german="[CN][CS:G]500[CR][M:S0] als Belohnung!", italian="[CN]riceve [CS:G]500[CR][M:S0]!", spanish="[CN]¡Recibió [CS:G]500[CR][M:S0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CARRY_GOLD = ((SV.SkyVars.CARRY_GOLD) or 0) + 500 -- $CARRY_GOLD += 500 (ROM)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]In addition, the team\n[CN]also received a [CS:I]Joy Seed[CR]!", french="[CN]En outre, l'équipe reçoit\n[CN]aussi une [CS:I]Allégraine[CR]!", german="[CN]Außerdem erhält das Team\n[CN]einen [CS:I]Lv.+ Samen[CR]!", italian="[CN]Inoltre, la squadra\n[CN]riceve un [CS:I]Gaudioseme[CR]!", spanish="[CN]¡El equipo recibió además\n[CN]una [CS:I]Sem. Júbilo[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 89, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]Not only that, the team\n[CN]also received a [CS:I]Ginseng[CR]!", french="[CN]Et ce n'est pas tout, l'équipe\n[CN]reçoit aussi un [CS:I]Ginseng[CR]!", german="[CN]Und nicht nur das... Das Team\n[CN]erhält außerdem einen [CS:I]Ginseng[CR]!", italian="[CN]Non solo, la squadra\n[CN]riceve anche un [CS:I]Ginseng[CR]!", spanish="[CN]Y no solo eso, ¡el equipo recibió\n[CN]también un [CS:I]Ginseng[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 88, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]But that's not the end of it!", french="[CN]Et ce n'est toujours pas fini!", german="[CN]Aber das ist noch nicht alles!", italian="[CN]Ma non è ancora finita!", spanish="[CN]¡Y eso no es todo!"})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The team also\n[CN]received a [CS:I]Life Seed[CR]!", french="[CN]L'équipe reçoit\n[CN]une [CS:I]Pévégraine[CR]!", german="[CN]Das Team erhält\n[CN]außerdem einen [CS:I]Lebenssamen[CR]!", italian="[CN]La squadra riceve\n[CN]pure un [CS:I]Semevita[CR]!", spanish="[CN]¡El equipo también\n[CN]recibió una [CS:I]Semilla Vida[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 77, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]So many rewards! Can you believe it?", french="[CN]Que de récompenses! Incroyable!", german="[CN]So viele Belohnungen! Kannst du es fassen?", italian="[CN]Una tale ricompensa! Riesci a crederci?", spanish="[CN]¡Cuántas recompensas! ¡Es increíble!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Keep up the good work! ♪", french="Continuez à bien\ntravailler! ♪", german=" Macht weiter so! ♪", italian=" Continuate così! ♪", spanish=" ¡Seguid así! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
