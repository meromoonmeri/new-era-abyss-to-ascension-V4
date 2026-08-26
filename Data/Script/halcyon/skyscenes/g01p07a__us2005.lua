-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/us2005.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 144, 208, Direction.Right, "NPC_KOIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_koiru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! [CS:N]Drowzee[CR] should be in\nseclusion on [CS:P]Mt. Travail[CR]. Zzzt!", french="ZZZT! [CS:N]Soporifik[CR] vit\nprobablement en ermite sur le [CS:P]Mt Labeur[CR].\nZZZT!", german="Zzzt! [CS:N]Traumato[CR] sollte in der\nAbgeschiedenheit des [CS:P]Mühsalbergs[CR] zu finden\nsein. Zzzt!", italian="ZZZT! [CS:N]Drowzee[CR] dovrebbe essere\nsul [CS:P]Monte Odissea[CR]. ZZZT!", spanish="¡Bzz! [CS:N]Drowzee[CR] debería estar\nen el [CS:P]Monte Tribulaciones[CR]. ¡Bzz!"})
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
