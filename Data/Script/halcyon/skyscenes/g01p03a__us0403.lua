-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/us0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_taneboo = SkySceneKit.spawn_npc("seedot", 416, 296, Direction.Left, "NPC_TANEBOO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english=" You two are something else!", french="Vous deux alors,\nvous êtes vraiment extraordinaires!", german=" Ihr zwei seid schon welche!", italian=" Voi due siete di un altro livello!", spanish=" ¡Sois de lo que no hay!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_taneboo, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_taneboo) end)
  SkySceneKit.say({english="Tch! I blew it![K] I should've hit\nthem up for autographs!", french="Pff! J'ai raté ma chance![K]\nJ'aurais dû leur demander un autographe!", german="Tch! Ich hab es vermasselt![K] Ich\nhätte sie um ein Autogramm bitten sollen!", italian="Tsk! Ho sprecato un'occasione![K]\nAvrei dovuto chiedergli un autografo!", spanish="¡Vaya! ¡Qué pifia![K] ¡Tendría que\nhaberles pedido un autógrafo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
