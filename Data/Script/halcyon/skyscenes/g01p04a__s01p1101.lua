-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s01p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 5) -- $SCENARIO_MAIN = scn[29,5] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 416, 216, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 388, 216, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 432, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 412, 216, false, 1)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You've passed the\ngraduation exam!", french=" Vous avez réussi l'examen!", german="Ihr habt die Abschlussprüfung\nbestanden!", italian="Avete superato l'esame di\ndiploma!", spanish=" ¡Habéis superado el gran reto!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 352, 248, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 264, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 464, 224, Direction.DownLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 400, 272, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 368, 264, Direction.UpRight, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 472, 248, Direction.Left, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 360, 224, Direction.DownRight, "NPC_DOGOOMU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 432, 272, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(60)
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_5 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_6 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_7 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Congratulations![K] You two have\npassed the guild's graduation exam! ♪", french="Félicitations![K] Permettez-moi de\nvous remettre le diplôme de la Guilde! ♪", german="Herzlichen Glückwunsch![K]\nIhr beide habt die Gildenabschlussprüfung\nbestanden! ♪", italian="Congratulazioni![K] Voi due avete\nsuperato l'esame della Gilda. ♪", spanish="¡Felicidades![K] ¡Habéis superado\nel gran reto del [CS:N]Pokégremio[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" You did it! ♪", french=" Vous avez réussi! ♪", german=" Ihr habt es geschafft! ♪", italian=" Ce l'avete fatta! ♪", spanish=" ¡Lo conseguisteis! ♪"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7944, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Oh? Not celebrating?", french=" ...[K] Oh? On ne fait pas la fête?", german=" ...[K]Oh? Wird nicht gefeiert?", italian=" ...[K] Oh? Niente festeggiamenti?", spanish="¿Qué...? [K]¿Qué pasa? ¿No vais a\ncelebrarlo?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Are you maybe not happy?", french=" Ça ne vous fait pas plaisir?", german="Seid ihr vielleicht nicht\nglücklich?", italian=" Forse non siete felici?", spanish=" ¿Acaso no os alegráis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, yeah, I'm happy...[K] But it\nhasn't really sunk in...", french="Si, si, je suis très content...[K]\nMais je n'ai pas encore réalisé...", german="Na ja, ich bin schon glücklich...[K]\nAber ich habe es wohl noch nicht richtig\nrealisiert...", italian="Beh, certo, sono felice...[K] Ma\nnon me ne rendo ancora conto...", spanish="Bueno, claro que me alegro...[K]\nPero todavía no lo he asimilado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, yes, I'm happy...[K] But it\nhasn't really registered...", french="Si, si, je suis très content...[K]\nMais je n'ai pas encore réalisé...", german="Na ja, ich bin schon glücklich...[K]\nAber ich habe es wohl noch nicht richtig\nrealisiert...", italian="Beh, certo, sono felice...[K] Ma\nnon me ne rendo ancora conto...", spanish="Bueno, claro que me alegro...[K]\nPero todavía no lo he asimilado."})
  else
  SkySceneKit.say({english="Well, yes, I'm happy...[K] But it\nhasn't really sunk in...", french="Si, si, je suis très contente...[K]\nMais je n'ai pas encore réalisé...", german="Na ja, ich bin schon glücklich...[K]\nAber ich habe es wohl noch nicht richtig\nrealisiert...", italian="Beh, certo, sono felice...[K] Ma\nnon me ne rendo ancora conto...", spanish="Bueno, claro que me alegro...[K]\nPero todavía no lo he asimilado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's not like we did anything\nthat special...", french="Nous n'avons rien fait de\nspécial après tout...", german="Es ist ja nicht so, als hätten wir\nirgendetwas Außergewöhnliches vollbracht...", italian="Dopotutto, non abbiamo fatto\nniente di così speciale...", spanish="Tampoco me siento como si\nhubiéramos hecho nada especial..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't think we've accomplished\nanything that special...", french="Nous n'avons rien fait de\nspécial après tout...", german="Ich glaube nicht, dass wir\nirgendetwas Tolles geleistet haben...", italian="Dopotutto, non abbiamo fatto\nniente di così speciale...", spanish="No creo que hayamos hecho\nnada especial..."})
  else
  SkySceneKit.say({english="It's not like we did anything\nthat special...", french="Nous n'avons rien fait de\nspécial après tout...", german="Es ist ja nicht so, dass wir\nirgendwas Besonderes vollbracht hätten...", italian="Dopotutto, non abbiamo fatto\nniente di così speciale...", spanish="Tampoco hemos hecho nada\nespecial..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's not true at all![K] Don't you\nunderstand that what you two did\nwas incredible?", french="Bien au contraire![K] Vous\nne comprenez pas à quel point ce que vous\navez accompli est incroyable?", german="Das stimmt absolut nicht![K]\nVerstehst du nicht, wie unglaublich das ist,\nwas ihr zwei getan habt?", italian="Non è affatto vero![K] Non capite\nche quello che avete fatto ha dell'incredibile?", spanish="¡No es cierto![K] ¿No entendéis\nque habéis hecho algo increíble?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You went and brought back a\nfantastic treasure in a Perfect Apple.", french="Vous avez récolté un trésor\ninestimable: une Pomme Parfaite.", german="Ihr seid losgezogen und mit\neinem fantastischen Schatz in Form eines\nPerfekten Apfels zurückgekehrt.", italian="Avete riportato un fantastico\ntesoro, una Mela Perfetta.", spanish="Atravesasteis el territorio y\nlograsteis regresar con una Manzana\nPerfecta como tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" But even better than that...", french=" Mais encore mieux...", german=" Und damit nicht genug!", italian=" Ma, ancora meglio...", spanish=" Y sobre todo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You defeated that horrifying\ngrand master of all things bad, didn't you?!", french="... vous avez vaincu l'ignoble\ngrand maître de tous les maux, n'est-ce pas?!", german="Ihr habt auch noch den\nschauderlichen Großmeister allen Übels\nbesiegt, oder nicht?!?", italian="Avete sconfitto Sua Malvagità,\nnon è così?!", spanish="Derrotasteis al gran malo\nrequetemalo, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk![K] But that's what I\ndon't understand.", french="Argh![K] Il y a une chose que\nje ne suis pas sûr de comprendre.", german="Umpf![K] Aber das ist es, was ich\nnicht verstehe.", italian="Urk![K] Ma è questo\nche non capisco.", spanish=" Hum...[K] Hay algo que no entiendo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk![K] But that's what I\ndon't understand.", french="Argh![K] Il y a une chose que\nje ne suis pas sûr de comprendre.", german="Umpf![K] Aber das ist es, was ich\nnicht verstehe.", italian="Urk![K] Ma è questo\nche non capisco.", spanish=" Hum...[K] Hay algo que no entiendo."})
  else
  SkySceneKit.say({english="Urk![K] But that's what I\ndon't understand.", french="Argh![K] Il y a une chose que\nje ne suis pas sûre de comprendre.", german="Umpf![K] Aber das ist es, was ich\nnicht verstehe.", italian="Urk![K] Ma è questo\nche non capisco.", spanish=" Hum...[K] Hay algo que no entiendo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], how do you know\nthat we defeated the grand master of all\nthings bad?", french="Dites-moi, [CS:N]Grodoudou[CR], comment\nvous savez que nous avons vaincu le grand\nmaître de tous les maux?", german="[CS:N]Knuddeluff[CR], woher weißt du,\ndass wir den Großmeister allen Übels besiegt\nhaben?", italian="[CS:N]Wigglytuff[CR], come fai a sapere\nche abbiamo sconfitto Sua Malvagità?", spanish="[CS:N]Wigglytuff[CR], ¿cómo sabes que\nderrotamos al gran malo requetemalo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], how could you know\nthat we defeated the grand master of all\nthings bad?", french="Dites-moi, [CS:N]Grodoudou[CR], comment\nvous savez que nous avons vaincu le grand\nmaître de tous les maux?", german="[CS:N]Knuddeluff[CR], woher weißt du,\ndass wir den Großmeister allen Übels besiegt\nhaben?", italian="[CS:N]Wigglytuff[CR], come fai a sapere\nche abbiamo sconfitto Sua Malvagità?", spanish="[CS:N]Wigglytuff[CR], ¿cómo sabes que\nderrotamos al gran malo requetemalo?"})
  else
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], how do you know\nthat we defeated the grand master of all\nthings bad?", french="Dites-moi, [CS:N]Grodoudou[CR], comment\nvous savez que nous avons vaincu le grand\nmaître de tous les maux?", german="[CS:N]Knuddeluff[CR], woher weißt du,\ndass wir den Großmeister allen Übels besiegt\nhaben?", italian="[CS:N]Wigglytuff[CR], come fai a sapere\nche abbiamo sconfitto Sua Malvagità?", spanish="[CS:N]Wigglytuff[CR], ¿cómo sabes que\nderrotamos al gran malo requetemalo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" ...[K]Um...[K] We heard it somewhere?", french="...[K] Hum...[K] On nous l'a dit,\nje crois... Je ne sais plus qui...", german="...[K]Ähm...[K] Wir haben es von\nirgendwoher gehört?", italian="...[K] Ehm...[K] Forse me l'ha detto\nqualcuno?", spanish="Eh...[K] Esto...[K] Eso hemos oído\npor ahí, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Besides...", french=" Et puis...", german=" Außerdem...", italian=" Inoltre...", spanish=" Me da en la nariz que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Besides...", french=" Et puis...", german=" Außerdem...", italian=" Inoltre...", spanish=" Me da en la nariz que..."})
  else
  SkySceneKit.say({english=" Besides...", french=" Et puis...", german=" Außerdem...", italian=" Inoltre...", spanish=" Me da en la nariz que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That bad grand master...[K]\n[CS:N]Wigglytuff[CR], wasn't that you?", french="Ce grand maître...[K] [CS:N]Grodoudou[CR],\nce ne serait pas vous, par hasard?", german="Dieser böse Großmeister...[K]\n[CS:N]Knuddeluff[CR], warst das nicht du?", italian="[CS:N]Wigglytuff[CR], non eri tu...[K]\nSua Malvagità?", spanish="El gran malo requetemalo...[K]\neras tú, [CS:N]Wigglytuff[CR], ¿cierto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That bad grand master...[K]\n[CS:N]Wigglytuff[CR], wasn't that you?", french="Ce grand maître...[K] [CS:N]Grodoudou[CR],\nce ne serait pas vous, par hasard?", german="Dieser böse Großmeister...[K]\n[CS:N]Knuddeluff[CR], warst das nicht du?", italian="[CS:N]Wigglytuff[CR], non eri tu...[K]\nSua Malvagità?", spanish="El gran malo requetemalo...[K]\neras tú, [CS:N]Wigglytuff[CR], ¿no es verdad?"})
  else
  SkySceneKit.say({english="That bad grand master...[K]\n[CS:N]Wigglytuff[CR], wasn't that you?", french="Ce grand maître...[K] [CS:N]Grodoudou[CR],\nce ne serait pas vous, par hasard?", german="Dieser böse Großmeister...[K]\n[CS:N]Knuddeluff[CR], warst das nicht du?", italian="[CS:N]Wigglytuff[CR], non eri tu...[K]\nSua Malvagità?", spanish="El gran malo requetemalo...[K]\neras tú, [CS:N]Wigglytuff[CR], ¿no es verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Wie bitte?", italian=" Eh?", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "sweating", 1) end)
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Uh?[K] I...[K] I don't know?", french="Hein?[K] Je... euh...[K] Oh, un oiseau!\nLà!", german=" Äh?[K] Ich...[K] weiß nicht?", italian=" Eh?[K] Io...[K] Chi lo sa?", spanish=" ¿Eh?[K] Yo no...[K] No sé qué dices."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I don't know what you're talking\nabout.[K] G-grand master of all things bad?", french="Je ne sais absolument pas de\nquoi vous voulez parler.[K] Moi, le grand maître\nde tous les maux? Meeeeuh non!", german="Ich weiß nicht, wovon du\nredest.[K] G-großmeister allen Übels?", italian="Ma cosa state dicendo?[K]\nS-Sua Malvagità?", spanish="No sé de qué hablas.[K]\n¿El gran malo requetemalo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Me too!", french=" Moi non plus, aucune idée!", german=" Ich auch nicht!", italian=" Mai sentita una cosa del genere!", spanish=" ¡Yo tampoco!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I know nothing![K] The grand\nmaster's minions? What are they?", french="Je ne sais rien![K] J'ignore\nmême tout des sbires du grand maître!", german="Ich weiß von nichts![K] Des\nGroßmeisters Untergebene? Wer soll das sein?", italian="Non so niente![K] Gli sgherri\ndi Sua Malvagità? Cosa sono?", spanish="¡Ni idea![K] Y los secuaces del\nmalo, tampoco sé quiénes son."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Me too!", french=" Eh dis donc! Pareil pour moi!", german=" Hey, hey! Ich auch nicht!", italian=" Ehi, ehi! Neanche io!", spanish=" ¡Oye, oye! ¡Yo tampoco!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eek! I don't know any minions!", french="Hiii! Je ne sais pas ce que c'est,\nun sbire! C'est pire!", german="Ieek! Ich kenne keine\nUntergebenen!", italian="Ehi! Non conosco nessuno\nsgherro!", spanish="¡Yo no sé nada de secuaces!\n¡De verdad de la buena!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HA HA HA!", french="[CS:N]Tous[CR]: HA HA HA!", german="[CS:N]Alle[CR]: HA HA HA!", italian="[CS:N]Tutti[CR]: AH AH AH!", spanish="[CS:N]Todos[CR]: ¡JA, JA, JA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Everyone... What's going on...?", french="Vous tous... qu'est-ce que\nvous nous cachez...?", german=" Leute... Was geht hier vor?", italian=" Ma... Cosa sta succedendo?", spanish=" Pero, ¿qué os pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Everyone... What's going on...?", french="Vous tous... qu'est-ce que\nvous nous cachez...?", german=" Leute... Was geht hier vor?", italian=" Ma... Cosa sta succedendo?", spanish=" Pero, ¿qué os pasa?"})
  else
  SkySceneKit.say({english=" Everyone... What's going on...?", french="Vous tous... qu'est-ce que\nvous nous cachez...?", german=" Leute... Was geht hier vor?", italian=" Ma... Cosa sta succedendo?", spanish=" Pero, ¿qué os pasa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Anyway![K] You two have now\nofficially graduated from the guild! ♪", french="Hum, hum, enfin bref![K] J'ai le\nplaisir de vous annoncer que vous avez\nbrillamment obtenu le diplôme de la Guilde! ♪", german="Wie auch immer![K] Ihr beide seid\njetzt jedenfalls offiziell Gildenabsolventen! ♪", italian="Comunque stiano le cose...[K]\nVoi due avete ufficialmente superato l'esame\ndi diploma della Gilda! ♪", spanish="¡Da igual![K] ¡Lo que importa es\nque habéis superado el reto! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="From now on, you will no longer\nbe bound by the guild's strict regulations.", french="Les diplômés ne sont plus tenus\nau règlement strict de la Guilde.", german="Von nun an seid ihr von den\nstrengen Regeln der Gilde ausgenommen.", italian="D'ora in poi, non dovrete più\nattenervi alle severe regole della Gilda.", spanish="A partir de ahora, no se os\naplicarán las estrictas reglas del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You'll be free to operate as an\nexploration team totally on your own! ♪", french="Vous serez donc totalement\nlibres d'agir en tant qu'équipe d'exploration\ncomme bon vous semble! ♪", german="Euch steht es frei, als\nErkundungsteam völlig eigenständig zu\narbeiten! ♪", italian="Potrete liberamente operare\ncome squadra d'esplorazione! ♪", spanish="¡Podréis funcionar como un\nequipo explorador independiente! ♪"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! That's great!", french=" Oh! C'est super!", german=" Oh! Das ist klasse!", italian=" Oh! Fantastico!", spanish=" ¡Estupendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! Right!", french=" Oh! C'est super!", german=" Oh! Super!", italian=" Oh! Fantastico!", spanish=" ¡Genial!"})
  else
  SkySceneKit.say({english=" Oh! Right!", french=" Oh! C'est super!", german=" Oh! Super!", italian=" Oh! Fantastico!", spanish=" ¡Estupendo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Does that mean from now on...", french="Alors, est-ce que ça veut dire\nqu'à partir de maintenant...", german=" Heißt das...", italian=" Significa che da adesso in poi...", spanish="Significa eso que a partir de\nahora..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Does that mean from now on...", french="Alors, est-ce que ça veut dire\nqu'à partir de maintenant...", german=" Heißt das...", italian=" Significa che da adesso in poi...", spanish="Significa eso que a partir de\nahora..."})
  else
  SkySceneKit.say({english=" Does that mean from now on...", french="Alors, est-ce que ça veut dire\nqu'à partir de maintenant...", german=" Heißt das...", italian=" Significa che da adesso in poi...", spanish="Significa eso que a partir de\nahora..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That we get to keep all the\nreward money from the board jobs? And we\ndon't need to share with the guild?", french="... on pourra garder tout l'argent\ndes récompenses des missions? Plus besoin\nde le partager avec la Guilde?", german="Wir können all die Belohnungen\nvon den Jobs behalten und müssen das Geld\nnicht mehr mit der Gilde teilen?", italian="... potremo tenerci l'intera\nricompensa quando portiamo a termine le\nmissioni elencate sulle Bacheche?", spanish="¿Nos podemos quedar con todo\nel dinero de las recompensas? ¿No tenemos\nque repartirlo con el [CS:N]Pokégremio[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That we get to keep all the\nreward money from the board jobs? And we\ndon't need to share with the guild?", french="... on pourra garder tout l'argent\ndes récompenses des missions? Plus besoin\nde le partager avec la Guilde?", german="Wir können all die Belohnungen\nvon den Jobs behalten und müssen das Geld\nnicht mehr mit der Gilde teilen?", italian="... potremo tenerci l'intera\nricompensa quando portiamo a termine le\nmissioni elencate sulle Bacheche?", spanish="¿Nos podemos quedar con todo\nel dinero de las recompensas? ¿No tenemos\nque repartirlo con el [CS:N]Pokégremio[CR]?"})
  else
  SkySceneKit.say({english="That we get to keep all the\nreward money from the board jobs? And we\ndon't need to share with the guild?", french="... on pourra garder tout l'argent\ndes récompenses des missions? Plus besoin\nde le partager avec la Guilde?", german="Wir können all die Belohnungen\nvon den Jobs behalten und müssen das Geld\nnicht mehr mit der Gilde teilen?", italian="... potremo tenerci l'intera\nricompensa quando portiamo a termine le\nmissioni elencate sulle Bacheche?", spanish="¿Nos podemos quedar con todo\nel dinero de las recompensas? ¿No tenemos\nque repartirlo con el [CS:N]Pokégremio[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's awesome, [hero]!", french=" C'est génial, [hero]!", german=" Das ist spitze, [hero]!", italian=" È grandioso, [hero]!", spanish=" ¡Estupendo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's excellent, [hero]!", french=" C'est génial, [hero]!", german=" Das ist exzellent, [hero]!", italian=" È grandioso, [hero]!", spanish=" ¡Excelente, [hero]!"})
  else
  SkySceneKit.say({english=" That's fantastic, [hero]!", french=" C'est génial, [hero]!", german="Das ist fantastisch,\n[hero]!", italian=" È grandioso, [hero]!", spanish=" ¡Fantástico, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No.[K] Unfortunately for you, that\naspect doesn't change at all.", french="Non.[K] Malheureusement\npour vous, cela ne change en rien cet aspect\ndes choses.", german="Nein.[K] Zu unserem Bedauern\nändert sich an dieser Sache nichts.", italian="No.[K] Sfortunatamente per voi,\nquesto non cambia per niente.", spanish="No.[K] Lamento comunicaros que\nese aspecto no cambia en absoluto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As before, you will still have to\ngive most of that money to the guild.", french="Comme toujours, vous devrez\nverser la majeure partie de votre argent à\nla Guilde.", german="Wie bisher werdet ihr auch\nweiterhin den größten Teil eures verdienten\nGeldes an die Gilde abtreten müssen.", italian="Come prima, dovrete dare gran\nparte dei soldi alla Gilda.", spanish="Tendréis que dar al [CS:N]Pokégremio[CR]\nla mayor parte del dinero, igual que antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Wh-why...?", french=" Hein?![K] Qu-quoi...?", german=" Äh?!?[K] Aber warum?", italian=" Eh?![K] P-Perché...?", spanish=" ¿Qué?[K] Pero ¿por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Wh-why...?", french=" Hein?![K] Qu-quoi...?", german=" Was?!?[K] Aber warum?", italian=" Eh?![K] P-Perché...?", spanish=" ¿Qué?[K] Pero ¿por qué?"})
  else
  SkySceneKit.say({english=" What?![K] Wh-why...?", french=" Hein?![K] Qu-quoi...?", german=" Was?!?[K] Aber warum?", italian=" Eh?![K] P-Perché...?", spanish=" ¿Qué?[K] Pero ¿por qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Graduation from the guild means\nyou're still affiliated with us.", french="Etre diplômé de la Guilde\nsous-entend que le Pokémon est affilié\nà notre Guilde.", german="Ein Absolvent dieser Gilde zu\nsein, bedeutet, immer noch mit uns verbunden\nzu sein.", italian="Superare l'esame non significa\nche non esiste più nessun legame con noi.", spanish="Aunque hayáis superado el reto,\nseguiréis siendo parte del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your team, Team [team:],\ncan operate only because of this guild.", french="Si votre équipe, l'Equipe\n[team:], existe, c'est uniquement\ngrâce à cette Guilde.", german="Euer Team, Team [team:],\nkann nur arbeiten, weil es diese Gilde gibt.", italian="Voi, il Team [team:],\npotete operare solo grazie a questa Gilda.", spanish="Vuestro equipo, el [CS:X]Equipo[CR]\n[team:], puede realizar misiones\ngracias al [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So you'll need to accept that as\npart of being an exploration team! ♪", french="Vous devez donc accepter ça,\ncela fait partie de vos devoirs en tant\nqu'équipe d'exploration! ♪", german="Das gilt es zu akzeptieren, wenn\nihr ein Erkundungsteam sein wollt! ♪", italian="Quindi dovete accettare questa\nregola! Fa parte dell'essere una squadra\nd'esplorazione! ♪", spanish="¡Tendréis que aceptar estos\ntérminos para ser un equipo explorador! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk![K] But then, it's not as if\nanything's changed at all from before...", french="Argh![K] Mais alors, rien\nn'a changé par rapport à notre situation\nprécédente...", german="Umpf![K] Aber dann hat sich ja\nim Vergleich zu vorher gar nichts geändert...", italian="Urk![K] Ma allora, non cambia\nmolto rispetto a prima...", spanish="Pero...[K] entonces es como\nsi no hubiera cambiado nada..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk![K] But, I mean, it's not like\nanything has changed from before...", french="Argh![K] Mais alors, rien\nn'a changé par rapport à notre situation\nprécédente...", german="Umpf![K] Aber dann hat sich ja\nim Vergleich zu vorher gar nichts geändert...", italian="Urk![K] Ma allora, non cambia\nmolto rispetto a prima...", spanish="Pero...[K] entonces es como\nsi no hubiera cambiado nada..."})
  else
  SkySceneKit.say({english="Urk![K] But that's like...as if\nnothing's changed at all.", french="Argh![K] Mais alors, rien\nn'a changé par rapport à notre situation\nprécédente...", german="Umpf![K] Aber dann hat sich ja\nim Vergleich zu vorher gar nichts geändert...", italian="Urk![K] Ma allora, non cambia\nmolto rispetto a prima...", spanish="Pero...[K] entonces es como\nsi no hubiera cambiado nada..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Eek![K] You don't understand!\nGraduating from the guild is extraordinary!", french="Hii![K] Vous ne comprenez pas!\nEtre diplômé de la Guilde, c'est trop l'hallu!", german="Ieek![K] Ihr versteht es nicht!\nAls Absolvent von dieser Gilde abzugehen, ist\netwas ganz Besonderes!", italian="Ehi![K] Non capite!\nSuperare l'esame della Gilda è una\ncosa straordinaria!", spanish="¿Cómo?[K] ¡No lo entendéis!\n¡Superar el reto es algo superextraordinario!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" That's right!", french=" C'est vrai!", german=" Das stimmt!", italian=" Esatto!", spanish=" ¡Correcto!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I should know! Even I couldn't\npass the graduation exam!", french="Je suis bien placé pour\nle SAVOIR! Moi, j'ai planté l'examen!", german="Ich sollte es wissen! Sogar ich\nkonnte die Abschlussprüfung nicht bestehen!", italian="Lo so bene! Io non sono neppure\nriuscito a superarlo!", spanish="¡Hasta yo lo sé! ¡Y eso que\nno logré superarlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HAW-HAW-HO-HO-HAW!", french=" HAW HAW HO HO HAW!", german=" HAR-HAR-BU-HU-HUUU!", italian=" AAH-AAH-OH-OH-AAH!", spanish=" ¡JUA, JUA, JUA!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Anyway, you two have passed\nthe exam with flying colors! ♪", french="Quoi qu'il en soit, vous avez\nréussi cet examen haut la main! ♪", german="Wie dem auch sei, ihr beiden\nhabt die Prüfung mit Bravour bestanden! ♪", italian="In ogni caso, voi due avete\npassato l'esame con il massimo dei voti! ♪", spanish="¡Lo que importa es que habéis\nsuperado el reto y con creces! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I hope you'll keep up your great\nwork as explorers! ♪", french="J'espère que votre carrière\nen tant qu'équipe d'exploration sera tout\naussi brillante! ♪", german="Ich hoffe, ihr leistet weiter\nsehr gute Arbeit als Erkunder! ♪", italian="Spero che continuerete a darvi\nda fare come squadra d'esplorazione! ♪", spanish="¡Espero que sigáis explorando\nigual de bien que hasta ahora! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]...", french=" [CS:N]Grodoudou[CR]...", german=" [CS:N]Knuddeluff[CR]...", italian=" [CS:N]Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]...", french=" [CS:N]Grodoudou[CR]...", german=" [CS:N]Knuddeluff[CR]...", italian=" [CS:N]Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]...", french=" [CS:N]Grodoudou[CR]...", german=" [CS:N]Knuddeluff[CR]...", italian=" [CS:N]Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Congratulations, [partner]\nand [hero]!", french="Félicitations, [partner]\net [hero]!", german="Herzlichen Glückwunsch,\n[partner] und [hero]!", italian="Congratulazioni, [partner]\ne [hero]!", spanish="¡Felicidades, [partner]!\n¡Felicidades, [hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! How wonderful!", french="Ben mince alors! C'est\ngiga top! J'en crois pas mes pétales!", german=" Auweia! Wie toll!", italian=" Shock! Fantastico!", spanish=" ¡Es supermaravilloso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Sniff...! I'm so happy for you\nall...[K] I'm...[K] I'm...", french="Snif... J'suis hyper content\npour vous...[K] Je...[K] je...", german="Schnief! Ich freu mich so für\neuch...[K] Ich bin...[K] Ich bin...", italian="Sniff...! Sono così contento per\nvoi...[K] Sono...[K] Sono...", spanish="Snif... Me alegro tanto...[K]\nEstoy...[K] Estoy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Drop in on your old friends now\nand then!", french="Oubliez pas de passer voir vos\nvieux copains de temps en temps, d'acc?", german="Schaut ab und zu mal bei euren\nalten Freunden rein!", italian="Tornate a far visita ai vostri\nvecchi amici ogni tanto!", spanish="¡No os olvidéis de los viejos\namigos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" E-everyone...", french=" V-vous tous...", german=" I-ihr alle...", italian=" T-Tutti...", spanish=" Chicos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" E-everyone...", french=" V-vous tous...", german=" I-ihr alle...", italian=" T-Tutti...", spanish=" Chicos..."})
  else
  SkySceneKit.say({english=" E-everyone...", french=" V-vous tous...", german=" I-ihr alle...", italian=" T-Tutti...", spanish=" Chicos..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Congratulations,\nTeam [team:]! ♪", french="Félicitations,\nEquipe [team:]! ♪", german="Glückwunsch,\nTeam [team:]! ♪", italian="Congratulazioni,\nTeam [team:]! ♪", spanish="¡Felicidades, [CS:X]Equipo[CR]\n[team:]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh...[K] E-e-everyone...[K] Thank you,\neveryone!", french="Oh...[K] V-vous tous...[K] Merci\ninfiniment!", german="Oh...[K] I-i-ihr alle...[K] Vielen\nDank an euch alle!", italian="Oh...[K] T-T-Tutti...[K] Grazie a\ntutti!", spanish="Vaya...[K] Chicos...[K]\n¡Muchas gracias a todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh...[K] E-e-everyone...[K] Thank you,\neveryone!", french="Oh...[K] V-vous tous...[K] Merci\ninfiniment!", german="Oh...[K] I-i-ihr alle...[K] Vielen\nDank an euch alle!", italian="Oh...[K] T-T-Tutti...[K] Grazie a\ntutti!", spanish="Vaya...[K] Chicos...[K]\n¡Muchas gracias a todos!"})
  else
  SkySceneKit.say({english="Oh...[K] E-e-everyone...[K] Thank you,\neveryone!", french="Oh...[K] V-vous tous...[K] Merci\ninfiniment!", german="Oh...[K] I-i-ihr alle...[K] Vielen\nDank an euch alle!", italian="Oh...[K] T-T-Tutti...[K] Grazie a\ntutti!", spanish="Oh...[K] Chicos...[K]\n¡Muchas gracias a todos!"})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- se_FadeOut(7944, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The Exploration Team Federation\n[CN]has sent a message...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Mitteilung geschickt...[W:30]", italian="[CN]Arriva un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]La Federación de Exploradores\n[CN]ha enviado un mensaje...[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded\n[CN]with an enlarged Treasure Bag![W:100]", french="[CN]L'équipe de [hero] est récompensée\n[CN]avec un Sac à Trésor plus grand![W:100]", german="[CN]Dem Team von [hero] wird ein\n[CN]größerer Schatzbeutel verliehen![W:100]", italian="[CN]La squadra di [hero] riceve in premio\n[CN]una Sacca dei tesori più capiente![W:100]", spanish="[CN]¡El equipo de [hero] ha sido premiado\n[CN]con una Bolsa más grande![W:100]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]You can now carry more\n[CN]items than you could before!", french="[CN]Désormais, vous pouvez transporter\n[CN]plus d'objets qu'avant!", german="[CN]Ihr könnt jetzt mehr Items\n[CN]tragen als zuvor!", italian="[CN]Adesso potrete trasportare molti più\n[CN]strumenti di prima!", spanish="[CN]¡Ahora puedes llevar\n[CN]más objetos que antes!"})
  -- message_Close
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Also, as start-up funds for\n[CN]the newly affiliated team...", french="[CN]En outre, en guise de capital de départ\n[CN]pour l'équipe nouvellement affiliée...", german="[CN]Zusätzlich, als Startkapital für das\n[CN]neue, an die Gilde angegliederte Team,", italian="[CN]Inoltre, la squadra\n[CN]riceve un premio particolare...", spanish="[CN]Asimismo, como fondos para el nuevo equipo\n[CN]explorador..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Team [team:] received\n[CN][CS:G]10[MP]000[CR][M:S0]!", french="[CN]L'Equipe [team:] reçoit\n[CN][CS:G]10 000[CR][M:S0]!", german="[CN]erhält Team [team:]\n[CN][CS:G]10.000[CR][M:S0]!", italian="[CN]Il Team [team:] ha ricevuto\n[CN][CS:G]10[MP]000[CR][M:S0]!", spanish="[CN]¡El [CS:X]Equipo[CR] [team:] ha obtenido\n[CN][CS:G]10 000[CR][M:S0]!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]One more thing...", french="[CN]Et ce n'est pas tout...", german="[CN]Noch etwas...", italian="[CN]Ma non solo...", spanish="[CN]Una cosa más..."})
  -- message_Close
  -- back_SetGround(LEVEL_V17P03A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"In the Future of Darkness\"\n[CN]has been unlocked![W:90]", french="[CN]L'Episode Spécial\n[CN]\"Dans l'ombre du futur\"\n[CN]est maintenant disponible![W:90]", german="[CN]Die Bonusepisode\n[CN][F:S2]In der dunklen Zukunft[F:E2]\n[CN]wurde freigeschaltet![W:90]", italian="[CN]L'episodio speciale\n[CN]\"Salto nel futuro oscuro!\"\n[CN]è ora disponibile![W:90]", spanish="[CN]Se ha desbloqueado\n[CN]el capítulo especial\n[CN]\"En un futuro oscuro\".[W:90]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]To play a Special Episode,\n[CN]select it from the Episode List\n[CN]on the Top Menu.", french="[CN]Pour jouer à un Episode Spécial,\n[CN]sélectionnez-le dans la Liste des épisodes\n[CN]à partir du menu principal.", german="[CN]Um eine Bonusepisode zu spielen,\n[CN]wähle sie in der Episodenliste\n[CN]im Hauptmenü aus.", italian="[CN]Per giocare a un episodio speciale,\n[CN]selezionalo dalla lista episodi\n[CN]nel menu principale.", spanish="[CN]Para jugar a un capítulo especial,\n[CN]elígelo en la lista de capítulos\n[CN]del menú principal."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]If you would like to play the Special Episode,\n[CN]save your adventure progress, and\n[CN]return to the Top Menu.", french="[CN]Si vous souhaitez jouer à cet Episode Spécial,\n[CN]sauvegardez d'abord votre aventure\n[CN]puis retournez au menu principal.", german="[CN]Wenn du eine Bonusepisode spielen\n[CN]möchtest, speichere deinen Spielstand\n[CN]und kehre zum Hauptmenü zurück.", italian="[CN]Se vuoi giocare all'episodio speciale,\n[CN]salva i progressi della tua avventura\n[CN]e torna al menu principale.", spanish="[CN]Si quieres jugar al capítulo especial,\n[CN]guarda tu progreso y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Congratulations, Team [team:]!\n[CN]You graduated![W:240]", french="[CN]Félicitations, Equipe [team:]!\n[CN]Vous voilà avec le diplôme en poche![W:240]", german="[CN]Herzlichen Glückwunsch, Team [team:]!\n[CN]Ihr habt euren Abschluss![W:240]", italian="[CN]Congratulazioni, Team [team:]!\n[CN]Avete superato l'esame![W:240]", spanish="[CN]¡Felicidades, [CS:X]Equipo[CR] [team:]!\n[CN]¡Lo lograsteis![W:240]"})
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}; SV.SkyVars.CARRY_GOLD = ((SV.SkyVars.CARRY_GOLD) or 0) + 10000 -- $CARRY_GOLD += 10000 (ROM)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
