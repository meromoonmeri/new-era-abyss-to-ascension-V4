-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/us0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 98) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 98]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_ringuma2 = SkySceneKit.spawn_npc("ursaring", 328, 264, Direction.UpLeft, "NPC_RINGUMA2")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 304, 240, Direction.DownRight, "NPC_RINGUMA")
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="There's something different\nabout [CS:P]Luminous Spring[CR].", french="Quelque chose a changé\nà la [CS:P]Source Lumineuse[CR].", german="Die [CS:P]Glitzerquelle[CR] hat sich\nirgendwie verändert.", italian="C'è qualcosa di diverso alla\n[CS:P]Sorgente Luccichio[CR].", spanish="El [CS:P]Manantial Luminoso[CR]\nparece diferente..."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="It still looks the same...[K]\nBut I know it's not just my imagination.", french="Tout semble pareil...[K]\nPourtant je suis sûre que quelque chose\na changé.", german="Sie sieht zwar noch gleich aus...[K]\nAber ich weiß, ich bilde mir da nichts ein.", italian="Apparentemente sembra che non\nsia cambiato nulla...[K] ma il mio istinto mi dice\nche non è così.", spanish="Aparentemente está igual...[K]\nPero sé que no me lo estoy imaginando."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ringuma2, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci de tout cœur!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchísimas gracias!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Your team is so cool!", french="Votre équipe est vraiment\nmagnifique!", german=" Euer Team ist so cool!", italian="La vostra squadra è davvero\nfantastica!", spanish=" ¡Vuestro equipo es genial!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
