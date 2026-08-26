-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m15a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english="This is tougher than I'd\nexpected. Let's go home and regroup.", french="Ce n'est pas une mince affaire.\nRentrons nous reposer.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="È più difficile di quel che\npensassimo. Andiamo a casa, per adesso.", spanish="¡Qué difícil ha resultado!\nVolvamos a casa a recuperar fuerzas."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM15') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 248, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone else is still out at\n[CS:P]Crystal Cave[CR].", french="Tous les autres sont encore à\nla [CS:P]Caverne Cristal[CR].", german="Alle anderen sind noch in der\n[CS:P]Kristallhöhle[CR].", italian="Sono tutti ancora alla [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR].", spanish="Todos los demás siguen en\nla [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They're doing their best to\nsearch the place.", french="Ils ratissent la caverne jusque\ndans ses moindres recoins.", german="Sie geben ihr Bestes, um den\nDurchgang zu finden.", italian=" Stanno cercando dappertutto.", spanish="Están haciendo lo posible para\nregistrar ese sitio de arriba a abajo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two should get moving and\njoin them.", french=" Vous devriez aller les rejoindre.", german="Ihr zwei solltet zurückgehen\nund ihnen helfen.", italian="Voi due dovreste andare laggiù a\ndare una mano.", spanish="Deberíais ir ahora mismo a\nayudarles."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" Off to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Si va alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 60)
  -- Destroy() [neutre/état moteur]
  GROUND:TeleportTo(hero, 356, 228, Direction.Down)
  GROUND:TeleportTo(partner, 332, 228, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
