-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 248, Direction.DownLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Let's have another fun\nday of exploring, hey, hey!", french="Eh dis donc! Encore une folle\njournée d'exploration devant nous!", german="Hey, hey! Auf einen weiteren\nspaßigen Erkundungstag, hey, hey!", italian="Ehi, ehi! Un'altra divertente\ngiornata d'esplorazione, ehi, ehi!", spanish="¡Oye, oye! ¡Divirtámonos\nexplorando un día más!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Don't let that [CS:N]Darkrai[CR]\nbeat you now, hey, hey!", french="Eh dis donc! Ne laissez pas\nl'ignoble [CS:N]Darkrai[CR] vous vaincre!", german="Hey, hey! Lass dich jetzt bloß\nnicht von diesem [CS:N]Darkrai[CR] schlagen, hey, hey!", italian="Ehi, ehi! Non permettete a quel\n[CS:N]Darkrai[CR] di battervi, ehi, ehi!", spanish="¡Oye, oye! ¡No permitáis que ese\n[CS:N]Darkrai[CR] os derrote!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
