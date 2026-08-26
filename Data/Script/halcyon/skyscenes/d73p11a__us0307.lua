-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us0307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 280, 264, Direction.Up, "NPC_KUCHIITO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="I'd love to go on an expedition\nwith everyone again sometime!", french="J'adorerais repartir en\nexploration avec toute l'équipe un jour!", german="Ich würde so gerne noch einmal\nmit allen auf eine Expedition gehen!", italian="Non vedo l'ora di partire per\nun'altra spedizione con qualcuno!", spanish="¡Sería genial que fuéramos\ntodos de expedición otra vez!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Haven't had a break in a while...", french="Ça fait un bout de temps qu'on\nn'a pas fait de pause...", german="Schon lange keine Pause mehr\ngehabt...", italian="È da un po' che non faccio\nuna sosta...", spanish="Hace tiempo que no\nme tomo un respiro..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="It's great to just relax and take\nyour time once in a while! Tee-hee-hee!", french="Prendre son temps et se\ndétendre, c'est si agréable! Youhouhou!", german="Es ist großartig, hin und wieder\neinfach nur zu entspannen und sich Zeit zu\nnehmen! Ji-chi-chi!", italian="Ogni tanto è così bello fare\nuna pausa e rilassarsi senza pensare\na nulla! Hi hi hi!", spanish="¡Con lo que mola relajarse\ny descansar de vez en cuando! ¡Ji, ji, ji!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
