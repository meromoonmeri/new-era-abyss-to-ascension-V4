-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um2405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 448, 240, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_a, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="I hear that [CS:N]Drowzee[CR] is at\nthe guild.", french="J'ai entendu dire que [CS:N]Soporifik[CR]\nétait à la Guilde.", german="Man sagt, [CS:N]Traumato[CR] sei in der\nGilde.", italian="Ho sentito che [CS:N]Drowzee[CR] è alla\nGilda.", spanish="He oído que [CS:N]Drowzee[CR] está\nen el [CS:N]Pokégremio[CR]."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_a, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="The rumor is that [CS:N]Drowzee[CR] has\nreformed and forsaken his criminal past.[K]\nBut I have to wonder...", french="Le bruit court que [CS:N]Soporifik[CR]\na renoncé à sa vie de hors-la-loi.[K] Mais\nje ne peux pas m'empêcher de m'en méfier...", german="Gerüchten zufolge hat [CS:N]Traumato[CR]\nseiner kriminellen Vergangenheit entsagt,[K] aber\nich frage mich...", italian="Dicono che [CS:N]Drowzee[CR] abbia messo\nla testa a posto e abbia rinnegato il suo\npassato da criminale.[K] Però...", spanish="Dicen que [CS:N]Drowzee[CR]\nse ha reformado y ya no es un criminal.[K]\nPero no sé qué pensar..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
