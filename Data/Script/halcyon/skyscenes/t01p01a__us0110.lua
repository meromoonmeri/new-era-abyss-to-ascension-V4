-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0110.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 376, 144, Direction.Left, "NPC_RURIRI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ruriri, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Mr. [CS:N]Drowzee[CR] told me to tell you,\n\"Take care and thanks,\" [hero] and\n[partner].", french="Monsieur [CS:N]Soporifik[CR] m'a dit\nde vous dire: \"Faites attention à vous et\nmerci, [hero] et [partner].\"", german="Herr [CS:N]Traumato[CR] bat mich, euch\nseinen Dank auszurichten, und ihr sollt auf euch\naufpassen, [hero] und [partner].", italian="Il signor [CS:N]Drowzee[CR] mi ha detto\ndi dirvi: \"In gamba e grazie\", [hero] e\n[partner].", spanish="El señor [CS:N]Drowzee[CR] me pidió que\nos diera las gracias y que os deseara\nlo mejor de su parte."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ruriri, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Thank you, [hero] and\n[partner]!", french="Merci, [hero]\net [partner]!", german="Danke, [hero] und\n[partner]!", italian="Grazie, [hero] e\n[partner]!", spanish="¡Gracias, [hero] y\n[partner]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
