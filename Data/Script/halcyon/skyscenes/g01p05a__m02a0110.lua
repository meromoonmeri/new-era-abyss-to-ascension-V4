-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/m02a0110.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 232, Direction.UpLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster![K] I present to you\ntwo Pokémon who wish to join our guild as\napprentices.", french="Maître![K] Je vous présente\ndeux Pokémon qui souhaiteraient rejoindre\nla Guilde et faire partie des apprentis.", german="Gildenmeister![K] Ich bringe zwei\nPokémon, die Lehrlinge in unserer Gilde\nwerden möchten.", italian="Capitano![K] Le presento\ndue Pokémon che desiderano unirsi alla nostra\nGilda come apprendisti.", spanish="¡Gran Bluff![K] Te presento\na dos Pokémon que desean unirse\na nuestro [CS:N]Pokégremio[CR] como aprendices."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster...[K]um...[K]Guildmaster?", french="Maître...[K] Hum hum...[K]\nMaître?", german="Gildenmeister...[K] Äh...[K]\nGildenmeister?", italian=" Capitano...[K] ehm...[K] Capitano?", spanish="¿Gran Bluff?[K] Esto...[K]\n¿Maestro?"})
  -- message_Close
  GAME:WaitFrames(60)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du jour, bonjour!", german=" Hallöchen!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm [CS:N]Wigglytuff[CR]![K] I'm the guild's\nGuildmaster!", french="Je m'appelle [CS:N]Grodoudou[CR]![K]\nJe suis le Maître de la Guilde!", german="Ich bin [CS:N]Knuddeluff[CR]![K] Ich bin der\nMeister der Gilde!", italian="Mi chiamo [CS:N]Wigglytuff[CR]![K] Sono il\nCapitano della Gilda!", spanish="¡Soy [CS:N]Wigglytuff[CR]![K]\n¡Soy el Gran Bluff de este [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You want to form an exploration\nteam?[K] Then, let's go for it!", french="Vous voulez créer une équipe\nd'exploration?[K] Alors allons-y!", german="Ihr wollt ein Erkundungsteam\ngründen?[K] Na dann, auf geht's!", italian="Volete formare una squadra\nd'esplorazione?[K] Beh, allora cosa stiamo\naspettando?", spanish="¿Queréis formar un equipo\nexplorador?[K] ¡Pues adelante!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="First we must register your\nexploration team's name!", french="Nous devons tout d'abord\nenregistrer le nom de votre équipe\nd'exploration!", german="Als Erstes müssen wir den\nNamen eures Erkundungsteams registrieren!", italian="Come prima cosa, bisogna\nregistrare il nome della vostra squadra!", spanish="¡Lo primero es registrar\nel nombre de vuestro equipo!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So tell me your team's name?", french=" Quel est le nom de votre équipe?", german=" Der Name des Teams lautet?", italian=" Qual è il nome?", spanish="Así que... ¿cómo queréis que\nse llame vuestro equipo?"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? The team's name?", french=" Hum? Le nom de l'équipe?", german=" Häh? Der Name des Teams?", italian=" Eh? Il nome della squadra?", spanish=" Ah... ¿El nombre del equipo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh? Our team's name?", french=" Hum? Le nom de l'équipe?", german=" Oh! Der Name unseres Teams?", italian=" Eh? Il nome della squadra?", spanish=" Ah... ¿El nombre del equipo?"})
  else
  SkySceneKit.say({english=" Oh? Our team's name?", french=" Hum? Le nom de l'équipe?", german=" Oh! Der Name unseres Teams?", italian=" Eh? Il nome della squadra?", spanish=" Oh... ¿El nombre del equipo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I never thought of that.", french=" On n'y a pas réfléchi.", german="Daran habe ich noch gar nicht\ngedacht.", italian=" Non ci ho mai pensato.", spanish=" No me había parado a pensarlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We didn't think of that.", french=" On n'y a pas réfléchi.", german="Daran haben wir noch nicht\ngedacht.", italian=" Non ci abbiamo mai pensato.", spanish=" No habíamos pensado en ello."})
  else
  SkySceneKit.say({english=" I didn't think about a team name.", french=" On n'y a pas réfléchi.", german="Ich habe mir noch keinen Namen\nüberlegt.", italian=" Non ci ho mai pensato.", spanish=" No me había parado a pensarlo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, do you have any ideas for a\ncool name, [hero]?", french="Hé! Est-ce que tu as une idée?\nIl nous faut un nom qui sonne bien,\n[hero]!", german="Hey, fällt dir ein cooler Name\nein, [hero]?", italian="Ehi, tu hai qualche idea,\n[hero]?", spanish="Oye, ¿a ti se te ha ocurrido\nalgún nombre interesante, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So what do you think would be a\ngood name for us, [hero]?", french="Hé! Est-ce que tu as une idée?\nIl nous faut un nom qui sonne bien,\n[hero]!", german="Welchen Namen würdest du denn\ngut finden, [hero]?", italian="Ehi, tu hai qualche idea,\n[hero]?", spanish="¿A ti cuál te parece que sería\nun buen nombre, [hero]?"})
  else
  SkySceneKit.say({english="So what do you think would be a\ngood name for us, [hero]?", french="Hé! Est-ce que tu as une idée?\nIl nous faut un nom qui sonne bien,\n[hero]!", german="Welchen Namen würdest du denn\ngut finden, [hero]?", italian="Ehi, tu hai qualche idea,\n[hero]?", spanish="¿Tú cuál crees que sería\nun buen nombre para el equipo, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_TEAM_NAME)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[1] = 1 -- $PERFORMANCE_PROGRESS_LIST[1] = 1 (ROM)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[team:]?![K]\nTeam [team:]!", french="... [team:]?![K] L'Equipe\n[team:]!", german="...[team:]?!?[K]\nTeam [team:]!", italian="... [team:]?![K]\nTeam [team:]!", spanish="¡¿[CS:X]Equipo[CR] [team:]?![K]\n¡[CS:X]Equipo[CR] [team:]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[team:]?![K]\nTeam [team:]!", french="... [team:]?![K] L'Equipe\n[team:]!", german="...[team:]?!?[K]\nTeam [team:]!", italian="... [team:]?![K]\nTeam [team:]!", spanish="¡¿[CS:X]Equipo[CR] [team:]?![K]\n¡[CS:X]Equipo[CR] [team:]!"})
  else
  SkySceneKit.say({english="...[team:]?![K]\nTeam [team:]!", french="... [team:]?![K] L'Equipe\n[team:]!", german="...[team:]?!?[K]\nTeam [team:]!", italian="... [team:]?![K]\nTeam [team:]!", spanish="¡¿[CS:X]Equipo[CR] [team:]?![K]\n¡[CS:X]Equipo[CR] [team:]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah... That's a good name![K]\nI like it!", french="Ça me plaît bien... C'est un nom\nsuper![K] Il nous va bien!", german="Jep, der Name ist gut![K]\nEr gefällt mir!", italian="Sì... È un bel nome![K]\nMi piace!", spanish="Sí... ¡Es un buen nombre![K]\n¡Me gusta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yeah... That's a good name![K]\nIt suits us!", french="Ça me plaît bien... C'est un nom\nsuper![K] Il nous va bien!", german="Ja, das ist ein guter Name![K]\nEr passt zu uns!", italian="Sì... È un bel nome![K]\nMi piace!", spanish="Sí... ¡Es un buen nombre![K]\n¡Es apropiado para nosotros!"})
  else
  SkySceneKit.say({english="I like it! It's a good name![K]\nIt's perfect for us!", french="Ça me plaît bien... C'est un nom\nsuper![K] Il nous va bien!", german="Das gefällt mir! Ein guter\nName![K] Er passt perfekt zu uns!", italian="Sì... È un bel nome![K]\nMi piace!", spanish="Sí... ¡Es un buen nombre![K]\n¡Me encanta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="All settled, then![K] I'll register\nyour team as [team:].", french="C'est décidé![K] J'enregistre votre\néquipe sous le nom [team:].", german="Dann hätten wir das![K] Ich\nregistriere euer Team unter dem Namen\n[team:].", italian="Allora è tutto stabilito![K] Vi\nregistrerò come Team [team:].", spanish="¡Pues ya está decidido![K] Voy a\nregistrar vuestro equipo como [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Registering! ♪ Registering! ♪", french="Enregistrement! ♪\nEnregistrement! ♪", german=" Registriere! ♪ Registriere! ♪", italian="Registrazione! ♪\nRegistrazione! ♪", spanish="¡Registrando! ♪\n¡Registrando! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" All registered...", french=" Enregistrement terminé...", german=" Alles registriert...", italian=" Fatto...", spanish=" Ya está registrado..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAAAA!", german=" LUUUU... FIIII!", italian=" BADABUM!", spanish=" ¡Genial!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Congratulations![K] From now on,\nyou're an official exploration team!", french="Félicitations![K] Dorénavant,\nvous formez une équipe d'exploration\nen bonne et due forme!", german="Glückwunsch![K] Ab heute seid ihr\noffiziell ein Erkundungsteam!", italian="Congratulazioni![K] Ora siete\nufficialmente una squadra d'esplorazione!", spanish="¡Enhorabuena![K] Desde ahora,\nsois oficialmente un equipo explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I present you with this in\ncommemoration.", french="En gage de bienvenue, je vous\noffre ceci.", german="Zu diesem Anlass überreiche ich\neuch dies hier.", italian="In ricordo di questo evento,\nvi dono questo.", spanish="Aquí tenéis un regalito\npara celebrarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[2] = 1 -- $PERFORMANCE_PROGRESS_LIST[2] = 1 (ROM)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN][CS:N]Wigglytuff[CR] set down\n[CN]a Pokémon Exploration Team Kit!", french="[CN][CS:N]Grodoudou[CR] dépose\n[CN]un Kit d'Exploration!", german="[CN][CS:N]Knuddeluff[CR] überreicht\n[CN]ein Pokémon-Erkundungsteam-Kit!", italian="[CN][CS:N]Wigglytuff[CR] porge\n[CN]un Kit per esploratori!", spanish="[CN]¡[CS:N]Wigglytuff[CR] ofreció\n[CN]un Kit de Exploración Pokémon!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A Pokémon Exploration\nTeam Kit?", french=" Un Kit d'Exploration?", german=" Pokémon-Erkundungsteam-Kit?", italian=" Un Kit per esploratori Pokémon?", spanish="¿Un Kit de Exploración\nPokémon?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="A Pokémon Exploration\nTeam Kit?", french=" Un Kit d'Exploration?", german=" Pokémon-Erkundungsteam-Kit?", italian=" Un Kit per esploratori Pokémon?", spanish="¿Un Kit de Exploración\nPokémon?"})
  else
  SkySceneKit.say({english="A Pokémon Exploration\nTeam Kit?", french=" Un Kit d'Exploration?", german=" Pokémon-Erkundungsteam-Kit?", italian=" Un Kit per esploratori Pokémon?", spanish="¿Un Kit de Exploración\nPokémon?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yup. It's what every exploration\nteam needs.", french="Ouaip. N'importe quelle équipe\nd'exploration en a toujours besoin.", german="Jep. Jedes Erkundungsteam\nbraucht eines.", italian="Già. Ogni squadra d'esplorazione\ndeve averne uno.", spanish="Exacto. Contiene justo lo que\nnecesita un equipo explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Quick, open it up.", french=" Vite, ouvrez-le.", german=" Schnell, macht es auf!", italian=" Forza, apritelo!", spanish=" ¡Venga, abridlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6411) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P05A1_106) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN][partner] opened the\n[CN]Pokémon Exploration Team Kit.", french="[CN][partner] ouvre\n[CN]le Kit d'Exploration.", german="[CN][partner] öffnet\n[CN]das Pokémon-Erkundungsteam-Kit.", italian="[CN][partner] apre\n[CN]il Kit per esploratori Pokémon.", spanish="[CN][partner] abrió el\n[CN]Kit de Exploración Pokémon."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(10)
  -- back_SetGround(LEVEL_V02P08A) [neutre/état moteur]
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]There was an\n[CN]Explorer Badge inside...", french="[CN]A l'intérieur, il y a un\n[CN]Badge d'Explorateur...", german="[CN]Darin sind\n[CN]ein Erkunderorden,", italian="[CN]Contiene una\n[CN]Targhetta dell'esploratore...", spanish="[CN]Dentro hay una\n[CN]Placa de Explorador..."})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]And a Wonder Map...", french="[CN]... une Carte Miracle...", german="[CN]eine Wunderkarte", italian="[CN]... una Mappa delle meraviglie...", spanish="[CN]un Mapa Mágico..."})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]And a Treasure Bag!", french="[CN]... et un Sac à Trésor!", german="[CN]und ein Schatzbeutel!", italian="[CN]... e persino una Sacca dei tesori!", spanish="[CN]¡Y una Bolsa para guardar tesoros!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah! There's all sorts of good\nstuff in here!", french="Ouais! Il y a plein d'objets super\nlà-dedans!", german="Hey! Da sind lauter coole\nSachen drin!", italian="Wow! Ci sono un sacco di cose\nutili qui dentro!", spanish="¡Genial! ¡Hay cantidad de objetos\ndentro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yeah! There are all sorts of\ngreat items in here!", french="Ouais! Il y a plein d'objets super\nlà-dedans!", german="Hey! Da sind lauter tolle\nItems drin!", italian="Wow! Ci sono un sacco di cose\nutili qui dentro!", spanish="¡Qué bien! ¡Aquí dentro hay todo\ntipo de objetos!"})
  else
  SkySceneKit.say({english="Yes! There are all sorts of\ngreat items in here!", french="Ouais! Il y a plein d'objets super\nlà-dedans!", german="Ja! Da sind lauter tolle\nItems drin!", italian="Wow! Ci sono un sacco di cose\nutili qui dentro!", spanish="¡Vaya! ¡Mira qué objetos tan\ninteresantes hay dentro!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's your Explorer Badge! It's\nyour official team identification!", french="Voici votre Badge d'Explorateur!\nIl permet de vous identifier en tant qu'équipe\nd'exploration officielle!", german="Das ist euer Erkunderorden. Er\nist das offizielle Erkennungszeichen eures\nTeams.", italian="Questa è la vostra Targhetta\ndell'esploratore! È il documento di\nriconoscimento ufficiale della vostra squadra!", spanish="Esa es vuestra Placa de\nExplorador. Sirve como identificación\noficial de vuestro equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And there's the Wonder Map,\nwhich is a wonder of convenience!", french="Ceci est la Carte Miracle, qui\nest si pratique, si géniale! Cette carte,\nc'est un miracle, en somme!", german="Und diese Wunderkarte ist\neinfach wunderbar praktisch!", italian="E poi c'è la Mappa delle\nmeraviglie, un oggetto utilissimo!", spanish="Y eso es el Mapa Mágico.\n¡Os resultará bastante útil!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Finally, there's a Treasure Bag.[K]\nIt lets you carry items you find in dungeons.", french="Pour finir, voici votre Sac\nà Trésor.[K] Il vous permet de transporter\nles objets que vous trouvez dans les donjons.", german="Dann ist da noch der\nSchatzbeutel.[K] Darin bewahrt ihr auf, was ihr in\nDungeons findet.", italian="Infine, la Sacca dei tesori.[K]\nVi permette di trasportare gli strumenti che\ntrovate nei dungeon.", spanish="Por último está la Bolsa.[K]\nOs servirá para guardar los objetos que\nencontréis en vuestras exploraciones."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Your successes as an exploration\nteam can lead to bigger and bigger space for\nyour Treasure Bag.", french="Plus vous accomplirez d'exploits\nen tant qu'équipe d'exploration, plus votre Sac\nà Trésor pourra contenir d'objets.", german="Wenn ihr als Erkundungsteam\nErfolg habt, könnt ihr das Fassungsvermögen\neures Schatzbeutels vergrößern.", italian="In seguito ai vostri successi\ncome squadra d'esplorazione, lo spazio nella\nSacca aumenterà sempre di più.", spanish="Si conseguís muchos éxitos\ncomo exploradores, podréis llevar más\nobjetos en la Bolsa."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" It's a very wonderful bag! ♪", french=" C'est un sac exceptionnel! ♪", german="Es ist einfach ein wundervoller\nBeutel! ♪", italian=" È una sacca meravigliosa! ♪", spanish=" ¡Es una bolsa estupenda! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Have a peek inside your\nTreasure Bag.", french="Jetez un coup d'œil dans votre\nSac à Trésor.", german="Werft doch mal einen Blick in\neuren Schatzbeutel.", italian="Date un'occhiata all'interno della\nSacca dei tesori.", spanish="Echad un vistazo dentro de\nla Bolsa."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back_SetGround(LEVEL_G01P05A) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P05A1_106) [routine d'objet NDS non simulée - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN][partner] peered into\n[CN]the Treasure Bag.", french="[CN][partner] regarde dans\n[CN]le Sac à Trésor.", german="[CN][partner] wirft einen Blick in\n[CN]den Schatzbeutel.", italian="[CN][partner] guarda nella\n[CN]Sacca dei tesori.", spanish="[CN][partner] miró\n[CN]dentro de la Bolsa."})
  -- message_KeyWait
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_HERO_KIND"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND, 0, 0) [ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- item_Set(0, 40, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- item_Set(0, 41, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- item_Set(0, 23, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- item_Set(0, 23, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- item_Set(0, 37, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- item_Set(0, 37, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  -- item_Set(0, 40, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  -- item_Set(0, 41, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  -- item_Set(0, 26, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  -- item_Set(0, 40, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- item_Set(0, 26, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  -- item_Set(0, 41, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  -- item_Set(0, 26, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  -- item_Set(0, 23, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  -- item_Set(0, 40, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  -- item_Set(0, 40, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  -- item_Set(0, 41, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  -- item_Set(0, 26, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  -- item_Set(0, 41, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  -- item_Set(0, 37, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  -- item_Set(0, 37, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- @label_21 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]The [s_item:0]\n[CN]was inside!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Darin ist das Item\n[CN][s_item:0]!", italian="[CN]Al suo interno c'è lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Dentro había\n[CN]el objeto [s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_KeyWait
  do local __sw = ((SV.SkyVars or {}).CONFIG_COLOR_KIND or 0) -- switch($CONFIG_COLOR_KIND) [GameVar CONFIG_COLOR_KIND (SV.SkyVars)]
  if __sw == 1 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Brown Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Brun[CR]!", german="[CN]Es ist auch ein [CS:I]Braunband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccobruno[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Marrón[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 429, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Red Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Rouge[CR]!", german="[CN]Es ist auch ein [CS:I]Rotband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccorosso[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Granate[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 430, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Pink Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Rose[CR]!", german="[CN]Es ist auch ein [CS:I]Rosaband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccorosa[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Salmón[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 431, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]An [CS:I]Orange Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Orange[CR]!", german="[CN]Es ist auch ein [CS:I]Orangeband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccarancio[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Naranja[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 432, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Yellow Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Jaune[CR]!", german="[CN]Es ist auch ein [CS:I]Gelbband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccogiallo[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Ámbar[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 433, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Lime Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Citron[CR]!", german="[CN]Es ist auch ein [CS:I]Neonband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccolimone[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Lima[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 434, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Green Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Vert[CR]!", german="[CN]Es ist auch ein [CS:I]Grünband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccoverde[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Oliva[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 435, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Viridian Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Jade[CR]!", german="[CN]Es ist auch ein [CS:I]Smaragdband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccogiada[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Glauco[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 436, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Minty Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Menthe[CR]!", german="[CN]Es ist auch ein [CS:I]Türkisband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccomenta[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Jade[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 437, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Sky Blue Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Azur[CR]!", german="[CN]Es ist auch ein [CS:I]Hellblauband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccazzurro[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Celeste[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 438, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Blue Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Bleu[CR]!", german="[CN]Es ist auch ein [CS:I]Blauband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccoblu[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Añil[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 439, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Cobalt Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Cobalt[CR]!", german="[CN]Es ist auch ein [CS:I]Kobaltband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccobalto[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Cobalto[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 440, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Purple Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Mauve[CR]!", german="[CN]Es ist auch ein [CS:I]Lilaband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccoindaco[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Púrpura[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 441, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Violet Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Violet[CR]!", german="[CN]Es ist auch ein [CS:I]Violettband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccoviola[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Violeta[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 442, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Fuchsia Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Fuchsia[CR]!", german="[CN]Es ist auch ein [CS:I]Purpurband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccofucsia[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Fucsia[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 443, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]A [CS:I]Silver Bow[CR] was also inside!", french="[CN]Il y a aussi un [CS:I]Ruban Argent[CR]!", german="[CN]Es ist ein [CS:I]Silberband[CR] darin!", italian="[CN]Ma non solo! Dentro c'è anche\n[CN]un [CS:I]Fioccargento[CR]!", spanish="[CN]¡Dentro también hay un [CS:I]Lazo Plata[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 428, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  -- @label_38 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Those two items are special.", french="Ces deux objets sont très\nparticuliers.", german=" Das sind zwei besondere Items.", italian="Si tratta di due strumenti\nspeciali.", spanish=" Estos dos objetos son especiales."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm sure they will help you on\nyour adventures! ♪", french="Je suis sûr qu'ils vous seront\nutiles lors de vos aventures! ♪", german="Sie werden euch auf euren\nAbenteuern sicherlich von Nutzen sein! ♪", italian="Sono certo che vi aiuteranno\nnelle vostre avventure! ♪", spanish="¡Estoy seguro de que os\nresultarán útiles en vuestras aventuras! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-thank you![K] We'll do our best!", french="M-merci![K] Nous allons faire\nde notre mieux!", german="D-danke![K] Wir werden unser\nBestes geben!", italian="G-Grazie![K] Faremo del nostro\nmeglio!", spanish="¡Gracias![K]\n¡Nos esforzaremos todo lo que podamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-thank you![K] We'll do our best!", french="M-merci![K] Nous allons faire\nde notre mieux!", german="D-danke![K] Wir werden unser\nBestes geben!", italian="G-Grazie![K] Faremo del nostro\nmeglio!", spanish="¡Gracias![K]\n¡Intentaremos esforzarnos al máximo!"})
  else
  SkySceneKit.say({english=" Th-thank you![K] We'll do our best!", french="M-merci![K] Nous allons faire\nde notre mieux!", german="D-danke![K] Wir werden unser\nBestes geben!", italian="G-Grazie![K] Faremo del nostro\nmeglio!", spanish="¡Muchas gracias![K]\n¡Haremos todo lo que podamos!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yup.[K] But you're only apprenticing\nright now. So do your best...to train!", french="Ouaip.[K] Mais en attendant,\nvous n'êtes qu'en apprentissage. Alors faites\nde votre mieux... pour vous entraîner!", german="Jep.[K] Aber im Moment seid ihr\nnur Lehrlinge. Gebt euer Bestes und trainiert!", italian="Sì.[K] Ma per il momento siete\nsolo apprendisti. Quindi fate del vostro\nmeglio... in allenamento!", spanish="Sí.[K] Pero por ahora solo sois\naprendices. Así que esforzaos todo lo que\npodáis durante vuestro entrenamiento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We will!", french=" D'accord!", german=" Das werden wir!", italian=" Certo!", spanish=" ¡Lo haremos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We will!", french=" D'accord!", german=" Das werden wir!", italian=" Certo!", spanish=" ¡Así será!"})
  else
  SkySceneKit.say({english=" We will!", french=" D'accord!", german=" Das werden wir!", italian=" Certo!", spanish=" ¡Lo intentaremos!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do this right, [hero]!", french="Donnons le meilleur\nde nous-mêmes, [hero]!", german=" Wir schaffen das, [hero]!", italian="Mettiamocela\ntutta, [hero]!", spanish="¡Tenemos que hacer las cosas\nbien, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's always do our best,\n[hero]!", french="Donnons le meilleur\nde nous-mêmes, [hero]!", german="Lass uns immer unser Bestes\ngeben, [hero]!", italian="Mettiamocela\ntutta, [hero]!", spanish="¡Hay que esforzarse al máximo,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's always do our best,\n[hero]!", french="Donnons le meilleur\nde nous-mêmes, [hero]!", german="Lass uns immer unser Bestes\ngeben, [hero]!", italian="Mettiamocela\ntutta, [hero]!", spanish="¡Lo haremos siempre lo mejor\nque podamos, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
