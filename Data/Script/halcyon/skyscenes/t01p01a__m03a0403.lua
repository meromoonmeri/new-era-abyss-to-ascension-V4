-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  SkySceneKit.say({english="(What was that?!)", french="(C'était quoi?!)", german="(Was war das?!?)", italian="(Cosa è stato?!)", spanish="(¡¿Qué ha sido eso?!)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="It would be nice if those cute\nlittle guys found their item soon.", french="Ce serait bien que ces deux\npetits gars retrouvent leur objet rapidement.", german="Es wäre schön, wenn diese\nputzigen Kleinen ihr Item bald finden würden.", italian="Spero che quei ragazzi riescano\na trovare presto il loro strumento.", spanish="A ver si esos chiquillos tan\nmonos encuentran pronto su objeto."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.say({english="Huh? Is anything the matter,\n[hero]?", french="Quoi? Qu'est-ce qu'il y a,\n[hero]?", german="Häh? Stimmt etwas nicht,\n[hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Te ocurre algo, [hero]?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Why are you looking so grim?", french="Pourquoi tu fais une tête\npareille?", german="Was siehst du denn so\nfinster drein?", italian=" Perché quella faccia scura?", spanish=" Te ha cambiado la cara."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="...Hmm?[K] You want to tell\nme something?", french="... Hein?[K] Tu veux me dire\nquelque chose?", german="...Hmm?[K] Was willst du mir\nsagen?", italian=" Eh?[K] Vuoi dirmi qualcosa?", spanish=" ¿Sí...?[K] ¿Quieres decirme algo?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  pcall(function() GAME:MoveCamera(520, 220, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 536, 220, Direction.Down)
  GROUND:TeleportTo(partner, 504, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(60)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.say({english="So you want to go rescue\n[CS:N]Azurill[CR] right away?", french="Tu veux qu'on aille sauver\n[CS:N]Azurill[CR] tout de suite?", german="Du willst dich also sofort auf\nden Weg machen, um [CS:N]Azurill[CR] zu retten?", italian="Quindi vuoi subito andare a\nsalvare [CS:N]Azurill[CR]?", spanish="¿Así que quieres ir a rescatar a\n[CS:N]Azurill[CR] inmediatamente?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" It's an...emergency?!", french=" C'est une... urgence?!", german=" Es ist ein Notfall?!?", italian=" È... un'emergenza?!", spanish=" ¿Es una... emergencia?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="They looked like they were\nhaving a good time, didn't they?", french="Ils avaient l'air de bien\ns'amuser.", german="Es sah doch so aus, als würden\nsie sich gut verstehen, oder?", italian="... sembrava che si stessero\ndivertendo, no?", spanish="Y parecían estar pasándoselo\nbien."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="Maybe that's why you just had\nthat bad daydream.", french="C'est peut-être pour ça que\ntu as eu cette hallucination.", german="Vielleicht hattest du deswegen\ndiesen schlimmen Tagtraum.", italian="Devi aver avuto un brutto sogno\na occhi aperti.", spanish="Tal vez por eso has tenido\nesa alucinación."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(But come to think of it...[K] That [CS:N]Drowzee[CR] didn't\nseem like a bad Pokémon.)", french="(Quand on y réfléchit...[K] ce [CS:N]Soporifik[CR] n'a\npas l'air d'être un méchant Pokémon.)", german="(Aber wenn ich darüber nachdenke...[K] Dieser\n[CS:N]Traumato[CR] kam mir wirklich nicht wie ein\nbösartiges Pokémon vor.)", italian="(Ma a pensarci...[K] quel [CS:N]Drowzee[CR] non\nsembrava un Pokémon cattivo.)", spanish="(Ahora que lo pienso...[K] Ese [CS:N]Drowzee[CR]\nno parecía un Pokémon malvado.)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="[CS:N]Bidoof[CR] should be waiting for us\non the guild's upper underground floor.", french="[CS:N]Keunotor[CR] a dit qu'il nous\nattendrait au premier sous-sol de la Guilde.", german="[CS:N]Bidiza[CR] dürfte in der Unteren\nGildenebene 1 auf uns warten.", italian="[CS:N]Bidoof[CR] ha detto che avrebbe\naspettato al Piano inferiore della Gilda 1.", spanish="[CS:N]Bidoof[CR] nos iba a esperar\nen la planta -1 del [CS:N]Pokégremio[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Let's go, [hero]!", french=" C'est parti, [hero]!", german=" Lass uns gehen, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
end
