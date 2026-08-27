-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_H02P99A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="OK, [CS:N]Manaphy[CR].[K] For the time being,\nthis is your house.", french="Très bien, [CS:N]Manaphy[CR].[K]\nPour l'instant, c'est ici ta maison.", german="Okay, [CS:N]Manaphy[CR].[K] Fürs Erste\nist das dein Haus.", italian="Va bene, [CS:N]Manaphy[CR].[K] Per il\nmomento, questa è la tua casa.", spanish="Bueno, [CS:N]Manaphy[CR]...[K]\nPor el momento, este será tu hogar."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" House?", french=" Mééézon?", german=" Haus?", italian=" Casa?", spanish=" ¿Hogar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="That's right. House.[K] We're going\nto look after you, little cutie.", french="Oui. Maison. [K]Nous allons\nprendre soin de toi, petite tête.", german="Genau. Haus.[K] Wir werden auf\ndich aufpassen, süßer Fratz.", italian="Esatto. Casa.[K] Ci prenderemo\ncura di te, piccolino.", spanish="Sí, hogar.[K] Cuidaremos de ti,\npequeño."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" House, house! ♪", french=" Mééézon, mééézon! ♪", german=" Haus, Haus! ♪", italian=" Casa, casa! ♪", spanish=" ¡Hogar, hogar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="But, um...[K] What do you think we\nshould do now?", french="Mais, euh...[K] qu'est-ce qu'on doit\nfaire?", german="Aber, ähem...[K] Was sollen wir\ndenn jetzt machen?", italian="Ma, eh...[K] Adesso cosa\nfacciamo?", spanish="Pero...[K] ¿qué se supone que\ndebemos hacer?"}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Goomi! Goomi!", french=" Jélé! Jélé!", german=" Dummi! Dummi!", italian=" Gooma! Gooma!", spanish=" ¡Gumi! ¡Gumi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Oh, OK![K] You want a [CS:I]Blue Gummi[CR]!", french="Ah oui![K] Tu veux une [CS:I]Gelée\nBleue[CR]!", german="Oh, okay![K] Du willst ein\n[CS:I]Blaugummi[CR]!", italian=" Oh, già![K] Vuoi una [CS:I]Gommablu[CR]!", spanish=" ¡Claro![K] ¡Quieres una [CS:I]Gomi Azul[CR]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="He's got quite the appetite, our\ncute little [CS:N]Manaphy[CR]!", french="Il a de l'appétit, notre petit\n[CS:N]Manaphy[CR].", german="Es hat einen ganz schönen\nAppetit, unser süßes, kleines [CS:N]Manaphy[CR].", italian="Ha un bell'appetito, il nostro\npiccolo [CS:N]Manaphy[CR].", spanish="Tiene apetito, el pequeño\n[CS:N]Manaphy[CR]."}) -- SwitchTalk: branche default (canon générique)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" OK!", french=" Très bien!", german=" Okay!", italian=" Va bene!", spanish=" ¡Vale!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="Let's find another [CS:I]Blue Gummi[CR]\nfor [CS:N]Manaphy[CR], [hero].", french="Trouvons encore une\n[CS:I]Gelée Bleue[CR] pour [CS:N]Manaphy[CR], [hero].", german="Finden wir noch ein [CS:I]Blaugummi[CR]\nfür [CS:N]Manaphy[CR], [hero].", italian="Troviamo un'altra [CS:I]Gommablu[CR]\nper [CS:N]Manaphy[CR], [hero].", spanish="Encontremos otra [CS:I]Gomi Azul[CR]\npara [CS:N]Manaphy[CR], [hero]."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.cleanup_npcs()
end
