-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P23A/us3108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 152, 264, Direction.Right, "NPC_HERAKUROSU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whooooa!\nI'm ready to explore the whoooole world\nwith [CS:N]Zigzagoon[CR]!", french="Youhou!\nJe me sens prêt à explorer le monnnnde entier\navec [CS:N]Zigzaton[CR]!", german="Wooow!\nIch bin bereit, zusammen mit [CS:N]Zigzachs[CR]\ndie gaaaanze Welt zu erkunden!", italian="Uaaah!\nOra che [CS:N]Zigzagoon[CR] è con me, sono pronto\nad esplorare il mondo inteeero!", spanish="¡Bieeeen!\n¡Ya puedo explorar el mundo entero\ncon [CS:N]Zigzagoon[CR]!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whooooa!\nFinally back!!", french="Youhou!\nDe retour, enfin!!", german="Woooow!\nEndlich zurück!!!", italian="Uoooh!\nFinalmente a casa!!!", spanish="¡Bieeen!\n¡Al fin de vuelta!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
