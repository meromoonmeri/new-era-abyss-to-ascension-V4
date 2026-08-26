-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us2004.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 328, 176, Direction.UpRight, "NPC_AABOKKU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_aabokku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="We've been exploring\n[CS:P]Zero Isle[CR], but...", french="Nous avons exsssploré\nl'[CS:P]Ile Zéro[CR]...", german="Wir haben die [CS:P]Null-Insel[CR]\nerkundet, aber...", italian="Abbiamo esssplorato l'[CS:P]Isssola[CR]\n[CS:P]Zero[CR], ma...", spanish="Hemosss essstado explorando la\n[CS:P]Isla Cero[CR], pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="That ssssspot isssssn't for the\nfaint of heart.", french="Ce n'est pas un endroit pour\nles froussssards.", german="Diessser Ort ist nichtsss für\njemanden mit einem ssschwachen Herzen.", italian="Non è un posssto per chi\nsssoffre di cuore!", spanish=" No esss un lugar para débilesss."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_aabokku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" We've finally found it!", french=" Enfin, nous l'avons trouvée!", german="Wir haben sssie endlich\ngefunden!", italian=" Alla fine l'abbiamo trovata!", spanish=" ¡La encontramosss!"})
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]!", french=" L'[CS:P]Ile Zéro[CR]!", german=" Die [CS:P]Null-Insel[CR]!", italian=" L'[CS:P]Isssola Zero[CR]!", spanish=" ¡Esss la [CS:P]Isla Cero[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
