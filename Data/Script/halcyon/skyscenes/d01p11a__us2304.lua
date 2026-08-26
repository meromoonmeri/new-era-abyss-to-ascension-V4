-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/us2304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rozureido = SkySceneKit.spawn_npc("roserade", 312, 168, Direction.DownRight, "NPC_ROZUREIDO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rozureido, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rozureido) end)
  SkySceneKit.say({english="I haven't been here for a\nlong time.", french="Ça faisait longtemps que je\nn'étais pas venue ici.", german=" Ich bin noch nicht lange hier.", italian=" Non venivo qui da molto tempo.", spanish="Hacía mucho tiempo que no venía\npor aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_rozureido) end)
  SkySceneKit.say({english="I wonder... Is [CS:N]Wigglytuff[CR] as\nlively as ever?", french="Je me demandais... [CS:N]Grodoudou[CR]\nest-il toujours aussi enjoué qu'avant?", german="Ich frage mich, ob [CS:N]Knuddeluff[CR] so\nlebhaft wie immer ist?", italian="Mi chiedo... [CS:N]Wigglytuff[CR] sarà\nbrioso come al solito?", spanish="Me pregunto si... [CS:N]Wigglytuff[CR]\nseguirá tan animado como siempre..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
