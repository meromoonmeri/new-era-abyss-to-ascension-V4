-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/us3106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 160, 216, Direction.DownRight, "NPC_BARIYAADO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Sometimes Bottles with\nMessages in them wash up on the beach.", french="Parfois, des bouteilles contenant\nun message s'échouent sur le rivage.", german="Manchmal werden am Strand\nFlaschen mit Nachrichten angespült.", italian="A volte sulla spiaggia puoi\ntrovare delle bottiglie con dei messaggi\nall'interno.", spanish="A veces llegan a la playa frascos\ncon mensajes dentro."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" It's kind of romantic...", french=" Romantique, n'est-il pas...?", german=" Ach, wie romantisch...", italian=" È così romantico...", spanish=" Me parece muy romántico..."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It's become pretty busy in here\nnow that everyone's back.", french="L'ambiance est plutôt frénétique\nici, maintenant que tout le monde est de retour.", german="Jetzt, wo alle wieder da sind,\nist es wieder recht geschäftig geworden.", italian="Ora che sono tornati tutti, il\nlocale è sempre stracolmo.", spanish="Hay mucho ambientillo por aquí,\nahora que ha vuelto todo el mundo."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
