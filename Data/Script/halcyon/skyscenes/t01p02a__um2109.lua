-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um2109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 352, 240, Direction.DownRight, "NPC_SANDOPAN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="We're not likely to come here\nagain.", french="Il y a peu de chances qu'on\nrevienne ici un jour.", german="Aller Wahrscheinlichkeit nach\nwerden wir nicht noch einmal hierherkommen.", italian="Probabilmente non torneremo\npiù qui.", spanish=" No creo que volvamos por aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" Take care.", french="N'oubliez pas, il faut toujours\nrester prudent!", german=" Passt auf euch auf.", italian=" State in gamba.", spanish=" Cuidaos."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sandopan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="If there's anything we can do to\nhelp, we would, but...", french="Si on pouvait faire quoi que\nce soit pour vous aider, on le ferait, mais...", german="Aber falls wir irgendwie helfen\nkönnen, würden wir das tun...", italian="Se possiamo fare qualcosa per\naiutarvi, fatecelo sapere, ma...", spanish="Si hubiera algo que pudiéramos\nhacer para ayudar lo haríamos, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" That little baby sure was cute.", french=" Ce bébé est tellement mignon.", german="Das Kleine war auf jeden Fall\nsüß.", italian="Quel cucciolo era davvero\ncarino.", spanish=" Aquel pequeñuelo era muy mono."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
