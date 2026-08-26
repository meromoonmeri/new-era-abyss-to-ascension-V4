-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us3102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 98) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 98]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.DownRight, "NPC_RINGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="If you want to evolve, maybe\nyou should head over to [CS:P]Luminous\nSpring[CR] again.", french="Si vous voulez évoluer, vous\ndevriez peut-être retourner\nà la [CS:P]Source Lumineuse[CR].", german="Wenn ihr euch entwickeln wollt,\nsolltet ihr euch vielleicht noch mal zur\n[CS:P]Glitzerquelle[CR] begeben.", italian="Se volete evolvervi, forse\ndovreste riprovare ad andare alla\n[CS:P]Sorgente Luccichio[CR].", spanish="Si quieres evolucionar, quizá\ndeberías volver al [CS:P]Manantial\nLuminoso[CR]."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You've got my thanks for saving\nthe world!", french="Je vous suis reconnaissant\nd'avoir sauvé le monde!", german="Dafür, dass ihr die Welt\ngerettet habt, gebührt euch mein Dank!", italian="Vi devo ringraziare per aver\nsalvato il mondo!", spanish="¡Tenéis mi agradecimiento por\nhaber salvado el mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
