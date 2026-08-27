-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P31A/n03a1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=9} -- $SCENARIO_SIDE = scn[42,9] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(132, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D45P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(1) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 184, 252, false, 2)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 224, 368, Direction.Up, "NPC_AAMARUDO")
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is...?", french=" C'est...?", german=" Ist dies...", italian=" Questa è...?", spanish=" ¿Es esto...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This seems to be the deepest\npart of the dungeon.", french="On dirait que c'est l'endroit le\nplus profond du donjon.", german="Dies ist anscheinend der tiefste\nTeil des Dungeons.", italian="Sembra essere la parte\npiù profonda del dungeon.", spanish="Parece ser la zona más\nprofunda del territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Make sure you're prepared.[K] You\ndon't know what awaits you ahead.", french="Assure-toi d'être bien préparé.[K]\nTu ne sais pas ce qui nous attend plus loin.", german="Mach dich bereit und sei auf der\nHut.[K] Du kannst nie wissen, was dich erwartet.", italian="Tieniti pronto.[K] Non sappiamo\ncosa ci attende da qui in poi.", spanish="Asegúrate de que estás listo.[K]\nNunca se sabe lo que puede estar esperándonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh![K] There's a door over there!", french=" Oh![K] Il y a une porte là-bas!", german=" Oh![K] Dort ist eine Tür!", italian=" Oh![K] C'è una porta laggiù!", spanish=" ¡Anda![K] ¡Ahí hay una puerta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(204, 192, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 184, 184, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.UpRight)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownRight)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Torches are burning all around...", french="Il y a des torches qui brûlent\ntout autour...", german=" Brennende Fackeln rundherum...", italian=" Delle torce accese intorno...", spanish=" Hay antorchas por todas partes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Master,[K] is there some kind of\ntrick to opening the door here too?", french="Maître,[K] pour ouvrir cette porte,\nil y a un truc aussi?", german="Meister,[K] gibt es auch hier einen\nbestimmten Trick, um die Tür zu öffnen?", italian="Maestro,[K] che ci sia anche qui\nuna specie di congegno da attivare per aprire\nla porta?", spanish="Maestro...[K] ¿Esta puerta también\ntiene trampa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You've really learned\na lot, Junior.", french="Tu as vraiment beaucoup\nappris, petit.", german="Du hast wirklich viel\ndazugelernt, Junior.", italian="Bravo, piccolo. Hai fatto\ndavvero molti progressi.", spanish=" Has aprendido muchísimo, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That's right.[K] These torches\nmust provide the solution to the puzzle of\nopening the door.", french="C'est juste.[K] Ces torches sont la\nclé dans la résolution de cette énigme.\nElles nous permettront d'ouvrir cette porte.", german="Ich denke schon.[K] Diese Fackeln\nmüssen der Schlüssel zum Mechanismus sein,\nder die Tür öffnet.", italian="Proprio così.[K] Queste torce\ndevono essere la chiave per risolvere\nl'enigma che ci consentirà di aprire la porta.", spanish="Eso es.[K] Las antorchas nos darán\nla clave del acertijo que abre la puerta."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Furthermore, this is a very\ncommon type of puzzle.", french="Sache en outre que ce type\nd'énigme est courant.", german="Darüber hinaus ist dies ein sehr\nverbreiteter Mechanismus.", italian="Inoltre si tratta di un enigma\nmolto comune.", spanish="Además, este tipo de acertijo\nes muy común."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What should we do?", french=" Qu'est-ce qu'il faut faire?", german=" Was müssen wir tun?", italian=" Cosa facciamo?", spanish=" ¿Qué hacemos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" It's simple.", french=" C'est élémentaire.", german=" Das ist einfach.", italian=" Semplice.", spanish=" Muy sencillo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If we blow out all the torches,\nthe door will open.[K] Watch!", french="Si nous éteignons toutes\nles torches, la porte s'ouvrira.[K] Regarde!", german="Wenn wir alle Fackeln\nlöschen, wird sich die Tür öffnen.[K]\nSieh mal!", italian="Se spegniamo tutte le torce,\nla porta si aprirà.[K] Guarda!", spanish="Si apagamos todas las antorchas,\nla puerta se abrirá.[K] ¡Observa mi ingenio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:MoveToPosition(npc_npc_aamarudo, 188, 160, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Here goes![K] [CS:M]Water Gun[CR]!", french=" Et hop![K] [CS:M]Pistolet à O[CR]!", german=" Hier kommt [K][CS:M]Aquaknarre[CR]!", italian=" Ecco qua![K] [CS:M]Pistolacqua[CR]!", spanish=" ¡Ahí va![K] ¡[CS:M]Pistola Agua[CR]!"})
  -- message_Close
  -- GAP: se_Play(9735) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- Slide2PositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A1_376) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_aamarudo, 228, 208, false, 2)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9735) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D45P31A6_549> [prop décor NDS]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  -- Slide2PositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A4_379) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_aamarudo, 188, 232, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9735) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D45P31A6_549> [prop décor NDS]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- Slide2PositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A3_378) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_aamarudo, 220, 184, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9735) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- SetPositionOffset<object OBJECT_D45P31A6_549> [prop décor NDS]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(8)
  -- SetPositionLives(293) [cible objet/id de décor NDS non simulée - trace]
  -- ResetOutputAttribute(1) [neutre/état moteur]
  -- SetPositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(20) [anim idle native]
  -- Slide2PositionOffset<object OBJECT_D45P31A6_548> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A6_548) [routine d'objet NDS non simulée - documenté]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D45P31A2_377) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="All right![K] The door should\nopen now!", french="Parfait![K] La porte devrait\ns'ouvrir maintenant!", german="Sehr gut![K] Die Tür sollte sich\njetzt öffnen!", italian="Bene![K] Ora la porta dovrebbe\naprirsi!", spanish="Muy bien.[K] La puerta debería\nestar abierta ya."})
  -- message_Close
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(60)
  -- se_FadeOut(5131, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(60)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh?[K] Master, the door\nisn't opening!", french="Hein?[K] Maître, la porte ne\ns'ouvre pas!", german="Huch![K] Meister, die Tür\nöffnet sich aber nicht!", italian="Eh?[K] Maestro, la porta è ancora\nchiusa!", spanish=" ¿Eh?[K] Pues no se abre, maestro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Why...[K] Why not?", french=" Pour...[K] pourquoi?", german=" Hmm...[K] Warum nur nicht?", italian=" Come...[K] Come mai?", spanish="Esto...[K] ¿Por qué no?\n¡Si eso nunca falla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9732) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(20), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(20), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 5)
  -- GAP: se_Play(7938) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Uwaaaaaaaahhhhhhhhhhhhhhh!!!!!", french=" Yaaaaaaaaaaaaaaaaaaaah!!!!!", german=" Uwaaaaaaaah!!!", italian=" Uaaaaaaaaahhhhhhhhhhhhhhh!!!!!!", spanish=" ¡¡¡Uaaaah!!!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  SkySceneKit.cleanup_npcs()
end
