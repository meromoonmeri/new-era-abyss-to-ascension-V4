-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m06a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone! ♪ I have an\nannouncement before we get down to work.", french="Ecoutez tous! ♪ J'ai une\nannonce importante à faire avant que vous\nne commenciez à travailler.", german="Alles herhören! ♪ Ich habe eine\nNeuigkeit zu melden, bevor wir unsere Arbeit\nbeginnen.", italian="Ehi, gente! ♪ Ho un annuncio da\nfare prima che torniate al lavoro.", spanish="¡Escuchadme todos! ♪\nTengo que anunciaros algo antes\nde que empecéis a trabajar."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me introduce our\nnew allies. ♪", french="Laissez-moi vous présenter\nnos nouveaux alliés. ♪", german="Lasst mich unsere neuen\nVerbündeten vorstellen. ♪", italian="Voglio presentarvi dei nuovi\namici. ♪", spanish="Permitidme presentaros\na nuestros nuevos compañeros. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Allies? What, more new\napprentices?", french="Nos alliés? Quoi, encore de\nnouveaux apprentis?", german="Verbündete? Gibt es wieder neue\nLehrlinge?", italian="Amici? Ci sono dei nuovi\napprendisti?", spanish="¿Compañeros?\n¿Tenemos más aprendices aún?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly, I wonder what kinds of\nPokémon they are?", french="Sapristi! Je m'demande bien qui\nc'est.", german="Donnerwetter! Was das wohl\nfür Pokémon sind?", italian=" Ohibò, che Pokémon saranno?", spanish="Huy, me pregunto qué tipo\nde Pokémon serán..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey! Over here, please. ♪", french=" Par ici, s'il vous plaît. ♪", german=" Hey! Herhören, bitte. ♪", italian="Ehi! Da questa parte, per\nfavore. ♪", spanish=" Venid aquí, por favor. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(30) end) -- bgm_ChangeVolume vers 0 (silence)
  -- GAP: se_Play(6661) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 639 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(20)
  -- Move2PositionOffset 3 [cible sans placement SSA zone: déplacement non joué]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Ugh! What stinks?!", french=" Argh! Quelle puanteur!", german=" Umpf! Was mieft hier so?!?", italian=" Ugh! Che puzza!", spanish=" ¡Puaj! ¡Qué pestazo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Eek! It reeks like rotten cheese!\nEwwww!", french="Beurk! Encore cette odeur de\nfromage pourri! On pourrait peut-être passer\ndirectement au dessert pour aujourd'hui!", german="Ieek! Es stinkt nach\nvergammeltem Käse! Wäääh!", italian="Eek! Puzza di formaggio andato\na male! Bleah!", spanish="¡Ayy! ¡Huele que apesta!\n¡Qué asco!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! That is some kind of\nfoul stench!", french="Ouaip! Ben avec c'te puanteur,\nj'pense que l'dessert a dû s'gâter aussi,\npour sûr!", german="Jawollja! Was für ein übler\nGestank das ist!", italian="Sì, sì! Una puzza davvero\ntremenda!", spanish=" Huy, ¡desde luego, vaya tufo!"})
  -- message_Close
  -- se_FadeOut(6661, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 328, 112, Direction.Up, "NPC_SUKATANKU")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 180, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(30)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 328, 104, Direction.Up, "NPC_ZUBATTO")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 180, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(30)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 328, 96, Direction.Up, "NPC_DOGAASU")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 180, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 420, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 388, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 364, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_pukurin, 444, 196, false, 2)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It-it's them!", french=" C'est eux!", german=" D-die sind das!", italian=" S-Sono loro!", spanish=" Son... ¡Son ellos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It-it's them!", french=" C'est eux!", german=" D-die sind das!", italian=" S-Sono loro!", spanish=" Son... ¡Son ellos!"})
  else
  SkySceneKit.say({english=" It-it's them!", french=" C'est eux!", german=" D-die sind das!", italian=" S-Sono loro!", spanish=" Son... ¡Son ellos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These three are our new\npartners. ♪", french="J'ai le plaisir de vous annoncer\nque ces trois Pokémon sont nos nouveaux\npartenaires. ♪", german="Diese drei sind unsere neuen\nPartner. ♪", italian="Questi sono i nostri nuovi\namici. ♪", spanish="Estos son nuestros nuevos\ncompañeros. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho! I'm [CS:N]Koffing[CR].", french="Mouarf mouarf mouarf! Je suis\n[CS:N]Smogo[CR].", german=" Whoahoho! Ich bin [CS:N]Smogon[CR].", italian=" Salve! Io sono [CS:N]Koffing[CR].", spanish=" ¡Jo, jo, jo! Yo soy [CS:N]Koffing[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh! [CS:N]Zubat[CR] here. Glad to\nmeet you.", french="Hin hin hin! Moi c'est [CS:N]Nosferapti[CR].\nRavi de vous rencontrer.", german="Hehehe! [CS:N]Zubat[CR] ist mein\nName. Freut mich sehr.", italian="Eh-eh-eh! Io mi chiamo [CS:N]Zubat[CR].\nFelice di incontrarvi.", spanish="¡Jue, jue, jue! Y yo [CS:N]Zubat[CR].\nEncantado de conoceros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" And I'm Team [CS:X]Skull[CR]'s leader.", french="Et moi, je suis le meneur de\nl'Equipe [CS:X]Crâne[CR].", german="Und ich bin der Anführer von\nTeam [CS:X]Totenkopf[CR].", italian="E io sono il capo del\nTeam [CS:X]Teschio[CR].", spanish="Yo soy el líder del\n[CS:X]Equipo Calavera[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" I'm [CS:N]Skuntank[CR].[K] Remember it.", french="Mon nom est [CS:N]Moufflair[CR].[K]\nIl faut vous le mettre dans le crâne.", german="Ich bin [CS:N]Skuntank[CR].[K]\nMerkt euch das.", italian="Mi chiamo [CS:N]Skuntank[CR].[K]\nVedete di ricordarvelo.", spanish=" Me llamo [CS:N]Skuntank[CR].[K] Recordadlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukatanku, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Especially you two.\nChaw-haw-haw!", french="Surtout vous deux, là!\nGnark gnark gnark!", german=" Vor allem ihr zwei. Cha-ha-ha!", italian="Soprattutto voi due.\nAhr-ahr-ahr!", spanish="Sobre todo dos que yo me sé.\n¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What, you're already acquainted?", french="Comment? Vous avez déjà fait\nconnaissance?", german=" Wie, ihr kennt euch bereits?", italian=" Eh? Vi conoscete già?", spanish=" Vaya, ¿ya os conocéis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That simplifies things. ♪", french="Voilà qui simplifie grandement\nles choses. ♪", german=" Das erleichtert einiges. ♪", italian="Questo rende tutto più\nsemplice. ♪", spanish=" Pues mira qué bien. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These three aren't joining us as\napprentices.", french="Ils ne nous rejoignent pas en\ntant qu'apprentis.", german="Diese drei fangen hier nicht als\nLehrlinge an.", italian="Loro tre non si uniscono a noi\ncome apprendisti.", spanish="Estos tres no van a unirse\nal [CS:N]Pokégremio[CR] como aprendices."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They will be joining our\nexpedition to lend us their assistance. ♪", french="Ils vont se joindre à l'expédition\npour nous prêter main-forte. ♪", german="Sie werden zur Expedition\nmitkommen, um uns zu unterstützen. ♪", italian="Parteciperanno alla nostra\nspedizione per darci una mano. ♪", spanish="Lo que harán será unirse a\nla expedición para prestarnos su ayuda. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoi?!", german=" Waaas?!?", italian=" Cooooosa?!", spanish=" ¡¿Quéeee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoi?!", german=" Waaas?!?", italian=" Cooooosa?!", spanish=" ¡¿Quéeee?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Cooooosa?!", spanish=" ¡¿Cómo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Why are you so shocked?", french=" Pourquoi cet air surpris?", german=" Wieso bist du so schockiert?", italian=" Perché tanta sorpresa?", spanish=" ¿Por qué reaccionas así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR], sir, it's nothing. That one\nalways overreacts to every little thing.[K]\nChaw-haw-haw.", french="[CS:N]Pijako[CR], ce n'est rien. C'est un\nPokémon un peu émotif.[K] Gnark gnark gnark!", german="[CS:N]Plaudagei[CR], das hat nichts zu\nbedeuten. Dieses Pokémon überreagiert bei\njeder Kleinigkeit.[K] Cha-ha-ha.", italian="[CS:N]Chatot[CR], signore, non è niente.\nQuel Pokémon reagisce sempre in modo\nesagerato a qualsiasi cosa.[K] Ahr-ahr-ahr.", spanish="[CS:N]Chatot[CR], no hay de qué\npreocuparse. Es que es muy impresionable y\ntodo le afecta muchísimo.[K] Jua, jua, jua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hm. Very well, then.", french=" Hum hum. Bien!", german=" Hmm. Also gut.", italian=" Mmm. Molto bene.", spanish=" Hum. Bueno, vale."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Anyway, the Guildmaster has\nmade his decision.", french="Quoi qu'il en soit, le Maître de\nla Guilde a pris sa décision.", german="Wie auch immer, der\nGildenmeister hat seine Entscheidung getroffen.", italian="In ogni caso, il Capitano ha già\ndeciso.", spanish="De todas formas, el Gran Bluff\nya ha tomado una decisión sobre esto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He has decided that having this\ntrio take part will make us stronger on the\nexpedition.", french="Il a décidé d'intégrer ce\ntrio à l'expédition pour nous renforcer.", german="Er hat entschieden, dass wir\nstärker sind, wenn dieses Trio uns auf der\nExpedition begleitet.", italian="Ha stabilito che avere loro tre\ncon noi faciliterà le cose durante la spedizione.", spanish="Ha decidido que la compañía\nde este trío nos será muy útil en la\nexpedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="However, it would be impossible\nto coordinate teamwork if we were to begin\nworking together right away.", french="Toutefois, notre travail d'équipe\nne sera guère efficace si nous ne nous\nconnaissons pas un peu mieux avant.", german="Allerdings wäre es unmöglich,\ndie Teamarbeit zu koordinieren, wenn wir\nsofort mit der Zusammenarbeit beginnen.", italian="Tuttavia, sarebbe impossibile\ncoordinare il lavoro di squadra se iniziassimo\nsubito a lavorare insieme.", spanish="Sin embargo, les será difícil\ncoordinarse con nosotros si nos acompañan\nsin conocernos antes, al menos un poco."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Therefore, we've decided that\nthe trio should live with us for several days.", french="C'est pourquoi nous avons décidé\nque le trio allait passer quelques jours avec\nnous.", german="Deshalb haben wir beschlossen,\ndass die drei einige Tage bei uns wohnen\nwerden.", italian="Per questo motivo, abbiamo\ndeciso che loro tre staranno qui da noi per\nqualche giorno.", spanish="Por eso, hemos decidido que\nvivirán con nosotros una temporada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Though it will be only for a\nshort while, I ask everyone to treat our\nguests with hospitality. ♪", french="Et aussi court que soit leur\nséjour ici, je vous demande de traiter nos\ninvités avec respect. ♪", german="Es wird zwar nur für eine\nWeile sein, aber ich bitte euch alle, unsere\nGäste freundlich zu empfangen. ♪", italian="Anche se si fermeranno per\npoco, chiedo a tutti voi di essere gentili\nnei confronti dei nostri ospiti. ♪", spanish="Aunque solo estaremos juntos\nunos días, os ruego a todos que les tratéis\ncon la máxima hospitalidad. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="...Doesn't [CS:N]Chatot[CR] think something\nstinks about this? Literally?", french="... Est-ce que [CS:N]Pijako[CR] ne se rend\npas compte qu'il y a quelque chose de POURRI\nà la Guilde? Au sens propre du terme, même?", german="...Merkt [CS:N]Plaudagei[CR] nicht, dass die\nSache stinkt? Im wahrsten Sinne des Wortes?", italian="[CS:N]Chatot[CR] non si rende conto che\nc'è qualcosa che puzza qui... nel vero senso\ndella parola?", spanish="¿Pero es que [CS:N]Chatot[CR] no se da\ncuenta de que algo huele mal? ¿Literalmente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="...Eww. How can the Guildmaster\nstand this?", french="... Beurk. Comment le Maître de\nla Guilde peut-il supporter ça?", german="...Igitt. Wie hält der\nGildenmeister das aus?", italian="Come può il Capitano\nsopportare una cosa del genere?", spanish="¡Puaj! ¿Cómo puede aguantar\nesto el Gran Bluff?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I sure hope this expedition ends\nsoon! Yup yup!", french="J'espère que l'expédition sera\nvite pliée! Pour sûr!", german="Ich hoffe, diese Expedition ist\nbald vorbei! Jawollja!", italian="Spero proprio che questa\nspedizione finisca presto! Sì, sì!", spanish="¡Espero que la expedición no\ndure mucho! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone. ♪ Let's get\ndown to work. ♪", french="Allez tout le monde! ♪\nAu travail! ♪", german="Nun gut, Pokémon. ♪ Machen\nwir uns an die Arbeit. ♪", italian="Forza, gente. ♪ Mettiamoci\nal lavoro. ♪", spanish="Muy bien. ♪ Y ahora,\n¡a trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: ...Hooray.", french="[CS:N]Tous[CR]: ... Hourra.", german="[CS:N]Alle[CR]: ...Hurra.", italian="[CS:N]Tutti[CR]: ... Urrà.", spanish="[CS:N]Todos[CR]: Hurra..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What's this?[K] Where's your\nusual spirit?", french="Que se passe-t-il?[K] Où est\npassée votre ferveur habituelle?", german="Was war denn das?[K] Wo bleibt\neuer Enthusiasmus?", italian="Cosa succede?[K] Dov'è la vostra\nsolita grinta?", spanish="¿Qué pasa?[K] ¿Dónde está vuestro\nentusiasmo de siempre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You gotta be KIDDING!", french=" Non mais c'est une BLAGUE!", german=" Das soll wohl ein SCHERZ sein!", italian=" Starai SCHERZANDO!", spanish=" ¡Será una broma!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="This STINKS! How do you expect\nus to be cheerful when...", french="Ça PUE! Comment tu veux qu'on\nsoit enjoués...", german="Die Sache STINKT! Wie sollen\nwir gut gelaunt sein, wenn...", italian="Con questa PUZZA! Come puoi\npretendere che siamo allegri, quando...", spanish="¡Esto apesta! ¿Cómo queréis\nque estemos contentos con esta...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WH-WHAT?", french=" QUOI?", german=" W-WAS?", italian=" C-COSA?", spanish=" ¿PERO QUÉ...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- SetAnimation(9) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '1')
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...", french=" TA-DAA...", german=" LUU...", italian=" BADA...", spanish=" ¡AUU!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOOOOOM...", french=" TA-DAAAAA...", german=" LUUUUU...", italian=" BAAAAAADAB...", spanish=" ¡AUUU!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No![K] The Guildmaster... His rage\nis building!", french="Non![K] Le Maître... il se met\nen colère!", german="Nein![K] Der Gildenmeister...\nSeine Wut baut sich auf!", italian="No![K] Il Capitano... Si sta\narrabbiando!", spanish="¡No![K] ¡El Gran Bluff se está\nenfureciendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If the Guildmaster gets angry,\nit will be horrific!", french="Si le Maître entre dans une\ncolère noire, ça va être affreux!", german="Es wird entsetzlich sein, wenn\nder Gildenmeister wütend wird!", italian="Se il Capitano si arrabbia sarà\nuna tragedia!", spanish="Si el Gran Bluff se enfada,\n¡será horrible!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone! Come on! Be cheerful,\neven if it hurts!", french="Allez! Tous ensemble! Faites\npreuve de bonne humeur, même si cela vous\nennuie!", german="Ihr alle! Kommt schon! Seid\ngut gelaunt, selbst wenn es wehtut!", italian="Gente! Forza! Siate allegri,\nanche se dovete sforzarvi!", spanish="¡Todos! ¡Venga! ¡Hay que\nalegrarse, aunque nos duela!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone. ♪ Let's get\ndown to today's work. ♪", french="Allez tout le monde! ♪\nAu travail! ♪", german="Nun gut, Pokémon. ♪ Machen\nwir uns an die heutige Arbeit. ♪", italian="Forza, gente. ♪ Andiamo a\noccuparci dei compiti di oggi. ♪", spanish="Muy bien. ♪ Ahora, todos\na trabajar. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:StopBGM() end)
  -- bgm2_Stop [canal BGM sub: voir bgm2_Play]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(16), p.Y+(-16), false, 2) end
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw! Glad to have\nmet you.", french="Gnark gnark gnark! Ravi d'avoir\nfait votre connaissance.", german="Cha-ha-ha! Es war mir eine\ngroße Freude.", italian="Ahr-ahr-ahr! Felice di avervi\nconosciuti.", spanish="¡Jua, jua, jua! Encantado\nde conoceros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 220, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho!", french=" Mouarf mouarf mouarf!", german=" Whoahoho!", italian=" Uooh-ho-ho!", spanish=" ¡Jo, jo, jo!"})
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 212, false, 2)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh!", french=" Hin hin hin!", german=" Hehehe!", italian=" Eh-eh-eh!", spanish=" ¡Jue, jue, jue!"})
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 132, false, 2)
  GAME:WaitFrames(15)
  -- message_CloseEnforce
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk! Something's suspicious\nabout them for sure.", french="Argh! Ils sont vraiment louches,\nceux-là. Aucun doute là-dessus.", german="Bah! Irgendetwas an denen\nkommt mir jedenfalls verdächtig vor.", italian="Urk! C'è sicuramente sotto\nqualcosa.", spanish="¡Hum! La verdad es que no hay\nque fiarse de ellos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk! Something's definitely\nsuspicious about them for sure.", french="Argh! Ils sont vraiment louches,\nceux-là. Aucun doute là-dessus.", german="Bah! Irgendetwas an denen\nkommt mir jedenfalls verdächtig vor.", italian="Urk! C'è sicuramente sotto\nqualcosa.", spanish="¡Hum! La verdad es que resultan\nmuy sospechosos."})
  else
  SkySceneKit.say({english="Urk! Something's definitely\nsuspicious about them for sure.", french="Argh! Ils sont vraiment louches,\nceux-là. Aucun doute là-dessus.", german="Bah! Irgendetwas an denen\nkommt mir jedenfalls verdächtig vor.", italian="Urk! C'è sicuramente sotto\nqualcosa.", spanish="¡Hum! La verdad es que resultan\nmuy sospechosos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what they're\nplotting...", french="Je ne sais pas ce qu'ils\ncomplotent...", german="Ich weiß nicht, was sie\nvorhaben...", italian=" Non so cosa stiano tramando...", spanish="No sé qué se traerán entre\nmanos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what they're\nscheming...", french="Je ne sais pas ce qu'ils\ncomplotent...", german="Ich weiß nicht, was sie\nim Schilde führen...", italian=" Non so cosa stiano tramando...", spanish=" No sé lo que estarán tramando..."})
  else
  SkySceneKit.say({english="I don't know what they're\nscheming...", french="Je ne sais pas ce qu'ils\ncomplotent...", german="Ich weiß nicht, was sie\nim Schilde führen...", italian=" Non so cosa stiano tramando...", spanish=" No sé lo que estarán tramando..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we'd better be careful,\n[hero].", french="... mais nous avons intérêt\nà être sur nos gardes, [hero].", german="Wir sollten besser vorsichtig\nsein, [hero].", italian="Ma ci conviene stare all'erta,\n[hero].", spanish="Pero será mejor que tengamos\ncuidado, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we'd better be careful,\n[hero].", french="... mais nous avons intérêt\nà être sur nos gardes, [hero].", german="Wir sollten besser vorsichtig\nsein, [hero].", italian="Ma ci conviene stare all'erta,\n[hero].", spanish="Pero será mejor que tengamos\ncuidado, [hero]."})
  else
  SkySceneKit.say({english="But let's be careful,\n[hero].", french="... mais nous avons intérêt\nà être sur nos gardes, [hero].", german="Wir sollten vorsichtig sein,\n[hero].", italian="Ma ci conviene stare all'erta,\n[hero].", spanish="Pero será mejor que tengamos\ncuidado, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two.", french=" Ah, vous deux.", german=" Ah, ihr zwei.", italian=" Ah, voi due.", spanish=" Ah, aquí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Take care of the jobs on the\nboards today, OK?", french="Occupez-vous des missions\naffichées sur les tableaux aujourd'hui,\nd'accord?", german="Ihr kümmert euch heute um die\nJobs an den Infobrettern, einverstanden?", italian="Oggi occupatevi delle missioni\nsulle Bacheche, va bene?", spanish="Encargaos hoy de las misiones\nde los dos tablones, ¿de acuerdo?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We're counting on you. ♪", french=" On compte sur vous. ♪", german=" Wir zählen auf euch. ♪", italian=" Contiamo su di voi. ♪", spanish="Contamos con vuestro\nesfuerzo. ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkyProg.set(7, 6) -- $SCENARIO_MAIN = scn[7,6] (ROM)
  SkySceneKit.cleanup_npcs()
end
