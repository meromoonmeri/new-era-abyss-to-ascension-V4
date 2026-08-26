-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/m20a0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  -- GAP: BGM BGM_FIRE_CRACKLING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 544, 232, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But [hero]...", french=" Mais, [hero]...", german=" Aber [hero]...", italian=" Ma, [hero]...", spanish=" Vaya, [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I never expected you to be\nthat very same [hero]...", french="Jamais je n'aurais imaginé que\ntu étais vraiment [hero]...", german="Ich habe niemals erwartet, dass\ndu wirklich [hero] bist...", italian="Non mi aspettavo che fossi\ndavvero [hero]...", spanish="Nunca me habría imaginado que\ntú fueras [hero], precisamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="[CS:N]Grovyle[CR], can you tell us more\nabout that?", french="[CS:N]Massko[CR], est-ce que tu peux\nnous en dire plus à ce sujet?", german="[CS:N]Reptain[CR], kannst du uns mehr\ndarüber erzählen?", italian="[CS:N]Grovyle[CR], perché non ci racconti\ndi più?", spanish=" [CS:N]Grovyle[CR], sigue contándonos..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yes, [hero] and I...", french=" Oui, [hero] et moi...", german=" Ja, [hero] und ich...", italian=" Sì, [hero] ed io...", spanish="De acuerdo. El caso es que\n[hero] y yo..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We were jointly investigating\nthe planet's paralysis.", french="On enquêtait tous les deux\nsur la Paralysie de la Planète.", german="Wir haben zusammen die\nLähmung des Planeten untersucht.", italian="Beh, noi indagavamo\ninsieme sulla paralisi del pianeta.", spanish="Estábamos investigando juntos\nla parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="A Pokémon and a human...[K]\npaired together?", french="Un Pokémon et un être\nhumain...[K] associés?", german="Ein Pokémon und ein Mensch...[K]\nZusammen als Team?", italian="Un Pokémon e un\nessere umano...[K] in coppia?", spanish="Eso sí que es increíble...[K]\nHumanos y Pokémon trabajando juntos\npara evitar la parálisis del planeta."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yeah.", french=" Ouais.", german=" Ja doch.", italian=" Sì.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And [hero] had...or has...\na special ability like no other.", french="Et [hero] avait... ou a...\nun pouvoir spécial à nul autre pareil.", german="Und [hero] hatte, oder\nhat, eine spezielle Fähigkeit, die niemand\nsonst besitzt.", italian="E [hero] aveva... oppure\nha... un'abilità unica.", spanish="Y [hero] tenía, o tiene,\nuna habilidad especial, ciertamente única."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We relied on that special ability\nto investigate the planet's paralysis.", french="Et on s'est servis de ce pouvoir\npour enquêter sur la Paralysie de la Planète.", german="Wir haben uns auf diese\nFähigkeit verlassen, um die Lähmung\ndes Planeten zu untersuchen.", italian="Facevamo affidamento su questa\nabilità per scoprire qualcosa sulle cause della\nparalisi del pianeta.", spanish="Empleamos esa habilidad especial\npara investigar la parálisis del planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It played a vital part.", french=" Cela a joué un rôle crucial.", german=" Sie spielte eine wichtige Rolle.", italian="Ha giocato una parte\nfondamentale.", spanish=" Desempeñó un papel esencial."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="By special ability...[K]you mean the\nDimensional Scream, don't you?", french="Quand tu dis pouvoir spécial...[K]\ntu parles du Cri Dimensionnel, pas vrai?", german="Wenn du von einer\nbesonderen Fähigkeit sprichst...[K] Meinst du\ndamit etwa den Dimensionalen Schrei?", italian="Quando dici abilità...[K] intendi lo\nSquarcio Dimensionale, vero?", spanish="Supongo que te refieres...[K]\na la Percepción de Cronos, ¿verdad?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Exactly.", french=" Exact.", german=" Exakt.", italian=" Esattamente.", spanish=" Exacto."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But the Dimensional Scream has\na drawback.", french="Mais le Cri Dimensionnel a\nun inconvénient.", german="Aber der Dimensionale Schrei hat\neinen Nachteil.", italian="Tuttavia, usufruire di questa\nabilità non è così semplice.", spanish="Pero la Percepción de Cronos\ntiene un inconveniente."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Dimensional Scream requires\nthe presence of a trusted Pokémon partner.", french="Il requiert la présence d'un ou\nd'une partenaire Pokémon en qui avoir\ntoute confiance.", german="Der Dimensionale Schrei\nverlangt die Anwesenheit eines Partners,\ndem man vertraut.", italian="Lo Squarcio Dimensionale\nrichiede la presenza di un fidato compagno\nPokémon.", spanish="Solo funciona si está presente\nun compañero Pokémon en el que confíes."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Without that partner, the ability\ncannot be triggered.", french="Sans ce Pokémon, le pouvoir\nne marche pas.", german="Ohne diesen Partner kann diese\nFähigkeit nicht ausgelöst werden.", italian="Senza un compagno, questa\nabilità non può essere utilizzata.", spanish="Su presencia es indispensable\npara poder activar la habilidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" A trusted...[K]partner...", french="Un partenaire...[K] en qui\navoir toute confiance...", german="Ein Partner,[K]\ndem man vertraut.", italian=" Un fidato...[K] compagno...", spanish="Un compañero...[K] en el que\nconfíes..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's why we worked together.", french="C'est pour ça qu'on s'est\nassociés.", german=" Darum arbeiteten wir zusammen.", italian="È per questo che lavoravamo\nassieme.", spanish=" Por eso trabajamos juntos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Dimensional Scream is set\noff by triggers tied to places where the Time\nGears are hidden.", french="Le Cri Dimensionnel est\ndéclenché par des dispositifs situés aux\nemplacements des Rouages du Temps.", german="Der Dimensionale Schrei wird\ndurch Dinge ausgelöst, die eine Verbindung zu\nden Verstecken der Zahnräder der Zeit haben.", italian="Lo Squarcio Dimensionale si\nverifica in prossimità dei luoghi in cui sono\nnascosti gli Ingranaggi del Tempo.", spanish="La Percepción de Cronos se\nactiva con objetos relacionados con el lugar\ndonde se ubican los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We needed to find out where the\nTime Gears were in the past.", french="Il fallait qu'on sache où trouver\nles Rouages du Temps dans le passé.", german="Wir mussten herausfinden, wo\nsich die Zahnräder der Zeit in der\nVergangenheit befanden.", italian="Dovevamo scoprire dov'erano\ngli Ingranaggi del Tempo nel passato.", spanish="Necesitábamos saber dónde\nestaban los Engranajes del Tiempo en\nel pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We needed the Dimensional\nScream to accomplish that.", french="Et pour ce faire, on avait besoin\ndu Cri Dimensionnel.", german="Das konnten wir nur mithilfe des\nDimensionalen Schreis.", italian="Per scoprirlo avevamo bisogno\ndello Squarcio Dimensionale.", spanish="Y la Percepción de Cronos era\nimprescindible para ello."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.say({english="But the Dimensional Scream was\nbeing triggered not long after we met!", french="Mais il s'est déclenché très\npeu de temps après notre rencontre!", german="Aber der Dimensionale Schrei\nkam schon, als wir uns erst seit Kurzem\nkannten!", italian="Ma lo Squarcio Dimensionale si\nè verificato poco dopo il nostro incontro!", spanish="Pero empezó al poco de que\n[hero] y yo nos conociéramos."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Your point?", french=" Où est-ce que tu veux en venir?", german=" Ja. Und?", italian=" E quindi?", spanish=" ¿Y qué?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Doesn't that show you how much\nyou two trusted each other from the start?", french="Ça prouve à quel point vous\nvous êtes fait confiance dès le départ, non?", german="Zeigt das denn nicht, wie groß\ndas Vertrauen zwischen euch von Anfang an\nwar?", italian="Ciò dimostra che fra voi due\nsi è creato un rapporto di fiducia fin\ndall'inizio.", spanish="¿No es evidente que hubo\nuna gran confianza desde el principio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Urk![K] When you put it like that...", french=" Ah![K] Dit comme ça...", german="Umpf![K] Wenn du es so\nausdrückst...", italian=" Oh![K] Se la metti così...", spanish=" ¡Vaya![K] Dicho así..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.say({english=" I mean...it's a bit embarrassing.", french="C'est... c'est un peu\nembarrassant.", german="Ich meine... Das macht mich ein\nbisschen verlegen.", italian="Voglio dire... È un po'\nimbarazzante.", spanish=" Me da un poco de vergüenza."}) -- SwitchTalk: branche default (canon générique)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="In addition, [hero]\ndeveloped amnesia...", french="En plus, [hero] souffre\nd'amnésie...", german="Dazu hat [hero]\nnoch einen Gedächtnisverlust erlitten...", italian="In più, [hero] ha perso la\nmemoria...", spanish="Además, [hero] sufrió\namnesia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Upon meeting you, [partner],\nyour partner had someone to turn to.", french="[hero] a donc trouvé\nquelqu'un vers qui se tourner\nlors de votre rencontre, [partner].", german="Du, [partner], warst von\nAnfang an für deinen Partner da.", italian="Conoscendoti, [partner],\nha avuto qualcuno su cui fare affidamento.", spanish="Al conocerte, [partner],\nencontró a alguien digno de confianza."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Perhaps [hero] grew to\ntrust you very quickly because of that.", french="Peut-être que c'est à cause de\nça que [hero] t'a tout de suite accordé\nsa confiance.", german="Vielleicht wuchs das Vertrauen\nvon [hero] in dich deshalb so schnell.", italian="Forse [hero] ha acquisito\nfiducia in te molto velocemente per questo\nmotivo.", spanish="Sin duda, [hero] se dio\ncuenta muy pronto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Does the Dimensional Scream go\noff in response to only Time Gears?", french="Le déclenchement du Cri\nDimensionnel est lié uniquement aux Rouages\ndu Temps?", german="Wird der Dimensionale Schrei\nnur in Verbindung mit den Zahnrädern der Zeit\nausgelöst?", italian="Lo Squarcio Dimensionale è\nsempre causato dagli Ingranaggi del\nTempo?", spanish="¿Dices que la Percepción\nde Cronos solo aparece en relación\ncon los Engranajes del Tiempo?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Right.[K] The opposite is also true.\nThe Dimensional Scream is not triggered in\nplaces that aren't connected to Time Gears.", french="En effet.[K] L'inverse est aussi\nvrai: le Cri Dimensionnel ne marche pas dans\nun lieu sans lien avec un Rouage du Temps.", german="Richtig.[K] Dementsprechend wird\nder Dimensionale Schrei nicht an Orten ohne\nVerbindung zu Zahnrädern der Zeit ausgelöst.", italian="È così.[K] Di conseguenza, lo\nSquarcio Dimensionale non si verifica in posti\nnon connessi con gli Ingranaggi del Tempo.", spanish="Así es.[K] No se activa en ningún\notro lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" That's not how I remember it...", french="Je ne me rappelle pas que\nça se soit passé comme ça...", german="So habe ich das nicht in\nErinnerung.", italian="Non mi sembra sia andata\nproprio così...", spanish=" Pues eso no me encaja..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  SkySceneKit.say({english="But even in places like that,\nthe Dimensional Scream went off sometimes,\ndidn't it?", french="Mais même dans ces\nendroits-là, le Cri Dimensionnel s'est\ndéclenché, non?", german="Aber auch an solchen Orten ging\nder Dimensionale Schrei manchmal los, oder?", italian="Ma lo Squarcio Dimensionale\nqualche volta si è verificato anche in quei\nposti, vero?", spanish="Y aun así, la Percepción de\nCronos se activó, ¿verdad?"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Are you sure?[K] But that never\nhappened in the future.", french="C'est vrai?[K] Ça n'est jamais\narrivé dans le futur.", german="Bist du sicher?[K] Aber das ist\nniemals in der Zukunft geschehen.", italian="Davvero?[K] Nel futuro non è\nmai successo.", spanish="¿Seguro?[K] En el futuro eso no\nocurrió nunca."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Dimensional Scream was\nnever triggered by places that had no tie to\nTime Gears whatsoever.", french="Jamais le Cri Dimensionnel ne\ns'est déclenché dans des endroits sans lien\navec les Rouages du Temps.", german="Der Dimensionale Schrei wurde\nsicher niemals an Orten ausgelöst, die nicht in\nVerbindung zu den Zahnrädern der Zeit stehen.", italian="Lo Squarcio Dimensionale non si\nè mai verificato in posti che non avevano\nalcun legame con gli Ingranaggi del Tempo.", spanish="Nunca se activó en lugares que\nno tenían relación con los engranajes."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...[K]Well, if that's true, I don't\nknow why it would work differently here.", french="...[K] Eh bien, si c'est vrai,\nje ne vois pas pourquoi ce ne serait pas le cas\nici aussi.", german="...[K]Nun, wenn das stimmt, kann\nich mir nicht erklären, warum er hier anders\nfunktionieren sollte.", italian="...[K] Beh, se è così, non so\nperché qui funzioni in un altro modo.", spanish="No...[K] No entiendo por qué iba a\nser distinto aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Perhaps things are just different\nin this world.", french="Peut-être que les choses sont\ntout simplement différentes dans ce monde.", german="Vielleicht sind die Dinge in dieser\nWelt einfach anders.", italian="Forse è solo che le cose in\nquesto tempo sono differenti.", spanish="Bueno, tal vez las cosas sean\ndiferentes en este mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Perhaps the nature of the\nDimensional Scream is altered in the past.", french="Peut-être que la nature du Cri\nDimensionnel a été modifiée dans le passé.", german="Vielleicht funktioniert der\nDimensionale Schrei in der Vergangenheit\neinfach anders.", italian="Forse la natura dello Squarcio\nDimensionale nel passato è alterata.", spanish="Tal vez la naturaleza de la\nPercepción de Cronos se altera en el pasado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="(when we were in the future...)", french="(... quand on était dans le futur...)", german="(Als wir in der Zukunft waren...)", italian="(Quando eravamo nel futuro...)", spanish="(Cuando estábamos en el futuro...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
