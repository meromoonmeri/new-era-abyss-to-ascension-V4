-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s03p2002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_AT_THE_END_OF_THE_DAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Several days later...", french="[CN]Quelques jours plus tard...", german="[CN]Ein paar Tage später...", italian="[CN]Alcuni giorni dopo...", spanish="[CN]Unos días más tarde..."})
  -- message_Close
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 344, 184, Direction.Right, "NPC_MANAFI")
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(48), p.Y+(0), false, 2) end
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  SkySceneKit.say({english="Ha! The little cutie's as good\nas ever!", french="Ha! Le petit est de nouveau sur\npied!", german="Ha! Das süße Kleine ist munter\nwie eh und je!", italian="Ah! Il cucciolo è completamente\nguarito!", spanish=" ¡Ya se ha recuperado!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Good! Ever!", french=" Petit! Sur pied!", german=" Munter! Wie eh und je!", italian=" Guarito! Completamente!", spanish=" ¡Bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" Am I glad to see this!", french=" Comme je suis contente!", german=" Ich freue mich so, das zu sehen!", italian=" Come sono sollevata!", spanish=" ¡Cuánto me alegro!"}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 312, 152, Direction.DownRight, "NPC_PERAPPU")
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[hero]...[partner].", french=" ... [hero], [partner]...", german=" ...[hero] ...[partner].", italian=" [hero]... [partner].", spanish=" [hero]... [partner]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(45)
  SkySceneKit.say({english="[CS:N]Manaphy[CR] needs to develop the\nability to survive in the sea...", french="[CS:N]Manaphy[CR] a besoin de\ndévelopper ses capacités de survie en mer...", german="[CS:N]Manaphy[CR] muss die Fähigkeit\nentwickeln, im Meer zu leben.", italian="[CS:N]Manaphy[CR] deve sviluppare\nl'abilità di sopravvivere in mare...", spanish="[CS:N]Manaphy[CR] tiene que aprender\na vivir en el mar..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" Let's take [CS:N]Manaphy[CR] to the sea.", french=" Ramenons [CS:N]Manaphy[CR] à la mer.", german="Lass uns [CS:N]Manaphy[CR] zum Meer\nbringen.", italian=" Dai, portiamo [CS:N]Manaphy[CR] in mare.", spanish=" Llevemos a [CS:N]Manaphy[CR] al mar."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
