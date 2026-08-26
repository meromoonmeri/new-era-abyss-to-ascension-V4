-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/us0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 432, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Good morning, you all!", french=" Chalut la compagnie!", german=" Guten Morgen, Leute!", italian=" Ehi voi due, buongiorno!", spanish=" ¡Buenos días a todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Here's to another good day of\nexploring!", french="Encore une bonne journée\nd'exploration en vue!", german="Auf einen weiteren erfolgreichen\nTag voller Erkundungen!", italian="Un altro bel giorno per\nesplorare!", spanish="Nos espera otro gran día de\nexploración... ¡Sí, señor!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm gonna be looking forward to\nyour team's safe return, [hero]!", french="J'espère que tu r'viendras en\nun seul morceau, [hero]!", german="Ich freue mich auf die sichere\nRückkehr eures Teams, [hero]!", italian="Spero che la tua squadra torni\nsana e salva, [hero]!", spanish="¡Estaré esperando vuestro\nregreso, [hero]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
